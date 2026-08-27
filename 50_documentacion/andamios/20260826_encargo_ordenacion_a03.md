# Encargo A-03 — Ordenación del repositorio

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Raíz:** `~/Projects/slep_estado_proyectos_monitoreo`
- **Sesión:** 13 (CONTINUATION)
- **Protocolo:** SETTINGS §4.7. **Cubre:** O-03, O-13, O-19.
- **Rama:** `ordenacion/20260826`. Termina en **PR**, nunca en merge.

---

## 1. Lo que el relevamiento cambió respecto del plan

El inventario de la sesión 12 declaraba 12 traspasos a la vista. Es falso: `traspasos/`
ya está ordenado, con `archivo/` conteniendo v01 a v11 y solo `v12` a la vista (fuente:
relevamiento de solo lectura, bloques 2 y 4, sesión 13). El bloque 1 del protocolo queda
reducido a una aserción de verificación.

A cambio, el bloque 4 tiene trabajo real que el plan no anticipaba: `EXCLUIR_DIRS` del
escáner es `c(".git", ".Rproj.user", "renv", ".quarto")` y POLITICA §7.2 exige además
`node_modules`, `packrat` y `venv`. Hoy el proyecto no tiene ninguno de los tres, así que
los totales publicados no están inflados, pero la guarda no está.

---

## 2. Precondiciones bloqueantes (§4.7.1)

```bash
cd ~/Projects/slep_estado_proyectos_monitoreo
git status --porcelain      # vacío
git stash list              # vacío
git rev-list --left-right --count @{u}...HEAD   # 0	0
git rev-parse --abbrev-ref HEAD                 # main, antes de crear la rama
```

**Dos cosas hay que despejar antes, y son parte de este encargo:**

1. Los dos encargos untracked de la sesión 13
   (`20260826_encargo_diagnostico_a05.md` y `20260826_encargo_correccion_frente_a.md`) se
   commitean en `main` **antes** de crear la rama:
   ```
   docs(andamios): encargos de diagnostico y correccion del frente A
   ```
2. `stash@{0}` (rotación obsoleta de snapshots del 2026-06-29, superada por las corridas
   del 24 y del 26): exportar y descartar.
   ```bash
   git stash show -p stash@{0} > /tmp/stash0_20260826.patch && \
     git stash drop stash@{0} && git stash list
   ```
   El parche queda en `/tmp` y **no** entra al repositorio: es respaldo de una reversión
   improbable, no documentación.

Recién con `status` y `stash list` vacíos se crea `ordenacion/20260826`.

---

## 3. Bloque 1 — Traspasos (verificación, sin movimientos)

Nada que mover. Verificar y transcribir:

```bash
ls -1 50_documentacion/traspasos/*.md        # una sola línea: traspaso_cierre_v12.md
ls -1 50_documentacion/traspasos/archivo/*.md | wc -l   # 11
```

Si `ls` devuelve más de una línea, **detente**: significa que algo cerró entre el
relevamiento y la ejecución, y la cartera está en producción permanente (A24).

**Normativos:** el bloque 1 del protocolo manda actualizar las copias de
`POLITICA_PROYECTO.md` y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` en `activa/` desde la
knowledge base. Aquí **no aplica como está escrito**: la sesión 12 decidió no versionarlos
en este repositorio y `git ls-files` devuelve vacío para los dos (fuente: bloque 7 del
relevamiento). Manda la decisión de gobernanza. Verificar en disco que son v5.8 y v34,
transcribir las dos líneas de versión, y **no commitear ninguno**.

Sin commit.

---

## 4. Bloque 2 — Obsoletos, a `_archivo/20260826/`

`_archivo/` no existe: se crea, conservando la ruta relativa de cada archivo movido
(POLITICA 1.5). Nada se borra.

| Archivo | Grado | Fundamento | Grep de referencias vivas |
|---|---|---|---|
| `50_documentacion/activa/esbozo_fase2_estado_estandarizado.md` | **Alto** | Es el boceto de la Fase 2, que está implementada: el backlog registra la categoría "Arquitectura Fase 2 (ESTADO.md)" con diseño PUSH/PULL, propagación a 13 hermanos y lector con fallback | Ninguna viva. Las apariciones son snapshots del escáner (regenerables), traspasos (histórico) y `andamios/` (congelado, no cancela la fila) |
| `50_documentacion/activa/reporte_cobertura_documental.md` | **Medio** | Último commit 2026-06-29. La cobertura documental hoy la miden el panorama y el censo, pero **ningún documento lo declara superado**, así que no es grado alto | Ninguna viva, mismo desglose. Grep obligatorio ya ejecutado en el relevamiento |

**Destino:** `_archivo/20260826/50_documentacion/activa/<nombre>.md`, con `git mv`.

**Corrección del grep (v13).** El relevamiento usó `grep -rn ... . | grep -v "^./…"` y el
filtro no descartó nada, porque `grep -rn .` emite rutas **sin** el prefijo `./`. Al
re-verificar antes de mover, usar la forma del protocolo:
`grep -rn --exclude-dir=_archivo --exclude-dir=.git --exclude-dir=andamios "<nombre>" .`

**Regla de cancelación:** si el grep devuelve una referencia viva (fuera de
`estructura/`, `traspasos/` y `andamios/`), la fila **se cancela y se reporta**. No se
mueve y no se arregla la referencia en el mismo paso.

**Commit:**
```
chore(ordenacion): archiva dos documentos superados de activa/

Bloque 2 de SETTINGS 4.7. Esbozo de Fase 2 (implementada) y reporte de cobertura
(hoy lo miden el panorama y el censo). Cierra O-13.
```

---

## 5. Bloque 3 — Nomenclatura (sin renombres)

O-13 nombraba dos archivos de `activa/` sin prefijo `50_`. **Los dos son exactamente los
del bloque 2**, así que archivarlos cierra el pendiente y no queda nada que renombrar:
renombrar un documento superado para dejarlo en `activa/` sería la corrección equivocada.

Verificar que no queda ningún otro archivo fuera de patrón:

```bash
find 50_documentacion/activa -maxdepth 1 -type f -name "*.md" | sort
```

Esperado: `50_locale_utf8.md`, `ESTADO.md`, `backlog_acumulativo.md`, más los dos
normativos ignorados. Los cuatro últimos son excepciones declaradas por POLITICA §2.
`decisiones/` sigue su propia convención `YYYYMMDD_decision_<tema>.md`, fijada por
POLITICA (líneas 196 y 344): **no se toca**.

**O-19** (`andamios/design_handoff_monitoreo_cartera/Panorama de cartera.dc.html`, con
espacios): **no se renombra**. `andamios/` está congelado por POLITICA 1.2 y §4.7.4 lo
prohíbe explícitamente. O-19 se cierra como **excepción declarada**, no como corrección,
y así se registra en el marcador del §8.

Sin commit.

---

## 6. Bloque 4 — Escáner

Añadir `node_modules`, `packrat` y `venv` a `EXCLUIR_DIRS` en `00_escanear_proyecto.R`.
Es el único archivo de código que este encargo toca, y el protocolo lo autoriza
nominalmente; `30_procesamiento/` y `10_utils/` siguen prohibidos.

**Declaración obligatoria del total antes y después.** Correr el escáner con la lista
vieja y con la nueva, y transcribir `Directorios` y `Archivos` de las dos corridas. Si
son idénticos, **dilo**: significa que el proyecto no tiene hoy ninguno de los tres
directorios y que la corrección es preventiva, no correctiva. Un bloque 4 que no declara
sus dos cifras no permite distinguir esos dos casos.

**Commit:**
```
fix(escaner): excluye node_modules, packrat y venv del barrido

Bloque 4 de SETTINGS 4.7 y POLITICA 7.2. Preventivo: hoy ninguno existe en el arbol.
```

---

## 7. Verificaciones antes de cada commit (§4.7.3 punto 5)

```bash
grep -rlnE "[0-9]{7,8}-[0-9kK]" 50_documentacion/ || echo "sin patron RUT"
grep -rln "Co-authored-by\|Generated with" 50_documentacion/
```

El segundo devuelve `20260824_encargo_rescate_tramo_a.md`, y es **falso positivo
confirmado**: la línea 147 de ese archivo es el propio patrón de búsqueda citado dentro
de un encargo, no un trailer real (fuente: bloque 3 del segundo relevamiento). Declararlo
y seguir. Cualquier hit distinto de ese detiene.

---

## 8. Entrega (§4.7.3)

1. **Manifiesto:** `git hash-object` de cada archivo movido, con origen y destino.
2. **Log de greps:** el resultado de cada uno, **incluidas las filas canceladas**. Si no
   hubo ninguna cancelada, se declara explícitamente: una ejecución sin cancelaciones no
   es limpia por definición, es una ejecución que hay que mirar dos veces.
3. **Escáner al final**, ya con la lista nueva.
4. **Marcador**, último commit:
   `50_documentacion/activa/50_ordenacion_repositorio.md`, con fecha, rama, conteo de
   archivos movidos por bloque, y **las dos excepciones declaradas**: O-19 (nombre con
   espacios dentro de `andamios/`, congelado) y los normativos no versionados. Sin este
   archivo el gatillo 4bis se vuelve a encender en cada apertura.
5. **PR** contra `main`. El merge lo decide el titular.

---

## 9. Qué reportar

Los cuatro bloques con su resultado, el manifiesto, el log de greps, las dos cifras del
escáner (antes y después), los hashes de los commits, la URL del PR, y las premisas de
este encargo que resultaron falsas.

Van siete encargos de esta sesión con premisas corregidas en la ejecución, incluida la
que motivó reescribir este: el plan decía 12 traspasos a la vista y había uno. Si
encuentras otra, corrígela y nómbrala; no la obedezcas.
