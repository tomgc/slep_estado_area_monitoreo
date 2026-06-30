# Backlog acumulativo — slep_estado_proyectos_monitoreo

> **Archivo canonico** (POLITICA_PROYECTO.md §10 / SETTINGS_Y_PROMPTS_OPERACIONALES.md
> §2.2.5). Registro historico vivo: en cada cierre se copia integro y se agregan
> los cambios nuevos al final. Jamas se reescriben, resumen ni renumeran entradas
> anteriores; un error se corrige con una entrada nueva.
>
> **Extraido desde:** `traspaso_cierre_v04.md` §5, en el cierre de la sesion 5
> (P-BACKLOG-PROPIO-EXTRAER). A partir de ahora los traspasos solo referencian
> esta ruta.

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
| Andamiaje/estructura | 3 | Estructura Rama A, .gitignore, .Rproj, git. |
| Pipeline determinista | 6 | Scripts 31-36 (36 nuevo en s4). |
| Utilidades/gobernanza por codigo | 2 | escribir_seguro/atomico; descubrir_hermanos. |
| Sintesis cualitativa | 5 | 14 fichas L2 iniciales + 3 re-sintetizadas (s2) + 0 nuevas (s3). |
| Operacion/regeneracion | 4 | Corridas run_all de regeneracion (s2, s3, s4 x2). |
| Documentacion | 8 | README, CLAUDE, cobertura (x2), esbozo Fase 2, decision, traspasos (x2: v03 commiteado + v04), parche POLITICA/SETTINGS. |
| Robustez/bugfix | 6 | id integer en PASOS, UTF-8 con readr, em-dash mojibake, exclusion .git, fix paso 31 (columnas extra), mojibake B6 (paso 36). |
| Gobernanza hermanos | 8 | gobernanza_datos.md en 3+2 proyectos, merge docs/suitedoc, push, conexion GitHub orquestador. |
| Estandarizacion de cartera | 5 | Auditoria de backlogs + 4 renames/reubicaciones + 1 volcado crudo eliminado. |
| Informe visual (P4) | 4 | Script 36 (HTML+MD autocontenidos), integracion a run_all, registro ampliado (2 columnas), integracion data.js (P-DATA-JS-RUTA). |
| Cierre de deuda menor | 2 | Paleta real sincronizada, auditoria archivada como andamio. |

## Resumen estadistico por sesion

| Sesion | Traspasos | Cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | ~18 | Opus 4.8 | Andamiaje + Fase 1 completa |
| 2 | v02 | 6 | Opus 4.8 | Operacion: regeneracion tras cierre parcial de H4 |
| 3 | v03 | 8 | Opus 4.8 | Gobernanza: cierre total de H4 + GitHub |
| 4 | v04 | 13 | Sonnet 4.6 | Estandarizacion de backlogs + parche de protocolo + P4 (panorama visual) + cierre de deuda |
| 5 | v05 | 2 (en curso) | Sonnet 4.6 | Bug B6 (mojibake paso 36) + P-DATA-JS-RUTA + extraccion de backlog propio |
| **Total** | | **47** | | |

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

## Delta del backlog

2 entradas nuevas (46-47) respecto a v04. Sin reclasificaciones de entradas
previas. Categoria "Robustez/bugfix" pasa de 4 a 6 descripciones (se agrega
mojibake B6); categoria "Informe visual (P4)" pasa de 3 a 4 descripciones (se
agrega integracion data.js). Sin categorias nuevas.
