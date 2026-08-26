# Traspaso de cierre v02 - slep_estado_proyectos_monitoreo

## 1. Identificacion

- **Proyecto:** slep_estado_proyectos_monitoreo (orquestador de estado de la cartera).
- **Version:** v02. **Fecha:** 2026-06-29. **Sesion:** 2 (CONTINUATION).
- **Foco:** corrida de OPERACION (no desarrollo nuevo): regenerar el panorama tras
  el cierre parcial del hallazgo H4 (tres `gobernanza_datos.md` creados en repos
  hermanos), re-sintetizar los caches con sello nuevo y cerrar con traspaso v02.
- **Entorno:** Claude Code, R 4.5.2, macOS, locale `C`.
- **Archivos modificados (todos del propio repo):** `40_salidas/panorama.md`,
  `40_salidas/inventario_cartera.{json,parquet}`,
  `40_salidas/cache/{slep_georreferenciacion,slep_minuta_desvinculacion,slep_simce_adecuado}.md`,
  `20_insumos/registro_proyectos.csv` (curacion del titular, preservada),
  `50_documentacion/activa/reporte_cobertura_documental.md`,
  `50_documentacion/traspasos/traspaso_cierre_v02.md`, escaner.

## 2. Resumen ejecutivo

Sesion de operacion. Se verifico el estado real de ramas de los tres repos
hermanos donde la sesion 1 marco H4 (gobernanza_datos.md ausente pese a manejar
datos de NNA): los tres tienen ahora el archivo en su working tree, por lo que el
detector `maneja_sensibles` viro FALSE->TRUE en los tres. `slep_aprendizajes_ep` y
`slep_minuta_desvinculacion` lo tienen commiteado en `main`;
`slep_seguimiento_educacion_inicial` lo tiene en la rama `docs/suitedoc`, no
mergeada a main (el orquestador lo ve porque lee el working tree). Se corrio
`run_all()`: tres caches quedaron desactualizados porque sus proyectos avanzaron
de traspaso (georreferenciacion v03->v05, minuta_desvinculacion v28->v29,
simce_adecuado v23->v24); se re-sintetizaron solo esos tres y se reutilizaron
literal los otros 11 (idempotencia de sintesis). El panorama quedo con 0
pendientes de sintesis; idempotencia determinista verificada (md5 de json y
parquet estables) y testigos R1 inalterados. Se actualizo el reporte de cobertura
y se detecto que H4 no esta del todo cerrado: `slep_simce_estandares_aprendizaje`
maneja datos sensibles y aun carece de gobernanza_datos.md. El registro curado por
el titular (16 filas con nombre_real/alias_corto/notas) fue preservado por el paso
31. No se ejecuto ningun pipeline hermano ni se escribio fuera del repo.

## 3. Estado al cierre

**Funciona (ultima ejecucion 2026-06-29):**
- `run_all()` 31->35 sin intervencion; panorama con **0 pendientes de sintesis**.
- Idempotencia determinista: 2da corrida -> json y parquet con md5 identico.
- Testigos R1 (`slep_idps`, `slep_aprendizajes_ep`, `slep_minuta_asistencia`)
  inalterados antes/despues. Cero fugas en salidas.

**Delta respecto a v01:**
- `maneja_sensibles`: FALSE->TRUE en aprendizajes_ep, minuta_desvinculacion,
  seguimiento_educacion_inicial (cierre parcial de H4).
- Caches re-sintetizados: georreferenciacion (v05; cerrado->pausa),
  minuta_desvinculacion (v29; sigue activo), simce_adecuado (v24; activo->cerrado).
- Panorama L1 ahora con `nombre_real` curado por el titular (P1 de v01 cerrado).

## 4. Registro detallado de cambios

Esta sesion es de operacion; los cambios conceptuales se listan en el backlog
(entradas 19-24). No hubo modificacion de scripts del pipeline.

## 5. Backlog acumulativo

### Objetivo del proyecto (permanente)

Orquestador en R del Area de Monitoreo y Seguimiento de Procesos y Resultados
Educativos (SLEP Costa Central) que descubre en tiempo de ejecucion los
proyectos hermanos `~/Projects/slep_*`, lee SOLO su documentacion curada y
sintetiza un "estado de situacion de la cartera": un `panorama.md` para el
arranque de jornada y la base para informes a jefaturas graduables (L1/L2/L3). No
ejecuta ni modifica los pipelines hermanos; su unica escritura ocurre, cerrada
por codigo, dentro de su propio repo. Producido con R (tidyverse, arrow,
jsonlite, readr, fs). Desde la sesion 1 (2026-06-28).

### Nota metodologica (permanente)

Un "cambio" es una solicitud distinguible del titular o una decision de diseno
con efecto en el producto, no cada accion tecnica que la implementa. No cuentan
los errores del asistente corregidos de inmediato (si cuentan los bugs
reportados por el titular). La clasificacion es por intencion primaria. Fuentes
del conteo: este traspaso y los commits.

### Clasificacion tematica (a refinar)

| Categoria | N | Descripcion |
|---|---|---|
| Andamiaje/estructura | 3 | Estructura Rama A, .gitignore, .Rproj, git. |
| Pipeline determinista | 5 | Scripts 31-35. |
| Utilidades/gobernanza por codigo | 2 | escribir_seguro/atomico; descubrir_hermanos. |
| Sintesis cualitativa | 4 | 14 fichas L2 iniciales + 3 re-sintetizadas (s2). |
| Operacion/regeneracion | 2 | Corridas run_all de regeneracion (s2). |
| Documentacion | 5 | README, CLAUDE, cobertura (x2), esbozo Fase 2, decision. |
| Robustez/bugfix | 3 | id integer en PASOS, UTF-8 con readr, em-dash mojibake, exclusion .git. |

### Resumen estadistico por sesion

| Sesion | Traspasos | Cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | ~18 | Opus 4.8 | Andamiaje + Fase 1 completa |
| 2 | v02 | 6 | Opus 4.8 | Operacion: regeneracion tras cierre parcial de H4 |

### Detalle cronologico

**Sesion 1 (entradas 1-18):** (copiadas integras de v01)
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

**Sesion 2 (entradas 19-24, nuevas):**
19. Verificacion del estado de ramas de los tres repos de H4: gobernanza_datos.md
    presente en los tres working trees (dos en main, uno en docs/suitedoc).
20. Regeneracion del panorama via `run_all()` (operacion, sin tocar scripts).
21. Re-sintesis de 3 caches con sello nuevo: georreferenciacion (v05),
    minuta_desvinculacion (v29), simce_adecuado (v24); 11 reutilizados literal.
22. Confirmacion del delta `maneja_sensibles` FALSE->TRUE en los tres de H4.
23. Actualizacion del reporte de cobertura (cierre parcial de H4, matiz de rama,
    caso abierto simce_estandares).
24. Verificacion de que el paso 31 preserva la curacion del titular del registro
    (16 filas con nombre_real/alias_corto/notas intactos).

### Delta del backlog

6 entradas nuevas (19-24). Sin reclasificaciones ni renumeraciones de entradas
previas. Nueva categoria "Operacion/regeneracion".

## 6. Bugs de la sesion

Ninguno. Sesion de operacion; el pipeline corrio limpio. (No se reintrodujo
ningun bug documentado en v01; no se modificaron scripts.)

## 7. Aprendizajes y restricciones (nuevos en s2)

- **H4 no siempre es "ausencia total".** En `slep_aprendizajes_ep` ya existia un
  `50_gobernanza_datos.md` de nombre NO canonico; el cierre consistio en
  consolidarlo bajo el nombre de POLITICA 10 y migrar sus referencias. Regla: al
  evaluar cobertura de gobernanza, distinguir "ausencia total" de "nombre no
  canonico"; el detector (presencia del nombre exacto) marca ambos como ausencia.
- **El orquestador lee el WORKING TREE, no `main`.** Un archivo presente en una
  rama no mergeada (caso `slep_seguimiento_educacion_inicial` en `docs/suitedoc`)
  se ve PRESENTE en la corrida, pero no es el estado canonico de main. Regla:
  cuando el cierre de un hueco dependa de un archivo, anotar en que rama vive; si
  no esta en main, el cierre es provisional hasta el merge.
- **Idempotencia de sintesis en la practica:** re-sintetizar SOLO los caches cuyo
  `sello_hash` dejo de coincidir con el md5 del traspaso vigente; reutilizar el
  resto literal. Confirmado: 3 re-sintetizados, 11 literales, 0 pendientes.

## 8. Decisiones de diseno

Sin decisiones arquitectonicas nuevas. Vigentes las D1-D7 de
`activa/decisiones/20260628_decision_arquitectura_orquestador.md`.

## 9. Constantes y parametros vigentes

Sin cambios respecto a v01: DIAS_OBSOLETO=21, LEER_GIT=FALSE,
SLUG_ORQUESTADOR, AUXILIARES_SEMILLA, PATRON_EXCLUIR_UNIVERSO=`\\.git$`,
ESQUEMA_INVENTARIO="1".

## 10. Arquitectura de archivos

Ver `50_documentacion/estructura/estructura_actual.md` (escaner al cierre de s2).
Sin cambios estructurales; solo se agregaron `traspaso_cierre_v02.md` y se
actualizaron salidas y reporte de cobertura.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P-H4-MERGE** (bloqueante de cierre canonico). *Descripcion:*
  `slep_seguimiento_educacion_inicial` tiene su `gobernanza_datos.md` en la rama
  `docs/suitedoc`, no en `main`. *Contexto:* el orquestador lo ve presente por
  leer el working tree; en main aun falta. *Tipo:* gobernanza (de otro repo).
  *Impacto:* hasta el merge, el cierre de H4 para ese proyecto es provisional; si
  ese repo cambia a main, el orquestador volveria a listarlo. *Dependencias:*
  decision del titular / equipo del proyecto hermano. *Complejidad:* baja (es un
  merge, no del orquestador). *Sugerencia:* merge a main de docs/suitedoc o cherry
  pick del archivo. *Criterio de exito:* `gobernanza_datos.md` presente en main.
- **P-H4-SIMCE-ESTANDARES** (hallazgo nuevo). *Descripcion:*
  `slep_simce_estandares_aprendizaje` maneja datos sensibles y carece de
  `gobernanza_datos.md`. *Contexto:* caso subreportado en s1; sigue abierto.
  *Tipo:* gobernanza (de otro repo). *Impacto:* el detector lo marca FALSE pese a
  manejar datos sensibles. *Complejidad:* baja. *Sugerencia:* crear el archivo
  (POLITICA 10) cuando ese proyecto reabra (esta obsoleto >21d, en pausa).
  *Criterio:* archivo presente; `maneja_sensibles=TRUE`.
- **P-H4-REVISAR-INSTITUCIONAL.** *Descripcion:* los tres `gobernanza_datos.md`
  creados llevan marcas `# REVISAR` institucionales (roles con acceso,
  offboarding, contacto de TI, Encargado de Proteccion de Datos, politica de
  retencion). *Contexto:* respuesta transversal identica para los tres. *Tipo:*
  documentacion (de otros repos). *Dependencias:* datos institucionales del
  titular. *Complejidad:* baja-media. *Sugerencia:* el titular responde una vez y
  se propaga. *Criterio:* sin marcas `# REVISAR` institucionales en los tres.
- **P-H4-REVISAR-LEGAL.** *Descripcion:* marcas `# REVISAR (legal)` sobre
  suficiencia de base legal para datos de categoria especial
  (minuta_desvinculacion: etnia/pais; aprendizajes_ep: pais_origen;
  seguimiento: instrumento habilitante con RUT y acto administrativo bajo Ley
  21.040 / JUNJI). *Tipo:* gobernanza/legal. *Dependencias:* area juridica SLEP.
  *Complejidad:* externa. *Sugerencia:* consulta legal. *Criterio:* base legal
  ratificada por juridica.
- **P-PLANTILLA-DESTINO.** *Descripcion:* `PLANTILLA_gobernanza_datos.md` quedo
  untracked en los repos hermanos. *Contexto:* ensucia su cobertura documental.
  *Tipo:* higiene (de otros repos). *Sugerencia:* mover a
  `herramientas_dev/plantillas/` (copia canonica unica) y retirarla de cada repo.
  *Criterio:* plantilla solo en herramientas_dev.
- **P-REGISTRO-OPCIONALES.** *Descripcion:* `alias_corto`/`notas` del registro ya
  poblados (desde data.js del portafolio). *Tipo:* documentacion. *Sugerencia:*
  el titular ratifica. *Criterio:* visto bueno del titular.
- **(Solo registro, NO accion del orquestador)** Higiene de hermanos detectada de
  paso: varios tienen traspasos recientes untracked (seguimiento v34,
  minuta_desvinculacion v29). Es deuda de cierre de esos proyectos, no del
  orquestador; se anota sin actuar (R1/R4).

### Diferidos (de v01, se mantienen)

- **P3/Fase 2 (PUSH/PULL con ESTADO.md):** sesion BIBLIOTECA dedicada.
- **P4 (informe a jefaturas L1/L2/L3 parametrizable):** operacion/funcionalidad.
- **Higiene de cobertura organica** (reseñas/backlogs ausentes en proyectos
  activos cuando reabran).
- **P5 (LEER_GIT=TRUE):** opcional, para captar commits recientes con traspaso viejo.

### Auditoria de cierre (POLITICA 5.6)

- Pipeline corre de cero sin intervencion: **Si**. Outputs idempotentes: **Si**.
- Constantes nombradas: **Si**. Naming sin tildes/ñ/espacios: **Si**.
- Sin deuda nueva sin documentar: **Si** (toda registrada arriba).

### Ruta sugerida para la sesion 3

1. Si el titular resuelve P-H4-MERGE y/o P-H4-SIMCE-ESTANDARES en los repos
   hermanos, **regenerar** (run_all) y confirmar el cierre total de H4. Criterio:
   todos los proyectos sensibles con `maneja_sensibles=TRUE`.
2. P4: informe a jefaturas parametrizable (mayor valor para el titular).
3. Diferir Fase 2 a sesion BIBLIOTECA.

## 12. Instrucciones especificas para la sesion 3

- 🔒 NUNCA escribir fuera de `slep_estado_proyectos_monitoreo/` (R1, cerrado por
  `escribir_seguro`). Hermanos = solo lectura de documentacion curada.
- ⚠️ NO leer `20_insumos/`, `40_salidas/` con datos, OneDrive ni `*_volcado_crudo*`
  (R2). Salida siempre saneada (R3). NO cambiar de rama en repos hermanos.
- ✅ ANTES de regenerar, reutilizar literal los `cache/<slug>.md` con sello
  intacto; re-redactar solo los de sello nuevo.
- ✅ El orquestador lee el WORKING TREE: al verificar cierres de H4, confirmar en
  que rama esta cada repo (un archivo en rama no mergeada se ve presente).
- ⚠️ NO tocar Fase 2 (ESTADO.md/SETTINGS en hermanos) sin sesion dedicada.

## 13. Fragmentos de referencia

```r
# Verificar rama y presencia de un archivo en un hermano (solo lectura):
#   git -C <ruta_hermano> branch --show-current
#   ls <ruta_hermano>/50_documentacion/activa/gobernanza_datos.md
# Regenerar el panorama (operacion):
source("00_run_all.R"); run_all()
# Idempotencia determinista: dos corridas -> md5 identico de inventario_cartera.*
```

## 14. Reapertura

- **Nombre del chat:** `slep_estado_proyectos_monitoreo, sesion 3 (Opus 4.8)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo
  (POLITICA + SETTINGS) vive en 50_documentacion/activa/ del repo; leelo desde
  ahi. Adjunto el traspaso v02 y el escaner."
- **Documentos:**
  1. *Protocolo (no se adjuntan):* `POLITICA_PROYECTO.md`,
     `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales segun foco:* `CLAUDE.md`;
     `esbozo_fase2_estado_estandarizado.md` si se aborda Fase 2.
  3. *Especificos (se adjuntan):* `traspaso_cierre_v02.md`;
     `50_documentacion/estructura/estructura_actual.md`;
     `reporte_cobertura_documental.md`.
- **Nota final:** si algun archivo cambio entre sesiones, adjuntar la version mas
  actualizada al abrir y avisarlo.
