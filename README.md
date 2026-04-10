# CROCO-MIC

Configuración y pipeline de preprocesamiento del modelo oceánico [CROCO](https://www.croco-ocean.org/) para el Mar Interior de Chiloé (MIC), Chile.

## Dominio

| Parámetro | Valor |
|-----------|-------|
| Región | Mar Interior de Chiloé (Golfo de Ancud) |
| Resolución horizontal | ~3 km |
| Grilla | 603 × 505 puntos rho |
| Niveles verticales | 42 sigma |
| Período | Noviembre 2020 – Agosto 2021 |

## Forzantes

| Forzante | Fuente | Resolución |
|----------|--------|------------|
| Atmosférico | ERA5 (ECMWF) | ~31 km, 3-horario |
| Condición inicial y contornos | GLORYS12 (CMEMS) | 1/12°, diario |
| Mareas | TPXO10 atlas v2 | 1/30° |

Contornos abiertos: Norte, Sur y Oeste (Este = tierra).

## Estructura

```
CROCO-MIC/
├── config/
│   └── mic_ancud.ini          # Configuración croco_pytools (INI/BRY/tides)
├── 04_analisis/python/
│   └── preprocessing/
│       ├── download_era5.py   # Descarga ERA5 desde CDS API
│       ├── download_glorys.py # Descarga GLORYS12 desde CMEMS
│       └── make_frc_era5.py   # Genera croco_frc_era5.nc (forzante atmosférico)
├── setup_and_run_preprocessing.sh  # Pipeline completo de preprocesamiento
├── run_croco.sh               # Lanzamiento del modelo
└── monitor_croco.sh           # Monitoreo de simulaciones en curso
```

## Dependencias

- Python 3.11+: `numpy`, `scipy`, `xarray`, `netCDF4`, `pandas`, `cdsapi`, `copernicusmarine`
- [croco_pytools](https://gitlab.inria.fr/croco-ocean/croco_pytools) — generación de INI, BRY y mareas
- Cuenta en [CDS (Copernicus)](https://cds.climate.copernicus.eu/) para ERA5
- Cuenta en [CMEMS](https://marine.copernicus.eu/) para GLORYS12
- TPXO10 atlas v2 (descarga manual desde [OSU](https://www.tpxo.net/))

## Uso

```bash
# Pipeline completo (instala entorno conda, genera todos los inputs)
tmux new-session -d -s prepro "bash setup_and_run_preprocessing.sh 2>&1 | tee prepro.log"
tail -f prepro.log
```

El script `make_frc_era5.py` procesa el forzante ERA5 mes a mes para minimizar el uso de RAM, con checkpoints automáticos para reanudar en caso de interrupción.

## Contexto

Este repositorio contiene el código asociado al manuscrito científico "Origin and dynamics of the Gulf of Ancud's eddy, in Chile: A numerical analysis", actualmente en revisión en *Ocean Modelling*. El trabajo se originó como tesis de Magíster en Geofísica (Universidad de Concepción) y está siendo preparado para publicación como artículo científico.
