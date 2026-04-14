#!/bin/bash
source ~/miniconda3/etc/profile.d/conda.sh
conda activate croco_env
cd /mnt/d/ProyectoMsc_CROCO/croco_pytools/prepro

echo "=== make_tides ==="
python make_tides.py mic_ancud.ini
echo "=== DONE ==="
