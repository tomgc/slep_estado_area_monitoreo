# Log de encargo autónomo — Verificación de apertura, sesión 14 (A-22)

Fecha: 2026-08-27. Repo: `slep_estado_proyectos_monitoreo` (orquestador).
Encargo: `50_documentacion/andamios/20260827_encargo_apertura_v14.md`.
Contrato: `encargo_autonomo_claude_code_v1.md` v1.3. Modo autónomo, secuencial,
un turno. Subagentes usados: 0 (tope duro del encargo: 0). Panel adversarial:
no aplica (§3 del contrato, encargo de lectura).

## 1. Resumen de la sesión

Entró la cadena FASE 0 → T1..T7. Se ejecutaron FASE 0, T1, T2, T3, T4a, T5 y
T6 completas. **T4b (merge) y T7 (apertura del candado) quedaron congeladas**
por dos condiciones medidas, ambas previstas por §1.1 del encargo:

- §1.1.2: `git status --porcelain` devolvió una línea al empezar (el propio
  archivo del encargo, untracked) → congela T7.
- §1.1.6: el PR #4 mide `mergeable: CONFLICTING` / `mergeStateStatus: DIRTY`
  → congela T4b. Como T7 depende de T4b (§5 del grafo), T7 queda congelada
  también por esta segunda vía, independiente de la primera.

Estado final: **cero escrituras en el repositorio salvo este log**. `ESTADO.md`
intacto, sin commits, sin push, sin merge, sin cambios de rama. La sesión 14
sigue formalmente cerrada.

Resultado más relevante: **cuatro de las siete premisas del §2 del encargo son
falsas al medirlas** (detalle en §9 de este log), incluida la que motivaba la
meta de T3 y la que describía el defecto O-38.

## 2. Inventario de commits

Ninguno. No se autorizó ni se ejecutó ningún commit: la única edición
autorizada (`ESTADO.md`, tres campos) pertenecía a T7, que quedó congelada.
Este log se deja **sin commitear** para revisión previa, según §6 del encargo.

`main` local y `origin/main` en `6174655`, idénticos antes y después de la
sesión.

## 3. Por cada cambio sustantivo

No hubo cambios sustantivos: el encargo es de lectura y sus dos tareas de
escritura quedaron congeladas por condición medida. Lo producido son
mediciones, listadas en §4.

## 4. Auditoría de diagnóstico

### 4.1 FASE 0 — medición de premisas

| # | Medición | Resultado | Veredicto |
|---|---|---|---|
| 0.1 | `rev-parse --show-toplevel` | ruta del proyecto | OK |
| 0.2 | rama activa | `main` | OK |
| 0.3 | `status --porcelain` | `?? 50_documentacion/andamios/20260827_encargo_apertura_v14.md` | **NO VACÍO → congela T7** |
| 0.4 | `fetch --all --prune`; `origin/main..HEAD`; `HEAD..origin/main` | ambas vacías | OK, sincronizado |
| 0.5 | `branch -r --contains 8213560` y `ec21563` | ambos en `origin/main` | premisa confirmada |
| 0.6 | rutas de insumos | 2 de 3 en su ruta; `estructura_actual.md` **no** está en `activa/` | premisa falsa (P-6) |

### 4.2 T1 — candado 0bis (SETTINGS §1.2.2)

| Comprobación | Salida literal | Veredicto |
|---|---|---|
| `sesion_abierta` | `sesion_abierta: false` | verde |
| `cierre_incompleto` | `cierre_incompleto: PR #4 (rama ordenacion/20260826) abierto sin mergear; el marcador 4bis y el fix del escaner viven solo en la rama, asi que el gatillo se enciende en la apertura siguiente` | **ROJO** |
| `commit_cierre` ancestro | `commit_cierre declarado: 88394ad` → `0bis-3: PASA (ancestro)` | verde |
| árbol limpio | `?? 50_documentacion/andamios/20260827_encargo_apertura_v14.md` | **ROJO** |

**Veredicto de 0bis: FALLA.** Dos rojos de cuatro.

**Calibración del instrumento (exigida por el encargo).** El caso malo conocido
(`cierre_incompleto`) disparó; el caso bueno conocido (`commit_cierre` ancestro)
calló. Los veredictos difieren, luego **el instrumento discrimina**. No se da la
patología que el encargo pedía reportar.

**I9 / `ventana_insumos`.** Línea 16: `ventana_insumos: ./40_salidas`. Una sola
entrada; resuelve a directorio existente con 21 archivos → **resuelve con
contenido**. I9 **PASA** (precedencia, no conjunción). Ninguna entrada quedó sin
resolver.

**Contraste con la tabla de insumos del traspaso v13.** El traspaso v13 **no
contiene** una tabla de insumos declarados: lo más cercano es §1 "Archivos
principales modificados" y §4.7, que registra que `ventana_insumos` fue corregida
en el commit `fee9c63` porque describía el mundo anterior a D-01. No hay fecha
discrepante que declarar. `insumos_verificados: 2026-08-27` coincide con la fecha
de cierre declarada en el traspaso v13 §1 y con la fecha de esta corrida.

### 4.3 T2 — gatillos 4bis y 4ter

| Gatillo | Archivo marcador | En `main` | En la rama | Evidencia numérica |
|---|---|---|---|---|
| 4bis, ordenación | `50_documentacion/activa/50_ordenacion_repositorio.md` | **NO** (ni en disco ni en `ls-tree origin/main`) | sí, en `origin/ordenacion/20260826` | `traspasos/*.md` = **1** |
| 4ter, locale UTF-8 | `50_documentacion/activa/50_locale_utf8.md` | **SÍ** (2111 bytes) | — | `grep -rl asegurar_locale_utf8 10_utils` = **3** |

**4bis SE ENCIENDE** (el marcador vive solo en la rama del PR #4, exactamente
como lo anticipó `cierre_incompleto`). **4ter NO se enciende.**

`estructura_actual.md`: ruta real `50_documentacion/estructura/estructura_actual.md`
(**no** `activa/`, como declaraba §1 del encargo). Fecha de corrida declarada en
su cabecera: **2026-08-27 09:54:03**. `wc -l` = **176**. Directorios 19, archivos
120, 2.22M. No se re-corrió el escáner (T2 es de lectura).

**Desfase declarado del escáner (hallazgo residual, §1.1.10).** Su árbol precede
por segundos a la escritura del paquete de cierre v13: lista
`traspasos/traspaso_cierre_v12.md` en el nivel superior (hoy rotado a
`traspasos/archivo/`), `backlog_acumulativo.md` en 25K (hoy 28K),
`ESTADO.md` en 1.61K (hoy 1.67K), y no lista
`20260826_pendientes_ruta_e_itinerario.md` (mtime 10:00, posterior a la corrida).
No es un defecto del escáner: es un snapshot honesto de las 09:54:03.

### 4.4 T3 — cacería del inventario de pendientes

**Veredicto: `existe_en 50_documentacion/andamios/20260826_pendientes_ruta_e_itinerario.md`,
en `main` y en `origin/main`.**

| Paso | Resultado |
|---|---|
| 1. disco, todo el repo | **encontrado**, junto con el control positivo |
| 2. disco, fuera del repo | sin coincidencias |
| 3. historial, todas las ramas | agregado por `6174655` (2026-08-27), `docs(andamios): inventario de pendientes, ruta e itinerario citado por el traspaso v13` |
| 4. índice por rama | presente en `main`, `origin`, `origin/main`; ausente en las otras 8 refs |
| 5. stash / reflog | stash vacío; reflog confirma `6174655` como último commit |
| 6. `_archivo/` | **no existe** en el working tree de `main` |
| 7. objetos sueltos | 4 dangling commits, 3 dangling trees; ninguno relevante |

**Control positivo (§2.6).** `20260824_pendientes_y_encargos.md` fue hallado por
los pasos 1, 3 y 4 (agregado por `2ac0c78`, 2026-08-26). **El instrumento no está
ciego**; su calibración pasa y la ausencia habría sido reportable si se hubiera
dado. No se dio.

Metadatos del archivo: 12453 bytes, 214 líneas, trackeado, mtime 2026-08-27 10:00.
Contiene las seis secciones que el traspaso v13 §11 le atribuye, incluido el
itinerario A-03 / A-06 / A-20 / A-21 / A-10..A-16.

### 4.5 T4a — diagnóstico del PR #4

Identidad derivada de su fuente: `git remote get-url origin` →
`https://github.com/tomgc/slep_estado_area_monitoreo.git`.

| Campo | Valor |
|---|---|
| `number` / `state` | 4 / `OPEN` |
| `baseRefName` / `headRefName` | `main` / `ordenacion/20260826` |
| `mergeable` | **`CONFLICTING`** (`gh api`: `false`) |
| `mergeStateStatus` | **`DIRTY`** (`gh api`: `dirty`) |
| `head_sha` | `f4449905c089240cb886585290b00a36dce1578b` |
| `commits` | 4 según GitHub; 3 según `origin/main..origin/ordenacion/20260826` |

Los tres commits `5c90656`, `283d19d`, `f444990` son **alcanzables** desde
`origin/ordenacion/20260826`. El cuarto que GitHub cuenta, `2555234`, **ya está
integrado en `origin/main`** (es la base de la rama), lo que explica la
diferencia 4 vs 3.

La primera consulta devolvió `UNKNOWN` en ambos campos (mergeabilidad aún no
computada por GitHub); tres consultas posteriores y una segunda fuente
(`gh api`) coincidieron en `CONFLICTING`/`dirty`.

**Causa del conflicto, derivada solo con lectura.** Base de fusión: `2555234`.
Intersección de archivos tocados por ambos lados:

| Archivo | Lado `main` | Lado rama | Efecto |
|---|---|---|---|
| `50_documentacion/estructura/estructura_actual.md` | M | M | **conflicto de contenido** |
| `50_documentacion/estructura/estructura_actual.txt` | M | M | **conflicto de contenido** |
| `50_documentacion/estructura/20260824_083051_estructura.md` | D | D | resuelve solo |
| `50_documentacion/estructura/20260824_083051_estructura.txt` | D | D | resuelve solo |

El conflicto es **íntegramente la rotación de snapshots del escáner**: `main`
escribió la corrida de las 09:54:03 y la rama la de las 09:00:29 sobre el mismo
par de archivos "actual". Ningún archivo de código, ni el marcador 4bis, ni el
fix del escáner están en conflicto.

Se confirma además la premisa de `_archivo/`: la rama mueve
`esbozo_fase2_estado_estandarizado.md` y `reporte_cobertura_documental.md` a
`_archivo/20260826/...` como renombres `R100` (conservan versionado pese a
`.gitignore:17`).

### 4.6 T5 — capas del backlog acumulativo

`backlog_acumulativo.md`: **378 líneas**, 28735 bytes.

| Bloque | Líneas |
|---|---|
| Objetivo del proyecto (permanente) | 18–38 |
| Nota metodológica (permanente) | 39–48 |
| Clasificación temática | 49–75 |
| Resumen estadístico por sesión | 76–94 |
| Detalle cronológico (completo) | 95–334 |
| Detalle cronológico, sesión 13 | 308–334 |
| Delta del backlog | 335–378 |

**Cuadratura.** Recuento programático del detalle cronológico: **82** entradas
numeradas presentes (rango 1–89 con el tramo **55–61 ausente**, exactamente las
siete declaradas perdidas). Sesión 13: **12** entradas (78–89). La Clasificación
temática declara `| **Total** | **89** |` (línea 68) y el Resumen estadístico
declara `**89** (82 conservadas, 7 perdidas)` (línea 93). 82 + 7 = 89.
**CUADRA.** La contradicción E13-09 no se reproduce.

Un falso positivo detectado y excluido del recuento: la línea 295,
`0304334. [codigo]`, es un hash de commit, no una entrada. El recuento depurado
(`^[0-9]{1,3}\. `) da 82 tanto por `grep` como por `awk` independiente.

### 4.7 T6 — O-38 medido en origen

**Universo, doble conteo independiente.** 27 directorios `/Users/tomgc/Projects/slep_*`.
Con `50_documentacion/activa/ESTADO.md`: **`find` = 23, bucle `test -f` = 23**.
**CONCUERDAN**, y `diff` de los dos conjuntos es vacío. T6 no se congela.
Sin ESTADO.md (4): `slep_minuta_desvinculacion`, `slep_minuta_matricula`,
`slep_resena_proyectos`, `slep_territorio_costa_central`. Ningún ESTADO.md
resultó ilegible.

**Tabla por hermano** (front matter únicamente, hasta el segundo `---`; el
falso positivo C7 no aplica):

| repo | tiene_ESTADO | semaforo_presente | semaforo_valor | estado_proyecto_presente | datos_sensibles_presente |
|---|---|---|---|---|---|
| slep_alertas_ael | si | si | activo | no | no |
| slep_aprendizajes_ep | si | si | activo | no | no |
| slep_categoria_desempeno | si | si | activo | no | no |
| slep_costapresente | si | si | activo | no | no |
| slep_dashboard_personal_monitoreo | si | si | activo | no | no |
| slep_estado_proyectos_monitoreo | si | si | activo | no | no |
| slep_estudio_oferta_demanda | si | si | activo | no | no |
| slep_gestion_solicitudes_compras | si | si | activo | no | no |
| slep_idps | si | si | activo | no | no |
| slep_lectoescritura | si | si | activo | no | no |
| slep_minuta_asistencia | si | si | activo | no | no |
| slep_minuta_buenas_senales | si | si | activo | no | no |
| slep_minuta_desvinculacion | no | - | - | - | - |
| slep_minuta_matricula | no | - | - | - | - |
| slep_monitoreo | si | si | activo | no | no |
| slep_normativa_convivencia | si | si | activo | no | no |
| slep_observatorio_medios | si | si | activo | no | no |
| slep_paes | si | si | activo | no | no |
| slep_rendimiento_historico | si | si | activo | no | no |
| slep_reporte_emergencia | si | si | **amarillo** | no | no |
| slep_reportes_modelo_resguardo_asistencia | si | si | activo | no | no |
| slep_resena_proyectos | no | - | - | - | - |
| slep_seguimiento_educacion_inicial | si | si | activo | no | no |
| slep_servicio_educativo_regional | si | si | activo | no | no |
| slep_simce_adecuado | si | si | activo | no | no |
| slep_simce_estandares_aprendizaje | si | si | activo | no | no |
| slep_territorio_costa_central | no | - | - | - | - |

**23 de 23 `ESTADO.md` traen `semaforo` con valor. 0 de 23 traen
`estado_proyecto`. 0 de 23 traen `datos_sensibles`.** (El campo de sensibilidad
que sí existe en 22 de ellos se llama `maneja_sensibles`, no `datos_sensibles`.)

**Traza del campo `semaforo`** (archivo:línea, sin corrección alguna):

| Punto | Ubicación |
|---|---|
| Lectura, camino primario | `30_procesamiento/36_generar_panorama_visual.R:329` (`sem <- est$meta$semaforo`), dentro de `leer_estado_hermano()` definida en `:318` |
| **Compuerta primaria** | `:332` — `if (isTRUE(est$sincronizado) && !is.null(sem) && nzchar(sem)) sem else NA_character_` |
| Lectura, camino de respaldo | `:359` (`sem <- meta$semaforo`) tras `parsear_front_matter()` en `:345` |
| **Compuerta de respaldo** | `:362`, con `sinc` calculado en `:353` a partir de `ultima_actividad` vs. `mtime` del traspaso y `MARGEN_DESYNC_DIAS` |
| Almacenamiento | `:461` — `semaforo_hno <- if (is.null(eh)) NA_character_ else o_null(eh$semaforo)`; colección `estados_hno` construida desde `:432` |
| **Entrada al JSON de la ficha** | `:489` — `semaforo = semaforo_hno`, dentro de `construir_objeto()` |
| Render markdown | `:1028` vía `et_semaforo()` (`:1017`) |
| Render JS / UI | `:822`, `:824`, `:796`, `:953` |
| Producto distinto (`panorama.md`) | `30_procesamiento/35_compilar_panorama.R:91-92`, `:102`, `:159` |
| Regla de sincronía de origen | `30_procesamiento/32_localizar_documentos.R:176-196` |
| Constantes | `10_utils/10_configuracion.R:66` (`DIAS_OBSOLETO <- 21L`), `:75` (`MARGEN_DESYNC_DIAS <- 1L`), `:87` (`TZ_ORQUESTADOR`) |

`estado_proyecto` y `datos_sensibles` **no vienen de `ESTADO.md`**: se leen del
registro curado a mano, en `36_generar_panorama_visual.R:478-479`
(`if (tiene_rg) o_null(rg$datos_sensibles) else NA_character_`). El registro
`40_salidas/registro_proyectos.csv` **sí tiene ambas columnas** (posiciones 6 y 7
de la cabecera) pero, sobre 25 filas, `datos_sensibles` tiene valor en **1** y
`estado_proyecto` en **0**; el resto son `NA` literales. Coincide con el
comentario de `30_procesamiento/31_descubrir_proyectos.R:52`.

**Cruce ficha por ficha contra la salida publicada** (`40_salidas/panorama_visual.html`
y `.md`, generados 2026-08-27 07:39; 24 fichas):

| Diagnóstico | N | Slugs |
|---|---|---|
| `semaforo` llega bien | **13** | reportes_modelo_resguardo_asistencia, categoria_desempeno, minuta_asistencia, gestion_solicitudes_compras, monitoreo, simce_adecuado, rendimiento_historico, dashboard_personal_monitoreo, estudio_oferta_demanda, minuta_buenas_senales, alertas_ael, simce_estandares_aprendizaje, observatorio_medios |
| **`semaforo` con valor en origen y `null` en la ficha** | **7** | aprendizajes_ep, lectoescritura, costapresente, idps, paes, seguimiento_educacion_inicial, reporte_emergencia |
| `null` sin origen (sin ESTADO.md) | 4 | georreferenciacion, minuta_desvinculacion, minuta_matricula, resena_proyectos |

`estado_proyecto`: **24 de 24 `null`**. `datos_sensibles`: **23 de 24 `null`**,
uno con `"FALSE"`.

**Veredicto de la duda 2 del traspaso v13: MIXTO**, con la cuenta de cada lado:

- **`semaforo` → `defecto_de_extraccion`.** 23/23 orígenes traen el campo con
  valor; 7 fichas lo pierden en el pipeline y 13 lo conservan. No es una columna
  sin curar: el dato existe en origen y se descarta en tránsito.
- **`estado_proyecto` → `columna_sin_curar`.** 0/23 en `ESTADO.md` y 0/25 en el
  registro, que es su fuente real.
- **`datos_sensibles` → `columna_sin_curar`.** 0/23 en `ESTADO.md` y 1/25 en el
  registro.

**Mecanismo de la pérdida de `semaforo`: hipótesis con evidencia, no hecho
establecido.** Reconstruyendo la compuerta `sinc` de `:353` con
`MARGEN_DESYNC_DIAS = 1` sobre `ultima_actividad` del front matter y el `mtime`
del traspaso más reciente de cada hermano, la reconstrucción marca desincronizados
**exactamente los 7** que pierden el campo (recall 7/7), pero también marca
`slep_minuta_buenas_senales`, que **sí** conserva `activo` en la ficha (1 falso
positivo). La divergencia es esperable: mi reconstrucción toma el traspaso más
reciente por `mtime` actual, mientras el pipeline usa el `ruta_traspaso` que le
entregó el paso 32 en la corrida de las 07:39. **No se propuso ni aplicó
corrección alguna**, conforme al traspaso v13 §12 y al encargo.

**Hallazgo residual (§1.1.10): cobertura del panorama.** 24 fichas contra 26
hermanos en disco. `slep_georreferenciacion` aparece como ficha **sin existir en
disco** (fantasma). `slep_normativa_convivencia`, `slep_servicio_educativo_regional`
y `slep_territorio_costa_central` existen en disco y **no tienen ficha**. Los dos
primeros tienen `ESTADO.md` con `semaforo: activo`. Esto es anterior e
independiente de O-38 y no estaba en el encargo.

## 5. Bugs encontrados y resueltos

Ninguno resuelto: la sesión no tocó código. Los defectos **medidos** son O-38
(§4.7), el conflicto del PR #4 (§4.5) y la cobertura del panorama (§4.7, final).

## 6. Verificación de invariantes (🔒)

| Invariante | Veredicto | Evidencia |
|---|---|---|
| Normativos no versionados, no agregados ni editados | **PASA** | sin escrituras; `git status` sólo lista el encargo untracked, `ls-files --others` idem |
| Instrumento del censo congelado | **PASA** | no se leyó para ejecutar ni se modificó; `diff-index --quiet HEAD` sin cambios trackeados |
| Ningún archivo nuevo en `_archivo/` | **PASA** | `_archivo/` ni siquiera existe en el working tree de `main` |
| No modificar instrumento de cierre ni SETTINGS | **PASA** | ninguna escritura fuera de este log |
| Ninguna escritura en hermanos `slep_*` | **PASA** | sólo `find`, `test -f`, `awk`, `sed`, `date -r` de lectura |
| Sin `push --force` ni descarte de commits ajenos | **PASA** | cero comandos de escritura en git |

Gobernanza de datos: ninguna salida de esta sesión contiene RUT, nombres de
personas, nombres reales de establecimientos ni datos de la Agencia de Calidad.
Las únicas rutas absolutas que aparecen son las del propio encargo.

## 7. Decisiones del usuario registradas en gates

Ninguna. La sesión corrió en un turno sin gates: las dos compuertas del encargo
(T4b y T7) se resolvieron por medición en negativo, no por decisión del titular.

## 7bis. Decisiones autónomas

1. **Re-consultar `mergeable` tras el primer `UNKNOWN`** (3 reintentos + segunda
   fuente `gh api`). Alternativa descartada: congelar T4b con el primer
   `UNKNOWN`, que habría sido un artefacto del cómputo diferido de GitHub y no un
   hecho del PR. **Reversible** (sólo lectura; `gh pr view` está autorizado).
2. **Diagnosticar la causa del conflicto del PR #4 con `merge-base` + `diff
   --name-only` en vez de `git merge-tree`.** Alternativa descartada:
   `merge-tree --write-tree`, que escribe objetos sueltos en la base de datos de
   git y excede la autorización "lectura de cualquier archivo". **Reversible**
   (no se ejecutó la alternativa).
3. **Medir también `maneja_sensibles`** además del `datos_sensibles` que pedía la
   tabla, al constatar que ninguno de los 23 orígenes usa el nombre pedido.
   Alternativa descartada: reportar sólo la columna vacía sin explicar por qué.
   **Reversible** (columna extra en la tabla, marcada como extra).
4. **Medir la compuerta `sinc` sobre los 7 hermanos que pierden `semaforo`.**
   Excede la letra de T6.3 (que pide sólo archivo y línea) pero es lectura pura y
   es lo que sostiene el veredicto `defecto_de_extraccion`. Se reporta como
   **hipótesis con su falso positivo declarado**, no como hecho. **Reversible**.
5. **No commitear el archivo del encargo para limpiar el árbol y habilitar T7.**
   Alternativa descartada: `git add` + commit del encargo. **Descartada por
   diseño**: la lista de autorizaciones de §1.2 es cerrada y sólo admite un
   commit de la edición de `ESTADO.md`. La detención §1.1.2 es del titular
   resolverla, no mía. **Reversible** (nada se hizo).

## 8. Dudas y pendientes abiertos

**D-14-1 — Árbol sucio por el propio encargo.**
Contexto: el único elemento untracked es `50_documentacion/andamios/20260827_encargo_apertura_v14.md`,
el archivo del encargo, y su presencia dispara §1.1.2 y bloquea la condición
"`git status --porcelain` vacío" de §1.2.
Pregunta cerrada: **¿autorizas commitear el archivo del encargo a `main` para
despejar la precondición, o prefieres que el árbol se limpie de otro modo antes
de reintentar T7?**
Bloqueó: T7 (vía §1.1.2) y la sexta condición de T4b.

**D-14-2 — PR #4 en conflicto.**
Contexto: `mergeable: CONFLICTING`; el conflicto es exclusivamente
`50_documentacion/estructura/estructura_actual.{md,txt}`, dos snapshots del
escáner escritos el mismo día con una hora de diferencia (09:00:29 en la rama,
09:54:03 en `main`).
Pregunta cerrada: **¿resuelvo el conflicto tomando la versión de `main` (la
corrida más reciente, 09:54:03) y descartando la de la rama, o esa resolución
exige un encargo propio con su propia autorización?**
Bloqueó: T4b y, por dependencia, T7.

**D-14-3 — Cobertura del panorama (fuera del encargo).**
Contexto: 24 fichas contra 26 hermanos; `slep_georreferenciacion` es una ficha
sin directorio en disco, y `slep_normativa_convivencia`,
`slep_servicio_educativo_regional` y `slep_territorio_costa_central` son
directorios sin ficha. Los dos primeros omitidos tienen `ESTADO.md` con
`semaforo: activo`.
Pregunta cerrada: **¿esta desalineación es un pendiente nuevo del backlog, o ya
está cubierta por un pendiente existente (P3 / la curación del registro A-21)?**
Bloqueó: nada de este encargo.

**D-14-4 — `estructura_actual.md` fuera de la ruta que declara el encargo.**
Contexto: §1 del encargo la sitúa en `50_documentacion/activa/`; su ruta real es
`50_documentacion/estructura/`, que es la que documenta `CLAUDE.md` §8.
Pregunta cerrada: **¿corrijo la ruta en la plantilla de encargos para que el
próximo no herede el error?**
Bloqueó: nada (se resolvió midiendo).

Sin marcas `# REVISAR`: no se tocó código.

## 9. Estado de cifras/datos críticos

**Lo intocable, intacto.** `main` local y `origin/main` en `6174655` antes y
después. `git diff-index --quiet HEAD` sin cambios trackeados. `ESTADO.md` sin
editar: sigue con `sesion_abierta: false`, `cierre_incompleto` en rojo y
`commit_cierre: 88394ad`.

**Premisas del §2 del encargo que resultaron FALSAS, una por una:**

1. **«`20260826_pendientes_ruta_e_itinerario.md` no existe en esa ruta, y el
   único archivo de pendientes en `andamios/` es `20260824_pendientes_y_encargos.md`.»**
   **FALSA.** El archivo existe en esa ruta exacta, trackeado, 214 líneas,
   agregado por el commit `6174655` de hoy — que es la cabeza de `main` y por
   tanto anterior a esta corrida. El `test -f` del titular se ejecutó antes de
   ese commit. La meta propia de T3 quedó sin objeto: **el inventario de
   pendientes de la sesión 14 no se perdió y no hay que reconstruirlo.**
2. **«`semaforo`, `estado_proyecto` y `datos_sensibles` llegan nulos a las fichas
   del panorama publicado.»** **FALSA para `semaforo`**: 13 de 24 fichas lo
   traen poblado y sólo 11 son `null`, de los cuales 4 no tienen origen. La
   pérdida real es de **7 fichas**, no de todas. Cierta para `estado_proyecto`
   (24/24 `null`) y prácticamente cierta para `datos_sensibles` (23/24).
3. **«`estructura_actual.md` está en `50_documentacion/activa/`»** (tabla de
   INSUMOS de §1). **FALSA.** Está en `50_documentacion/estructura/`.
4. **«`cierre_incompleto` está en rojo declarando el PR #4 sin mergear»**
   (marcada como hipótesis). **VERDADERA**, confirmada literalmente.
5. **«`commit_cierre` apunta a `88394ad`»**. **VERDADERA**, y es ancestro de
   `origin/main` por dos métodos.
6. **«El cierre v13 publicó `8213560` y `ec21563`»**. **VERDADERA**, ambos en
   `origin/main`. Incompleta en un punto: `main` avanzó además a `6174655`
   después de esos dos, dato que el encargo no contemplaba.
7. **«`_archivo/` está ignorado en `.gitignore:17`»**. **VERDADERA**
   (`.gitignore:17` es `_archivo/`), con la precisión de que el directorio **no
   existe** en el working tree de `main`; sólo existe en la rama del PR #4, y
   allí como destino de dos renombres `R100` que conservan versionado.

**Re-derivación de auto-auditoría (§6 del encargo), cada resultado con un
comando distinto del que lo produjo:**

| Resultado | Método original | Método de contraste | ¿Concuerda? |
|---|---|---|---|
| `88394ad` ancestro | `merge-base --is-ancestor` | `rev-list origin/main \| grep` → 1 | sí |
| Inventario existe | `find` / `ls-tree` | `git cat-file -e origin/main:<ruta>` + `stat` | sí |
| 82 entradas de backlog | `grep -cE` sobre rango `sed` | `awk` con delimitadores de sección | sí (82 y 12) |
| 23 orígenes con `semaforo` | `awk` de front matter | `sed -n "2,/^---$/p"` | sí (23/23) |
| 13 con valor en la salida | `grep -o` sobre el `.html` | `awk` sobre el `.md` | sí (24 / 11 / 13) |
| Árbol sucio | `status --porcelain` | `diff-index --quiet` + `ls-files --others` | sí |
| PR #4 conflictivo | `gh pr view` | `gh api` + `merge-base`/`diff --name-only` | sí |
| Universo de hermanos | `find` | bucle `test -f` | sí (23 = 23) |

## 10. Notas para el revisor

1. **Mirar primero D-14-1.** T7 está bloqueada por el propio archivo del encargo.
   Es la fricción más barata de resolver y desbloquea la mitad del pendiente.
2. **El veredicto de O-38 cambia la ruta.** `semaforo` **no** es una columna sin
   curar: es un descarte por compuerta de desincronización que afecta a 7
   hermanos cuyos `ESTADO.md` están más viejos que su traspaso. La pregunta de
   diseño que sigue no es "cómo extraer el campo" sino "**debe un `ESTADO.md`
   desincronizado ocultar su semáforo, o basta con marcarlo como
   desactualizado?**". Esa decisión es del titular y no la tomé.
3. **Auditar con ojo crítico mi reconstrucción de `sinc`** (§4.7, final):
   reproduce 7/7 las pérdidas pero genera 1 falso positivo. La reconstrucción es
   una aproximación desde fuera del pipeline; la medición autoritativa exige
   correr el paso 32 y leer su `log_msg`, que esta sesión no tenía autorizado.
4. **El escáner está desfasado por segundos**, no por días (§4.3). Si se re-corre,
   el conflicto del PR #4 empeora en vez de mejorar: `estructura_actual.{md,txt}`
   es justamente el par en conflicto.
5. **Qué costó.** Un tropiezo real: el shell del entorno resultó ser **zsh**, no
   bash, y una comparación de fechas con `[ "$a" \< "$b" ]` falló con
   `condition expected: <`. Se rehízo toda esa medición bajo `bash -c` explícito
   (bash 3.2.57), tal como exigía la sección POSICIÓN del encargo, que yo había
   cumplido sólo por accidente en los comandos anteriores (eran POSIX puros). Un
   segundo tropiezo menor: un `comm -23 <(seq 1 $max)` se disparó a 1.9 MB de
   salida porque el máximo se contaminó con el hash `0304334` de la línea 295;
   se acotó el patrón a `^[0-9]{1,3}\. ` y se declaró el falso positivo.
