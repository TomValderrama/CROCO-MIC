#!/bin/bash
# setup_and_run_preprocessing.sh
# Instala Miniconda + entorno croco_pytools, luego genera todos los archivos de input CROCO.
# Diseñado para correr en tmux mientras el usuario duerme.
#
# USO: tmux new-session -d -s prepro "bash /mnt/d/ProyectoMsc_CROCO/setup_and_run_preprocessing.sh 2>&1 | tee /mnt/d/ProyectoMsc_CROCO/prepro.log"
# VER LOG: tail -f /mnt/d/ProyectoMsc_CROCO/prepro.log

set -euo pipefail

LOGFILE="/mnt/d/ProyectoMsc_CROCO/prepro.log"
PROJ="/mnt/d/ProyectoMsc_CROCO"
INPUTS="$PROJ/01_inputs/croco_files"
PREPRO="$PROJ/croco_pytools/prepro"
CONDA_DIR="$HOME/miniconda3"
ENV_NAME="croco_env"

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "=== INICIO DEL PREPROCESAMIENTO ==="
log "Log: $LOGFILE"
echo ""

# ─────────────────────────────────────────────────────────────
# PASO 1: Instalar Miniconda (si no existe)
# ─────────────────────────────────────────────────────────────
log "PASO 1/6 — Verificar/instalar Miniconda"

if [[ ! -f "$CONDA_DIR/bin/conda" ]]; then
    log "  Descargando Miniconda..."
    INSTALLER="/tmp/miniconda_installer.sh"
    curl -L "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" \
         -o "$INSTALLER" --progress-bar
    bash "$INSTALLER" -b -p "$CONDA_DIR"
    rm -f "$INSTALLER"
    log "  Miniconda instalado en $CONDA_DIR"
else
    log "  Miniconda ya existe en $CONDA_DIR"
fi

# Activar conda
source "$CONDA_DIR/etc/profile.d/conda.sh"
log "  conda $(conda --version)"

# Aceptar TOS de conda (requerido desde conda 26+)
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main 2>/dev/null || true
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r    2>/dev/null || true

# ─────────────────────────────────────────────────────────────
# PASO 2: Crear entorno conda con todas las dependencias
# ─────────────────────────────────────────────────────────────
log ""
log "PASO 2/6 — Crear entorno conda '$ENV_NAME'"

if conda env list | grep -q "^$ENV_NAME "; then
    log "  Entorno '$ENV_NAME' ya existe, activando..."
else
    log "  Creando entorno (esto tarda ~5 min)..."
    conda create -y -n "$ENV_NAME" -c conda-forge \
        python=3.11 \
        numpy scipy xarray netcdf4 pandas \
        pyinterp \
        regionmask geopandas cartopy \
        matplotlib \
        compilers \
        libnetcdf \
        meson ninja
    log "  Entorno creado."
fi

conda activate "$ENV_NAME"
log "  Entorno activo: $(which python)"
log "  pyinterp: $(python -c 'import pyinterp; print(pyinterp.__version__)')"

# ─────────────────────────────────────────────────────────────
# PASO 3: Compilar módulo Fortran toolsf
# ─────────────────────────────────────────────────────────────
log ""
log "PASO 3/6 — Compilar módulo Fortran toolsf"

FORTDIR="$PREPRO/Modules/tools_fort_routines"
cd "$FORTDIR"

# Detectar rutas netcdf del entorno conda
NETCDFINC=$(python -c "import netCDF4; import os; print(os.path.dirname(netCDF4.__file__))" 2>/dev/null || \
            nf-config --includedir 2>/dev/null || echo "$CONDA_PREFIX/include")
log "  NETCDFINC: $NETCDFINC"

# Limpiar compilados anteriores
make clean 2>/dev/null || true
rm -f ../toolsf*.so 2>/dev/null || true

# Compilar
FC=gfortran F90=gfortran F77=gfortran \
NETCDFINC="$CONDA_PREFIX/include" \
make 2>&1 || {
    log "  ADVERTENCIA: compilacion de toolsf fallo (no bloquea make_ini/bry/tides)"
}

ls ../toolsf*.so 2>/dev/null && log "  toolsf compilado OK" || log "  toolsf no compilado (continuando sin el)"

# ─────────────────────────────────────────────────────────────
# PASO 4: Generar croco_frc_era5.nc
# ─────────────────────────────────────────────────────────────
log ""
log "PASO 4/6 — Generar croco_frc_era5.nc"

if [[ -f "$INPUTS/croco_frc_era5.nc" ]]; then
    log "  Ya existe, omitiendo."
else
    cd "$PROJ/04_analisis/python/preprocessing"
    log "  Corriendo make_frc_era5.py..."
    python make_frc_era5.py && log "  croco_frc_era5.nc generado OK" || {
        log "  ERROR en make_frc_era5.py — ver log"
        exit 1
    }
fi

# ─────────────────────────────────────────────────────────────
# PASO 5: Generar croco_ini.nc y croco_bry.nc (via croco_pytools)
# ─────────────────────────────────────────────────────────────
log ""
log "PASO 5/6 — Generar croco_ini.nc y croco_bry_*.nc"

cd "$PREPRO"

if [[ -f "$INPUTS/croco_ini.nc" ]]; then
    log "  croco_ini.nc ya existe, omitiendo."
else
    log "  Corriendo make_ini.py..."
    python make_ini.py mic_ancud.ini && log "  croco_ini.nc generado OK" || {
        log "  ERROR en make_ini.py"
        exit 1
    }
fi

# Buscar si ya existen archivos bry
N_BRY=$(ls "$INPUTS"/croco_bry*.nc 2>/dev/null | wc -l)
if [[ "$N_BRY" -gt 0 ]]; then
    log "  croco_bry ya existe ($N_BRY archivos), omitiendo."
else
    log "  Corriendo make_bry.py..."
    python make_bry.py mic_ancud.ini && log "  croco_bry generado OK" || {
        log "  ERROR en make_bry.py"
        exit 1
    }
fi

# ─────────────────────────────────────────────────────────────
# PASO 6: Generar croco_frc_tpxo10.nc (mareas)
# ─────────────────────────────────────────────────────────────
log ""
log "PASO 6/6 — Generar croco_frc_tides.nc"

if ls "$INPUTS"/croco_frc*tide*.nc "$INPUTS"/croco_frc*tpxo*.nc 2>/dev/null | grep -q .; then
    log "  Archivo de mareas ya existe, omitiendo."
else
    log "  Corriendo make_tides.py..."
    python make_tides.py mic_ancud.ini && log "  croco_frc_tides.nc generado OK" || {
        log "  ERROR en make_tides.py"
        exit 1
    }
fi

# ─────────────────────────────────────────────────────────────
# RESUMEN FINAL
# ─────────────────────────────────────────────────────────────
log ""
log "=== RESUMEN FINAL ==="
log "Archivos generados en $INPUTS:"
ls -lh "$INPUTS/"*.nc 2>/dev/null | awk '{print "  " $5 "  " $9}' || log "  (ninguno)"

log ""
log "=== PREPROCESAMIENTO COMPLETADO ==="
log "Puedes revisar el log completo en: $LOGFILE"
