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

1. 2026-06-28 (v01): andamiaje Rama A completo; pipeline 31->35 funcional;
   registro sembrado; inventario + panorama generados; reporte de cobertura;
   esbozo Fase 2; tests en verde; primer commit.
