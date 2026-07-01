# Traspaso de cierre v03 — slep_estado_proyectos_monitoreo

## 1. Identificacion

- **Proyecto:** slep_estado_proyectos_monitoreo (orquestador de estado de la cartera).
- **Version:** v03. **Fecha:** 2026-06-29. **Sesion:** 3 (CONTINUATION).
- **Foco:** cierre total de H4 (gobernanza de datos en proyectos con datos sensibles): creacion de `gobernanza_datos.md` en dos hermanos, merge de rama, regeneracion del orquestador, conexion a GitHub y push de los tres repos.
- **Entorno:** Claude Code + terminal manual (tomgc), R 4.5.2, macOS.
- **Archivos modificados:**
  - `slep_simce_estandares_aprendizaje`: `50_documentacion/activa/gobernanza_datos.md` (creado, commiteado, pusheado; commit 662d6e1).
  - `slep_seguimiento_educacion_inicial`: merge de `docs/suitedoc` a `main` (incorpora `gobernanza_datos.md` + suite suitedoc); commit de merge 10c8673, pusheado.
  - `slep_estado_proyectos_monitoreo`: `40_salidas/inventario_cartera.{json,parquet}` (regenerados, commit fe50290), `50_documentacion/estructura/` (rotacion de snapshot, commit c2da1ed); repo conectado a GitHub por primera vez.

---

## 2. Resumen ejecutivo

Sesion de cierre de gobernanza. Se redactaron e implementaron los `gobernanza_datos.md` faltantes en los dos proyectos sensibles que aun no los tenian: `slep_simce_estandares_aprendizaje` (creado desde cero por Claude Code a partir del traspaso v14) y `slep_seguimiento_educacion_inicial` (ya existia en `docs/suitedoc` desde sesion anterior; se mergeo a `main`). El orquestador se regenero y confirmo `maneja_sensibles=TRUE` en los 12 proyectos sensibles de la cartera (0 pendientes de sintesis, idempotencia determinista verificada). El orquestador se conecto a GitHub (`slep_estado_area_monitoreo`) y se pusheo por primera vez, previa reescritura del historial para usar el email noreply canonico (6 commits reescritos; HEAD final fe50290, luego c2da1ed tras limpiar estructura). Los tres repos quedaron sincronizados con `origin/main`. H4 cerrado.

---

## 3. Estado al cierre

**Funciona (ultima ejecucion 2026-06-29):**
- `run_all()` 31->35 sin intervencion; panorama con 0 pendientes de sintesis.
- Idempotencia determinista: 2da corrida -> json md5 `57d22eb3e8e5fec76b0b9c96e8a1f727`, parquet md5 `5af7f1c636e131ca1837fb59fa1e7666` (identicos entre corridas).
- 12 proyectos con `maneja_sensibles=TRUE` (ver lista en seccion 5).
- Orquestador en GitHub: `https://github.com/tomgc/slep_estado_area_monitoreo`.

**Delta respecto a v02:**
- `maneja_sensibles`: FALSE->TRUE en `simce_estandares_aprendizaje` (gobernanza creada y pusheada).
- `slep_seguimiento_educacion_inicial`: `gobernanza_datos.md` mergeado a main (cierre canonico de H4 para ese proyecto).
- Orquestador: conectado a GitHub por primera vez; historial reescrito a email noreply.
- Inventario actualizado para reflejar los dos cambios de gobernanza.

---

## 4. Registro detallado de cambios

Sesion de operacion y gobernanza; los cambios conceptuales se listan en el backlog (entradas 25-32). No hubo modificacion de scripts del pipeline.

---

## 5. Backlog acumulativo

### Objetivo del proyecto (permanente)

Orquestador en R del Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos (SLEP Costa Central) que descubre en tiempo de ejecucion los proyectos hermanos `~/Projects/slep_*`, lee SOLO su documentacion curada y sintetiza un "estado de situacion de la cartera": un `panorama.md` para el arranque de jornada y la base para informes a jefaturas graduables (L1/L2/L3). No ejecuta ni modifica los pipelines hermanos; su unica escritura ocurre, cerrada por codigo, dentro de su propio repo. Producido con R (tidyverse, arrow, jsonlite, readr, fs). Desde la sesion 1 (2026-06-28).

### Nota metodologica (permanente)

Un "cambio" es una solicitud distinguible del titular o una decision de diseno con efecto en el producto, no cada accion tecnica que la implementa. No cuentan los errores del asistente corregidos de inmediato (si cuentan los bugs reportados por el titular). La clasificacion es por intencion primaria. Fuentes del conteo: este traspaso y los commits.

### Clasificacion tematica

| Categoria | N | Descripcion |
|---|---|---|
| Andamiaje/estructura | 3 | Estructura Rama A, .gitignore, .Rproj, git. |
| Pipeline determinista | 5 | Scripts 31-35. |
| Utilidades/gobernanza por codigo | 2 | escribir_seguro/atomico; descubrir_hermanos. |
| Sintesis cualitativa | 5 | 14 fichas L2 iniciales + 3 re-sintetizadas (s2) + 0 nuevas (s3, sin cambio de sello). |
| Operacion/regeneracion | 3 | Corridas run_all de regeneracion (s2, s3). |
| Documentacion | 6 | README, CLAUDE, cobertura (x2), esbozo Fase 2, decision, traspasos. |
| Robustez/bugfix | 3 | id integer en PASOS, UTF-8 con readr, em-dash mojibake, exclusion .git. |
| Gobernanza hermanos | 8 | gobernanza_datos.md en 3 proyectos (s2) + 2 proyectos (s3) + merge docs/suitedoc + push + conexion GitHub orquestador. |

### Resumen estadistico por sesion

| Sesion | Traspasos | Cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | ~18 | Opus 4.8 | Andamiaje + Fase 1 completa |
| 2 | v02 | 6 | Opus 4.8 | Operacion: regeneracion tras cierre parcial de H4 |
| 3 | v03 | 8 | Opus 4.8 | Gobernanza: cierre total de H4 + GitHub |

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

**Sesion 2 (entradas 19-24):** (copiadas integras de v02)

19. Verificacion del estado de ramas de los tres repos de H4: gobernanza_datos.md presente en los tres working trees (dos en main, uno en docs/suitedoc).
20. Regeneracion del panorama via `run_all()` (operacion, sin tocar scripts).
21. Re-sintesis de 3 caches con sello nuevo: georreferenciacion (v05), minuta_desvinculacion (v29), simce_adecuado (v24); 11 reutilizados literal.
22. Confirmacion del delta `maneja_sensibles` FALSE->TRUE en los tres de H4.
23. Actualizacion del reporte de cobertura (cierre parcial de H4, matiz de rama, caso abierto simce_estandares).
24. Verificacion de que el paso 31 preserva la curacion del titular del registro (16 filas con nombre_real/alias_corto/notas intactos).

**Sesion 3 (entradas 25-32, nuevas):**

25. Creacion de `gobernanza_datos.md` en `slep_simce_estandares_aprendizaje` (desde traspaso v14; 117 lineas; commit 662d6e1 en ese repo).
26. Deteccion de que `slep_seguimiento_educacion_inicial` ya tenia `gobernanza_datos.md` en `docs/suitedoc` (270 lineas, commit a6727a5); no se sobrescribio.
27. Merge de `docs/suitedoc` a `main` en `slep_seguimiento_educacion_inicial` (8 archivos, 2556 inserciones; commit de merge 10c8673).
28. Regeneracion del orquestador: `maneja_sensibles=TRUE` confirmado en 12 proyectos; idempotencia determinista verificada (md5 identico run1=run2).
29. Commit de salidas del orquestador (inventario_cartera.json + .parquet; commit fe50290 pre-reescritura).
30. Conexion del orquestador a GitHub (`slep_estado_area_monitoreo`); reescritura de historial (6 commits, email tgonzalez@gmail.com -> 10123542+tomgc@users.noreply.github.com); push exitoso (HEAD c2da1ed).
31. Push de `slep_simce_estandares_aprendizaje` (fix de GH007 por email, reescritura de 1 commit; push 662d6e1).
32. Push de `slep_seguimiento_educacion_inicial` (push 10c8673, sin reescritura necesaria).

### Delta del backlog

8 entradas nuevas (25-32). Nueva categoria "Gobernanza hermanos". Sin reclasificaciones ni renumeraciones de entradas previas.

---

## 6. Bugs de la sesion

Ninguno en el pipeline. Incidente operacional resuelto autonomamente:

- **GH007 (email privado en commits):** los commits del orquestador y de simce_estandares usaban `tgonzalez@gmail.com`; GitHub rechaza el push con la proteccion de email activa. Fix: reescritura de autor/committer al noreply `10123542+tomgc@users.noreply.github.com` (ya configurado en los demas repos). Aprobado explicitamente por el titular antes de ejecutar. Regla aprendida: fijar `user.email` local en cada repo al noreply antes del primer commit.

---

## 7. Aprendizajes y restricciones (nuevos en s3)

- **Antes del primer push a un repo nuevo, verificar el email de todos los commits del historial.** Si el repo se creo con git init y no tenia `user.email` local configurado, puede haber usado el email global (real). El fix es reescritura de historial antes del push (seguro si no hay remoto previo).
- **Un `gobernanza_datos.md` puede existir en una rama no mergeada.** El patron correcto es verificar con `branch --show-current` antes de crear; si existe en otra rama, el paso es el merge, no la creacion. Regla: chequear working tree Y rama antes de declarar ausencia.
- **El encargo autonomo debe leer el traspaso del proyecto hermano** para extraer campos de gobernanza; el cache del orquestador es orientativo pero no suficiente para los campos institucionales/legales.

---

## 8. Decisiones de diseno

- **Reescritura de historial del orquestador (D8):** aprobada por el titular porque el repo nunca habia sido pusheado (sin consecuencias remotas). Alternativa rechazada: desactivar proteccion de email en GitHub (expone email real). Alternativa rechazada: dejar el orquestador sin remoto.
- Vigentes las D1-D7 de `activa/decisiones/20260628_decision_arquitectura_orquestador.md`.

---

## 9. Constantes y parametros vigentes

Sin cambios: DIAS_OBSOLETO=21, LEER_GIT=FALSE, SLUG_ORQUESTADOR, AUXILIARES_SEMILLA, PATRON_EXCLUIR_UNIVERSO=`\\.git$`, ESQUEMA_INVENTARIO="1".

Email local del orquestador fijado a `10123542+tomgc@users.noreply.github.com` (nuevo desde s3).

---

## 10. Arquitectura de archivos

Ver `50_documentacion/estructura/estructura_actual.md` (escaner al cierre de s3, fecha 2026-06-29 18:20:04, 44 archivos, 285K). Sin cambios estructurales respecto a v02; se agrego `traspaso_cierre_v03.md` en traspasos y se rotaron los snapshots de estructura.

Repo remoto: `https://github.com/tomgc/slep_estado_area_monitoreo` (conectado en s3).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P-H4-REVISAR-INSTITUCIONAL** (abierto, transversal). Los `gobernanza_datos.md` de los tres proyectos cerrados en s2 + el de simce_estandares llevan marcas `# REVISAR` institucionales: roles nominales con acceso, offboarding, Encargado de Proteccion de Datos, politica de retencion, contacto de TI. Son preguntas que el titular puede responder una vez y propagar a los cuatro archivos. Tipo: documentacion (repos hermanos). Complejidad: baja. Criterio: sin marcas `# REVISAR` institucionales en los cuatro gobernanza_datos.md.
- **P-H4-REVISAR-LEGAL** (abierto, transversal). Marcas `# REVISAR (legal)` sobre base legal especifica y acto administrativo habilitante en minuta_desvinculacion, aprendizajes_ep y seguimiento. Requiere area juridica SLEP. Tipo: gobernanza/legal. Complejidad: externa.
- **P-SIMCE-ESTANDARES-VAR-ENV** (deuda tecnica). Discrepancia en el nombre de la variable de entorno del data root de `slep_simce_estandares_aprendizaje`: el codigo usa `SIMCE_ESTANDARES_APRENDIZAJE_DATA_ROOT` (sin prefijo SLEP_), README/CLAUDE/traspaso usan `SLEP_SIMCE_ESTANDARES_APRENDIZAJE_DATA_ROOT` (canonico segun POLITICA 6.2). Tipo: deuda tecnica (repo hermano). Complejidad: baja. Criterio: codigo y documentacion alineados al nombre canonico con prefijo.
- **P-SIMCE-ESTANDARES-CATEGORIA-21719** (gobernanza). El `gobernanza_datos.md` de simce_estandares dejo como `# REVISAR` si los insumos incluyen microdatos individuales con RUT (datos de NNA) o solo agregados por establecimiento educacional. El traspaso v14 no lo aclara explicitamente. Tipo: gobernanza. Complejidad: baja (el titular sabe que datos tiene). Criterio: categoria Ley 21.719 declarada sin marca REVISAR.
- **P-PLANTILLA-DESTINO** (higiene). `PLANTILLA_gobernanza_datos.md` quedo untracked en repos hermanos. Mover a `herramientas_dev/plantillas/` y retirar de cada repo. Tipo: higiene. Complejidad: baja.
- **P-REGISTRO-OPCIONALES** (documentacion). `alias_corto`/`notas` del registro ya poblados desde data.js del portafolio. El titular ratifica. Tipo: documentacion. Complejidad: minima.

### Diferidos (se mantienen de v02)

- **P3/Fase 2 (PUSH/PULL con ESTADO.md):** sesion BIBLIOTECA dedicada (requiere SETTINGS v5 y propagacion a 16 repos).
- **P4 (informe a jefaturas L1/L2/L3 parametrizable):** mayor valor para el titular; candidato para encargo autonomo a Claude Code.
- **Higiene de cobertura organica** (resenas/backlogs ausentes en proyectos activos cuando reabran).
- **P5 (LEER_GIT=TRUE):** opcional.

### Auditoria de cierre (POLITICA 5.6)

- Pipeline corre de cero sin intervencion: **Si**.
- Outputs idempotentes: **Si** (md5 verificado).
- Constantes nombradas: **Si**.
- Naming sin tildes/ni/espacios: **Si**.
- Sin deuda nueva sin documentar: **Si** (toda registrada arriba).

### Ruta sugerida para la sesion 4

1. **P4 — informe a jefaturas parametrizable** (mayor valor; el pipeline esta maduro). Candidato a encargo autonomo a Claude Code.
2. **P-H4-REVISAR-INSTITUCIONAL** — el titular responde los campos institucionales y se propagan a los cuatro `gobernanza_datos.md` (baja complejidad, alta importancia legal).
3. Diferir Fase 2 a sesion BIBLIOTECA.

---

## 12. Instrucciones especificas para la sesion 4

- 🔒 NUNCA escribir fuera de `slep_estado_proyectos_monitoreo/` (R1, cerrado por `escribir_seguro`). Hermanos = solo lectura de documentacion curada.
- ⚠️ NO leer `20_insumos/`, `40_salidas/` con datos, OneDrive ni `*_volcado_crudo*` (R2).
- ✅ ANTES de crear `gobernanza_datos.md` en un hermano, verificar rama actual con `git branch --show-current` y presencia del archivo en esa rama.
- ✅ ANTES del primer push a un repo nuevo, verificar emails de todo el historial con `git log --format="%ae" | sort -u`.
- ⚠️ NO tocar Fase 2 (ESTADO.md/SETTINGS en hermanos) sin sesion dedicada.
- ✅ Fijar `user.email` local al noreply en todo repo nuevo antes del primer commit.

---

## 13. Fragmentos de referencia

```r
# Verificar rama y presencia de gobernanza en un hermano (solo lectura):
#   git -C <ruta_hermano> branch --show-current
#   ls <ruta_hermano>/50_documentacion/activa/gobernanza_datos.md

# Regenerar el panorama (operacion):
source("00_run_all.R"); run_all()

# Idempotencia determinista: dos corridas -> md5 identico de inventario_cartera.*

# Verificar emails del historial antes de push a repo nuevo:
#   git -C <ruta_repo> log --format="%ae" | sort -u

# Reescribir email de historial (solo si repo nunca pusheado; requiere aprobacion explicita):
# FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter '
#   N="10123542+tomgc@users.noreply.github.com"
#   [ "$GIT_AUTHOR_EMAIL" = "tgonzalez@gmail.com" ] && export GIT_AUTHOR_EMAIL="$N"
#   [ "$GIT_COMMITTER_EMAIL" = "tgonzalez@gmail.com" ] && export GIT_COMMITTER_EMAIL="$N"; true
# ' -- --all
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_estado_proyectos_monitoreo, sesion 4 (Opus 4.8)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (POLITICA + SETTINGS) vive en `50_documentacion/activa/` del repo; leelo desde ahi. Adjunto el traspaso v03 y el escaner."
- **Documentos:**
  1. *Protocolo (no se adjuntan):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales segun foco:* `CLAUDE.md`; `esbozo_fase2_estado_estandarizado.md` si se aborda Fase 2; `encargo_autonomo_claude_code_v1.md` si se redacta encargo para P4.
  3. *Especificos (se adjuntan):* `traspaso_cierre_v03.md`; `estructura_actual.md`.
- **Nota final:** si algun archivo cambio entre sesiones, adjuntar la version mas actualizada al abrir y avisarlo.
