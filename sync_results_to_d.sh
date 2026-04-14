#!/bin/bash
# sync_results_to_d.sh — Copia los resultados del Linux FS de vuelta a D:.
# Copia solo archivos de salida (*.nc, logs), no los archivos de entrada grandes.
#
# USO:
#   bash sync_results_to_d.sh 02_runs/control_verano
#   bash sync_results_to_d.sh 02_runs/control_verano --todo   # copia TODO incluyendo inputs

set -euo pipefail

RUNDIR_REL="${1:-02_runs/control_verano}"
MODE="${2:---outputs}"
EXP_NAME=$(basename "$RUNDIR_REL")
SRC="$HOME/croco_runs/$EXP_NAME"
DEST="/mnt/d/ProyectoMsc_CROCO/$RUNDIR_REL"

echo "=== Sincronizando resultados: $EXP_NAME ==="
echo "  Origen:  $SRC"
echo "  Destino: $DEST"

if [[ ! -d "$SRC" ]]; then
    echo "ERROR: no existe $SRC"
    exit 1
fi

mkdir -p "$DEST/CROCO_FILES"

if [[ "$MODE" == "--todo" ]]; then
    echo "Modo: copia completa"
    rsync -av --progress "$SRC/" "$DEST/"
else
    echo "Modo: solo outputs (archivos de salida *.nc, logs, croco.in)"

    # Archivos de salida CROCO (history, averages, restart, diagnostics)
    # Excluye los inputs grandes que ya existen en D:
    rsync -av --progress \
        --include="CROCO_FILES/" \
        --include="CROCO_FILES/croco_his*.nc" \
        --include="CROCO_FILES/croco_avg*.nc" \
        --include="CROCO_FILES/croco_rst*.nc" \
        --include="CROCO_FILES/croco_dia*.nc" \
        --include="CROCO_FILES/croco_diaM*.nc" \
        --include="CROCO_FILES/croco_diags*.nc" \
        --include="croco_run.log" \
        --include="croco.in" \
        --exclude="*" \
        "$SRC/" "$DEST/"
fi

echo ""
echo "=== Sincronizacion completada ==="
DU=$(du -sh "$DEST" 2>/dev/null | cut -f1)
echo "  $DEST  ($DU)"
