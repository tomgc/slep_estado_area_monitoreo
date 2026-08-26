# Ruta de encargos — `run_all()` como único comando de actualización y publicación

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Fecha:** 2026-08-24
- **Sesión de origen:** 12
- **Objetivo final:** que un solo comando en Positron recoja el estado de los 24
  hermanos, genere el panorama, deje el árbol del orquestador limpio y sincronizado,
  y publique el sitio, sin ningún paso manual intermedio.

---

## 0. El comando de destino

```r
source(here::here("00_run_all.R"))
run_all(publicar = TRUE)
```

Y su forma segura, que debe existir desde el primer encargo que toque escritura:

```r
run_all(publicar = TRUE, simular = TRUE)   # imprime lo que haria, no toca nada
```

---

## 1. Principio de orden: corrección antes que automatización

Hoy el pipeline produce un panorama con tres defectos medidos (fuente: log de
`run_all()` del 2026-08-24 11:04 y 11:06):

- `data.js no disponible`: `tipo`, `objetivo` y `sintesis` quedan nulos en los 24.
- `24 sin estado_proyecto`: el campo sale vacío en todos, sin excepción.
- Cuatro falsos `PULL` por comparación de `mtime` en vez de `vNN`.

Automatizar el commit y la publicación de un artefacto con esos tres defectos no
ahorra trabajo: publica el error más rápido y con menos oportunidad de verlo. Por eso
los encargos de corrección van antes que los de automatización, y no al revés.

El segundo principio de orden es de riesgo: **el encargo que escribe en git y el que
publica al mundo van al final**, cuando el arnés de verificación ya existe y puede
demostrar que se comportan.

## 2. Restricción permanente: la cartera está en producción

La concurrencia es condición de contexto, no anomalía. Un hermano puede recibir
commits mientras el pipeline lo lee, y el remoto del orquestador puede moverse entre
el `fetch` y el `push`. Esto tiene tres consecuencias de diseño que atraviesan toda la
ruta:

1. **Lectura tolerante:** el paso que recorre hermanos nunca aborta por un repo en
   estado raro. Degrada la fila, la marca y sigue. Ya es el comportamiento del censo y
   debe serlo del pipeline.
2. **Escritura acotada y fail-fast:** el orquestador commitea **solo** artefactos que
   él mismo generó, **solo** en su propio repo, y **se niega** si encuentra cualquier
   otra cosa sucia. Ante un remoto que se movió, falla con instrucción, no
   automerge. Un merge automático dentro de un script es la forma conocida de perder
   trabajo.
3. **Toda medición lleva su instante:** cada fila del log declara cuándo se midió, o
   una corrida no se puede comparar con otra.

## 3. Contrato de log (transversal, lo define el encargo E0)

Es la pieza que hace la ruta evaluable. Sin ella, verificar un encargo consiste en
creerle al reporte; con ella, consiste en leer un artefacto de formato fijo.

Cada paso del pipeline emite, además de su log legible actual, una línea JSON por
evento en `40_salidas/logs/AAAAMMDD_HHMMSS_run.jsonl`, con este esquema cerrado:

| Campo | Tipo | Contenido |
|---|---|---|
| `ts` | string | ISO 8601 con zona |
| `corrida` | string | identificador único de la corrida, igual en todas sus líneas |
| `paso` | int | 1 a 8 |
| `evento` | string | vocabulario cerrado: `inicio`, `fin`, `item_ok`, `item_degradado`, `decision`, `escritura`, `red`, `error` |
| `objeto` | string | slug del hermano, ruta de archivo, o `-` |
| `resultado` | string | `ok`, `degradado`, `omitido`, `error` |
| `causa` | string | vacío si `ok`; obligatorio en cualquier otro caso |
| `medido_en` | string | instante de la medición del objeto, que no es `ts` |
| `duracion_ms` | int | del evento |

Reglas del contrato, todas verificables por lectura del archivo:

- **Una corrida, un archivo.** Nunca se sobrescribe uno anterior.
- **`causa` no vacía siempre que `resultado` no sea `ok`.** Un degradado sin causa es
  un defecto del instrumento, no un dato.
- **Cero rutas absolutas del titular** en el `.jsonl`, por la misma razón que en el
  censo: el repo es público.
- **Nada de secretos.** Tokens y credenciales nunca aparecen, ni truncados.
- **El resumen final se calcula del `.jsonl`, no de variables en memoria.** Si el log
  y el resumen discrepan, el log manda y la discrepancia es un error a registrar.

## 4. Cómo evalúo cada encargo

No por su narración. Cada encargo declara abajo un **criterio de éxito evaluable**,
que consiste siempre en artefactos que puedo leer y contrastar:

- El `.jsonl` de la corrida, contra su esquema y contra las cifras del resumen.
- Un `diff` entre la salida antes y después, cuando el encargo cambia una salida.
- El resultado de un **autotest con control negativo**, en la línea del que el censo
  ya usó: cada corrección debe demostrar en la misma corrida que detecta una
  condición plantada. Una corrección que solo demuestra que "ya no falla" no demuestra
  nada.

---

## 5. Los encargos

### E0 — Arnés: contrato de log estructurado y verificador

**Objetivo.** Depositar `10_utils/10_log_estructurado.R` con la función emisora, y
`tests/verificar_log.R` que valida un `.jsonl` contra el esquema del §3.

**Por qué primero.** Es lo que hace evaluables a los cinco encargos siguientes. Si va
después, cada uno se verifica con un método distinto y ninguno se puede comparar con
el anterior.

**Alcance.** Instrumentar los seis pasos actuales para que emitan el `.jsonl` sin
cambiar una sola línea de su lógica. El log legible actual se conserva tal cual.

**No alcance.** Ninguna corrección de comportamiento. Este encargo no arregla nada, y
esa es su virtud: el `.jsonl` de la primera corrida es la **línea base** contra la que
se medirán E1 y E2.

**Criterio de éxito evaluable.**
1. `run_all()` produce un `.jsonl` con al menos una línea `inicio` y una `fin` por
   paso, y 24 líneas de `item_*` en los pasos 2 y 3.
2. `tests/verificar_log.R` corre sobre ese archivo y sale `0`.
3. El mismo verificador, corrido sobre un `.jsonl` con una línea a la que se le quitó
   `causa` teniendo `resultado: degradado`, sale distinto de `0`. Control negativo
   obligatorio.
4. `git diff` de las salidas antes y después: **vacío**. Instrumentar no cambia el
   producto.

**Complejidad.** Media. **Riesgo.** Bajo.

---

### E1 — Corrección de las tres degradaciones medidas

**Objetivo.** Que el panorama deje de salir con campos nulos y con desync falso.

**Por qué aquí.** Son defectos ya observados con evidencia en log, no hipótesis. Y son
la diferencia entre publicar un panorama correcto y publicar uno vacío más rápido.

**Alcance, tres frentes con diagnóstico previo obligatorio:**

1. **`data.js`.** Diagnosticar antes de corregir: dónde lo busca el paso 6, si el
   archivo existe en esa ruta, y si cambió de formato. Prohibido "arreglarlo" cambiando
   la ruta a ciegas.
2. **`estado_proyecto` vacío en los 24.** Que fallen todos, sin excepción, apunta a la
   extracción y no a los hermanos. Localizar en qué paso se pierde el campo (32, 33 o
   35) y corregir ahí, no en el consumidor.
3. **Desync por `vNN`.** Sustituir la comparación de `mtime` con margen de un día por
   la comparación entre `sesion_actual` y la `vNN` del traspaso vigente, que es el
   criterio ya validado en el censo. `mtime` produce falsos positivos cada vez que una
   operación de filesystem toca un traspaso, cosa que en una cartera concurrente pasa
   a diario.

**Autotest con control negativo, obligatorio para el frente 3.** Dos casos mínimos:
un hermano sintético con `sesion_actual` menor que su `vNN` debe dar `PULL`; uno con
ambas iguales debe dar `PUSH`. Un detector que marca desync en todo no discrimina.

**Criterio de éxito evaluable.**
1. `.jsonl` de la corrida posterior: cero eventos con `causa` igual a
   `data.js no disponible`.
2. Número de proyectos con `estado_proyecto` no nulo: mayor que cero, y la cifra sale
   del `.jsonl`, no del texto del resumen.
3. Los cuatro hermanos que hoy salen `PULL` por `mtime` (`slep_aprendizajes_ep`,
   `slep_lectoescritura`, `slep_seguimiento_educacion_inicial`, `slep_simce_adecuado`)
   cambian de fuente, o el log declara por qué no.
4. Los dos casos del autotest pasan y quedan registrados en el `.jsonl`.

**Complejidad.** Media-alta, por los diagnósticos previos. **Riesgo.** Bajo: no toca
git ni la red.

---

### E2 — Lectura del esquema v34 y traducción del enum

**Objetivo.** Que el orquestador lea los siete campos nuevos de `ESTADO.md` y los
publique, y que deje de romperse ante vocabulario fuera de enum.

**Por qué aquí.** Es la razón de existir del repo y hoy es su mayor deuda de producto:
SETTINGS v34 declara en su propio encabezado que los campos de candado no se propagan
a la cartera, y 20 de 25 hermanos no tienen ninguno (fuente: §9 del censo). Un panorama
que muestre por hermano si tiene candado convierte una deuda invisible en lista de
trabajo.

**Alcance.**
1. Pasos 32, 33 y 35 leen `sesion_abierta`, `maquina`, `commit_cierre`,
   `traspaso_vigente`, `cierre_incompleto`, `insumos_verificados` y `ventana_insumos`.
2. El extractor de front matter usa la especificación del censo: delimitado por los
   `---`, nunca `grep` sobre el archivo entero.
3. `tipo_pendiente` fuera del enum se **traduce** con una tabla explícita y declarada,
   no se amplía el enum y no se cae. Los tres casos vivos son `funcionalidad`,
   `no_bloqueante` y `verificacion_y_decision_titular`. Cada traducción se emite como
   evento `decision` en el `.jsonl`, con el valor original y el traducido.
4. El panorama muestra, por hermano, el estado de candado y si declara ventana.

**Control negativo obligatorio.** El fixture C7 del censo: un `ESTADO.md` con
`commit_cierre:` en el cuerpo en prosa y no en el front matter debe leerse como
ausente. Si se lee como presente, el extractor está mirando fuera del front matter.

**Criterio de éxito evaluable.**
1. El `.jsonl` reporta, por hermano, `n_candado` entre 0 y 6, y la suma coincide con
   la del censo del 2026-08-24 en los hermanos que no cambiaron entre ambas fechas.
2. Cero eventos `error` por `tipo_pendiente` desconocido; tres eventos `decision` de
   traducción.
3. El control negativo pasa.

**Complejidad.** Alta. **Riesgo.** Bajo.

---

### E3 — Paso 7: cierre de árbol del orquestador

**Objetivo.** Que el pipeline deje su propio repo limpio, commiteado y sincronizado,
sin intervención.

**Dependencia bloqueante.** Antes de este encargo hay que resolver
`20_insumos/registro_proyectos.csv`: está versionado y el paso 1 lo escribe, lo que
choca con el invariante I8 y con POLITICA 1.3 punto 5. Un paso 7 que lo commitee
automáticamente convierte una deuda declarada en un hábito. Las tres salidas
(declararlo excepción por escrito, moverlo a `40_salidas/`, o dejar de versionarlo)
se deciden antes, no dentro de este encargo.

**Alcance.**
1. **Regla de alcance de escritura, estricta:** el paso 7 stagea **solo** rutas de una
   lista blanca declarada en configuración (`40_salidas/`,
   `50_documentacion/estructura/`, y `20_insumos/registro_proyectos.csv` si la decisión
   previa lo mantiene versionado). Nunca `git add -A`. Nunca un archivo de
   `50_documentacion/activa/` ni de `traspasos/`.
2. **Compuerta previa:** si hay cambios fuera de la lista blanca, el paso 7 **no
   commitea nada** y termina en `error` con la lista. Es fail-fast deliberado: un
   árbol sucio por otra razón significa que hay trabajo humano en curso.
3. **Remoto movido:** `fetch` y comparación. Si hay commits por integrar, el paso 7 se
   detiene con instrucción y no mergea. La integración es acto humano.
4. **Push** solo si el commit se creó y las comprobaciones pasan. Verificación
   posterior con `ls-remote`: un commit local no está publicado hasta que el SHA
   remoto coincide.
5. `simular = TRUE` imprime el plan completo (qué stagearía, qué mensaje, a qué rama)
   sin ejecutar nada.

**Criterio de éxito evaluable.**
1. Con el árbol limpio salvo salidas: crea un commit, lo pushea, y el `.jsonl` trae un
   evento `red` con el SHA remoto igual al local.
2. **Control negativo:** con un archivo sucio fuera de la lista blanca, el paso 7
   termina en `error`, no crea commit, y el `.jsonl` nombra el archivo. Este caso es el
   que decide si el encargo se aprueba.
3. Con `simular = TRUE`: `git status` idéntico antes y después, byte a byte.

**Complejidad.** Alta. **Riesgo.** Alto: es el primer encargo que escribe en git de
forma autónoma. Rollback: el paso 7 es opcional y desactivable por parámetro.

---

### E4 — Paso 8: publicación en Cloudflare + Access

**Objetivo.** Publicar `panorama_visual.html` detrás de identidad institucional,
replicando el patrón ya implementado en `slep_reporte_emergencia`.

**Por qué después de E3.** Publicar exige que el artefacto esté commiteado y que se
sepa qué versión se publicó. Sin E3, el sitio y el repo pueden divergir sin que nada
lo note.

**Alcance.**
1. **Leer primero el patrón existente.** Las decisiones de `slep_reporte_emergencia`
   (29 archivos entre 20260715 y 20260722, fuente: §8 del censo) contienen el diseño.
   Este encargo lo replica; no lo rediseña.
2. **Credenciales fuera del repo**, en `.Renviron`, con `.Renviron.example`
   documentando los nombres. Ningún token en el árbol, ningún token en el `.jsonl`.
3. **Verificación posterior real:** tras publicar, comprobar con `curl -sI` que la URL
   responde y que **exige autenticación**. Un 200 sin Access es un fallo de
   gobernanza, no un éxito de publicación.
4. **Convivencia o retiro de GitHub Pages:** decisión declarada en el encargo, no
   implícita. Mientras `pages.yml` siga activo, el HTML sigue público.

**Criterio de éxito evaluable.**
1. El `.jsonl` trae un evento `red` con el código de respuesta y la evidencia de que
   Access intercepta.
2. `grep` de nombres de variables de credencial en el `.jsonl` y en las salidas: cero
   valores, solo nombres.
3. **Control negativo:** una corrida con la credencial ausente termina en `error`
   declarado, no en publicación silenciosa ni en un sitio a medias.

**Complejidad.** Alta. **Riesgo.** Alto, por credenciales y por exposición pública.

---

### E5 — `run_all()` como comando único, idempotente

**Objetivo.** Unificar: un comando, ocho pasos, parámetros `publicar` y `simular`,
resumen final calculado del `.jsonl`.

**Alcance.**
1. Firma final y valores por defecto: `publicar = FALSE`, `simular = FALSE`. La
   publicación es opt-in.
2. **Idempotencia:** dos corridas seguidas sin cambios en el universo producen el mismo
   HTML byte a byte y la segunda no crea commit. Es la propiedad que hace seguro
   ejecutarlo a diario.
3. Un paso que falla detiene los siguientes y el resumen dice cuál y por qué.
4. Documentación técnica del comando en `50_documentacion/activa/`, con el prefijo que
   POLITICA §2 exige.

**Criterio de éxito evaluable.**
1. `run_all(publicar = TRUE)` dos veces seguidas: el segundo `.jsonl` declara `omitido`
   en el paso 7 por ausencia de cambios, y `cmp` del HTML entre ambas da idénticos.
2. Con el paso 3 forzado a fallar: los pasos 4 a 8 no corren y el resumen lo declara.
3. `run_all(simular = TRUE, publicar = TRUE)` no toca git ni la red: `git status`
   idéntico y cero eventos `red` de escritura.

**Complejidad.** Media. **Riesgo.** Medio.

---

### E6 — Prueba de aceptación de extremo a extremo

**Objetivo.** Demostrar, en una sola corrida y con evidencia, que el comando único
cumple lo pedido.

**Alcance.** Un guion de aceptación con seis afirmaciones, cada una verificada contra
el `.jsonl` y el filesystem:

| # | Afirmación | Evidencia |
|---|---|---|
| A1 | Recoge el estado de los 24 hermanos | 24 eventos `item_*` en el paso 2, cero `error` |
| A2 | Ningún hermano fue escrito | `sucio` y `HEAD` de los 24, iguales antes y después |
| A3 | El árbol del orquestador queda limpio | `git status --porcelain` vacío al terminar |
| A4 | Lo publicado es lo commiteado | `sha256` del HTML local igual al servido |
| A5 | El sitio exige autenticación | respuesta de `curl -sI` registrada |
| A6 | La corrida es reproducible | segunda corrida idéntica, sin commit nuevo |

**Criterio de éxito evaluable.** Las seis afirmaciones con su evidencia en el
`.jsonl`, y **A2 medida sobre los 24 hermanos reales**, no sobre una muestra.

**Complejidad.** Media. **Riesgo.** Bajo.

---

## 6. Secuencia y dependencias

```
E0 (arnes)
 └─> E1 (correcciones)  ─┐
 └─> E2 (esquema v34)   ─┴─> E3 (paso 7, git) ──> E4 (paso 8, publicar) ──> E5 (comando unico) ──> E6 (aceptacion)
                                  ^
                                  └── bloqueante: decision sobre registro_proyectos.csv (I8)
```

E1 y E2 son independientes entre sí y pueden ir en cualquier orden, o en paralelo si
hay dos sesiones. Todo lo demás es secuencial.

**Pendientes de la sesión 12 que no entran en esta ruta** y siguen vivos por separado:
ordenación del repositorio (POLITICA 1.3.1, gatillo 4bis), reconstrucción del backlog
55 a 67, reposición de `CLAUDE.md`, guarda de locale vista fallar, y los rescates de
`slep_rendimiento_historico`, `slep_simce_estandares_aprendizaje` y `slep_alertas_ael`.

## 7. Riesgo mayor de la ruta, declarado

El comando único concentra en un solo acto lo que hoy son cuatro decisiones humanas
separadas: qué se commitea, cuándo se pushea, qué se publica y a quién se expone. Esa
concentración es exactamente lo que se pidió y también su riesgo.

Las tres mitigaciones están repartidas por diseño, no agrupadas al final: la lista
blanca de escritura de E3, el fail-fast ante cualquier cosa inesperada, y `simular` en
todos los pasos que escriben. La cuarta mitigación es de gobernanza y no es técnica:
`publicar` es opt-in y por defecto está en `FALSE`.
