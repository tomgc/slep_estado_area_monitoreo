# Encargo A-00 — Cierre del hueco I8, apertura del candado y retorno a operación

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Raíz:** `~/Projects/slep_estado_proyectos_monitoreo`
- **Sesión:** 13 (CONTINUATION)
- **Origen:** SETTINGS §1.2.8 punto 4 (el candado 0bis falló por `cierre_incompleto`),
  decisión D-01 del inventario `20260824_pendientes_y_encargos.md`, y pendiente O-14.
- **Naturaleza:** escritura en el repositorio propio, autorizada. Ningún repo hermano se
  toca en este encargo.

---

## 1. Por qué existe este encargo

El candado 0bis tiene cuatro condiciones y tres pasan. La que falla es
`cierre_incompleto`, que trae texto en vez de `no`: la sesión 12 cerró declarando que
I8 falla porque `20_insumos/registro_proyectos.csv` está versionado y el paso 1 lo
escribe. SETTINGS §1.2.8 punto 4 prohíbe trabajar antes de cerrar ese hueco. El titular
despachó D-01 con la salida "moverlo a `40_salidas/`", que es la que resuelve las dos
infracciones a la vez (POLITICA §1.3 punto 5, `20_insumos/` es read-only; e I8, ningún
archivo de datos versionado) sin gastar una excepción escrita.

El encargo hace tres cosas, en este orden y en tres commits separados: ejecuta D-01,
abre el candado, y devuelve el pipeline a operación. El orden no es negociable: el
escáner del bloque 3 tiene que retratar el árbol **después** del movimiento, o el
retrato nace viejo, que es exactamente el defecto que esta sesión abre para corregir.

---

## 2. Precondición verificable

Antes de tocar nada, comprobar y transcribir la salida:

```bash
cd ~/Projects/slep_estado_proyectos_monitoreo && \
  git status --porcelain && echo "--- fin status ---" && \
  git rev-list --left-right --count HEAD...origin/main && \
  git rev-parse --abbrev-ref HEAD && \
  ls -la 20_insumos/registro_proyectos.csv
```

**Regla de detención:** si `status --porcelain` devuelve cualquier línea, si el conteo no
es `0	0`, si la rama no es `main`, o si el CSV no existe en `20_insumos/`, **detente y
reporta**. No limpies, no stashes, no integres. Un árbol sucio aquí significa que algo
escribió entre la verificación de apertura y este encargo, y mezclar eso con un `git mv`
hace indistinguible qué movimiento fue cuál.

---

## 3. Alcance de escritura cerrado

Rutas que este encargo puede modificar, y ninguna otra:

- `20_insumos/registro_proyectos.csv` (origen del movimiento)
- `40_salidas/registro_proyectos.csv` (destino)
- `.gitignore`
- Los scripts de `30_procesamiento/` y `10_utils/` que referencien la ruta antigua
- `50_documentacion/activa/ESTADO.md`
- `50_documentacion/estructura/` (lo regenera el escáner)
- `renv/library/` y `renv.lock` si `renv::restore()` los toca

**Exclusión explícita, no es un falso positivo:**
`50_documentacion/andamios/design_handoff_monitoreo_cartera/registro_proyectos.csv`
**no se toca**. Los andamios están congelados por POLITICA §1.3 punto 7 y sus rutas
internas no se reescriben jamás. Si un grep lo devuelve, se ignora y se declara.

Si encuentras una referencia a la ruta antigua fuera de la lista de arriba (por ejemplo
en `.github/workflows/pages.yml`, en `tests/` o en `CLAUDE.md`), **no la edites**:
detente, nómbrala y reporta. Ampliar el alcance en caliente es el error de alcance que
ya costó un aborto en la sesión 11.

---

## 4. Bloque 1 — Ejecución de D-01

1. Mover con historial:
   ```bash
   cd ~/Projects/slep_estado_proyectos_monitoreo && \
     git mv 20_insumos/registro_proyectos.csv 40_salidas/registro_proyectos.csv
   ```
   `git mv` y nunca `cp` más `rm`: rompería `git log --follow`.

2. Sacarlo del control de versiones conservándolo en disco:
   ```bash
   git rm --cached 40_salidas/registro_proyectos.csv
   ```

3. Agregar al `.gitignore`, al final, con su comentario de una línea:
   ```
   # Registro de proyectos: lo escribe el paso 1 en cada corrida (D-01, sesion 13).
   # Es destino del pipeline, no fuente (A21). No se versiona: I8.
   40_salidas/registro_proyectos.csv
   ```

4. Localizar **todas** las referencias a la ruta antigua y actualizarlas:
   ```bash
   grep -rn "20_insumos/registro_proyectos\|registro_proyectos.csv" \
     --include="*.R" --include="*.yml" --include="*.md" . \
     | grep -v "^./50_documentacion/andamios/"
   ```
   Actualiza solo los archivos de `30_procesamiento/` y `10_utils/`. Si la ruta está
   construida desde una constante (por ejemplo en `10_utils/10_configuracion.R`), se
   corrige **la constante** y no cada uso: un valor en un lugar.

5. **Guarda de ausencia en el lector.** El paso 32 lee el CSV y a partir de ahora el
   archivo puede no existir en un clon nuevo. Añadir en el punto donde se lee una
   comprobación explícita que, si el archivo falta, **detenga con un mensaje que nombre
   la causa y el remedio** (correr el paso 1 primero). No inventes un fallback que
   devuelva una tabla vacía: un descubrimiento vacío que no aborta produce un panorama
   verde y equivocado, que es peor que un error (A25).

6. Regenerar el CSV para dejar el disco coherente:
   ```bash
   Rscript -e 'source("00_run_all.R"); run_all(only = 1)'
   ```
   Si esto falla por paquetes faltantes, **salta a la nota del §6** y ejecuta el bloque 3
   antes de volver a este punto. Es la única reordenación permitida.

**Control negativo obligatorio.** Antes de commitear, comprobar que el cambio hace lo que
dice y no otra cosa:

```bash
# (a) Cero referencias vivas a la ruta antigua en codigo:
grep -rn "20_insumos/registro_proyectos" --include="*.R" --include="*.yml" . \
  | grep -v "^./50_documentacion/andamios/" ; echo "salida vacia = PASA"
# (b) El archivo ya no esta versionado:
git ls-files | grep -c "registro_proyectos.csv" ; echo "0 fuera de andamios = PASA"
# (c) El archivo SI existe en disco:
ls -la 40_salidas/registro_proyectos.csv
# (d) El ignore lo cubre:
git check-ignore -v 40_salidas/registro_proyectos.csv
```

Si (b) devuelve una línea que corresponde al andamio congelado, eso **pasa**: nómbralo.

**Commit 1:**
```
refactor(insumos): registro_proyectos.csv pasa a 40_salidas y deja de versionarse

D-01: es destino del pipeline, no fuente. Resuelve I8 y POLITICA 1.3 punto 5.
```

---

## 5. Bloque 2 — Apertura del candado

Editar `50_documentacion/activa/ESTADO.md`, **solo estos tres campos** y nada más:

- `cierre_incompleto:` pasa a `no`.
- `sesion_abierta:` pasa a `true`.
- `maquina:` conserva `macbook-titular` (verifica que sea la estación actual; si no lo
  es, **detente**: un `sesion_abierta: true` con otra máquina es la condición que este
  campo existe para detectar).

`sesion_actual` se queda en `v12` y `traspaso_vigente` en `traspaso_cierre_v12.md`: el
traspaso vigente sigue siendo el de la sesión 12 hasta que la 13 cierre. No los toques.
Los tres bloques de prosa (`En que vamos`, `Proximo paso`, `Bloqueantes`) tampoco se
tocan en este encargo: se reescriben al cierre.

**Commit 2:**
```
chore(estado): abre sesion 13 y cierra el hueco de cierre_incompleto

El hueco declarado al cierre de la s12 era I8, resuelto por D-01 en el commit anterior.
```

Pushear los dos commits juntos y verificar publicación:
```bash
git push origin main && git ls-remote --heads origin main && git rev-parse HEAD
```
Los dos hashes tienen que coincidir. Un commit no está publicado hasta que coinciden
(A29).

---

## 6. Bloque 3 — Retorno a operación (O-14 e I7)

1. Restaurar la biblioteca:
   ```bash
   cd ~/Projects/slep_estado_proyectos_monitoreo && \
     Rscript -e 'renv::restore(prompt = FALSE)'
   ```
   `renv/library` ya existe pero está incompleta: el escáner abortó con
   `no hay paquete llamado 'rprojroot'`. Transcribe la salida completa, incluidos los
   paquetes que instale y los que ya estuvieran.

2. Verificar que la causa concreta del fallo desapareció:
   ```bash
   Rscript -e 'cat(as.character(requireNamespace("rprojroot", quietly = TRUE)), "\n")'
   Rscript -e 'renv::status()'
   ```

3. Correr el escáner:
   ```bash
   Rscript 00_escanear_proyecto.R
   ```

4. Comprobar que el retrato es nuevo y que refleja el movimiento del bloque 1:
   ```bash
   grep -m1 "Fecha" 50_documentacion/estructura/estructura_actual.md
   grep -n "registro_proyectos" 50_documentacion/estructura/estructura_actual.md
   ```
   La fecha tiene que ser de hoy y el CSV tiene que aparecer bajo `40_salidas/` y no bajo
   `20_insumos/`. Si aparece en los dos, el `git mv` dejó copia y hay que detenerse.

5. Poda de `estructura/` por retención 2 (POLITICA §7.4) si el escáner no la hace solo.

**Commit 3:**
```
chore(estructura): escaner regenerado tras renv::restore

Cierra O-14 e I7. Primer retrato posterior al cierre de la sesion 12.
```

Pushear y verificar con `ls-remote` igual que en el bloque 2.

**No corras `run_all()` completo.** Los pasos 2 a 6 arrastran las tres degradaciones
medidas (`data.js`, `estado_proyecto`, desync por `mtime`) y su diagnóstico es otro
encargo. La única corrida autorizada aquí es `run_all(only = 1)` del bloque 1.

---

## 7. Criterio de éxito, medible

El encargo está completo cuando las nueve líneas siguientes se pueden transcribir:

| # | Comprobación | Criterio |
|---|---|---|
| 1 | `git ls-files \| grep registro_proyectos.csv` | Solo la copia del andamio congelado, o nada |
| 2 | `ls 40_salidas/registro_proyectos.csv` | Existe |
| 3 | `git check-ignore -v 40_salidas/registro_proyectos.csv` | Devuelve la línea del `.gitignore` |
| 4 | `grep -rn "20_insumos/registro_proyectos" --include="*.R" .` | Vacío |
| 5 | `grep -E "^(cierre_incompleto\|sesion_abierta):" 50_documentacion/activa/ESTADO.md` | `no` y `true` |
| 6 | `git status --porcelain` | Vacío |
| 7 | `git rev-list --left-right --count HEAD...origin/main` | `0	0` |
| 8 | `grep -m1 "Fecha" .../estructura_actual.md` | Fecha de hoy |
| 9 | `Rscript -e 'renv::status()'` | Sin paquetes faltantes |

---

## 8. Qué reportar

Una tabla con las nueve filas del §7 y su resultado, los tres hashes de commit (40 hex,
verificados en terminal), la salida literal del control negativo del §4, y la salida
completa de `renv::restore()`. Si algo se detuvo, la regla que lo detuvo y el estado
exacto en que quedó el árbol.

Si encontraste una referencia fuera del alcance del §3, nómbrala aunque no la hayas
tocado. Un hueco declarado vale; un hueco silencioso no.
