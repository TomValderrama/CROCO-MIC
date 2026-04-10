"""
Download GLORYS12 ocean data for CROCO MIC initial and boundary conditions.

Dataset: cmems_mod_glo_phy_my_0.083deg_P1D-m (GLORYS12 daily)
Domain: Mar Interior de Chiloé
Lon: -80 to -71, Lat: -48 to -40 (1° padding around model grid)
Period: Nov 2020 - Aug 2021 (2 months spin-up + 3 months analysis per season)

Variables:
  thetao : potential temperature [°C]
  so     : salinity [psu]
  uo     : eastward velocity [m/s]
  vo     : northward velocity [m/s]
  zos    : sea surface height [m]
"""

import copernicusmarine
import os

# --- Configuration ---
OUTPUT_DIR = "/mnt/d/ProyectoMsc_CROCO/01_inputs/glorys_raw"
os.makedirs(OUTPUT_DIR, exist_ok=True)

DATASET_ID = "cmems_mod_glo_phy_my_0.083deg_P1D-m"

# Domain with 1° padding
LON_MIN, LON_MAX = -80.0, -71.0
LAT_MIN, LAT_MAX = -48.0, -40.0

VARIABLES = ["thetao", "so", "uo", "vo", "zos"]

# Months to download: Nov 2020 - Aug 2021
MONTHS = [
    ("2020-11-01", "2020-11-30"),
    ("2020-12-01", "2020-12-31"),
    ("2021-01-01", "2021-01-31"),
    ("2021-02-01", "2021-02-28"),
    ("2021-03-01", "2021-03-31"),
    ("2021-04-01", "2021-04-30"),
    ("2021-05-01", "2021-05-31"),
    ("2021-06-01", "2021-06-30"),
    ("2021-07-01", "2021-07-31"),
    ("2021-08-01", "2021-08-31"),
]

for start, end in MONTHS:
    month_str = start[:7].replace("-", "")
    outfile = os.path.join(OUTPUT_DIR, f"glorys_{month_str}.nc")

    if os.path.exists(outfile):
        print(f"Already exists: {outfile}, skipping.")
        continue

    print(f"Downloading GLORYS12 {start} to {end}...")
    copernicusmarine.subset(
        dataset_id=DATASET_ID,
        variables=VARIABLES,
        minimum_longitude=LON_MIN,
        maximum_longitude=LON_MAX,
        minimum_latitude=LAT_MIN,
        maximum_latitude=LAT_MAX,
        start_datetime=f"{start}T00:00:00",
        end_datetime=f"{end}T00:00:00",
        output_filename=outfile,
        output_directory=".",
        force_download=False,
    )
    print(f"Saved: {outfile}")

print("GLORYS12 download complete.")
