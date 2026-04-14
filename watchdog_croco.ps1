# watchdog_croco.ps1
# Lanza CROCO desde WSL y lo relanza automaticamente si WSL crashea.
# Tras cada crash, parchea croco.in para retomar desde el ultimo restart.
#
# USO (desde PowerShell en Windows):
#   .\watchdog_croco.ps1
#   .\watchdog_croco.ps1 -RunDir "02_runs/control_invierno" -NProc 6
#
# Para correr en el filesystem nativo de Linux (recomendado, evita crashes de WSL por I/O):
#   .\watchdog_croco.ps1 -UseLinuxFS
#   .\watchdog_croco.ps1 -UseLinuxFS -RunDir "02_runs/control_invierno" -NProc 6
#
#   Antes de usar -UseLinuxFS, preparar el directorio con:
#   wsl bash /mnt/d/ProyectoMsc_CROCO/setup_linux_run.sh 02_runs/control_verano

param(
    [string]$RunDir = "02_runs/control_verano",
    [int]$NProc = 6,
    [int]$MaxRetries = 50,
    [switch]$UseLinuxFS
)

# Nombre corto del experimento (ej: "control_verano")
$ExpName = Split-Path $RunDir -Leaf

if ($UseLinuxFS) {
    # Obtener usuario de Linux (puede diferir del usuario de Windows)
    $LinuxUser = (wsl.exe whoami).Trim()
    # Filesystem nativo de Linux — sin bridge 9P, I/O directo
    $WslRunDir = "/home/$LinuxUser/croco_runs/$ExpName"
    # UNC path para que PowerShell acceda al FS de Linux
    $WslDistro = (wsl.exe -l -q | Where-Object { $_ -match '\w' } | Select-Object -First 1).Trim() -replace "`0", ""
    $WinRunDir = "\\wsl$\$WslDistro\home\$LinuxUser\croco_runs\$ExpName"
} else {
    $WslRunDir = "/mnt/d/ProyectoMsc_CROCO/$RunDir"
    $WinRunDir = "D:\ProyectoMsc_CROCO\" + ($RunDir -replace '/', '\')
}

$LogFile   = "$WinRunDir\croco_run.log"
$CrocoIn   = "$WinRunDir\croco.in"
$RstFile   = "$WinRunDir\CROCO_FILES\croco_rst.nc"
$WslScript = "/mnt/d/ProyectoMsc_CROCO/run_croco_direct.sh"

function Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$ts] $msg"
}

function PatchCrocoInForRestart {
    $lines = Get-Content $CrocoIn
    $inInitial = $false
    $patched = $false

    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match '^\s*initial:') {
            $inInitial = $true
            continue
        }
        if ($inInitial) {
            if ($lines[$i] -match '^\s+(-?\d+)\s*$') {
                $lines[$i] = '          -1'
                continue
            }
            if ($lines[$i] -match 'croco_ini\.nc') {
                $lines[$i] = $lines[$i] -replace 'croco_ini\.nc', 'croco_rst.nc'
                $inInitial = $false
                $patched = $true
            }
            if ($lines[$i] -match 'croco_rst\.nc') {
                $inInitial = $false
                $patched = $true
            }
        }
    }

    if ($patched) {
        Set-Content -Path $CrocoIn -Value $lines
        Log "croco.in actualizado: NRREC=-1, croco_rst.nc"
    } else {
        Log "ADVERTENCIA: no se pudo parchear croco.in - revisalo manualmente"
    }
}

function CrocoFinished {
    if (-not (Test-Path $LogFile)) { return $false }
    $tail = Get-Content $LogFile -Tail 10 -ErrorAction SilentlyContinue
    return ($tail -match "CROCO finalizado OK")
}

Log "=== Watchdog CROCO iniciado ==="
Log "  Experimento: $RunDir"
Log "  Procesos:    $NProc"
Log "  Max reintentos: $MaxRetries"
Write-Host ""

$attempt = 0
$consecutiveColdFails = 0   # fallos consecutivos sin rst file
$MaxColdFails = 5           # abortar si nunca llega a escribir un rst

while ($attempt -lt $MaxRetries) {
    $attempt++
    Log "--- Intento $attempt / $MaxRetries ---"

    $wslReady = $false
    for ($w = 0; $w -lt 12; $w++) {
        $test = wsl.exe echo "ok" 2>$null
        if ($test -eq "ok") { $wslReady = $true; break }
        Log "WSL no disponible aun, esperando 10s..."
        Start-Sleep -Seconds 10
    }

    if (-not $wslReady) {
        Log "ERROR: WSL no responde tras 2 minutos. Abortando."
        exit 1
    }

    Log "Lanzando CROCO..."
    $proc = Start-Process -FilePath "wsl.exe" `
        -ArgumentList "bash $WslScript $WslRunDir $NProc" `
        -PassThru -NoNewWindow -Wait

    $exitCode = $proc.ExitCode
    Log "WSL/CROCO termino con codigo de salida: $exitCode"

    if (CrocoFinished) {
        Log "CROCO finalizo correctamente. Watchdog terminando."
        exit 0
    }

    # Blow-up numerico (exit 250): no reintentar, requiere correccion manual
    if ($exitCode -eq 250) {
        Log "ERROR: CROCO tuvo BLOW UP (inestabilidad numerica)."
        Log "  -> Reducir dt en croco.in y re-sincronizar al Linux FS antes de relanzar."
        Log "Ultimo output del log:"
        Get-Content $LogFile -Tail 20 -ErrorAction SilentlyContinue | ForEach-Object { Log "  $_" }
        exit 1
    }

    # Si CROCO aborto con error de configuracion (rapido, <30s), no reintentar
    $elapsed = ((Get-Date) - $proc.StartTime).TotalSeconds
    if ($exitCode -ne 0 -and $elapsed -lt 30) {
        Log "ERROR: CROCO fallo en menos de 30s (probable error de config, no crash de WSL)."
        Log "Revisa el log y corrige antes de relanzar."
        Log "Ultimo output del log:"
        Get-Content $LogFile -Tail 15 -ErrorAction SilentlyContinue | ForEach-Object { Log "  $_" }
        exit 1
    }

    Log "CROCO no termino normalmente (crash de WSL)."

    if (-not (Test-Path $RstFile)) {
        $consecutiveColdFails++
        Log "No existe archivo de restart. Relanzando desde el inicio... (cold fail $consecutiveColdFails / $MaxColdFails)"
        if ($consecutiveColdFails -ge $MaxColdFails) {
            Log "ERROR: $MaxColdFails intentos consecutivos sin archivo de restart. Revisar memoria WSL o config."
            exit 1
        }
    } else {
        $consecutiveColdFails = 0
        Log "Archivo de restart encontrado. Preparando retomada..."
        PatchCrocoInForRestart
    }

    Log "Esperando 15s antes de relanzar..."
    Start-Sleep -Seconds 15
    Write-Host ""
}

Log "Se alcanzo el maximo de reintentos ($MaxRetries). Revisar manualmente."
exit 1
