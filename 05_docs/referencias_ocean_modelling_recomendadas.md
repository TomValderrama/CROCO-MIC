# Referencias de Ocean Modelling — Diagnóstico y Recomendaciones
## Manuscrito OCEMOD-D-25-00208
## Actualizado tras leer `cas-refs.bib` completo

---

## 1. QUÉ TIENEN ACTUALMENTE EN EL BIB (referencias de Ocean Modelling)

Solo hay **5 referencias de Ocean Modelling**, y las 5 son sobre el modelo en sí, no sobre el fenómeno físico estudiado:

| Clave bib | Referencia | Por qué se cita |
|-----------|-----------|----------------|
| `Marchesiello2001` | Marchesiello, McWilliams & Shchepetkin (2001). Open boundary conditions. *Ocean Modelling* 3:1–20 | OBCs del modelo |
| `Shchepetkin2005` | Shchepetkin & McWilliams (2005). The regional oceanic modeling system (ROMS). *Ocean Modelling* 9:347–404 | Descripción del modelo |
| `Debreu2012` | Debreu et al. (2012). Two-way nesting. *Ocean Modelling* 49–50:1–21 | Técnica de anidamiento |
| `Dufois2012` | Dufois et al. (2012). SST bias in EBUSs. *Ocean Modelling* 47:113–118 | Validación SST |
| `Penven2008` | Penven et al. (2008). Software tools for oceanic regional simulations. *Ocean Modelling* | Pre/postprocesamiento |

**Diagnóstico:** Ninguna referencia de Ocean Modelling habla de dinámica de remolinos, experimentos de sensibilidad, rectificación de mareas, ni mares semi-cerrados. Esto es lo que la revista probablemente echa en falta.

---

## 2. REFERENCIAS DE OCEAN MODELLING QUE FALTA AGREGAR

### 2.1 CRÍTICAS — Deben citarse (contenido directamente relevante)

---

#### A. Zheng et al. (2023) — *Topografía rugosa y remolinos de mesoscala*
```
Zheng, K., Zhang, Z., Zhao, W., Tian, J. (2023).
The impact of rough topography on behaviors of mesoscale eddies
as revealed by submesoscale resolving simulations.
Ocean Modelling, 186, 102266.
DOI: 10.1016/j.ocemod.2023.102266
```
**Por qué es crítica:**
- Es exactamente la contraparte teórica del experimento de "batimetría plana" que realiza el paper.
- Demuestra, mediante simulaciones de alta resolución, que la topografía rugosa modifica la energía, la forma y la persistencia de los remolinos de mesoscala. Al citar este trabajo, el experimento de 150 m deja de ser una elección arbitraria y se convierte en un test explícito de la hipótesis de Zheng et al.
- **Cómo citar:** en la justificación del experimento de batimetría plana (Methods) y en Discussion al interpretar resultados.

**Entrada BibTeX a agregar al `cas-refs.bib`:**
```bibtex
@article{Zheng2023,
   author = {Zheng, Kaiwen and Zhang, Zhiwei and Zhao, Wei and Tian, Jiwei},
   title = {The impact of rough topography on behaviors of mesoscale eddies
            as revealed by submesoscale resolving simulations},
   journal = {Ocean Modelling},
   volume = {186},
   pages = {102266},
   year = {2023},
   DOI = {10.1016/j.ocemod.2023.102266},
   url = {https://www.sciencedirect.com/science/article/pii/S146350032300077X},
   type = {Journal Article}
}
```

---

#### B. Hu et al. (2024) — *Rectificación mareal en mar semi-cerrado*
```
Hu, Y., Yu, F., Si, G., Sun, F., Ren, Q. (2024).
The seasonal evolution of the Yellow Sea Cold Water Mass Circulation:
Roles of fronts, thermoclines, and tidal rectification.
Ocean Modelling, 190, 102373.
```
**Por qué es crítica:**
- Es el análogo más directo al estudio del Golfo de Ancud publicado en Ocean Modelling recientemente.
- Estudia un mar semi-cerrado (Mar Amarillo) con circulación estacional fuertemente influenciada por rectificación de mareas y frentes — exactamente el tipo de sistema que es el MIC.
- Los experimentos de sensibilidad de Hu et al. (con/sin mareas, con/sin estratificación estacional) son comparables en diseño a los del paper en revisión.
- **Cómo citar:** en la Introduction al describir el rol de la rectificación mareal en mares semi-cerrados; y en Discussion al comparar el rol de las mareas en la generación de remolinos.

**Entrada BibTeX a agregar:**
```bibtex
@article{Hu2024,
   author = {Hu, Yibo and Yu, Fei and Si, Guangcheng and Sun, Fan and Ren, Qiang},
   title = {The seasonal evolution of the {Y}ellow {S}ea {C}old {W}ater {M}ass {C}irculation:
            {R}oles of fronts, thermoclines, and tidal rectification},
   journal = {Ocean Modelling},
   volume = {190},
   pages = {102373},
   year = {2024},
   type = {Journal Article}
}
```

---

#### C. Morel et al. (2023) — *Vorticidad potencial e inestabilidad de surgencia costera*
```
Morel, Y., Morvan, G., Benshila, R., Renault, L., Auclair, F. (2023).
An "objective" definition of potential vorticity. Generalized evolution
equation and application to the study of coastal upwelling instability.
Ocean Modelling, 186, 102262.
```
**Por qué es importante:**
- Renault es co-autor → el grupo que desarrolla CROCO publica en Ocean Modelling.
- Aborda la vorticity balance en contextos costeros relevantes para la interpretación de los experimentos de sensibilidad.
- Fortifica el vínculo entre el análisis de vorticidad del paper (DIAGNOSTICS_VRT en CROCO) y la literatura publicada en la misma revista.

**Entrada BibTeX a agregar:**
```bibtex
@article{Morel2023,
   author = {Morel, Yves and Morvan, Guillaume and Benshila, Rachid and Renault, Lionel and Auclair, Francis},
   title = {An ``objective'' definition of potential vorticity. {G}eneralized evolution equation
            and application to the study of coastal upwelling instability},
   journal = {Ocean Modelling},
   volume = {186},
   pages = {102262},
   year = {2023},
   DOI = {10.1016/j.ocemod.2023.102262},
   type = {Journal Article}
}
```

---

### 2.2 RECOMENDADAS — Fortalecen el argumento científico

---

#### D. Ruan et al. (2024) — *Parameterización de remolinos de mesoscala a resolución eddy-permitting*
```
Ruan, X., Couespel, D., Lévy, M., Li, J., Wang, Y. (2024).
Combined physical and biogeochemical assessment of mesoscale eddy
parameterisations in ocean models: Eddy-induced advection at
eddy-permitting resolutions.
Ocean Modelling, 190.
```
**Por qué es relevante:**
- El modelo del paper corre a ~3 km (eddy-permitting), y Ruan et al. discuten exactamente los límites y capacidades de esta resolución para representar la dinámica de remolinos de mesoscala.
- Apoya o matiza la elección de resolución en Methods.

**Entrada BibTeX a agregar:**
```bibtex
@article{Ruan2024,
   author = {Ruan, X. and Couespel, D. and Lévy, M. and Li, J. and Wang, Y.},
   title = {Combined physical and biogeochemical assessment of mesoscale eddy
            parameterisations in ocean models: {E}ddy-induced advection at
            eddy-permitting resolutions},
   journal = {Ocean Modelling},
   volume = {190},
   year = {2024},
   type = {Journal Article}
}
```

---

#### E. Megann (2024) — *Mezcla numérica en modelo eddy-permitting con mareas*
```
Megann, A. (2024).
Quantifying numerical mixing in a tidally forced global
eddy-permitting ocean model.
Ocean Modelling, 188.
```
**Por qué es relevante:**
- Directamente relevante para el modelo del paper: eddy-permitting + forzante mareal → fuentes de mixing numérico.
- Puede usarse para contextar o justificar la resolución del modelo y los esquemas de disipación usados en CROCO.

**Entrada BibTeX a agregar:**
```bibtex
@article{Megann2024,
   author = {Megann, Alex},
   title = {Quantifying numerical mixing in a tidally forced global eddy-permitting ocean model},
   journal = {Ocean Modelling},
   volume = {188},
   year = {2024},
   type = {Journal Article}
}
```

---

## 3. REFERENCIAS RELEVANTES FUERA DE OCEAN MODELLING QUE TAMBIÉN FALTAN

Estas son de otras revistas de primera línea pero refuerzan argumentos específicos de los revisores:

| Referencia | Relevancia | Revisor que lo pide |
|-----------|-----------|-------------------|
| McWilliams (2016). *Proc. R. Soc. A*, 472:20160117 | Definición formal de submesoscala (Ro, escalas) | R#2 (crítico) |
| Badin et al. (2009). *JGR*, 114, C10021 | Remolinos en shelf seas de inestabilidad baroclínica de frentes mareales | R#2 (crítico) |
| Chelton et al. (1998). *JPO*, 28:433 | Radio de Rossby barotrópico global — para calcular Rd a 42°S | R#2 |
| Chelton et al. (2011). *Prog. Oceanogr.*, 91:167 | Revisión global de remolinos mesoscala, metodología de detección | R#2 |
| Contreras et al. (2019). *JGR Oceans*, 124:5700 | Generación de remolinos sub-superficiales off Chile | R#1 (conclusiones) |

Estos 5 se deben añadir al `cas-refs.bib` (ver entradas en `revision_bibliografica_mejorada.md`).

---

## 4. REFERENCIAS DEL BIB QUE PODRÍAN ELIMINARSE O REEMPLAZARSE

Los revisores señalaron que la introducción tiene párrafos que "can be simply removed". Estas son referencias vinculadas a esos párrafos:

| Clave bib | Referencia | Motivo para revisar |
|-----------|-----------|-------------------|
| `Williams2012` | Interface Exchange as Indicator for Eddy Heat Transport (Computer Graphics Forum) | No es oceanografía; es visualización de datos |
| `Wang2022` | Arabian Sea tropical cyclones | Completamente fuera del alcance del paper |
| `Smith2019` | Hurricane Ivan wake, Gulf of Mexico | Fuera del alcance |
| `Rysgaard2020` | Greenland shelf water masses | Poco relevante para el argumento |
| `Redondo2001` | SAR para detección de eddies | La sección de detección de eddies (L407-413) probablemente debe recortarse |
| `Correa-Ramirez2012` | TOPEX/Poseidon, MTM-SVD en SE Pacífico | Relevante para satélite, puede quedarse |
| `Rebolledo2012` | Trabajadores del salmón, Quellón (revista Polis) | No es oceanografía |
| `Vazquez2023` | Gestión costera en Chiloé (Geografía Norte Grande) | Marginalmente relevante |
| `GAJARDOCORTES2011` | Pesca artesanal Chiloé (Chungará) | No relevante para argumento físico |

La sección socioeconómica de la introducción (L316-319) probablemente es la que R#2 llama "not closely relevant to the main focus". En un paper de Physical Oceanography en Ocean Modelling, la motivación socioeconómica debe ser 1-2 oraciones al inicio o en la conclusión, no un párrafo completo en el cuerpo de la introducción.

---

## 5. PLAN DE ACCIÓN CONCRETO PARA EL BIB

### En `cas-refs.bib`:

**AGREGAR (6 entradas nuevas):**
1. `Zheng2023` — Ocean Modelling — topografía y remolinos
2. `Hu2024` — Ocean Modelling — rectificación mareal en mar semi-cerrado
3. `Morel2023` — Ocean Modelling — vorticidad potencial costera
4. `McWilliams2016` — Proc. R. Soc. A — definición submesoscala
5. `Badin2009` — JGR — inestabilidad baroclínica en shelf seas
6. `Chelton2011` — Prog. Oceanogr. — remolinos mesoscala globales

**CONSIDERAR ELIMINAR del texto principal (no necesariamente del bib):**
- Citas de `Wang2022`, `Smith2019`, `Rysgaard2020` en la Introduction
- Referencias socioeconómicas (`Rebolledo2012`, `GAJARDOCORTES2011`, `Vazquez2023`) fuera del párrafo de contexto o reducir a 1 oración

### En el texto:
- Agregar cita `\citep{Zheng2023}` en la oración que describe el experimento de batimetría plana
- Agregar cita `\citep{Hu2024}` al describir la rectificación mareal en mares semi-cerrados
- Agregar cita `\citep{McWilliams2016}` y `\citep{Badin2009}` en la discusión sobre mesoscala vs. submesoscala

---

## 6. DIAGNÓSTICO FINAL — POR QUÉ EL BIB ACTUAL ES DÉBIL EN OCEAN MODELLING

El bib actual tiene ~60 referencias con la siguiente distribución por revista:

| Revista | N citas | Tipo |
|--------|---------|------|
| JGR: Oceans | ~12 | Contexto científico |
| Ocean Modelling | 5 | Solo métodos/modelo |
| Estuarine Coast. Shelf Sci. | ~4 | Contexto regional |
| Continental Shelf Research | ~3 | Contexto regional |
| Ocean Dynamics | ~3 | Contexto |
| Ocean Science | ~3 | Contexto |
| Ciencia y Tecnología del Mar | ~5 | Contexto regional Chile |
| Otras | ~25 | Varios |

**El problema:** Las 5 citas a Ocean Modelling son todas del tipo "describimos el modelo que usamos" (ROMS, OBCs, nesting). No hay ninguna cita a Ocean Modelling que soporte un argumento científico del paper (sobre generación de remolinos, dinámica de mareas, efectos de batimetría, etc.).

**La solución:** Agregar Zheng2023 + Hu2024 + Morel2023 en el argumento científico del texto, no solo en Methods. Esto señaliza que los autores leen y conocen la literatura reciente de su propia revista de publicación.
