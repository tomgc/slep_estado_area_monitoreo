# Verificación del frente A — `data.js`, los tres defectos corregidos

- **Encargo:** A-19 (`20260826_encargo_correccion_frente_a.md`), sesión 13. **Cubre:** O-05.
- **Fuente de premisas:** `20260826_diagnostico_campos_perdidos.md`. Este informe no rediagnostica.
- **Ejecutado:** 2026-08-27. **Archivo de código tocado:** uno,
  `30_procesamiento/36_generar_panorama_visual.R`.
- **Commits:** `7726627` (código), este commit (regeneración de `40_salidas/` + este informe).

---

## 1. Precondición (§2) y línea base (§3)

```
$ git status --porcelain
?? 50_documentacion/andamios/20260826_encargo_correccion_frente_a.md
?? 50_documentacion/andamios/20260826_encargo_diagnostico_a05.md
--- fin status ---
main
0	0
-rw-r--r--@ 1 tomgc  staff  22864 Jul 30 06:55 /Users/tomgc/Projects/slep_monitoreo/docs/data.js
```

Rama `main`, `0	0`, y `data.js` está en `docs/`: la premisa central del diagnóstico se
sostiene hoy. Los dos untracked son los propios encargos de la sesión.

Línea base copiada a `/tmp/base_panorama_visual.{html,md}` y **medida**, no asumida
(recuento programático sobre el JSON embebido en el HTML, `id="datos-cartera"`):

```
archivo: /tmp/base_panorama_visual.html
fichas totales: 24
con tipo: 0
con objetivo: 0
con sintesis: 0
con los tres: 0
```

La cifra esperada era cero y la medición la confirma: 0 de 24.

---

## 2. Los tres cambios aplicados (§5)

| # | Qué se hizo | Dónde |
|---|---|---|
| 1 | `RUTA_DATA_JS_PORTAFOLIO` pasa a `slep_monitoreo/docs/data.js`, con comentario de una línea que data la mudanza en el commit `00a1af3` del hermano | l. 38-40 |
| 2 | El saneador quotea **cualquier** clave a inicio de línea (`^(\s*)([A-Za-z_][A-Za-z0-9_]*)\s*:`) en vez de siete claves fijas | l. 213-219 |
| 3 | `MAPEO_ORDEN_SLUG` (por posición) → `MAPEO_ID_SLUG` (por `id`), con guarda dura de aborto | l. 62-86, 226-235, 340-370 |

Sobre el cambio 1: el archivo **no** definía ninguna constante de raíz del sitio, así que
el valor sigue viviendo en un solo lugar, `RUTA_DATA_JS_PORTAFOLIO`, y no se introdujo una
constante nueva de un solo uso. No se agregó fallback que pruebe ambas rutas (el
diagnóstico lo sugería, el encargo no lo pide): un fallback silencioso habría enmascarado
la próxima mudanza del origen, que es lo que produjo este defecto.

Sobre el cambio 3: `parsear_data_js()` ahora indexa por `id` y **aborta** si una entrada
parsea pero no trae `id`; el reindexado aborta si un `id` no figura en `MAPEO_ID_SLUG` o si
dos entradas reclaman el mismo slug.

---

## 3. El mapeo `id -> slug`, entrada por entrada (§5.3)

Los `id` del origen **no** coinciden con los slug del orquestador, así que el mapeo es
explícito. Los 11 pares aprobados por el titular se conservan intactos: cada uno se
reclavó por el **título literal** con el que fue aprobado, que sigue siendo el comentario
inline de su línea. Ningún par cambió de pareja; lo que cambió es la llave que lo sostiene.

| `id` (origen) | `slug` (orquestador) | Título en `data.js` | Origen del par |
|---|---|---|---|
| `asistencia` | `slep_minuta_asistencia` | Minuta de asistencia mensual | heredado (orden 1) |
| `resguardo` | `slep_reportes_modelo_resguardo_asistencia` | Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio | heredado (orden 2) |
| `simce` | **NA** | Minutas de resultados Simce 2025 del territorio | **nuevo, sin pareja** |
| `estandares` | `slep_simce_adecuado` | Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce | heredado (orden 3) |
| `idps` | `slep_idps` | Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) | heredado (orden 4) |
| `categorias` | `slep_categoria_desempeno` | Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país | heredado (orden 5) |
| `parvularia` | `slep_aprendizajes_ep` | Monitoreo de aprendizajes en la educación parvularia | heredado (orden 6) |
| `inicial` | `slep_seguimiento_educacion_inicial` | Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles | heredado (orden 7) |
| `costapresente` | `slep_costapresente` | CostaPresente | heredado (orden 8) |
| `ael` | `slep_alertas_ael` | Sistema de alertas de Anótate en la Lista | heredado (orden 9) |
| `trayectorias` | `slep_minuta_desvinculacion` | Análisis de trayectorias educativas interrumpidas | heredado (orden 10) |
| `rendimiento` | `slep_rendimiento_historico` | Diagnóstico histórico del rendimiento escolar | heredado (orden 11) |

### La única entrada sin pareja, y por qué se declaró `NA` en vez de abortar

`simce` es el proyecto que el origen insertó en la posición 3 (su propio
`50_catalogo_project_cards.md` lo data en la sesión 8 del hermano). **No tiene repositorio
hermano en la cartera**, y la evidencia contra el candidato más obvio es del propio
titular:

- El candidato sería `slep_simce_estandares_aprendizaje`, pero la nota curada a mano en
  `registro_proyectos.csv` dice, para ese slug: *"No figura en el sitio (antecesor de
  slep_simce_adecuado). Nombre funcional."*
- Además, `slep_dashboard_personal_monitoreo/50_documentacion/activa/decisiones/04_fuentes_por_dominio.md:98`
  describe el proyecto de las tres minutas como *"un segundo «proyecto SIMCE» que
  corresponde a tres minutas hechas a mano. No emite consolidado y queda fuera de scope
  hasta que se automatice"* — es decir, un producto sin pipeline propio.

Emparejarlo con `slep_simce_estandares_aprendizaje` habría sido inventar una pareja que la
curación del titular contradice, y una pareja inventada es exactamente el cruce editorial
que el encargo viene a impedir (A25: salida verde y equivocada). La guarda del §5.3 se
implementó entonces así: **abortar cuando un `id` no figura en la tabla**, y admitir `NA`
como declaración explícita de "entrada editorial sin hermano". `simce` figura en la tabla;
lo que declara es que no tiene pareja. El paso emite advertencia nombrando la entrada:

```
[2026-08-27 06:56:47] [36_visual] [WARN] data.js: la entrada id='simce' esta declarada sin hermano en la cartera; sus campos editoriales no se usan.
```

**Decisión pendiente del titular:** si el proyecto de las tres minutas debe tener ficha en
el panorama, hay que decidir a qué slug corresponde (o crear el hermano) y cambiar ese
`NA`. Mientras tanto la ficha no existe, que es un nulo visible y no un texto plausible en
el lugar equivocado.

---

## 4. Nivel 1 — parseo (§6)

`parse()` + `eval()` selectivo de las definiciones, sin `source()` del script (mismo
aislamiento que usó el diagnóstico):

```
ruta evaluada: /Users/tomgc/Projects/slep_monitoreo/docs/data.js
file.exists: TRUE
entradas parseadas: 12
ids: asistencia, resguardo, simce, estandares, idps, categorias, parvularia, inicial, costapresente, ael, trayectorias, rendimiento
advertencias del parser: 0
campos de la primera entrada: id, orden, tipo, titulo, objetivo, sintesis, estado, imgs
```

**12 de 12, cero advertencias.** Antes: 0 entradas y 12 advertencias `entrada no parseable`
(diagnóstico §2.3).

### Inmunidad a la próxima clave, no solo a `id` (§5.2)

El encargo exige que la corrección sea inmune a la **siguiente** clave nueva. Prueba sobre
un `data.js` sintético con las ocho claves que el propio origen ya declara como "campos a
crear" (`codigo`, `categoria`, `madurez`, `frase`, `problema`, `solucion`, `pasos`, más
`id`), en `slep_monitoreo/50_documentacion/activa/50_catalogo_project_cards.md` §4:

```
entradas parseadas con 8 claves nuevas presentes: 1
claves leidas: id, orden, codigo, categoria, madurez, frase, problema, solucion, tipo, titulo, objetivo, sintesis, pasos, estado, imgs
objetivo intacto: TRUE
sintesis intacta (2 parrafos): TRUE
```

---

## 5. Nivel 2 — poblado (§6)

`run_all(only = 6)` corrió limpio en 0,51 s. Cierre del log:

```
[2026-08-27 06:56:47] [36_visual] [INFO] panorama_visual.html/.md generados: 24 proyectos, 15 con backlog, 24 sin estado_proyecto, 3 sin tipo_pendiente, 4 bug/bloqueante en cabeza, 13 con semaforo (Fase 2 PUSH).
```

Recuento programático sobre la salida nueva, contrastado con la línea base del §3:

| | Línea base (2026-08-24) | Después (2026-08-27) |
|---|---:|---:|
| fichas totales | 24 | 24 |
| con `tipo` | 0 | **11** |
| con `objetivo` | 0 | **11** |
| con `sintesis` | 0 | **11** |
| con los tres | 0 | **11** |

11 y no 12 porque `simce` está declarada sin hermano (§3). 24 − 11 = 13 fichas siguen sin
campos editoriales porque no tienen entrada en el sitio: no es defecto (diagnóstico §5).

---

## 6. Nivel 3 — control negativo de cruce editorial (§6)

### 6.1 `slep_idps` habla de IDPS y no de estándares Simce

```
nombre_real: Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS)
tipo: Motor de comparación
objetivo: Desarrollamos un motor de comparación interactivo que organiza y visualiza los resultados de los Indicadores de Desarrollo Personal y Social (IDPS) de todo el país y desde el inicio de su medición. De esta forma, es posible navegar por los resultados actuales e históricos de un establecimiento, además de explorar uno o múltiples territorios de manera simultánea y comparativa.
menciona IDPS: TRUE | menciona estandares de aprendizaje: FALSE
```

**PASA.** Con el mapeo viejo, esta misma ficha habría recibido el objetivo del motor de
estándares (ver 6.3).

### 6.2 Tres fichas más, elegidas al azar y transcritas

Muestra con `set.seed(20260827)` sobre las 10 fichas pobladas restantes. El contraste es
contra el `nombre_real` del registro, que cura el titular y es independiente de `data.js`.

**`slep_rendimiento_historico`** — nombre_real: *Diagnóstico histórico del rendimiento escolar*; tipo: *Diagnóstico*.
> Diagnóstico longitudinal y multidimensional de las bases de rendimiento escolar del Mineduc (2002-2025) con el propósito de caracterizar las trayectorias educativas de los estudiantes de los establecimientos educacionales del SLEP Costa Central y cuantificar las variaciones en las tasas de promoción y reprobación.

Corresponde: rendimiento escolar histórico, no otro proyecto.

**`slep_aprendizajes_ep`** — nombre_real: *Monitoreo de aprendizajes en la educación parvularia*; tipo: *Monitoreo*.
> Sistema que organiza las evaluaciones realizadas por las educadoras de los jardines infantiles del territorio y los presenta en informes interactivos, segmentados por momento evaluativo y niveles de agrupación que van desde todo el territorio hasta cada párvulo.

Corresponde: párvulos y jardines, no el motor de Categoría de Desempeño que el mapeo viejo
le habría puesto.

**`slep_reportes_modelo_resguardo_asistencia`** — nombre_real: *Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio*; tipo: *Reporte · Directores/as*.
> Dirigido a cada director y directora de los establecimientos del SLEP Costa Central, este reporte entrega información pertinente, oportuna, precisa y accionable sobre la asistencia de su unidad educativa. Tiene una frecuencia mensual e incluye, además de indicadores con distintos grados de segmentación, el detalle de cada estudiante que gatilla una de las alertas definidas como críticas para el resguardo de su trayectoria educativa.

Corresponde: resguardo de asistencia dirigido a directores.

### Cotejo 1:1 de las once, no solo de las cuatro

Además de la inspección a mano, se cotejaron los tres campos de las 11 fichas contra la
entrada de `data.js` que el mapeo les asigna:

```
  slep_minuta_asistencia                     id='asistencia'   tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_reportes_modelo_resguardo_asistencia  id='resguardo'    tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  id='simce' -> declarado sin hermano (no se coteja)
  slep_simce_adecuado                        id='estandares'   tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_idps                                  id='idps'         tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_categoria_desempeno                   id='categorias'   tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_aprendizajes_ep                       id='parvularia'   tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_seguimiento_educacion_inicial         id='inicial'      tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_costapresente                         id='costapresente' tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_alertas_ael                           id='ael'          tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_minuta_desvinculacion                 id='trayectorias' tipo=TRUE  objetivo=TRUE  sintesis=TRUE
  slep_rendimiento_historico                 id='rendimiento'  tipo=TRUE  objetivo=TRUE  sintesis=TRUE
fichas con los tres campos identicos a su entrada de data.js: 11
```

### 6.3 Prueba del desplazamiento (el control decisivo)

Se extrajo `MAPEO_ORDEN_SLUG` **literal de `git show HEAD:...`** (no retecleado) y se aplicó
a los datos de hoy, junto al mapeo nuevo:

| `orden` | `id` | Slug que asigna el mapeo VIEJO | Slug correcto (mapeo nuevo) | ¿Cruza? |
|---:|---|---|---|---|
| 1 | `asistencia` | `slep_minuta_asistencia` | `slep_minuta_asistencia` | no |
| 2 | `resguardo` | `slep_reportes_modelo_resguardo_asistencia` | `slep_reportes_modelo_resguardo_asistencia` | no |
| 3 | `simce` | `slep_simce_adecuado` | (sin hermano) | **sí** |
| 4 | `estandares` | `slep_idps` | `slep_simce_adecuado` | **sí** |
| 5 | `idps` | `slep_categoria_desempeno` | `slep_idps` | **sí** |
| 6 | `categorias` | `slep_aprendizajes_ep` | `slep_categoria_desempeno` | **sí** |
| 7 | `parvularia` | `slep_seguimiento_educacion_inicial` | `slep_aprendizajes_ep` | **sí** |
| 8 | `inicial` | `slep_costapresente` | `slep_seguimiento_educacion_inicial` | **sí** |
| 9 | `costapresente` | `slep_alertas_ael` | `slep_costapresente` | **sí** |
| 10 | `ael` | `slep_minuta_desvinculacion` | `slep_alertas_ael` | **sí** |
| 11 | `trayectorias` | `slep_rendimiento_historico` | `slep_minuta_desvinculacion` | **sí** |
| 12 | `rendimiento` | (sin par en el mapeo viejo) | `slep_rendimiento_historico` | **sí** |

Salida literal del control:

```
entradas cuyo slug cambia entre el mapeo viejo y el nuevo: 10 de 12
entradas que el mapeo viejo deposita en la ficha equivocada: 8

  ficha 'slep_idps' recibiria: "Motor de comparación interactivo de los resultados de los est…"
     (contenido de id='estandares', que corresponde a 'slep_simce_adecuado')
  ficha 'slep_categoria_desempeno' recibiria: "Motor de comparación interactivo de los resultados en los Ind…"
     (contenido de id='idps', que corresponde a 'slep_idps')
  ficha 'slep_aprendizajes_ep' recibiria: "Motor de comparación interactivo de la Categoría de Desempeño…"
     (contenido de id='categorias', que corresponde a 'slep_categoria_desempeno')
  ficha 'slep_seguimiento_educacion_inicial' recibiria: "Monitoreo de aprendizajes en la educación parvularia"
     (contenido de id='parvularia', que corresponde a 'slep_aprendizajes_ep')
  ficha 'slep_costapresente' recibiria: "Análisis longitudinal de preferencias de matrícula de egresad…"
     (contenido de id='inicial', que corresponde a 'slep_seguimiento_educacion_inicial')
  ficha 'slep_alertas_ael' recibiria: "CostaPresente"
     (contenido de id='costapresente', que corresponde a 'slep_costapresente')
  ficha 'slep_minuta_desvinculacion' recibiria: "Sistema de alertas de Anótate en la Lista"
     (contenido de id='ael', que corresponde a 'slep_alertas_ael')
  ficha 'slep_rendimiento_historico' recibiria: "Análisis de trayectorias educativas interrumpidas"
     (contenido de id='trayectorias', que corresponde a 'slep_minuta_desvinculacion')

VEREDICTO: el mapeo viejo SI produce cruce sobre los datos de hoy.
```

**El defecto 3 era real y el diagnóstico no se equivocó.** Nueve fichas habrían mostrado
contenido ajeno (las ocho listadas, más `slep_simce_adecuado`, que habría recibido el
proyecto nuevo de las minutas Simce), y el contenido de `rendimiento` se habría perdido sin
aviso por no tener par. Solo dos de doce entradas sobrevivían intactas.

### 6.4 Las guardas no son decorativas

Controles negativos evaluando el bloque real del script (líneas 345-370), no una copia:

```
(a) id desconocido en data.js ('proyecto_nuevo'):
    ABORTA: 36: data.js trae la entrada id='proyecto_nuevo' ("Proyecto que el sitio agrego ayer") que no figura en MAPEO_ID_SLUG. Declare su pareja en 30_procesamiento/36_generar_panorama_visual.R (slug del hermano, o NA si el sitio publica un proyecto sin repo en la cartera) y reintente.

(b) dos entradas reclamando el mismo slug (MAPEO_ID_SLUG no inyectivo):
    ABORTA: 36: el slug 'slep_simce_adecuado' es reclamado por dos entradas de data.js (la segunda es id='idps'). MAPEO_ID_SLUG tiene que ser inyectivo: dos entradas en la misma ficha se pisan.

(c) entrada sin campo `id` (guarda del parser, sobre un data.js de prueba):
    ABORTA: 36: data.js trae una entrada sin campo `id` (titulo: "Entrada sin id"). `id` es la llave del mapeo id->slug: sin ella la entrada solo podria asignarse adivinando por posicion, que es justo lo que este mapeo evita.

(d) control positivo: los datos reales de hoy no abortan:
    SIN ABORTO | slugs mapeados: 11 | advertencias: 1
```

---

## 7. Qué más cambió en `40_salidas/` y no es de este encargo

Comparación campo a campo contra la línea base. Fuera de `tipo`/`objetivo`/`sintesis` (11
fichas cada uno), cambiaron 11 celdas en tres proyectos:

| Slug | Campos | Causa |
|---|---|---|
| `slep_reportes_modelo_resguardo_asistencia` | `tipo_pendiente`, `fecha_actualizacion`, `proximos_pasos` | su `ESTADO.md` y su traspaso v85 son del 2026-08-26, posteriores a la línea base del 24 |
| `slep_simce_adecuado` | `tipo_pendiente`, `semaforo`, `proximos_pasos` | su `ESTADO.md` y su traspaso v27 son del 2026-08-26 |
| `slep_georreferenciacion` | `semaforo`, `fecha_actualizacion`, `proximos_pasos`, `tiene_backlog`, `resena_itinerario` | **su directorio ya no existe** bajo `~/Projects` |

El conjunto de 24 slug es idéntico antes y después: ninguna ficha apareció ni desapareció.

**Hallazgo lateral, fuera de alcance:** `slep_georreferenciacion` sigue en
`inventario_cartera.json` (compilado el 2026-08-26 09:49) pero su directorio no existe hoy.
El paso 6 degrada sus campos a nulo con gracia, como corresponde, pero la ficha permanece
porque este encargo solo autorizaba `run_all(only = 6)` y el inventario lo compila el paso
4. Una corrida completa del pipeline la retiraría. No se tocó.

---

## 8. Fragilidad que queda en pie (candidata a backlog)

El separador de objetos de `parsear_data_js()` sigue siendo `\{[^{}]*\}`: asume objetos
**planos**. El propio catálogo del origen (`50_catalogo_project_cards.md` §4) propone
agregar `valor: array[{icono, texto}]`, que son objetos anidados. Cuando esa clave llegue,
el separador partirá mal las entradas — el saneador ya no será el eslabón débil, pero el
separador sí. No se corrigió: el encargo cierra el alcance en tres cambios y este defecto
todavía no existe en el origen.

---

## 9. Premisas del encargo que resultaron falsas o incompletas

Van seis encargos con premisas corregidas en la ejecución. Este es el séptimo, y también
tiene:

1. **§5.1 supone que puede existir "una constante de raíz del sitio" en el archivo.** No
   existe: la única constante es `RUTA_DATA_JS_PORTAFOLIO` misma. La instrucción se cumplió
   por su intención (un valor en un solo lugar) sin crear una constante nueva de un solo uso.

2. **§5.3 supone que todo `id` del origen tiene un `slug` que encontrar.** `simce` no lo
   tiene: es un proyecto que el sitio publica y que la cartera no tiene como repositorio.
   La guarda "aborta si una entrada no encuentra su slug", leída literalmente, dejaría el
   paso 6 inejecutable hasta que exista un hermano que quizá nunca exista. Se implementó
   la guarda contra lo que el encargo quiere impedir — la **omisión silenciosa** — y no
   contra la ausencia declarada: un `id` fuera de la tabla aborta; un `id` en la tabla con
   valor `NA` es una decisión visible, con advertencia nombrada en el log y declarada en el
   §3 de este informe.

3. **§1 dice que el defecto 3, corregido solo, produce "cada proyecto muestra el contenido
   editorial de otro".** Es casi exacto y conviene precisarlo: son 9 de 12; dos entradas
   (`asistencia`, `resguardo`) caían en su lugar correcto porque están antes del punto de
   inserción, y una (`rendimiento`) se habría perdido en silencio en vez de cruzarse. El
   diagnóstico §2.4 ya lo mostraba así; el encargo lo redondeó.

4. **§7 pide que el segundo commit contenga la regeneración de `40_salidas/`.** Se cumple,
   con la salvedad del §7 de este informe: parte de esa regeneración no viene de la
   corrección sino de la deriva documental de tres hermanos entre el 24 y el 27 de agosto.
   Un lector que atribuya todo el diff a este encargo se equivocaría.

**Lo que no se tocó, deliberadamente.** `estado_proyecto` (frente B), por instrucción
explícita del §8 del encargo. `registro_proyectos.csv`, que es curación del titular; su
nota para `slep_simce_estandares_aprendizaje` ("No figura en el sitio") sigue siendo
correcta bajo la lectura de este informe, pero conviene releerla cuando se decida qué
hacer con `simce`. Y `CLAUDE.md`, cuya sección "Últimos cambios" queda sin actualizar
porque el §4 del encargo cierra el alcance de escritura en tres rutas y esa no es una:
queda como pendiente del cierre de sesión.
