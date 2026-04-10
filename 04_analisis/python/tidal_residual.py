"""
Tidal decomposition and residual sea level analysis for CROCO MIC simulations.

Decomposes sea surface height (zeta) into:
  - Astronomical tidal prediction (via utide, Python equivalent of t_tide)
  - Residual sea level = zeta - tidal prediction

The residual captures sub-tidal variability (wind-driven, baroclinic, eddy-related).

NOTE on "corriente residual de marea" (reviewer comment):
  This script computes the residual of the SEA LEVEL (ζ_res).
  The barotropic residual CURRENT can be obtained two ways:
    1. Time-mean of (u, v) over the analysis period  [simplest, recommended]
    2. Geostrophic from ζ_res:
         U_geo = -(g/f) * ∂ζ_res/∂y
         V_geo =  (g/f) * ∂ζ_res/∂x
  Option 1 is implemented here. Option 2 requires proper spatial derivatives
  in meters (not degrees) and the local Coriolis parameter f.

Usage:
    Edit the CONFIG section and run in Spyder or from terminal.
"""

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import pandas as pd
import utide
from pathlib import Path


# =============================================================================
# CONFIG — edit here
# =============================================================================
HIS_FILE   = "/mnt/d/ProyectoMsc_CROCO/03_outputs/simulaciones_antiguas/ancud_bench_inv.nc"
START_DATE = "2021-07-01"     # start of simulation (YYYY-MM-DD)
DT_HOURS   = 1                # output frequency in hours
SPINUP_H   = 72               # hours to skip at start (spin-up buffer for t_tide)
REF_I      = 15               # reference grid point i (for time series plot)
REF_J      = 35               # reference grid point j
SNAP_IDX   = 540              # snapshot time index for spatial map
# =============================================================================


def load_zeta(his_file, spinup_h, dt_h):
    """Load sea surface height, skipping the spin-up period."""
    ds = xr.open_dataset(his_file, decode_times=False)
    zeta_full = ds['zeta'].values   # [time, eta_rho, xi_rho]
    lon = ds['lon_rho'].values
    lat = ds['lat_rho'].values
    ds.close()

    skip = spinup_h // dt_h
    zeta = zeta_full[skip:, :, :]
    return zeta, lon, lat


def tidal_decomposition(zeta, dt_h, lat_ref):
    """
    Decompose zeta into tidal prediction and residual at every grid point.
    Uses utide (robust to NaN — land points skipped).
    Returns zeta_tide, zeta_res (same shape as zeta).
    """
    nt, ny, nx = zeta.shape
    t = np.arange(nt) * dt_h   # time in hours

    zeta_tide = np.full_like(zeta, np.nan)
    zeta_res  = np.full_like(zeta, np.nan)

    total = ny * nx
    done = 0
    for j in range(ny):
        for i in range(nx):
            ts = zeta[:, j, i]
            if np.all(np.isnan(ts)) or np.nanstd(ts) < 1e-6:
                done += 1
                continue
            try:
                coef = utide.solve(t, ts,
                                   lat=lat_ref,
                                   method='ols',
                                   conf_int='linear',
                                   verbose=False)
                tide = utide.reconstruct(t, coef, verbose=False).h
                zeta_tide[:, j, i] = tide
                zeta_res[:, j, i]  = ts - tide
            except Exception:
                pass
            done += 1
        if (j + 1) % max(1, ny // 10) == 0:
            print(f"  utide progress: {done}/{total} ({100*done/total:.0f}%)")

    return zeta_tide, zeta_res


def barotropic_residual_current(his_file, spinup_h, dt_h):
    """
    Method 1: time-mean barotropic current (average over full analysis period).
    Returns u_mean, v_mean on rho grid [eta, xi].
    """
    ds = xr.open_dataset(his_file, decode_times=False)
    skip = spinup_h // dt_h

    # Average over all sigma levels and time → barotropic + temporal mean
    u = ds['u'].values[skip:, :, :, :]   # [t, s, eta_u, xi_u]
    v = ds['v'].values[skip:, :, :, :]   # [t, s, eta_v, xi_v]
    ds.close()

    # Average over sigma levels (barotropic)
    u_bt = np.nanmean(u, axis=1)   # [t, eta_u, xi_u]
    v_bt = np.nanmean(v, axis=1)

    # Interpolate to rho grid
    u_rho = 0.5 * (u_bt[:, :, :-1] + u_bt[:, :, 1:])
    v_rho = 0.5 * (v_bt[:, :-1, :] + v_bt[:, 1:, :])

    # Trim to common shape
    ny = min(u_rho.shape[1], v_rho.shape[1])
    nx = min(u_rho.shape[2], v_rho.shape[2])
    u_rho = u_rho[:, :ny, :nx]
    v_rho = v_rho[:, :ny, :nx]

    # Time mean
    u_mean = np.nanmean(u_rho, axis=0)
    v_mean = np.nanmean(v_rho, axis=0)
    return u_mean, v_mean


# =============================================================================
# PLOTS
# =============================================================================

def plot_timeseries(zeta, zeta_tide, zeta_res, time_vec, i, j):
    """Time series at reference point: sea level, tide, residual."""
    fig, axes = plt.subplots(3, 1, figsize=(12, 8), sharex=True)
    fig.subplots_adjust(hspace=0.1)

    series = [zeta[:, j, i], zeta_tide[:, j, i], zeta_res[:, j, i]]
    titles = ['Sea Level (ζ)', 'Tidal prediction', 'Residual (ζ − tide)']
    colors = ['k', 'steelblue', 'firebrick']

    for ax, ts, title, color in zip(axes, series, titles, colors):
        ax.plot(time_vec, ts, color=color, lw=1.2)
        ax.set_ylabel('ζ (m)', fontsize=12)
        ax.set_title(title, fontsize=12, loc='left')
        ax.axhline(0, color='0.7', lw=0.8, ls='--')
        ax.tick_params(labelsize=10)
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))

    axes[-1].set_xlabel('Date', fontsize=12)
    fig.autofmt_xdate()
    plt.tight_layout()
    return fig


def plot_residual_map(zeta_res, lon, lat, snap_idx, clim=0.5):
    """Spatial map of residual sea level at a given snapshot."""
    import cmocean
    fig, ax = plt.subplots(figsize=(8, 9))
    ny, nx = zeta_res.shape[1], zeta_res.shape[2]
    # Trim lon/lat if needed
    lx = min(lon.shape[1], nx)
    ly = min(lon.shape[0], ny)
    snap = zeta_res[snap_idx, :ly, :lx]
    cf = ax.pcolormesh(lon[:ly, :lx], lat[:ly, :lx], snap,
                       cmap=cmocean.cm.balance, vmin=-clim, vmax=clim,
                       shading='auto')
    plt.colorbar(cf, ax=ax, label='ζ residual (m)', shrink=0.7)
    ax.set_xlabel('Longitude', fontsize=12)
    ax.set_ylabel('Latitude', fontsize=12)
    ax.set_title(f'Residual sea level — snapshot t={snap_idx}', fontsize=12)
    ax.tick_params(labelsize=10)
    plt.tight_layout()
    return fig


# =============================================================================
# MAIN
# =============================================================================
if __name__ == '__main__':
    print(f"Loading: {Path(HIS_FILE).name}")
    zeta, lon, lat = load_zeta(HIS_FILE, SPINUP_H, DT_HOURS)
    nt = zeta.shape[0]
    time_vec = pd.date_range(
        pd.Timestamp(START_DATE) + pd.Timedelta(hours=SPINUP_H),
        periods=nt, freq=f'{DT_HOURS}h')
    print(f"  Analysis period: {time_vec[0].date()} → {time_vec[-1].date()} ({nt} steps)")

    lat_ref = float(np.nanmean(lat))

    print("Running tidal decomposition (utide) — this takes a few minutes...")
    zeta_tide, zeta_res = tidal_decomposition(zeta, DT_HOURS, lat_ref)

    print("Computing barotropic residual current (time mean)...")
    u_mean, v_mean = barotropic_residual_current(HIS_FILE, SPINUP_H, DT_HOURS)

    # --- Plots ---
    fig1 = plot_timeseries(zeta, zeta_tide, zeta_res, time_vec, REF_I, REF_J)
    fig2 = plot_residual_map(zeta_res, lon, lat, SNAP_IDX)
    plt.show()

    print("\nDone. Variables available:")
    print(f"  zeta      {zeta.shape}  — total sea level")
    print(f"  zeta_tide {zeta_tide.shape}  — tidal prediction")
    print(f"  zeta_res  {zeta_res.shape}  — residual")
    print(f"  u_mean    {u_mean.shape}  — barotropic residual current (time-mean)")
    print(f"  v_mean    {v_mean.shape}")
