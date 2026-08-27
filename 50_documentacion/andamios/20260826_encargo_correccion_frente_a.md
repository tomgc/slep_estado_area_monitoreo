# Encargo A-19 — Corrección del frente A: `data.js`, tres defectos apilados

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Raíz:** `~/Projects/slep_estado_proyectos_monitoreo`
- **Sesión:** 13 (CONTINUATION)
- **Cubre:** O-05. **Se apoya en:** `20260826_diagnostico_campos_perdidos.md`, que es su
  única fuente de premisas. Este encargo no vuelve a diagnosticar.
- **Naturaleza:** primera escritura de código de la sesión. Un solo archivo del pipeline.

---

## 1. Los tres defectos y por qué se corrigen juntos

El diagnóstico estableció que `36_generar_panorama_visual.R` falla en tres puntos y que
ninguna corrección aislada produce salida correcta:

| # | Línea | Defecto | Si se corrige solo |
|---|---|---|---|
| 1 | 38 | La ruta apunta a `~/Projects/slep_monitoreo/data.js`; el origen movió el sitio a `docs/` (commit `00a1af3` del hermano) | El parser falla igual y el síntoma es idéntico: se concluye que la ruta no era el problema |
| 2 | 204 | El saneador quotea siete claves fijas; el origen agregó `id` (commit `15dc047`), así que `fromJSON` falla en las 12 entradas | Sin la ruta, nunca se ejecuta |
| 3 | 64-76 | `MAPEO_ORDEN_SLUG` clava por posición; el origen insertó un proyecto en la 3 y corrió todo lo posterior en +1 | **Salida verde y equivocada:** cada proyecto muestra el contenido editorial de otro |

El tercero es el peligroso. Los dos primeros producen nulos, que se ven. El tercero
produce texto plausible en el lugar equivocado, que no se ve. Por eso el criterio de éxito
de este encargo **no es contar entradas parseadas**.

---

## 2. Precondición

```bash
cd ~/Projects/slep_estado_proyectos_monitoreo && \
  git status --porcelain && echo "--- fin status ---" && \
  git rev-parse --abbrev-ref HEAD && \
  git rev-list --left-right --count HEAD...origin/main && \
  ls -la ~/Projects/slep_monitoreo/docs/data.js
```

Rama `main`, `0	0`. El archivo del propio encargo untracked no detiene. Si `data.js` no
está en `docs/`, **detente**: la premisa central del encargo es del diagnóstico y si no se
sostiene hoy, el resto no aplica.

---

## 3. Línea base, antes de tocar nada

Sin esta línea base no hay contra qué medir después:

```bash
cd ~/Projects/slep_estado_proyectos_monitoreo && \
  cp 40_salidas/panorama_visual.html /tmp/base_panorama_visual.html && \
  cp 40_salidas/panorama_visual.md   /tmp/base_panorama_visual.md
```

Registra cuántas fichas de la salida actual tienen `tipo`, `objetivo` y `sintesis` no
vacíos. La cifra esperada es cero, pero **medila**, no la asumas.

---

## 4. Alcance de escritura cerrado

- `30_procesamiento/36_generar_panorama_visual.R` (único archivo de código)
- `40_salidas/` (lo regenera la corrida de verificación)
- `50_documentacion/andamios/20260826_verificacion_frente_a.md` (informe de cierre)

**Ningún repositorio hermano se toca.** `~/Projects/slep_monitoreo/` se **lee** y nada
más: sin `fetch`, sin `pull`, sin `checkout`.

---

## 5. Los tres cambios

### 5.1 Ruta (línea 38)
Apuntar a `docs/data.js`. **No la claves como literal si el archivo ya define una
constante de raíz del sitio:** un valor en un solo lugar. Añade, junto a la definición, un
comentario de una línea con el commit del hermano que motivó el cambio (`00a1af3`), para
que la próxima mudanza del origen sea rastreable.

### 5.2 Saneador (línea 204)
Reemplazar la lista blanca de siete claves por una expresión que quotee **cualquier** clave
a inicio de línea. La lista blanca es el defecto de diseño, no la ausencia de `id`: cada
clave que el origen agregue vuelve a romper el parseo. La corrección tiene que ser inmune
a la siguiente clave nueva, no solo a esta.

### 5.3 Mapeo (líneas 64-76)
Reclavar `MAPEO_ORDEN_SLUG` por `id` y no por posición. Si el `id` del origen no coincide
con el `slug` del orquestador, el mapeo pasa a ser explícito `id -> slug` y se declara en
el informe, entrada por entrada.

**Guarda obligatoria:** si una entrada de `data.js` no encuentra su `slug`, o si un `slug`
aparece en dos entradas, el paso **aborta con la entrada nombrada**. No degrades a
silencio: un mapeo incompleto que no aborta es precisamente cómo se produce el cruce
editorial que este encargo viene a impedir.

---

## 6. Verificación, en tres niveles

**Nivel 1, parseo.** Las 12 entradas de `data.js` se leen sin error. Transcribe el conteo.

**Nivel 2, poblado.** Corre `run_all(only = 6)` y cuenta las fichas con `tipo`, `objetivo`
y `sintesis` no vacíos. Contrasta con la línea base del §3.

**Nivel 3, control negativo de cruce editorial.** El decisivo. Verifica que el contenido
corresponde al proyecto y no al vecino:

1. La ficha de `slep_idps` habla de IDPS y **no** de estándares Simce.
2. Elige otras **tres** fichas al azar, transcribe su `objetivo` y confirma a mano que el
   texto corresponde al proyecto que lo encabeza. Transcribe las tres.
3. **Prueba del desplazamiento:** aplica deliberadamente el mapeo viejo (por posición) a
   los datos nuevos y comprueba que produce cruce. Si el mapeo viejo **no** produce cruce,
   entonces el defecto 3 no era tal y el diagnóstico se equivocó: detente y dilo.

El punto 3 es el que distingue "lo arreglé" de "no estaba roto". Sin él, un `PASA` en los
niveles 1 y 2 no prueba nada sobre el mapeo.

---

## 7. Commit e informe

Un solo commit de código:
```
fix(paso-6): corrige ruta, saneador y mapeo de data.js

Cierra O-05. Tres defectos apilados: ruta movida a docs/ por 00a1af3, clave id
agregada por 15dc047, y mapeo por posicion desplazado en +1. Ninguno se corrige solo.
```

Un segundo commit con la regeneración de `40_salidas/` y el informe
`20260826_verificacion_frente_a.md`, que contiene los tres niveles del §6 con su salida
literal, el mapeo `id -> slug` completo si hizo falta declararlo, y las fichas
transcritas del nivel 3.

Push y verificación por `ls-remote` contra `rev-parse HEAD` (A29).

---

## 8. Qué reportar

Las tres cifras de los niveles 1 y 2 (antes y después), el resultado literal de la prueba
del desplazamiento, las cuatro fichas transcritas, los dos hashes, y las premisas de este
encargo que resultaron falsas. Van seis encargos con premisas corregidas en la ejecución:
si este no tiene ninguna, dilo también, porque sería el primero.

`estado_proyecto` **no se toca** en este encargo. El diagnóstico estableció que no es un
defecto de código sino una columna nunca curada, y su dominio de valores hay que fijarlo
contra `RANGO_ESTADO` antes de poblarla. Curarla con el enum equivocado ya tumbó el paso 6
en la sesión 6.
