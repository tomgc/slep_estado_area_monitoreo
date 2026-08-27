# Encargo A-17 — Censo de backlogs de la cartera contra sus traspasos vigentes

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Raíz de ejecución:** `~/Projects/slep_estado_proyectos_monitoreo`
- **Universo medido:** `~/Projects/slep_*`
- **Sesión:** 13 (CONTINUATION)
- **Origen:** duda 6 de la compuerta de cierre de la sesión 12.
- **Naturaleza:** **solo lectura** sobre los hermanos. La única escritura ocurre dentro
  del repositorio propio, en `50_documentacion/andamios/`.

---

## 1. La pregunta que este encargo responde

La sesión 12 descubrió que las entradas 55 a 61 del backlog propio nunca llegaron a git
y son irrecuperables. La pregunta abierta es si eso fue un accidente de un repositorio o
un patrón de la cartera entera. La diferencia decide la prioridad de todo lo que viene:
si es un patrón, proteger la memoria de los hermanos manda sobre automatizar su
publicación, y la ruta del comando único se reordena.

El encargo **mide y no corrige**. No escribe en ningún hermano, no crea `ESTADO.md`
faltantes, no repara backlogs. Un censo que además arregla deja de ser una línea base.

---

## 2. Precondición verificable

```bash
cd ~/Projects/slep_estado_proyectos_monitoreo && \
  git status --porcelain && echo "--- fin status ---" && \
  git rev-parse --abbrev-ref HEAD && \
  ls -d ~/Projects/slep_* | wc -l
```

**Regla de detención:** si la rama no es `main`, detente. Si `status --porcelain` devuelve
líneas que **no sean** los artefactos de este encargo, detente y nómbralas. Si el conteo
de directorios es menor a 20, detente: significa que el universo no es el que este
encargo espera medir y seguir produciría una línea base falsa.

---

## 3. Prohibiciones explícitas, no negociables

Sobre cualquier directorio distinto de `~/Projects/slep_estado_proyectos_monitoreo`:

- **Nada de `git fetch`, `pull`, `add`, `commit`, `checkout`, `stash`, `gc` ni `prune`.**
  `fetch` escribe referencias remotas y **cuenta como escritura** en un repo ajeno.
- Solo se permiten lecturas del árbol de trabajo (`cat`, `grep`, `ls`, `head`, `wc`) y
  consultas locales de git que no muten nada: `git status --porcelain`,
  `git log --oneline`, `git rev-parse`, `git ls-files`, `git branch --show-current`.
- No crear, mover ni borrar archivos fuera de `50_documentacion/andamios/` del repo
  propio.

Si un hermano no tiene `.git`, se mide igual por sistema de archivos y se clasifica como
`sin_git`. No es un error: es un dato (D-05 lo dejó fuera del universo del paso 1, pero
sigue siendo un directorio con documentación que puede tener backlog).

---

## 4. La trampa que este encargo tiene que evitar

El backlog propio **no numera con `### <n>`**: el `grep -oE '^### [0-9]+'` de la apertura
devolvió cero líneas sobre un archivo que sí tiene entradas (fuente: bloque 3 de la
verificación de apertura, sesión 13). Si el censo asume una convención de numeración,
va a reportar "0 entradas" en cada repo que numere distinto, y eso se lee como pérdida
masiva cuando en realidad es un patrón de grep mal elegido. Sería una respuesta
segura de verdad, que es la peor clase de respuesta.

Por eso la convención **se descubre por repo** y se declara en el reporte. Para cada
backlog encontrado, probar al menos estos patrones y quedarse con el que produzca más
coincidencias:

| Clave | Expresión | Forma |
|---|---|---|
| `h3_num` | `^### +([0-9]+)` | `### 42` |
| `h3_num_punto` | `^### +([0-9]+)\.` | `### 42.` |
| `h2_num` | `^## +([0-9]+)` | `## 42` |
| `tabla` | `^\| *([0-9]+) *\|` | fila de tabla que abre con número |
| `lista_num` | `^ *([0-9]+)\. ` | lista ordenada markdown |
| `id_prefijo` | `^[-*] *\*?\*?([0-9]+)\*?\*?[.):]` | viñeta que abre con número |

Si dos patrones empatan, se declara el empate y se reportan los dos conteos. Si ninguno
supera 3 coincidencias sobre un archivo de más de 50 líneas, la fila se clasifica
`convencion_no_detectada` y **no** como cero entradas.

---

## 5. Qué medir, por repositorio

1. **Localización del backlog.** Buscar, en este orden, `50_documentacion/activa/backlog_acumulativo.md`,
   luego cualquier `**/backlog*.md` fuera de `andamios/` y de `archivo/`. Registrar la
   ruta encontrada o `sin_backlog`.
2. **Localización del traspaso vigente.** Cubrir los dos patrones de nombre,
   `traspaso_cierre_vNN.md` y `traspaso-cierre-vNN.md`, y quedarse con el `NN` mayor.
   Registrar cuántos hay a la vista (I5) y cuál se eligió.
3. **Convención y último número del backlog**, según el §4.
4. **Número declarado en el traspaso.** Buscar en el traspaso vigente la afirmación sobre
   entradas de backlog: patrones como `entrada[s]? *([0-9]+)`, `backlog.*?([0-9]+)`,
   `hasta la ([0-9]+)`, y el rango `([0-9]+) *a *([0-9]+)`. Registrar el número mayor
   encontrado y **la línea literal de donde salió**, truncada a 120 caracteres. Sin la
   línea de origen la cifra no es verificable y no sirve.
5. **Huecos internos.** Con la secuencia de números extraída, listar los faltantes entre
   el mínimo y el máximo. Un backlog que va 1..40, 43..54 tiene un hueco aunque su
   máximo calce con el traspaso.
6. **Instante de medición** por repo, en ISO 8601, y `git status --porcelain | wc -l` como
   indicador de suciedad. La cartera está en producción permanente (A24): una fila medida
   sobre un árbol sucio se marca y no se descarta.

**Clasificación final por repo**, un solo valor:

| Clase | Condición |
|---|---|
| `calza` | máximo del backlog igual o mayor al declarado, sin huecos internos |
| `hueco_interno` | máximo calza pero faltan números intermedios |
| `perdida_declarada` | el traspaso declara un número mayor que el máximo del backlog |
| `convencion_no_detectada` | §4, no se pudo medir |
| `sin_backlog` | no existe archivo de backlog |
| `sin_traspaso` | no hay traspaso vigente contra el cual contrastar |
| `sin_git` | el directorio no es repositorio |

---

## 6. Autotest obligatorio, con dos controles negativos

El censo no se ejecuta sobre la cartera hasta que las seis pruebas siguientes pasen sobre
archivos sintéticos creados en `/tmp`. Transcribir la salida de las seis.

| Caso | Insumo sintético | Resultado esperado |
|---|---|---|
| C1 | Backlog `### 1` a `### 10`, traspaso que declara 10 | `calza`, máximo 10 |
| C2 | Backlog con `### 1..5` y `### 8..10`, traspaso que declara 10 | `hueco_interno`, faltantes 6 y 7 |
| C3 | Backlog `### 1..40`, traspaso que declara 54 | `perdida_declarada`, delta 14 |
| C4 | Backlog numerado como tabla (`\| 12 \|`) hasta 12 | detecta `tabla`, máximo 12, **no** cero |
| C5 (**control negativo**) | Backlog de 200 líneas sin ningún número de entrada | `convencion_no_detectada`, **nunca** `calza` ni máximo 0 |
| C6 (**control negativo**) | Dos traspasos a la vista, `v03` y `v11`, el `v03` declarando 99 | elige `v11`, reporta I5 incumplido, y **no** toma el 99 |

C5 y C6 existen porque son los dos modos en que este censo puede mentir: confundir
"no supe leerlo" con "está vacío", y leer el traspaso equivocado. Si alguno de los dos
falla, el encargo se detiene y no mide la cartera.

---

## 7. Artefactos de salida

Ambos en `50_documentacion/andamios/`, escritos con la utilidad de escritura segura del
proyecto si está disponible:

1. `20260826_censo_backlogs_cartera.md`: reporte con (a) la tabla completa, una fila por
   repositorio, (b) la salida del autotest del §6, (c) el recuento por clase, y (d) el
   veredicto de la duda 6 en un párrafo: patrón de cartera o accidente aislado, con la
   cifra que lo sostiene.
2. `20260826_censo_backlogs_cartera.csv`: línea base reutilizable. Columnas:
   `repo, ruta_backlog, convencion, n_coincidencias, max_backlog, huecos_internos,
   traspaso_vigente, n_traspasos_a_la_vista, declarado_en_traspaso, linea_origen,
   delta, clase, sucio, rama, instante_medicion`.

Codificación UTF-8, separador coma, sin caracteres fuera de ASCII en los nombres de
columna.

---

## 8. Qué reportar en el chat

1. La salida literal de las seis pruebas del §6.
2. El recuento por clase, en tabla.
3. Los repositorios en clase `perdida_declarada` y `hueco_interno`, con su delta y la
   línea literal del traspaso que sostiene la cifra.
4. El veredicto de la duda 6, en dos líneas.
5. El hash del commit que deposita los dos artefactos, verificado en terminal, y la
   confirmación de publicación por `ls-remote` contra `rev-parse HEAD`.
6. Cualquier detención, con la regla que la disparó.

Si una premisa de este encargo resultó falsa al ejecutarlo (como pasó en A-00 con el
paso 32), **nómbrala y corrígela en la ejecución**, no la obedezcas. Una premisa
equivocada del autor no es una instrucción.
