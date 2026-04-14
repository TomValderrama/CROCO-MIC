#!/usr/bin/env python3
"""
Crop TPXO10 atlas files to the MIC domain to avoid OOM kills.

MIC grid extent: lon -79 to -72, lat -47 to -41
Using 5-degree buffer: lon -84 to -67, lat -52 to -36
TPXO10 uses 0-360 longitude, so -84 → 276, -67 → 293.
"""

import os
import numpy as np
import xarray as xr
import netCDF4 as nc

# ── Domain bounds (with buffer) ──────────────────────────────────────────────
LON_MIN, LON_MAX = -84.0, -67.0   # 276–293 in 0-360
LAT_MIN, LAT_MAX = -52.0, -36.0

TIDE_DIR  = "/mnt/d/ProyectoMsc_CROCO/01_inputs/tides/TPXO10_atlas_v2_nc"
OUT_DIR   = os.path.join(TIDE_DIR, "MIC")
WAVES     = ["m2", "s2", "n2", "k2", "k1", "o1", "p1", "q1"]

os.makedirs(OUT_DIR, exist_ok=True)


def lon_to_360(lon):
    """Convert negative longitudes to 0-360."""
    return lon % 360


def get_slice(coord_1d, vmin, vmax):
    """Return (imin, imax+1) index slice for a 1D coordinate."""
    lon360_min = lon_to_360(vmin)
    lon360_max = lon_to_360(vmax)
    idx = np.where((coord_1d >= lon360_min) & (coord_1d <= lon360_max))[0]
    return idx[0], idx[-1] + 1


def to_180(lon_arr):
    """Convert 0-360 longitudes to -180/180."""
    out = lon_arr.copy()
    out[out > 180] -= 360
    return out


def get_lat_slice(lat_1d, lat_min, lat_max):
    idx = np.where((lat_1d >= lat_min) & (lat_1d <= lat_max))[0]
    return idx[0], idx[-1] + 1


def crop_h_file(wave):
    """Crop elevation file h_<wave>_tpxo10_atlas_30_v2.nc"""
    src = os.path.join(TIDE_DIR, f"h_{wave}_tpxo10_atlas_30_v2.nc")
    dst = os.path.join(OUT_DIR,  f"h_{wave}_tpxo10_atlas_30_v2.nc")
    if os.path.exists(dst):
        print(f"  [skip] {os.path.basename(dst)} already exists")
        return

    print(f"  Cropping {os.path.basename(src)} ...", flush=True)
    ds = xr.open_dataset(src)

    lon_z = ds["lon_z"].values
    lat_z = ds["lat_z"].values

    i0, i1 = get_slice(lon_z, LON_MIN, LON_MAX)
    j0, j1 = get_lat_slice(lat_z, LAT_MIN, LAT_MAX)

    lon_z_sub = ds["lon_z"].isel(nx=slice(i0, i1)).values
    ds_out = xr.Dataset(
        {
            "con":  ds["con"],
            "lon_z": xr.DataArray(to_180(lon_z_sub), dims="nx", attrs=ds["lon_z"].attrs),
            "lat_z": ds["lat_z"].isel(ny=slice(j0, j1)),
            "hRe":  ds["hRe"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
            "hIm":  ds["hIm"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
        },
        attrs=ds.attrs,
    )
    ds_out.to_netcdf(dst)
    print(f"    -> nx={i1-i0}, ny={j1-j0}  saved.")


def crop_u_file(wave):
    """Crop transport file u_<wave>_tpxo10_atlas_30_v2.nc"""
    src = os.path.join(TIDE_DIR, f"u_{wave}_tpxo10_atlas_30_v2.nc")
    dst = os.path.join(OUT_DIR,  f"u_{wave}_tpxo10_atlas_30_v2.nc")
    if os.path.exists(dst):
        print(f"  [skip] {os.path.basename(dst)} already exists")
        return

    print(f"  Cropping {os.path.basename(src)} ...", flush=True)
    ds = xr.open_dataset(src)

    lon_u = ds["lon_u"].values
    lat_u = ds["lat_u"].values
    lon_v = ds["lon_v"].values
    lat_v = ds["lat_v"].values

    iu0, iu1 = get_slice(lon_u, LON_MIN, LON_MAX)
    ju0, ju1 = get_lat_slice(lat_u, LAT_MIN, LAT_MAX)
    iv0, iv1 = get_slice(lon_v, LON_MIN, LON_MAX)
    jv0, jv1 = get_lat_slice(lat_v, LAT_MIN, LAT_MAX)

    # Use the union of u/v slices so dimensions are consistent
    i0 = min(iu0, iv0); i1 = max(iu1, iv1)
    j0 = min(ju0, jv0); j1 = max(ju1, jv1)

    lon_u_sub = to_180(ds["lon_u"].isel(nx=slice(i0, i1)).values)
    lon_v_sub = to_180(ds["lon_v"].isel(nx=slice(i0, i1)).values)
    ds_out = xr.Dataset(
        {
            "con":  ds["con"],
            "lon_u": xr.DataArray(lon_u_sub, dims="nx", attrs=ds["lon_u"].attrs),
            "lat_u": ds["lat_u"].isel(ny=slice(j0, j1)),
            "lon_v": xr.DataArray(lon_v_sub, dims="nx", attrs=ds["lon_v"].attrs),
            "lat_v": ds["lat_v"].isel(ny=slice(j0, j1)),
            "uRe":   ds["uRe"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
            "uIm":   ds["uIm"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
            "vRe":   ds["vRe"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
            "vIm":   ds["vIm"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
        },
        attrs=ds.attrs,
    )
    ds_out.to_netcdf(dst)
    print(f"    -> nx={i1-i0}, ny={j1-j0}  saved.")


def crop_grid_file():
    """Crop grid_tpxo10atlas_v2.nc"""
    src = os.path.join(TIDE_DIR, "grid_tpxo10atlas_v2.nc")
    dst = os.path.join(OUT_DIR,  "grid_tpxo10atlas_v2.nc")
    if os.path.exists(dst):
        print(f"  [skip] grid file already exists")
        return

    print(f"  Cropping grid file ...", flush=True)
    ds = xr.open_dataset(src)

    lon_z = ds["lon_z"].values
    lat_z = ds["lat_z"].values

    i0, i1 = get_slice(lon_z, LON_MIN, LON_MAX)
    j0, j1 = get_lat_slice(lat_z, LAT_MIN, LAT_MAX)

    def sub_lon(name):
        return xr.DataArray(to_180(ds[name].isel(nx=slice(i0, i1)).values),
                            dims="nx", attrs=ds[name].attrs)

    ds_out = xr.Dataset(
        {
            "lon_z": sub_lon("lon_z"),
            "lat_z": ds["lat_z"].isel(ny=slice(j0, j1)),
            "lon_u": sub_lon("lon_u"),
            "lat_u": ds["lat_u"].isel(ny=slice(j0, j1)),
            "lon_v": sub_lon("lon_v"),
            "lat_v": ds["lat_v"].isel(ny=slice(j0, j1)),
            "hz":    ds["hz"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
            "hu":    ds["hu"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
            "hv":    ds["hv"].isel(nx=slice(i0, i1), ny=slice(j0, j1)),
        },
        attrs=ds.attrs,
    )
    ds_out.to_netcdf(dst)
    print(f"    -> nx={i1-i0}, ny={j1-j0}  saved.")


if __name__ == "__main__":
    print(f"Cropping TPXO10 to lon [{LON_MIN},{LON_MAX}], lat [{LAT_MIN},{LAT_MAX}]")
    print(f"Output dir: {OUT_DIR}\n")

    crop_grid_file()
    for wave in WAVES:
        crop_h_file(wave)
        crop_u_file(wave)

    print("\nDone. Update mic_ancud.ini: tide_dir -> .../TPXO10_atlas_v2_nc/MIC/")
