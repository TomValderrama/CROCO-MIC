#!/bin/bash
# sync_to_server.sh
# Sube el proyecto CROCO-MIC al servidor remoto, excluyendo:
#   - Binarios compilados para WSL (hay que recompilar en el server)
#   - Datos crudos no necesarios para correr (TPXO10 atlas, ERA5 raw)
#   - Outputs del run de prueba local
#   - Scripts de Windows (.ps1)
#   - Logs
#
# Uso:
#   ./sync_to_server.sh             # dry-run (solo muestra qué se transferiría)
#   ./sync_to_server.sh --execute   # transferencia real

# ── Configuración ──────────────────────────────────────────────────────────────
SERVER_USER="tvalderrama"           # tu usuario en el server
SERVER_HOST="server.example.com"    # hostname o IP del server
SERVER_PATH="/home/tvalderrama/ProyectoMsc_CROCO"  # destino en el server

LOCAL_PATH="/mnt/d/ProyectoMsc_CROCO"
# ──────────────────────────────────────────────────────────────────────────────

DRY_RUN="--dry-run"
if [[ "$1" == "--execute" ]]; then
    DRY_RUN=""
    echo ">>> MODO REAL — se transferirán archivos al server <<<"
else
    echo ">>> MODO DRY-RUN — solo muestra qué se transferiría (usa --execute para enviar) <<<"
fi

rsync -avhP \
    $DRY_RUN \
    --stats \
    \
    `# ── Binarios compilados para WSL (recompilar en server) ──` \
    --exclude="/croco" \
    --exclude="/ncjoin" \
    --exclude="/partit" \
    --exclude="/Compile/" \
    \
    `# ── Datos crudos de entrada (no se necesitan para correr) ──` \
    --exclude="/01_inputs/tides/TPXO10_atlas_v2_nc/" \
    --exclude="/01_inputs/croco_files/croco_frc_era5.nc" \
    --exclude="/01_inputs/forcing/era5_raw/" \
    \
    `# ── Symlinks de CROCO_FILES (apuntan a /mnt/d/..., no servirán en server) ──` \
    `# Los archivos reales están en 01_inputs/croco_files/ y se suben desde allá. ──` \
    `# Recrear symlinks en el server con setup_linux_run.sh ──` \
    --exclude="/02_runs/control_verano/CROCO_FILES/" \
    \
    `# ── Output del run de prueba local ──` \
    --exclude="/02_runs/control_verano/croco_run.log" \
    --exclude="/02_runs/control_verano/run.log" \
    \
    `# ── Logs de preprocesamiento ──` \
    --exclude="/frc.log" \
    --exclude="/ibc.log" \
    --exclude="/prepro.log" \
    \
    `# ── Scripts de Windows ──` \
    --exclude="/watchdog_croco.ps1" \
    \
    `# ── Git history (no necesaria en server) ──` \
    --exclude="/.git/" \
    \
    "${LOCAL_PATH}/" \
    "${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/"

echo ""
echo "Tamaño estimado transferido:"
echo "  ~1 GB  — inputs procesados (grid, bry, clm, ini, frc_tpxo10)"
echo "  ~11 GB — croco_blk_mic.nc (bulk forcing ERA5, necesario para correr)"
echo "  ~55 MB — CROCO_SRC (fuentes, recompilar en server)"
echo "  ~500 MB — croco_tools, config, scripts"
echo ""
echo "NOTA: croco_blk_mic.nc son 11 GB. Si el server tiene acceso a ERA5,"
echo "      considera re-generarlo allá con convert_era5_to_bulk.py y excluirlo aquí."
echo ""
echo "SIGUIENTE PASO en el server:"
echo "  cd ${SERVER_PATH} && bash setup_linux_run.sh"
echo "  (esto recrea los symlinks en 02_runs/control_verano/CROCO_FILES/)"
