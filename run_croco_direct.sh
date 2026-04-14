#!/bin/bash
# run_croco_direct.sh — Corre CROCO sin tmux, bloqueando hasta que termina.
# Diseñado para ser invocado por watchdog_croco.ps1 desde PowerShell.
#
# USO:
#   bash run_croco_direct.sh <directorio_experimento> [nprocesos]
#
# EJEMPLO:
#   bash run_croco_direct.sh /mnt/d/ProyectoMsc_CROCO/02_runs/control_verano 6

set -uo pipefail

RUNDIR="${1:-}"
NPROC="${2:-6}"

# Usar ejecutable desde Linux FS si existe (evita bridge 9P, mas rapido y estable)
# Setup: bash setup_linux_run.sh <experimento>
CROCO_EXE_LINUX="$HOME/croco_runs/croco"
CROCO_EXE_MNTD="/mnt/d/ProyectoMsc_CROCO/croco"
if [[ -x "$CROCO_EXE_LINUX" ]]; then
    CROCO_EXE="$CROCO_EXE_LINUX"
else
    CROCO_EXE="$CROCO_EXE_MNTD"
fi

if [[ -z "$RUNDIR" ]]; then
    echo "ERROR: debes especificar el directorio del experimento"
    exit 1
fi

LOGFILE="$RUNDIR/croco_run.log"

if [[ ! -f "$CROCO_EXE" ]]; then
    echo "ERROR: ejecutable no encontrado: $CROCO_EXE"
    exit 1
fi

if [[ ! -f "$RUNDIR/croco.in" ]]; then
    echo "ERROR: no se encontro croco.in en $RUNDIR"
    exit 1
fi

# Intentar bajar prioridad OOM (puede fallar sin root, no es crítico)
echo -1000 > /proc/self/oom_score_adj 2>/dev/null || true

cd "$RUNDIR"

# Matar procesos MPI/CROCO colgados de corridas previas
pkill -9 -f "mpirun.*croco" 2>/dev/null || true
pkill -9 -f "croco croco.in"  2>/dev/null || true
sleep 2

echo "=== Iniciando CROCO ===" | tee -a "$LOGFILE"
date | tee -a "$LOGFILE"
echo "  Directorio: $RUNDIR" | tee -a "$LOGFILE"
echo "  Procesos:   $NPROC" | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

TMPOUT=$(mktemp)
mpirun --oversubscribe -np "$NPROC" "$CROCO_EXE" croco.in 2>&1 | tee -a "$LOGFILE" "$TMPOUT"
EXIT_CODE=${PIPESTATUS[0]}

# Detectar blow-up numerico (mpirun puede retornar 0 aunque haya blow-up)
if grep -q "BLOW UP\|ABNORMAL JOB END" "$TMPOUT" 2>/dev/null; then
    EXIT_CODE=250
fi
rm -f "$TMPOUT"

echo "" | tee -a "$LOGFILE"
if [[ $EXIT_CODE -eq 0 ]]; then
    echo "=== CROCO finalizado OK ===" | tee -a "$LOGFILE"
elif [[ $EXIT_CODE -eq 250 ]]; then
    echo "=== CROCO BLOW UP: inestabilidad numerica — reducir dt ===" | tee -a "$LOGFILE"
elif (( EXIT_CODE > 128 )); then
    SIG=$(( EXIT_CODE - 128 ))
    echo "=== CROCO terminado por SEÑAL $SIG (codigo $EXIT_CODE) ===" | tee -a "$LOGFILE"
elif [[ $EXIT_CODE -eq 15 ]]; then
    echo "=== CROCO termino con codigo 15 (SIGTERM directo o MPI_Abort) ===" | tee -a "$LOGFILE"
else
    echo "=== CROCO termino con error (codigo $EXIT_CODE) ===" | tee -a "$LOGFILE"
fi
date | tee -a "$LOGFILE"

exit $EXIT_CODE
