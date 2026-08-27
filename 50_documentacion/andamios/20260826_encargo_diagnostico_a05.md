# Encargo A-05 — Diagnóstico de `data.js` y de la pérdida de `estado_proyecto`

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Raíz:** `~/Projects/slep_estado_proyectos_monitoreo`
- **Sesión:** 13 (CONTINUATION)
- **Cubre:** O-05 (`data.js` no disponible: `tipo`, `objetivo`, `sintesis` nulos en los 24)
  y O-06 (`estado_proyecto` vacío en los 24 sin excepción).
- **Naturaleza:** **solo lectura**. Este encargo entrega un informe, **no una corrección**.
  Ni un `str_replace`, ni un commit de código, ni un cambio de ruta.

---

## 1. Por qué el diagnóstico va separado de la corrección

Que los dos campos fallen en los 24 sin una sola excepción apunta a la extracción y no a
los hermanos: si el defecto estuviera en los repos de origen, algunos pasarían. Pero eso
es hipótesis hasta medirlo, y corregir una ruta sin haber leído dónde se busca el archivo
es cambiar rutas a ciegas. El traspaso v12 lo prohíbe de forma literal.

El criterio de éxito de este encargo, por lo tanto, no es que algo funcione. Es que el
informe **nombre el archivo y la línea** donde se pierde cada campo, con la evidencia que
lo demuestra.

---

## 2. Precondición

```bash
cd ~/Projects/slep_estado_proyectos_monitoreo && \
  git status --porcelain && echo "--- fin status ---" && \
  git rev-parse --abbrev-ref HEAD && \
  git rev-list --left-right --count HEAD...origin/main && \
  Rscript -e 'renv::status()'
```

Rama `main`, `0	0`, `renv` consistente. Si `status` devuelve el archivo de este encargo
sin seguir, eso **no** detiene: es el falso positivo que ya se adjudicó dos veces en esta
sesión. Cualquier otra línea sí detiene.

---

## 3. Alcance de escritura cerrado

Un solo archivo nuevo: `50_documentacion/andamios/20260826_diagnostico_campos_perdidos.md`.
Los scratchpads temporales van fuera del repo o a `tempdir()` y se borran.

**Nada más se escribe.** Ni `40_salidas/`, ni `30_procesamiento/`, ni `10_utils/`, ni
`ESTADO.md`. Si el diagnóstico exige correr algo que escriba salidas, **primero** copia el
estado previo a `tempdir()` y **restáuralo** al terminar, y declara que lo hiciste.

---

## 4. Advertencia sobre las premisas de este encargo

Cinco encargos de esta sesión llevaron premisas falsas que la ejecución tuvo que
corregir: el paso 32 no leía el registro, el escáner sí tenía biblioteca pero vacía, la
tabla de patrones no cubría `C-NNN`, la tabla del backlog contaba sub-items. El patrón es
del autor, no del ejecutor.

Por eso este encargo **no te dice dónde está el defecto**. Los números de paso que
menciona son puntos de partida para buscar, no afirmaciones. Si el consumidor de `data.js`
no es el paso 6, o si `estado_proyecto` no nace donde este texto sugiere, **corrígelo en
la ejecución y nómbralo**. Una premisa equivocada del autor no es una instrucción.

---

## 5. Frente A — `data.js`

1. **Localiza al consumidor.** No asumas el paso 6:
   ```bash
   grep -rn "data\.js\|data_js\|DATA_JS" --include="*.R" . | grep -v "^./50_documentacion/andamios/"
   ```
   Registra todos los sitios, con archivo y línea.
2. **Reconstruye la ruta esperada.** Si se arma desde una constante o desde una función de
   configuración, transcribe la definición y **evalúala** para obtener la ruta literal que
   el código busca en tiempo de ejecución. La ruta escrita en el fuente y la ruta que
   resulta al evaluarse pueden diferir, y esa diferencia es una causa candidata.
3. **Comprueba existencia y forma.** ¿Existe el archivo en esa ruta? Si no, ¿existe en
   alguna otra dentro de `~/Projects` o del sitio del Área? Si existe, transcribe sus
   primeras 20 líneas y su tamaño. `data.js` es la fuente autoritativa de nombres curados
   y su formato puede haber cambiado en origen.
4. **Distingue las tres causas posibles y di cuál es**, con la evidencia:
   - la ruta que el código construye no es donde está el archivo;
   - el archivo está y el parser ya no lo entiende (cambio de formato en origen);
   - el archivo no existe en ninguna parte (la fuente desapareció).
5. **Traza el campo hasta la salida.** Toma un proyecto concreto y sigue `tipo`, `objetivo`
   y `sintesis` desde la lectura hasta `inventario_cartera.json`, diciendo en qué punto
   pasan a nulo.

---

## 6. Frente B — `estado_proyecto`

1. **Dónde nace.** `estado_proyecto` es campo del front matter de los `ESTADO.md` de los
   hermanos. Mide primero **en el origen**:
   ```bash
   for d in ~/Projects/slep_*/; do
     f="$d/50_documentacion/activa/ESTADO.md"
     [ -f "$f" ] && printf "%s\t%s\n" "$(basename $d)" "$(grep -m1 '^estado_proyecto:' "$f" || echo AUSENTE)"
   done
   ```
   Si el campo está ausente en los hermanos, el defecto **no es de extracción** y el
   informe tiene que decirlo con esa tabla como prueba. Esta comprobación va primero
   porque es la que puede invalidar toda la hipótesis del encargo.
2. **Si el campo sí existe en origen**, sigue la cadena paso por paso. Para un proyecto
   concreto, imprime el valor del campo a la salida de cada etapa (localización,
   extracción de metadatos, compilación del panorama) y señala **la primera** en la que
   deja de estar. No corras el pipeline entero y midas solo el final: eso dice que se
   perdió, no dónde.
3. **Contrasta con un campo que sí sobrevive.** Elige uno del mismo front matter que
   llegue bien a la salida (`semaforo`, por ejemplo) y compara cómo se lo trata frente a
   `estado_proyecto`. La diferencia entre los dos tratamientos es la causa candidata más
   probable: lista de campos declarada, expresión de parseo, o nombre que no coincide.
4. **Comprueba el esquema.** SETTINGS v34 introdujo campos nuevos y O-08 dice que los
   pasos 32, 33 y 35 no leen ese esquema. Verifica si `estado_proyecto` figura en la lista
   de campos que el código extrae, y transcribe esa lista completa.

---

## 7. El informe

`50_documentacion/andamios/20260826_diagnostico_campos_perdidos.md`, con esta estructura:

1. **Veredicto por frente, en una línea cada uno.** Archivo, línea, causa.
2. **Evidencia de A:** los sitios del grep, la ruta evaluada, el estado del archivo, y
   cuál de las tres causas es, con lo que la demuestra.
3. **Evidencia de B:** la tabla de los hermanos, la etapa donde se pierde el campo, y la
   comparación con el campo que sobrevive.
4. **Corrección propuesta, descrita y no aplicada.** Qué archivo, qué línea, qué cambio, y
   qué habría que medir para saber que funcionó.
5. **Qué no se pudo determinar**, si algo quedó abierto. Un hueco declarado vale; un hueco
   silencioso, no.

---

## 8. Qué reportar en el chat

Los dos veredictos de una línea, la corrección propuesta para cada frente en dos o tres
líneas, el hash del commit que deposita el informe (verificado por `ls-remote` contra
`rev-parse HEAD`), y las premisas de este encargo que resultaron falsas.

Si al terminar el diagnóstico la corrección te parece trivial: **no la apliques igual**.
La separación entre medir y corregir es lo que hace que la corrección se pueda evaluar
después contra una línea base.
