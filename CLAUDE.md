# CLAUDE.md - slep_estado_proyectos_monitoreo

## Descripcion

Orquestador de estado de la cartera del Area de Monitoreo y Seguimiento de
Procesos y Resultados Educativos (SLEP Costa Central). Descubre los proyectos
hermanos `~/Projects/slep_*`, lee SOLO su documentacion curada y sintetiza un
panorama de la cartera. No ejecuta ni modifica los pipelines hermanos.

## Stack

R: tidyverse, pipe nativo `|>`, `dplyr >= 1.1` con `.by=`, `here`/`rprojroot`,
`fs`, `arrow`, `jsonlite`, `readr`.

## Estructura relevante

- `00_run_all.R` orquesta 31->35; `00_escanear_proyecto.R` escanea ESTE repo.
- `10_utils/10_utils.R` (bootstrapping: `instalar_si_falta`, `log_msg`,
  `escribir_seguro`, `escribir_atomico`, `hash_archivo`).
- `10_utils/10_configuracion.R` (resuelve `RAIZ_ORQUESTADOR` y `RAIZ_PROYECTOS`;
  `descubrir_hermanos()`; constantes `DIAS_OBSOLETO=21`, `LEER_GIT=FALSE`).
- `30_procesamiento/31..35`: descubrir, localizar, metadatos, inventario, panorama.
- `20_insumos/registro_proyectos.csv`: unico insumo curado a mano (el titular
  completa `nombre_real`, `alias_corto`, `notas`; 31 jamas los pisa).
- `40_salidas/`: `inventario_cartera.{json,parquet}` (determinista),
  `cache/<slug>.md` (prosa de sintesis del agente con sello de frescura),
  `panorama.md`.

## Convenciones del proyecto

- Rama A (publico, raiz unificada). `.gitignore` SIN bloque de datos.
- Naming sin tildes/ñ/espacios/guiones medios; estructura por decenas; archivos
  con prefijo numerico de su carpeta. Contenido en espanol pleno; commits en espanol.
- Gobernanza de lectura R1-R4 (ver README): escritura confinada por
  `escribir_seguro`; solo documentacion curada de hermanos; salida saneada
  (sin nombres reales de EE/personas, sin RUT, sin rutas `/Users/`); no ejecutar
  pipelines hermanos.
- Determinista (31-34) vs. sintesis (agente, en `cache/<slug>.md`). El inventario
  es byte-estable; la sintesis se reutiliza literal mientras el sello no cambie.
- Locale de la maquina = C: usar `readr` para CSV y `writeLines(useBytes=TRUE)`
  para texto; no concatenar literales no-ASCII con datos acentuados via sprintf.
- Tras regenerar `panorama.md`, el titular lo sube a la knowledge base del
  Project de consumo (tarea manual).

## Ultimos cambios (max 5, recientes primero)

1. 2026-06-30 (v05, cierre sesion 5): paso 36 endurecido. (a) Paleta sincronizada
   con los valores hex reales de la marca SLEP Costa Central (commit 80b72d0).
   (b) Fix bug B6 (mojibake): bajo locale C los literales no-ASCII se parseaban
   como Encoding "unknown" y al concatenarse con strings UTF-8 (JSON/readLines) R
   los escapaba como texto "<c3><81>"; helper u8() declara UTF-8 antes de mezclar
   (commit 96e1433; misma familia que el em-dash de la sesion 1). (c) P-DATA-JS-RUTA:
   parseo in situ de slep_monitoreo/data.js (R2, nunca copiado) via jsonlite tras
   quotear claves + tryCatch por entrada; mapeo orden->slug aprobado y clavado por
   orden; cards muestran tipo/objetivo/sintesis (primer parrafo + "+N parrafos mas",
   N_PARRAFOS_SINTESIS_CARD=1); 11/16 pobladas, 5 null con gracia (commit 6ecbb43).
2. 2026-06-30 (v05): backlog acumulativo extraido a archivo independiente
   50_documentacion/activa/backlog_acumulativo.md (P-BACKLOG-PROPIO-EXTRAER, 47
   entradas, 5 sesiones; commit 1c3912f); auditoria_backlogs.md archivada como
   andamio congelado en 50_documentacion/andamios/.
3. 2026-06-29 (v02): operacion/regeneracion tras cierre parcial de H4; 3 caches
   re-sintetizados (georreferenciacion v05, minuta_desvinculacion v29,
   simce_adecuado v24), 11 reutilizados literal; maneja_sensibles FALSE->TRUE en
   los 3 de H4; registro curado por el titular preservado; reporte de cobertura
   actualizado. Aprendizaje: el orquestador lee el WORKING TREE (un gobernanza
   en rama no mergeada se ve presente; seguimiento_ed_inicial en docs/suitedoc).
4. 2026-06-28 (v01): andamiaje Rama A completo; pipeline 31->35 funcional;
   registro sembrado; inventario + panorama generados; reporte de cobertura;
   esbozo Fase 2; tests en verde; primer commit.
