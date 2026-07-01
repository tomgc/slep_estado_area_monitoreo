# Traspaso de cierre v04 — slep_estado_proyectos_monitoreo

## 1. Identificacion

- **Proyecto:** slep_estado_proyectos_monitoreo (orquestador de estado de la cartera).
- **Version:** v04. **Fecha:** 2026-06-29/30. **Sesion:** 4 (CONTINUATION).
- **Foco:** estandarizacion del backlog acumulativo en la cartera de proyectos
  hermanos; parche de gobernanza documental en POLITICA_PROYECTO.md y
  SETTINGS_Y_PROMPTS_OPERACIONALES.md; ejecucion de P4 (panorama visual HTML
  autocontenido + gemelo .md); cierre de deuda menor (paleta real, archivado de
  auditoria).
- **Entorno:** Claude Code (modo autonomo, varios encargos dirigidos por meta) +
  conversacion con el asistente de analisis. R 4.5.2, macOS, locale C.
- **Archivos principales modificados:**
  - **Repos hermanos** (autorizacion explicita del titular en cada caso):
    `slep_idps` (rename backlog + eliminacion de volcado crudo, commit `708572a`),
    `slep_categoria_desempeno` (rename backlog, commit `5aaaea8`),
    `slep_seguimiento_educacion_inicial` (rename backlog, commit `cd61ddb`),
    `slep_monitoreo` (mv + rename backlog, commit `4d7b326`).
  - **Documentos de protocolo** (entregados al titular para su distribucion via
    knowledge base; el titular confirma haberlo aplicado ya en este proyecto):
    `POLITICA_PROYECTO.md` (v5 -> v5.1, nueva entrada en §10),
    `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (v4 -> v5, nuevo parrafo en §2.2.5).
  - **Propio repo (orquestador):** `20_insumos/registro_proyectos.csv` (2 columnas
    nuevas: `datos_sensibles`, `estado_proyecto`, vacias),
    `30_procesamiento/31_descubrir_proyectos.R` (fix: preservar columnas extra del
    registro), `30_procesamiento/36_generar_panorama_visual.R` (nuevo),
    `00_run_all.R` (paso 36 agregado), `40_salidas/panorama_visual.{html,md}`
    (nuevos), `40_salidas/inventario_cartera.{json,parquet}` y `panorama.md`
    (regenerados, reflejan los renames de backlog de los hermanos),
    `50_documentacion/andamios/auditoria_backlogs_20260629.md` (archivado desde
    `40_salidas/`), `50_documentacion/andamios/logs/20260629_panorama_visual_log.md`
    (nuevo).

---

## 2. Resumen ejecutivo

Sesion larga con tres bloques de trabajo. Primero, se audito (solo lectura) el
estado de los archivos backlog en los 16 proyectos hermanos, encontrando 7 con
backlog bajo 4 grafias distintas y 9 sin ninguno; con esa base se estandarizaron
los 4 backlogs no canonicos al nombre y ubicacion unicos
(`50_documentacion/activa/backlog_acumulativo.md`), incluyendo un caso untracked
(slep_monitoreo) y la eliminacion de un volcado crudo obsoleto en slep_idps. La
regla de nombre/ubicacion, que no estaba escrita en ningun protocolo, se parcheo
en POLITICA_PROYECTO.md §10 y SETTINGS §2.2.5 para que las sesiones futuras la
hereden sin tener que redescubrirla. Segundo, se diseno y ejecuto P4: un informe
visual HTML autocontenido (mas su gemelo .md) que muestra el estado de los 16
proyectos de la cartera, integrado como paso 36 de run_all(); el encargo destapo
y corrigio un bug real en el paso 31 (truncaba el registro a 5 columnas,
borrando cualquier columna nueva en cada corrida). Tercero, se cerraron dos
deudas menores: la paleta de color del HTML (que habia quedado con valores hex
aproximados por R2) se sincronizo con los tokens reales de la marca SLEP, y el
reporte de auditoria de backlogs se archivo como andamio congelado. Se
identifico y corrigio ademas una discrepancia de numeracion de traspaso: el v03
de la sesion anterior habia quedado untracked en el repo; este v04 lo consolida
sin perdida de historial.

---

## 3. Estado al cierre

**Funciona (ultima ejecucion 2026-06-29):**
- `run_all()` corre los 6 pasos (31->36) sin intervencion manual.
- `panorama_visual.html` autocontenido: 0 referencias de red, 16 cards
  renderizadas, paleta con valores hex reales de marca SLEP.
- `panorama_visual.md`: 16 bloques, mismo orden y campos que el HTML.
- Idempotencia determinista verificada en el paso 36 (md5 estable entre
  corridas) y en el registro (7 columnas preservadas tras el fix del paso 31).
- 5 proyectos hermanos con `backlog_acumulativo.md` canonico:
  `categoria_desempeno`, `idps`, `monitoreo`, `reportes_modelo_resguardo_asistencia`,
  `seguimiento_educacion_inicial`.

**No funciona / pendiente:**
- `registro_proyectos.csv`: las columnas `datos_sensibles` y `estado_proyecto`
  estan vacias en las 16 filas. El titular las completa a mano (P-REGISTRO-CURAR).
- `RUTA_DATA_JS_PORTAFOLIO` sin configurar (NA): `sintesis`/`objetivo`/`tipo`
  quedan null en las 16 cards del panorama visual.
- `slep_minuta_desvinculacion`: su traspaso cambio de md5 (avanzo de version)
  por lo que su cache de panorama quedo "pendiente de sintesis"; ademas su mtime
  quedo fechado 2026-06-30, produciendo un cosmetico "hace -1 dias" en el paso 35.
  Anomalia del hermano, no del orquestador; sin actuar (R1/R4).
- `traspaso_cierre_v03.md`: estaba untracked en el repo del orquestador (de la
  sesion anterior). Este traspaso v04 lo consolida; falta commitearlo junto con
  este archivo al cerrar.

**Delta respecto a v03:**
- 4 backlogs hermanos estandarizados (nombre + ubicacion canonicos).
- 1 volcado crudo eliminado (slep_idps).
- POLITICA_PROYECTO.md v5->v5.1 y SETTINGS v4->v5 (regla de backlog explicita).
- Paso 36 (panorama visual) agregado a run_all(); 2 archivos de salida nuevos.
- Bug del paso 31 corregido (preservacion de columnas extra del registro).
- registro_proyectos.csv: 5->7 columnas.
- Paleta del HTML sincronizada a valores reales de marca.
- auditoria_backlogs.md archivado como andamio.

---

## 4. Registro detallado de cambios

### 4.1 Auditoria de backlogs (solo lectura, Claude Code autonomo)

Encargo confinado a lectura de `50_documentacion/` de cada hermano, excluyendo
`*_volcado_crudo*`. Resultado: 16 proyectos auditados, 7 con backlog (4 grafias
distintas: `backlog_consolidado` x3, `backlog_historico` x2, `backlog_acumulativo`
x1, `backlog_acumulado` x1), 9 sin ninguno. De los 7, solo 3 tenian las 5
secciones canonicas completas y reconocibles por naming; 2 parciales; 2 con
estructura propia no estandar (`aprendizajes_ep`, `simce_adecuado`), diferidos
para sesion dedicada por proyecto porque requieren reescritura de contenido, no
solo renombrado. Verificacion: como se usaron solo bash y lectura de archivos
.md, no aplica build/test; criterio de exito fue el reporte mismo
(`auditoria_backlogs_20260629.md`, ahora archivado en andamios/).

### 4.2 Estandarizacion de 4 backlogs (autorizacion explicita del titular)

Renombre/reubicacion a `backlog_acumulativo.md` en `activa/` en 4 repos
hermanos, mas eliminacion del volcado crudo obsoleto de `slep_idps`. Iteracion
en 3 rondas por restricciones de working tree:
- Ronda 1: solo `slep_idps` (working tree limpio) -> `708572a`.
- Ronda 2: los 3 restantes seguian con working tree sucio (trabajo legitimo
  preexistente de cada repo: snapshots de escaner, traspasos y resenas
  untracked) -> 0 ejecutados, regla de guardrail respetada.
- Ronda 3 (autorizacion de staging selectivo por pathspec): `categoria_desempeno`
  -> `5aaaea8`, `seguimiento_educacion_inicial` -> `cd61ddb`. `slep_monitoreo`
  fallo porque su backlog fuente nunca habia sido commiteado (`git mv` no opera
  sobre untracked) -> resuelto en una cuarta corrida con `mv` plano + `git add`
  + commit por pathspec -> `4d7b326`.
Verificacion: cada commit confirmado con `git show --stat HEAD` (1 archivo, 0
lineas de contenido cambiadas salvo el caso untracked, que aparece como
adicion integra por falta de historial previo) y `git status --short` (resto
del working tree de cada repo intacto). Sin push en ningun repo (decision del
titular).

### 4.3 Parche de gobernanza documental (POLITICA + SETTINGS)

La regla de nombre canonico (`backlog_acumulativo.md`) y ubicacion canonica
(`50_documentacion/activa/`) existia de facto en los proyectos mas maduros pero
no estaba escrita en ningun protocolo, lo que permitio que emergieran 4 grafias
distintas en la cartera. Se agrego:
- `POLITICA_PROYECTO.md` §10: nueva entrada de documentacion minima declarando
  nombre, ubicacion, momento de extraccion (a partir de la 2a sesion) y
  referencia cruzada a SETTINGS §2.2.5. Version 5 -> 5.1.
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md` §2.2.5: nuevo parrafo "Archivo
  canonico" al inicio de la seccion, antes del detalle de las 5 secciones
  internas. Version 4 -> 5.
Verificacion: revision manual del texto por el titular antes de aplicar
(entregado como dos archivos completos, sin aplicarlos directamente al KB
porque el titular gestiona la distribucion a los 16 proyectos). El titular
confirmo haberlo aplicado ya en este proyecto.

### 4.4 P4 — Panorama visual (encargo autonomo dirigido por meta)

Encargo extenso de 5 fases (ver `andamios/logs/20260629_panorama_visual_log.md`
para el detalle paso a paso; no se reproduce aqui completo). Resumen: se amplio
el registro con 2 columnas vacias para curado manual del titular
(`datos_sensibles`, `estado_proyecto`); se construyo una funcion de extraccion
por proyecto que combina datos del registro, fecha y pendientes del traspaso
mas reciente, y reseña de itinerario del backlog canonico (si existe); se
genero un HTML autocontenido (CSS inline, datos embebidos como JSON, vanilla
JS) y su gemelo .md; se integro como paso 36 de `run_all()`.

Durante la auto-auditoria del encargo se detecto un bug real: el paso 31
(`31_descubrir_proyectos.R`) estrechaba el registro a las 5 columnas canonicas
originales en cada corrida (`leer_registro_previo` hacia `prev[, cols]`),
borrando silenciosamente cualquier columna nueva del registro -- lo cual habria
hecho inutil tanto la FASE 0 de este mismo encargo como cualquier extension
futura del registro. Se corrigio introduciendo `COLS_GESTIONADAS` (las 5
columnas que el paso 31 sincroniza activamente) y preservando el resto como
"columnas extra" arrastradas por slug. Verificado: tras `run_all()`, el
registro conserva las 7 columnas, es idempotente, y las 5 columnas originales
quedan byte-identicas a la curacion del titular.

Verificacion de la Fase 3 (HTML): grep de referencias de red = 0
(`<link>`/`@import`/`src=http`/`href=http`/`url(http)`); JSON embebido parseado
y validado (16 objetos, nulls explicitos donde corresponde, orden correcto por
estado/fecha); apertura `file://` sin consola de errores.

Hallazgo no anticipado: 5 proyectos con backlog canonico al cierre del encargo
(no 4 como anticipaba el encargo original), porque `reportes_modelo_resguardo_asistencia`
ya tenia el nombre canonico antes de la estandarizacion de esta sesion; los 4
renombrados (4.2) sumaron los restantes.

### 4.5 Cierre de deuda menor: paleta real + archivado de auditoria

- **Paleta:** los 8 valores hex aproximados (`# REVISAR`) del `:root` del HTML
  se sincronizaron con los tokens reales de la marca SLEP Costa Central
  (`--plum #4A2746`, `--cream #FFF6E0`, `--ocean #0062A0`, `--slate #747474`,
  `--olive #75924E`, `--sand #BCA493`, `--coral #E88663`, `--ink #1C1212`),
  agregando `--ink-2 #2E2230` (no existia previamente; se agrego sin renombrar
  nada existente). Verificacion: grep de hex confirma los 9 valores; mapeo
  determinista badge-a-token confirma que cada estado/acento resuelve al color
  correcto; 0 referencias de red mantenidas. Commit `80b72d0`.
- **Archivado:** `auditoria_backlogs.md` (estaba untracked en `40_salidas/`) se
  movio a `50_documentacion/andamios/auditoria_backlogs_20260629.md` como
  registro congelado. Commit `95ce146`.

---

## 5. Backlog acumulativo

> **Archivo canonico:** a partir de esta sesion, el backlog de este proyecto
> tambien deberia vivir en `50_documentacion/activa/backlog_acumulativo.md`
> (regla recien parcheada en POLITICA §10 / SETTINGS §2.2.5). Esta es la
> segunda sesion del proyecto con traspaso commiteado (v01, v02, v03, v04);
> corresponde extraerlo a archivo independiente. Se incluye completo aqui por
> ultima vez; **pendiente para el cierre de la sesion 5: extraerlo a
> `backlog_acumulativo.md` y dejar solo la referencia en el traspaso** (ver
> P-BACKLOG-PROPIO-EXTRAER en pendientes).

### Objetivo del proyecto (permanente)

Orquestador en R del Area de Monitoreo y Seguimiento de Procesos y Resultados
Educativos (SLEP Costa Central) que descubre en tiempo de ejecucion los
proyectos hermanos `~/Projects/slep_*`, lee SOLO su documentacion curada y
sintetiza un "estado de situacion de la cartera": un `panorama.md` para el
arranque de jornada y un informe visual HTML autocontenido
(`panorama_visual.html`) de consumo directo del titular, sin intermediarios.
No ejecuta ni modifica los pipelines hermanos; su unica escritura ocurre,
cerrada por codigo, dentro de su propio repo. Producido con R (tidyverse,
arrow, jsonlite, readr, fs). Desde la sesion 1 (2026-06-28).

> **Nota v04:** se corrige la mencion heredada a un "informe a jefaturas
> graduable (L1/L2/L3)" presente en v01-v03. Ese concepto fue una invencion
> del asistente en la sesion 1 (extrapolacion no solicitada), nunca un
> requerimiento real del titular. El producto real es el panorama visual de
> uso personal del titular (P4), quien informa a sus propias jefaturas por
> fuera de este sistema. El objetivo permanente arriba ya queda corregido;
> se documenta el error para que no se repita en consolidaciones futuras del
> backlog.

### Nota metodologica (permanente)

Un "cambio" es una solicitud distinguible del titular o una decision de diseno
con efecto en el producto, no cada accion tecnica que la implementa. No cuentan
los errores del asistente corregidos de inmediato (si cuentan los bugs
reportados por el titular o detectados por auto-auditoria con efecto real en
el producto, como el bug del paso 31). La clasificacion es por intencion
primaria. Fuentes del conteo: este traspaso, los logs de encargos autonomos y
los commits.

### Clasificacion tematica

| Categoria | N | Descripcion |
|---|---|---|
| Andamiaje/estructura | 3 | Estructura Rama A, .gitignore, .Rproj, git. |
| Pipeline determinista | 6 | Scripts 31-36 (36 nuevo en s4). |
| Utilidades/gobernanza por codigo | 2 | escribir_seguro/atomico; descubrir_hermanos. |
| Sintesis cualitativa | 5 | 14 fichas L2 iniciales + 3 re-sintetizadas (s2) + 0 nuevas (s3). |
| Operacion/regeneracion | 4 | Corridas run_all de regeneracion (s2, s3, s4 x2). |
| Documentacion | 8 | README, CLAUDE, cobertura (x2), esbozo Fase 2, decision, traspasos (x2 nuevos: v03 commiteado + v04), parche POLITICA/SETTINGS. |
| Robustez/bugfix | 4 | id integer en PASOS, UTF-8 con readr, em-dash mojibake, exclusion .git, fix paso 31 (columnas extra). |
| Gobernanza hermanos | 8 | gobernanza_datos.md en 3+2 proyectos, merge docs/suitedoc, push, conexion GitHub orquestador. |
| Estandarizacion de cartera | 5 | Auditoria de backlogs + 4 renames/reubicaciones + 1 volcado crudo eliminado. |
| Informe visual (P4) | 3 | Script 36 (HTML+MD autocontenidos), integracion a run_all, registro ampliado (2 columnas). |
| Cierre de deuda menor | 2 | Paleta real sincronizada, auditoria archivada como andamio. |

### Resumen estadistico por sesion

| Sesion | Traspasos | Cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | ~18 | Opus 4.8 | Andamiaje + Fase 1 completa |
| 2 | v02 | 6 | Opus 4.8 | Operacion: regeneracion tras cierre parcial de H4 |
| 3 | v03 | 8 | Opus 4.8 | Gobernanza: cierre total de H4 + GitHub |
| 4 | v04 | 13 | Sonnet 4.6 | Estandarizacion de backlogs + parche de protocolo + P4 (panorama visual) + cierre de deuda |

### Detalle cronologico

**Sesion 1 (entradas 1-18):** (copiadas integras de v01/v02/v03 — sin cambios)

1. Estructura de carpetas por decenas (Rama A, raiz unificada).
2. `.gitignore` estandar SIN bloque de datos; `.Rproj`.
3. `10_utils.R`: `instalar_si_falta`, `log_msg`, `escribir_seguro`, `escribir_atomico`, `hash_archivo`.
4. `10_configuracion.R`: anclaje rprojroot; resolucion+validacion de `RAIZ_PROYECTOS`; `descubrir_hermanos()`; constantes; exclusion `*.git`.
5. `31_descubrir_proyectos.R`: descubrimiento por patron; clasificacion; sincronizacion del registro sin pisar campos del titular; pre-sugerencia de `nombre_real`.
6. `32_localizar_documentos.R`: localizacion por patron (traspaso por maximo entero, backlog con exclusion de volcados, escaner, gobernanza).
7. `33_extraer_metadatos.R`: fechas mtime, sellos md5, git opcional.
8. `34_compilar_inventario.R`: inventario JSON/parquet determinista, rutas saneadas, escritura atomica.
9. `35_compilar_panorama.R`: ensamblado desde inventario + cache; alertas; anexo de incompleta anotado.
10. `00_run_all.R`: orquestador 31->35.
11. `00_escanear_proyecto.R`: escaner del propio repo, poda retencion 2.
12. `tests/test_orquestador.R`: confinamiento (R1), dedup de traspaso, backlog.
13. Sintesis de 14 fichas L2 en `cache/<slug>.md` con sello.
14. `registro_proyectos.csv` sembrado (16 filas, `nombre_real` pre-sugerido).
15. Bugfix: `id` de PASOS como integer.
16. Bugfix: E/S de registro con `readr` (UTF-8 en locale C).
17. Bugfix: mojibake de em-dash en 35.
18. Documentacion: README, CLAUDE, reporte de cobertura, esbozo Fase 2, decision.

**Sesion 2 (entradas 19-24):** (copiadas integras de v02/v03 — sin cambios)

19. Verificacion del estado de ramas de los tres repos de H4: gobernanza_datos.md presente en los tres working trees (dos en main, uno en docs/suitedoc).
20. Regeneracion del panorama via `run_all()` (operacion, sin tocar scripts).
21. Re-sintesis de 3 caches con sello nuevo: georreferenciacion (v05), minuta_desvinculacion (v29), simce_adecuado (v24); 11 reutilizados literal.
22. Confirmacion del delta `maneja_sensibles` FALSE->TRUE en los tres de H4.
23. Actualizacion del reporte de cobertura (cierre parcial de H4, matiz de rama, caso abierto simce_estandares).
24. Verificacion de que el paso 31 preserva la curacion del titular del registro (16 filas con nombre_real/alias_corto/notas intactos).

**Sesion 3 (entradas 25-32):** (copiadas integras de v03 — sin cambios)

25. Creacion de `gobernanza_datos.md` en `slep_simce_estandares_aprendizaje` (desde traspaso v14; 117 lineas; commit 662d6e1 en ese repo).
26. Deteccion de que `slep_seguimiento_educacion_inicial` ya tenia `gobernanza_datos.md` en `docs/suitedoc` (270 lineas, commit a6727a5); no se sobrescribio.
27. Merge de `docs/suitedoc` a `main` en `slep_seguimiento_educacion_inicial` (8 archivos, 2556 inserciones; commit de merge 10c8673).
28. Regeneracion del orquestador: `maneja_sensibles=TRUE` confirmado en 12 proyectos; idempotencia determinista verificada.
29. Commit de salidas del orquestador (inventario_cartera.json + .parquet; commit fe50290 pre-reescritura).
30. Conexion del orquestador a GitHub por primera vez (`slep_estado_area_monitoreo`).
31. Reescritura del historial de 6 commits a email noreply canonico, previa verificacion (D8); push inicial.
32. Rotacion de snapshots de estructura tras el cierre (commit c2da1ed).

**Sesion 4 (entradas 33-45, nuevas):**

33. Auditoria solo-lectura de archivos backlog en los 16 hermanos (encargo autonomo): 7 con backlog (4 grafias distintas), 9 sin ninguno; reporte en `auditoria_backlogs.md`.
34. Decision del titular: estandarizar nombre y ubicacion de los 4 backlogs no canonicos (Opcion B: renombrar + reubicar; alineacion de encabezados diferida para los 5 canonicos en sesion futura).
35. Lectura completa de los 5 backlogs canonicos por el asistente de analisis para diagnosticar el alcance real antes de redactar el encargo.
36. Rename + reubicacion de backlog en 4 repos hermanos en 3 rondas (autorizacion explicita por ronda): `slep_idps` (commit `708572a`, incluye eliminacion de volcado crudo obsoleto), `slep_categoria_desempeno` (`5aaaea8`), `slep_seguimiento_educacion_inicial` (`cd61ddb`), `slep_monitoreo` (`4d7b326`, caso untracked resuelto con mv plano).
37. Parche de gobernanza documental: nueva entrada en `POLITICA_PROYECTO.md` §10 (v5->v5.1) y nuevo parrafo en `SETTINGS_Y_PROMPTS_OPERACIONALES.md` §2.2.5 (v4->v5) declarando nombre y ubicacion canonicos del backlog. Entregados al titular para distribucion a la knowledge base de los 16 proyectos.
38. Diseno conversacional de P4 (informe visual): definicion de campos de la card (nombre, slug, sintesis, descripcion, estado, fuentes de datos, fecha, proximos pasos, reseña de itinerario opcional), arquitectura de produccion (HTML autocontenido + MD gemelo generados por el pipeline), fuente editorial (data.js del portafolio para los 11 publicos; registro para el resto).
39. Decision del titular: 2 columnas nuevas en el registro (`datos_sensibles`, `estado_proyecto`) curadas manualmente, sin heuristica del agente.
40. Ejecucion del encargo P4 (5 fases, Claude Code autonomo): registro ampliado, funcion de extraccion por proyecto, orden de cards, HTML+MD generados, integracion a run_all() como paso 36.
41. Bug detectado y corregido durante la auto-auditoria del encargo P4: el paso 31 truncaba el registro a 5 columnas en cada corrida, borrando las columnas nuevas. Fix: `COLS_GESTIONADAS` + preservacion de columnas extra.
42. Correccion de la numeracion de traspaso: deteccion de que `traspaso_cierre_v03.md` (sesion anterior) habia quedado untracked; decision del titular de preservar el historial completo cerrando esta sesion como v04 (no sobrescribir v03).
43. Sincronizacion de la paleta del HTML con los valores hex reales de la marca SLEP (8 tokens + 1 agregado, `--ink-2`); eliminacion del marcador `# REVISAR` de paleta. Commit `80b72d0`.
44. Archivado de `auditoria_backlogs.md` (untracked en `40_salidas/`) a `50_documentacion/andamios/auditoria_backlogs_20260629.md` como registro congelado. Commit `95ce146`.
45. Correccion documental: el objetivo permanente del backlog (heredado desde v01) mencionaba un "informe a jefaturas graduable L1/L2/L3" que nunca fue un requerimiento del titular -- fue una invencion del asistente en la sesion 1. Corregido en la seccion 5 de este traspaso, documentado como aprendizaje (seccion 7).

### Delta del backlog

13 entradas nuevas (33-45). Sin reclasificaciones de entradas previas. Dos
categorias nuevas: "Estandarizacion de cartera" e "Informe visual (P4)"; una
sub-entrada relevante en "Cierre de deuda menor".

---

## 6. Bugs de la sesion

- **B5:** el paso 31 (`31_descubrir_proyectos.R`) truncaba el
  `registro_proyectos.csv` a las 5 columnas canonicas originales en cada
  corrida de `run_all()`, descartando silenciosamente cualquier columna nueva.
  **Causa raiz:** `leer_registro_previo()` hacia `prev[, cols]` con `cols`
  fijo a las 5 columnas de la sesion 1; `construir_fila()` ensamblaba un
  data.frame de exactamente esas 5 columnas, sin mecanismo de paso para
  columnas adicionales. **Solucion:** se introdujo `COLS_GESTIONADAS` (las 5
  columnas que el paso 31 sincroniza activamente desde las fuentes de
  descubrimiento) y se modifico `leer_registro_previo`/`construir_fila` para
  preservar cualquier columna extra del registro previo (gestionadas primero,
  extra despues, en su orden original), arrastrando el valor previo por slug
  o `""` si la fila es nueva. **Verificacion:** tras `run_all()`, el registro
  conserva las 7 columnas; 2da corrida produce md5 identico (idempotencia);
  las 5 columnas originales quedan byte-identicas a la curacion del titular
  (verificado por `diff` de las primeras 5 columnas via `cut`).
  **Regla aprendida:** cualquier script que sincronice un CSV "vivo" (con
  campos de curacion manual del titular) debe declarar explicitamente que
  columnas gestiona vs. cuales son de curacion externa, y preservar las
  segundas por diseño, no por omision accidental. Detectado por
  auto-auditoria durante el encargo P4 (panel adversarial informal: verificar
  el estado real tras `run_all()` en vez de asumir que la FASE 0 persistia).
  **Principio relacionado:** B.4 (criterio de exito verificable definido antes
  de codificar) habria exigido este check desde el diseño del encargo; quedo
  cubierto por la auto-auditoria en su defecto.

---

## 7. Aprendizajes y restricciones (nuevos en s4)

- **Un dato fabricado en una sesion temprana puede persistir en el backlog
  permanente durante varias sesiones sin que nadie lo cuestione.** El
  "objetivo del proyecto" (seccion permanente) de v01 a v03 mencionaba un
  "informe a jefaturas graduable L1/L2/L3" que el titular jamas pidio: fue una
  extrapolacion del asistente en la sesion 1, nunca confrontada hasta que el
  titular pregunto directamente "¿que es L1/L2/L3?" en esta sesion. **Regla:**
  el objetivo permanente del backlog debe re-verificarse contra la voz directa
  del titular cuando se reabre para edicion, no solo copiarse integro por
  inercia entre sesiones. Si algo en el "objetivo permanente" parece
  sospechosamente especifico sin que el titular lo haya dicho con esas
  palabras, vale la pena preguntar antes de seguir propagandolo.
- **Un guardrail de seguridad (working tree limpio) puede bloquear
  innecesariamente una operacion quirurgica cuando el "ruido" del repo no
  tiene relacion con la operacion.** La regla original ("si hay cambios sin
  commitear, SALTAR") es sana por defecto, pero en repos con trabajo legitimo
  pendiente de cierre de sesion (traspasos, resenas, snapshots de escaner),
  bloquea trabajo seguro. **Regla:** cuando el guardrail bloquea una operacion
  de bajo riesgo (un rename mecanico sin tocar contenido), la alternativa
  correcta es staging selectivo por pathspec (`git commit <archivo> -- ...`),
  no relajar el guardrail global ni forzar `git add .`. El pathspec preserva
  la atomicidad del commit sin tocar el resto del working tree.
- **Un archivo "fuente" para un `git mv` puede estar untracked, no solo
  ausente.** `git mv` falla silenciosamente con un mensaje de error claro
  cuando el origen nunca fue commiteado (no hay historial que preservar). La
  operacion correcta en ese caso es `mv` plano + `git add` del destino, no
  forzar `git mv` ni asumir que el archivo no existe.
- **La numeracion de version de un traspaso es independiente de si el archivo
  fue commiteado.** Un traspaso puede generarse correctamente en una sesion y
  quedar untracked en el repo; eso no significa que la sesion "no cuenta" ni
  que su numero de version deba reciclarse. La cadena de reapertura
  (seccion 14 de cada traspaso) es la fuente de verdad del numero de sesion,
  no el conteo de archivos commiteados en `traspasos/`.
- **Las reglas de naming/ubicacion que emergen organicamente en los proyectos
  mas maduros de una cartera deben escribirse en el protocolo apenas se
  detectan, no asumirse como "obvias".** La regla de `backlog_acumulativo.md`
  en `activa/` existia de facto en 3 de 7 proyectos pero nunca se documento
  explicitamente hasta que la heterogeneidad resultante (4 grafias distintas)
  se hizo evidente en una auditoria. Costo: trabajo de estandarizacion
  retroactiva en 4 repos. Prevencion: cuando una convencion repetida en >50%
  de los casos observados no esta en la politica, parchearla de inmediato.

---

## 8. Decisiones de diseno

- **Estandarizacion de backlogs: Opcion B (renombrar + reubicar + alinear
  encabezados de los canonicos; diferir reescritura de los 2 no canonicos).**
  Alternativa rechazada: Opcion A (solo renombrar/reubicar, sin alinear
  encabezados) por dejar mas trabajo de normalizacion fina sin hacer.
  Alternativa rechazada: reescribir tambien `aprendizajes_ep` y `simce_adecuado`
  en este encargo, por requerir juicio de contenido que excede un encargo
  mecanico de Claude Code; diferido a sesion dedicada por proyecto.
- **Staging selectivo por pathspec en vez de relajar el guardrail de working
  tree limpio.** Alternativa rechazada: autorizar `git add .` o ignorar el
  guardrail por completo, lo que habria arriesgado mezclar el rename con
  trabajo no revisado de cada repo hermano.
- **Cierre de esta sesion como v04 (no sobrescribir v03).** Alternativa
  rechazada: forzar que "queden 3 traspasos" reescribiendo v03 con el
  contenido de ambas sesiones, lo que habria fusionado dos sesiones distintas
  bajo un mismo numero de version y roto la cadena de reapertura existente
  (v03 ya declaraba su propia reapertura como "sesion 4"). Se prioriza
  preservar el historial completo sobre la expectativa inicial de conteo.
- **`datos_sensibles`/`estado_proyecto` curados manualmente, sin heuristica.**
  Alternativa rechazada: inferir con heuristicas (dias desde ultimo cambio,
  presencia de HTML publicado, etc.) y dejar que el titular corrija errores.
  El titular declaro tener "mucho criterio" en esa decision, lo que hace la
  curacion manual mas rapida y mas confiable que cualquier heuristica.
- **Fecha de actualizacion del panorama visual: fecha declarada en el
  traspaso, no mtime de archivo ni ultimo commit.** Alternativa rechazada:
  mtime (fragil ante clonado en otra maquina). Alternativa rechazada: ultimo
  commit (requiere `LEER_GIT=TRUE`, desactivado por default). Ambas
  descartadas por el titular tras presentarle las tres opciones.
- Vigentes las D1-D8 de `activa/decisiones/20260628_decision_arquitectura_orquestador.md`.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| DIAS_OBSOLETO | 21 | 10_configuracion.R | sin cambio |
| LEER_GIT | FALSE | 10_configuracion.R | sin cambio |
| SLUG_ORQUESTADOR | slep_estado_proyectos_monitoreo | 10_configuracion.R | sin cambio |
| AUXILIARES_SEMILLA | slep_monitoreo, slep_resena_proyectos | 10_configuracion.R | sin cambio |
| PATRON_EXCLUIR_UNIVERSO | `\\.git$` | 10_configuracion.R | sin cambio |
| ESQUEMA_INVENTARIO | "1" | 34_compilar_inventario.R | sin cambio |
| COLS_GESTIONADAS | slug, nombre_real, alias_corto, categoria, notas | 31_descubrir_proyectos.R | **nueva (s4)** — declara que columnas gestiona el paso 31; el resto se preserva |
| RUTA_DATA_JS_PORTAFOLIO | NA | 36_generar_panorama_visual.R | **nueva (s4)** — pendiente de configurar; ver P-DATA-JS-RUTA |
| Email local del orquestador | `10123542+tomgc@users.noreply.github.com` | git config | sin cambio (fijado en s3) |

---

## 10. Arquitectura de archivos

Ver `50_documentacion/estructura/estructura_actual.md` (escaner del proyecto;
debe re-correrse al cerrar para reflejar el paso 36 y los archivos nuevos de
esta sesion antes del proximo commit de cierre).

Cambios estructurales: se agrego `30_procesamiento/36_generar_panorama_visual.R`
(nuevo paso del pipeline); `40_salidas/panorama_visual.{html,md}` (salidas
nuevas); `50_documentacion/andamios/auditoria_backlogs_20260629.md` (archivado
desde `40_salidas/`); `50_documentacion/andamios/logs/20260629_panorama_visual_log.md`
(log de encargo autonomo). Sin cambios de convencion de carpetas.

Repo remoto (sin cambios desde s3): `https://github.com/tomgc/slep_estado_area_monitoreo`.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P-REGISTRO-CURAR** (manual del titular, bloqueante para que P4 alcance su
  potencial completo). *Descripcion:* completar `datos_sensibles` y
  `estado_proyecto` en las 16 filas de `registro_proyectos.csv`. *Tipo:*
  documentacion. *Complejidad:* baja, pero requiere criterio del titular
  proyecto por proyecto. *Criterio de exito:* las 16 filas con ambos campos
  poblados; el panorama visual deja de mostrar badges "sin clasificar".
- **P-DATA-JS-RUTA** (mejora). *Descripcion:* fijar la constante
  `RUTA_DATA_JS_PORTAFOLIO` en `36_generar_panorama_visual.R` con la ruta
  absoluta a `slep_monitoreo/data.js`, e implementar el parseo tolerante del
  array `PROYECTOS` (literal JS, no JSON estricto) documentado como pendiente
  en el script. *Tipo:* funcionalidad. *Complejidad:* media (el parseo
  tolerante de JS no-JSON es lo no trivial). *Impacto:* los 11 proyectos
  publicos ganarian `sintesis`/`objetivo`/`tipo` en sus cards. *Criterio de
  exito:* las cards de los proyectos publicos muestran sintesis curada en vez
  de null.
- **P-BACKLOG-NORMALIZAR-ENCABEZADOS** (deuda diferida, Opcion B original).
  *Descripcion:* alinear sufijos, orden de secciones y numeracion de
  encabezados entre los 5 backlogs canonicos (`categoria_desempeno` usa "del
  conteo", `idps` usa "(permanente)" y orden invertido Resumen->Clasificacion,
  etc.). *Tipo:* documentacion (repos hermanos). *Complejidad:* baja-media,
  requiere editar contenido real, no solo mover archivos. *Sugerencia:* un
  encargo por proyecto, no autonomo masivo (riesgo de tocar contenido
  sustantivo sin supervision). *Criterio de exito:* los 5 backlogs comparten
  exactamente los mismos encabezados y orden de secciones.
- **P-BACKLOG-RECONSTRUIR-NO-CANONICOS** (deuda diferida, mayor esfuerzo).
  *Descripcion:* `aprendizajes_ep` y `simce_adecuado` tienen backlog con
  estructura propia (numeracion nueva + mapa de regimenes; "Taxonomia
  vigente" + secciones por sesion) sin las 5 secciones canonicas reconocibles.
  *Tipo:* documentacion (repos hermanos), requiere reescritura de contenido.
  *Complejidad:* alta — exige releer el historial completo de cada proyecto.
  *Sugerencia:* sesion BIBLIOTECA o CONTINUATION dedicada por proyecto, nunca
  un encargo autonomo sin supervision de contenido. *Criterio de exito:* ambos
  backlogs con las 5 secciones canonicas reconocibles por naming.
- **P-BACKLOG-PROPIO-EXTRAER** (higiene del propio orquestador). *Descripcion:*
  este proyecto ya tiene 4 traspasos (v01-v04); segun la regla recien
  parcheada (POLITICA §10), corresponde extraer el backlog a
  `50_documentacion/activa/backlog_acumulativo.md` independiente, dejando solo
  la referencia en el traspaso. *Tipo:* documentacion. *Complejidad:* baja
  (es una extraccion mecanica del contenido ya escrito en la seccion 5 de este
  mismo traspaso). *Criterio de exito:* archivo `backlog_acumulativo.md`
  presente en `activa/`; el traspaso v05 referencia su ruta en vez de
  reproducirlo integro.
- **P-H4-REVISAR-INSTITUCIONAL** (heredado de v02/v03, sin cambios). Marcas
  `# REVISAR` institucionales en los 4 `gobernanza_datos.md` de proyectos
  sensibles. *Tipo:* documentacion (repos hermanos). *Complejidad:* baja.
- **P-H4-REVISAR-LEGAL** (heredado de v02/v03, sin cambios). Marcas
  `# REVISAR (legal)` sobre base legal especifica. *Tipo:* gobernanza/legal,
  requiere area juridica SLEP. *Complejidad:* externa.
- **P-SIMCE-ESTANDARES-VAR-ENV** (heredado de v03, sin cambios). Discrepancia
  de nombre de variable de entorno en `slep_simce_estandares_aprendizaje`.
  *Tipo:* deuda tecnica. *Complejidad:* baja.
- **P-SIMCE-ESTANDARES-CATEGORIA-21719** (heredado de v03, sin cambios).
  Categoria Ley 21.719 sin declarar explicitamente. *Tipo:* gobernanza.
  *Complejidad:* baja.
- **P-PLANTILLA-DESTINO** (heredado de v02/v03, sin cambios). Plantilla de
  gobernanza untracked en repos hermanos. *Tipo:* higiene. *Complejidad:* baja.
- **P-MINUTA-DESVINCULACION-SINTESIS** (hallazgo nuevo, menor). *Descripcion:*
  el cache de panorama de `slep_minuta_desvinculacion` quedo "pendiente de
  sintesis" porque su traspaso avanzo de version durante esta sesion. *Tipo:*
  sintesis. *Complejidad:* baja (re-sintetizar 1 ficha en la proxima corrida
  de `run_all()`).

### Diferidos (se mantienen)

- **P3/Fase 2 (PUSH/PULL con ESTADO.md):** sesion BIBLIOTECA dedicada.
- **Higiene de cobertura organica** (resenas/backlogs ausentes en proyectos
  activos cuando reabran).
- **P5 (LEER_GIT=TRUE):** opcional.

### Auditoria de cierre (POLITICA 5.6)

- Pipeline corre de cero sin intervencion: **Si**.
- Outputs idempotentes: **Si** (md5 verificado en paso 36 y en el registro
  tras el fix del paso 31).
- Constantes nombradas: **Si** (incluyendo las 2 nuevas de esta sesion).
- Naming sin tildes/ñ/espacios: **Si**.
- Sin deuda nueva sin documentar: **Si** (toda registrada arriba, incluyendo
  el backlog propio del orquestador pendiente de extraer).

### Ruta sugerida para la sesion 5

1. **P-REGISTRO-CURAR** (el titular completa datos_sensibles/estado_proyecto;
   sin esto, P4 no muestra su valor completo). Bajo costo, alto impacto.
2. **P-BACKLOG-PROPIO-EXTRAER** (higiene rapida del propio orquestador, ya que
   la regla que la exige se parcheo en esta misma sesion).
3. Si el titular quiere avanzar en estandarizacion de cartera:
   **P-BACKLOG-NORMALIZAR-ENCABEZADOS** (mecanico, bajo riesgo) antes de
   **P-BACKLOG-RECONSTRUIR-NO-CANONICOS** (requiere mas tiempo y criterio).
4. Diferir Fase 2 a sesion BIBLIOTECA.

---

## 12. Instrucciones especificas para la sesion 5

- 🔒 NUNCA escribir fuera de `slep_estado_proyectos_monitoreo/` (R1, cerrado
  por `escribir_seguro`). Hermanos = solo lectura de documentacion curada.
- ⚠️ NO leer `20_insumos/`, `40_salidas/` con datos, OneDrive ni
  `*_volcado_crudo*` (R2). Salida siempre saneada (R3).
- ✅ ANTES de modificar el registro o el paso 31, recordar que
  `COLS_GESTIONADAS` declara las columnas que el paso 31 sincroniza; cualquier
  columna nueva debe pasar por el mecanismo de preservacion, no asumirse
  automatica.
- ⚠️ NO escribir en repos hermanos sin autorizacion explicita del titular por
  cada repo/operacion (regla aplicada y respetada en s4 para los 4 renames).
- ✅ Si un `git mv` falla porque el archivo fuente esta untracked, usar `mv`
  plano + `git add` del destino (no forzar, no asumir ausencia).
- ✅ Si un guardrail de working tree limpio bloquea una operacion de bajo
  riesgo, usar staging selectivo por pathspec antes de relajar el guardrail
  globalmente.
- ⚠️ NO tocar Fase 2 (ESTADO.md/SETTINGS en hermanos) sin sesion dedicada.
- ✅ Verificar que `traspaso_cierre_v04.md` (este archivo) y
  `traspaso_cierre_v03.md` queden ambos commiteados al repo antes de cerrar
  esta sesion — ambos estaban pendientes de versionar al inicio de la sesion 4.

---

## 13. Fragmentos de referencia

```r
# Patron correcto: registro con columnas gestionadas + columnas extra preservadas
COLS_GESTIONADAS <- c("slug", "nombre_real", "alias_corto", "categoria", "notas")
# leer_registro_previo() preserva todo lo que NO esta en COLS_GESTIONADAS,
# arrastrando el valor previo por slug (o "" si la fila es nueva).

# Verificar idempotencia del registro tras una corrida:
source("00_run_all.R"); run_all()
# diff de las columnas originales (las 5 primeras) debe ser vacio:
# cut -d, -f1-5 registro_nuevo.csv | diff - <(cut -d, -f1-5 registro_viejo.csv)

# Rename seguro de un archivo trackeado (preserva historial):
#   git -C <ruta> mv <fuente> <destino> && git -C <ruta> commit <fuente> <destino> -m "..."
# Si el origen esta untracked (git mv falla):
#   mv <fuente> <destino> && git -C <ruta> add <destino> && git -C <ruta> commit <destino> -m "..."

# Verificar referencias de red en un HTML "autocontenido":
#   grep -E '<link|@import|src=.?http|href=.?http|url\(.?http' archivo.html
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_estado_proyectos_monitoreo, sesion 5 (Sonnet 4.6)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo
  (POLITICA + SETTINGS) vive en la knowledge base del Project; leelo desde
  ahi (version vigente: POLITICA v5.1, SETTINGS v5). Adjunto el traspaso v04 y
  el escaner."
- **Documentos para la proxima sesion, en tres bloques:**
  1. *Protocolo en knowledge base (NO se adjuntan, solo verificar version):*
     `POLITICA_PROYECTO.md` (v5.1), `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (v5).
  2. *Opcionales segun foco real:* `CLAUDE.md` si correra en Claude Code;
     `encargo_autonomo_claude_code_v1.md` si se redacta otro encargo autonomo
     (p. ej. para P-BACKLOG-NORMALIZAR-ENCABEZADOS).
  3. *Especificos de la sesion (SI se adjuntan):* `traspaso_cierre_v04.md`
     (este archivo); `50_documentacion/estructura/estructura_actual.md`
     (re-correr el escaner antes de cerrar esta sesion 4 para que el snapshot
     refleje los archivos nuevos).
- **Nota final:** verificar que `traspaso_cierre_v03.md` y este
  `traspaso_cierre_v04.md` quedaron ambos commiteados antes de abrir la
  sesion 5 — ambos estaban pendientes de versionar al cierre de la sesion 4.
