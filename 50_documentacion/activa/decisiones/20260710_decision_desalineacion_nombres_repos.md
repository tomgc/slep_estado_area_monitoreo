# Decisión: desalineación entre nombre de directorio local y nombre de repo remoto

- **Fecha:** 2026-07-10
- **Sesión:** 11 (`slep_estado_proyectos_monitoreo`)
- **Origen:** pendiente P3 del `traspaso_cierre_v10.md` §11, ampliado al
  descubrirse un tercer caso durante el inventario de sesión 11.
- **Evidencia:** `50_documentacion/andamios/20260710_inventario_repos_y_nuevos.md`
  (andamio de solo-lectura con el cruce completo de los 22 directorios `slep_*`).

## Contexto

El pipeline descubre proyectos por **convención** sobre el nombre del
**directorio local** (`descubrir_hermanos()` en `10_configuracion.R`: filtra
`startsWith("slep_")`, excluye el orquestador y `PATRON_EXCLUIR_UNIVERSO`). El
nombre del **repositorio remoto** no interviene en el descubrimiento. Por eso
una desalineación entre ambos nombres **no bloquea el pipeline** (los tres casos
pushean fast-forward con historia compartida), pero es deuda de nomenclatura que
reaparece en cada auditoría si no queda registrada como decisión.

El inventario de sesión 11 confirmó los 2 casos conocidos de v10 y detectó un
tercero (`slep_lectoescritura`), no listado antes.

## Los tres casos

| directorio_local | repo_remoto | naturaleza | decisión |
|---|---|---|---|
| `slep_georreferenciacion` | `tomgc/slep_territorio_costa_central` | proyecto cerrado (`semaforo=cerrado`, s10) | **Mapeo aceptado**, sin renombrar |
| `slep_estado_proyectos_monitoreo` | `tomgc/slep_estado_area_monitoreo` | orquestador (ancla de rutas y `SLUG_ORQUESTADOR`) | **Mapeo aceptado**, sin renombrar |
| `slep_lectoescritura` | `tomgc/slep_desarrollo_lectoescritura` | hermano activo nuevo, aún no sincronizado al registro | **Alinear a forma corta** (renombrar remoto) |

## Decisión por caso

### Caso 1 — `slep_georreferenciacion` → `slep_territorio_costa_central`

**Decisión: mapeo aceptado, no renombrar.**

- **Alternativas consideradas:** (a) renombrar el directorio local para igualar
  al remoto temático; (b) renombrar el remoto de vuelta a `slep_georreferenciacion`;
  (c) aceptar el mapeo y documentarlo (elegida).
- **Justificación:** el proyecto está cerrado (`semaforo=cerrado` desde s10).
  Renombrar el directorio de un proyecto terminado no aporta valor operativo y
  arriesga romper referencias locales de un repo que ya no se toca. El remoto fue
  renombrado deliberadamente a un nombre temático (afiche territorial de Costa
  Central); revertirlo perdería esa intención.
- **Implicancia:** el mapeo local↔remoto queda como dato conocido; cualquier
  operación remota sobre este proyecto usa `slep_territorio_costa_central`.
  Historia compartida verificada por `merge-base` en sesión previa.

### Caso 2 — `slep_estado_proyectos_monitoreo` → `slep_estado_area_monitoreo`

**Decisión: mapeo aceptado, no renombrar.**

- **Alternativas consideradas:** (a) renombrar el directorio local; (b) renombrar
  el remoto para igualar al directorio; (c) aceptar el mapeo (elegida).
- **Justificación:** el directorio local es el ancla de todo el sistema:
  `SLUG_ORQUESTADOR`, las rutas de `10_configuracion.R`, el `.Rproj`, y la
  autoexclusión del universo descubierto. Renombrarlo (local o remoto) propaga a
  variables de entorno y configuración con riesgo desproporcionado frente a un
  beneficio puramente cosmético. El orquestador se autoexcluye del universo, así
  que la desalineación no afecta el descubrimiento de hermanos.
- **Implicancia:** operaciones remotas sobre el orquestador usan
  `slep_estado_area_monitoreo`. Documentado como deuda de nomenclatura aceptada,
  no como error a corregir.

### Caso 3 — `slep_lectoescritura` → `slep_desarrollo_lectoescritura`

**Decisión: alinear a la forma corta `slep_lectoescritura`, renombrando el
repositorio remoto.**

- **Alternativas consideradas:** (a) adoptar la forma larga del remoto como
  canónica, renombrando el directorio local (arrastra cambio de slug: baja + alta
  en el registro); (b) alinear a la forma corta renombrando el remoto (elegida);
  (c) aceptar el mapeo como en los casos 1 y 2.
- **Justificación:** a diferencia de los otros dos, es un proyecto **activo y
  nuevo**, aún sin fila en `registro_proyectos.csv` ni `ESTADO.md` consumido por
  el orquestador: es el momento más barato para alinear, sin arrastre. La forma
  corta es (i) la que el pipeline ya produce por convención sobre el directorio
  local, y (ii) consistente con el resto de la cartera, donde ningún hermano lleva
  prefijo `desarrollo_`. El rename recae en el remoto (barato, sin efecto sobre
  rutas locales, slug ni descubrimiento).
- **Implicancia:** tras el rename remoto, `git remote -v` del directorio local
  apunta a `tomgc/slep_lectoescritura`; el mapeo desaparece en lugar de aceptarse.
  Es prerequisito de la sincronización posterior (`run_all()`): resolver el nombre
  antes de que el proyecto entre al registro evita una fila con slug provisional.

## Orden de ejecución dependiente

El rename del caso 3 debe ocurrir **antes** de correr `run_all()` para sincronizar
los hermanos nuevos al registro. Un rename posterior al alta en el CSV generaría
una baja (`categoria="baja"`) más un alta con el nombre nuevo. Como el rename es
del **remoto** (no del directorio), el slug local no cambia, pero se mantiene el
orden por higiene y para no depender de ese matiz.

## Estado

- Casos 1 y 2: cerrados (mapeo aceptado, sin acción sobre los repos).
- Caso 3: pendiente el rename remoto (`gh repo rename`), acción de sesión 11.
