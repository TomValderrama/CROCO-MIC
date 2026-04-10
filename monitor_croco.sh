#!/bin/bash
# monitor_croco.sh — Monitorea el progreso de una corrida CROCO
#
# USO: ./monitor_croco.sh <directorio_experimento>

RUNDIR="${1:-.}"
RUNDIR="$(realpath "$RUNDIR")"
LOGFILE="$RUNDIR/croco_run.log"

echo "=== Monitor CROCO ==="
echo "Directorio: $RUNDIR"
echo ""

# Ver si el proceso corre
if pgrep -x croco > /dev/null 2>&1; then
    PID=$(pgrep -x croco)
    echo "Estado: CORRIENDO (PID $PID)"
    # Uso de CPU y memoria
    ps -p "$PID" -o pid,pcpu,pmem,etime --no-headers 2>/dev/null | \
        awk '{printf "  CPU: %s%%  Mem: %s%%  Tiempo: %s\n", $2, $3, $4}'
else
    echo "Estado: NO hay proceso croco corriendo"
fi

echo ""

# Buscar el ultimo output en el log
if [[ -f "$LOGFILE" ]]; then
    echo "--- Ultimo output del log ($LOGFILE) ---"
    tail -20 "$LOGFILE"
    echo ""
    # Buscar lineas de tiempo del modelo (contienen el paso de tiempo actual)
    echo "--- Progreso de tiempo del modelo ---"
    grep -E "MAIN.*step|time =|Day =|STEP =" "$LOGFILE" 2>/dev/null | tail -5 || \
        echo "  (buscando lineas de progreso...)"
fi

# Ver sesion tmux
echo ""
if tmux has-session -t croco 2>/dev/null; then
    echo "Sesion tmux 'croco': ACTIVA"
    echo "  Reconectarse: tmux attach -t croco"
else
    echo "Sesion tmux 'croco': no activa"
fi
