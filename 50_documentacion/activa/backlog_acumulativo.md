# Backlog acumulativo — slep_estado_proyectos_monitoreo

> **Archivo canonico** (POLITICA_PROYECTO.md §10 / SETTINGS_Y_PROMPTS_OPERACIONALES.md
> §2.2.5). Registro historico vivo: en cada cierre se copia integro y se agregan
> los cambios nuevos al final. Jamas se reescriben, resumen ni renumeran entradas
> anteriores; un error se corrige con una entrada nueva.
>
> **Extraido desde:** `traspaso_cierre_v04.md` §5, en el cierre de la sesion 5
> (P-BACKLOG-PROPIO-EXTRAER). A partir de ahora los traspasos solo referencian
> esta ruta.
>
> **Actualizado en sesion 6:** se incorporan las entradas 48-53
> (`traspaso_cierre_v05.md` §4), pendientes de incorporacion al cierre de la
> sesion 5 (nota explicita en `traspaso_cierre_v05.md` §5).

---

## Objetivo del proyecto (permanente)

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

## Nota metodologica (permanente)

Un "cambio" es una solicitud distinguible del titular o una decision de diseno
con efecto en el producto, no cada accion tecnica que la implementa. No cuentan
los errores del asistente corregidos de inmediato (si cuentan los bugs
reportados por el titular o detectados por auto-auditoria con efecto real en
el producto, como el bug del paso 31). La clasificacion es por intencion
primaria. Fuentes del conteo: los traspasos, los logs de encargos autonomos y
los commits.

## Clasificacion tematica

| Categoria | N | Descripcion |
|---|---|---|
| Andamiaje/estructura | 7 | Estructura Rama A, .gitignore y .Rproj, escaner del propio repo, tests, siembra del registro. |
| Pipeline determinista | 6 | Scripts 31-35 y el orquestador 00_run_all.R. |
| Utilidades/gobernanza por codigo | 3 | 10_utils.R y 10_configuracion.R: escritura confinada y descubrimiento de hermanos. |
| Sintesis cualitativa | 2 | 14 fichas L2 iniciales y la re-sintesis de 3 en s2. |
| Operacion/regeneracion | 8 | Corridas de run_all para regenerar salidas o incorporar hermanos nuevos. |
| Documentacion | 9 | README, CLAUDE, cobertura, esbozo Fase 2, traspaso v03, parches normativos, delta de la KB, reconstruccion del backlog. |
| Robustez/bugfix | 9 | id integer, UTF-8 bajo locale C, em-dash, paso 31 truncando columnas, mojibake B6, acceso [[ ]] del paso 6. |
| Gobernanza hermanos | 9 | gobernanza_datos.md en 5 proyectos, merge docs/suitedoc, conexion y push a GitHub, alineacion de remoto, rescate de traspaso ajeno. |
| Estandarizacion de cartera | 12 | Auditoria y renombrado de backlogs, correccion del universo, decision sobre desalineaciones de nombre, censo documental de la cartera. |
| Informe visual (P4) | 5 | Diseno, script 36, columnas nuevas del registro, data.js in situ, rediseno acordeon. |
| Cierre de deuda menor | 3 | Paleta real sincronizada, auditoria archivada como andamio. |
| Arquitectura Fase 2 (ESTADO.md) | 3 | Diseno PUSH/PULL, propagacion a 13 hermanos, lector con fallback. |
| Gobernanza de proceso (asistente) | 1 | Parche POLITICA 0.5 / SETTINGS 2.2.15 (registro de errores del asistente). |
| Rescate e integracion del repositorio | 5 | CATEGORIA NUEVA (s13): apertura de emergencia, tramos A y B del rescate, reversion de la regresion normativa. |
| Perdidas (55-61) | 7 | Nunca llegaron a git en las sesiones 8 a 10. Irrecuperables. No se reconstruyen. |
| **Total** | **89** | Cuadra con el total del resumen por sesion. |

**Cobertura (s13).** La tabla se re-derivo entrada por entrada sobre las 70 presentes
mas la fila de perdidas: una entrada, una categoria, sin doble conteo. Antes sumaba 59
sobre 54 entradas clasificables, un sobreconteo de 5 sin origen documentado. Las
entradas 55-61 no se reconstruyen: su hueco es permanente y declararlo es la conducta
correcta (traspaso v12).

## Resumen estadistico por sesion

| Sesion | Traspasos | Cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | ~18 | Opus 4.8 | Andamiaje + Fase 1 completa |
| 2 | v02 | 6 | Opus 4.8 | Operacion: regeneracion tras cierre parcial de H4 |
| 3 | v03 | 8 | Opus 4.8 | Gobernanza: cierre total de H4 + GitHub |
| 4 | v04 | 13 | Sonnet 4.6 | Estandarizacion de backlogs + parche de protocolo + P4 (panorama visual) + cierre de deuda |
| 5 | v05 | 8 | Sonnet 4.6 | Bug B6 + P-DATA-JS-RUTA + extraccion de backlog propio + rediseno acordeon + Fase 2 (diseno+propagacion+lector) + parche registro de errores |
| 6 | (en curso) | 1 (en curso) | Sonnet 5 | Curacion slep_paes + incorporacion de backlog s5 |
| 7 | v07 | 0 | n/d | Cierre de pendientes de v06, idempotencia, categoria de backlog, refresco de cartera, encargo a Claude Design |
| 8 | v08 | 2 (perdidas) | n/d | Handoff de Claude Design vs. contrato de datos, semaforo desde ESTADO.md, fix de exclusion `_BACKUP` |
| 9 | v09 | 2 (perdidas) | n/d | GitHub Pages permanente via Actions + P-DESIGN-PANORAMA-ADOPCION (KPIs, banda de atencion, filtros) |
| 10 | v10 | 3 (perdidas) | n/d | Consolidacion de backlog atrasado, fix del escaner (`.github`), resto del patron visual, cobertura ESTADO.md 16/17 |
| 11 | v11 | 6 | n/d | Resolucion de P3 (desalineacion de nombres) e incorporacion de los hermanos nuevos descubiertos en disco |
| 12 | v12 | 10 | Opus 5 | Apertura de emergencia, rescate del repositorio en dos tramos, primer censo completo del estado documental de la cartera y trazado de la ruta hacia un comando unico de actualizacion y publicacion. |
| 13 | v13 | 12 | Opus 5 | Desbloqueo del candado por I8, retorno del pipeline a operacion, censo de backlogs de la cartera y correccion de los tres defectos apilados de data.js. |
| **Total** | | **89** (82 conservadas, 7 perdidas) | | |

## Detalle cronologico

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

**Sesion 4 (entradas 33-45):** (copiadas integras de v04 — sin cambios)

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
45. Correccion documental: el objetivo permanente del backlog (heredado desde v01) mencionaba un "informe a jefaturas graduable L1/L2/L3" que nunca fue un requerimiento del titular -- fue una invencion del asistente en la sesion 1. Corregido en la seccion 5 del traspaso v04, documentado como aprendizaje en su seccion 7.

**Sesion 5 (entradas 46-47, nuevas):**

46. Bug B6 corregido: `36_generar_panorama_visual.R` producia mojibake en 7 cadenas hardcodeadas (titulo, header, badges, "Ultima actualizacion", "Reseña del itinerario", "Proximos pasos") en `panorama_visual.html` y `.md`. Causa raiz: literales no-ASCII parseados bajo locale C (`run_all()` hace `source()` sin `encoding=`) quedan con `Encoding()` marcado `"unknown"` (bytes UTF-8 correctos); al concatenarse via `paste0()`/`sprintf()` con strings ya marcados `"UTF-8"`, R recodifica el literal desde el nativo C hacia UTF-8 y, como C no representa bytes altos, lo escapa como texto literal (`<c3><81>` en vez del caracter real). Fix: helper local `u8()` (`Encoding(x) <- "UTF-8"`, solo reetiqueta) aplicado antes de mezclar. Misma familia que el mojibake de em-dash de la sesion 1 (entrada 17), ahora en el paso 36. Commit `96e1433` (sin push).
47. Implementacion de P-DATA-JS-RUTA: `RUTA_DATA_JS_PORTAFOLIO` fijada a lectura in situ de `~/Projects/slep_monitoreo/data.js` (R2: nunca copiado/versionado). Parser: `jsonlite::toJSON` tras quotear las 7 claves conocidas + split por objeto con `tryCatch` por entrada. Mapeo titulo->slug resuelto por `orden` (entero estable) via constante `MAPEO_ORDEN_SLUG` con titulo literal en comentario inline por entrada (gate de aprobacion del titular cumplido antes de implementar). Ajuste de card: `sintesis` muestra el primer parrafo completo (`N_PARRAFOS_SINTESIS_CARD <- 1L`) mas indicador "+N parrafos mas" cuando aplica, reemplazando el truncamiento a `MAX_RESENA` (que queda exclusivo de `resena_itinerario`). Resultado: 11/16 cards pobladas con `tipo`/`objetivo`/`sintesis`; 5 sin entrada en `data.js` quedan `null` con gracia. Verificado con spot-check 1:1 verbatim contra `data.js` real (2 cards), idempotencia en 2 corridas, 0 mojibake, 0 referencias de red. Commit `6ecbb43` (sin push).

48. Rediseno acordeon del panorama visual + cambio de titulo. Grid de 3
columnas tipo card reemplazado por lista acordeon de ancho completo (toggle
JS, sin libreria externa), verificado funcionalmente con shim de DOM en Node
(16 filas, toggle real, `aria-expanded` correcto) porque el screenshot no era
viable en el entorno de Claude Code. Titulo cambiado a "Cartera de proyectos
Area de Monitoreo" en `<title>`, `<h1>` y el `#` del `.md`. El `.md` muestra
ahora todos los parrafos de `sintesis[]` directamente, sin indicador "+N mas"
(decision declarada antes de implementar); constante `N_PARRAFOS_SINTESIS_CARD`
eliminada por no tener mas uso. Commit `6dc127d`.

49. Diseno completo de arquitectura Fase 2 (PUSH de `ESTADO.md`). Tres
artefactos BIBLIOTECA: `fase2_push_estado_v1.md`, `fase2_push_estado_v2.md`
(version final, agrega `tipo_pendiente` al front matter tras decidir fusionar
el requerimiento de agenda diaria con Fase 2), `parche_a_settings_v6.md`
(superado por el archivo completo). Decision D1: modelo hibrido PUSH+PULL,
recomendacion del esbozo original del titular, sin alternativa real
compitiendo. Decision D2: fusionar "agenda diaria" con Fase 2 en vez de crear
un segundo estandar.

50. Propagacion batch de `ESTADO.md` a 13 hermanos + 2 regeneraciones por
desync real. Autorizacion explicita batch del titular (D4, excepcion puntual
a la regla de autorizacion por repo). Claude Code inventario 16 hermanos (3
sin traspaso, omitidos sin inventar contenido), destilo 13 con subagentes
paralelos de solo-lectura (spot-check anti-alucinacion antes de escribir).
Hallazgo sistemico: el vocabulario tematico real de los pendientes de los
traspasos no coincide con el enum de `tipo_pendiente` (D3: taxonomias
distintas a proposito, no se amplia el enum). Dos semaforos revisados
manualmente por el titular con el texto real delante (`aprendizajes_ep`
confirmado activo; `georreferenciacion` corregido a pausa, D6). Regeneraciones
por desync real: `slep_alertas_ael` (glob original no cubria grafia con guion
del traspaso mas reciente, commit `aa9568f`); `slep_minuta_desvinculacion`
(repo avanzo v34->v37 durante la sesion, decision del titular D5 de regenerar
desde v37). Commits: 13 iniciales + `5bff039` (correccion semaforo) +
`aa9568f` + `87936df`.

51. Lector de `ESTADO.md` en el orquestador (Fase 2, pieza de codigo).
`parsear_front_matter()` factorizado a `10_utils.R` (reutilizado por
`32_localizar_documentos.R` y `35_compilar_panorama.R`). `resolver_estado()`
en 32 implementa la regla de desincronizacion via `resolver_traspaso()`
existente. `tipo_pendiente` y `estado.presente` persistidos en el inventario
JSON/parquet (34), disponibles para la futura pieza C sin tocar el paso 36.
Bug lateral encontrado y corregido: `as.Date(file.mtime())` asumia UTC en vez
de zona local, produciendo falsos-desync para traspasos guardados de noche el
mismo dia; corregido con `TZ_ORQUESTADOR` capturado al bootstrap
(`10_configuracion.R`). Verificado con test controlado de desync forzado,
spot-check 1:1 de 2 proyectos PUSH, idempotencia en 2+ corridas, 0 mojibake.
Commit `c6df30d` (codigo) + `2577d9d` (outputs regenerados).

52. Descubrimiento de `slep_paes` como hermano nuevo en la cartera (17mo
proyecto), detectado en la corrida de `run_all()` de la sesion. Sin fila
curada en `registro_proyectos.csv`, sin `ESTADO.md`, sin traspaso conocido al
cierre de la sesion 5.

53. Parche de registro obligatorio de errores del asistente (POLITICA
0.5 / SETTINGS 2.2.15). A peticion explicita del titular tras dos errores del
asistente detectados en la sesion (mismo patron: confundir "quien produce el
contenido" con "quien ejecuta la operacion mecanica de moverlo"). `POLITICA_PROYECTO.md`
v5.1->v5.2: nueva regla 0.5, disparador exhaustivo (cualquier desviacion de
regla canonica, nombrada como error o no). `SETTINGS_Y_PROMPTS_OPERACIONALES.md`
v6->v7: nueva subseccion 2.2.15, tabla de campos fijos (momento, disparador,
que_paso, regla_violada, causa_raiz, salvaguarda_presente, patron), declarada
como artefacto de analisis CRUZADO entre los 16 proyectos de la cartera.
Archivos completos entregados y pegados por el titular en la knowledge base de
los 16 proyectos.

**Sesion 6 (entrada 54, en curso):**

54. Curacion manual de `slep_paes` en `registro_proyectos.csv` (nombre_real:
"Motor de comparacion interactivo de los resultados de la PAES"; alias_corto:
"PAES"; categoria: activo; datos_sensibles: FALSE; estado_proyecto: activo),
resolviendo el pendiente P-PAES-REGISTRAR (entrada 52). Incorporacion al
presente archivo de las 6 entradas de sesion 5 (48-53) que habian quedado
pendientes de consolidar al cierre de esa sesion (nota explicita en
`traspaso_cierre_v05.md` §5).

> **Entradas 55 a 61: perdidas.** Volcadas en la sesion 10 sobre una copia de
> trabajo que nunca llego a git (`git log --all --follow` sobre este archivo tiene
> dos commits). Su existencia consta en `traspaso_cierre_v10.md` §4.1 y §5; su
> texto no se conserva. No se reconstruyen: seria redaccion nueva sobre registro
> historico.

**Sesion 11 (entradas 62-67, trasladadas de `traspaso_cierre_v11.md` §5):**

62. Inventario de solo-lectura de los 22 directorios `slep_*`: nombre local
vs. remoto, registro, `ESTADO.md`, traspasos.

63. Corrección del universo de la cartera: 17 → 21 hermanos + orquestador.

64. Decisión formal sobre las 3 desalineaciones de nombre (2 mapeos
aceptados, 1 alineación real).

65. Alineación del remoto de `slep_lectoescritura` a la forma corta canónica.

66. Incorporación de los 4 hermanos nuevos al registro vía `run_all()`.

67. Rescate del traspaso v07 de `slep_paes` (untracked → versionado).

**Sesion 12 (entradas 68-77):**

68. Apertura de emergencia (SETTINGS 1.2.8) tras 44 dias sin integrar. El punto 0bis
fallo por las cuatro causas simultaneas: sin campos de candado en ESTADO.md, arbol
sucio, stash pendiente y diez commits sin integrar, con los traspasos v10 y v11
existiendo solo en disco. Se fotografio el estado antes de tocar nada. [gobernanza]

69. Revision linea por linea de la knowledge base: POLITICA de v5.3 a v5.8 y SETTINGS
de v8 a v34, veintiseis versiones de delta. Producto: 20260824_delta_normativo_kb.md,
con la tabla de obligaciones que el delta impone al proyecto en sus dos roles. Hallazgo
principal: ESTADO.md gano siete campos que los pasos 33 y 35 no leen. [gobernanza]

70. Censo de solo lectura de la cartera sobre 25 directorios slep_*, con autotest de
ocho casos y dos controles negativos previos a la recoleccion. Salidas: informe de 883
lineas y CSV de 26 lineas por 58 columnas. El autotest atrapo un defecto real del
clasificador de ventana_insumos antes de que contaminara el censo. [diagnostico]

71. Hallazgo del censo: 20 de 25 hermanos sin ningun campo de candado, cero parciales;
14 incumplen el invariante I5; el mayor riesgo de perdida de la cartera se desplazo a
slep_rendimiento_historico. El pendiente P1 del traspaso v11 quedo obsoleto: ese repo ya
esta en v78 y limpio. [diagnostico]

72. Rescate tramo A: rama rescate/20260824 con cuatro commits selectivos que publican
los traspasos v10 y v11, los artefactos de las sesiones 11 y 12, y las salidas
regeneradas. Publicada y verificada por ls-remote contra HEAD (98a4097). [gobernanza]

73. Regresion normativa detectada y revertida: el arbol de trabajo y el indice tenian
POLITICA v5.6 y SETTINGS v16 mientras HEAD conservaba v5.8 y v34, con 901 borrados
staged en SETTINGS. Un commit habria consolidado el retroceso de dieciocho versiones.
Revertido con git restore --source=HEAD. [gobernanza]

74. Rescate tramo B: dos merges. El primero (5953106) integro origin/main resolviendo el
conflicto modify/delete de los normativos con la decision de cartera de no versionarlos;
el segundo (1c74ad0) integro origin/rescate/20260824 y trajo los traspasos v10 y v11 a
main. Estado final 0 0, pusheado. [gobernanza]

75. Bugfix del paso 6: acceso por [[ ]] sobre vector con nombres abortaba ante cualquier
tipo_pendiente fuera del enum, y el fallback escrito con is.null() era inalcanzable por
construccion. Corregido a [ ] con guarda is.na() en rango_tp_de() y rango_de(). Commit
0304334. [codigo]

76. Incorporacion de siete hermanos nuevos por descubrimiento de convencion de nombre,
sin edicion manual del registro: el universo del pipeline paso de 17 a 24. Se confirmo
que registro_proyectos.csv es destino y no fuente. [operacion]

77. Reconstruccion parcial del backlog y hallazgo de perdida irrecuperable. Se
trasladaron las entradas 62-67 desde el traspaso v11. Las entradas 55-61 constan como
volcadas en el traspaso v10 pero ninguna version del archivo con 61 entradas llego jamas
a git: el trabajo se hizo sobre una copia perdida. No se reconstruyen. Producto
adicional: la ruta de siete encargos hacia el comando unico y el inventario consolidado
de 21 pendientes. [gobernanza]

**Sesion 13 (entradas 78-89):**

78. Mudanza de `registro_proyectos.csv` a `40_salidas/` y salida del control de versiones, con guarda de ausencia en sus lectores reales (D-01). Resuelve I8 y POLITICA 1.3 punto 5.

79. Apertura del candado 0bis: `cierre_incompleto` a `no` y `sesion_abierta` a `true`, tras cerrar el hueco que la sesion 12 dejo declarado.

80. Restauracion de `renv` y regeneracion del escaner: el pipeline vuelve a operacion y se apaga I7.

81. Censo de backlogs de los 26 directorios de la cartera, con seis casos de autotest y dos controles negativos. Veredicto de la duda 6: accidente aislado, no patron.

82. Cuadratura de la clasificacion tematica del backlog, re-derivada entrada por entrada, con categoria nueva "Rescate e integracion del repositorio" y fila explicita de las entradas perdidas 55-61.

83. Versionado del motor y del arnes del censo en `andamios/`, el arnes reescrito autocontenido para correr desde cualquier directorio.

84. Correccion de las descripciones del registro en `README.md`, `CLAUDE.md` y `ventana_insumos`, que describian el mundo anterior a D-01.

85. Diagnostico de solo lectura de `data.js` y `estado_proyecto`: tres defectos apilados en el primero, y en el segundo una columna nunca curada en vez de un defecto de extraccion.

86. Correccion del frente A en el paso 6: ruta a `docs/data.js`, saneador de claves generalizado y mapeo reclavado por `id`, con guarda contra omision silenciosa. Once fichas recuperan contenido editorial.

87. Endurecimiento del parser de `data.js` ante objetos anidados, con recorrido unico y strings enmascarados, inmune a la proxima clave y a la proxima forma.

88. Ordenacion del repositorio segun SETTINGS 4.7: dos documentos superados a `_archivo/20260826/`, exclusiones del escaner completadas y marcador depositado. Entregado como PR #4, sin mergear.

89. Linea base fechada del registro depositada en `andamios/` antes de intervenir la idempotencia del paso 1, porque el archivo dejo de versionarse y su estado curado vivia en una sola copia fuera del repositorio.


## Delta del backlog

7 entradas nuevas (48-54) respecto al estado reflejado en `traspaso_cierre_v05.md`
(que solo incorporaba 46-47). Sin reclasificaciones de entradas previas.
Categoria "Robustez/bugfix" pasa de 6 a 7 descripciones (se agrega bug lateral
tz UTC); "Informe visual (P4)" pasa de 4 a 5 (se agrega rediseno acordeon).
Dos categorias nuevas: "Arquitectura Fase 2 (ESTADO.md)" (3 entradas: 49, 50,
51) y "Gobernanza de proceso (asistente)" (1 entrada: 53). Entrada 52
(descubrimiento de `slep_paes`) y 54 (su curacion + esta incorporacion) no se
clasifican tematicamente por ahora: son eventos de mantenimiento de cartera,
no encajan limpio en ninguna categoria existente; revisar si conviene una
categoria "Mantenimiento de registro/cartera" cuando haya mas casos similares
(hoy serian solo 2, bajo el umbral de 2% declarado en SETTINGS §2.2.5 para
crear categoria nueva salvo que se anticipe recurrencia).

10 entradas nuevas (68-77) respecto al estado reflejado en
`traspaso_cierre_v11.md` (que llego a la 67). El tramo 55-61 sigue declarado
como perdido y no se recupera en este cierre. Sin categorias nuevas. Las diez
entradas se reparten en cuatro existentes: gobernanza (6), diagnostico (2),
codigo (1) y operacion (1). El peso de gobernanza refleja que la sesion fue
de rescate y no de desarrollo.

El movimiento tematico de esta sesion es hacia adentro: seis de diez entradas
son sobre la integridad del propio sistema de registro (candado, traspasos
versionados, backlog, normativos) y no sobre el producto. La causa es que el
censo hizo medible por primera vez el estado documental de la cartera
completa, y lo que midio fue una deuda de custodia extendida: 20 de 25
hermanos sin campos de candado y siete entradas de backlog perdidas sin que
nadie lo notara en dos meses. La sesion siguiente deberia devolver el peso al
producto, empezando por las dos degradaciones del panorama.

12 entradas nuevas (78-89) respecto al estado reflejado en
`traspaso_cierre_v12.md` (que llego a la 77). Sin categorias nuevas ni
reclasificaciones de entradas previas. Las doce se reparten entre las catorce
categorias existentes, una entrada una categoria: Andamiaje/estructura 78 y 88;
Utilidades/gobernanza por codigo 83; Operacion/regeneracion 80; Documentacion 82
y 84; Robustez/bugfix 85, 86 y 87; Estandarizacion de cartera 81; Cierre de deuda
menor 89; Rescate e integracion del repositorio 79.

La sesion se reparte entre desbloqueo (78-80), instrumentacion de medicion
(81-83) y correccion del producto publicado (85-87). Es la primera sesion en que
medir precede a corregir por regla explicita, y las dos correcciones que produjo
se apoyan en diagnosticos que desmontaron supuestos de un ano. La categoria
Robustez/bugfix es la que mas crece, de 6 a 9.
