"""
ERA5 → CROCO atmospheric forcing file (croco_frc_era5.nc)

Reads the monthly ERA5 zip archives downloaded by download_era5.py,
processes accumulated variables into rates, interpolates to the CROCO
rho grid, and writes a CROCO-compatible NetCDF bulk forcing file.

Memory-efficient: processes one month at a time instead of loading all data.

CROCO variables produced (for BULK_FLUX CPP option):
  Uwind, Vwind   — 10 m wind components (m/s)
  Tair           — 2 m air temperature (Celsius)
  Qair           — specific humidity (kg/kg)
  Pair           — mean sea-level pressure (mb)
  rain           — precipitation rate (kg/m²/s = mm/s)
  swrad          — surface net downward SW radiation (W/m²)
  lwrad_down     — surface downward LW radiation (W/m²)

Time dimension names follow croco_tools convention:
  wind_time, tair_time, qair_time, pair_time, rain_time, srf_time, lrf_time

Usage:
    python make_frc_era5.py
    (edit CONFIG section below)
"""

import numpy as np
import xarray as xr
import netCDF4 as nc4
import pandas as pd
import zipfile
import tempfile
import os
from pathlib import Path
from scipy.interpolate import RegularGridInterpolator

# =============================================================================
# CONFIG
# =============================================================================
ERA5_DIR  = "/mnt/d/ProyectoMsc_CROCO/01_inputs/forcing/era5_raw"
GRD_FILE  = "/mnt/d/ProyectoMsc_CROCO/01_inputs/croco_files/croco_grd.nc"
OUT_FILE  = "/mnt/d/ProyectoMsc_CROCO/01_inputs/croco_files/croco_frc_era5.nc"
# Reference time for CROCO (days since YORIG)
YORIG     = 2000
MORIG     = 1
DORIG     = 1
# =============================================================================

# Map variable → (time dim name, units, long_name)
VAR_META = {
    "Uwind":      ("wind_time", "m/s",     "u-wind component at 10m"),
    "Vwind":      ("wind_time", "m/s",     "v-wind component at 10m"),
    "Tair":       ("tair_time", "Celsius", "air temperature at 2m"),
    "Qair":       ("qair_time", "kg/kg",   "specific humidity at 2m"),
    "Pair":       ("pair_time", "mb",      "mean sea-level pressure"),
    "rain":       ("rain_time", "kg/m2/s", "precipitation rate"),
    "swrad":      ("srf_time",  "W/m2",   "surface net downward SW radiation"),
    "lwrad_down": ("lrf_time",  "W/m2",   "surface downward LW radiation"),
}


def deaccumulate(arr, time_unix):
    """
    Convert ERA5 accumulated variable to per-second rates.

    ERA5 reanalysis accumulations reset at each hourly step (the "valid_time"
    series from CDS API v2 is already de-accumulated per timestep, i.e., each
    value represents the accumulation over that single step).
    If values reset (next < current), treat them as independent.

    Parameters
    ----------
    arr      : np.ndarray (nt, ny, nx)
    time_unix: np.ndarray (nt,) seconds since 1970-01-01

    Returns
    -------
    rate     : np.ndarray (nt, ny, nx) — values / dt_seconds
    """
    dt = np.diff(time_unix, prepend=time_unix[0] - (time_unix[1] - time_unix[0]))
    dt = np.where(dt <= 0, time_unix[1] - time_unix[0], dt)

    mean_arr = arr.reshape(arr.shape[0], -1).mean(axis=1)
    diffs = np.diff(mean_arr, prepend=0)

    rate = np.empty_like(arr)
    for t in range(len(time_unix)):
        if t == 0 or diffs[t] < 0:
            rate[t] = arr[t] / dt[t]
        else:
            rate[t] = (arr[t] - arr[t - 1]) / dt[t]

    return rate


def q_from_dewpoint(td_k, msl_pa):
    """
    Compute specific humidity (kg/kg) from dew point temperature (K)
    and surface pressure (Pa).
    Uses Tetens formula for saturation vapor pressure.
    """
    td_c = td_k - 273.15
    e_sat = 611.2 * np.exp(17.67 * td_c / (td_c + 243.5))
    q = 0.622 * e_sat / (msl_pa - 0.378 * e_sat)
    return np.clip(q, 0, None)


def interp_to_croco(data, src_lon, src_lat, dst_lon, dst_lat):
    """
    Horizontally interpolate ERA5 field to CROCO grid using bilinear interp.

    Parameters
    ----------
    data   : np.ndarray (nt, ny_src, nx_src)
    src_lon: 1D array (nx_src,) — must be monotonically increasing
    src_lat: 1D array (ny_src,) — can be decreasing (North→South)
    dst_lon: 2D array (ny_dst, nx_dst)
    dst_lat: 2D array (ny_dst, nx_dst)

    Returns
    -------
    out    : np.ndarray (nt, ny_dst, nx_dst)
    """
    nt = data.shape[0]
    ny_dst, nx_dst = dst_lon.shape
    out = np.empty((nt, ny_dst, nx_dst), dtype=np.float32)

    lat_asc = np.asarray(src_lat)
    flip = lat_asc[0] > lat_asc[-1]
    if flip:
        lat_asc = lat_asc[::-1]
        data_arr = data[:, ::-1, :]
    else:
        data_arr = data

    pts = np.column_stack([dst_lat.ravel(), dst_lon.ravel()])

    for t in range(nt):
        itp = RegularGridInterpolator(
            (lat_asc, np.asarray(src_lon)),
            data_arr[t].astype(float),
            method="linear",
            bounds_error=False,
            fill_value=None,
        )
        out[t] = itp(pts).reshape(ny_dst, nx_dst)
    return out


def croco_time(time_unix, yorig=2000, morig=1, dorig=1):
    """Convert Unix timestamps (s since 1970) to days since YORIG/MORIG/DORIG."""
    ref = pd.Timestamp(f"{yorig:04d}-{morig:02d}-{dorig:02d}")
    t_pd = pd.to_datetime(time_unix.astype("int64"), unit="s")
    days = (t_pd - ref).total_seconds() / 86400.0
    return days.values


def scan_zip_timestamps(zip_path):
    """Extract only the time coordinate from a zip (no data arrays loaded)."""
    with zipfile.ZipFile(zip_path) as z:
        names = z.namelist()
        inst_name = next(n for n in names if "instant" in n)
        with tempfile.TemporaryDirectory() as tmpdir:
            z.extract(inst_name, path=tmpdir)
            ds = xr.open_dataset(os.path.join(tmpdir, inst_name), engine="netcdf4")
            times = ds["valid_time"].values.copy()
            src_lat = ds["latitude"].values.copy()
            src_lon = ds["longitude"].values.copy()
            ds.close()
    return times, src_lat, src_lon


def create_output_file(out_file, grd_file, all_time_unix, yorig, morig, dorig):
    """Create the output NetCDF file with all dimensions and variables (data=fill)."""
    t_days = croco_time(all_time_unix, yorig, morig, dorig)
    t_units = f"days since {yorig:04d}-{morig:02d}-{dorig:02d} 00:00:00"
    nt = len(t_days)

    with nc4.Dataset(grd_file) as grd:
        eta_rho = grd.dimensions["eta_rho"].size
        xi_rho  = grd.dimensions["xi_rho"].size

    print(f"  Creating output: {out_file}")
    print(f"  {nt} time steps, grid {eta_rho}×{xi_rho}")

    with nc4.Dataset(out_file, "w", format="NETCDF4_CLASSIC") as ds:
        ds.title = "ERA5 atmospheric forcing for CROCO MIC"
        ds.source = "ERA5 (ECMWF), processed by make_frc_era5.py"
        ds.time_origin = t_units

        ds.createDimension("xi_rho",  xi_rho)
        ds.createDimension("eta_rho", eta_rho)

        created_time_dims = set()
        for vname, (tdim, units, longname) in VAR_META.items():
            if tdim not in created_time_dims:
                ds.createDimension(tdim, nt)
                tv = ds.createVariable(tdim, "f8", (tdim,))
                tv.units = t_units
                tv.long_name = f"time for {tdim.split('_')[0]} forcing"
                tv.calendar = "gregorian"
                tv[:] = t_days
                created_time_dims.add(tdim)

            v = ds.createVariable(vname, "f4", (tdim, "eta_rho", "xi_rho"),
                                  fill_value=1e37, zlib=True, complevel=4)
            v.long_name = longname
            v.units = units

    return nt, t_units


def process_month(zip_path, src_lat, src_lon, dst_lon, dst_lat, time_unix_all):
    """
    Load one month's zip, process all variables, interpolate to CROCO grid.
    Returns dict of {vname: array(nt_month, eta, xi)} and slice into full time axis.
    """
    with zipfile.ZipFile(zip_path) as z:
        names = z.namelist()
        inst_name  = next(n for n in names if "instant" in n)
        accum_name = next(n for n in names if "accum"   in n)

        with tempfile.TemporaryDirectory() as tmpdir:
            z.extract(inst_name,  path=tmpdir)
            z.extract(accum_name, path=tmpdir)

            ds_i = xr.open_dataset(
                os.path.join(tmpdir, inst_name),  engine="netcdf4"
            ).load()
            ds_a = xr.open_dataset(
                os.path.join(tmpdir, accum_name), engine="netcdf4"
            ).load()

    # Sort by time within this month
    ds_i = ds_i.sortby("valid_time")
    ds_a = ds_a.sortby("valid_time")

    t_ns = ds_i["valid_time"].values.astype("datetime64[ns]").astype("int64")
    time_unix = t_ns // 10**9

    # Find where these timestamps fall in the full time axis
    # Build a lookup dict for efficiency
    time_to_idx = {t: i for i, t in enumerate(time_unix_all)}
    indices = [time_to_idx[t] for t in time_unix]

    # Instantaneous variables
    u10  = ds_i["u10"].values
    v10  = ds_i["v10"].values
    t2m  = ds_i["t2m"].values
    d2m  = ds_i["d2m"].values
    msl  = ds_i["msl"].values

    tair = t2m - 273.15
    pair = msl / 100.0
    qair = q_from_dewpoint(d2m, msl)

    # Accumulated variables
    ssrd = ds_a["ssrd"].values
    strd = ds_a["strd"].values
    tp   = ds_a["tp"].values

    swrad    = np.clip(deaccumulate(ssrd, time_unix), 0, None)
    lwrad_dn = np.clip(deaccumulate(strd, time_unix), 0, None)
    rain     = np.clip(deaccumulate(tp,   time_unix) * 1000.0, 0, None)

    # Free raw arrays
    del ds_i, ds_a, t2m, d2m, msl, ssrd, strd, tp

    vars_raw = {
        "Uwind":      u10,
        "Vwind":      v10,
        "Tair":       tair,
        "Qair":       qair,
        "Pair":       pair,
        "rain":       rain,
        "swrad":      swrad,
        "lwrad_down": lwrad_dn,
    }

    vars_croco = {}
    for vname, data in vars_raw.items():
        vars_croco[vname] = interp_to_croco(data, src_lon, src_lat, dst_lon, dst_lat)
        del data  # free as we go

    return vars_croco, indices


def checkpoint_path(zip_path):
    """Return the .done checkpoint file path for a given zip."""
    return Path(str(zip_path) + ".done")


def write_month_to_file(out_file, vars_croco, indices):
    """Append one month of processed data to the output NetCDF at the given indices."""
    with nc4.Dataset(out_file, "a") as ds:
        for vname, arr in vars_croco.items():
            v = ds.variables[vname]
            for local_i, global_i in enumerate(indices):
                v[global_i, :, :] = arr[local_i, :, :]


# =============================================================================
# MAIN
# =============================================================================
if __name__ == "__main__":
    era5_path = Path(ERA5_DIR)
    zip_files = sorted(era5_path.glob("era5_*.nc"))
    if not zip_files:
        raise FileNotFoundError(f"No ERA5 files found in {ERA5_DIR}")
    print(f"Found {len(zip_files)} ERA5 zip files")

    out_exists = Path(OUT_FILE).exists()
    done_files = [checkpoint_path(z) for z in zip_files]
    n_done = sum(p.exists() for p in done_files)

    # If output file is missing but some .done files exist → inconsistent state, restart
    if not out_exists and n_done > 0:
        print("Output file missing but checkpoints exist — limpiando checkpoints...")
        for p in done_files:
            p.unlink(missing_ok=True)
        n_done = 0

    if out_exists and n_done > 0:
        print(f"Resumiendo: {n_done}/{len(zip_files)} meses ya procesados.")
    elif not out_exists:
        print("Inicio desde cero.")

    # --- Pass 1: collect all timestamps (lightweight, no data) ---
    print("\nPass 1: scanning timestamps...")
    all_times = []
    src_lat_ref = src_lon_ref = None
    for zpath in zip_files:
        print(f"  {zpath.name}")
        times, src_lat, src_lon = scan_zip_timestamps(zpath)
        all_times.append(times)
        if src_lat_ref is None:
            src_lat_ref = src_lat
            src_lon_ref = src_lon

    all_times_ns = np.concatenate([t.astype("datetime64[ns]").astype("int64")
                                    for t in all_times])
    sort_idx = np.argsort(all_times_ns)
    all_times_ns = all_times_ns[sort_idx]
    all_time_unix = all_times_ns // 10**9

    t0 = pd.to_datetime(all_time_unix[0],  unit='s')
    t1 = pd.to_datetime(all_time_unix[-1], unit='s')
    print(f"  Total: {len(all_time_unix)} steps  {t0.date()} → {t1.date()}")

    # --- Read CROCO grid ---
    print("\nReading CROCO grid...")
    with nc4.Dataset(GRD_FILE) as grd:
        dst_lon = grd["lon_rho"][:]
        dst_lat = grd["lat_rho"][:]

    # --- Create output file skeleton (only if starting fresh) ---
    if not out_exists:
        print("\nCreating output file...")
        create_output_file(OUT_FILE, GRD_FILE, all_time_unix, YORIG, MORIG, DORIG)
    else:
        print("\nOutput file exists, continuando escritura...")

    # --- Pass 2: process one month at a time ---
    print("\nPass 2: processing months...")
    for i, zpath in enumerate(zip_files, 1):
        ckpt = checkpoint_path(zpath)
        if ckpt.exists():
            print(f"\n  [{i}/{len(zip_files)}] {zpath.name}  [SKIP - ya procesado]")
            continue

        print(f"\n  [{i}/{len(zip_files)}] {zpath.name}")
        vars_croco, indices = process_month(
            zpath, src_lat_ref, src_lon_ref, dst_lon, dst_lat, all_time_unix
        )
        print(f"    Writing {len(indices)} timesteps to output...")
        write_month_to_file(OUT_FILE, vars_croco, indices)
        del vars_croco

        # Mark as done only after successful write
        ckpt.touch()
        print(f"    Done. [checkpoint guardado]")

    print(f"\nDone. Output: {OUT_FILE}")
    print(f"Period: {t0.date()} → {t1.date()}  ({len(all_time_unix)} time steps)")
