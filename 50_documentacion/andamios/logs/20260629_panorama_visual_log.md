# Log de encargo autónomo — Paso 36: panorama visual

Fecha: 2026-06-29. Repo: slep_estado_proyectos_monitoreo (orquestador).

## Resumen

Se agregó el paso 36 al pipeline: genera un informe visual HTML autocontenido
(`40_salidas/panorama_visual.html`) y su gemelo en texto
(`40_salidas/panorama_visual.md`) a partir del inventario determinista (paso 34),
el registro curado y la documentación curada de cada hermano (traspaso vigente +
`backlog_acumulativo.md` canónico). Se amplió `registro_proyectos.csv` con dos
columnas vacías (`datos_sensibles`, `estado_proyecto`) para curado manual del
titular, y se integró el paso 36 a `run_all()`. Todo confinado al repo del
orquestador; lectura de hermanos limitada a `50_documentacion/` (R2).

## Inventario de commits

1. `feat(registro): columnas datos_sensibles y estado_proyecto vacias` — registro_proyectos.csv (FASE 0).
2. `feat(paso 36): panorama visual HTML/MD autocontenido + integrar a run_all` — 36_generar_panorama_visual.R + 00_run_all.R (FASES 1-5).
3. `chore(salidas): generar panorama_visual.* y regenerar inventario/panorama` — panorama_visual.html/.md, inventario_cartera.json/.parquet, panorama.md.

(Hashes en el reporte al chat. Sin push.)

## Cambios sustantivos

- **FASE 0 — registro.** Se agregaron `datos_sensibles` y `estado_proyecto` al
  final, vacías ("") en las 16 filas; las 5 columnas originales quedaron
  byte-idénticas (verificado por `cut -f1-5` + diff). El titular las completará a
  mano.
- **FASE 1 — extracción por proyecto.** `36_generar_panorama_visual.R` construye,
  por proyecto del inventario, un objeto con: identidad (registro), gobernanza
  (`datos_sensibles`/`estado_proyecto`, null si vacías), `sintesis/objetivo/tipo`
  (null: data.js no configurado), `fecha_actualizacion` (fecha DECLARADA en el
  traspaso, no mtime), `proximos_pasos` (≤3 entradas de la sección de pendientes),
  `tiene_backlog` + `resena_itinerario` (sección "Objetivo del proyecto" del
  `backlog_acumulativo.md` canónico, ≤600 chars). Campos ausentes = null explícito.
  Se reusa la localización del paso 32 vía el inventario (no se reescribe).
- **FASE 2 — orden.** null/inicial primero → en_desarrollo → con_productos →
  en_pausa → concluido; dentro de cada grupo, fecha declarada descendente, null
  al final. (Hoy: 16 con estado null → orden por fecha descendente.)
- **FASE 3 — HTML.** Autocontenido: CSS inline en `:root` con tokens nombrados
  del portafolio (valores hex aproximados, `# REVISAR`), `font-family: system-ui`,
  grid responsivo (1/2/3 columnas), datos embebidos como
  `<script type="application/json">` (con blindaje `</`→`<\/`), render vanilla JS
  por `createElement`/`textContent` (sin inyección, sin escaping manual). Cero
  referencias de red.
- **FASE 4 — MD.** Mismo contenido y orden que las cards, en prosa corta por campo.
- **FASE 5 — run_all.** Paso 6 (id=6L) agregado a `PASOS` tras el paso 5,
  siguiendo el patrón existente.

## Verificación de invariantes (🔒)

- Confinamiento de escritura (solo dentro del orquestador): **PASA** —
  todas las escrituras vía `escribir_seguro`/Write a `40_salidas/`, `20_insumos/`,
  `30_procesamiento/`, `50_documentacion/` del propio repo.
- Solo lectura sobre hermanos: **PASA** — testigos de mtime
  (`slep_idps/README.md`, `slep_minuta_asistencia/README.md`) inalterados; no se
  ejecutó ni modificó ningún hermano.
- R2 (no leer `*_volcado_crudo*`): **PASA** — solo se leyeron traspaso vigente y
  `backlog_acumulativo.md` (ambos en `50_documentacion/`).
- R3 (no transcribir andamios literal): **PASA** — no se leyeron andamios; las
  fuentes fueron traspaso y backlog.
- No leer `20_insumos/`/`40_salidas/` de hermanos ni OneDrive: **PASA**.
- HTML 100% autocontenido (cero red): **PASA** — 0 `<link>/@import/src=http/href=http/url(http)`.
- Cero paquetes R nuevos: **PASA** — solo jsonlite, readr, stringr (+ utils/config).

## Pendientes abiertos / # REVISAR

- `# REVISAR` (palette): los valores hex de `:root` son aproximaciones de los
  tokens del portafolio; sincronizar con `colors_and_type.css` (no leído por R2).
- `RUTA_DATA_JS_PORTAFOLIO = NA`: `sintesis/objetivo/tipo` quedan null en los 16.
  Para activarlo, fijar la constante al inicio de `36_generar_panorama_visual.R`
  con la ruta absoluta a `slep_monitoreo/data.js` e implementar el parseo
  tolerante del array `PROYECTOS` (documentado como pendiente en el script).
- `estado_proyecto`/`datos_sensibles`: vacías en los 16; las cura el titular.
- Fuera de alcance (se observa, no se actúa): `slep_minuta_desvinculacion`
  cambió su traspaso (md5 nuevo) → su cache de panorama quedó "pendiente de
  síntesis" en `panorama.md`; además su mtime quedó fechado 2026-06-30, lo que
  produce un cosmético "hace -1 dias" en el paso 35 (anomalía de dato del
  hermano, no del orquestador).

## Corrección de bug detectado durante la ejecución

Al verificar con `run_all`, se detectó que el **paso 31 estrechaba el registro a
las 5 columnas canónicas** (`leer_registro_previo` hacía `prev[, cols]` y
`construir_fila` armaba un data.frame de 5 columnas), borrando las columnas nuevas
de FASE 0 en cada corrida. Sin arreglo, FASE 0 era inútil y FASE 1 nunca podría
leer `datos_sensibles`/`estado_proyecto`. Corrección (commit `fix(paso 31)`):

- `COLS_GESTIONADAS` declara las 5 columnas que 31 sincroniza.
- `leer_registro_previo` ahora preserva las columnas extra (gestionadas primero,
  extra después en su orden original).
- `construir_fila` arrastra las columnas extra por slug (valor previo, o "" si es
  nuevo).

Verificado: tras `run_all`, el registro conserva las 7 columnas; idempotente; las
5 columnas originales quedan byte-idénticas a la curación del titular. (Nota: este
bug también explica por qué el primer intento de commit del registro no encontró
cambios — el paso 31 ya lo había revertido a 5 columnas.)

## Notas para el revisor

- `tiene_backlog = TRUE` en **5** proyectos (no 4 como anticipaba el encargo):
  `categoria_desempeno`, `idps`, `monitoreo`, `reportes_modelo_resguardo_asistencia`,
  `seguimiento_educacion_inicial`. La auditoría previa contó 4 porque
  `reportes_modelo_resguardo_asistencia` ya tenía el nombre canónico antes de la
  estandarización; los renombres posteriores sumaron los otros 4 (uno de ellos,
  `monitoreo`, es auxiliar). No es error: es el estado real tras la estandarización.
- El inventario y `panorama.md` cambiaron respecto al commit previo por causas
  externas (renombres de backlog de la tarea anterior + churn de
  `minuta_desvinculacion`), no por el paso 36.
