# Auditoría de backlogs — slep_*

Fecha: 2026-06-29
Proyectos auditados: 16
Con backlog: 7 | Sin backlog: 9

> Diagnóstico estructural puro (solo lectura, R1–R4). Se buscaron archivos
> `*backlog*.md` (sin `_volcado_crudo`) dentro de `50_documentacion/` de cada
> hermano (o, si no existe, en la raíz excluyendo `_archivo/`, `.git/`, `renv/`,
> `20_insumos/`, `40_salidas/`). De cada archivo se leyeron las primeras 150
> líneas y se extrajeron sus encabezados `##`/`###`. Ningún archivo superó el
> umbral de 200K, así que todos se leyeron. No se sintetiza ni se propone
> contenido: solo se describe el estado de los archivos.

## Resumen ejecutivo

De 16 proyectos hermanos, **solo 7 mantienen un archivo backlog** y los 9
restantes no tienen ninguno. Entre los 7 que sí lo tienen, la estandarización
es **baja**: el archivo "vivo" aparece bajo **cuatro nombres distintos** para el
mismo artefacto —`backlog_consolidado` (aprendizajes_ep, categoria_desempeno,
seguimiento_educacion_inicial), `backlog_historico` (idps, simce_adecuado),
`backlog_acumulativo` (reportes_modelo_resguardo_asistencia) y `backlog_acumulado`
(monitoreo)— y casi siempre vive en `50_documentacion/activa/`, salvo
`slep_monitoreo`, que lo aloja en `50_documentacion/traspasos/`.

Las cinco secciones canónicas (Objetivo del proyecto, Nota metodológica,
Clasificación temática, Resumen estadístico por sesión, Detalle cronológico)
aparecen completas y reconocibles en tres proyectos
(**monitoreo**, **reportes_modelo_resguardo_asistencia** y
**seguimiento_educacion_inicial**), parcialmente en dos
(**categoria_desempeno** e **idps**, con el Detalle cronológico probablemente
más abajo de la línea 150), y **no aparecen con su naming canónico** en dos
(**aprendizajes_ep** y **simce_adecuado**), cuyos backlogs se reconstruyeron con
estructuras a la medida (numeración nueva + mapa de regímenes; o "Taxonomía
vigente" + sesiones como encabezados `##`). Hay además variación de forma menor:
encabezados numerados (`## 1. Objetivo…`) versus sin numerar, sufijos
(`(permanente)`, `del conteo`, `acumulada`) y orden de secciones invertido entre
Clasificación temática y Resumen estadístico.

Por último, varios proyectos acompañan el backlog vivo con **anexos o logs de
consolidación** que no son el backlog en sí: anexos "verbatim/extracción cruda"
y "log de decisiones" en `activa/` (aprendizajes_ep), o logs de reconstrucción y
una instrucción de construcción en `andamios/` (idps, simce_adecuado,
reportes_modelo_resguardo_asistencia). Esto confirma que los backlogs no nacieron
estandarizados sino que en varios casos fueron reconstruidos a posteriori, cada
uno con su propia convención.

## Por proyecto

### slep_aprendizajes_ep
- Archivos encontrados:
  - `50_documentacion/activa/backlog_consolidado.md` (40.226 bytes)
  - `50_documentacion/activa/backlog_consolidado_anexo_extraccion_cruda.md` (27.842 bytes)
  - `50_documentacion/activa/backlog_consolidado_anexo_log_decisiones.md` (5.696 bytes)
- Tipo aparente: **mixto** — un consolidado vivo de estructura no canónica + dos anexos (volcado verbatim y log de decisiones de la consolidación).
- Secciones canónicas presentes: Detalle cronológico ("Detalle cronológico consolidado (1–335)").
- Secciones canónicas ausentes (en 150 líneas): Objetivo del proyecto, Nota metodológica, Clasificación temática, Resumen estadístico por sesión.
- Encabezados reales (consolidado): `## Por qué una numeración NUEVA (lectura obligatoria)`, `### Mapa de regímenes históricos (lo que se reconcilió)`, `## Detalle cronológico consolidado (1–335)`, `### Sesión 1…11 (…)`.
- Notas: el consolidado abre con la justificación de una renumeración y un mapa de regímenes históricos; carece del preámbulo canónico (objetivo/nota/clasificación/resumen). Los anexos `extraccion_cruda` (entradas verbatim por versión) y `log_decisiones` son material de consolidación, no backlog vivo.

### slep_categoria_desempeno
- Archivos encontrados:
  - `50_documentacion/activa/backlog_consolidado.md` (74.877 bytes)
- Tipo aparente: **backlog vivo** (canónico).
- Secciones canónicas presentes: Objetivo del proyecto, Nota metodológica (como "Nota metodológica del conteo"), Clasificación temática, Resumen estadístico por sesión.
- Secciones canónicas ausentes (en 150 líneas): Detalle cronológico (probable más abajo; el archivo es de 74K y las primeras 150 líneas llegan hasta el Resumen estadístico).
- Encabezados reales: `## Objetivo del proyecto`, `## Nota metodológica del conteo`, `## Clasificación temática`, `## Resumen estadístico por sesión`.
- Notas: el más voluminoso. Orden Clasificación → Resumen. Variación de naming en la nota metodológica ("del conteo").

### slep_idps
- Archivos encontrados:
  - `50_documentacion/activa/backlog_historico.md` (46.932 bytes)
  - `50_documentacion/andamios/logs/20260623_consolidacion_backlog_s18_s19_log.md` (6.551 bytes)
- Tipo aparente: **mixto** — backlog vivo (canónico) + un log de consolidación en `andamios/` (no es backlog vivo).
- Secciones canónicas presentes: Objetivo del proyecto, Nota metodológica, Clasificación temática, Resumen estadístico por sesión.
- Secciones canónicas ausentes (en 150 líneas): Detalle cronológico (probable más abajo).
- Encabezados reales (histórico): `## Objetivo del proyecto (permanente)`, `## Nota metodológica (permanente)`, `## Resumen estadístico por sesión`, `## Clasificación temática (actualizada a v25, sobre 147 cambios)`.
- Notas: sufijo `(permanente)` en objetivo/nota; orden **Resumen → Clasificación** (inverso a categoria_desempeno). El log de andamios documenta una consolidación s18–s19.

### slep_monitoreo
- Archivos encontrados:
  - `50_documentacion/traspasos/backlog_acumulado.md` (20.633 bytes)
- Tipo aparente: **backlog vivo** (canónico, encabezados numerados).
- Secciones canónicas presentes: **las 5** (Objetivo, Nota metodológica, Clasificación temática, Resumen estadístico por sesión, Detalle cronológico).
- Secciones canónicas ausentes: ninguna.
- Encabezados reales: `## 1. Objetivo del proyecto`, `## 2. Nota metodológica`, `## 3. Clasificación temática`, `## 4. Resumen estadístico por sesión`, `## 5. Detalle cronológico de cambios por sesión`, `### Sesión 1…6 (…)`.
- Notas: proyecto auxiliar. Único cuyo backlog vive en `traspasos/` (no en `activa/`). Encabezados numerados `## N.`.

### slep_reportes_modelo_resguardo_asistencia
- Archivos encontrados:
  - `50_documentacion/activa/backlog_acumulativo.md` (64.443 bytes)
  - `50_documentacion/andamios/instruccion_claude_code_construir_backlog.md` (11.323 bytes)
- Tipo aparente: **mixto** — backlog vivo (canónico, completo) + una instrucción de construcción del backlog en `andamios/` (plantilla, no backlog).
- Secciones canónicas presentes: **las 5** (Objetivo, Nota metodológica, Clasificación temática, Resumen estadístico por sesión, Detalle cronológico).
- Secciones canónicas ausentes: ninguna.
- Encabezados reales (acumulativo): `## Objetivo del proyecto`, `## Nota metodológica`, `### Nota de causa raíz — discontinuidad histórica de la numeración (§2.3.3)`, `## Clasificación temática`, `## Resumen estadístico por sesión`, `## Detalle cronológico`, `### Sesión 1 (v01) — …`.
- Notas: incluye una sub-nota de causa raíz sobre discontinuidad de numeración. El archivo de andamios contiene encabezados de plantilla (`## Objetivo del proyecto`, etc.) que podrían confundir a un detector ingenuo; es una instrucción, no el backlog.

### slep_seguimiento_educacion_inicial
- Archivos encontrados:
  - `50_documentacion/activa/backlog_consolidado.md` (11.917 bytes)
- Tipo aparente: **backlog vivo** (canónico, encabezados numerados).
- Secciones canónicas presentes: **las 5** (Objetivo, Nota metodológica, Clasificación temática, Resumen estadístico por sesión, Detalle cronológico).
- Secciones canónicas ausentes: ninguna.
- Encabezados reales: `## 1. Objetivo del proyecto`, `## 2. Nota metodológica`, `## 3. Clasificación temática acumulada (base v29, sesiones 0–29)`, `## 4. Resumen estadístico por sesión`, `## 5. Detalle cronológico — sesiones 30–34 (continuación del correlativo por sesión)`.
- Notas: encabezados numerados `## N.` (como monitoreo). Variación de naming: "Clasificación temática **acumulada**"; el Detalle cronológico solo cubre sesiones 30–34 (continuación).

### slep_simce_adecuado
- Archivos encontrados:
  - `50_documentacion/activa/backlog_historico.md` (28.753 bytes)
  - `50_documentacion/andamios/logs/20260620_reconstruccion_backlog_log.md` (9.665 bytes)
  - `50_documentacion/andamios/logs/20260622_anexo_delta_s20_backlog_log.md` (4.825 bytes)
- Tipo aparente: **mixto** — backlog vivo de estructura no canónica + dos logs de reconstrucción/anexo-delta en `andamios/`.
- Secciones canónicas presentes: ninguna con su naming canónico (la "Taxonomía vigente" cumple el rol de Clasificación temática; las sesiones `##` cumplen el rol de Detalle cronológico).
- Secciones canónicas ausentes (por naming): Objetivo del proyecto, Nota metodológica, Resumen estadístico por sesión, Detalle cronológico, Clasificación temática.
- Encabezados reales (histórico): `## Taxonomía vigente`, `## Sesión 1 — … (traspaso v01)` … `## Sesión 14 — … (traspaso v14)`.
- Notas: estructura propia — una taxonomía y luego una sección `##` por sesión (no `###` bajo un "Detalle cronológico"). No hay objetivo/nota/resumen estadístico. Los dos logs de andamios documentan la reconstrucción del backlog y un delta s20.

## Proyectos sin backlog

- slep_alertas_ael
- slep_costapresente
- slep_dashboard_personal_monitoreo
- slep_georreferenciacion
- slep_minuta_asistencia
- slep_minuta_desvinculacion
- slep_rendimiento_historico
- slep_resena_proyectos
- slep_simce_estandares_aprendizaje

(9 de 16. Varios son proyectos de correlativo bajo o que mantienen el registro de cambios embebido en sus traspasos; `slep_resena_proyectos` es auxiliar no canónico.)

## Observaciones para estandarización

Diagnóstico estructural (sin proponer contenido):

1. **Nombre del archivo:** cuatro grafías para el mismo artefacto —
   `backlog_consolidado`, `backlog_historico`, `backlog_acumulativo`,
   `backlog_acumulado`. Conviene unificar a una sola.
2. **Ubicación:** casi todos en `50_documentacion/activa/`; `slep_monitoreo` lo
   tiene en `50_documentacion/traspasos/`. Ubicación canónica no homogénea.
3. **Encabezados numerados vs. sin numerar:** `## 1. Objetivo…` (monitoreo,
   seguimiento) frente a `## Objetivo del proyecto` (categoria_desempeno, idps,
   reportes). Mismo contenido, distinto formato de encabezado.
4. **Sufijos y variantes de una misma sección:** "Nota metodológica" vs. "Nota
   metodológica **del conteo**"; "Clasificación temática" vs. "… **acumulada**"
   vs. "… (actualizada a v25…)"; "Objetivo del proyecto" vs. "… **(permanente)**".
5. **Orden de secciones inconsistente:** Clasificación temática → Resumen
   estadístico (categoria_desempeno, reportes) vs. Resumen → Clasificación (idps).
6. **Dos backlogs sin las secciones canónicas:** `aprendizajes_ep` (numeración
   nueva + mapa de regímenes) y `simce_adecuado` (Taxonomía vigente + sesiones
   como `##`). Son los más alejados de la convención; sus encabezados no mapean
   1:1 a las cinco secciones esperadas.
7. **Convención de Detalle cronológico:** unos usan `## Detalle cronológico` con
   sesiones como `###` (reportes, monitoreo, aprendizajes_ep); simce_adecuado usa
   directamente `## Sesión N` sin un contenedor "Detalle cronológico". Un detector
   por encabezado debe contemplar ambas formas.
8. **Ruido de anexos/logs:** anexos en `activa/` (aprendizajes_ep) y logs/
   instrucciones en `andamios/` contienen encabezados que imitan los canónicos
   (p. ej. la instrucción de reportes trae `## Objetivo del proyecto` de
   plantilla). Cualquier consolidación automática debe distinguir el backlog vivo
   de estos materiales por ubicación y nombre, no solo por encabezados.
