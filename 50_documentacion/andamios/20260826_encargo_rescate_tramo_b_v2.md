# Encargo — Rescate, tramo B (v2): integrar el remoto

- **Repo:** `slep_estado_proyectos_monitoreo` (remoto: `tomgc/slep_estado_area_monitoreo`)
- **Raíz:** `/Users/tomgc/Projects/slep_estado_proyectos_monitoreo`
- **Fecha:** 2026-08-26
- **Sesión:** 12
- **Reemplaza a:** `20260824_encargo_rescate_tramo_b.md` (v1), cuya precondición y cuyo
  §4 quedaron inválidos. No lo ejecutes.

---

## 0. Qué cambió respecto de la v1, y por qué importa

La v1 se escribió el 2026-08-24 sobre un árbol que ya no existe. Dos correcciones, y
la segunda es la que evita una pérdida:

1. **La precondición.** La v1 esperaba `HEAD` en `1b478b8` y el árbol con dos archivos
   modificados. Hoy hay un commit encima (`ee7348f wip(checkpoint)`), `main` está
   **ahead 1 y behind 10**, y los traspasos v10 y v11 viven solo en la rama
   `rescate/20260824`.

2. **De dónde se preserva la copia de los normativos.** La v1 copiaba
   `50_documentacion/activa/POLITICA_PROYECTO.md` y
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md` **desde el disco**. Entre medio, el árbol de
   trabajo retrocedió: hoy el disco tiene POLITICA v5.6 y SETTINGS v16, mientras
   `HEAD` conserva v5.8 y v34. Ejecutar la v1 preservaría la copia equivocada y el
   merge borraría la buena. **La copia se extrae de `HEAD`, no del disco.**

Si al llegar al §4 el disco ya fue restaurado desde `HEAD` (`git restore --source=HEAD`),
las dos vías coinciden y el §4.3 lo comprueba en vez de suponerlo.

---

## 1. Qué resuelve y qué no

**Resuelve:** dejar `main` sincronizado con `origin/main`, con el trabajo de las
sesiones 10 a 12 incorporado y los normativos fuera del control de versiones pero
presentes en disco con su contenido vigente.

**No resuelve:** el cierre de la sesión. El paquete `paquete_cierre_v12.md` queda donde
está, sin tocar; el cierre se relanza después, cuando el correlativo de traspasos y la
versión de los normativos ya sean los correctos.

**Decisión de cartera que se acata:** `e24bceb` borra del árbol
`POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md` y `CLAUDE.md`, y los
agrega al `.gitignore`. Los normativos **no se versionan** y **se conservan en disco
como archivos ignorados**. Ignorado no es borrado: Claude Code los sigue leyendo del
filesystem.

**Red de seguridad:** todo el trabajo está publicado en `origin/rescate/20260824`
(`98a4097`). Si este tramo sale mal, ese punto es recuperable. El comando de retroceso
se declara aquí y **no se ejecuta**: `git reset --hard <HEAD_inicial>`.

---

## 2. Contrato

### 2.1 Prohibido

1. `push --force` en cualquier forma y hacia cualquier destino.
2. `rebase`. La integración es por `merge`.
3. Borrar, mover o modificar la rama `rescate/20260824`, local o remota.
4. `git stash` en cualquiera de sus formas.
5. Ejecutar R, `Rscript`, `run_all()` o cualquier script del pipeline.
6. `renv::restore()`, `renv::init()` o cualquier escritura sobre la biblioteca de
   paquetes.
7. `git add -A`, `git add .`, y cualquier `add` sin ruta explícita.
8. Tocar `50_documentacion/andamios/paquete_cierre_v12.md`.
9. Resolver un conflicto distinto de los anticipados en el §6. Cualquier otro activa
   **D3**.

### 2.2 Reglas de detención

- **D1.** El §3 encuentra un estado que no calza con lo descrito y la diferencia **no**
  es una de las dos toleradas que ahí se declaran. Para y reporta.
- **D2.** El §4 no logra extraer de `HEAD` un `POLITICA_PROYECTO.md` cuya línea de
  versión transcriba `5.8`, y un `SETTINGS_Y_PROMPTS_OPERACIONALES.md` que transcriba
  `34`. Para: sin esa copia, el merge pierde el marco normativo vigente y no hay de
  dónde reponerlo dentro del repo.
- **D3.** El merge produce conflicto en un archivo que no sea uno de los tres
  normativos. Para **sin abortar**, reporta `git status` completo y espera
  instrucción.
- **D4.** Tras el merge, `git check-ignore` no confirma que los tres normativos estén
  ignorados. Para: sin el `.gitignore` de `e24bceb`, los archivos repuestos volverían a
  aparecer sin seguimiento en el próximo cierre.
- **D5.** La versión de R declarada en `renv.lock` difiere de la instalada en su
  versión mayor o menor. Para antes de mergear.

---

## 3. Precondiciones

```bash
cd /Users/tomgc/Projects/slep_estado_proyectos_monitoreo
git rev-parse HEAD
git rev-parse --abbrev-ref HEAD
git status --porcelain
git stash list | wc -l
git rev-list --count origin/main..HEAD
git rev-list --count HEAD..origin/main
git ls-remote --heads origin rescate/20260824
git branch --list rescate/20260824
```

| Comprobación | Esperado | Si difiere |
|---|---|---|
| rama | `main` | D1 |
| `HEAD` | un commit cuyo padre sea `1b478b8`, es decir `ee7348f` o su equivalente | D1 |
| adelante | `1` | D1 |
| detrás | `10` | tolerado si es mayor: el remoto siguió avanzando. Declararlo y continuar |
| `status --porcelain` | vacío, o con archivos sin seguimiento en `50_documentacion/andamios/` | tolerado. Cualquier archivo **modificado** activa D1 |
| `stash list` | cualquier número | se registra y no se toca |
| `rescate/20260824` en `origin` | existe | D1: sin red de seguridad no se integra |

Guarda `HEAD` inicial como `HEAD_INICIAL`. Es el punto de retroceso.

**Las dos diferencias toleradas** están declaradas arriba a propósito: el remoto puede
haber avanzado más de diez commits desde que se midió, y los andamios de la sesión 12
pueden estar sin seguimiento. Ninguna de las dos cambia la naturaleza de la operación.
Cualquier otra sí.

---

## 4. Preservar los normativos, desde `HEAD`

```bash
mkdir -p /tmp/normativos_vigentes
git show HEAD:50_documentacion/activa/POLITICA_PROYECTO.md \
  > /tmp/normativos_vigentes/POLITICA_PROYECTO.md
git show HEAD:50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md \
  > /tmp/normativos_vigentes/SETTINGS_Y_PROMPTS_OPERACIONALES.md
git show HEAD:CLAUDE.md > /tmp/normativos_vigentes/CLAUDE.md 2>/dev/null \
  || echo "CLAUDE.md no esta en HEAD: se declara y no se repone"
```

### 4.1 Verificación de que la copia es la buena (activa D2 si falla)

```bash
grep -m1 -i 'versi' /tmp/normativos_vigentes/POLITICA_PROYECTO.md
grep -m1 -i 'versi' /tmp/normativos_vigentes/SETTINGS_Y_PROMPTS_OPERACIONALES.md
shasum -a 256 /tmp/normativos_vigentes/*.md
wc -l /tmp/normativos_vigentes/*.md
```

La primera línea debe transcribir `Versión 5.8`; la segunda, `Versión 34`. Guarda los
`sha256`: son la prueba de que lo repuesto en el §7 es byte a byte lo preservado aquí.

### 4.2 Contraste con el disco (informativo, no detiene)

```bash
grep -m1 -i 'versi' 50_documentacion/activa/POLITICA_PROYECTO.md
grep -m1 -i 'versi' 50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md
```

Si el disco transcribe versiones **anteriores** a las de `HEAD`, declara la
discrepancia en el reporte. Es el síntoma de la regresión que motivó esta v2 y su
registro importa aunque ya esté corregida. No detiene: la copia preservada viene de
`HEAD`, no del disco.

---

## 5. Diagnóstico de `renv` (solo lectura, antes de integrar)

```bash
git show origin/main:.Rprofile
git show origin/main:renv.lock | head -20
git show origin/main:renv.lock | grep -c '"Package"'
R --version | head -1
ls -d renv 2>/dev/null || echo "sin directorio renv local"
```

Compara la versión de R del lockfile contra la instalada. Distintas en mayor o menor:
**D5**. Iguales: continúa y declara en el reporte cuántos paquetes tendrá que restaurar
el titular.

---

## 6. Integración

```bash
git fetch origin
git merge origin/main --no-edit
git status
```

**Conflicto anticipado:** `modify/delete` en los normativos. `HEAD` los tiene
modificados respecto del ancestro común y `e24bceb` los borra. Los tres son
candidatos: `50_documentacion/activa/POLITICA_PROYECTO.md`,
`50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` y `CLAUDE.md`.

Reporta `git status` completo **antes** de resolver. Cualquier conflicto fuera de esos
tres activa **D3**.

### 6.1 Resolución: se acepta el borrado

```bash
git rm 50_documentacion/activa/POLITICA_PROYECTO.md
git rm 50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md
git rm CLAUDE.md          # solo si aparece en conflicto
git status --porcelain
git commit --no-edit
```

Verifica antes del `commit` que no queda ningún archivo en estado `U`.

`git rm` resuelve el conflicto aceptando la eliminación **y borra el archivo del
disco**. Por eso el §4 va antes: sin esa copia, la v5.8 y la v34 se pierden.

---

## 7. Reponer los normativos como archivos ignorados

```bash
grep -n 'POLITICA_PROYECTO.md\|SETTINGS_Y_PROMPTS_OPERACIONALES.md\|CLAUDE.md' .gitignore
```

Las tres líneas deben estar. Si falta alguna, **D4**.

```bash
cp /tmp/normativos_vigentes/POLITICA_PROYECTO.md 50_documentacion/activa/
cp /tmp/normativos_vigentes/SETTINGS_Y_PROMPTS_OPERACIONALES.md 50_documentacion/activa/
[ -f /tmp/normativos_vigentes/CLAUDE.md ] && cp /tmp/normativos_vigentes/CLAUDE.md ./
shasum -a 256 50_documentacion/activa/POLITICA_PROYECTO.md \
              50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md
git check-ignore -v 50_documentacion/activa/POLITICA_PROYECTO.md \
                    50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md
git status --porcelain
```

Condiciones, todas obligatorias:

1. Los `sha256` son idénticos a los del §4.1.
2. `check-ignore` devuelve las rutas citando la línea del `.gitignore` que las ignora.
3. `status --porcelain` no muestra ninguno de los tres normativos, ni modificado ni
   sin seguimiento.

---

## 8. Incorporar los traspasos v10 y v11

Después del merge, `50_documentacion/traspasos/` tendrá como máximo el v09: los v10 y
v11 se commitearon en `f4fc840`, que vive en `rescate/20260824` y no en `main`. Sin
ellos, el correlativo del próximo cierre es v10 y colisiona con el v10 ya existente en
la rama de rescate.

```bash
git merge origin/rescate/20260824 --no-edit
git status
ls 50_documentacion/traspasos/
```

**Conflicto anticipado:** ninguno en los traspasos, que son archivos nuevos. Sí puede
haberlo en `40_salidas/` y en `50_documentacion/estructura/`, porque ambas ramas los
tocaron. Resolución declarada: **prevalece la versión de `main` tras el merge del
remoto** (`git checkout --ours <ruta>`), porque las salidas se regeneran y el retrato
del escáner se rehace en el cierre. Cualquier conflicto fuera de esos dos directorios
activa **D3**.

Verificación: `ls 50_documentacion/traspasos/` incluye `traspaso_cierre_v10.md` y
`traspaso_cierre_v11.md`.

---

## 9. Verificación de la integración

```bash
git log --oneline -5
git rev-list --left-right --count origin/main...HEAD
git status --porcelain
ls -la .Rprofile renv.lock 2>/dev/null
ls 50_documentacion/activa/
ls 50_documentacion/traspasos/
```

Condiciones:

1. `rev-list --left-right --count` devuelve `0` a la izquierda: nada del remoto sin
   integrar.
2. `status --porcelain` sin archivos modificados ni normativos visibles.
3. `.Rprofile` y `renv.lock` existen en la raíz.
4. `50_documentacion/activa/` contiene los dos normativos repuestos e ignorados.
5. `50_documentacion/traspasos/` contiene los traspasos hasta el v11.

---

## 10. Push de `main`

Solo si las cinco condiciones del §9 pasan:

```bash
git push origin main
git ls-remote --heads origin main
git rev-parse HEAD
```

Los dos últimos SHA deben coincidir. Sin `--force`. Si alguna condición falló, **no
pushees**: reporta y detente.

---

## 11. Limpieza

```bash
rm -rf /tmp/normativos_vigentes
```

Solo después de que el §7 verificara los `sha256` y el §10 coincidiera. Nunca antes.

La rama `rescate/20260824` **se conserva**, local y remota.

---

## 12. Mensaje final

Máximo quince líneas:

- Estado inicial: `HEAD_INICIAL`, rama, adelante, detrás, líneas de `status`, stash.
- Diagnóstico de `renv`: versión de R del lockfile contra la instalada, paquetes.
- Las dos líneas de versión extraídas de `HEAD` en el §4.1, transcritas literales.
- La discrepancia del §4.2 con el disco, si la hubo.
- Conflictos aparecidos en cada uno de los dos merges y cómo se resolvieron.
- Resultado de `check-ignore` sobre los normativos.
- Las cinco condiciones del §9 con su resultado.
- Contenido de `50_documentacion/traspasos/` tras el §8.
- SHA de `ls-remote` y de `HEAD`, y si coinciden.

Y una línea final: que el cierre de la sesión 12 debe relanzarse con un paquete nuevo,
porque el correlativo de traspasos y la versión de los normativos cambiaron con este
tramo.
