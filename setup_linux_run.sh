#!/bin/bash
# setup_linux_run.sh — Copia el directorio de corrida al filesystem nativo de Linux.
# Esto evita el bridge 9P (/mnt/d/) que causa crashes de WSL por I/O.
#
# USO:
#   bash setup_linux_run.sh 02_runs/control_verano
#   bash setup_linux_run.sh 02_runs/control_invierno
#
# Luego correr desde PowerShell:
#   .\watchdog_croco.ps1 -UseLinuxFS -RunDir "02_runs/control_verano"

set -euo pipefail

RUNDIR_REL="${1:-02_runs/control_verano}"
EXP_NAME=$(basename "$RUNDIR_REL")
SRC="/mnt/d/ProyectoMsc_CROCO/$RUNDIR_REL"
DEST="$HOME/croco_runs/$EXP_NAME"
CROCO_SRC="/mnt/d/ProyectoMsc_CROCO/croco"
CROCO_DEST="$HOME/croco_runs/croco"

echo "=== Setup Linux FS para experimento: $EXP_NAME ==="
echo "  Origen:  $SRC"
echo "  Destino: $DEST"

# Verificar que existe el directorio fuente
if [[ ! -d "$SRC" ]]; then
    echo "ERROR: no existe el directorio $SRC"
    exit 1
fi

# Crear directorio base si no existe
mkdir -p "$HOME/croco_runs"

# Copiar ejecutable CROCO (solo si no existe o es más nuevo)
if [[ ! -f "$CROCO_DEST" ]] || [[ "$CROCO_SRC" -nt "$CROCO_DEST" ]]; then
    echo "Copiando ejecutable CROCO..."
    cp "$CROCO_SRC" "$CROCO_DEST"
    chmod +x "$CROCO_DEST"
    echo "  OK: $CROCO_DEST"
else
    echo "  Ejecutable ya actualizado: $CROCO_DEST"
fi

# Si ya existe el destino, preguntar si sobreescribir
if [[ -d "$DEST" ]]; then
    echo ""
    echo "ADVERTENCIA: $DEST ya existe."
    read -r -p "  ¿Sobreescribir? (s/N): " resp
    if [[ ! "$resp" =~ ^[sS]$ ]]; then
        echo "Abortado."
        exit 0
    fi
    rm -rf "$DEST"
fi

# Copiar directorio de corrida completo
echo "Copiando directorio de corrida (puede tardar por los NetCDF de entrada)..."
cp -r "$SRC" "$DEST"

# Verificar que croco.in existe
if [[ ! -f "$DEST/croco.in" ]]; then
    echo "ERROR: no se encontro croco.in en $DEST"
    exit 1
fi

# Mostrar tamaño
DU=$(du -sh "$DEST" 2>/dev/null | cut -f1)
echo ""
echo "=== Listo ==="
echo "  Directorio: $DEST  ($DU)"
echo "  Ejecutable: $CROCO_DEST"
echo ""
echo "Ahora correr desde PowerShell:"
echo "  .\\watchdog_croco.ps1 -UseLinuxFS -RunDir \"$RUNDIR_REL\" -NProc 4"
