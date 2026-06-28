# slep_estado_proyectos_monitoreo

Orquestador de estado de la cartera de proyectos del **Area de Monitoreo y
Seguimiento de Procesos y Resultados Educativos** del SLEP Costa Central.

Lee el estado de avance de todos los proyectos hermanos `~/Projects/slep_*` y
produce, bajo demanda, un "estado de situacion de la cartera": un `panorama.md`
para el arranque de jornada y la base para informes a jefaturas.

El orquestador **NO ejecuta ni modifica** los pipelines de los proyectos
hermanos. Solo LEE su documentacion curada y SINTETIZA. Su unica escritura
ocurre dentro de su propio repo (cerrado por codigo, ver `escribir_seguro`).

## Stack

R (>= 4.x): tidyverse, pipe nativo `|>`, `dplyr >= 1.1`, `here`/`rprojroot`,
`fs`, `arrow`, `jsonlite`, `readr`.

## Como correr el pipeline

```r
source("00_run_all.R"); run_all()      # corre 31->35
# o desde shell:
Rscript 00_run_all.R
```

Argumentos de `run_all(from, to, only, skip)`. Pasos:

1. `31_descubrir_proyectos.R`  - descubre `slep_*`, clasifica, detecta altas/bajas, sincroniza el registro.
2. `32_localizar_documentos.R` - localiza por patron reseña, ultimo traspaso, backlog, escaner, gobernanza.
3. `33_extraer_metadatos.R`    - fechas (mtime), sellos md5, git opcional.
4. `34_compilar_inventario.R`  - consolida `inventario_cartera.json` y `.parquet` (determinista, byte-estable).
5. `35_compilar_panorama.R`    - ensambla `panorama.md` (tabla L1 + fichas L2 desde cache + alertas).

Escaner del propio repo: `Rscript 00_escanear_proyecto.R`.
Tests: `Rscript tests/test_orquestador.R`.

## Determinista vs. sintesis

- **31-34 (codigo):** hechos verificables, cero interpretacion. El inventario
  es byte-estable si los hermanos no cambian.
- **Sintesis (agente):** las fichas de estado en prosa se redactan a mano en
  `40_salidas/cache/<slug>.md` (con sello de frescura). 35 las ensambla en el
  panorama. Idempotencia de sintesis: se reutiliza el cache literal mientras el
  sello (`sello_hash`) coincida con el md5 del traspaso vigente.

## Estructura

```
00_run_all.R              orquestador (POLITICA 4)
00_escanear_proyecto.R    escaner de ESTE repo
10_utils/                 bootstrapping + configuracion
20_insumos/               registro_proyectos.csv (unico insumo curado a mano)
30_procesamiento/         31..35
40_salidas/               inventario_cartera.*, cache/, panorama.md
50_documentacion/         activa (POLITICA + SETTINGS + decisiones + reportes), traspasos, andamios, estructura
tests/                    test_orquestador.R
```

## Resolucion de rutas (portable Mac/Windows)

`10_utils/10_configuracion.R` ancla el repo con `rprojroot` y resuelve
`RAIZ_PROYECTOS` asi: (1) variable de entorno `RAIZ_PROYECTOS` si existe; (2) si
no, `dirname(<raiz_orquestador>)` (tipicamente `~/Projects`). Tras resolverla,
**valida** que haya >= 2 hermanos `slep_*`; si no, `stop()` pide definir
`RAIZ_PROYECTOS`. (El fallback `dirname()` falla en silencio si el repo no esta
exactamente en `~/Projects/` o esta anidado; por eso la validacion.)

Configuracion en una maquina nueva: clonar el repo dentro de la carpeta que
contiene los `slep_*` (o exportar `RAIZ_PROYECTOS`), instalar los paquetes del
stack, y correr `run_all()`.

## Gobernanza de lectura (no negociable)

- **R1** Escritura confinada al repo del orquestador (cerrada por codigo).
- **R2** Solo documentacion curada de los hermanos (`50_documentacion/`,
  README, CLAUDE). Nunca `20_insumos/`, `40_salidas/` con datos, OneDrive ni
  `*_volcado_crudo*`.
- **R3** Salida saneada: sin nombres reales de establecimientos, RUT, nombres de
  personas ni rutas absolutas `/Users/<nombre>/`. Universos en abstracto.
- **R4** Nunca se ejecutan los pipelines hermanos.

Este repo es **Rama A** (publico, raiz unificada): no produce ni almacena datos
personales propios. La regla de lectura saneada rige igual, porque lee repos que
si manejan datos sensibles.

## Canal de consumo

El motor es Claude Code (esta sesion y las de regeneracion del panorama). La
consulta y los informes a jefaturas se haran en un Project dedicado de claude.ai
con `panorama.md` en su knowledge base. **Tras cada regeneracion del panorama,
el titular debe actualizar `panorama.md` en la knowledge base de ese Project**
(tarea manual).

Ver POLITICA_PROYECTO.md y SETTINGS_Y_PROMPTS_OPERACIONALES.md en
`50_documentacion/activa/`.
