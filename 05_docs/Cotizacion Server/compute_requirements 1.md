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

| Recurso            | Especificación                       |
| ------------------ | ------------------------------------ |
| **Cores totales**  | ≥ 64 (2 × 32 cores)                  |
| **RAM total**      | ≥ 96 GB                              |
| **Scratch activo** | ≥ 1 TB NVMe/SSD — 2 exp. simultáneos |
| **Archival**       | ≥ 5 TB HDD                           |

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

## 12. Qué verificar al comprar hardware desde China

Comprar desde China (AliExpress o Taobao vía intermediario) es viable pero cada componente tiene su trampa específica. Esta sección tiene dos partes: qué exigir **antes y durante la compra** (sin necesidad de comandos), y cómo verificar **al recibir** el equipo armado.

---

### 12.1 Qué pedir al armador antes de comprar

Antes de que compre nada, pídele que te mande el **link exacto de cada listing de AliExpress** que va a usar. Con eso puedes revisar tú mismo las fotos, reseñas y modelo antes de que gaste un peso.

Cuando lleguen las partes y antes de armar, pídele **foto del sticker de cada componente**:
- CPU: foto del sticker del IHS (la tapa metálica) o del packaging — debe mostrar el modelo completo
- RAM: foto de la etiqueta de cada módulo
- HDDs: foto del sticker lateral de cada disco — muestra modelo, capacidad y número de serie
- SSD: foto del sticker del chip o caja

Esas fotos son tu evidencia si algo no coincide con lo prometido.

---

### 12.2 CPU — qué modelos pedir y qué evitar

Para dual-socket LGA3647 (Xeon Scalable), los modelos con mejor relación rendimiento/precio en el mercado chino de usados son:

| Modelo | Cores | Generación | Canales RAM | Estado |
|--------|-------|-----------|-------------|--------|
| Xeon Gold 6226R | 16 | Cascade Lake (2020) | 6 canales | **Recomendado** |
| Xeon Gold 6230R | 26 | Cascade Lake (2020) | 6 canales | Más cores, más caro |
| Xeon Gold 6130 | 16 | Skylake-SP (2017) | 6 canales | Aceptable, más viejo |
| Xeon Silver 4216 | 16 | Cascade Lake (2019) | 6 canales | Menor rendimiento |
| Xeon E5-2683 v4 | 16 | Broadwell (2016) | 4 canales | Evitar — muy viejo |

**Pedir:** que el listing muestre la foto del IHS de la CPU, no solo una imagen genérica.

**Red flags en el listing:**
- Precio muy por debajo del mercado para ese modelo (ej. Gold 6226R a $20 USD — no existe)
- Descripción dice "ES version" o "QS version" → Engineering Sample, clock speeds distintos, puede tener bugs de silicio no documentados
- Foto del producto es una imagen de catálogo, no del ítem real
- Vendedor con menos de 100 reseñas en ese ítem

**Cómo verificar el modelo sin comandos:** buscar el número de serie completo del sticker en **ark.intel.com** (Intel) → si el número de parte no aparece o lleva prefijo QS/ES antes del modelo → no es retail.

---

### 12.3 RAM — ECC RDIMM, no cualquier DDR4

Para LGA3647 dual-socket la RAM **debe ser DDR4 ECC RDIMM** (Registered). Si el armador compra DDR4 UDIMM normal (sin ECC, sin registro) el motherboard simplemente no arranca o arranca inestable.

**Marcas con módulos legítimos en AliExpress:**
- Samsung (sticker verde): series M393xxxxx → legítimo y frecuente en el mercado chino de usados de datacenter
- SK Hynix (sticker azul): series HMAxxxxx → legítimo
- Micron/Crucial: series MTxxxxx → legítimo

**Marcas a evitar para RAM ECC:**
- Atermiter, Kllisre, Jingsha, Jonsbo — son marcas de motherboards baratas que también venden RAM sin respaldo técnico real. Sus módulos DDR4 "ECC" suelen ser UDIMM con el pin de paridad puenteado, no RDIMM real.
- Cualquier módulo sin nombre de fabricante en la etiqueta

**Qué pedir en el listing:** que el número de parte del módulo sea buscable. Ej: `M393A2K43CB2-CVF` (Samsung 16GB DDR4 2933 ECC RDIMM) → se puede verificar en la hoja de datos de Samsung.

**Sobre los 64 GB:** para dual-socket con 6 canales por socket (12 canales totales), idealmente los módulos pueblan los canales simétricamente. Con 64 GB lo más limpio es **8 × 8 GB** (4 por socket, 2 por canal en los primeros 2 canales de cada socket). Si el armador pone 4 × 16 GB concentrados en un socket, el ancho de banda cae a la mitad.

---

### 12.4 HDDs — modelos CMR conocidos, evitar SMR

**El problema:** WD cambió algunos modelos WD Red a SMR en 2020 sin anunciarlo. Hoy la línea es confusa. Para no equivocarse, pedir modelos de las siguientes líneas que son **todas CMR sin excepción**:

| Marca | Línea | Capacidad 4 TB | Modelo específico | CMR |
|-------|-------|---------------|-------------------|-----|
| Seagate | IronWolf (NAS) | 4 TB | ST4000VN006 | ✓ |
| Seagate | IronWolf (NAS) | 6 TB | ST6000VN001 | ✓ |
| WD | Red **Plus** (NAS) | 4 TB | WD40EFPX | ✓ |
| Toshiba | N300 (NAS) | 4 TB | HDWG440UZSVA | ✓ |

**Evitar:**
- WD Red **sin** "Plus": los modelos de 2–6 TB post-2020 son SMR
- Cualquier disco "Desktop" o "PC" vendido como NAS
- Modelos sin especificación CMR/PMR en el listing

**Red flag en el listing:** precio muy bajo para la capacidad. Un IronWolf 4 TB en AliExpress debería estar entre $60–80 USD. Si está a $30 USD es reacondicionado con horas de uso, refurbished sin declarar, o SMR.

**Dato adicional:** pedir al armador que en el sticker del disco figure el modelo completo (ej. `ST4000VN006`) — con ese código verificas en el sitio de Seagate/WD que es CMR antes de que lo instale.

---

### 12.5 SSD NVMe — para 256 GB solo SO, casi cualquier TLC sirve

Para este uso (SO + código + inputs de lectura) el SSD no va a recibir escrituras masivas. Lo importante es que sea **TLC, no QLC** (mayor durabilidad) y de marca reconocida.

**Marcas con SSDs TLC legítimos de 256 GB en AliExpress:**
- Samsung (PM981a, PM9A1 — OEM de laptops, completamente funcionales)
- Western Digital (SN730, SN750 — OEM frecuente en el mercado chino)
- SK Hynix (BC501, BC511)

**Evitar:**
- Goldenfir, Kingspec, KingDian, Oscoo — controladores baratos, QLC o DRAM-less, fallas frecuentes en escrituras sostenidas
- Cualquier SSD "2280 NVMe" sin marca visible en el chip

**Cómo verificarlo sin comandos:** pedir foto del chip del SSD. Los Samsung PM981a tienen el chip claramente marcado "SAMSUNG"; los WD SN730 muestran el controlador SanDisk. Si la foto muestra un chip genérico negro sin marca → no es lo que dicen.

---

### 12.6 Motherboard — que sea server-grade real

Para dual-socket LGA3647 el motherboard es un componente caro y no hay versiones "baratas" legítimas. Las opciones reales del mercado chino de usados son:

- **Supermicro X11DAi-N / X11DPi-N**: los más comunes, bien documentados, soporte Linux nativo
- **Supermicro X11DAL-i**: versión más básica, suficiente
- **Asus Z11PA-D8**: menos común pero legítimo

**Red flag:** motherboards de marca desconocida que dicen soportar "dual Xeon" por menos de $100 USD — no existen plataformas LGA3647 baratas. Si el armador propone algo así, pedir el modelo exacto y buscarlo en Google antes de autorizar.

**Dato útil:** los Supermicro traen IPMI (acceso remoto a la BIOS y al estado del hardware por red, independiente del SO). Para un server en tu departamento al que accedes por SSH, el IPMI es muy útil — si el sistema se cuelga podés reiniciarlo remotamente sin estar físicamente ahí.

---

### 12.7 Resumen: lo que debes pedir al armador

```
Antes de comprar:
  [ ] Link de AliExpress de cada componente → revisarlos tú
  [ ] Confirmar modelo de CPU: Xeon Gold 6226R o equivalente Gen 2019–2020
  [ ] Confirmar RAM: DDR4 ECC RDIMM, Samsung/Hynix/Micron, distribución simétrica
  [ ] Confirmar HDD: Seagate IronWolf o WD Red Plus, modelo exacto CMR
  [ ] Confirmar SSD: marca reconocida TLC (no Goldenfir, no Kingspec)
  [ ] Confirmar motherboard: Supermicro X11 series o Asus Z11

Antes del armado (fotos que debes pedir):
  [ ] Sticker del IHS de cada CPU (modelo completo visible)
  [ ] Etiqueta de cada módulo de RAM (número de parte buscable)
  [ ] Sticker lateral de cada HDD (modelo + número de serie)
  [ ] Foto del chip del SSD
  [ ] Foto de la motherboard (modelo visible en el PCB o caja)

Al recibir el equipo armado:
  [ ] Verificar en ark.intel.com el modelo de CPU con el número del sticker
  [ ] Buscar número de serie de los HDDs en el registro del fabricante
  [ ] Correr memtest86+ antes de instalar el SO
```

---

Comprar desde China es viable pero cada componente tiene su trampa específica. Esta sección asume que recibes un equipo armado o partes sueltas y necesitas verificar que recibes lo prometido antes de pagar el saldo o antes de que pasen los plazos de disputa.

---

### CPU — ¿son los cores que dijeron?

**El engaño más común:** vender una CPU de menor generación o menor core count con el mismo nombre comercial ("Xeon Gold"), o CPUs remarked (borrada la serigrafía original y reimpresas con otro modelo).

**Cómo verificar:**

```bash
# Apenas enciende el equipo, en Linux:
lscpu | grep -E "Model name|CPU\(s\)|Thread|Core|Socket"

# Debe mostrar:
#   Socket(s): 2
#   Core(s) per socket: 16
#   Thread(s) per core: 2
#   CPU(s): 64   ← 2 sockets × 16 cores × 2 threads

# Para ver el modelo exacto:
cat /proc/cpuinfo | grep "model name" | head -2
```

Con el modelo exacto (ej. "Intel Xeon Gold 6226R") búscalo en **ark.intel.com** o **amd.com/products** y verifica que los cores, TDP y fecha de lanzamiento coincidan con lo ofrecido.

**Red flags:**
- `Core(s) per socket` × `Socket(s)` ≠ 32 → no son 32 cores físicos
- Modelo que no aparece en ark.intel.com → remarked
- Xeon E5 v3/v4 (Haswell/Broadwell, 2014–2016): demasiado viejo, consumo alto, rendimiento pobre para el precio

---

### RAM — el engaño más frecuente y más difícil de detectar

**El engaño:** módulos con capacidad falsa (un stick que aparece como 16 GB pero es 4 GB real con firmware manipulado), o módulos no-ECC vendidos como ECC, o módulos con errores que solo aparecen bajo carga sostenida.

**Cómo verificar:**

```bash
# Capacidad real reportada por el sistema:
free -h
# o
dmidecode -t memory | grep -E "Size|Type|Speed|Manufacturer"
```

Pero la única verificación real de errores es **memtest86+**, que corre fuera del SO:

1. Descargar `memtest86+` (booteable desde USB)
2. Correr el **Test 13 (Hammer test)** completo — tarda varias horas
3. Cero errores = módulos sanos

**Nunca lances una simulación de 10–30 días sin haber pasado memtest.** Un bit flipped en RAM mata el run silenciosamente o produce resultados físicamente incorrectos sin ningún mensaje de error.

**Red flags:**
- `dmidecode` muestra "Unknown" en fabricante → módulo sin identificación real
- Velocidad reportada inferior a lo prometido (ej. 2133 MHz en vez de 2666 MHz)
- Cualquier error en memtest → módulo defectuoso o falso

---

### HDDs — CMR vs SMR y horas de uso ocultas

**El engaño:** vender discos SMR (Shingled Magnetic Recording) como NAS-grade, o discos usados con miles de horas como nuevos.

**CMR vs SMR para este uso:**
- CMR: escrituras directas, velocidad sostenida ~150–200 MB/s → correcto para salidas CROCO
- SMR: escrituras lentas en bloques grandes (~30–50 MB/s sostenido) → inaceptable para scratch, aceptable solo para archival frío

**Cómo verificar el tipo:**

```bash
# En Linux, instalar smartmontools:
sudo apt install smartmontools

# Ver datos S.M.A.R.T. completos:
sudo smartctl -a /dev/sda

# Buscar específicamente:
sudo smartctl -a /dev/sda | grep -E "Power_On_Hours|Reallocated|Pending|Uncorrectable|Rotation"
```

| Atributo S.M.A.R.T. | Qué indica | Valor de alerta |
|---------------------|-----------|-----------------|
| `Power_On_Hours` | Horas de uso real | >20.000h = disco muy usado |
| `Reallocated_Sector_Ct` | Sectores reasignados por fallas | >0 = señal de deterioro |
| `Current_Pending_Sector` | Sectores con errores pendientes | >0 = falla inminente |
| `Offline_Uncorrectable` | Errores no corregibles | >0 = disco comprometido |

Para confirmar CMR: buscar el número de modelo exacto en el sitio del fabricante. Si no aparece o el número de serie no existe en el registro del fabricante → falso o relabeled.

**Red flags:**
- `Power_On_Hours` > 5.000 en disco "nuevo" → es reacondicionado
- Cualquier `Reallocated_Sector_Ct` > 0 → no usar como almacenamiento de datos de investigación
- Número de modelo que no aparece en WD/Seagate/Toshiba → falso

---

### SSD NVMe — TBW y tipo de celda

**El engaño:** SSDs QLC (4 bits/celda, vida útil baja) vendidos sin mencionar el tipo, o con TBW (Total Bytes Written) bajísimo para un uso de escritura continua.

Para este uso (SO + inputs, escrituras moderadas) **QLC es aceptable** porque el SSD no va a recibir escrituras masivas (los outputs van a HDD). Pero conviene saberlo.

```bash
# Ver modelo y salud del SSD:
sudo smartctl -a /dev/nvme0

# Buscar:
#   Percentage Used: X%   ← desgaste acumulado
#   Data Units Written     ← TB escritos en total
```

**Red flag:** `Percentage Used` > 10% en un SSD "nuevo" → fue usado previamente.

---

### Motherboard — que soporte las CPUs y la RAM que te venden

En dual-socket el motherboard es server-grade (no consumidor). Debe soportar:
- El socket exacto de las CPUs (ej. LGA3647 para Xeon Scalable)
- RAM ECC RDIMM (Registered) — distinto de UDIMM o LRDIMM
- El número de canales de memoria declarados

```bash
# Verificar que el motherboard reconoce todos los slots de RAM:
sudo dmidecode -t memory | grep -c "Size:.*GB"
# Debe coincidir con la cantidad de módulos instalados

# Verificar que no hay slots vacíos no declarados (afecta ancho de banda):
sudo dmidecode -t memory | grep "Size"
```

**Red flag:** slots de RAM vacíos en canales impares → ancho de banda a la mitad de lo posible. Para máximo rendimiento en CROCO los módulos deben poblar los canales de memoria simétricamente.

---

### Fuente de poder — que entregue lo que dice

Una PSU de 600W de marcas desconocidas chinas puede entregar realmente 400W bajo carga. Un dual-socket al 100% puede consumir 400–600W de peak.

**Cómo verificar bajo carga:**

```bash
# Instalar stress-ng para carga sintética:
sudo apt install stress-ng

# Correr todos los cores al 100% por 10 minutos:
stress-ng --cpu 32 --cpu-method fft --timeout 600

# Mientras corre, observar:
# - Que el equipo no se apague ni reinicie (PSU insuficiente)
# - Temperatura de CPUs con: watch -n1 "sensors | grep -E 'Core|Package'"
# - Que la temperatura se estabilice < 85°C (buen cooling)
```

Si el equipo se apaga bajo carga sostenida → PSU subdimensionada o defectuosa.

---

### Resumen: protocolo de recepción

Al recibir el equipo, antes de pagar saldo o dejar pasar el plazo de disputa:

```
Día 1 — Encender y verificar identidad del hardware
  [ ] lscpu → confirmar 2 sockets × 16 cores físicos = 32 cores
  [ ] cat /proc/cpuinfo → modelo de CPU en ark.intel.com / amd.com
  [ ] dmidecode -t memory → 64 GB reconocidos, ECC, velocidad correcta
  [ ] smartctl -a /dev/sda y /dev/sdb → S.M.A.R.T. limpio, horas < 500h
  [ ] smartctl -a /dev/nvme0 → SSD sin desgaste previo

Día 1–2 — Tests de estrés
  [ ] memtest86+ completo (Test 13, mínimo 2 pasadas) → cero errores
  [ ] stress-ng 30 min a 100% → sistema estable, temperatura < 85°C
  [ ] dd si=/dev/zero of=/mnt/hdd1/test bs=1M count=10000 → velocidad > 100 MB/s sostenida
  [ ] Confirmar que el RAID-1 queda configurado y sincronizado

Día 3 — Test funcional con CROCO
  [ ] Compilar CROCO con NProc=32 en el equipo
  [ ] Correr 3 días de simulación del control_verano
  [ ] Verificar que no hay crashes, blow-ups, ni errores numéricos
  [ ] Medir tiempo real → comparar con proyección de 16 días para control a 32 cores
```

**CPU**: pedir modelo exacto (idealmente Xeon Gold 6226R o similar Cascade Lake 2019–2020). El riesgo principal son las versiones ES/QS (Engineering Samples) que se venden como retail — se identifican porque el número de parte empieza con QS o ES en el sticker físico.

**RAM**: tiene que ser DDR4 ECC RDIMM (Registered), no UDIMM. Solo confiar en módulos Samsung, Hynix o Micron con número de parte buscable. Las marcas chinas tipo Atermiter/Kllisre venden UDIMM disfrazadas de ECC. Además, los 64 GB deben distribuirse simétricamente entre los dos sockets — si el armador los concentra todos en uno, el ancho de banda se corta a la mitad.

**HDD**: pedir modelo exacto antes de comprar. Seagate IronWolf o WD Red Plus (con la palabra Plus obligatoria). El WD Red sin Plus post-2020 es SMR y no sirve para esto.

**SSD**: para 256 GB de SO cualquier Samsung/WD/Hynix TLC sirve. Evitar Goldenfir, Kingspec y similares.

**Motherboard**: tiene que ser Supermicro X11 series o Asus Z11. No hay motherboards LGA3647 dual-socket baratas legítimas — si propone algo desconocido por menos de $100 USD, es falso.

  La acción más importante antes de que el armador avance: pedirle los links de AliExpress de cada parte antes de comprar. Con eso revisas tú mismo el listing en 10 minutos.
---

## 13. Checklist antes de lanzar simulaciones

- [ ] Recompilar CROCO con `NtileI × NtileJ = N_cores_objetivo` en `param.h`
- [ ] Verificar `croco.in` para cada duración: `ntimes`, `nwrt`, `navg`, `nrst` consistentes con `dt=30s`
- [ ] Estimar espacio en disco antes de lanzar: `ntsavg × nvars × nlev × Lm × Mm × 8 bytes`
- [ ] Correr 1 experimento de prueba (1 semana de simulación) en la plataforma destino
- [ ] Tener `sync_results_to_d.sh` (o equivalente) listo para transferir resultados
- [ ] Para NLHPC/UdeC: preparar script de restart automático por límite de walltime
- [ ] Definir directorio scratch (escritura activa) y archival (outputs finales) separados
