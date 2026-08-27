# Encargo A-23 — Ruta aprobada de la sesión 14 (P0 a P3)

> Encargo autónomo dirigido por meta (`encargo_autonomo_claude_code_v1.md` v1.3).
> **Meta:** cerrar el candado 0bis, corregir O-38 en su causa (no en su síntoma),
> instalar el contrato con la cartera que convierte las asimetrías mudas en errores
> nombrados, y resolver la duda 1 con un control positivo real del censo.

---

## 1. Encabezado de contrato

**Modo y disciplina.** Modo autónomo, secuencial, todo en este turno. Aprobada la
ruta, no se confirman pasos mecánicos: encadena.

**Subagentes: tope duro 3.** Se admiten solo para los tres usos declarados en §6, y
**todos de solo lectura**: ningún subagente escribe, commitea, pushea ni modifica el
árbol. La escritura la hace el hilo principal, secuencialmente.

**ENTORNO.** Filesystem local del titular vía Claude Code, macOS. El shell
interactivo **es zsh, no bash** (medido en la apertura: `[ "$a" \< "$b" ]` reventó con
`condition expected: <`). Todo script corre bajo `bash -c` explícito o como archivo
`.sh` con shebang `#!/usr/bin/env bash`. Toda URL con `?` va entre comillas dobles.

**POSICIÓN.** Toda ruta completa desde `<RAIZ>`. Ningún comando asume `cd` previo ni
estado heredado. FASE 0 sincroniza (`git fetch`) antes de operar contra el remoto.

**INSUMOS.** Todos en el filesystem local; ninguno se pasa aparte.

| Insumo | Ruta | Marcador |
|---|---|---|
| Raíz | `/Users/tomgc/Projects/slep_estado_proyectos_monitoreo` | (fuente: FASE 0 del encargo A-22, corrido en el turno anterior) |
| Paso 6 | `<RAIZ>/30_procesamiento/36_generar_panorama_visual.R` | (fuente: traza T6 de A-22) |
| Localizador | `<RAIZ>/30_procesamiento/32_localizar_documentos.R` | (fuente: traza T6 de A-22) |
| Configuración | `<RAIZ>/10_utils/10_configuracion.R` | (fuente: traza T6 de A-22) |
| Motor del censo | `<RAIZ>/50_documentacion/andamios/20260826_censo_backlogs_motor.R` | (hipótesis, se mide en FASE 0) |
| Arnés del censo | `<RAIZ>/50_documentacion/andamios/20260826_censo_backlogs_autotest.R` | (hipótesis, se mide en FASE 0) |
| Cartera hermana | `/Users/tomgc/Projects/slep_*` | (fuente: T6 de A-22, 27 directorios, 23 con `ESTADO.md`) |

### 1.1 Regla de detención (condiciones medibles)

Una detención **congela su tarea y sus descendientes** según el grafo de §5; las
independientes siguen.

1. `<RAIZ>` no existe o no es repo git → **detén la sesión entera**.
2. Al empezar, `git -C "<RAIZ>" status --porcelain` devuelve algo distinto de los dos
   untracked conocidos (`50_documentacion/andamios/20260827_encargo_apertura_v14.md`
   y `50_documentacion/andamios/logs/20260827_apertura_v14_log.md`, más el archivo de
   este encargo) → congela T0, reporta la salida literal, no commitees nada.
3. `git -C "<RAIZ>" log --oneline HEAD..origin/main` devuelve commits → otra estación
   trabajó: **detén la sesión entera** y reporta. No hagas `pull` ni `merge`.
4. El conflicto del PR #4 involucra **algún archivo distinto** de
   `50_documentacion/estructura/estructura_actual.md`,
   `50_documentacion/estructura/estructura_actual.txt` y los dos
   `50_documentacion/estructura/20260824_083051_estructura.{md,txt}` → congela T0b,
   **no resuelvas**, reporta la lista real. La autorización de §1.2 cubre esos cuatro
   y nada más.
5. **T1, condición central.** Si el conjunto de fichas que pierden `semaforo` **no**
   coincide exactamente con el conjunto que la regla de sincronía marca
   desincronizado → el diagnóstico es falso: congela T1 **antes de tocar una línea de
   código**, reporta ambos conjuntos y su diferencia simétrica. No ajustes la
   hipótesis al resultado.
6. Tras el cambio de T1, si `run_all(only = 6)` deja menos de 24 fichas con `semaforo`
   poblado, o si cualquier otro campo hoy poblado pasa a nulo → revierte el cambio con
   `git revert` (nunca `reset`), congela T1 y reporta el diff de campos.
7. El control negativo de T1 (repo con `vNN` realmente atrasado) **no** dispara, o el
   control positivo (repo sincronizado) **sí** dispara → la regla nueva no discrimina:
   congela T1 y no commitees.
8. T2: la guarda dispara sobre alguno de los 22 casos sanos, o calla sobre alguno de
   los 4 conocidos → congela T2, no commitees.
9. T3: cualquier operación que escriba dentro de un directorio `slep_*` distinto de
   `<RAIZ>` → **prohibida**; si el diseño la exige, congela T3 y reporta.
10. Tres intentos de corrección fallidos en la misma tarea, cada uno destapando un
    problema nuevo en otro lugar → **no intentes un cuarto**: detente y reporta "la
    arquitectura puede estar mal" con la evidencia de los tres.
11. **Cláusula residual.** Cualquier estado, conteo o resultado no enumerado en este
    encargo → congela ESA tarea, regístrala como duda (§4.8 del contrato) y sigue con
    la próxima tarea independiente.

### 1.2 Autorizaciones explícitas (lista cerrada)

- `git -C "<RAIZ>" fetch --all --prune`; `gh pr view`, `gh pr list`, `gh api "..."`.
- **T0a:** `git add` y commit de los tres archivos de andamio nombrados en §1.1 punto
  2, y push a `main`.
- **T0b:** `git checkout ordenacion/20260826`; `git merge main`; resolución del
  conflicto **tomando la versión de `main`** (`git checkout --theirs` o
  `--ours` según corresponda, verificando cuál es `main` con `git log` antes) para
  `50_documentacion/estructura/estructura_actual.md` y `.txt`; aceptación del borrado
  en los dos `20260824_083051_estructura.{md,txt}`; commit de merge; push de la rama;
  `gh pr merge 4 --merge --delete-branch=false`; `git checkout main`;
  `git pull --ff-only`.
- **T0c:** edición de `<RAIZ>/50_documentacion/activa/ESTADO.md` limitada a
  `sesion_abierta`, `cierre_incompleto` y `maquina`. **No toques prosa, ni
  `sesion_actual`, ni `commit_cierre`.** Commit y push.
- **T1:** edición de `<RAIZ>/30_procesamiento/32_localizar_documentos.R` y, si la
  medición lo exige, de `<RAIZ>/30_procesamiento/36_generar_panorama_visual.R` y
  `<RAIZ>/10_utils/10_configuracion.R`. Commit atómico y push.
- **T2:** edición de los mismos tres archivos, en commit **separado** del de T1.
- **Ejecución del pipeline:** `run_all(only = 6)` y `run_all(only = 1)`. Declarado:
  `only = 1` **no es de solo lectura**, escribe `40_salidas/registro_proyectos.csv`
  (ya fuera del control de versiones tras D-01). Antes de correrlo, copia el archivo
  vigente a `/tmp/registro_previo.csv` y contrasta después.
- **T3:** copias de trabajo **exclusivamente** bajo
  `/tmp/censo_control_positivo_20260827/`. Lectura de cualquier `slep_*`.
- Escritura de logs y andamios bajo `<RAIZ>/50_documentacion/andamios/`.
- `git revert` (si la condición 6 se activa).

**Nada más.** Sin `rm` fuera de `/tmp`, sin `checkout --` sobre archivos de trabajo,
sin `reset`, sin `push --force`, sin `stash drop`, sin crear ramas nuevas, sin
escritura alguna en repositorios hermanos, sin tocar los normativos, sin tocar el
instrumento de cierre.

---

## 2. Estado de partida (premisas marcadas)

Todas las cifras y estados de esta sección provienen del reporte y el log del encargo
A-22, corrido en el turno inmediatamente anterior sobre este mismo entorno.

- `main` = `origin/main` = `6174655`; árbol con untracked de andamio, sin
  modificaciones (fuente: A-22 §9 y §1).
- `commit_cierre: 88394ad`, ancestro de `origin/main`; `sesion_abierta: false`;
  `cierre_incompleto` en rojo por el PR #4 (fuente: A-22 §2, front matter íntegro).
- PR #4: abierto, `mergeable: CONFLICTING`, `mergeStateStatus: DIRTY`, base `main`,
  head `ordenacion/20260826` en `f444990`; los tres commits `5c90656`, `283d19d`,
  `f444990` alcanzables; `2555234` ya en `main` (fuente: A-22 §5).
- El conflicto es **solo** rotación de snapshots del escáner: `estructura_actual.md` y
  `.txt` modificados en ambos lados; los dos `20260824_083051_estructura.{md,txt}`
  borrados en ambos lados (resuelven solos). Ningún código, ni el marcador 4bis, ni el
  fix del escáner están en conflicto (fuente: A-22 §5).
- 23 de 27 hermanos tienen `ESTADO.md`; los 23 traen `semaforo` con valor (22
  `activo`, 1 `amarillo` en `slep_reporte_emergencia`) (fuente: A-22 §7, dos conteos
  independientes concordantes).
- El panorama tiene 24 fichas: 13 conservan `semaforo`, **7 lo pierden**
  (`aprendizajes_ep`, `lectoescritura`, `costapresente`, `idps`, `paes`,
  `seguimiento_educacion_inicial`, `reporte_emergencia`), 4 no tienen origen
  (fuente: A-22 §7).
- `estado_proyecto`: 0 de 23 en los `ESTADO.md` y 0 de 25 en el registro, que es su
  fuente real (`36_generar_panorama_visual.R:479`). **Es columna sin curar, no bug de
  extracción** (fuente: A-22 §7).
- `datos_sensibles`: 0 de 23 y 1 de 25. **El campo que sí existe en origen se llama
  `maneja_sensibles`** (fuente: A-22 §7).
- Traza del paso 6: lectura en `36_generar_panorama_visual.R:329` y `:359`; compuertas
  en `:332` y `:362`, que gatean por sincronizado; almacenamiento en `:461`; entrada
  al JSON de la ficha en `:489`; constantes en `10_utils/10_configuracion.R:66,75,87`;
  regla de sincronía en `32_localizar_documentos.R:176-196` (fuente: A-22 §7).
- La regla de sincronía usa `mtime` y no `vNN` (fuente: `traspaso_cierre_v13.md` §3;
  se re-verifica en FASE 0 leyendo el código).
- Asimetrías con la cartera: `slep_georreferenciacion` es ficha sin directorio;
  `normativa_convivencia`, `servicio_educativo_regional` y `territorio_costa_central`
  son directorios sin ficha, los dos primeros con `semaforo: activo` (fuente: A-22
  §10, hallazgo fuera del encargo previo).
- Escáner en `<RAIZ>/50_documentacion/estructura/estructura_actual.md`, **no** en
  `activa/` (fuente: A-22 §3).
- Backlog: 378 líneas, 82 entradas presentes de 89 numeradas, hueco permanente 55-61
  (fuente: A-22 §6).
- El log de A-22 quedó **sin commitear**, 473 líneas (fuente: A-22 §10).

**Cláusula fija de premisas.** Si alguna resulta falsa al medirla, **corrígela y
nómbrala en el reporte; no la obedezcas.** En A-22 cuatro premisas resultaron falsas y
esta cláusula fue lo que las hizo visibles.

**Cabo suelto heredado, a cerrar en FASE 0.** A-22 no declaró el resultado de su
medición 0.5: si `8213560` y `ec21563` (los dos commits del cierre v13) están en
`origin/main`. Mídelo y decláralo.

---

## 3. Invariantes (🔒)

- 🔒 **Ninguna escritura en repositorios hermanos.** T3 trabaja sobre copias en
  `/tmp/`. La escritura en un hermano exige autorización nominal por repo y esta
  sesión no la tiene.
- 🔒 Los normativos no se versionan en este repositorio.
- 🔒 El instrumento del censo (`20260826_censo_backlogs_motor.R` y
  `20260826_censo_backlogs_autotest.R`) está **congelado**: T3 lo **corre**, no lo
  edita. Si el control positivo exige tocarlo, congela T3 y reporta.
- 🔒 **No depositar archivos nuevos en `_archivo/`**: `.gitignore:17` los ignora y
  quedarían fuera de git sin aviso.
- 🔒 **No modificar el instrumento de cierre ni SETTINGS**: son transversales a los 25
  hermanos.
- 🔒 **No curar `estado_proyecto`** en este encargo. Su dominio debe fijarse antes
  contra `RANGO_ESTADO` del paso 6, y el enum equivocado ya tumbó ese paso en la
  sesión 6. T2 solo instala guardas y corrige el **nombre** del campo de
  sensibilidad; no cura contenido.
- 🔒 Nunca `push --force` ni descarte de commits ajenos.
- 🔒 Un cambio conceptual por commit. T1 y T2 no comparten commit aunque toquen el
  mismo archivo.

---

## 4. Contexto mínimo suficiente

`slep_estado_proyectos_monitoreo` (remoto `tomgc/slep_estado_area_monitoreo`) es el
orquestador en R que descubre la cartera `slep_*`, lee sus `ESTADO.md` y genera
`40_salidas/panorama_visual.html`, publicado por GitHub Pages vía `pages.yml`.

La apertura de la sesión 14 desdobló O-38 en dos causas distintas: `semaforo` **sí**
está en los 23 orígenes y se pierde en 7 fichas al pasar por compuertas que gatean por
sincronía; `estado_proyecto` y `datos_sensibles` nunca estuvieron. La hipótesis que
este encargo mide es que **O-38 y P6 son el mismo defecto visto por dos lados**: la
detección de sincronía usa `mtime`, produce falsos desincronizados, y esos falsos
pierden el campo.

---

## 5. Grafo de dependencias

```
FASE 0 ─┬─> T0a (commit andamios) ─> T0b (merge PR #4) ─> T0c (abrir candado)
        │                                                      │
        │                                                      v
        │                                                    T1 (O-38 / P6)
        │                                                      │
        │                                                      v
        │                                                    T2 (contrato de cartera)
        │
        └─> T3 (control positivo del censo)   [INDEPENDIENTE de todo lo anterior]
```

T0b requiere T0a. T0c requiere T0b. T1 requiere T0c. T2 requiere T1. **T3 es
independiente:** una detención en cualquier punto de la cadena T0-T2 no la congela, y
puede correr en paralelo como subagente desde el inicio.

---

## 6. Uso autorizado de subagentes (máximo 3, todos de solo lectura)

| # | Uso | Momento | Prohibido |
|---|---|---|---|
| S1 | **T3 completa**: control positivo del censo sobre copias en `/tmp/` | desde FASE 0, en paralelo | escribir fuera de `/tmp/`; editar el motor o el arnés |
| S2 | **Panel adversarial de T1 FASE A**: re-derivar con código propio, e independiente del hilo principal, el conjunto de fichas que pierden `semaforo` y el conjunto que la regla marca desincronizado | tras T1 FASE A, antes de tocar código | escribir cualquier archivo |
| S3 | **Panel adversarial de T1 FASE C**: re-derivar desde el HTML publicado el conteo de fichas con `semaforo` poblado, leyendo el artefacto y no el objeto en memoria | tras regenerar el panorama, antes del commit | escribir cualquier archivo |

S2 y S3 existen porque un check del mismo flujo que produjo el cambio hereda sus
puntos ciegos, y T1 es exactamente el caso: cifras y compuertas. Si S2 y el hilo
principal difieren, **manda la discrepancia**: congela T1 y reporta ambos conjuntos.

---

## FASE 0 — Medición de premisas

| # | Medición | Comando | Esperado | Si difiere |
|---|---|---|---|---|
| 0.1 | Cabeza y sincronía | `git -C "<RAIZ>" fetch --all --prune` y `git -C "<RAIZ>" log --oneline -1 main origin/main` | ambas `6174655` | punto 3 de §1.1 |
| 0.2 | Árbol | `git -C "<RAIZ>" status --porcelain` | solo los untracked de andamio | punto 2 de §1.1 |
| 0.3 | Cabo suelto v13 | `git -C "<RAIZ>" branch -r --contains 8213560` y con `ec21563` | ambos en `origin/main` | corrige la premisa y nómbralo |
| 0.4 | Conflicto real del PR | `git -C "<RAIZ>" merge-tree` o merge en seco de `main` sobre la rama | los 4 archivos de §2 | punto 4 de §1.1 |
| 0.5 | Regla de sincronía | `sed -n '160,210p' "<RAIZ>/30_procesamiento/32_localizar_documentos.R"` | usa `mtime` | corrige la premisa; si ya usa `vNN`, T1 cambia de objeto y se reporta |
| 0.6 | Compuertas del paso 6 | `sed -n '320,370p;450,500p' "<RAIZ>/30_procesamiento/36_generar_panorama_visual.R"` | líneas 329/332/359/362/461/479/489 como declara §2 | corrige los números y sigue con los reales |
| 0.7 | Instrumental del censo | `ls -l "<RAIZ>/50_documentacion/andamios/"20260826_censo_backlogs_*.R` | dos archivos | congela T3 |
| 0.8 | Inventario de pendientes | `wc -l "<RAIZ>/50_documentacion/andamios/20260826_pendientes_ruta_e_itinerario.md"` | 214 | reporta el real |

**No modifiques ningún archivo antes de completar FASE 0.**

---

## T0 — Cerrar el candado (Prioridad 0)

### T0a — Publicar los andamios

Commitea los tres archivos de andamio (encargo A-22, log de apertura, este encargo) en
un commit atómico `docs: encargo y log de apertura v14`. **Verificación entre generar
y consumar:** `git status --porcelain` vacío **antes** del push, y `git show --stat` de
la cabeza confirmando los tres archivos y ninguno más.

### T0b — Resolver el conflicto y mergear el PR #4

**Decisión del titular, ya tomada y registrada (D-14-2):** el conflicto se resuelve
tomando `estructura_actual.{md,txt}` de `main` (corrida 09:54:03) y descartando la de
la rama. Razón: son salidas regeneradas por `00_escanear_proyecto.R`, no autoría; no se
pierde información porque el escáner las vuelve a producir.

1. Antes de resolver, **imprime el plan**: la lista exacta de archivos en conflicto y,
   por cada uno, qué lado se toma. La lista impresa es lo autorizado; una discrepancia
   con §2 detiene la fase (§1.1 punto 4).
2. Verifica con `git log` **cuál lado es `main`** antes de usar `--ours`/`--theirs`:
   en un `git merge main` desde la rama, `--ours` es la rama y `--theirs` es `main`.
   Componer esto de memoria es el modo de fallo mudo de este paso.
3. Merge, commit, push de la rama, `gh pr merge 4 --merge --delete-branch=false`.
4. `git checkout main` y `git pull --ff-only`. Si no es fast-forward, detén y reporta.
5. **Re-derivación con comando distinto** (§3 del contrato): confirma que
   `50_documentacion/activa/50_ordenacion_repositorio.md` existe en `main` con
   `git show origin/main:50_documentacion/activa/50_ordenacion_repositorio.md | wc -l`,
   y que `EXCLUIR_DIRS` en `00_escanear_proyecto.R` incluye `node_modules`, `packrat` y
   `venv`. **No** por el mensaje de salida de `gh pr merge`.

**Criterio de éxito y calibración.** Gatillo 4bis apagado. Caso malo conocido: antes
del merge el `git show` falla (el archivo no está en `main`); caso bueno: después
devuelve un conteo positivo. Si el `git show` ya funcionaba antes del merge, la
comprobación no discrimina y hay que reportarlo.

### T0c — Abrir el candado

`sesion_abierta: true` con la máquina actual, `cierre_incompleto: no`. Commit
`chore: abrir sesion 14 (candado 0bis)` y push. Verificación con comando distinto:
`gh api "repos/tomgc/slep_estado_area_monitoreo/commits/main" --jq .sha` contrastado
con el hash local.

---

## T1 — O-38 en su causa (Prioridad 1)

### T1 FASE A — Medición pareada (**sin tocar código**)

Produce una tabla de **una fila por ficha del panorama** (24 filas) con:

`slug | tiene_directorio | tiene_ESTADO | semaforo_en_origen | veredicto_sincronia | semaforo_en_ficha | mtime_traspaso | sesion_actual | vNN_ultimo_traspaso`

`veredicto_sincronia` se obtiene ejecutando la regla vigente de
`32_localizar_documentos.R:176-196` tal como está, no reimplementándola de memoria.
`semaforo_en_ficha` se lee del **artefacto generado**, no del objeto en memoria.

**Predicado a contrastar, literal:** el conjunto de las 7 fichas que pierden `semaforo`
es **idéntico** al conjunto de fichas con `veredicto_sincronia == desincronizado`.

- **Coinciden** → la hipótesis se sostiene, sigue a FASE B.
- **No coinciden** → §1.1 punto 5: congela T1, reporta ambos conjuntos y su diferencia
  simétrica, y **no toques código**. El diagnóstico sería otro y esta sesión no lo
  tiene.

**Panel adversarial S2** re-deriva los dos conjuntos con código propio antes de que el
hilo principal decida. Discrepancia entre S2 y el hilo principal → congela T1.

**Validez de lectura.** Ata cada conteo a su fuente: el número de fichas leídas del
HTML debe igualar el número de bloques JSON encontrados, con `stopifnot`.

### T1 FASE B — Migrar la detección de `mtime` a `vNN`

Solo si FASE A confirmó. El criterio correcto, ya establecido en la cartera: comparar
`sesion_actual` del front matter contra el `vNN` del traspaso más reciente. `mtime`
produce falsos positivos cuando un traspaso se guarda pasada la medianoche de su fecha
de cierre declarada, que es exactamente el modo de fallo que se está corrigiendo.

Requisitos del cambio:

1. **Lee el archivo entero antes de editarlo.** No edites por número de línea sin ver
   el contexto.
2. `resolver_traspaso()` ya cubre los dos patrones de nombre (`traspaso_cierre_vNN` y
   `traspaso-cierre-vNN`): **úsala, no reimplementes la extracción del `vNN`**.
3. **Enumera los consumidores del veredicto de sincronía antes de cambiarlo**
   (`grep -rn` sobre `30_procesamiento/` y `10_utils/`). Si hay consumidores además de
   las compuertas `:332` y `:362`, decláralos y comprueba que el cambio no altera su
   comportamiento. Un cambio de semántica que se propaga sin medirse es el patrón de la
   sesión 13.
4. Fallback declarado: si un repo no tiene traspaso legible o no tiene `sesion_actual`,
   el veredicto es `indeterminado`, **no** `desincronizado`. Un dato ausente no es un
   dato negativo, y tratarlo como negativo es lo que produjo estas 7 fichas mudas.

### T1 FASE C — Regenerar y verificar

1. Copia `40_salidas/registro_proyectos.csv` a `/tmp/registro_previo.csv`.
2. `run_all(only = 1)` y `run_all(only = 6)`.
3. **Conteo programático sobre el HTML generado**: fichas con `semaforo` poblado.
   Esperado: **24 de 24**.
4. **Diff de campos completo**: por cada ficha y cada campo, antes contra después.
   Ningún campo hoy poblado puede pasar a nulo (§1.1 punto 6).
5. **Panel adversarial S3** re-deriva el conteo del punto 3 leyendo el artefacto con
   código propio.

**Controles, ambos obligatorios antes de commitear** (§2.6: el criterio debe demostrar
que puede arrojar el resultado contrario):

- **Control negativo (caso malo plantado):** en una copia bajo `/tmp/`, deja un repo
  con `sesion_actual` realmente atrasado respecto de su último traspaso. La regla nueva
  **debe** marcarlo desincronizado. Si calla, §1.1 punto 7.
- **Control positivo (caso bueno):** un repo con `sesion_actual` igual al `vNN` de su
  último traspaso **no** debe marcarse. Si dispara, §1.1 punto 7.

Commit atómico `fix: detectar sincronia por vNN en vez de mtime (O-38, P6)` y push.

---

## T2 — Contrato con la cartera (Prioridad 2)

Requiere T1. Commit **separado**.

1. **Corrección de nombre.** El paso 6 busca `datos_sensibles`; el campo que existe en
   los `ESTADO.md` es `maneja_sensibles`. Corrige la lectura al nombre real y verifica
   con `grep -rn` que no queda ninguna referencia al nombre viejo. **Esto es corregir
   el nombre del campo, no curar su contenido** (🔒).
2. **Guarda de asimetría.** El paso 6 debe emitir un **error nombrado** por cada una de
   las dos asimetrías, en vez de dejarlas mudas:
   - ficha en `data.js` sin directorio en disco (`slep_georreferenciacion`);
   - directorio `slep_*` con `ESTADO.md` y sin ficha en `data.js`
     (`normativa_convivencia`, `servicio_educativo_regional`,
     `territorio_costa_central`).
   El mensaje nombra el slug y el lado que falta. Reutiliza el patrón de la guarda del
   mapeo de `data.js` ya instalada en la sesión 13, que distingue **"no lo encontré"**
   de **"declaré que no existe"**: `simce` existe en el sitio y no en la cartera, y
   abortar por él dejaría el paso inejecutable por un dato verdadero. Por lo tanto la
   guarda **advierte con nombre y no aborta**, salvo que la asimetría sea de un slug
   declarado en la tabla de mapeo.
3. **Calibración obligatoria (§2.6).** Demuestra en el mismo turno que la guarda
   dispara sobre los **4** casos conocidos y **calla** sobre los otros 22. Si dispara
   sobre alguno de los 22 o calla sobre alguno de los 4, §1.1 punto 8.
4. `run_all(only = 6)` y verificación de que las 24 fichas siguen íntegras.

Commit `feat: guarda de asimetria entre data.js y la cartera` y push.

---

## T3 — Control positivo del censo (Prioridad 3, independiente)

Ejecutable por el subagente S1 desde el inicio, en paralelo con T0.

**Duda 1 del traspaso v13, literal.** Supuesto: el censo de backlogs detecta un hueco
real y no solo produce falsos positivos por sobre-detección. Predicado: plantando un
hueco en una copia de un repo clasificado `calza`, el instrumento lo clasifica
`hueco_interno` y nombra los números faltantes.

Procedimiento:

1. Del censo de la sesión 13, identifica un repo clasificado `calza` con backlog
   suficientemente largo. Declara cuál eliges y por qué.
2. Copia **solo su `backlog_acumulativo.md`** a
   `/tmp/censo_control_positivo_20260827/`. 🔒 Ninguna escritura en el hermano.
3. Corre el motor sobre la copia **intacta**: debe clasificar `calza`. Este es el caso
   bueno; si ya dice `hueco_interno`, el instrumento está roto y no hay nada que
   probar.
4. Borra **dos entradas intermedias no contiguas** (registra cuáles) y corre el motor:
   debe clasificar `hueco_interno` y **nombrar los dos números**.
5. Segunda variante: borra **un rango contiguo de tres**. Mismo criterio.
6. Tercera variante, control de la sobre-detección: renumera manteniendo el
   correlativo denso. Debe seguir diciendo `calza`.

🔒 El motor y el arnés están congelados: se corren, no se editan. Si el control exige
editarlos, congela T3 y reporta con la razón.

**Veredicto, uno de tres:** `detecta` (los tres casos correctos) / `ciego` (no detecta
el hueco plantado) / `sobre-detecta` (dispara sobre el caso bueno). No hay cuarta
opción, y "parece que sí" no es veredicto.

---

## 7. Auto-auditoría y log

Antes de reportar, re-deriva cada afirmación con comandos distintos de los que la
produjeron. El log completo y honesto, con la plantilla fija de §4 del contrato, va a:

`<RAIZ>/50_documentacion/andamios/logs/20260827_ruta_v14_log.md`

Déjalo **sin commitear**. Incluye obligatoriamente: §6 verificación de invariantes con
PASA/FALLA y evidencia; §7bis decisiones autónomas con alternativa descartada y
reversibilidad; §8 dudas en formato pendiente accionable con pregunta **cerrada**.

---

## 8. Reporte final al chat

1. Veredicto de T0: hashes del merge re-derivados desde `origin/main`, gatillo 4bis
   apagado con su evidencia, front matter de `ESTADO.md` tras abrir el candado.
2. **Tabla completa de T1 FASE A** (24 filas) y el veredicto del predicado, con lo que
   dijo el panel S2.
3. Conteo de fichas con `semaforo` poblado antes y después, re-derivado por S3, más el
   diff de campos.
4. Resultado de los dos controles de T1 (negativo y positivo), con el caso plantado.
5. Calibración de la guarda de T2: los 4 que disparan, los 22 que callan.
6. Veredicto de T3, uno de los tres, con los números plantados y los detectados.
7. Premisas de §2 que resultaron falsas, una por una, y el resultado del cabo suelto
   0.3.
8. Dudas y tareas congeladas, cada una con su pregunta cerrada.
9. Qué falló o sorprendió. Si nada, dilo explícitamente.

---

## 9. Checklist de envío (verificada sobre este borrador)

1. ENTORNO / INSUMOS / POSICIÓN presentes, intérprete declarado (`bash -c` explícito,
   el shell es zsh) → sí.
2. Toda oración declarativa del Estado de partida lleva marcador → sí.
3. Cada hipótesis tiene medición en FASE 0 con esperado y detención → sí.
4. La regla de detención cierra con la cláusula residual → sí, §1.1 punto 11.
5. Autorizaciones en lista cerrada terminada en "Nada más." → sí.
6. Cada criterio declara su calibración (caso malo, caso bueno) → sí: T0b, T1 FASE C,
   T2 punto 3, T3 pasos 3 y 6.
7. Toda iteración destructiva imprime su plan antes → sí, T0b punto 1.
8. ¿Algún identificador compuesto desde un nombre y no de su fuente? → no: el veredicto
   de sincronía se obtiene ejecutando la regla vigente, no reimplementándola; el `vNN`
   sale de `resolver_traspaso()`.
9. La cadena agota los pendientes encadenables → sí. **Excluidos con su razón:**
   O-20/B13-03 (idempotencia del paso 1) y A-21 (curación) porque curar sobre un
   archivo que el paso 1 corrompe es trabajo perdido, y la curación de
   `estado_proyecto` exige fijar antes su dominio contra `RANGO_ESTADO` (🔒); O-16 y
   O-18 porque tocan instrumentos transversales a los 25 hermanos y exigen sesión
   propia; A-06/O-11 porque el gatillo 4ter no se enciende y es la tarea menos urgente;
   O-37 (`_archivo/` ignorado) porque exige decisión de gobernanza del titular sobre si
   ese directorio debe versionarse.
10. Tope duro de subagentes declarado → sí: 3, todos de solo lectura, usos tasados en §6.
11. Dependencias como grafo explícito → sí, §5.
