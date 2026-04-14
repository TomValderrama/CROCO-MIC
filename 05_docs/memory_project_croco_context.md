---
name: Contexto del proyecto CROCO — MIC
description: Dominio, experimentos, configuración del modelo y estado actual del proyecto de tesis MSc
type: project
---

## Proyecto
Tesis MSc de Tomás Valderrama. Artículo en revisión en Ocean Modelling (Major Revision).
Título: "Origin and dynamics of the Gulf of Ancud's eddy, in Chile: A numerical analysis"

## Dominio
**Mar Interior de Chiloé (MIC)**, Chile. Región con remolinos sub-superficiales de 10–30 km de diámetro.
- Grilla: `roms_MIC_grd_v9g.nc` → 603×505 (eta_rho × xi_rho), 42 niveles sigma
- Extensión: lon [-79, -72], lat [-47, -41]
- S-coord: theta_s=7.0, theta_b=2.0, hc=200.0, N=42

## Modelo
- **CROCO 2.1.1** (instalado en WSL)
- Ejecutable compilado: `/mnt/d/ProyectoMsc_CROCO/croco` ✓ (compilación exitosa)
- Fuentes: `/mnt/d/ProyectoMsc_CROCO/CROCO_SRC/`
- CPP options activos: `Compile/cppdefs.h` — MIC_ANCUD, REGIONAL, MPI, TIDES, OBC_WEST/NORTH/SOUTH, LMD_MIXING, SSH_TIDES, FRC_BRY, AVERAGES, DIAGNOSTICS_TS, DIAGNOSTICS_UV, **DIAGNOSTICS_VRT, DIAGNOSTICS_EK, DIAGNOSTICS_EK_MLD, DIAGNOSTICS_EDDY** (nuevos)

## Preprocesamiento
- **croco_pytools** (Python, dev branch) en `/mnt/d/ProyectoMsc_CROCO/croco_pytools/`
- Config principal: `croco_pytools/prepro/mic_ancud.ini`
- Outputs CROCO en: `01_inputs/croco_files/`
- Reader tpxo10 añadido a `croco_pytools/prepro/readers.jsonc`

## Forzantes — estado
| Dato | Fuente | Estado |
|------|--------|--------|
| ERA5 (u10,v10,t2m,d2m,msl,ssrd,strd,tp,e) | CDS API v2 | ✓ Descargado nov2020–ago2021, formato zip en `01_inputs/forcing/era5_raw/` |
| GLORYS12 (thetao,so,uo,vo,zos) | Copernicus Marine | ✓ Descargado nov2020–ago2021 en `01_inputs/glorys_raw/` |
| TPXO10 atlas v2 | tpxo.net | ✓ 31 archivos NC en `01_inputs/tides/TPXO10_atlas_v2_nc/` |
| Dai & Trenberth runoff | climatología | ✓ `01_inputs/runoff/Dai_Trenberth_runoff_global_clim.nc` |
| Grid | existente | ✓ `01_inputs/grid/roms_MIC_grd_v9g.nc` |

## Scripts de preprocesamiento Python
- `04_analisis/python/preprocessing/download_era5.py` — descarga ERA5 (CDS API v2)
- `04_analisis/python/preprocessing/download_glorys.py` — descarga GLORYS12
- `04_analisis/python/preprocessing/make_frc_era5.py` — ERA5 zip → croco_frc_era5.nc (BULK_FLUX)
- `04_analisis/python/spinup_analysis.py` — análisis de spin-up (KE, Hilbert, exp fit)
- `04_analisis/python/tidal_residual.py` — descomposición mareal con utide

## Experimentos (a correr)
Período de datos: nov 2020 – ago 2021

| Experimento | Spin-up | Análisis |
|-------------|---------|----------|
| Control verano | nov–dic 2020 | ene–mar 2021 |
| Control invierno | abr–may 2021 | jun–ago 2021 |
| Sin mareas | ídem | ídem |
| Batimetría plana (150 m) | ídem | ídem |
| Vientos climatológicos | ídem | ídem |
| **Sin viento** (nuevo) | ídem | ídem |

Directorios de corrida: `02_runs/control_verano/`, `02_runs/control_invierno/`, etc.

## Problemas identificados por revisores (a corregir)
1. Cálculo estrés del viento: debe ser vectorial τ_x = ρ·C_D·√(U²+V²)·U
2. Corriente residual de marea: metodología → promedio temporal baroclínico (implementado en tidal_residual.py)
3. Validación: agregar RMSE, correlación, Taylor diagram vs. datos SHOA/DIMAR/altimetría
4. Número de Rossby: calcular Ro = U/fL
5. Figura 10b: reemplazar mapa homogéneo por serie de tiempo en área del remolino
6. Estadística: R2 señaló que 2–4 remolinos es insuficiente → simulaciones más largas

## Notas importantes
- ERA5 reemplaza a WRF (modelo Chile solo llega a 2016, sin acceso a NLHPC)
- PSOURCE rivers eliminado (datos MOSA-ROMS no recuperables) → Dai & Trenberth distribuido
- CI: GLORYS12 reemplaza restart operacional de MOSA
- Mareas: 8 componentes M2,S2,N2,K2,K1,O1,P1,Q1 (antes solo M2+S2)
- ERA5 files descargados con CDS API v2 son .zip con 2 NetCDF4 internos (instant + accum)

**Why:** Revisión mayor requiere nuevos experimentos, diagnósticos adicionales, simulaciones más largas y mejor metodología.
**How to apply:** Próximos pasos: crear croco_frc_era5.nc, luego croco_ini+croco_bry via make_ini/make_bry.py, luego croco_frc_tpxo10 via make_tides.py, luego croco.in para primera corrida.
