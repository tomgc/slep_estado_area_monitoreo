# Encargo — A-02: reconstrucción del backlog, entradas 55 a 67

- **Repo:** `slep_estado_proyectos_monitoreo`
- **Raíz:** `/Users/tomgc/Projects/slep_estado_proyectos_monitoreo`
- **Fecha:** 2026-08-26
- **Sesión:** 12
- **Depende de:** tramo B completado (`main` en `1c74ad0`, estado `0 0`, traspasos v01
  a v11 presentes).

---

## 0. Qué resuelve

`50_documentacion/activa/backlog_acumulativo.md` llega a la entrada **54**. Las
entradas **55 a 67** están escritas dentro de los traspasos v07 a v11 y nunca se
volcaron al archivo. El backlog es la memoria de largo plazo del proyecto y hoy le
faltan cinco sesiones.

Esto se arregla **en este cierre y no después**: SETTINGS §2.2.5 declara que un backlog
que no está donde debe estar es parte del cierre en curso, no un pendiente que se
hereda. Y hay una razón operativa inmediata: el instrumento de cierre exige que el
tramo de entradas nuevas empiece en `ultimo_previo + 1`. Con el archivo en 54 y las
entradas de la sesión 12 numeradas desde 68, el cierre se detiene. Reconstruir cierra
esa brecha en vez de pedirle al instrumento que la tolere.

**No es una tarea de redacción.** Las entradas ya están escritas por quien cerró cada
sesión. Este encargo las **traslada**, no las reformula.

---

## 1. Contrato

### 1.1 Invariantes candados

1. **Un solo archivo escrito:** `50_documentacion/activa/backlog_acumulativo.md`.
   Ningún otro byte del disco cambia.
2. **Cero git mutante.** Sin `add`, `commit`, `push`, `merge`, `checkout`, `stash`,
   `rm`, `mv`. El commit lo hace el cierre, no este encargo.
3. **Cero reformulación.** El texto de cada entrada se traslada tal como está en su
   traspaso de origen. Se permite exclusivamente: reajustar el sangrado y el ancho de
   línea al del archivo destino, y nada más. Prohibido resumir, corregir ortografía,
   uniformar estilo o "mejorar" una redacción.
4. **Cero invención.** Si una entrada del rango no aparece en ningún traspaso, se
   declara como hueco y **no se rellena**.
5. **No se tocan los traspasos.** Son registro histórico cerrado: se leen, no se
   editan.
6. **Sin datos personales** en lo que se escriba: ningún RUT, correo, nombre de
   persona o de establecimiento que no estuviera ya en el traspaso de origen.

### 1.2 Reglas de detención

- **D1.** El estado inicial no calza con el §2. Para y reporta.
- **D2.** Tras la extracción, el conjunto de números hallados **no** es exactamente
  `{55, ..., 67}`. Para y reporta qué falta y qué sobra. Un backlog con un hueco
  silencioso es peor que uno con un hueco declarado, porque nadie lo busca.
- **D3.** Dos traspasos distintos declaran la **misma** entrada con textos distintos.
  Para y reporta ambos: cuál manda es decisión del titular.
- **D4.** El archivo destino, tras escribirse, no supera las comprobaciones del §5.
  Restaura la copia de respaldo del §3.1 y reporta.

---

## 2. Precondiciones

```bash
cd /Users/tomgc/Projects/slep_estado_proyectos_monitoreo
git rev-parse --abbrev-ref HEAD
git rev-parse --short HEAD
git status --porcelain
ls 50_documentacion/traspasos/
grep -nE "^[0-9]+\." 50_documentacion/activa/backlog_acumulativo.md | tail -3
```

| Comprobación | Esperado | Si difiere |
|---|---|---|
| rama | `main` | D1 |
| `HEAD` | `1c74ad0` | tolerado si es posterior; declararlo |
| `status --porcelain` | sin archivos **modificados**; los `??` de `andamios/` son tolerados | D1 ante cualquier modificado |
| traspasos | v01 a v11 presentes | D1 |
| última entrada del backlog | `54.` | D1 |

**Ojo con el conteo.** Un `grep -c "^[0-9]\+\."` sobre este archivo devuelve **55** y
no 54: cuenta la línea `0.5 / SETTINGS 2.2.15`, que es continuación de la entrada 53 y
empieza con `0.`. El número real de la última entrada se lee del último match, no del
conteo. Cualquier cifra de este encargo se deriva del número de la entrada, nunca de
un conteo de líneas.

---

## 3. Extracción

### 3.1 Respaldo previo

```bash
cp 50_documentacion/activa/backlog_acumulativo.md /tmp/backlog_respaldo_$$.md
shasum -a 256 /tmp/backlog_respaldo_$$.md
```

Guarda la ruta y el hash. Es la vía de retroceso del D4.

### 3.2 Localizar las entradas en cada traspaso

Para cada traspaso de `v07` a `v11`, en orden:

1. Localiza su sección de backlog. El encabezado canónico es el punto 5 de la
   estructura de SETTINGS §2.2, con título que contiene la cadena `Backlog`. Búscalo
   por encabezado (`^#{1,3}.*[Bb]acklog`), nunca por número de línea.
2. Dentro de esa sección, extrae los bloques que empiezan con `^[0-9]{2}\.` y cuyo
   número esté entre 55 y 67.
3. Cada entrada abarca desde su línea de número hasta la línea anterior al siguiente
   número de entrada, o hasta el fin de la sección. Las continuaciones que empiezan con
   dígito (como `0.5 / SETTINGS`) **no** son entradas nuevas: solo lo es una línea cuyo
   número esté en el rango y sea mayor que el último aceptado.
4. Registra, por cada entrada: número, traspaso de origen, número de líneas, y si trae
   etiqueta temática entre corchetes al final.

### 3.3 Comprobaciones de la extracción

- El conjunto de números hallados es exactamente `{55, ..., 67}` → si no, **D2**.
- Ningún número aparece en dos traspasos → si aparece, **D3**.
- Los números son estrictamente crecientes dentro de cada traspaso → si no, declaralo
  en el reporte y continúa.

---

## 4. Escritura

### 4.1 Detalle cronológico

Inserta las trece entradas **al final** de la sección `## Detalle cronologico`,
en orden numérico ascendente, respetando el formato del archivo destino: número, punto,
espacio, texto, y la etiqueta temática entre corchetes al final si el original la
traía.

Inserta **por posición estructural**: localiza el encabezado `## Detalle cronologico` y
el siguiente encabezado de nivel `##`, e inserta antes de ese segundo. Nunca por
coincidencia de cadena de texto.

Si alguna entrada del origen no traía etiqueta temática, **no se la inventes**: déjala
sin etiqueta y anótalo en el reporte.

### 4.2 Resumen estadístico por sesión

La tabla `## Resumen estadistico por sesion` termina hoy en la fila de la sesión 6.
Agrega una fila por cada sesión de la 7 a la 11, con las columnas existentes
(`Sesion`, `Traspasos`, `Cambios`, `Modelo`, `Foco`).

Los valores se leen del traspaso correspondiente:

- `Traspasos`: `vNN`.
- `Cambios`: cuántas entradas aportó esa sesión, contadas de la extracción del §3.
- `Modelo`: el declarado en su sección de identificación; `n/d` si no lo declara.
- `Foco`: el declarado en su sección de identificación, recortado a una línea.

La fila `**Total**` se recalcula: debe quedar en **67**.

### 4.3 Sección `## Delta del backlog`

**No la modifiques en esta corrida.** Su contenido actual es prosa sin filas de tabla, y
el instrumento de cierre v11 espera insertar ahí una fila. Reporta su contenido
literal (§6, punto 5) y espera instrucción. Inventar una estructura de tabla que el
instrumento no espera cambia un problema por otro.

### 4.4 Nota metodológica

Si la sección `## Nota metodologica (permanente)` contiene alguna afirmación sobre la
completitud del backlog que este cambio deja obsoleta, repórtala **literal** y no la
edites. Si no la contiene, dilo y no hagas nada.

---

## 5. Verificación (activa D4 si alguna falla)

```bash
grep -nE "^[0-9]+\." 50_documentacion/activa/backlog_acumulativo.md | tail -3
```

1. La última entrada es **67**.
2. Los números de entrada, extraídos y ordenados, forman la serie continua `1..67` sin
   huecos ni repeticiones. Compruébalo programáticamente, no de vista.
3. Las entradas 1 a 54 quedaron **byte a byte idénticas** a las del respaldo del §3.1.
   Compruébalo extrayendo ese tramo de ambos archivos y comparándolo con `cmp`.
4. La tabla de resumen tiene filas para las sesiones 1 a 11 y su total dice 67.
5. `git status --porcelain` muestra el backlog como **modificado** y ningún otro
   archivo nuevo ni modificado respecto del estado inicial.
6. `git diff --stat` sobre el backlog: solo inserciones y las modificaciones de la fila
   de total. Cero borrados fuera de esa fila.

---

## 6. Reporte final

Máximo quince líneas, más los dos bloques literales que se piden abajo:

1. Estado inicial: rama, `HEAD`, líneas de `status`.
2. Tabla de la extracción: por entrada, su número y su traspaso de origen.
3. Las seis comprobaciones del §5 con su resultado.
4. Entradas sin etiqueta temática, si las hubo.
5. **Literal:** el contenido completo de la sección `## Delta del backlog`, tal como
   está hoy.
6. **Literal:** la afirmación de la nota metodológica que este cambio deja obsoleta, si
   existe.

## 7. Dato adicional que necesito del instrumento

Independiente de este encargo, y solo lectura. Reporta al final, en bloque literal:

```bash
grep -n '<<<\|>>>' "$HERRAMIENTAS_DEV_PATH/prompts/cierre_sesion_autonomo_cc_v11.md" | head -20
sed -n '/front matter/,/^---$/p' "$HERRAMIENTAS_DEV_PATH/prompts/cierre_sesion_autonomo_cc_v11.md" | head -40
grep -n -A15 'BACKLOG_NARRATIVA' "$HERRAMIENTAS_DEV_PATH/prompts/cierre_sesion_autonomo_cc_v11.md" | head -40
```

Si el nombre del archivo no calza, localízalo con `ls "$HERRAMIENTAS_DEV_PATH/prompts/"`
y usa el que corresponda al v11.

**Por qué se pide.** SETTINGS §2.1, que es la única fuente que el redactor del paquete
puede leer, describe el instrumento **v10**: tres bloques, sin delimitadores `<<<`. El
instrumento en disco es el **v11**: cuatro bloques con delimitadores y un bloque
`BACKLOG_NARRATIVA` que la norma no menciona. Esa desincronización es la causa de una
de las cinco detenciones del cierre anterior. No se pide el instrumento como insumo de
redacción: se pide el **contrato** entre paquete e instrumento, que la norma dejó
desactualizado y que sin esto obliga a adivinar.
