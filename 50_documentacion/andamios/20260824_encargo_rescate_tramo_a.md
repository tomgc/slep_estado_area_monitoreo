# Encargo — Rescate, tramo A: preservar y versionar

- **Repo:** `slep_estado_proyectos_monitoreo` (remoto: `tomgc/slep_estado_area_monitoreo`)
- **Raíz:** `/Users/tomgc/Projects/slep_estado_proyectos_monitoreo`
- **Fecha:** 2026-08-24
- **Sesión:** 12
- **Alcance:** un solo repositorio, el emisor. Ningún hermano se toca.

---

## 0. Qué resuelve y qué no

**Resuelve:** que el trabajo de las sesiones 10, 11 y 12 deje de existir solo en este
disco. Hoy hay dos traspasos sin versionar, un andamio, una decisión formal y las
salidas regeneradas de la sesión 11, ninguno alcanzable desde `origin`.

**No resuelve, y es deliberado:** la integración de los diez commits que el remoto
tiene por delante. Esa es el tramo B y **no está autorizada**. La razón es concreta y
está medida: el commit `e24bceb` borra del árbol `POLITICA_PROYECTO.md`,
`SETTINGS_Y_PROMPTS_OPERACIONALES.md` y `CLAUDE.md`, y los agrega al `.gitignore`
(fuente: `git show --stat e24bceb` y `git show e24bceb -- .gitignore`, sesión 12).
Este árbol tiene esos mismos archivos modificados con 947 inserciones sin commitear.
Un merge produce conflicto `modify/delete` en los tres, y resolverlo mal pierde la
actualización a POLITICA v5.8 y SETTINGS v34 o revierte una decisión de cartera.

**Por qué una rama y no `main`:** una rama nueva se puede pushear estando diez commits
detrás, porque crea una referencia que no existe en el remoto y no modifica ninguna
existente. Es la única operación que quita el riesgo de pérdida hoy sin tocar la
integración. El destino final de la rama lo decide el titular en el tramo B.

---

## 1. Contrato

### 1.1 Prohibido en este tramo

1. `fetch`, `pull`, `merge`, `rebase`, `cherry-pick`, `reset`, `revert`.
2. `push` a `main` o a cualquier rama existente. El único push autorizado es la
   creación de `rescate/20260824`.
3. `push --force` en cualquier forma y hacia cualquier destino.
4. `git add -A`, `git add .`, `git add -u`, y cualquier `add` sin ruta explícita.
5. `git stash` en cualquiera de sus formas, incluido `pop`, `apply` y `drop`. El
   `stash@{0}` existente se conserva intacto y se declara.
6. Tocar cualquier directorio fuera de la raíz declarada.
7. `git rm`, `git mv`, y el borrado de cualquier archivo. Nada se archiva en este
   tramo: el archivado de traspasos (POLITICA 1.3.1) es otra tarea y mezclarla aquí
   haría indistinguible qué movimiento fue rescate y cuál fue orden.
8. **Stagear los tres normativos.** `50_documentacion/activa/POLITICA_PROYECTO.md`,
   `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` y `CLAUDE.md` quedan
   modificados y sin stagear, tal como están. La decisión de cartera (`e24bceb`) es
   que no se versionan; el `.gitignore` local todavía no los ignora porque esa línea
   viene en el commit que aún no se integra, así que la protección aquí es esta regla
   y no el `.gitignore`.

### 1.2 Reglas de detención

- **D1.** El estado inicial no calza con el declarado en §2. Reporta la diferencia y
  para: significa que algo escribió en este repo entre la apertura de la sesión y
  ahora, y el encargo se construyó sobre una foto que dejó de ser válida.
- **D2.** El grep de gobernanza del §5 encuentra un hallazgo. Para y escala: **no
  sanees por tu cuenta**. Este repositorio es público (fuente: mensaje de `e24bceb`,
  "repo publico"), y la decisión D3 del traspaso v11, que permitió conservar el
  nombre de pila del titular, se tomó sobre un repositorio privado. El criterio no se
  extrapola.
- **D3.** Cualquier comando de git devuelve un error no anticipado. Para, reporta la
  salida literal y no intentes una vía alternativa.

---

## 2. Precondiciones (verificar antes de tocar nada)

```bash
cd /Users/tomgc/Projects/slep_estado_proyectos_monitoreo
git rev-parse HEAD
git rev-parse --abbrev-ref HEAD
git status --porcelain | wc -l
git stash list | wc -l
git branch --list rescate/20260824
git ls-remote --heads origin rescate/20260824
```

Valores esperados, medidos en la apertura de esta sesión:

| Comprobación | Esperado | Si difiere |
|---|---|---|
| `HEAD` | `1b478b8` | D1 |
| rama | `main` | D1 |
| `status --porcelain` | 24 líneas, más las salidas del censo que el titular haya depositado | continuar, declarando el número real |
| `stash list` | 1 | D1 |
| rama local `rescate/20260824` | no existe | D1 |
| rama remota `rescate/20260824` | no existe | D1 |

Guarda el número inicial de líneas de `status` como `sucio_inicial`.

`git ls-remote` es la única consulta de red de este paso y es de solo lectura: no
mueve referencias locales, a diferencia de `fetch`.

---

## 3. Rama de trabajo

```bash
git switch -c rescate/20260824
```

`switch -c` desde `main` sin argumentos adicionales: la rama arranca exactamente en
`HEAD` y el árbol de trabajo no se altera. Nada del contenido sin commitear se pierde
ni se mueve en esta operación.

Verifica: `git rev-parse HEAD` devuelve el mismo hash que en §2, y
`git status --porcelain | wc -l` devuelve el mismo `sucio_inicial`.

---

## 4. Inventario previo al primer `add`

Antes de stagear nada, lista y reporta:

```bash
git status --porcelain
```

Clasifica cada línea en uno de estos cuatro grupos y **reporta la clasificación
completa antes de continuar**. Un archivo que no calce en ninguno se declara y no se
commitea.

| Grupo | Contenido | Destino |
|---|---|---|
| G1 | Traspasos sin versionar | commit 1 |
| G2 | Artefactos de la sesión 11: andamio de inventario y decisión de desalineación | commit 2 |
| G3 | Artefactos de la sesión 12 depositados en `andamios/` | commit 3 |
| G4 | Salidas regeneradas y snapshots del escáner | commit 4 |
| G5 | Los tres normativos | **ninguno**, por la regla 1.1.8 |

---

## 5. Compuerta de gobernanza (previa a todo commit)

Sobre **el conjunto exacto de archivos** que se van a commitear, no sobre el repo
completo:

```bash
grep -rInE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]' <archivos>
grep -rInE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' <archivos>
grep -rIn '/Users/' <archivos>
grep -rInE '(Escuela|Liceo|Colegio|Jardin|Jardín) [A-ZÁÉÍÓÚÑ]' <archivos>
grep -rInE 'Co-authored-by|Generated with|Claude Code' <archivos>
```

Cualquier resultado activa **D2**: para, reporta el archivo, el número de línea y el
tipo de hallazgo, y **no muestres la línea completa si contiene un dato personal**:
describe qué tipo de dato es.

Excepción única, ya decidida y acotada: la cadena `/Users/` dentro de
`50_documentacion/andamios/` cuando aparece en un bloque de comandos de un encargo. Es
ruta de ejecución documentada, no dato personal. Se declara en el reporte y no
detiene. Cualquier `/Users/` fuera de `andamios/` sí detiene.

---

## 6. Commits selectivos

Uno por bloque, con rutas explícitas. Nunca `add` sin ruta. Tras cada `add`, verifica
con `git status --porcelain` que **solo** lo previsto quedó staged; si aparece algo
más, `git restore --staged` de lo sobrante y reporta.

### Commit 1 — los traspasos

```bash
git add 50_documentacion/traspasos/traspaso_cierre_v10.md \
        50_documentacion/traspasos/traspaso_cierre_v11.md
git commit -m "docs(traspasos): versiona los cierres v10 y v11

Ambos existian solo en disco desde el 2026-07-10. Se versionan en el orden
correlativo y sin archivar ninguno: el archivado de POLITICA 1.3.1 es tarea
aparte."
```

Es el commit que quita el riesgo de pérdida y por eso va primero y solo.

### Commit 2 — artefactos de la sesión 11

```bash
git add 50_documentacion/andamios/20260710_inventario_repos_y_nuevos.md \
        50_documentacion/activa/decisiones/20260710_decision_desalineacion_nombres_repos.md
git commit -m "docs(sesion-11): andamio de inventario y decision de desalineacion de nombres"
```

### Commit 3 — artefactos de la sesión 12

Los archivos son los que el titular haya depositado en `50_documentacion/andamios/`.
Los esperados:

- `20260824_delta_normativo_kb.md`
- `20260824_encargo_censo_cartera.md`
- `20260824_censo_cartera.md`
- `20260824_censo_cartera.csv`
- `20260824_encargo_rescate_tramo_a.md` (este archivo)

**Comprobación previa obligatoria:** para cada uno, si no existe, **omítelo y
declaralo**; no lo des por presente. Si `20260824_censo_cartera.csv` resulta ignorado
por el `.gitignore`, no lo fuerces con `-f`: declara que quedó fuera y sigue.

```bash
git add <solo los que existen y no estan ignorados>
git commit -m "docs(sesion-12): delta normativo de la knowledge base y censo de cartera"
```

### Commit 4 — salidas y escáner

```bash
git add 20_insumos/registro_proyectos.csv 40_salidas/ 50_documentacion/estructura/
git commit -m "chore(salidas): regeneracion de la sesion 11 y rotacion de snapshots

Incluye las bajas de snapshots que la poda de retencion 2 dejo pendientes de
versionar (POLITICA 7.4)."
```

Este commit incluye los borrados de `50_documentacion/estructura/` que figuran como
`D` en el estado. `git add` de un directorio registra los borrados: verifica en el
`status` posterior al `add` que las cuatro `D` quedaron staged y no olvidadas.

---

## 7. Verificación previa al push

```bash
git status --porcelain
git log --oneline main..HEAD
git diff --stat main..HEAD
```

Condiciones que deben cumplirse todas:

1. `status --porcelain` muestra **solo** los tres normativos como modificados, más lo
   que se haya declarado omitido en el §6. Ningún traspaso, ningún andamio, ninguna
   salida.
2. `log --oneline main..HEAD` muestra exactamente cuatro commits, o tres si algún
   grupo quedó vacío. Ninguno más.
3. `git diff --stat main..HEAD` **no** menciona `POLITICA_PROYECTO.md`,
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md` ni `CLAUDE.md`. Si aparece alguno, la regla
   1.1.8 se violó: para, no pushees, y reporta.
4. `git stash list | wc -l` sigue devolviendo 1.

Si alguna falla, **no pushees** y reporta el estado completo.

---

## 8. Push de la rama

```bash
git push -u origin rescate/20260824
```

Sin `--force`, sin `--force-with-lease`, sin tocar `main`.

Verificación posterior, que es la que convierte "commiteado" en "publicado":

```bash
git ls-remote --heads origin rescate/20260824
git rev-parse HEAD
```

El SHA que devuelve `ls-remote` debe ser idéntico al de `HEAD` local. Un commit local
no es un commit publicado hasta que esto coincide.

---

## 9. Retorno a `main`

```bash
git switch main
git status --porcelain | wc -l
```

El árbol vuelve a `main` con los tres normativos modificados y el stash intacto, que
es exactamente el estado que el tramo B recibirá. Reporta el número de líneas: debe
ser 3 (los normativos), más lo declarado omitido.

**No** integres nada. El tramo B empieza con una decisión del titular sobre qué hacer
con las 947 inserciones locales de los normativos frente al borrado de `e24bceb`.

---

## 10. Mensaje final

Máximo doce líneas:

- Estado inicial: `HEAD`, `sucio_inicial`, `stash`.
- La clasificación del §4: cuántos archivos en cada grupo.
- Resultado del grep de gobernanza: hallazgos o "sin hallazgos".
- Los cuatro commits con su hash corto y su número de archivos.
- Archivos declarados omitidos y por qué.
- Las cuatro condiciones del §7 con su resultado.
- El SHA de `ls-remote` y el de `HEAD`, y si coinciden.
- Número de líneas de `status` tras volver a `main`.

Sin conclusiones ni propuestas de siguiente paso.
