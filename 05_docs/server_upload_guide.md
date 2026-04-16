# Guía de subida al server

## 1. Configurar el script

Editar las variables al inicio de `sync_to_server.sh`:

```bash
SERVER_USER="tvalderrama"           # usuario en el server
SERVER_HOST="server.example.com"    # hostname o IP
SERVER_PATH="/home/tvalderrama/ProyectoMsc_CROCO"  # ruta destino
```

## 2. Dry-run (ver qué se transferiría)

```bash
./sync_to_server.sh
```

Revisa la lista y el tamaño estimado antes de transferir.

## 3. Transferencia real

```bash
./sync_to_server.sh --execute
```

Transferencia estimada: **~12.5 GB** (dominado por `croco_blk_mic.nc`, 11 GB).

> Si el server tiene acceso a ERA5, considera excluir `croco_blk_mic.nc` y regenerarlo
> allá con `convert_era5_to_bulk.py` para ahorrar 11 GB de transferencia.

## 4. Setup en el server (después de subir)

### 4.1 Recompilar CROCO

```bash
cd $SERVER_PATH/Compile
make clean
make
cp croco ..
```

### 4.2 Recrear symlinks en CROCO_FILES

Los symlinks que estaban en `02_runs/control_verano/CROCO_FILES/` apuntaban a rutas
absolutas de WSL (`/mnt/d/...`) y no se transfirieron. Recrearlos en el server:

```bash
cd $SERVER_PATH/02_runs/control_verano/CROCO_FILES

INPUTS="$SERVER_PATH/01_inputs/croco_files"

ln -s $INPUTS/croco_grd.nc      croco_grd.nc
ln -s $INPUTS/croco_ini_mercator_Y2020M11.nc  croco_ini.nc
ln -s $INPUTS/croco_bry_verano.nc             croco_bry.nc
ln -s $INPUTS/croco_clm.nc      croco_clm.nc
ln -s $INPUTS/croco_frc_tpxo10.nc            croco_frc.nc
ln -s $INPUTS/croco_blk_mic.nc  croco_blk.nc
```

### 4.3 Correr CROCO

```bash
cd $SERVER_PATH/02_runs/control_verano
mpirun -np <N_PROCS> ../../croco croco.in > croco_run.log 2>&1 &
```

---

## Qué se excluye y por qué

| Excluido | Razón |
|---|---|
| `croco`, `ncjoin`, `partit` | Binarios compilados para WSL — recompilar en server |
| `Compile/*.o`, `*.f`, `*.f1` | Objetos WSL |
| `tides/TPXO10_atlas_v2_nc/` | 21 GB — atlas crudo, `croco_frc_tpxo10.nc` ya generado |
| `croco_files/croco_frc_era5.nc` | 12 GB — ERA5 crudo, `croco_blk_mic.nc` ya generado |
| `forcing/era5_raw/` | Descargas crudas ERA5 |
| `CROCO_FILES/` (symlinks) | Symlinks WSL, se recrean en el server (ver 4.2) |
| `.git/` | Historia git |
| `watchdog_croco.ps1` | Solo Windows/PowerShell |
| Logs (`frc.log`, `prepro.log`, etc.) | Descartables |

## Nota sobre setup_linux_run.sh

Este script es **solo para WSL local** — copia el experimento a `~/croco_runs/` para
evitar el bridge 9P de Windows que causa crashes de I/O. En el server no aplica
(CROCO corre directamente en el filesystem nativo).
