# Traspaso de cierre v01 - slep_estado_proyectos_monitoreo

## 1. Identificacion

- **Proyecto:** slep_estado_proyectos_monitoreo (orquestador de estado de la cartera).
- **Version:** v01. **Fecha:** 2026-06-28. **Sesion:** 1 (NEW PROJECT).
- **Foco:** construir el andamiaje Rama A y la Fase 1 (PULL con cache) completa:
  descubrir/localizar/extraer/compilar inventario + sintesis del primer panorama.
- **Entorno:** Claude Code, R 4.5.2, macOS, locale `C`. Paquetes: tidyverse,
  arrow, jsonlite, readr, fs, rprojroot (todos presentes).
- **Archivos principales creados:** `00_run_all.R`, `00_escanear_proyecto.R`,
  `10_utils/{10_utils.R,10_configuracion.R}`,
  `30_procesamiento/{31..35}.R`, `20_insumos/registro_proyectos.csv`,
  `40_salidas/{inventario_cartera.json,.parquet,panorama.md,cache/*.md}`,
  `tests/test_orquestador.R`, `README.md`, `CLAUDE.md`, `.gitignore`, `.Rproj`,
  y en `50_documentacion/activa/`: reporte de cobertura, esbozo Fase 2 y la
  decision de arquitectura.

## 2. Resumen ejecutivo

Se levanto desde cero el orquestador de cartera como proyecto Rama A (publico,
raiz unificada). El pipeline determinista `31->35` descubre por patron los 16
hermanos `slep_*` (excluyendo el propio repo y respaldos `*.git`), localiza su
documentacion curada resolviendo la heterogeneidad de grafias, extrae metadatos
deterministas (fechas mtime, sellos md5) y compila `inventario_cartera.json/.parquet`
byte-estable. La sintesis cualitativa (14 fichas L2 de proyectos activos) se
redacto a mano en `40_salidas/cache/<slug>.md` con sello de frescura, leyendo
reseña + ultimo traspaso + backlog de cada hermano bajo R1-R4, y `35` ensamblo
`panorama.md` (tabla L1 + fichas + alertas). Se entregaron ademas el registro
sembrado con `nombre_real` pre-sugerido, el reporte de cobertura documental y el
esbozo de Fase 2. Quedo todo verificado: 10/10 tests, idempotencia determinista
(md5 estable), confinamiento de escritura probado y testigos de hermanos
inalterados. Pendiente del titular: completar `nombre_real`/`alias_corto`/`notas`
del registro y subir `panorama.md` al Project de consumo.

## 3. Estado al cierre

**Funciona (ultima ejecucion exitosa 2026-06-28):**
- `run_all()` corre 31->35 de cero y produce inventario + panorama sin
  intervencion manual (salvo el llenado de `nombre_real`).
- `00_escanear_proyecto.R` emite snapshot sellado + aliases con poda retencion 2.
- `tests/test_orquestador.R`: 10 OK, 0 FAIL.
- Idempotencia determinista: 2da corrida sin cambios -> `inventario_cartera.json`
  con md5 identico (`26cd448690363f9fb8a5ff42ad55cf65`) y `.parquet` estable.

**Delta respecto a v00:** no aplica (sesion 1).

## 4. Registro detallado de cambios

Ver backlog (seccion 5). Bloques conceptuales de esta sesion: (a) estructura
Rama A + git; (b) utils con `escribir_seguro`/`escribir_atomico`; (c)
configuracion con resolucion+validacion de `RAIZ_PROYECTOS` y `descubrir_hermanos`;
(d) 31 descubrimiento+registro; (e) 32 localizacion por patron; (f) 33
metadatos; (g) 34 inventario; (h) 35 panorama; (i) escaner; (j) tests; (k)
sintesis de 14 fichas L2; (l) reporte de cobertura; (m) esbozo Fase 2; (n)
README/CLAUDE/decision.

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

### Clasificacion tematica inicial (a refinar)

| Categoria | N | Descripcion |
|---|---|---|
| Andamiaje/estructura | 3 | Estructura Rama A, .gitignore, .Rproj, git. |
| Pipeline determinista | 5 | Scripts 31-35. |
| Utilidades/gobernanza por codigo | 2 | escribir_seguro/atomico; descubrir_hermanos. |
| Sintesis cualitativa | 1 | 14 fichas L2 en cache con sello. |
| Documentacion | 4 | README, CLAUDE, cobertura, esbozo Fase 2, decision. |
| Robustez/bugfix | 3 | id integer en PASOS, UTF-8 con readr, em-dash mojibake, exclusion .git. |

### Resumen estadistico por sesion

| Sesion | Traspasos | Cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | ~18 | Opus 4.8 | Andamiaje + Fase 1 completa |

### Detalle cronologico (sesion 1)

1. Estructura de carpetas por decenas (Rama A, raiz unificada).
2. `.gitignore` estandar SIN bloque de datos; `.Rproj`.
3. `10_utils.R`: `instalar_si_falta`, `log_msg`, `escribir_seguro`,
   `escribir_atomico`, `hash_archivo`.
4. `10_configuracion.R`: anclaje rprojroot; resolucion+validacion de
   `RAIZ_PROYECTOS`; `descubrir_hermanos()`; constantes `DIAS_OBSOLETO=21`,
   `LEER_GIT=FALSE`; exclusion `*.git` del universo.
5. `31_descubrir_proyectos.R`: descubrimiento por patron; clasificacion
   canonica/no_canonica y activo/auxiliar/baja; sincronizacion del registro sin
   pisar campos del titular; pre-sugerencia de `nombre_real` desde la reseña.
6. `32_localizar_documentos.R`: localizacion por patron de reseña, traspaso
   (dedup por correlativo entero, desempate de grafia, reporte de colision),
   backlog (preferencia consolidado/acumulativo, exclusion de volcados),
   escaner, gobernanza.
7. `33_extraer_metadatos.R`: fechas mtime, sellos md5, git opcional.
8. `34_compilar_inventario.R`: inventario JSON/parquet determinista, rutas
   saneadas relativas, escritura atomica.
9. `35_compilar_panorama.R`: ensamblado de panorama desde inventario + cache;
   alertas; anexo de documentacion incompleta anotado por hueco.
10. `00_run_all.R`: orquestador 31->35 con `from/to/only/skip`, validacion de
    rutas, logging, resumen.
11. `00_escanear_proyecto.R`: escaner del propio repo, poda retencion 2.
12. `tests/test_orquestador.R`: confinamiento (R1), dedup de traspaso, backlog.
13. Sintesis de 14 fichas L2 (proyectos activos) en `cache/<slug>.md` con sello.
14. `registro_proyectos.csv` sembrado (16 filas, `nombre_real` pre-sugerido).
15. Bugfix: `id` de PASOS como integer (vapply tipado).
16. Bugfix: E/S de registro con `readr` (UTF-8 en locale C; antes `<U+00F3>`).
17. Bugfix: mojibake de em-dash en 35 (separadores ASCII).
18. Documentacion: README, CLAUDE, reporte de cobertura, esbozo Fase 2, decision.

### Delta del backlog

Backlog inicial creado en la sesion 1 (~18 entradas).

## 6. Bugs de la sesion

- **B1:** `run_all()` fallaba en `vapply(... integer(1))`. **Causa raiz:** los
  literales `id = 1` son double en R. **Solucion:** `id = 1L` en `PASOS`.
  **Regla:** tipar enteros con sufijo `L` cuando se validan con `vapply`/`integer`.
- **B2:** `registro_proyectos.csv` con acentos escapados como `<U+00F3>`.
  **Causa raiz:** `utils::write.csv` en locale `C` escapa no-ASCII. **Solucion:**
  `readr::read_csv`/`write_csv`. **Regla:** en locale C, usar readr para CSV y
  `writeLines(useBytes=TRUE)` para texto; UTF-8 explicito.
- **B3:** cabecera L2 con `<e2><80><94>` en vez de "-". **Causa raiz:** literal
  em-dash concatenado via `sprintf` con dato acentuado (UTF-8) en locale C.
  **Solucion:** separadores ASCII en la estructura del panorama. **Regla:** no
  mezclar literales no-ASCII con datos acentuados en `sprintf`.
- **B4 (dato, no bug):** primer arranque sembro `slep_repo_backup_*.git` como
  proyecto. **Solucion:** exclusion por patron `\\.git$` en `descubrir_hermanos`.

## 7. Aprendizajes y restricciones

- **Confinamiento por codigo (R1):** toda escritura pasa por `escribir_seguro`;
  no depender de la disciplina del agente. Probado.
- **Determinista vs. sintesis:** 31-34 producen hechos byte-estables; la prosa
  (cache) la redacta el agente. Reutilizar el cache literal mientras el sello
  (`sello_hash` = md5 del traspaso) coincida; re-redactar solo los de sello nuevo.
- **Heterogeneidad por patron, nunca por nombre fijo.** El vigente del traspaso
  es el maximo correlativo entero, deduplicando por entero (no por archivo).
- **Locale C:** principal fuente de mojibake; ver B2/B3.

## 8. Decisiones de diseno

Replicadas en `50_documentacion/activa/decisiones/20260628_decision_arquitectura_orquestador.md`
(D1 paso 35 separado; D2 division determinista/sintesis y sello; D3
escribir_seguro; D4 grafia historica de minuta_asistencia; D5 exclusion .git;
D6 readr/UTF-8; D7 saneamiento de rutas).

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo |
|---|---|---|
| DIAS_OBSOLETO | 21 | 10_configuracion.R |
| LEER_GIT | FALSE | 10_configuracion.R |
| SLUG_ORQUESTADOR | slep_estado_proyectos_monitoreo | 10_configuracion.R |
| AUXILIARES_SEMILLA | slep_monitoreo, slep_resena_proyectos | 10_configuracion.R |
| PATRON_EXCLUIR_UNIVERSO | `\\.git$` | 10_configuracion.R |
| ESQUEMA_INVENTARIO | "1" | 34_compilar_inventario.R |

## 10. Arquitectura de archivos

Ver `50_documentacion/estructura/estructura_actual.md` (escaner al cierre).
Estructura conforme a la POLITICA (decenas, naming, Rama A).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P1 (manual del titular):** completar `nombre_real`/`alias_corto`/`notas` en
  `20_insumos/registro_proyectos.csv` para los 4 sin reseña (dashboard,
  georreferenciacion, simce_estandares) y los auxiliares. Tipo: documentacion.
  Criterio de exito: registro con `nombre_real` en las 16 filas.
- **P2 (manual del titular):** subir `panorama.md` a la knowledge base del
  Project de consumo tras cada regeneracion. Tipo: operacion. (POLITICA 0.4.)
- **P3 (Fase 2, sesion dedicada):** decidir adopcion del modelo hibrido
  PUSH/PULL con `ESTADO.md` (ver esbozo). Tipo: funcionalidad/migracion.
  Bloqueante: requiere subir SETTINGS a v5 (sesion BIBLIOTECA).
- **P4 (mejora):** implementar el informe a jefaturas L1/L2/L3 parametrizable
  (subconjunto, voz institucional). Hoy existe el panorama (L1+L2); el informe
  graduable a jefaturas aun no. Tipo: funcionalidad. Complejidad media.
- **P5 (mejora opcional):** activar `LEER_GIT=TRUE` para captar actividad con
  traspaso viejo pero commits recientes. Tipo: mejora. Complejidad baja.
- **P6 (frescura):** revalidar `slep_georreferenciacion` (estaba bajo edicion en
  vivo; su cache quedo "pendiente de sintesis"). Re-correr y, si el sello
  cambio, re-redactar su ficha. Tipo: sintesis.

### Auditoria de cierre (POLITICA 5.6)

- Datos crudos aislados: N/A (no maneja datos propios). 
- Pipeline corre de cero sin intervencion: **Si**.
- Paquetes/rutas/constantes al inicio de cada script: **Si**.
- Estructura respeta la politica: **Si**.
- Cada transformacion critica tiene check: **Si** (validar_configuracion;
  guards de upstream; tests).
- Outputs reproducibles/idempotentes: **Si** (determinista verificado).
- Decisiones metodologicas como constantes nombradas: **Si**.
- Nombres sin tildes/ñ/espacios: **Si**.

### Ruta sugerida para la sesion 2

1. Cerrar P1 (registro) y P6 (revalidar georreferenciacion). Criterio: panorama
   sin "pendientes de sintesis" y registro completo.
2. P4: informe a jefaturas parametrizable (mayor valor para el titular).
3. Diferir P3 (Fase 2) a sesion BIBLIOTECA dedicada.

## 12. Instrucciones especificas para la sesion 2

- 🔒 NUNCA escribir fuera de `slep_estado_proyectos_monitoreo/` (R1, cerrado por
  `escribir_seguro`). Hermanos = solo lectura de documentacion curada.
- ⚠️ NO leer `20_insumos/`, `40_salidas/` con datos, OneDrive ni `*_volcado_crudo*`
  de los hermanos (R2). Salida siempre saneada (R3).
- ✅ ANTES de regenerar el panorama, verificar que los `cache/<slug>.md` cuyo
  sello NO cambio se reutilizan literal; re-redactar solo los de sello nuevo.
- ⚠️ NO tocar Fase 2 (ESTADO.md/SETTINGS en hermanos) sin sesion dedicada.

## 13. Fragmentos de referencia

```r
# Forma correcta de escribir cualquier salida (confinada por codigo):
escribir_seguro(file.path(RUTA_SALIDAS, "x.md"), function(r) writeLines(L, r, useBytes = TRUE))
# Inventario byte-estable (atomico):
escribir_atomico(RUTA_INVENTARIO_JSON, function(tmp) jsonlite::write_json(x, tmp, pretty = TRUE, auto_unbox = TRUE))
```

## 14. Reapertura

- **Nombre del chat:** `slep_estado_proyectos_monitoreo, sesion 2 (Opus 4.8)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (POLITICA
  + SETTINGS) vive en la knowledge base y se lee desde ahi. Adjunto el traspaso
  v01 y el escaner."
- **Documentos:**
  1. *Protocolo en knowledge base (no se adjuntan):* `POLITICA_PROYECTO.md`,
     `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales segun foco:* `CLAUDE.md` (sesion en Claude Code);
     `esbozo_fase2_estado_estandarizado.md` si se aborda Fase 2.
  3. *Especificos (se adjuntan):* `traspaso_cierre_v01.md`;
     `50_documentacion/estructura/estructura_actual.md`;
     `reporte_cobertura_documental.md`.
- **Nota final:** si algun archivo cambio entre sesiones, adjuntar la version
  mas actualizada al abrir y avisarlo.
