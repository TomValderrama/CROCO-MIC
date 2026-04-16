# Requerimientos de cómputo — CROCO MIC (Mar Interior de Chiloé)

**Proyecto:** Tesis MSc — "Origin and dynamics of the Gulf of Ancud's eddy, in Chile: A numerical analysis"  
**Revisado:** abril 2026

---

## 1. Parámetros del modelo

| Parámetro | Valor |
|-----------|-------|
| Grilla | 603 × 505 (eta × xi), 42 niveles sigma |
| Puntos totales | ~305.000 puntos 2D × 42 = ~12.8 M puntos 3D |
| `dt` barotrópico | 30 s / 40 = 0.75 s |
| `dt` baroclínico | 30 s |
| Cores en benchmark | 6 |
| RAM total sistema en benchmark | 21 GB |
| **Tiempo benchmark** | **87 días para 5 meses de simulación a 6 cores** |

---

## 2. Equivalente en core-días

```
Core-días por mes simulado = (87 días × 6 cores) / 5 meses = 104.4 core-días / mes-sim
```

---

## 3. Estructura de experimentos (corregida)

| # | Experimento | Spin-up | Análisis | Total simulado | Core-días |
|---|-------------|---------|----------|---------------|-----------|
| 1 | Control verano | 2 meses | 3 meses | **5 meses** | 522 |
| 2 | Control invierno | 2 meses | 3 meses | **5 meses** | 522 |
| 3 | Sin mareas — verano | 2 meses | 1 mes | **3 meses** | 313 |
| 4 | Sin mareas — invierno | 2 meses | 1 mes | **3 meses** | 313 |
| 5 | Batimetría plana — verano | 2 meses | 1 mes | **3 meses** | 313 |
| 6 | Batimetría plana — invierno | 2 meses | 1 mes | **3 meses** | 313 |
| 7 | Vientos climatológicos — verano | 2 meses | 1 mes | **3 meses** | 313 |
| 8 | Vientos climatológicos — invierno | 2 meses | 1 mes | **3 meses** | 313 |
| 9 | Sin viento — verano | 2 meses | 1 mes | **3 meses** | 313 |
| 10 | Sin viento — invierno | 2 meses | 1 mes | **3 meses** | 313 |
| | | | | **Total** | **3.815 core-días** |

```
3.815 core-días = 91.560 core-horas
A 6 cores, secuencial: 3.815 / 6 ≈ 636 días ≈ 1.75 años
```

---

## 4. Tiempo por experimento según cores asignados

| Cores / experimento | Control (5 meses) | Sensibilidad (3 meses) |
|---------------------|--------------------|------------------------|
| 6 (benchmark) | 87 días | 52 días |
| 16 | 33 días | 20 días |
| 32 | **16 días** | **10 días** |
| 48 | 11 días | 6.5 días |
| 64 | 8 días | 5 días |

> Para cambiar el número de cores hay que recompilar CROCO: `NtileI × NtileJ = NProc` en `param.h`.
> La grilla de 603×505 escala bien hasta ~100 cores por experimento (>3.000 puntos/core).

---

## 5. Planificación óptima de corridas

Los 10 experimentos son completamente independientes entre sí: se pueden correr en paralelo sin ninguna comunicación MPI entre ellos. La estrategia óptima es agendar los trabajos más largos (controles) primero.

### Con 32 cores por experimento

#### 64 cores totales (2 simultáneos × 32 cores)

```
T =  0:  Control_V (16d)  |  Control_I (16d)
T = 16:  Sens_1   (10d)   |  Sens_2    (10d)
T = 26:  Sens_3   (10d)   |  Sens_4    (10d)
T = 36:  Sens_5   (10d)   |  Sens_6    (10d)
T = 46:  Sens_7   (10d)   |  Sens_8    (10d)
Fin: T = 56 días
```
**→ 56 días con 64 cores**

#### 96 cores totales (3 simultáneos × 32 cores)

```
T =  0:  Control_V (16d)  |  Control_I (16d)  |  Sens_1 (10d)
T = 10:  Sens_1 termina   →  inicia Sens_2 (10d)
T = 16:  Controles terminan  →  inician Sens_3 y Sens_4 (10d)
T = 20:  Sens_2 termina   →  inicia Sens_5 (10d)
T = 26:  Sens_3 termina   →  inicia Sens_6 (10d)
T = 26:  Sens_4 termina   →  inicia Sens_7 (10d)
T = 30:  Sens_5 termina   →  inicia Sens_8 (10d)
T = 36:  Sens_6 y Sens_7 terminan
T = 40:  Sens_8 termina
Fin: T = 40 días
```
**→ 40 días con 96 cores**

#### 160 cores totales (5 simultáneos × 32 cores)

```
T =  0:  Control_V | Control_I | Sens_1 | Sens_2 | Sens_3
T = 10:  Sens_1,2,3 terminan  →  inician Sens_4, Sens_5, Sens_6
T = 16:  Controles terminan   →  inician Sens_7, Sens_8
T = 20:  Sens_4,5,6 terminan  (2 slots libres → sin más trabajos)
T = 26:  Sens_7 y Sens_8 terminan
Fin: T = 26 días
```
**→ 26 días con 160 cores**

---

## 6. Especificaciones por plazo objetivo

### 6.1 Ideal: ~30 días

| Recurso | Especificación |
|---------|---------------|
| **Cores totales** | ≥ 160 (5 experimentos simultáneos × 32 cores) |
| **RAM total** | ≥ 192 GB (5 exp. × ~12 GB + SO + buffers de I/O) |
| **Scratch activo** | ≥ 2 TB rápido (NVMe o SSD) — 5 exp. escribiendo simultáneamente |
| **Archival** | ≥ 5 TB HDD |
| **I/O scratch** | ≥ 1 GB/s escritura sostenida |

### 6.2 Bueno: ~60 días

| Recurso | Especificación |
|---------|---------------|
| **Cores totales** | ≥ 64 (2 × 32 cores) |
| **RAM total** | ≥ 96 GB |
| **Scratch activo** | ≥ 1 TB NVMe/SSD — 2 exp. simultáneos |
| **Archival** | ≥ 5 TB HDD |

### 6.3 Aceptable: ~90 días

| Recurso | Especificación |
|---------|---------------|
| **Cores totales** | ≥ 32 (ya sea 2 × 16 o 1 × 32, con experimentos escalonados) |
| **RAM total** | ≥ 64 GB |
| **Scratch activo** | ≥ 800 GB NVMe/SSD |
| **Archival** | ≥ 5 TB HDD |

---

## 7. Almacenamiento detallado

### Outputs por experimento

| Tipo de archivo | Control (5 meses) | Sensibilidad (3 meses) |
|----------------|-------------------|------------------------|
| Promedios diarios 3D (8 vars × 42 niveles × 90 ó 30 días análisis) | ~130 GB | ~80 GB |
| Diagnósticos VRT, EK, EK_MLD, EDDY | ~80 GB | ~50 GB |
| Historia (salidas frecuentes, mareas) | ~100 GB | ~60 GB |
| Restarts cada 2 semanas | ~20 GB | ~15 GB |
| **Subtotal** | **~330 GB** | **~205 GB** |

### Total para los 10 experimentos

```
2 controles × 330 GB  = 660 GB
8 sensibilidades × 205 GB = 1.640 GB
Inputs compartidos (ERA5, GLORYS, TPXO10, grid) = ~150 GB
Código, config, scripts, logs = ~10 GB
─────────────────────────────────────────────────
Total outputs + datos = ~2.460 GB ≈ 2.5 TB
Margen ×1.5 (reprocesos, errores, versiones) = ~3.8 TB
Recomendación: ≥ 5 TB
```

### Diseño de storage para server propio

```
SSD NVMe 256 GB  →  Sistema operativo + código + CROCO binario + inputs activos (ERA5, GLORYS)
HDD 1 (archival) →  Outputs finales de experimentos terminados
HDD 2 (archival) →  Espejo o RAID-1 (redundancia)
```

**¿Por qué no usar el SSD como scratch?**
Con 256 GB el SSD alcanza apenas para el SO (50 GB) + inputs (150 GB). Si los outputs se escriben en el SSD puede saturarse rápido y el SSD sufre desgaste por escrituras continuas. Lo correcto es:

- Los **inputs** (ERA5, GLORYS, TPXO10, grid) viven en el SSD → lecturas rápidas al inicio de cada corrida.
- Las **salidas CROCO** (el I/O pesado) van directo a HDD.
- CROCO escribe en ráfagas cortas (1 vez por día simulado), no de manera continua. Un HDD de 7200 rpm escribe a ~150–200 MB/s, suficiente para ese patrón.

### ¿Cuántos TB de HDD?

| Configuración | Capacidad útil | Redundancia | Recomendación |
|---------------|---------------|-------------|---------------|
| 1 × 4 TB HDD | 4 TB | Ninguna | No recomendado (sin backup) |
| 2 × 4 TB RAID-1 | 4 TB | Espejo completo | Mínimo seguro |
| 2 × 6 TB RAID-1 | 6 TB | Espejo completo | **Recomendado** |
| 2 × 8 TB RAID-1 | 8 TB | Espejo completo | Cómodo con margen |
| 3 × 4 TB RAID-5 | 8 TB | 1 disco de falla | Buena relación capacidad/seguridad |

**Recomendación concreta: 2 × 6 TB RAID-1** → 6 TB útiles, proteges contra pérdida de un disco. Si los presupuestos lo permiten, **2 × 8 TB** da margen holgado para futuras corridas o datos de colaboración.

> Los HDD "de helio" (NAS-grade, llenados con helio en vez de aire) consumen menos energía, generan menos calor y tienen mayor vida útil en carga 24/7. Son la opción correcta para un servidor doméstico que correrá semanas seguidas. Buscar etiquetas como NAS, CMR (no SMR), 24/7.
> Los HDD SMR (Shingled Magnetic Recording) son baratos pero tienen escrituras lentas en bloques grandes — evitarlos para scratch o archival de uso intensivo.

---

## 8. Costo en electricidad

### Consumo estimado según configuración

| Configuración | Consumo típico en carga |
|---------------|------------------------|
| 32 cores, socket único eficiente | ~250–320 W |
| 64 cores, dual-socket o HEDT | ~450–600 W |
| 96 cores (server 2P) | ~700–900 W |
| + 2 HDD activos | +15 W cada uno (+30 W) |
| + SSD NVMe | +5–10 W |

**Tarifa eléctrica residencial Chile (abril 2026): ~$140 CLP/kWh**

### Por duración de las corridas

#### Escenario 30 días (160 cores, ~900 W total)

```
900 W × 24 h × 26 días = 562 kWh × $140 = ~78.700 CLP
```

#### Escenario 60 días (64 cores, ~500 W total)

```
500 W × 24 h × 56 días = 672 kWh × $140 = ~94.100 CLP
```

#### Escenario 90 días (32 cores, ~300 W total)

```
300 W × 24 h × 90 días = 648 kWh × $140 = ~90.700 CLP
```

> Los tres escenarios cuestan entre **78k y 95k CLP** en electricidad para las simulaciones completas. La diferencia es pequeña porque a más cores el equipo termina antes: más potencia × menos días ≈ mismo consumo total de energía.

### Costo mensual de electricidad si el server sigue encendido para análisis

```
300 W × 24 h × 30 días = 216 kWh × $140 = ~30.200 CLP / mes
500 W × 24 h × 30 días = 360 kWh × $140 = ~50.400 CLP / mes
```

---

## 9. Opciones de infraestructura

### 9.1 Cluster UdeC

**Qué solicitar al área de cómputo:**

```
Solicitud de acceso HPC — Proyecto tesis MSc Oceanografía

10 jobs MPI independientes (sin comunicación entre ellos):
  - 2 jobs "control":    32 cores / job, walltime 400 h (16 días), RAM ≥ 64 GB, scratch 400 GB
  - 8 jobs "sensibilidad": 32 cores / job, walltime 250 h (10 días), RAM ≥ 48 GB, scratch 250 GB

Total core-horas:  (2 × 32 × 400) + (8 × 32 × 250) = 25.600 + 64.000 = ~90.000 core-horas
Almacenamiento scratch total activo: ~2.5 TB
Almacenamiento archival permanente: ~4 TB

Código: CROCO 2.1.1 (ROMS-family), compilado con gfortran + OpenMPI, Linux.
```

### 9.2 NLHPC — Leftraru

**Ventajas:** gratuito para investigadores con proyecto ANID/FONDECYT. Filesystem paralelo (Lustre). Nodos con 64–128 cores y 256 GB RAM.

**Qué solicitar en el formulario de postulación:**

```
Core-horas solicitadas: 100.000 core-horas
  (margen sobre los 91.560 requeridos para reprocesos y pruebas)

Estructura:
  - 10 jobs MPI independientes (array job SLURM o PBS)
  - 32 cores / job, 1 nodo por job (--nodes=1 para latencia mínima)
  - Walltime: 240 h por job (dentro del límite estándar de Leftraru)
  - RAM: 64 GB / job
  - Scratch: 400 GB / job activo → ~4 TB scratch total

Descripción: simulaciones de circulación oceánica barotrópica-baroclínica
con modelo CROCO (ROMS-family), dominio del Mar Interior de Chiloé,
grilla 603×505×42 sigma-levels. 10 experimentos independientes para tesis
de Magíster en Oceanografía, Universidad de Concepción.
```

**Consideraciones:**
- Walltime de 240 h = 10 días. Si un control demora 16 días a 32 cores, se corre en 2 jobs encadenados usando restart (CROCO soporta hot restart automático).
- Los datos de salida (~3 TB) se transfieren con `rsync` una vez terminadas las corridas.
- Hay que solicitar acceso con carta del tutor/a.

### 9.3 Server propio

#### Configuración para plazo de 60 días (recomendada para inversión doméstica)

| Componente | Especificación | Rol |
|------------|---------------|-----|
| **CPU** | ≥ 32 cores físicos, ≥ 3 GHz, caché L3 ≥ 64 MB | 2 experimentos simultáneos × 16 cores |
| **RAM** | 128 GB DDR4/DDR5, preferible ECC si la plataforma lo permite | 2 exp. × 12 GB + SO + buffers |
| **SSD NVMe** | 256 GB | SO (50 GB) + código + inputs activos |
| **HDD × 2** | 6–8 TB cada uno, NAS-grade CMR, 7200 rpm | RAID-1 → outputs + archival |
| **PSU** | ≥ 650 W, 80+ Gold | Carga continua 24/7 |
| **Refrigeración** | Torre de alta capacidad o AIO 240 mm | TDP ≥ 200 W sostenido |
| **Factor de forma** | Tower workstation | Silencioso, sin sala dedicada |
| **Red** | 2.5 GbE | Acceso remoto SSH, transferencia de datos |

**Consumo estimado:** ~300 W → **~30.000 CLP/mes en electricidad** operando 24/7.

#### Configuración para plazo de 30 días (mayor inversión)

| Componente | Especificación |
|------------|---------------|
| **CPU** | ≥ 64 cores físicos (plataforma HEDT o dual-socket) |
| **RAM** | 256 GB ECC |
| **SSD NVMe** | 256 GB (SO + código) |
| **HDD × 2** | 8–10 TB NAS CMR cada uno, RAID-1 |
| **PSU** | ≥ 1000 W, 80+ Platinum |
| **Refrigeración** | Circuito de agua cerrado o sala con A/C |

**Consumo:** ~600–700 W → **~56.000–65.000 CLP/mes**.

---

## 10. El server propio como inversión a futuro

Un equipo con ≥32 cores y 128 GB RAM tiene vida útil de 5–8 años en investigación. Usos concretos más allá de la tesis:

### Análisis y postproceso

Con ~3 TB de salidas NetCDF, procesar con `xarray` + `dask` en un equipo con 128 GB RAM permite:
- Calcular EOF, vorticidad, EKE, climatologías sobre todos los experimentos en paralelo.
- Correr `utide` para descomposición mareal sobre el dominio completo sin subsampling.
- Generar todas las figuras del artículo y sus revisiones sin limitaciones de memoria.

### Nuevos experimentos sin burocracia

Si los revisores piden sensibilidades adicionales o meses extra, corres localmente en 1–2 semanas sin esperar turno en cola de cluster.

### Machine learning

Con una GPU añadida (planificar PCIe x16 libre + PSU holgada):
- Emuladores del modelo oceánico (surrogate ML).
- Detección de remolinos en imágenes satelitales (SST, Chl-a).
- Downscaling estadístico de forzantes.

### NAS y servidor de datos del laboratorio

- Almacenar re-análisis compartidos (ERA5, GLORYS) accesibles para todo el grupo.
- Backup centralizado de datos de otros tesistas.
- Acceso SSH remoto para colaboración.

### Software recomendado

```
SO:               Ubuntu Server LTS (sin escritorio, máximo rendimiento)
Scheduler local:  GNU parallel o SLURM single-node (gestión de los 10 jobs)
Python:           mamba + xarray, dask, matplotlib, cmocean, utide, gsw
Acceso remoto:    SSH + tmux (sesiones persistentes)
Monitoreo:        htop, iotop, Grafana + node_exporter
Transferencia:    rsync sobre SSH
```

---

## 11. Tabla comparativa final

| Opción | Cores | RAM | Plazo estimado | Costo total |
|--------|-------|-----|---------------|-------------|
| **NLHPC Leftraru** | 320+ (en cola) | 256+ GB/nodo | **30–45 días** (+ tiempos de cola) | **Gratuito** |
| **Cluster UdeC** | 64–128 (en cola) | 64–256 GB | **45–80 días** (+ tiempos de cola) | **Gratuito** |
| **Cloud Hetzner ~96 cores** | 96 dedicados | 192 GB | **~40 días** | ~200–250k CLP/mes |
| **Server propio 32 cores** | 32 dedicados | 128 GB | **~100 días** | ~1.2M CLP inversión + 30k/mes luz |
| **Server propio 64 cores** | 64 dedicados | 256 GB | **~55 días** | ~2.5M CLP inversión + 50k/mes luz |

### Recomendación según situación

| Situación | Recomendación |
|-----------|---------------|
| Tutor con proyecto ANID activo | **NLHPC primero** — gratuito, gestión de cola mediante restart automático |
| Necesitas control total y rapidez sin burocracia | **Cloud Hetzner 1–2 meses** — ~200–500k CLP fijo, luego cancelas |
| Vas a seguir en investigación (doctorado, grupo) | **Server propio 32–64 cores** — se amortiza en 2–3 proyectos |
| Necesitas correr algo puntual esta semana | **Cloud spot** — pagar solo las horas que uses |

---

## 12. Checklist antes de lanzar

- [ ] Recompilar CROCO con `NtileI × NtileJ = N_cores_objetivo` en `param.h`
- [ ] Verificar `croco.in` para cada duración: `ntimes`, `nwrt`, `navg`, `nrst` consistentes con `dt=30s`
- [ ] Estimar espacio en disco antes de lanzar: `ntsavg × nvars × nlev × Lm × Mm × 8 bytes`
- [ ] Correr 1 experimento de prueba (1 semana de simulación) en la plataforma destino
- [ ] Tener `sync_results_to_d.sh` (o equivalente) listo para transferir resultados
- [ ] Para NLHPC/UdeC: preparar script de restart automático por límite de walltime
- [ ] Definir directorio scratch (escritura activa) y archival (outputs finales) separados
