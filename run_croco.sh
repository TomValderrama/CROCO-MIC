#!/bin/bash
# run_croco.sh — Lanza CROCO en una sesion tmux persistente
#
# USO:
#   ./run_croco.sh <directorio_experimento> [nprocesos]
#
# EJEMPLO:
#   ./run_croco.sh 02_runs/control_verano 6
#
# El proceso corre en tmux, por lo que:
#   - Sobrevive si se cierra la terminal
#   - Para reconectarse: tmux attach -t croco
#   - Para ver el log: tail -f <directorio>/croco_run.log

set -euo pipefail

# ── Argumentos ────────────────────────────────────────────────
RUNDIR="${1:-}"
NPROC="${2:-6}"

if [[ -z "$RUNDIR" ]]; then
    echo "ERROR: debes especificar el directorio del experimento"
    echo "Uso: $0 <directorio_experimento> [nprocesos]"
    echo "Ejemplo: $0 02_runs/control_verano 6"
    exit 1
fi

# Convertir a ruta absoluta
RUNDIR="$(realpath "$RUNDIR")"
CROCO_EXE="/mnt/d/ProyectoMsc_CROCO/croco"
LOGFILE="$RUNDIR/croco_run.log"
SESSION="croco"

# ── Verificaciones previas ─────────────────────────────────────
echo "=== Verificando configuracion ==="

if [[ ! -d "$RUNDIR" ]]; then
    echo "ERROR: directorio no existe: $RUNDIR"
    exit 1
fi

if [[ ! -f "$CROCO_EXE" ]]; then
    echo "ERROR: ejecutable no encontrado: $CROCO_EXE"
    exit 1
fi

# Buscar croco.in en el directorio de corrida
CROCOFILE=""
for f in "$RUNDIR/croco.in" "$RUNDIR"/*.in; do
    if [[ -f "$f" ]]; then
        CROCOFILE="$f"
        break
    fi
done

if [[ -z "$CROCOFILE" ]]; then
    echo "ERROR: no se encontro archivo croco.in en $RUNDIR"
    exit 1
fi

echo "  Directorio: $RUNDIR"
echo "  Ejecutable: $CROCO_EXE"
echo "  Input:      $CROCOFILE"
echo "  Procesos:   $NPROC"
echo "  Log:        $LOGFILE"
echo ""

# ── Matar sesion previa si existe ─────────────────────────────
if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "ADVERTENCIA: ya existe una sesion tmux '$SESSION'"
    read -rp "  ¿Terminarla y empezar nueva? [s/N]: " resp
    if [[ "${resp,,}" == "s" ]]; then
        tmux kill-session -t "$SESSION"
        echo "  Sesion anterior terminada."
    else
        echo "  Para reconectarte: tmux attach -t $SESSION"
        exit 0
    fi
fi

# ── Crear comando de corrida ───────────────────────────────────
INFILE_NAME="$(basename "$CROCOFILE")"

# Proteger contra OOM killer: -1000 = nunca matar este proceso
# Los hijos de mpirun heredan el oom_score_adj del shell padre en tmux
RUN_CMD="cd '$RUNDIR' && echo -1000 > /proc/self/oom_score_adj 2>/dev/null; echo '=== Iniciando CROCO ===' >> '$LOGFILE' && date >> '$LOGFILE' && mpirun -np $NPROC '$CROCO_EXE' '$INFILE_NAME' 2>&1 | tee -a '$LOGFILE'; echo '=== CROCO finalizado ===' >> '$LOGFILE'; date >> '$LOGFILE'"

# ── Lanzar en tmux ────────────────────────────────────────────
echo "=== Lanzando CROCO en sesion tmux '$SESSION' ==="
tmux new-session -d -s "$SESSION" -x 220 -y 50 "bash -c \"$RUN_CMD\""

echo ""
echo "Simulacion lanzada. Comandos utiles:"
echo "  Ver sesion en vivo:  tmux attach -t $SESSION"
echo "  Ver log:             tail -f $LOGFILE"
echo "  Desconectarse:       Ctrl+B, luego D (sin matar el proceso)"
echo "  Ver si corre:        pgrep -a croco"
echo ""
echo "IMPORTANTE: Abre croco_keep_awake.ps1 en PowerShell de Windows"
echo "para evitar que el PC se suspenda durante la simulacion."
