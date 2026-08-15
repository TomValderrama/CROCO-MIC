# Comparación: Introducción Actual vs. Propuesta Mejorada
## Documento de análisis de diferencias para respuesta a revisores
### Manuscrito OCEMOD-D-25-00208 | Oct 2025

---

> **CONVENCIONES DE MARCADO**
> - 🔴 PROBLEMA — deficiencia identificada por los revisores
> - 🟡 RETENER — contenido que puede quedarse con ajuste menor
> - 🟢 AGREGAR — contenido nuevo que resuelve comentarios de revisores
> - 🔵 MOVER — contenido útil pero que debe reubicarse (no eliminar)
> - ❌ ELIMINAR — contenido que los revisores piden quitar explícitamente

---

## BLOQUE 1 — Apertura de la introducción (≈ L1–L50)

### ESTADO ACTUAL
🔴 **Problema (Reviewer #2):** El tema central del estudio — los remolinos del Golfo de Ancud —
solo aparece claramente alrededor de la **línea 154**. Las primeras ~150 líneas tratan contexto
general de remolinos oceánicos de manera general y poco relevante.

🔴 **Problema (Reviewer #1):** La introducción "tries to review ocean eddies but does a poor job.
The content is poorly organized. Most of the paragraphs in the introduction can be simply removed."

| Lo que hay ahora | Lo que debe haber |
|-----------------|-------------------|
| Revisión general larga de remolinos oceánicos de escala global | Una o dos oraciones que anclen el problema en el Golfo de Ancud **desde la primera línea** |
| Información de contexto global no directamente relevante | Descripción compacta del sistema MIC/CIS y por qué es científicamente interesante |
| La pregunta de investigación emerge muy tarde | La pregunta de investigación en el párrafo 1 |

### QUÉ HACER
🟢 Reemplazar el párrafo 1 con la **apertura propuesta** en `revision_bibliografica_mejorada.md`.
La nueva apertura nombra el Golfo de Ancud en la primera oración, establece el contexto de
mares semi-cerrados con tides+viento+batimetría, y termina con la laguna de conocimiento
que el paper llena. Esto sigue el estándar de Ocean Modelling.

**Por qué es mejor:** Los revisores necesitan ver el "hook" del paper en 30 segundos.
Un lector que llega a L154 para entender de qué trata el paper va a rechazarlo.
La Sección 1 propuesta hace esto en ~200 palabras.

---

## BLOQUE 2 — Definición y clasificación de remolinos (actual: no existe explícitamente)

### ESTADO ACTUAL
🔴 **Problema crítico (Reviewer #2, pregunta 1):** "The eddies (shown in Figure 1a,12) could
fall in the submesoscale regime since their diameters are 10-30 km. Submesoscale eddies are
generally affected by dynamics different from mesoscale, e.g., mixed layer instabilities, and
would change the physical explanations of the results. Do the authors agree that the eddies
they detect could fall in the submesoscale range?"

Este es el **comentario científico más importante** de la revisión. Si no se contesta
rigurosamente, el paper corre riesgo de rechazo en la re-revisión.

| Lo que hay ahora | Lo que debe haber |
|-----------------|-------------------|
| No hay discusión del régimen dinámico (mesoscala vs submesoscala) | Sección dedicada que calcula Ro = U/fL y Rd, y argumenta el régimen |
| Los eddies se describen como "mesoscale" sin justificación formal | Justificación cuantitativa basada en Ro, Rd y profundidad de los cores |
| No se citan McWilliams (2016) ni Badin et al. (2009) | Ambas referencias esenciales incluidas |

### QUÉ HACER
🟢 Insertar la **Sección 1 completa** de `revision_bibliografica_mejorada.md` como un
párrafo nuevo después de la apertura. El argumento es:

1. **Definición**: Submesoscala → Ro ~ O(1), escala 0.1–10 km, impulsado por inestabilidades
   de la capa de mezcla (McWilliams 2016). Mesoscala → Ro << 1, cuasi-geostrófico (Chelton 2011).

2. **Cálculo para el Golfo de Ancud** (42°S, f ≈ 9.7×10⁻⁵ s⁻¹):
   - U ~ 0.1–0.3 m/s, L ~ 10–15 km → Ro ≈ 0.07–0.20 → quasi-geostrófico
   - Rd estimado: 10–25 km → los eddies son comparables a Rd → mesoscala
   - Cores sub-superficiales (50–200 m) → por debajo de la capa de mezcla → no mixed layer instability

3. **Conclusión**: régimen mesoscala; las más pequeñas (10–15 km) están en el límite
   pero siguen siendo quasi-geostroficas dado el Ro calculado.

**Por qué es mejor:** Convierte una debilidad crítica en una fortaleza. Al hacer el cálculo
explícito, el paper demuestra que los autores son conscientes de la discusión y tienen
argumentos cuantitativos para responderla. Badin et al. (2009) — único paper que estudia
exactamente esta pregunta en shelf seas — debe citarse obligatoriamente.

---

## BLOQUE 3 — Revisión de mecanismos de generación de remolinos

### ESTADO ACTUAL
🔴 **Problema (Reviewer #1):** La revisión de mecanismos de generación es de mala calidad,
desorganizada y con párrafos que "can be simply removed."

🟡 **Contenido que puede existir:** Probablemente el texto actual menciona inestabilidad
baroclínica, tides y viento, pero sin estructura clara ni ejemplos del contexto costero/fjord.

| Problema actual | Solución propuesta |
|----------------|-------------------|
| Mecanismos listados sin jerarquía ni contexto | Estructura en 4 sub-temas con transición lógica entre ellos |
| Citas generales de océano abierto | Citas específicas de mares costeros + ejemplos chilenos |
| No se justifica por qué se estudia cada mecanismo | Cada mecanismo termina con una oración que lo conecta al diseño experimental |

### QUÉ HACER
🟢 Reemplazar con la **Sección 2** de `revision_bibliografica_mejorada.md`. Estructura:
1. Inestabilidad baroclínica (general → shelf seas → Badin 2009)
2. Interacción flujo-batimetría (Signell & Geyer 1991, Dong et al. 2007)
3. Rectificación de mareas (Zimmerman 1978, Signell & Geyer 1991)
4. Forzante del viento (Strub 1998, ERA5)
5. Por qué las inestabilidades de capa de mezcla NO dominan aquí (responde R#2)

**Por qué es mejor:** Cada mecanismo está conectado directamente con un experimento de
sensibilidad del paper. El lector entiende de inmediato por qué el diseño experimental es
el que es. Además, Badin (2009) aparece aquí como evidencia de que incluso en shelf seas
de pequeña escala el régimen puede ser quasi-geostrófico.

---

## BLOQUE 4 — Contexto regional: oceanografía del MIC/CIS

### ESTADO ACTUAL
🟡 **Probablemente existe pero es demasiado largo o con información no relevante.**
🔴 **Reviewer #2:** "The Introduction is lengthy and includes background information that is not
closely relevant to the main focus of the study."

| Problema actual | Solución propuesta |
|----------------|-------------------|
| Descripción detallada de todo el CIS incluyendo el Golfo de Corcovado | Solo lo relevante para el Golfo de Ancud y para entender las forzantes |
| Quizás incluye historia geológica o biología | Eliminar: solo física relevante para generación de remolinos |
| Figures 1 y 2 son demasiado generales (Reviewer #2) | Consolidar en Figure 3 o eliminar F1; eliminar F2 |

### QUÉ HACER
🟢 Usar la **Sección 3** de `revision_bibliografica_mejorada.md`. Puntos clave:
- 3 forzantes principales: tides (Aiken 2008) + viento (Strub 1998) + freshwater (Sievers 1975)
- Mencionar M21 (Mardones et al. 2021) como referencia directa previa a este estudio
- Reducir a ~200–250 palabras

❌ **Eliminar según R#2:**
- Figure 1 → integrar en Figure 3 (añadir inset de ubicación global)
- Figure 2 (distribución global de fiordos) → no es relevante para este paper
- Figure 5 (de otro estudio) → reemplazar con cita a Allel (2020): "Circular motions in the Gulf of Ancud have been documented previously (Allel, 2020)"

**Por qué es mejor:** La introducción compacta muestra que los autores conocen la diferencia
entre "contexto necesario" y "enciclopedia". Ocean Modelling valora la concisión.

---

## BLOQUE 5 — Descripción de experimentos (actualmente en Methods)

### ESTADO ACTUAL
🟡 La elección de 150 m de profundidad en el experimento de batimetría plana no está
justificada en el texto (Reviewer #2: "Why choose 150 m? Is it related to mixed layer depth?")
🟡 La definición de "vientos climatológicos" no está clara (Reviewer #2: "Is it time-invariant
over the whole month? Or does it vary?")

| Problema | Solución |
|----------|---------|
| 150 m no justificado | Agregar oración: "This depth corresponds to the approximate pycnocline depth..." |
| Vientos climatológicos ambiguos | Aclarar: "monthly-mean ERA5 wind fields for January/July, applied as time-invariant forcing" |

### QUÉ HACER
🟢 Usar la **Sección 4** de `revision_bibliografica_mejorada.md` para justificar el diseño
experimental ya sea en la Introducción (última parte) o en el inicio de Methods.
También citar Leth (2004) y Contreras et al. (2019) para mostrar que este tipo de
experimentos de sensibilidad tiene precedente en la literatura chilena.

---

## BLOQUE 6 — Limitaciones estadísticas (actualmente ausente)

### ESTADO ACTUAL
🔴 **Reviewer #2 (pregunta 7):** "The number of eddies identified in each experiment is only
2–4, which raises the question of whether these counts would diverge in longer simulations.
This is a notable limitation of the study, and I would appreciate a more detailed explanation
and/or an extension of the simulations to address this concern."

❌ Actualmente no hay discusión de limitaciones estadísticas en el manuscript.

### QUÉ HACER
🟢 Agregar un párrafo breve en la introducción (último párrafo antes de outline) y una
subsección en Discussion usando la **Sección 5** de `revision_bibliografica_mejorada.md`.
El argumento es honesto: n=2–4 es pequeño, pero el análisis es cualitativo (presencia/ausencia),
y la consistencia entre verano e invierno duplica la evidencia. Citar Chelton et al. (2011)
para establecer que incluso en estudios globales con miles de eddies se discute este punto.

**Por qué es mejor:** Nombrarlo como limitación explícita convierte una crítica del revisor
en una fortaleza metodológica. Los revisores aprueban más fácilmente papers que son
honestos sobre sus limitaciones que los que no las reconocen.

---

## RESUMEN DE CAMBIOS — Tabla de acciones

| # | Bloque | Acción | Urgencia | Responde a |
|---|--------|--------|----------|------------|
| 1 | Párrafo de apertura | REEMPLAZAR | 🔴 Alta | R#1 + R#2 |
| 2 | Submesoscala vs mesoscala | INSERTAR NUEVO | 🔴 Alta | R#2 (crítico) |
| 3 | Mecanismos de generación | REESTRUCTURAR | 🔴 Alta | R#1 |
| 4 | Contexto regional MIC | ACORTAR + ENFOCAR | 🟡 Media | R#2 |
| 5 | Figuras 1, 2, 5 | ELIMINAR/CONSOLIDAR | 🟡 Media | R#2 |
| 6 | Justificación de 150 m | AGREGAR 1-2 oraciones | 🟡 Media | R#2 |
| 7 | Definición vientos climatológicos | CLARIFICAR en Methods | 🟡 Media | R#2 |
| 8 | Limitaciones estadísticas | AGREGAR en Discussion | 🟡 Media | R#2 |
| 9 | Número de Rossby Ro=U/fL | CALCULAR Y REPORTAR | 🔴 Alta | R#1 (indirecto) |
| 10 | Edición de lenguaje L87, L608, L654 | CORRECCIONES MENORES | 🟢 Baja | R#2 editorial |

---

## ESTIMACIÓN DE IMPACTO EN LONGITUD DE INTRODUCCIÓN

| Bloque | Palabras actuales (estimado) | Palabras propuestas |
|--------|------------------------------|---------------------|
| Apertura general | ~300 | ~150 |
| Sub/mesoscala (ausente) | 0 | ~300 |
| Mecanismos | ~500 | ~400 |
| Contexto MIC | ~400 | ~200 |
| Diseño experimental justificación | 0 | ~150 |
| **Total** | **~1200** | **~1200** |

La introducción no necesita acortarse en términos de palabras totales, sino **reorganizarse**:
mover el foco hacia el Golfo de Ancud desde el principio y eliminar la revisión genérica
de remolinos que no aporta al argumento del paper.
