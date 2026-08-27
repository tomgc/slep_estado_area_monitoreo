# Diagnostico de `data.js` y de la perdida de `estado_proyecto`

- **Encargo:** A-05, sesion 13. **Naturaleza:** solo lectura. Este informe no corrige nada.
- **Cubre:** O-05 (`tipo`, `objetivo`, `sintesis` nulos) y O-06 (`estado_proyecto` vacio).
- Ninguna salida del pipeline se regenero ni se restauro: el diagnostico no ejecuto ningun paso. Las definiciones del paso 6 se evaluaron en aislamiento (`parse()` + `eval()` selectivo de `parsear_data_js` y `MAPEO_ORDEN_SLUG`), nunca por `source()` del script, que habria escrito `40_salidas/`.

## 1. Veredicto por frente

**Frente A.** `30_procesamiento/36_generar_panorama_visual.R:38` construye `~/Projects/slep_monitoreo/data.js`, donde el archivo ya no esta; y **aunque se corrija la ruta seguiria fallando**, porque la lista blanca de la linea 204 no cubre la clave `id` que el origen agrego: son **tres defectos apilados**, no uno.

**Frente B.** `30_procesamiento/36_generar_panorama_visual.R:384` lee `estado_proyecto` de la fila del **registro**, no de `ESTADO.md`; la columna nunca fue curada (0 de 25 filas con valor). **No hay defecto de extraccion que corregir.**

## 2. Evidencia del Frente A

### 2.1 El consumidor es unico

`grep -rn "data\.js|data_js|DATA_JS" --include="*.R"` devuelve **un solo archivo**, `30_procesamiento/36_generar_panorama_visual.R`. La premisa del encargo ("no asumas el paso 6") resulto correcta esta vez: el paso 6 es el unico consumidor.

| Linea | Rol |
|---|---|
| 38 | `RUTA_DATA_JS_PORTAFOLIO <- file.path(RAIZ_PROYECTOS, "slep_monitoreo", "data.js")` |
| 64-76 | `MAPEO_ORDEN_SLUG`: 11 pares `orden` -> slug, clavados por `orden` |
| 185-215 | `parsear_data_js()`: saneador de 7 claves + `jsonlite::fromJSON` por objeto |
| 313 | `datos_data_js <- parsear_data_js(RUTA_DATA_JS_PORTAFOLIO)` |
| 358 | `dj <- datos_por_slug[[slug]]` |
| 395-397 | `sintesis`, `objetivo`, `tipo` salen a `NA` si `dj` es `NULL` |

### 2.2 La ruta evaluada, no la escrita

| | Valor |
|---|---|
| `RAIZ_PROYECTOS` | `~/Projects` |
| Ruta que el codigo construye | `~/Projects/slep_monitoreo/data.js` |
| Existe | **NO** |
| Unico `data.js` bajo `~/Projects` | `~/Projects/slep_monitoreo/docs/data.js` (22864 bytes) |

El movimiento esta datado en el historial del hermano: commit `00a1af3`, *"chore(pages): mueve el sitio a docs/ y deja de servir la raiz"*. El orquestador nunca se entero.

### 2.3 Las tres causas del encargo: dos aplican, y se enmascaran

| Causa candidata (encargo 5.4) | Veredicto | Evidencia |
|---|---|---|
| La ruta construida no es donde esta el archivo | **SI** | `file.exists()` FALSE en la ruta del codigo, TRUE en `docs/` |
| El archivo esta y el parser ya no lo entiende | **SI** | Con la ruta correcta, `parsear_data_js()` emite 12 advertencias `entrada no parseable` y devuelve `NULL` igual |
| El archivo no existe en ninguna parte | NO | Existe, con 12 entradas y 22528 caracteres |

**Esto es lo importante del frente A:** corregir solo la ruta no arregla nada, y el sintoma seria identico (todo nulo). Quien aplique el cambio de ruta y mida el resultado concluiria que la ruta no era el problema.

La segunda causa es concreta: el saneador de la linea 204 quotea exactamente siete claves
(`estado`, `imgs`, `objetivo`, `orden`, `sintesis`, `tipo`, `titulo`) y el archivo de origen hoy trae **8**, incluida `id`, que queda sin comillas y hace fallar `fromJSON` en **cada uno** de los 12 objetos. El `tryCatch` por objeto degrada con gracia, se queda sin ninguno, y `parsear_data_js()` devuelve `NULL`. La clave la agrego el commit `15dc047` del hermano, *"Agrega el campo id a los 12 proyectos y enlaces profundos #p=<id>"*.

### 2.4 Tercer defecto, latente: el `orden` ya se renumero

`MAPEO_ORDEN_SLUG` se clava por `orden`. El origen inserto un proyecto nuevo en la posicion 3 y corrio todo lo posterior en +1. Contraste literal:

| `orden` | Titulo hoy en `data.js` | Slug que `MAPEO_ORDEN_SLUG` asigna a ese `orden` |
|---|---|---|
| 3 | Minutas de resultados Simce 2025 del territorio *(nuevo)* | `slep_simce_adecuado` |
| 4 | Motor ... estandares de aprendizaje Simce | `slep_idps` |
| 5 | Motor ... IDPS | `slep_categoria_desempeno` |
| 12 | Diagnostico historico del rendimiento escolar | *(sin par en el mapeo)* |

Es decir que arreglar ruta y parser **sin tocar el mapeo** no produciria nulos: produciria **contenido editorial cruzado**, cada proyecto mostrando el objetivo y la sintesis de otro. Una salida verde y equivocada, que es peor que un nulo (A25). El propio `data.js` lo advierte en su cabecera: `orden` *"se renumera al insertar proyectos"*, mientras que `id` es la *"llave estable y unica... NO se cambia una vez publicado"*.

### 2.5 Traza del campo hasta la salida

Tomando `slep_minuta_asistencia` (`orden` 1, `id` `asistencia`, el unico cuyo `orden` no se desplazo): `parsear_data_js()` devuelve `NULL` en la linea 313 -> la guarda de la 320 deja `datos_por_slug` vacio -> `dj` es `NULL` en la 358 -> `parrafos` queda en `character(0)` (361) -> las lineas 395-397 escriben `sintesis = NA`, `objetivo = NA`, `tipo = NA`. El punto exacto de la perdida es la **linea 313**, y su causa esta aguas arriba, en la 38 y en la 204.

## 3. Evidencia del Frente B

### 3.1 La medicion en el origen invalida la hipotesis del encargo

De los 26 directorios `slep_*`, 23 tienen `ESTADO.md`. El campo `estado_proyecto` esta **ausente en los 23**, sin una sola excepcion. El campo `semaforo` esta presente en 23 de 23.

| | Con `ESTADO.md` | Con `estado_proyecto` | Con `semaforo` |
|---|---|---|---|
| Hermanos (26 directorios) | 23 | **0** | 23 |

### 3.2 El campo no nace donde el encargo supone

`estado_proyecto` **no es** campo del front matter de `ESTADO.md`. Es la septima columna de `registro_proyectos.csv`, curada a mano, como declara el comentario de `30_procesamiento/31_descubrir_proyectos.R:52` (*"curadas a mano por el titular"*). El unico lugar donde el codigo la lee es `36_generar_panorama_visual.R:384`:

```r
estado_proyecto  = if (tiene_rg) o_null(rg$estado_proyecto) else NA_character_,
```

donde `rg` es la fila del registro, no el front matter del hermano. Por eso el chequeo del encargo 6.4 (si el campo figura en la lista de campos que el codigo extrae del front matter) queda sin objeto: no figura porque **nunca se pretendio extraerlo de ahi**.

### 3.3 El contraste que pide el encargo 6.3, y un control positivo

| Campo | Fuente en el codigo | Linea | Presente en origen | Llega a la salida |
|---|---|---|---|---|
| `semaforo` | `eh$semaforo`, front matter del `ESTADO.md` del hermano | 366 | 23/23 | SI |
| `estado_proyecto` | `rg$estado_proyecto`, fila del registro | 384 | 0/25 | no hay que llevar |

La diferencia entre los dos tratamientos no es la expresion de parseo ni el nombre del campo: es que **leen de dos fuentes distintas**, y una de las dos esta vacia.

El control positivo lo da la columna vecina. `datos_sensibles` vive en el mismo registro, se lee en la linea 383 con la misma expresion, y tiene exactamente 1 valor curado (`slep_paes = FALSE`). En `40_salidas/panorama_visual.md`, generado el 2026-08-26, la ficha de `slep_paes` dice:

```
- **estado:** sin clasificar
- **datos sensibles:** FALSE
```

El unico valor curado de esa columna **llega intacto a la salida**. La cadena de extraccion funciona. Lo que falta es el dato.

## 4. Correccion propuesta, descrita y no aplicada

### Frente A: tres cambios, en este orden, y ninguno sirve solo

1. **Ruta.** `36_generar_panorama_visual.R:38`: `file.path(RAIZ_PROYECTOS, "slep_monitoreo", "data.js")` -> `file.path(RAIZ_PROYECTOS, "slep_monitoreo", "docs", "data.js")`. Conviene resolverlo con un fallback que pruebe ambas (`docs/` primero) y registre cual uso, para que el proximo movimiento del sitio no vuelva a romperlo en silencio.
2. **Parser.** `36_generar_panorama_visual.R:204`: la lista blanca de siete claves es fragil por construccion (cada clave nueva en origen rompe el objeto entero). Reemplazarla por un saneador que quotee **cualquier** clave a inicio de linea, `(?m)^(\\s*)([a-zA-Z_][a-zA-Z0-9_]*)\\s*:` -> `\\1"\\2":`, que es igual de seguro para este formato plano y deja de necesitar mantenimiento.
3. **Clave del mapeo.** `36_generar_panorama_visual.R:64-76`: reemplazar `MAPEO_ORDEN_SLUG` por un mapeo `id` -> slug. `id` es estable por contrato declarado del origen; `orden` no. Los 12 `id` actuales son: `asistencia`, `resguardo`, `simce`, `estandares`, `idps`, `categorias`, `parvularia`, `inicial`, `costapresente`, `ael`, `trayectorias`, `rendimiento`.

**Como medir que funciono:** tras los tres cambios, `parsear_data_js()` sobre la ruta nueva debe devolver 12 entradas y cero advertencias; y en `panorama_visual.md`, la ficha de `slep_minuta_asistencia` debe mostrar `tipo: Minuta - Direccion Ejecutiva` y la de `slep_idps` un objetivo que hable de IDPS y no de estandares Simce. Ese segundo control es el que detecta el cruce del mapeo; el conteo de entradas por si solo no lo detecta.

### Frente B: no hay codigo que corregir

La correccion es de **dato, no de software**: curar la columna `estado_proyecto` de `40_salidas/registro_proyectos.csv` para los proyectos que corresponda. Antes de curarla hay que fijar su dominio de valores: `36_generar_panorama_visual.R` la ordena por `RANGO_ESTADO` (taxonomia editorial), y en la sesion 6 curarla con el enum equivocado tumbo el paso 6. El `estado` de `data.js` (`vigente` / `desarrollo`) es candidato natural a poblarla de forma automatica una vez que el frente A este resuelto, lo que convertiria un campo curado a mano en uno derivado. **Esa es una decision del titular, no de este informe.**

**Como medir que funciono:** `n_sin_estado` en `36_generar_panorama_visual.R:958` baja de su valor actual, y las fichas dejan de decir `estado: sin clasificar`.

## 5. Lo que no se pudo determinar

- **Que valores deberia llevar `estado_proyecto`.** El dominio valido esta en `RANGO_ESTADO` dentro del paso 6, pero cual corresponde a cada proyecto es curacion del titular y no se deduce del codigo ni del origen.
- **Si el `orden` volvera a moverse.** El contraste de la seccion 2.4 es de hoy. Mientras el mapeo siga clavado por `orden`, cualquier insercion futura en el sitio vuelve a cruzarlo, y nada en el pipeline lo detecta.
- **Si los 12 `id` cubren los 25 hermanos.** El sitio publica 12 proyectos y la cartera tiene 25 directorios: 13 hermanos no tienen entrada editorial y seguiran con `tipo`, `objetivo` y `sintesis` nulos aun con todo corregido. Eso no es un defecto, pero conviene no leerlo como tal.

## 6. Premisas de este encargo que resultaron falsas

1. **El 5.4 pide decir *cual* de las tres causas es.** Son dos, apiladas, y la de la ruta enmascara la del parser. Se declara el par, no una.
2. **El 5.5 pide seguir `tipo`, `objetivo` y `sintesis` hasta `inventario_cartera.json`.** Esos tres campos no estan ni pueden estar ahi: el inventario lo compila el paso 4 y sus campos por proyecto son `slug`, `nombre_real`, `alias_corto`, `categoria`, `estructura`, `maneja_sensibles`, `traspaso`, `fechas`, `sellos`, `documentos`, `cobertura`, `estado`, `notas`. Los tres viven solo en el objeto en memoria del paso 6 y terminan en `panorama_visual.html` y `.md`. La traza se hizo hasta ese destino real.
3. **El 6.1 supone que `estado_proyecto` es campo del front matter de los `ESTADO.md`.** No lo es en ninguno de los 23 hermanos que tienen `ESTADO.md`, y el codigo tampoco lo busca ahi. El propio encargo previo esta comprobacion "porque puede invalidar toda la hipotesis": la invalido.
4. **El 6.2 y el 6.4 presuponen una cadena de extraccion que perdia el campo.** No hay tal cadena: no hay etapa intermedia entre el registro y la linea 384. El campo no se pierde en ningun punto porque nunca entro.

