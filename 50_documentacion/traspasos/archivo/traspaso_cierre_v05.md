# Traspaso de cierre v05 — slep_estado_proyectos_monitoreo

## 1. Identificacion

- **Proyecto:** slep_estado_proyectos_monitoreo (orquestador de estado de la cartera).
- **Version:** v05. **Fecha:** 2026-06-30/07-01. **Sesion:** 5 (CONTINUATION).
- **Foco:** bugfix B6 (mojibake paso 36); implementacion de P-DATA-JS-RUTA
  (integracion data.js del portafolio); extraccion de backlog_acumulativo.md
  propio (P-BACKLOG-PROPIO-EXTRAER); rediseno acordeon del panorama visual +
  cambio de titulo; diseno completo de Fase 2 (PUSH de ESTADO.md, parche A a
  SETTINGS v6->v7); propagacion batch de ESTADO.md a 13+2 hermanos; parche a
  POLITICA (v5.1->v5.2, regla 0.5) y SETTINGS (v6->v7, seccion 2.2.15) sobre
  registro obligatorio de errores del asistente; implementacion del lector
  ESTADO.md con fallback PULL en el orquestador (32/34/35 + 10_utils.R).
- **Entorno:** Claude Code (modo autonomo, multiples encargos dirigidos por
  meta) + conversacion con el asistente de analisis. R, macOS, locale C.
- **Archivos principales modificados:**
  - **Este repo (orquestador):** `30_procesamiento/36_generar_panorama_visual.R`
    (B6, P-DATA-JS-RUTA, rediseno acordeon, titulo); `30_procesamiento/32_localizar_documentos.R`
    (deteccion ESTADO.md, regla de desync, resolver_estado); `30_procesamiento/34_compilar_inventario.R`
    (persistencia tipo_pendiente/estado en inventario); `30_procesamiento/35_compilar_panorama.R`
    (rama PUSH/PULL, refactor leer_cache); `10_utils/10_utils.R` (parsear_front_matter
    compartido); `10_utils/10_configuracion.R` (TZ_ORQUESTADOR); `50_documentacion/activa/backlog_acumulativo.md`
    (nuevo, extraido); `CLAUDE.md` (Ultimos cambios).
  - **Repos hermanos** (autorizacion explicita batch del titular para Fase 2;
    ver seccion 8): 13 hermanos recibieron `50_documentacion/activa/ESTADO.md`
    nuevo; 2 de ellos (`slep_alertas_ael`, `slep_minuta_desvinculacion`)
    recibieron una segunda regeneracion tras detectar desync real contra su
    traspaso mas reciente.
  - **Knowledge base del Project:** `POLITICA_PROYECTO.md` v5.1->v5.2 (regla
    0.5) y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` v5->v6->v7 (2.1bis + 2.2.15),
    ya pegados por el titular en la knowledge base de los 16 proyectos.

## 2. Resumen ejecutivo

La sesion cerro primero los 3 objetivos heredados del traspaso v04 (B6,
P-DATA-JS-RUTA, extraccion de backlog), verificados con hash real de commit
en cada caso. A pedido del titular se redisenio el panorama visual (layout
acordeon de ancho completo reemplazando el grid de cards tipo post-it, mas
cambio de titulo), verificado con un test funcional de DOM en Node dado que
el entorno de Claude Code no permitia screenshot. El titular pidio luego una
corrida diaria de agenda priorizada; el analisis establecio que esta requiere
primero un formato estandarizado y parseable de pendientes entre los 16
hermanos, lo que llevo a fusionar ese requerimiento con el esbozo de Fase 2
(ESTADO.md) ya pendiente, en vez de crear un segundo estandar. Se diseno el
parche completo a SETTINGS (subseccion 2.1bis) y se ejecuto un encargo batch
autorizado explicitamente por el titular que genero ESTADO.md en 13 de 16
hermanos (3 sin traspaso quedaron fuera, sin inventar contenido). Dos casos de
desync real se detectaron y corrigieron en el proceso (alertas_ael por grafia
de traspaso no cubierta por el glob original; minuta_desvinculacion por avance
de v34 a v37 durante la sesion). Se implemento en el orquestador la lectura de
ESTADO.md con fallback a PULL, con verificacion empirica de las 16(17) fichas,
idempotencia y un test controlado de la regla de desincronizacion. Aparecio un
proyecto nuevo en la cartera (`slep_paes`) durante la ultima corrida, aun sin
registrar. Se detectaron y corrigieron dos errores del asistente (ambos del
mismo patron: asumir un canal de transferencia de archivo inexistente o
etiquetar como "tarea del titular" algo que era edicion propia), lo que
disparo el diseno e implementacion de una nueva regla estructural (POLITICA
0.5 / SETTINGS 2.2.15) para registrar este tipo de error de forma comparable
entre los 16 proyectos de la cartera. Estado general: sano, sin bugs activos
heredados; el pendiente de mayor peso es decidir que hacer con slep_paes y
completar el ciclo Fase 2 (pieza C, agenda priorizada, sigue bloqueada).

## 3. Estado al cierre

**Que funciona (ultima ejecucion exitosa 2026-07-01):**
- `run_all()` corre de cero sin intervencion manual sobre 17 hermanos
  (16 + slep_paes nuevo), genera panorama.md, panorama_visual.html/.md e
  inventario_cartera.json/.parquet. Idempotente (md5 estable en 2+ corridas,
  excluyendo timestamp).
- El panorama visual usa layout acordeon de ancho completo (16(17) filas,
  toggle funcional verificado con DOM real en Node), titulo actualizado a
  "Cartera de proyectos Area de Monitoreo".
- Integracion de `data.js` del portafolio: 11 cards con `tipo`/`objetivo`/
  `sintesis` poblados via mapeo por `orden` (constante `MAPEO_ORDEN_SLUG`).
- Lectura de `ESTADO.md` (Fase 2 PUSH) con fallback a PULL: 8 PUSH / 9 PULL
  sobre 17 proyectos en la ultima corrida (conteo exacto en seccion 4).
- 0 mojibake (grep `<[0-9a-f]{2}>` = 0 en html/md tras B6).

**Que no funciona / queda pendiente:**
- `slep_paes` (proyecto nuevo detectado) no esta en `registro_proyectos.csv`;
  no tiene curacion manual (nombre_real, alias, categoria, datos_sensibles,
  estado_proyecto). Sin ESTADO.md ni traspaso conocido aun.
- 4 hermanos (`dashboard_personal_monitoreo`, `georreferenciacion`,
  `seguimiento_educacion_inicial`, y parcialmente `alertas_ael`) quedan en
  PULL por un patron de "falso-desync" cuando el traspaso se guarda pasada la
  medianoche de su fecha de cierre declarada (`ultima_actividad` < mtime por
  1 dia sin ser un desync real de contenido). No corregido (fuera de alcance
  de la tarea que lo detecto); ver pendiente en seccion 11.
- Pieza C de Fase 2 (agenda diaria priorizada, panorama reordenado por
  `tipo_pendiente`) sigue sin implementar: requiere que mas hermanos adopten
  ESTADO.md y una sesion de codigo aparte con su propio gate.
- 3 hermanos sin traspaso (`slep_costapresente`, `slep_minuta_asistencia`,
  `slep_resena_proyectos`) no pueden adoptar Fase 2 hasta su primer cierre
  formal.

**Delta respecto a v04:** +3 features (B6 resuelto, data.js integrado,
acordeon), +1 arquitectura nueva completa (Fase 2: parche A + piezas B/C
disenadas, B ejecutada), +1 regla estructural nueva (POLITICA 0.5 / SETTINGS
2.2.15), +1 hallazgo de cartera (slep_paes nuevo), +2 errores del asistente
registrados.

## 4. Registro detallado de cambios

**Cambio 1 — Bug B6 (mojibake paso 36).** Archivo:
`36_generar_panorama_visual.R`. 7 cadenas hardcodeadas (titulo, header,
badges, "Ultima actualizacion", "Reseña del itinerario", "Proximos pasos")
mostraban mojibake en el HTML/MD generado. Causa raiz: literales no-ASCII
parseados bajo locale C (`run_all()` hace `source()` sin `encoding=`) quedan
con `Encoding()` "unknown" (bytes UTF-8 correctos, etiqueta incorrecta); al
concatenarse via `paste0()`/`sprintf()` con strings ya marcados `"UTF-8"`, R
recodifica el literal y, como C no representa bytes altos, lo escapa como
texto literal. Fix: helper local `u8()` (`Encoding(x) <- "UTF-8"`, solo
reetiqueta) aplicado antes de mezclar. Verificado: 0 mojibake, idempotencia
en 2 corridas, referencias de red sin alterar. Commit `96e1433`.

**Cambio 2 — P-DATA-JS-RUTA.** Mismo archivo. `RUTA_DATA_JS_PORTAFOLIO` fijada
a lectura in situ de `~/Projects/slep_monitoreo/data.js` (R2: nunca copiado
ni versionado). Parser: `jsonlite::toJSON` tras quotear las 7 claves
conocidas + split por objeto con `tryCatch` por entrada (decision B.2: mas
robusto que regex de campo para el array multilinea `sintesis[]`). Mapeo
titulo->slug resuelto por `orden` (entero estable) via `MAPEO_ORDEN_SLUG` con
titulo literal en comentario inline por entrada (gate de aprobacion cumplido
antes de implementar). Resultado: 11/16 cards pobladas, 5 sin entrada quedan
null con gracia. Verificado con spot-check 1:1 verbatim en 2 cards,
idempotencia, 0 mojibake. Commit `6ecbb43`.

**Cambio 3 — Extraccion de backlog propio (P-BACKLOG-PROPIO-EXTRAER).**
Archivo nuevo `50_documentacion/activa/backlog_acumulativo.md` (47 entradas,
5 sesiones, extraido de la seccion 5 de v04 con 2 entradas nuevas de esta
sesion incorporadas). Commit `1c3912f`. Nota de proceso: el archivo lo
transcribio el titular manualmente a la ruta del repo (no existe canal de
transferencia de archivo entre este chat y el filesystem local); Claude Code
detecto la preexistencia, verifico que el contenido coincidia con lo
aprobado, y escalo la decision antes de commitear (ver error 1, seccion 15).

**Cambio 4 — Rediseno acordeon + titulo.** Mismo archivo del script 36. Grid
de 3 columnas tipo card reemplazado por lista acordeon de ancho completo
(toggle JS, sin libreria externa), verificado funcionalmente con un shim de
DOM en Node (16 filas, toggle real, aria-expanded correcto) porque el
screenshot no era viable en el entorno de Claude Code. Titulo cambiado a
"Cartera de proyectos Area de Monitoreo" en `<title>`, `<h1>` y el `#` del
`.md`. El `.md` (no interactivo) muestra ahora todos los parrafos de
`sintesis[]` directamente, sin indicador "+N mas" (decision declarada antes
de implementar); constante `N_PARRAFOS_SINTESIS_CARD` eliminada por no tener
mas uso. Commit `6dc127d`.

**Cambio 5 — Diseno de Fase 2 completo (arquitectura, sin codigo de
hermanos).** Tres artefactos BIBLIOTECA producidos y entregados al titular:
`fase2_push_estado_v1.md` (version inicial), `fase2_push_estado_v2.md`
(version final, agrega campo `tipo_pendiente` al front matter de ESTADO.md
tras decidir fusionar el requerimiento de agenda diaria con Fase 2), y
`parche_a_settings_v6.md` (texto aislado del parche, superado por el archivo
completo de la seccion 6). Decision de diseno: modelo hibrido PUSH+PULL,
recomendacion del esbozo original del titular (`esbozo_fase2_estado_estandarizado.md`
§5), sin alternativa real compitiendo.

**Cambio 6 — Propagacion batch de ESTADO.md.** Autorizacion explicita batch
del titular (excepcion puntual a la regla de "autorizacion por repo"; ver
seccion 8). Claude Code inventario los 16 hermanos (3 sin traspaso, omitidos
sin inventar contenido), destilo 13 con subagentes paralelos de solo-lectura
(spot-check anti-alucinacion contra la fuente antes de escribir), escribio
13 `ESTADO.md` con 1 commit atomico por repo. Hallazgo sistemico: el
vocabulario real de "tipo" en los pendientes de los traspasos (`administrativo`,
`contenido`, `documentacion`, `deuda de datos`, etc.) no coincide con el enum
de `tipo_pendiente` (que es la taxonomia de PRIORIDAD de sesion de SETTINGS
§1.2.4, distinta de la taxonomia TEMATICA del backlog de cada hermano);
resuelto manteniendo el enum sin ampliar y aclarando la regla de traduccion
en el parche A definitivo. Dos casos de semaforo revisados manualmente por el
titular con el texto real delante: `slep_aprendizajes_ep` confirmado activo;
`slep_georreferenciacion` corregido a pausa (proyecto completo a la espera de
aprobacion de un tercero externo). Commits: 13 iniciales (ver tabla en
seccion 8) + `5bff039` (correccion de semaforo georreferenciacion).

**Cambio 7 — Regeneracion de 2 ESTADO.md por desync real detectado durante
la implementacion del lector (cambio 8).** `slep_alertas_ael`: el traspaso
mas reciente real es `traspaso-cierre-v02.md` (grafia con guion), no v01; el
glob de la tarea de propagacion original no cubria esa grafia. Regenerado
desde v02, commit `aa9568f`. Nota: sigue en PULL porque v02 declara fecha
2026-06-09 pero se guardo 2026-06-10 (mismo patron de "falso-desync" del
pendiente de seccion 11; no se fuerza la fecha). `slep_minuta_desvinculacion`:
el repo avanzo a v35/v36/v37 durante la propia sesion; el ESTADO.md ya habia
sido actualizado intencionalmente a v35 cuando se detecto el conflicto.
Decision del titular (gate explicito, no improvisado por Claude Code):
regenerar desde v37 (el latest real), no desde v34 como pedia la instruccion
original ni mantener v35. Commit `87936df`. Transicion confirmada: PULL ->
PUSH tras la regeneracion.

**Cambio 8 — Lector de ESTADO.md en el orquestador (Fase 2, pieza de
codigo).** `parsear_front_matter()` factorizado a `10_utils.R` (reutilizado
por `32_localizar_documentos.R` para hermanos y por `35_compilar_panorama.R`
para el cache propio, sin duplicar mecanismo). `resolver_estado()` en 32
implementa la regla de desincronizacion (`ultima_actividad` vs mtime del
traspaso mas reciente, resuelto con `resolver_traspaso()` existente que
cubre todas las grafias/versiones). `tipo_pendiente` y `estado.presente`
persistidos en el inventario JSON/parquet (34) como hecho de contenido
byte-estable, disponibles para la futura pieza C sin tocar el paso 36.
Bug lateral encontrado y corregido durante la implementacion: `as.Date(file.mtime())`
asume UTC, no zona local, produciendo falsos-desync para traspasos guardados
de noche el mismo dia; corregido capturando `TZ_ORQUESTADOR` al bootstrap
(10_configuracion.R) y pasandolo explicito a `format()`. Verificado con test
controlado de desync forzado (sin tocar hermanos), spot-check 1:1 de 2
proyectos PUSH contra su ESTADO.md real, idempotencia en 2+ corridas, 0
mojibake. Commit `c6df30d` (codigo) + `2577d9d` (outputs regenerados).

**Cambio 9 — Parche de registro de errores del asistente (POLITICA 0.5 /
SETTINGS 2.2.15).** A peticion explicita del titular tras el error 2 (seccion
15). `POLITICA_PROYECTO.md` v5.1->v5.2: nueva regla 0.5, registro obligatorio
de errores con disparador exhaustivo (cualquier desviacion de regla canonica
detectada por Claude o por el titular, nombrada como error o no).
`SETTINGS_Y_PROMPTS_OPERACIONALES.md` v6->v7: nueva subseccion 2.2.15, tabla
de campos fijos (momento, disparador, que_paso, regla_violada, causa_raiz,
salvaguarda_presente, patron), declarada como artefacto de analisis CRUZADO
entre los 16 proyectos de la cartera, no solo memoria de sesion individual.
§2.2 y §2.3 actualizados (punto 15 de la lista de secciones obligatorias;
regla 11 de redaccion: la tabla es obligatoria incluso vacia). Archivos
completos entregados y ya pegados por el titular en la knowledge base de los
16 proyectos (confirmado por el titular, no verificable por el asistente).

## 5. Backlog acumulativo

Ver `50_documentacion/activa/backlog_acumulativo.md` (47 entradas al cierre
de la sesion anterior + 2 mas incorporadas durante esta sesion antes de
extraerlo = 47 total ya reflejadas; esta sesion agrega entradas adicionales
que el titular debe incorporar en el proximo cierre o sesion dedicada: B6,
P-DATA-JS-RUTA y extraccion ya estan en el archivo; rediseno acordeon,
Fase 2 completa (diseno + propagacion + lector), slep_paes nuevo, y la regla
de registro de errores AUN NO estan incorporados al archivo — pendiente
mecanico para el proximo cierre o para esta misma sesion si el titular lo
pide). No reproducir el contenido aqui (regla vigente desde v05).

## 6. Bugs de la sesion

**Bug B6 (mojibake paso 36):** ver cambio 1, seccion 4. Resuelto. Patron:
mismatch UTF-8/nativo en literales no-ASCII bajo locale C. Misma familia que
el mojibake de em-dash de la sesion 1 (backlog #17).

**Bug lateral (tz UTC en deteccion de desync):** ver cambio 8, seccion 4.
Resuelto. `as.Date(file.mtime())` asume UTC; corregido con `TZ_ORQUESTADOR`
capturado al bootstrap.

**Patron abierto, no bug de codigo (pendiente, ver seccion 11):**
falso-desync sistematico cuando un traspaso se guarda pasada la medianoche
de su fecha de cierre declarada. Afecta 4 hermanos en la corrida de esta
sesion. No es un bug (la regla funciona segun su definicion), es una
decision de diseno de la regla que vale la pena revisar.

## 7. Aprendizajes y restricciones (nuevos en s5)

- **Glob de traspasos debe cubrir todas las grafias.** El glob usado en la
  propagacion batch original de ESTADO.md no cubria la grafia con guion
  (`traspaso-cierre-vNN.md` vs `traspaso_cierre_vNN.md`), causando que
  `alertas_ael` se destilara desde un traspaso viejo (v01) cuando existia
  uno mas nuevo (v02). Regla: cualquier tarea que enumere traspasos de
  hermanos debe usar la misma funcion `resolver_traspaso()` que ya usa el
  orquestador (cubre todas las grafias/versiones conocidas), no un glob
  ad-hoc nuevo.
- **`tipo_pendiente` (ESTADO.md) y la clasificacion tematica del backlog son
  taxonomias distintas a proposito.** No se debe ampliar el enum de
  `tipo_pendiente` para acomodar vocabulario tematico del backlog
  (`administrativo`, `contenido`, etc.); se traduce por significado. Regla
  ya incorporada en SETTINGS §2.1bis.
- **Fecha declarada del traspaso no es el mtime del archivo.** Cuando un
  traspaso se guarda en disco despues de la medianoche de su fecha de cierre
  declarada, `ultima_actividad` (que debe reflejar la fecha declarada, no
  inventarse) queda 1 dia detras del mtime real, disparando falsos-desync.
  No corregido esta sesion (ver pendiente, seccion 11).

## 8. Decisiones de diseno

**D1 — Modelo hibrido PUSH+PULL para Fase 2.** Alternativas: PUSH puro
(rompe cobertura en hermanos lentos en adoptar) vs PULL puro (statu quo,
costoso de recomputar) vs hibrido con fallback por desincronizacion.
Justificacion: recomendacion ya razonada en el esbozo original del titular;
sin alternativa real compitiendo. Implicancia: la pieza C (agenda priorizada)
queda bloqueada hasta que suficientes hermanos adopten ESTADO.md.

**D2 — Fusionar el requerimiento de "agenda diaria" con Fase 2 en vez de
crear un segundo estandar.** Alternativas: formato minimo separado solo para
pendientes-priorizables, o fusion con ESTADO.md. Decision del titular:
fusionar. Justificacion: evita dos estandares de formato distintos para los
16 hermanos; el campo `tipo_pendiente` cubre ambos usos.

**D3 — `tipo_pendiente` usa el enum de prioridad de SETTINGS §1.2.4, no la
taxonomia tematica del backlog.** Ver aprendizaje en seccion 7. Decision
tomada junto con el titular tras encontrar el desajuste real en los 16
traspasos.

**D4 — Autorizacion batch explicita para propagar ESTADO.md a 13 hermanos
de una sola corrida.** Excepcion puntual y declarada a la regla general de
"autorizacion por repo, por operacion" (gobernanza POLITICA 0.3). El titular
la otorgo explicitamente para esta tarea unica; no es un cambio permanente
a la regla de autorizacion.

**D5 — Regenerar `minuta_desvinculacion` desde v37, no desde v34 (instruccion
original) ni mantener v35 (estado intermedio).** Gate de decision real:
Claude Code detecto el conflicto (repo avanzo v34->v37 durante la sesion) y
lo escalo sin improvisar. El titular eligio v37 (el estado real mas
reciente) sobre las otras 2 opciones ofrecidas.

**D6 — Semaforo de `slep_georreferenciacion` corregido a pausa.** Ver cambio
6. Criterio aplicado: proyecto completo sin accion ejecutable del titular
(espera de aprobacion de un tercero) es pausa; un item puntual bloqueado
dentro de un proyecto con trabajo disponible (`aprendizajes_ep`) sigue activo.
Este criterio quedo incorporado textualmente en SETTINGS §2.1bis.

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `RUTA_DATA_JS_PORTAFOLIO` | `file.path(RAIZ_PROYECTOS, "slep_monitoreo", "data.js")` | 36 | Nueva (P-DATA-JS-RUTA) |
| `MAPEO_ORDEN_SLUG` | 11 entradas, orden->slug con titulo literal en comentario | 36 | Nueva |
| `N_PARRAFOS_SINTESIS_CARD` | (eliminada) | 36 | Introducida y eliminada en la misma sesion (cambio 2 -> cambio 4) |
| `TZ_ORQUESTADOR` | zona local capturada al bootstrap | 10_configuracion.R | Nueva (fix bug lateral tz) |
| Enum `tipo_pendiente` | `bug\|bloqueante\|deuda_heredada\|deuda_tecnica\|nuevo\|cosmetica\|ninguno` | SETTINGS §2.1bis | Taxonomia de prioridad, no tematica |

## 10. Arquitectura de archivos

Sin cambios estructurales respecto a la politica. Nuevo archivo canonico:
`50_documentacion/activa/backlog_acumulativo.md`. Referencia al escaner:
pendiente re-ejecutar `00_escanear_proyecto.R` antes del proximo cierre (no
se corrio en esta sesion; el `estructura_actual.md` disponible es el de
2026-06-29, previo a los cambios de hoy).

## 11. Pendientes y ruta sugerida

**P-PAES-REGISTRAR** — descripcion: `slep_paes` aparecio como hermano nuevo
en la ultima corrida, sin fila en `registro_proyectos.csv` ni curacion
manual. Tipo: nuevo. Impacto: la ficha en el panorama sale vacia/generica
para ese proyecto. Complejidad: baja (una fila de CSV, curacion manual del
titular). Precaucion: no inventar `nombre_real`/categoria; es curacion
100% manual segun regla vigente. Criterio de exito: fila poblada, aparece
correctamente en la proxima corrida de `run_all()`.

**P-DESYNC-MARGEN** — descripcion: la regla de desincronizacion (`ultima_actividad`
< mtime del traspaso) produce falsos-PULL cuando el traspaso se guarda
pasada la medianoche de su fecha declarada (4 casos detectados esta sesion).
Tipo: deuda tecnica. Impacto: bajo (el fallback a PULL sigue siendo
correcto, solo menos eficiente). Complejidad: baja-media (cambiar a
`ua < mtime - 1 dia`, o comparar contenido/md5 en vez de fecha). Precaucion:
declarar la decision antes de implementar (puede ocultar desyncs reales si
el margen es muy amplio). Criterio de exito: los 4 casos conocidos pasan a
PUSH sin introducir falsos negativos verificables.

**P-FASE2-PIEZA-C** — descripcion: implementar el reordenamiento del
acordeon por `tipo_pendiente` (agenda diaria priorizada), el objetivo
original que disparo todo el trabajo de Fase 2 de esta sesion. Tipo:
funcionalidad nueva. Impacto: alto (es el entregable que el titular pidio
originalmente). Complejidad: media. Dependencias: mas hermanos con
ESTADO.md sincronizado (hoy 8/17 PUSH); considerar si conviene esperar a
mejorar cobertura antes de esta pieza. Precaucion: requiere su propio
gate de aprobacion (toca el nucleo del orquestador, `35_compilar_panorama.R`).
Criterio de exito: el acordeon del panorama visual muestra primero
bug/bloqueante, luego deuda, luego el resto, verificable contra el
`tipo_pendiente` real de cada `ESTADO.md`.

**P-ESTADO-3-SIN-TRASPASO** — descripcion: `slep_costapresente`,
`slep_minuta_asistencia`, `slep_resena_proyectos` no pueden adoptar Fase 2
hasta su primer cierre formal. Tipo: bloqueante (para cobertura completa de
Fase 2, no para el proyecto individual). Dependencias: fuera del control de
este proyecto; depende de que esos 3 hermanos generen su primer traspaso.

**Auditoria de cierre (politica 5.6, preguntas "Cierre"):**
- ¿Cada transformacion critica tiene check de validacion? Si (spot-checks,
  tests controlados de desync, verificacion de mojibake en cada cambio).
- ¿Outputs reproducibles e idempotentes? Si, verificado en cada cambio.
- ¿Decisiones metodologicas como constantes nombradas? Si (ver seccion 9).
- ¿Nombres de archivos sin tildes/ñ/espacios? Si, sin desviaciones nuevas.

**Ruta sugerida para sesion 6:** Prioridad 1: P-PAES-REGISTRAR (mecanica,
del titular, 5 minutos) + incorporar las entradas de esta sesion al backlog
acumulativo (mecanico). Prioridad 2 (si el titular quiere seguir con Fase
2): P-DESYNC-MARGEN antes que P-FASE2-PIEZA-C, porque mejora la cobertura
PUSH real sin tocar el nucleo del orquestador. Diferir P-FASE2-PIEZA-C hasta
tener mas cobertura o decision explicita de proceder igual con 8/17.

## 12. Instrucciones especificas para la sesion 6

- ⚠️ No implementar P-FASE2-PIEZA-C sin gate de aprobacion explicito (toca
  `35_compilar_panorama.R`, nucleo del orquestador).
- ⚠️ No ampliar el enum de `tipo_pendiente` con vocabulario tematico del
  backlog; traducir por significado (D3, seccion 8).
- ✅ ANTES de cualquier tarea que enumere traspasos de hermanos, usar
  `resolver_traspaso()` (ya existe en el orquestador), no un glob nuevo.
- 🔒 Nunca escribir fuera del propio repo sin autorizacion explicita por
  repo/operacion (la autorizacion batch de esta sesion fue puntual, no es
  precedente permanente).
- ✅ ANTES de dar por cerrada cualquier tarea que genere archivos nuevos,
  confirmar hash de commit en terminal, no solo confiar en el reporte (regla
  aplicada consistentemente esta sesion tras B6).

## 13. Fragmentos de referencia

```r
# Patron correcto para parsear front matter (10_utils.R, reutilizado)
parsear_front_matter <- function(ruta) {
  lineas <- readr::read_lines(ruta, locale = readr::locale(encoding = "UTF-8"))
  # ... (ver 10_utils.R para implementacion completa)
}
```

```r
# Patron correcto para forzar UTF-8 en literales no-ASCII bajo locale C (B6)
u8 <- function(x) { Encoding(x) <- "UTF-8"; x }
# aplicar ANTES de mezclar con strings ya marcados UTF-8 via paste0()/sprintf()
```

## 14. Reapertura

**Nombre del chat:** `slep_estado_proyectos_monitoreo, sesion 6 (Sonnet 4.6)`

**Mensaje de apertura pre-armado:**
> Continuemos con slep_estado_proyectos_monitoreo. Tipo CONTINUATION. El
> protocolo (POLITICA_PROYECTO.md v5.2 + SETTINGS_Y_PROMPTS_OPERACIONALES.md
> v7) vive en la knowledge base del Project y se lee desde ahi. Adjunto el
> traspaso v05 y el escaner mas reciente.

**Documentos para la proxima sesion:**

1. *Protocolo en knowledge base* (verificar que esten al dia, NO adjuntar):
   `POLITICA_PROYECTO.md` (v5.2), `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (v7).
2. *Opcionales segun el foco real de la sesion 6*: `encargo_autonomo_claude_code_v1.md`
   si P-FASE2-PIEZA-C se aborda como encargo autonomo dirigido por meta.
3. *Especificos de la sesion (SI se adjuntan):* `traspaso_cierre_v05.md`
   (este archivo); escaner actualizado (⚠️ pendiente re-ejecutar
   `00_escanear_proyecto.R`, el disponible es previo a esta sesion);
   `backlog_acumulativo.md` si se va a incorporar las entradas nuevas de
   esta sesion.

**Nota final obligatoria:** el escaner disponible (`estructura_actual.md`,
2026-06-29) es PREVIO a todos los cambios de esta sesion. Re-ejecutar
`00_escanear_proyecto.R` antes de la sesion 6 o al abrirla.

## 15. Errores del asistente

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron |
|---|---|---|---|---|---|---|
| Encargo de extraccion de backlog (P-BACKLOG-PROPIO-EXTRAER) | usuario lo corrigio, con dureza | El asistente redacto un encargo a Claude Code diciendo "te adjunto el archivo... pegalo o transcribelo a la ruta del repo", asumiendo un canal de transferencia de archivo entre este chat y el filesystem local de Claude Code que no existe | `encargo_autonomo_claude_code_v1.md` §7 (antipatron "el archivo de referencia que no llega": lo que Claude Code necesita debe estar EN EL FILESYSTEM o INCRUSTADO en el texto; "te lo paso aparte" no es fuente accesible); ademas `userPreferences`, tareas mecanicas manuales son del titular | El asistente aplico un patron de redaccion valido para archivos ya subidos a ESTE chat, sin verificar que el destino real (filesystem de Claude Code en la Mac del titular) no comparte ese canal | POLITICA §0.4 (tareas mecanicas manuales); `encargo_autonomo_claude_code_v1.md` §7 (antipatron documentado explicitamente) | nuevo (primera ocurrencia de este patron especifico en la sesion) |
| Pedido de actualizar SETTINGS con el parche de errores | usuario lo señalo explicitamente ("eso es trabajo tuyo y lo sabes") | El asistente ofrecio redactar solo el contenido del parche y pedir al titular que lo "aplicara" el mismo en la knowledge base, en vez de entregar el archivo completo ya editado y listo para subir | `userPreferences`, seccion "Code edits": entregar el archivo COMPLETO actualizado, nunca fragmentos ni instrucciones de tipo "pega esto"; POLITICA §0.4 (distincion entre tarea mecanica real y edicion de contenido) | El asistente clasifico mal la tarea: etiqueto como "mecanica del titular" (subir el archivo a la interfaz) una tarea que en realidad requeria primero produccion de contenido (la edicion completa del documento), que si es responsabilidad del asistente; confundio la operacion de plataforma (esa si es del titular) con la produccion del contenido (esa es del asistente) | `userPreferences` (explicita, "Code edits — never deliver fragments"); POLITICA §0.4 | variante de la fila anterior: ambos son fallos de clasificar mal "quien produce/mueve que", bajo presion de avanzar rapido |

**Nota del asistente:** ambos errores comparten causa raiz de fondo (no
verificar, antes de responder, la distincion entre "quien produce el
contenido" y "quien ejecuta la operacion mecanica de moverlo/subirlo"), pese
a que las reglas relevantes (POLITICA §0.4, `userPreferences`, el antipatron
documentado en `encargo_autonomo_claude_code_v1.md`) ya estaban disponibles
en el contexto en ambos casos. El titular solicito explicitamente que este
patron repetido se analice para buscar una solucion estructural nueva, no
solo repetir la regla con mas enfasis; queda como pendiente de analisis para
sesion BIBLIOTECA (posiblemente cruzando con otros proyectos de la cartera
si el mismo patron aparece registrado ahi, segun el proposito declarado de
SETTINGS §2.2.15).
