"""
Spin-up analysis for CROCO MIC simulations.

Calculates domain-averaged kinetic energy (KE) from CROCO history files,
applies a low-pass filter, and detects the spin-up end using two methods:
  1. Hilbert envelope: first time the relative change stays below a threshold
  2. Exponential fit: 3*tau criterion

Usage:
    Edit the CONFIG section and run in Spyder or from terminal.
"""

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from scipy.signal import butter, filtfilt, hilbert
from scipy.optimize import curve_fit
from pathlib import Path


# =============================================================================
# CONFIG — edit here
# =============================================================================
HIS_FILE   = "/mnt/d/ProyectoMsc_CROCO/03_outputs/simulaciones_antiguas/ancud_bench_inv.nc"
START_DATE = "2021-07-01"   # start date of the simulation (YYYY-MM-DD)
DT_HOURS   = 1              # output frequency in hours

# Filter & detection parameters
CUTOFF_HOURS  = 72    # low-pass cutoff (hours); removes tidal & inertial noise
BUTTER_ORDER  = 4
UMBRAL_REL    = 0.01  # 1% relative change threshold for spin-up detection
WINDOW_DAYS   = 3     # sustained stability window (days)
# =============================================================================


def lowpass(signal, dt_h, cutoff_h, order=4):
    """Zero-phase Butterworth low-pass filter."""
    fs = 1.0 / dt_h          # cycles/hour
    fc = 1.0 / cutoff_h
    Wn = fc / (fs / 2)
    Wn = np.clip(Wn, 1e-6, 1 - 1e-6)
    b, a = butter(order, Wn, btype='low')
    return filtfilt(b, a, signal)


def exp_decay(x, a, b, c):
    return a + b * np.exp(-x / c)


def compute_ke(his_file):
    """Compute domain-averaged KE from a CROCO history file."""
    ds = xr.open_dataset(his_file, decode_times=False)

    u = ds['u'].values   # [time, s_rho, eta_u, xi_u]
    v = ds['v'].values   # [time, s_rho, eta_v, xi_v]
    nt = u.shape[0]

    # Interpolate u,v to rho points
    u_rho = 0.5 * (u[:, :, :, :-1] + u[:, :, :, 1:])   # [t, s, eta, xi-1]
    v_rho = 0.5 * (v[:, :, :-1, :] + v[:, :, 1:, :])   # [t, s, eta-1, xi]

    # Trim to common shape
    nx = min(u_rho.shape[3], v_rho.shape[3])
    ny = min(u_rho.shape[2], v_rho.shape[2])
    u_rho = u_rho[:, :, :ny, :nx]
    v_rho = v_rho[:, :, :ny, :nx]

    ke = 0.5 * (u_rho**2 + v_rho**2)
    KE = np.nanmean(ke.reshape(nt, -1), axis=1)

    ds.close()
    return KE


def detect_spinup(KE, dt_h, cutoff_h, order, umbral, window_days):
    """Detect spin-up end using envelope and exponential methods."""
    # Fill NaNs
    if np.any(np.isnan(KE)):
        KE = np.where(np.isnan(KE), np.interp(
            np.where(np.isnan(KE))[0],
            np.where(~np.isnan(KE))[0],
            KE[~np.isnan(KE)]), KE)

    KE_filt = lowpass(KE, dt_h, cutoff_h, order)

    # --- Method 1: Hilbert envelope ---
    KE_env = np.abs(hilbert(KE_filt - KE_filt.mean()))
    denv = np.abs(np.diff(KE_env)) / (KE_env[1:] + 1e-12)
    pts_day = round(24 / dt_h)
    denv_smooth = np.convolve(denv, np.ones(pts_day) / pts_day, mode='same')
    window_pts = window_days * pts_day
    d_running = np.convolve(denv_smooth, np.ones(window_pts) / window_pts, mode='same')

    idx_env = np.argmax(d_running < umbral) if np.any(d_running < umbral) else None

    # --- Method 2: Exponential fit ---
    x = np.arange(len(KE_filt), dtype=float)
    idx_exp = None
    tau = None
    try:
        p0 = [KE_filt.min(), KE_filt.max() - KE_filt.min(), 50.0]
        popt, _ = curve_fit(exp_decay, x, KE_filt, p0=p0, maxfev=5000)
        tau = popt[2]
        idx_exp = min(len(KE) - 1, int(round(3 * tau)))
    except Exception:
        pass

    return KE_filt, KE_env, d_running, umbral, idx_env, idx_exp, tau


def plot_spinup(KE, KE_filt, KE_env, d_running, umbral,
                idx_env, idx_exp, tau, time_vec, dt_h):
    """Two-panel spin-up plot."""
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 7),
                                    gridspec_kw={'height_ratios': [1.2, 1]})
    fig.subplots_adjust(hspace=0.05)

    # --- Panel 1: KE ---
    ax1.plot(time_vec, KE, color='0.75', lw=1, label='KE (raw)')
    ax1.plot(time_vec, KE_filt, 'k-', lw=2, label='KE (low-pass)')
    ax1.plot(time_vec, KE_env, 'r--', lw=1.5, label='Envelope')

    if idx_env is not None:
        ax1.axvline(time_vec[idx_env], color='b', ls='--', lw=2,
                    label=f'Spin-up end (env): day {idx_env * dt_h / 24:.1f}')
    if idx_exp is not None:
        ax1.axvline(time_vec[idx_exp], color='g', ls='--', lw=2,
                    label=f'Spin-up end (exp, 3τ): day {idx_exp * dt_h / 24:.1f}')

    ax1.set_ylabel('Kinetic Energy (m² s⁻²)', fontsize=13)
    ax1.legend(fontsize=10, loc='best')
    ax1.tick_params(labelbottom=False)
    ax1.set_xlim(time_vec[0], time_vec[-1])

    # --- Panel 2: relative change ---
    t2 = time_vec[1:]
    ax2.plot(t2, d_running, 'b-', lw=2, label='Running mean |ΔEnv|/Env')
    ax2.axhline(umbral, color='r', ls='--', lw=1.5,
                label=f'Threshold ({umbral*100:.0f}%)')
    ax2.set_ylabel('Relative change', fontsize=13)
    ax2.set_xlabel('Date', fontsize=13)
    ax2.legend(fontsize=10, loc='best')
    ax2.set_xlim(time_vec[0], time_vec[-1])

    for ax in (ax1, ax2):
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
        ax.xaxis.set_major_locator(mdates.AutoDateLocator())
        ax.tick_params(labelsize=11)

    fig.autofmt_xdate()
    plt.tight_layout()
    return fig


# =============================================================================
# MAIN
# =============================================================================
if __name__ == '__main__':
    print(f"Reading: {Path(HIS_FILE).name}")
    KE = compute_ke(HIS_FILE)
    nt = len(KE)

    import pandas as pd
    time_vec = pd.date_range(START_DATE, periods=nt, freq=f'{DT_HOURS}h')

    print(f"  {nt} time steps, {nt * DT_HOURS / 24:.1f} days")

    KE_filt, KE_env, d_running, umbral, idx_env, idx_exp, tau = detect_spinup(
        KE, DT_HOURS, CUTOFF_HOURS, BUTTER_ORDER, UMBRAL_REL, WINDOW_DAYS)

    if idx_env is not None:
        print(f"  Spin-up end (envelope): day {idx_env * DT_HOURS / 24:.1f}  ({time_vec[idx_env].date()})")
    if idx_exp is not None:
        print(f"  Spin-up end (exp, 3τ): day {idx_exp * DT_HOURS / 24:.1f}  "
              f"({time_vec[idx_exp].date()}, τ = {tau * DT_HOURS:.1f} h)")

    fig = plot_spinup(KE, KE_filt, KE_env, d_running, umbral,
                      idx_env, idx_exp, tau, time_vec, DT_HOURS)
    plt.show()
