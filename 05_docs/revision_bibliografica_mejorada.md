# Introducción Reescrita — LaTeX listo para pegar en main.tex
## "Origin and dynamics of the Gulf of Ancud's eddy, in Chile: A numerical analysis"
## Manuscrito OCEMOD-D-25-00208 | Actualizado Mayo 2026

---

> **CÓMO USAR**
> Reemplaza líneas L274–L429 del `main.tex` (todo el bloque `\section{Introduction}`).
> Claves bib nuevas que deben agregarse al `cas-refs.bib` están listadas al final.
> Las 5 referencias metodológicas obligatorias (Shchepetkin2005, Marchesiello2001,
> Debreu2012, Penven2008, Dufois2012) aparecen en el párrafo de objetivo (§5).

---

## INTRODUCCIÓN EN LATEX

```latex
\section{Introduction}
\label{sec:introduction}

The Gulf of Ancud (GoA) is a semi-enclosed marginal sea located within
the Chiloé Inner Sea (CIS), in the southern Chilean fjord system
($\sim$41°S–44°S; Figure~\ref{fig:BathGAncud}). The basin spans
approximately 80~km in width, bounded to the north by the Chacao
Channel, to the east by Chiloé Island and the Andean fjord network,
and to the south by the narrows of the Dalcahue Channel. Observational
surveys and satellite imagery have documented a recurrent anticyclonic
eddy of 10--30~km diameter within the GoA interior
\citep{pastene2020dinamica, sotomardones2009}, yet the physical
mechanisms responsible for its generation and its seasonal variability
remain unknown. Resolving this question is a prerequisite for
understanding the transport of larvae, dissolved oxygen, and dissolved
substances in a basin where salmon aquaculture is a dominant economic
activity. The present study addresses this gap by applying a
high-resolution CROCO regional ocean model in a suite of numerical
sensitivity experiments designed to isolate the relative contributions
of tidal forcing, bathymetric complexity, and wind stress to eddy
generation in the Gulf of Ancud.

The CIS receives three primary forcings that drive its circulation.
Barotropic tides dominate the momentum budget, with M$_2$ amplitudes
exceeding 1~m and currents reaching 2--4~m~s$^{-1}$ in the Chacao
Channel \citep{caceres2003, artal2019, Aiken2008}. Wind forcing from
the Southern Hemisphere westerlies drives seasonal upwelling and
downwelling along the outer coast and within the channels, with maximum
equatorward (upwelling-favorable) winds in summer and relaxation in
winter \citep{strub2019, letelier2011}. Freshwater discharge from
rivers and glaciers imposes a permanent halocline that stratifies the
water column year-round, with surface layers dominated by modified
Subantarctic Water (mSAAW) and deeper levels by Antarctic Intermediate
Water (AAIW) \citep{silva95, sievers2006, sievers08}. The GoA is the
widest basin of the CIS and is underlain by complex bathymetry that
includes a central sill structure at approximately 150~m depth. This
combination of energetic tides, pronounced stratification, and irregular
bottom topography creates conditions dynamically comparable to other
eddy-generating semi-enclosed seas such as the Yellow Sea
\citep{Hu2024} and the Patagonian shelf \citep{Tonini2013}.

The observed diameters of 10--30~km place the Gulf of Ancud Eddy
(hereafter GAE) at the boundary between mesoscale and submesoscale
regimes, a distinction with important consequences for the physical
interpretation of its dynamics. Submesoscale features are characterized
by Rossby numbers $Ro = U/fL \sim \mathcal{O}(1)$ and are primarily
driven by mixed-layer instabilities (MLI) and frontogenesis
\citep{McWilliams2016}. At the latitude of the GoA (42°S), the Coriolis
parameter is $f \approx 9.7 \times 10^{-5}$~s$^{-1}$. Combining
velocity estimates of $U \sim 0.1$--0.3~m~s$^{-1}$ with eddy radii
of $L \sim 5$--15~km gives $Ro \approx 0.07$--0.20, placing the GAE
squarely in the quasi-geostrophic (mesoscale) regime. The baroclinic
Rossby radius, estimated as $R_d = NH/f$ with representative buoyancy
frequency $N \sim 5 \times 10^{-3}$~s$^{-1}$ and pycnocline depth
$H \sim 200$~m, gives $R_d \approx 10$--25~km --- comparable to the
observed eddy diameters and consistent with mesoscale dynamics
\citep{Chelton2011}. Importantly, the eddy cores are consistently
located at 50--200~m depth, well below the seasonal mixed layer depth
of 30--50~m in summer, which excludes MLI as a primary generation
mechanism. \citet{Badin2009} showed that even shelf-sea eddies at
scales approaching $R_d$ remain quasi-geostrophic when their formation
is controlled by baroclinic instability of tidal fronts rather than
by mixed-layer dynamics. We therefore classify the GAE as a mesoscale
eddy governed by quasi-geostrophic dynamics, while acknowledging that
the smallest detected features approach the submesoscale boundary.

Four mechanisms are known to generate mesoscale eddies in semi-enclosed
coastal seas: (1)~baroclinic instability of density fronts and tidal
mixing interfaces \citep{Badin2009}; (2)~flow-bathymetry interaction
at headlands, canyons, and sills \citep{yangwang2013}; (3)~tidal
rectification, whereby nonlinear advection of oscillatory tidal currents
produces a time-mean residual vorticity \citep{zimmerman1981,
Robinson1981}; and (4)~wind-driven current instabilities modulated by
seasonal wind reversals. Tidal rectification is particularly effective
in basins where strong tidal flow interacts with abrupt topographic
features: the nonlinear tidal residual can organize into persistent
coherent eddies with diameters comparable to $R_d$ \citep{Hu2024}.
Bathymetric roughness modulates this process by redistributing tidal
kinetic energy and providing additional sources of relative vorticity
through bottom form stress; smooth or flat topography has been shown to
suppress eddy formation even when tidal forcing is maintained
\citep{Zheng2023}. To test these mechanisms in the GoA, we run four
experiments for both a summer (January) and a winter (July) month: a
control simulation (CTR) with full forcing, a no-tides experiment (NT),
a flat-bathymetry experiment (FB) in which the seafloor is set to a
uniform depth of 150~m corresponding to the mean depth of the GoA
interior, and a climatological-wind experiment (CW) using
time-invariant monthly-mean ERA5 wind fields.

The objective of this study is to quantify the contributions of tidal
forcing, bathymetric complexity, and wind stress to the origin and
seasonal variability of the Gulf of Ancud Eddy using the CROCO regional
ocean model \citep{Shchepetkin2005, Marchesiello2001, Debreu2012,
Penven2008, Dufois2012}. Specifically, we address three questions:
(1)~which forcing mechanism is primarily responsible for generating the
GAE?; (2)~does the eddy exhibit consistent seasonal differences in
occurrence, size, and intensity between summer and winter?; and
(3)~is the GAE a robust feature of the mean CIS circulation or a
transient response to specific forcing conditions? The paper is
organized as follows: Section~\ref{sec:methods} describes the numerical
model configuration and experimental design; Section~\ref{sec:results}
presents eddy detection results across sensitivity experiments;
Section~\ref{sec:discussion} discusses the physical interpretation; and
Section~\ref{sec:conclusions} summarizes the main findings.
```

---

## FIGURAS — cambios respecto al texto original

| Figura actual | Acción |
|--------------|--------|
| `ubicación` (Fig. 1 — mapa de ubicación global) | **ELIMINAR** — integrar como inset en `BathGAncud` |
| `mapa` (Fig. 2 — distribución global de fiordos) | **ELIMINAR** — no es relevante para el argumento |
| `BathGAncud` (Fig. 3 — batimetría del GoA) | **CONSERVAR** — es la única figura que referencia la intro |

Asegúrate de que el entorno `figure` de `BathGAncud` tenga `\label{fig:BathGAncud}`.

---

## ENTRADAS BIBTEX — agregar a `cas-refs.bib`

Las siguientes 5 entradas no están en el bib actual y deben agregarse.
`Aiken2008` ya existe con datos correctos; las otras 5 son nuevas.

### Aiken2008 — YA EXISTE en el bib con datos correctos
Clave: `Aiken2008` (A mayúscula). JGR: Oceans 113, C8. DOI confirmado.
No tocar.

### McWilliams2016 — NUEVA
```bibtex
@article{McWilliams2016,
   author  = {McWilliams, James C.},
   title   = {Submesoscale currents in the ocean},
   journal = {Proceedings of the Royal Society A},
   volume  = {472},
   pages   = {20160117},
   year    = {2016},
   DOI     = {10.1098/rspa.2016.0117},
   type    = {Journal Article}
}
```

### Badin2009 — NUEVA
```bibtex
@article{Badin2009,
   author  = {Badin, Gualtiero and Williams, Richard G. and Holt, Jason T.
              and Fernand, Liam J.},
   title   = {Are mesoscale eddies in shelf seas formed by baroclinic
              instability of tidal fronts?},
   journal = {Journal of Geophysical Research: Oceans},
   volume  = {114},
   pages   = {C10021},
   year    = {2009},
   DOI     = {10.1029/2009JC005340},
   type    = {Journal Article}
}
   ```

### Chelton2011 — NUEVA
```bibtex
@article{Chelton2011,
   author  = {Chelton, Dudley B. and Schlax, Michael G. and Samelson, Roger M.},
   title   = {Global observations of nonlinear mesoscale eddies},
   journal = {Progress in Oceanography},
   volume  = {91},
   pages   = {167--216},
   year    = {2011},
   DOI     = {10.1016/j.pocean.2011.01.002},
   type    = {Journal Article}
}
```

### Zheng2023 — NUEVA (Ocean Modelling)
```bibtex
@article{Zheng2023,
   author  = {Zheng, Kaiwen and Zhang, Zhiwei and Zhao, Wei and Tian, Jiwei},
   title   = {The impact of rough topography on behaviors of mesoscale eddies
              as revealed by submesoscale resolving simulations},
   journal = {Ocean Modelling},
   volume  = {186},
   pages   = {102266},
   year    = {2023},
   DOI     = {10.1016/j.ocemod.2023.102266},
   type    = {Journal Article}
}
```

### Hu2024 — NUEVA (Ocean Modelling)
```bibtex
@article{Hu2024,
   author  = {Hu, Yibo and Yu, Fei and Si, Guangcheng and Sun, Fan and Ren, Qiang},
   title   = {The seasonal evolution of the {Y}ellow {S}ea {C}old {W}ater {M}ass
              {C}irculation: {R}oles of fronts, thermoclines, and tidal rectification},
   journal = {Ocean Modelling},
   volume  = {190},
   pages   = {102373},
   year    = {2024},
   type    = {Journal Article}
}
```

---

## CORRECCIONES RESPECTO A BORRADORES ANTERIORES

| Cambio | Motivo |
|--------|--------|
| `Aiken2008` agregado en §2 junto a `caceres2003` y `artal2019` | Confirmado en bib: JGR 2008, mareas del CIS con ROMS — directamente relevante |
| `Combes2015` **eliminado** del mecanismo (4) en §4 | Combes2015 es sobre ITEs subsuperficiales del PCUC off Perú-Chile (10–35°S), no sobre vientos en el GoA |
| `Chaigneau2005` **no usado** en la intro | Eddies del sistema Perú-Chile a 10–35°S, demasiado al norte para ser analogía del GoA a 42°S |
| Mecanismo (4) re-redactado sin cita forzada | Se describe el experimento CW directamente; la referencia vendría de la literatura de sensibilidad a vientos si se encuentra una apropiada |

---

## CLAVES BIB USADAS EN LA INTRO — resumen de confirmación

| Clave | Estado | Paper |
|-------|--------|-------|
| `pastene2020dinamica` | ✅ en bib | Evidencia observacional del eddy |
| `sotomardones2009` | ✅ en bib | Circulación CIS |
| `caceres2003` | ✅ en bib | Flujo en Canal de Chacao |
| `artal2019` | ✅ en bib | Energía mareal CIS |
| `Aiken2008` | ✅ en bib | Mareas barótropas CIS con ROMS |
| `strub2019` | ✅ en bib | Vientos y surgencia SE Pacífico |
| `letelier2011` | ✅ en bib | Circulación costera S Chile |
| `silva95` | ✅ en bib | Masas de agua CIS |
| `sievers2006` | ✅ en bib | Masas de agua CIS |
| `sievers08` | ✅ en bib | Masas de agua CIS |
| `Hu2024` | ⬜ NUEVA | Ocean Modelling — rectificación mareal Mar Amarillo |
| `Tonini2013` | ✅ en bib | Shelf patagónico (usar capital T) |
| `McWilliams2016` | ⬜ NUEVA | Submesoscale definition |
| `Chelton2011` | ⬜ NUEVA | Global mesoscale eddies |
| `Badin2009` | ⬜ NUEVA | Baroclinic instability shelf seas |
| `yangwang2013` | ✅ en bib | Eddies mareales Puget Sound |
| `zimmerman1981` | ✅ en bib | Rectificación mareal |
| `Robinson1981` | ✅ en bib | Teoria de eddies mareales |
| `Zheng2023` | ⬜ NUEVA | Ocean Modelling — topografía y eddies |
| `Shchepetkin2005` | ✅ en bib | ROMS (obligatoria) |
| `Marchesiello2001` | ✅ en bib | OBCs (obligatoria) |
| `Debreu2012` | ✅ en bib | Two-way nesting (obligatoria) |
| `Penven2008` | ✅ en bib | Software tools (obligatoria) |
| `Dufois2012` | ✅ en bib | SST bias (obligatoria) |
