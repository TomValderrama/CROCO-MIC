"""
Download ERA5 surface forcing data for CROCO MIC simulations.

Domain: Mar Interior de Chiloé
Lon: -80 to -71, Lat: -48 to -40 (1° padding around model grid)
Period: Nov 2020 - Aug 2021 (2 months spin-up + 3 months analysis per season)
"""

import cdsapi
import os

# --- Configuration ---
OUTPUT_DIR = "/mnt/d/ProyectoMsc_CROCO/01_inputs/forcing/era5_raw"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Domain with 1° padding
AREA = [-40, -80, -48, -71]  # [N, W, S, E]

# Variables needed for CROCO bulk formulas
VARIABLES = [
    "10m_u_component_of_wind",     # u10
    "10m_v_component_of_wind",     # v10
    "2m_temperature",              # t2m
    "2m_dewpoint_temperature",     # d2m
    "mean_sea_level_pressure",     # msl
    "surface_solar_radiation_downwards",   # ssrd
    "surface_thermal_radiation_downwards", # strd
    "total_precipitation",         # tp
    "evaporation",                 # e  (for P-E freshwater flux)
]

# Months to download: Nov 2020 - Aug 2021
MONTHS = [
    ("2020", ["11", "12"]),
    ("2021", ["01", "02", "03", "04", "05", "06", "07", "08"]),
]

client = cdsapi.Client()

for year, months in MONTHS:
    for month in months:
        outfile = os.path.join(OUTPUT_DIR, f"era5_{year}{month}.nc")
        if os.path.exists(outfile):
            print(f"Already exists: {outfile}, skipping.")
            continue

        print(f"Downloading ERA5 {year}-{month}...")
        client.retrieve(
            "reanalysis-era5-single-levels",
            {
                "product_type": "reanalysis",
                "variable": VARIABLES,
                "year": year,
                "month": month,
                "day": [f"{d:02d}" for d in range(1, 32)],
                "time": ["00:00", "03:00", "06:00", "09:00",
                         "12:00", "15:00", "18:00", "21:00"],
                "area": AREA,
                "data_format": "netcdf",
            },
            outfile,
        )
        print(f"Saved: {outfile}")

print("ERA5 download complete.")
