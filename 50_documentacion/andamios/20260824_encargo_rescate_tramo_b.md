# Encargo — Rescate, tramo B: integrar el remoto

- **Repo:** `slep_estado_proyectos_monitoreo` (remoto: `tomgc/slep_estado_area_monitoreo`)
- **Raíz:** `/Users/tomgc/Projects/slep_estado_proyectos_monitoreo`
- **Fecha:** 2026-08-24
- **Sesión:** 12
- **Depende de:** tramo A completado y publicado (`98a4097` en
  `origin/rescate/20260824`).

---

## 0. Qué resuelve

`main` local está diez commits detrás de `origin/main`. Esos diez commits traen tres
cosas de naturaleza distinta, y el encargo las trata por separado porque fallan
distinto:

1. **La decisión de gobernanza `e24bceb`:** los normativos no se versionan. Borra del
   árbol `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md` y `CLAUDE.md`,
   y los agrega al `.gitignore`.
2. **La ola de portabilidad:** `renv` obligatorio, `.Rprofile`, `.Renviron.example`,
   `10_utils/10_validar_portabilidad.R` y el verificador de cierre.
3. **La actualización normativa `2dbb0b3`** a POLITICA v5.7 y SETTINGS v31, que este
   árbol ya supera localmente con v5.8 y v34 sin commitear.

**Decisión del titular, tomada en la sesión 12:** se acata `e24bceb`. Los normativos
salen del control de versiones y **se conservan en disco como archivos ignorados**,
con el contenido local (v5.8 / v34), que es más reciente que el del remoto. Ignorado
no es borrado: Claude Code los sigue leyendo del filesystem.

**Red de seguridad:** todo el trabajo de las sesiones 10 a 12 ya está publicado en
`origin/rescate/20260824`. Si este tramo sale mal, `git reset --hard 1b478b8` devuelve
el árbol a su estado actual sin pérdida. Ese comando **no** se ejecuta aquí: se
declara para que exista la salida.

---

## 1. Contrato

### 1.1 Prohibido

1. `push --force` en cualquier forma y hacia cualquier destino.
2. `rebase`. La integración es por `merge`, que preserva ambos historiales.
3. Borrar, mover o modificar la rama `rescate/20260824`, local o remota.
4. `git stash` en cualquiera de sus formas. El `stash@{0}` se conserva intacto.
5. Ejecutar R, `Rscript`, `run_all()` o cualquier script del pipeline. La
   verificación funcional del pipeline la corre el titular en Positron, y este
   encargo termina dejándole el árbol listo, no probado.
6. `renv::restore()`, `renv::init()` o cualquier escritura sobre la biblioteca de
   paquetes. El paso 2 solo **lee** `renv.lock`.
7. Resolver un conflicto distinto de los dos anticipados en el §4. Cualquier otro
   conflicto activa **D2**.
8. `git add -A`, `git add .`, y cualquier `add` sin ruta explícita.

### 1.2 Reglas de detención

- **D1.** El estado inicial no calza con el §3. Para y reporta.
- **D2.** El merge produce un conflicto en un archivo que no sea
  `50_documentacion/activa/POLITICA_PROYECTO.md` o
  `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md`. Para **sin abortar**,
  reporta `git status` completo y espera instrucción. No inventes una resolución.
- **D3.** Tras el merge, `git check-ignore` no confirma que los tres normativos estén
  ignorados. Para: significa que el `.gitignore` de `e24bceb` no llegó, y sin él los
  archivos repuestos volverían a aparecer como sin seguimiento en el próximo cierre.
- **D4.** El diagnóstico de `renv` del paso 2 revela que la versión de R declarada en
  `renv.lock` difiere de la instalada en esta máquina en su versión mayor o menor
  (por ejemplo, `4.4.x` declarado contra `4.3.x` instalado). Para y reporta antes de
  mergear: el `.Rprofile` activa `renv` en cada arranque de R y una discrepancia así
  rompe el pipeline al abrir Positron, que es exactamente el modo de fallo que este
  paso existe para anticipar.

---

## 2. Diagnóstico previo de `renv` (solo lectura, antes de integrar)

El merge deposita un `.Rprofile` que activa `renv` en todo arranque de R en esta
raíz. Es el único cambio de los diez commits que puede romper el pipeline sin que
ningún archivo del pipeline cambie, y por eso se mide antes y no después.

```bash
cd /Users/tomgc/Projects/slep_estado_proyectos_monitoreo
git show origin/main:.Rprofile
git show origin/main:renv/settings.json
git show origin/main:renv.lock | head -20
git show origin/main:renv.lock | grep -c '"Package"'
R --version | head -1
ls -d renv 2>/dev/null || echo "sin directorio renv local"
echo "${RENV_PATHS_ROOT:-RENV_PATHS_ROOT no definida}"
```

Reporta la salida literal de cada uno. Del `head -20` interesa el campo `Version` del
bloque `R`; del `grep -c`, cuántos paquetes declara el lockfile.

Aplica **D4** comparando la versión de R del lockfile contra la de `R --version`.
Iguales en mayor y menor: continúa. Distintas: para.

Si continúas, declara en el reporte final, en una línea, cuántos paquetes tendrá que
restaurar el titular y si existe ya una biblioteca `renv` local en esta raíz.

---

## 3. Precondiciones

```bash
git rev-parse HEAD
git rev-parse --abbrev-ref HEAD
git status --porcelain
git stash list | wc -l
git ls-remote --heads origin rescate/20260824
```

| Comprobación | Esperado | Si difiere |
|---|---|---|
| `HEAD` | `1b478b8` | D1 |
| rama | `main` | D1 |
| `status --porcelain` | exactamente 2 líneas, ambas ` M` sobre los normativos de `50_documentacion/activa/` | D1 |
| `stash list` | 1 | D1 |
| `rescate/20260824` en `origin` | existe, en `98a4097` | D1: sin red de seguridad no se integra |

---

## 4. Preservar los normativos fuera del repo

El merge va a intentar borrar dos archivos que este árbol tiene modificados. Antes de
que eso ocurra, la versión local se pone a salvo **fuera** de la raíz del repo, para
que ninguna resolución de conflicto pueda perderla.

```bash
mkdir -p /tmp/normativos_v58_v34
cp 50_documentacion/activa/POLITICA_PROYECTO.md /tmp/normativos_v58_v34/
cp 50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md /tmp/normativos_v58_v34/
shasum -a 256 /tmp/normativos_v58_v34/*.md
grep -m1 -i 'versi' /tmp/normativos_v58_v34/POLITICA_PROYECTO.md
grep -m1 -i 'versi' /tmp/normativos_v58_v34/SETTINGS_Y_PROMPTS_OPERACIONALES.md
```

Las dos líneas de versión deben transcribir `Versión 5.8` y `Versión 34`. Si alguna
no lo hace, para: la copia local no es la que se cree y la premisa del tramo cae.

Guarda los dos `sha256`. Son la prueba de que el archivo repuesto en el §6 es
byte a byte el mismo que se preservó aquí.

---

## 5. Integración

```bash
git fetch origin
git merge origin/main --no-edit
```

`fetch` está permitido en este tramo, a diferencia del A: aquí la integración es el
objetivo, no un efecto colateral que contamine una medición.

**Resultado anticipado:** conflicto `modify/delete` en los dos normativos modificados.
`CLAUDE.md` no está modificado en este árbol (verificado en el tramo A), así que su
borrado se aplica limpio y sin conflicto.

Reporta `git status` completo antes de resolver. Si aparece cualquier conflicto fuera
de los dos anticipados, **D2**.

### 5.1 Resolución

Se acepta el borrado, que es la decisión de cartera:

```bash
git rm 50_documentacion/activa/POLITICA_PROYECTO.md
git rm 50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md
git status --porcelain
git commit --no-edit
```

`git rm` sobre un conflicto `modify/delete` resuelve aceptando la eliminación y quita
el archivo del disco. Por eso el §4 va antes: sin esa copia, la v5.8 y la v34 locales
se perderían en esta línea.

Verifica antes del `commit` que no queda ningún archivo en estado `U`.

---

## 6. Reponer los normativos como archivos ignorados

```bash
grep -n 'POLITICA_PROYECTO.md\|SETTINGS_Y_PROMPTS_OPERACIONALES.md\|CLAUDE.md' .gitignore
```

Las tres líneas deben estar presentes. Si falta alguna, **D3**.

```bash
cp /tmp/normativos_v58_v34/POLITICA_PROYECTO.md 50_documentacion/activa/
cp /tmp/normativos_v58_v34/SETTINGS_Y_PROMPTS_OPERACIONALES.md 50_documentacion/activa/
shasum -a 256 50_documentacion/activa/POLITICA_PROYECTO.md \
              50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md
git check-ignore -v 50_documentacion/activa/POLITICA_PROYECTO.md \
                    50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md
git status --porcelain
```

Condiciones, todas obligatorias:

1. Los dos `sha256` son idénticos a los del §4.
2. `check-ignore` devuelve las dos rutas, citando la línea del `.gitignore` que las
   ignora.
3. `status --porcelain` sale **vacío**. Los archivos existen en disco, git no los ve.

`CLAUDE.md` **no** se repone desde este árbol: su copia local es idéntica a la versión
del remoto que `2dbb0b3` dejó en v3, y la knowledge base tiene una posterior. Su
reposición es tarea manual del titular, y va en el reporte como tal.

---

## 7. Verificación de la integración

```bash
git log --oneline -3
git rev-list --left-right --count origin/main...HEAD
git status --porcelain
git stash list | wc -l
ls -la .Rprofile renv.lock 2>/dev/null
ls 50_documentacion/activa/
git log --oneline --all --source -- 50_documentacion/traspasos/traspaso_cierre_v11.md
```

Condiciones:

1. `rev-list --left-right --count` devuelve `0` a la izquierda: ya no hay nada del
   remoto sin integrar.
2. `status --porcelain` vacío.
3. `stash list` sigue en 1.
4. `.Rprofile` y `renv.lock` existen en la raíz.
5. `50_documentacion/activa/` contiene los dos normativos repuestos y **no** contiene
   `CLAUDE.md` (ese vive en la raíz, no aquí).
6. El último comando confirma que `traspaso_cierre_v11.md` sigue siendo alcanzable
   desde alguna referencia. Es la comprobación de que el merge no deshizo el tramo A.

---

## 8. Push de `main`

Solo si las seis condiciones del §7 pasan:

```bash
git push origin main
git ls-remote --heads origin main
git rev-parse HEAD
```

Los dos últimos SHA deben coincidir. Sin `--force`.

Si alguna condición del §7 falló, **no pushees**: reporta y detente. El árbol local es
recuperable con `git reset --hard 1b478b8`, y esa decisión es del titular.

---

## 9. Limpieza

```bash
rm -rf /tmp/normativos_v58_v34
```

Solo después de que el §6 haya verificado los dos `sha256` y el §8 haya coincidido.
Nunca antes.

La rama `rescate/20260824` **se conserva**, local y remota. Su borrado es decisión del
titular en una sesión posterior, cuando el merge lleve tiempo estable.

---

## 10. Mensaje final

Máximo quince líneas:

- Diagnóstico de `renv`: versión de R del lockfile contra la instalada, número de
  paquetes, si existe biblioteca local.
- Estado inicial: `HEAD`, líneas de `status`, `stash`.
- Los dos `sha256` del §4 y su coincidencia en el §6.
- Conflictos aparecidos y cuáles se resolvieron por `git rm`.
- Resultado de `check-ignore` sobre los dos normativos.
- Las seis condiciones del §7 con su resultado.
- SHA de `ls-remote` y de `HEAD`, y si coinciden.
- Confirmación de que `rescate/20260824` sigue en `origin`.

Y una línea final, que es la única acción manual que queda: que el titular reponga
`CLAUDE.md` en la raíz desde la knowledge base, y que abra R en esta raíz para que
`renv` haga su primera activación antes de correr `run_all()`.
