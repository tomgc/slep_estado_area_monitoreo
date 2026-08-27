# Encargo A-22 — Verificación de apertura, sesión 14

> Encargo autónomo dirigido por meta (`encargo_autonomo_claude_code_v1.md` v1.3).
> **Meta:** dejar la apertura de la sesión 14 medida, no supuesta: candado 0bis,
> gatillos 4bis/4ter, paradero del inventario de pendientes que el traspaso v13
> declara y que no está en su ruta, estado real del PR #4, capas del backlog, y la
> medición en origen que O-38 exige antes de suponer una cadena de extracción.

---

## 1. Encabezado de contrato

**Modo y disciplina.** Modo autónomo, secuencial, todo en este turno.
**No se admiten subagentes (tope duro: 0).** El encargo es de lectura y no tiene
riesgo de datos: el panel adversarial de §3 no aplica.

**ENTORNO.** Filesystem local del titular vía Claude Code, macOS, `gh` CLI
disponible.

**POSICIÓN.** Toda ruta completa desde la raíz del proyecto. Ningún comando asume
`cd` previo ni estado de terminal heredado. **Intérprete declarado: `bash`
explícito**, nunca el shell interactivo (en zsh `read -r path` destruye `PATH`, y
toda URL con `?` exige comillas dobles). FASE 0 sincroniza contra el remoto
(`git fetch`) antes de comparar refs.

**INSUMOS.** Todos viven en el filesystem local; ninguno se incrusta ni se pasa
aparte. Sus rutas se verifican en FASE 0 antes de leerlos.

| Insumo | Ruta | Marcador |
|---|---|---|
| Raíz del proyecto | `/Users/tomgc/Projects/slep_estado_proyectos_monitoreo` | (hipótesis, se mide en FASE 0) |
| Estado | `<RAIZ>/50_documentacion/activa/ESTADO.md` | (hipótesis, se mide en FASE 0) |
| Backlog | `<RAIZ>/50_documentacion/activa/backlog_acumulativo.md` | (hipótesis, se mide en FASE 0) |
| Escáner | `<RAIZ>/50_documentacion/activa/estructura_actual.md` | (hipótesis, se mide en FASE 0) |
| Cartera hermana | `/Users/tomgc/Projects/slep_*` | (hipótesis, se mide en FASE 0) |

En adelante `<RAIZ>` es la raíz confirmada en FASE 0. Si no existe, **detén la
sesión entera** y reporta: sin raíz no hay encargo.

### 1.1 Regla de detención (condiciones medibles)

Cada condición nombra su medición. Una detención **congela su tarea y sus
descendientes** según el grafo de §5; las tareas independientes siguen.

1. `<RAIZ>` no existe o no es repositorio git (`git -C "<RAIZ>" rev-parse --git-dir`)
   → **detén la sesión entera**.
2. `git -C "<RAIZ>" status --porcelain` devuelve alguna línea al empezar
   → congela T7 (escritura), ejecuta T1-T6 igual, reporta la salida literal.
3. La rama activa no es `main` (`git -C "<RAIZ>" rev-parse --abbrev-ref HEAD`)
   → congela T7, reporta rama activa; no cambies de rama por tu cuenta.
4. `git -C "<RAIZ>" log origin/main..HEAD --oneline` devuelve commits locales sin
   publicar → congela T7 y reporta los hashes; no pushees.
5. `git -C "<RAIZ>" log HEAD..origin/main --oneline` devuelve commits remotos sin
   integrar → congela T7 y reporta; no hagas `pull` (puede haber otra estación).
6. El PR #4 no está abierto, o `mergeable` no es `MERGEABLE`, o su `baseRefName`
   no es `main`, o su `headRefName` no es `ordenacion/20260826`
   → congela T4b (el merge), ejecuta T4a (el diagnóstico) igual.
7. La cacería de T3 no encuentra el archivo de control positivo
   (`20260824_pendientes_y_encargos.md`) → el instrumento es ciego: **no reportes
   ausencia**, congela T3 y reporta que el instrumento falló su calibración.
8. El conteo de directorios `slep_*` con `ESTADO.md` difiere entre los dos comandos
   independientes de T6 → congela T6 y reporta ambos conteos; no elijas uno.
9. Cualquier `ESTADO.md` de hermano resulta ilegible (permisos, encoding)
   → no lo omitas en silencio: cuéntalo como fila con causa declarada.
10. **Cláusula residual.** Cualquier estado, conteo o resultado no enumerado en este
    encargo → **congela ESA tarea, regístrala como duda (§4.8 del contrato) y sigue
    con la próxima tarea independiente.**

### 1.2 Autorizaciones explícitas (lista cerrada)

- `git -C "<RAIZ>" fetch --all --prune` (lectura remota).
- `gh pr view`, `gh pr list`, `gh api "..."` con la URL entre comillas dobles
  (lectura).
- `gh pr merge 4 --merge --delete-branch=false` **solo si** se cumplen a la vez, y
  medidas en este mismo turno: PR #4 abierto; `mergeable == MERGEABLE`;
  `baseRefName == main`; `headRefName == ordenacion/20260826`; los tres commits
  `5c90656`, `283d19d`, `f444990` alcanzables desde el head del PR; y
  `git status --porcelain` vacío. Si una sola falla, **no mergees**.
- Tras un merge exitoso: `git -C "<RAIZ>" checkout main` y
  `git -C "<RAIZ>" pull --ff-only`. Si el `pull` no es fast-forward, detén T7 y
  reporta.
- Edición de `<RAIZ>/50_documentacion/activa/ESTADO.md` **limitada a tres campos**:
  `sesion_abierta`, `cierre_incompleto` y el campo de máquina. No toques prosa, no
  toques `sesion_actual`, no toques `commit_cierre`.
- Un commit y un push de esa edición a `main`.
- Escritura del log en `<RAIZ>/50_documentacion/andamios/logs/20260827_apertura_v14_log.md`.
- Lectura de cualquier archivo del repositorio y de los hermanos `slep_*`.

**Nada más.** Sin `rm`, sin `checkout --`, sin `reset`, sin `push --force`, sin
`stash drop`, sin tocar los repositorios hermanos, sin crear ramas.

---

## 2. Estado de partida (premisas marcadas)

- POLITICA vigente v5.8 y SETTINGS vigente v34 (fuente: encabezados de ambos
  archivos leídos por el asistente en este turno desde la knowledge base).
- El traspaso v13 declara `main` previo al cierre en `88394ad` (fuente:
  `traspaso_cierre_v13.md` §1, leído en este turno).
- El cierre v13 declara dos commits publicados, `8213560` (documentación) y
  `ec21563` (log) (fuente: eco del titular en este turno; **no es fuente de estado
  de repositorio**, se mide en FASE 0).
- `commit_cierre` de `ESTADO.md` apunta a `88394ad`, el `main` previo al cierre
  (fuente: eco del titular; se mide en FASE 0).
- `cierre_incompleto` está en rojo declarando el PR #4 sin mergear (hipótesis, se
  mide en FASE 0).
- `50_documentacion/andamios/20260826_pendientes_ruta_e_itinerario.md` no existe en
  esa ruta, y el único archivo de pendientes en `andamios/` es
  `20260824_pendientes_y_encargos.md` (fuente: `test -f` y `ls` corridos por el
  titular en este turno). **Su paradero real es la meta de T3.**
- `_archivo/` está ignorado en `.gitignore:17`: lo movido conserva versionado, lo
  nuevo no (fuente: `traspaso_cierre_v13.md` §7 punto 1 y O-37).
- `semaforo`, `estado_proyecto` y `datos_sensibles` llegan nulos a las fichas del
  panorama publicado (fuente: `traspaso_cierre_v13.md` §3).

**Cláusula fija de premisas.** Si alguna de estas premisas resulta falsa al medirla,
**corrígela y nómbrala en el reporte; no la obedezcas.** Siete encargos consecutivos
de la sesión 13 llevaron premisas equivocadas y esta cláusula fue la única
salvaguarda que funcionó.

---

## 3. Invariantes (🔒)

- 🔒 Los normativos (`POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`)
  **no se versionan en este repositorio**. No los agregues ni los edites.
- 🔒 El instrumento del censo (`20260826_censo_backlogs_motor.R` y
  `20260826_censo_backlogs_autotest.R`, en `andamios/`) está **congelado**.
- 🔒 **No deposites ningún archivo nuevo en `_archivo/`.** Está ignorado y quedaría
  fuera de git sin aviso: es la forma exacta en que se perdieron las entradas 55-61
  del backlog.
- 🔒 **No modifiques el instrumento de cierre ni SETTINGS desde este proyecto:** son
  transversales a los 25 hermanos y su cambio obliga a repropagarlos.
- 🔒 **Ninguna escritura en los repositorios hermanos `slep_*`.** T6 los lee y nada
  más. La escritura en un hermano exige autorización nominal por repo y esta sesión
  no la tiene.
- 🔒 Nunca `push --force` ni descarte de commits ajenos. Si hay divergencia real
  entre estaciones, detente y reporta.

---

## 4. Contexto mínimo suficiente

`slep_estado_proyectos_monitoreo` (remoto `tomgc/slep_estado_area_monitoreo`) es el
orquestador en R que lee los `ESTADO.md` de la cartera hermana y genera
`40_salidas/panorama_visual.html`, publicado por GitHub Pages. La sesión 13 devolvió
el pipeline a operación, corrigió `data.js` y dejó la ordenación del repositorio en
el PR #4 sin mergear. Al cierre apareció O-38: `semaforo` llega nulo a todas las
fichas del panorama publicado.

El protocolo de apertura (SETTINGS §1.2.2) exige medir el candado 0bis **antes de
trabajar**, y el traspaso v13 §12 prohíbe diagnosticar `semaforo` suponiendo una
cadena de extracción: hay que medir primero en los `ESTADO.md` de los hermanos.

---

## 5. Cadena de tareas y grafo de dependencias

```
FASE 0 ─┬─> T1 (candado 0bis) ─┬─> T4a (diagnóstico PR #4) ──> T4b (merge, condicionado)
        │                      └─> T7 (apertura del candado)   ──┘
        ├─> T2 (gatillos 4bis / 4ter)        [independiente]
        ├─> T3 (cacería del inventario)      [independiente]
        ├─> T5 (capas del backlog)           [independiente]
        └─> T6 (O-38 en origen)              [independiente]
```

T4b requiere T4a. T7 requiere T1 y T4b. T2, T3, T5 y T6 son independientes entre sí
y de todo lo anterior: **una detención en T1 o T4 no las congela.**

---

### FASE 0 — Medición de premisas

Confirma, con comando y valor esperado:

| # | Medición | Comando | Esperado | Si difiere |
|---|---|---|---|---|
| 0.1 | Raíz existe y es repo | `git -C "<RAIZ>" rev-parse --show-toplevel` | ruta absoluta | detén la sesión |
| 0.2 | Rama activa | `git -C "<RAIZ>" rev-parse --abbrev-ref HEAD` | `main` | congela T7 |
| 0.3 | Árbol limpio | `git -C "<RAIZ>" status --porcelain` | salida vacía | congela T7, reporta literal |
| 0.4 | Sincronía remota | `git -C "<RAIZ>" fetch --all --prune` y luego `git -C "<RAIZ>" log --oneline origin/main..HEAD` y `git -C "<RAIZ>" log --oneline HEAD..origin/main` | ambas vacías | congela T7, reporta hashes |
| 0.5 | Commits del cierre publicados | `git -C "<RAIZ>" branch -r --contains 8213560` y lo mismo con `ec21563` | ambos en `origin/main` | corrige la premisa y nómbralo |
| 0.6 | Rutas de insumos | `ls -l` de las cuatro rutas de §1 | existen | reporta la que falte |

---

### T1 — Candado 0bis (SETTINGS §1.2.2, punto 0bis)

Las cuatro comprobaciones, **con comando y no de vista**:

```bash
cd "<RAIZ>" && git fetch --quiet && \
  c=$(grep -m1 '^commit_cierre:' 50_documentacion/activa/ESTADO.md | awk '{print $2}') && \
  echo "commit_cierre declarado: $c" && \
  git merge-base --is-ancestor "$c" origin/main && echo "0bis-3: PASA (ancestro)" || echo "0bis-3: FALLA" ; \
  grep -m1 '^sesion_abierta:' 50_documentacion/activa/ESTADO.md ; \
  grep -m1 '^cierre_incompleto:' 50_documentacion/activa/ESTADO.md ; \
  git status --porcelain | head
```

Además:

1. **Volcado íntegro del front matter** de `ESTADO.md`, literal, al reporte. Es el
   insumo del acuse y el asistente no lo tiene.
2. **`ventana_insumos` (I9, SETTINGS v34).** Lee la línea, resuelve **cada** entrada
   y declara cuáles resolvieron con contenido y cuáles no, con su causa. I9 pasa si
   **al menos una** resuelve con contenido: es precedencia, no conjunción. Las que
   no resolvieron se declaran igual.
3. **Contraste de la tabla de insumos declarados del traspaso v13 contra la ventana
   real.** Una fecha distinta se declara, no se ignora.

**Criterio de aceptación y su calibración.** El veredicto de 0bis es PASA solo si las
cuatro comprobaciones dan verde. Calibración: el propio `cierre_incompleto` es el
caso malo conocido esperado (debería disparar); `commit_cierre` ancestro es el caso
bueno conocido (debería callar). Si **ambos** dan el mismo veredicto, el instrumento
no discrimina: repórtalo.

---

### T2 — Gatillos 4bis y 4ter

| Gatillo | Comprobación | Evidencia obligatoria |
|---|---|---|
| 4bis, ordenación | `test -f "<RAIZ>/50_documentacion/activa/50_ordenacion_repositorio.md"` **en `main`**, no en la rama de ordenación | `ls "<RAIZ>"/50_documentacion/traspasos/*.md \| wc -l` |
| 4ter, locale UTF-8 | `test -f "<RAIZ>/50_documentacion/activa/50_locale_utf8.md"` | `grep -rl asegurar_locale_utf8 "<RAIZ>/10_utils" \| wc -l` |

Declara el resultado incluso si el archivo existe (el asistente necesita el dato para
el acuse; la regla de "si existe, no se menciona" gobierna el acuse, no tu reporte).

Añade: contenido de `estructura_actual.md` limitado a **la fecha de corrida y el
árbol de `50_documentacion/`**, más `wc -l` del archivo completo. No lo re-corras:
`00_escanear_proyecto.R` escribe y esta tarea es de lectura.

---

### T3 — Cacería del inventario de pendientes (**meta propia**)

El traspaso v13 §11 declara que el inventario completo de pendientes "está en"
`50_documentacion/andamios/20260826_pendientes_ruta_e_itinerario.md`, "que es su
fuente", y su §14 lo repite en la reapertura. En esa ruta no está. Si el archivo no
existe en ninguna parte, **el inventario de pendientes de la sesión 14 se perdió** y
hay que reconstruirlo desde el traspaso: eso cambia la ruta de la sesión.

Busca, en este orden, y reporta cada uno por separado:

1. **Disco, todo el repo:**
   `find "<RAIZ>" -iname '*pendiente*' -o -iname '*itinerario*' -o -iname '*ruta_e*'`
2. **Disco, fuera del repo:**
   `find /Users/tomgc/Projects -maxdepth 3 -iname '*pendientes_ruta_e_itinerario*' 2>/dev/null`
3. **Todas las ramas y todo el historial:**
   `git -C "<RAIZ>" log --all --diff-filter=A --name-only --format='%h %ad' --date=short | grep -i -E 'pendiente|itinerario'`
4. **Índice de cada rama:**
   `for b in $(git -C "<RAIZ>" for-each-ref --format='%(refname:short)' refs/heads refs/remotes); do echo "== $b"; git -C "<RAIZ>" ls-tree -r --name-only "$b" | grep -i -E 'pendiente|itinerario'; done`
5. **Stash y reflog:** `git -C "<RAIZ>" stash list` y
   `git -C "<RAIZ>" reflog --date=short | head -40`
6. **`_archivo/`, incluido lo no versionado:**
   `ls -laR "<RAIZ>/_archivo" 2>/dev/null`
7. **Objetos sueltos:** `git -C "<RAIZ>" fsck --lost-found 2>&1 | head -20`

**Control positivo obligatorio (§2.6, "ausencia exige control positivo").** Antes de
reportar cualquier ausencia, corre los pasos 1, 3 y 4 buscando
`20260824_pendientes_y_encargos.md`, que sí existe. Si el instrumento **no** lo
encuentra, está ciego: no reportes ausencia, congela T3 y dilo.

**Veredicto de T3, uno de tres:** `existe_en <ruta o rama>` /
`nunca_existio` (ningún commit lo agregó jamás, evidencia del paso 3) /
`existio_y_se_perdio` (aparece en el historial o el reflog y no en disco). No hay
cuarta opción y "no lo encontré" no es veredicto.

---

### T4a — Diagnóstico del PR #4

```bash
gh pr view 4 --repo tomgc/slep_estado_area_monitoreo \
  --json number,state,mergeable,mergeStateStatus,baseRefName,headRefName,title,commits
```

Reporta además:
`git -C "<RAIZ>" log --oneline origin/main..origin/ordenacion/20260826` y si los tres
commits `5c90656`, `283d19d`, `f444990` son alcanzables desde el head del PR
(`git merge-base --is-ancestor` para cada uno). **Identidad desde su fuente:** el
nombre del remoto se deriva de `git -C "<RAIZ>" remote get-url origin`, no del nombre
del directorio local (que difiere del remoto: es deuda de nomenclatura documentada).

### T4b — Merge del PR #4 (condicionado)

Solo con **todas** las condiciones de §1.2 medidas verdes en este turno. Tras el
merge, re-deriva con un comando distinto del que lo produjo: confirma por
`git -C "<RAIZ>" log --oneline -3 origin/main` que los tres commits están en
`origin/main`, **no** por el mensaje de salida de `gh pr merge`.

---

### T5 — Capas del backlog acumulativo (SETTINGS §1.2.2, punto 2)

Del archivo `<RAIZ>/50_documentacion/activa/backlog_acumulativo.md`, devuelve
**literales** y en este orden: Objetivo del proyecto; Nota metodológica;
Clasificación temática completa (la tabla, con su columna `N` y su total);
Resumen estadístico por sesión; y el Detalle cronológico **solo de la sesión 13**.
No resumas: el asistente necesita el texto.

**Validez de lectura.** Ata lo leído a la fuente: reporta `wc -l` del archivo y el
número de línea donde empieza y termina cada bloque extraído. Una lectura truncada
en silencio pasa todos los chequeos de salida.

**Cuadratura.** Recuenta programáticamente las entradas del detalle cronológico y
contrástalo con el total que declara la Clasificación temática. Si no cuadran,
repórtalo con ambos números; la sesión 13 ya cerró con esa contradicción una vez
(E13-09).

---

### T6 — O-38: medición en origen (**solo lectura, sin corregir nada**)

El traspaso v13 §12 lo prohíbe explícitamente: no supongas una cadena de extracción.
Mide primero en la fuente.

1. **Universo.** Lista los directorios `/Users/tomgc/Projects/slep_*` y, de ellos,
   los que tienen `50_documentacion/activa/ESTADO.md`. Cuenta con **dos comandos
   independientes** (`find` y un bucle con `test -f`). Si los conteos difieren,
   congela T6 y reporta ambos: no elijas uno.
2. **Tabla por hermano**, una fila por repositorio, con estas columnas:
   `repo | tiene_ESTADO | semaforo_presente | semaforo_valor | estado_proyecto_presente | datos_sensibles_presente`.
   Lee **solo el front matter** (hasta el segundo `---`), no el archivo entero: un
   `grep` que lee más allá del front matter es el falso positivo C7 del censo.
3. **Traza del campo**, solo para los hermanos donde `semaforo` **sí** tiene valor:
   localiza con `grep -n` en qué archivo y línea del pipeline se lee `semaforo`, en
   qué constante o vector se guarda, y en qué punto entra al JSON de la ficha.
   Nombra archivo y línea; **no propongas ni apliques corrección alguna.**
4. **Veredicto de la duda 2 del traspaso**, uno de dos:
   `columna_sin_curar` (el campo no está en los `ESTADO.md` de origen, misma causa
   que `estado_proyecto`) o `defecto_de_extraccion` (está en origen con valor y se
   pierde en el pipeline). Si el resultado es mixto, dilo con la cuenta de cada lado.

---

### T7 — Apertura del candado (condicionada)

Solo si T1 da PASA en las cuatro comprobaciones (o si el único rojo era
`cierre_incompleto` y T4b lo resolvió mergeando el PR #4). Entonces:

1. `sesion_abierta: true` con la máquina actual y `cierre_incompleto: no`.
2. Commit atómico, mensaje `chore: abrir sesion 14 (candado 0bis)`.
3. Push inmediato a `main`.
4. Verificación **con comando distinto**: `gh api "repos/tomgc/slep_estado_area_monitoreo/commits/main" --jq .sha` y contraste con el hash local.

Si T1 quedó en rojo por otra causa, **no abras el candado**: reporta y deja el
estado intacto. La apertura de emergencia (§1.2.8) la decide el asistente con tu
reporte en mano, no tú.

---

## 6. Mandato de auto-auditoría y log

Antes de reportar, re-deriva con comandos distintos de los que produjeron cada
resultado (§3 del contrato). Escribe el log completo, honesto e incluyendo lo que
costó, con la plantilla fija de §4 del contrato, en:

`<RAIZ>/50_documentacion/andamios/logs/20260827_apertura_v14_log.md`

Déjalo **sin commitear** para revisión previa.

---

## 7. Reporte final al chat

En este orden, y sin prosa de relleno:

1. **Veredicto de 0bis**: PASA / FALLA, con la causa y la salida literal de las
   cuatro comprobaciones.
2. **Front matter íntegro de `ESTADO.md`** y resolución de `ventana_insumos` (I9).
3. **Gatillos 4bis y 4ter**, con su evidencia numérica.
4. **Veredicto de T3**, uno de los tres, con la evidencia del control positivo.
5. **Estado del PR #4** y, si se mergeó, los hashes re-derivados desde `origin/main`.
6. **Bloques literales de T5**, con sus números de línea, y la cuadratura del total.
7. **Tabla de T6** completa, más el veredicto de la duda 2.
8. **Premisas de §2 que resultaron falsas**, nombradas una por una.
9. **Dudas y tareas congeladas**, cada una con su pregunta cerrada.
10. **Qué falló o sorprendió. Si nada, dilo explícitamente.**

---

## 8. Checklist de envío (verificada sobre este borrador)

1. ENTORNO / INSUMOS / POSICIÓN presentes, intérprete `bash` declarado → sí.
2. Toda oración declarativa del Estado de partida lleva marcador → sí.
3. Cada hipótesis tiene medición en FASE 0 con esperado y detención → sí.
4. La regla de detención cierra con la cláusula residual → sí, §1.1 punto 10.
5. La lista de autorizaciones es cerrada y termina en "Nada más." → sí.
6. Cada criterio declara su calibración → sí (T1, T3 control positivo, T6 doble conteo).
7. Toda iteración destructiva tiene pasada de impresión previa → no hay iteraciones destructivas.
8. ¿Algún identificador compuesto desde un nombre y no de su fuente? → no: T4a deriva el remoto de `git remote get-url`.
9. La cadena agota los pendientes encadenables → sí. **Excluidos con su razón:**
   A-06 (guarda de locale) es escritura de código y espera la compuerta de Fase C;
   duda 1 (control positivo del censo) exige diseño de instrumento, no comando;
   A-20 y A-21 esperan la ruta aprobada.
10. Tope duro de subagentes declarado → sí: 0.
11. Dependencias como grafo explícito → sí, §5.
