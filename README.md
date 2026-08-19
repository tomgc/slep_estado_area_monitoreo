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

<!-- portabilidad-cross-os: bloque generado, no editar a mano -->

## Portabilidad cross-OS

Este proyecto se clona, configura y ejecuta igual en macOS y en Windows. El contrato completo está en `herramientas_dev/gobernanza/portabilidad_os/protocolo_portabilidad_cross_os.md`.

### Configuración de una máquina nueva

1. Instalar Git, R y Positron.
2. Clonar el repositorio **fuera de OneDrive** (por ejemplo `~/Projects/slep_estado_area_monitoreo`).
3. Copiar `.Renviron.example` a `~/.Renviron` y declarar la raíz de datos. Basta **una línea**:

   ```text
   WORKSPACE_DATA_ROOT=<carpeta de proyectos en el OneDrive institucional>
   ```

   El proyecto se resuelve como `<WORKSPACE_DATA_ROOT>/slep_estado_area_monitoreo`. Si necesita otra ubicación, declarar `SLEP_ESTADO_AREA_MONITOREO_DATA_ROOT`, que gana sobre la global. Reiniciar R después de editar.
4. Verificar que la raíz de datos esté sincronizada y accesible.
5. Restaurar el entorno de paquetes:

   ```r
   renv::restore()
   ```

   `renv.lock` es la única fuente de verdad de paquetes y versiones. No instalar con `install.packages()` a mano.

### Validación del entorno

Antes de ejecutar nada, con la sesión de R abierta en la raíz del repo:

```r
source(here::here("10_utils", "10_validar_portabilidad.R"))
validar_portabilidad()
```

Debe quedar sin fallas críticas. Comprueba el ancla de `here`, la locale UTF-8, `renv.lock`, que `.Renviron` no esté versionado, que `.Renviron.example` exista, y que la raíz de datos resuelva y sea escribible. Para comprobar que el propio verificador detecta violaciones: `validar_portabilidad_autotest()`.

### Ejecutar el proyecto

```r
source(here::here("00_run_all.R"))
```

### Matriz de dependencias de sistema

Lo que `renv` no resuelve se instala en la máquina antes de ejecutar el pipeline.

| Dependencia | macOS | Windows | Necesaria |
|---|---|---|---|
| Git | sí | sí | sí |
| R (4.2 o superior) | sí | sí | sí |
| Positron | sí | sí | recomendado |
| OneDrive institucional | sí | sí | sí (raíz de datos) |

Si el proyecto necesita binarios externos (ODBC, Java, Ghostscript, LibreOffice, Quarto, Typst), declararlos en esta tabla con su versión: el protocolo prohíbe depender de que un comando esté "casualmente" en el `PATH`.

