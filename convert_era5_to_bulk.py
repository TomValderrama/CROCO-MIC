#!/usr/bin/env python3
"""
Convert croco_frc_era5.nc (croco_pytools format) to CROCO bulk_flux format.

croco_pytools writes separate time dimensions (wind_time, tair_time, ...)
but CROCO's get_bulk.F expects a single 'bulk_time' dimension and
specific variable names (uwnd, vwnd, tair, rhum, patm, prate, radsw, radlw_in).

Processes variable-by-variable to keep memory usage low (~few hundred MB).
"""

import netCDF4 as nc
import numpy as np

SRC = "/mnt/d/ProyectoMsc_CROCO/01_inputs/croco_files/croco_frc_era5.nc"
DST = "/mnt/d/ProyectoMsc_CROCO/01_inputs/croco_files/croco_blk_mic.nc"

# ERA5 variable → (CROCO bulk name, units, long_name)
VAR_MAP = {
    "Uwind":      ("uwnd",     "m/s",     "surface u-wind component"),
    "Vwind":      ("vwnd",     "m/s",     "surface v-wind component"),
    "Tair":       ("tair",     "Celsius", "surface air temperature"),
    "Qair":       ("rhum",     "kg/kg",   "specific humidity at 2m"),
    "Pair":       ("patm",     "millibar","atmospheric pressure at MSL"),
    "rain":       ("prate",    "kg/m2/s", "precipitation rate"),
    "swrad":      ("radsw",    "W/m2",    "surface net downward shortwave radiation"),
    "lwrad_down": ("radlw_in", "W/m2",    "surface downward longwave radiation"),
}

CHUNK = 50   # timesteps to copy at once (keeps RAM ~few hundred MB)

with nc.Dataset(SRC, "r") as src, nc.Dataset(DST, "w", format="NETCDF4_CLASSIC") as dst:

    # ── Copy global attributes ──────────────────────────────────────────────
    dst.setncatts({a: src.getncattr(a) for a in src.ncattrs()})
    dst.history = "Converted to CROCO bulk_flux format by convert_era5_to_bulk.py"

    # ── Get time axis from first time variable ──────────────────────────────
    # All time dimensions have identical values — use wind_time
    t_var   = src.variables["wind_time"]
    t_units = t_var.units
    t_data  = t_var[:]
    nt      = len(t_data)

    # ── Create dimensions ──────────────────────────────────────────────────
    dst.createDimension("bulk_time", nt)
    dst.createDimension("eta_rho",   src.dimensions["eta_rho"].size)
    dst.createDimension("xi_rho",    src.dimensions["xi_rho"].size)

    # ── Write bulk_time ────────────────────────────────────────────────────
    bt = dst.createVariable("bulk_time", "f8", ("bulk_time",))
    bt.units    = t_units
    bt.long_name = "bulk forcing time"
    bt.calendar = "gregorian"
    bt[:] = t_data
    print(f"bulk_time: {nt} records  [{t_units}]")
    print(f"  range: {float(t_data[0]):.2f} – {float(t_data[-1]):.2f} days")

    # ── Copy variables in chunks ───────────────────────────────────────────
    eta = src.dimensions["eta_rho"].size
    xi  = src.dimensions["xi_rho"].size

    for era5_name, (croco_name, units, longname) in VAR_MAP.items():
        print(f"  {era5_name} → {croco_name} ...", flush=True)
        src_var = src.variables[era5_name]

        dst_var = dst.createVariable(
            croco_name, "f4", ("bulk_time", "eta_rho", "xi_rho"),
            fill_value=1e37, zlib=True, complevel=4
        )
        dst_var.long_name = longname
        dst_var.units     = units

        for i0 in range(0, nt, CHUNK):
            i1 = min(i0 + CHUNK, nt)
            dst_var[i0:i1, :, :] = src_var[i0:i1, :, :]

        print(f"    done ({nt} steps, {eta}×{xi})")

print(f"\nWritten: {DST}")
