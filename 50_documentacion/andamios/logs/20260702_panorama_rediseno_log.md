# Log de encargo autónomo — P-DESIGN-PANORAMA-ADOPCION (rediseño panorama visual)

Fecha: 2026-07-02. Repo: slep_estado_proyectos_monitoreo (orquestador).

## 1. Resumen de la sesión

Encargo: adoptar del handoff de diseño (`design_handoff_monitoreo_cartera/`)
los patrones de KPIs por semáforo, banda "Requieren atención hoy" y filtros
combinables, sobre el panorama visual (`panorama_visual.html`) ya existente
(acordeón + semáforo de sesiones previas), **sin tocar el contrato de
datos ni el orden de las cards**. Ejecutado en un único tramo, modo autónomo
secuencial. Estado final: implementado, verificado empíricamente contra los
17 proyectos reales, commiteado. Sin push.

Se hizo PASO 0 completo: lectura íntegra del script objetivo (confirmado que
las líneas aproximadas del encargo coincidían con el archivo real: css ~498,
js ~557, `html <- paste0(...)` ~633, conteos de cierre ~701-707 — sin
divergencia que disparara la regla de detención).

## 2. Inventario de commits

1. `f61644031cb4fe0db02fb6bf39a09a4af46cfff8` — `feat(panorama): adoptar KPIs, banda de atención y filtros (P-DESIGN-PANORAMA-ADOPCION)`
   — commit único (cambio conceptual de UI, per encargo). Toca
   `30_procesamiento/36_generar_panorama_visual.R` y los 5 artefactos
   regenerados (`inventario_cartera.json`, `inventario_cartera.parquet`,
   `panorama.md`, `panorama_visual.html`, `panorama_visual.md`).

No hubo bugs de producción que ameritaran un commit separado (ver sección 5:
el único bug encontrado fue en el arnés de verificación, no en el código
entregado).

## 3. Cambios sustantivos

**Qué:** tres bloques nuevos en el HTML, insertados entre el header y la
lista de cards (`#kpis`, `#atencion`, `#filtros`), más el CSS/JS que los
alimenta. Ningún campo nuevo en el objeto por proyecto; todo se calcula
client-side sobre `semaforo`/`tipo_pendiente` ya existentes.

- **KPIs (Fase 2):** fila de 5 números (activo/pausa/bloqueado/cerrado/sin
  dato), conteo fijo de toda la cartera, no se filtra.
- **Banda de atención (Fase 1):** criterio de DATO fijo
  (`tipo_pendiente ∈ {bug, bloqueante}`), se omite el bloque completo si el
  conteo es 0 (nunca banda vacía). Cada card: nombre + tipo_pendiente +
  semáforo (punto de color), clic hace scroll + expande la fila
  correspondiente en la lista completa (vía un mapa `slug -> elemento`
  poblado en `render()`, sin `querySelector` frágil).
- **Filtros (Fase 3):** dos grupos independientes (semáforo: 5 valores;
  tipo_pendiente: 7 del enum + "sin dato"), combinables con AND, 100%
  client-side sobre el array `CARTERA` ya embebido. Grupo vacío = no filtra.
  Filtra solo la lista (`.fila.oculta{display:none}`); KPIs y banda quedan
  fijos, tal como pide el invariante.

**Por qué así (decisiones no triviales):**

- **Color del borde de la banda de atención — decisión de UX no cubierta
  explícitamente.** El encargo solo especifica el CONTENIDO de cada card de
  la banda (nombre + tipo_pendiente + semáforo), no su estilo de borde. El
  handoff de referencia usa el color del **semáforo propio** de cada ítem
  para el borde-izquierdo (no un color fijo). Adopté ese criterio,
  reutilizando los tokens ya existentes (`--olive/--amber/--danger/--slate`,
  `--line` si semáforo=NA) — es la lectura más consistente con "reusar
  tokens existentes" (Fase 4) y con el propio patrón visual del handoff.
- **No usar `querySelectorAll`/`dataset` para filtrar.** Se optó por un mapa
  JS `FILAS_POR_SLUG` (slug → elemento `.fila`) poblado una vez en
  `render()`, reutilizado tanto por el clic de la banda (scroll+expand) como
  por `aplicarFiltros()`. Evita depender de `querySelectorAll` (no usado en
  ningún otro punto del script) y mantiene el patrón ya establecido de
  "objeto de lookup construido una vez" (mismo idioma que `datos_por_slug`
  para data.js).
- **Ningún hex nuevo.** Los 3 bloques nuevos reutilizan íntegramente los 12
  tokens ya definidos en `:root` (incluidos `--amber`/`--danger` agregados en
  la sesión de semáforo). No hizo falta ningún color derivado
  (`color-mix`/`rgba`) porque ninguna superficie nueva requería un tono que
  no existiera ya; se documenta esto explícitamente en el comentario del CSS
  en vez de justificar una derivación que no ocurrió.
- **Iconografía:** cero glifos Unicode nuevos. El punto de color del
  semáforo (ya existente de la sesión anterior) se reutiliza tal cual
  (círculo CSS puro) en la banda; no se agregó ningún ícono SVG porque
  ninguna de las tres piezas (KPIs/banda/filtros) lo requería para
  comunicarse con claridad.

**Archivos tocados:** solo `30_procesamiento/36_generar_panorama_visual.R`
(css/js/html `paste0()`) + los 5 artefactos regenerados. `construir_objeto()`,
el `order()` de FASE 2 y el bloque FASE 4 (generación de `panorama_visual.md`)
**no se tocaron** — verificado en el diff línea a línea contra el archivo
previo (ver sección 6).

## 4. Auditoría de diagnóstico

Mandato de auto-auditoría del encargo: contrastar cada conteo de UI contra su
homólogo ya calculado en R (líneas ~701-707) antes de reportar éxito. Todos
los contrastes cerraron exactos:

| Conteo UI (JS/DOM) | Homólogo en R | Resultado |
|---|---|---|
| Suma de 5 categorías de semáforo (KPIs) | `n_total` | 12+1+0+0+4 = **17 = 17** ✓ |
| Cards en la banda de atención | `n_prioritarios` (log: "1 bug/bloqueante en cabeza") | **1 = 1** ✓ (único: `slep_georreferenciacion`, `tipo_pendiente=bloqueante`) |
| Filas totales renderizadas | `n_total` | **17 = 17** ✓ |

No se requirió panel adversarial completo (riesgo de datos bajo, per el
encargo); el contraste numérico fue suficiente.

## 5. Bugs encontrados y resueltos

**Bug en el arnés de verificación (Node, no en producción).** Primer intento
del test de filtros combinados dio resultados incorrectos (3 y 4 visibles en
vez de 0 y 17). Causa raíz: el script de prueba buscaba el chip "sin dato"
por **texto** con `.find()` sobre TODOS los chips (`filtros.q('chip')`), pero
ese texto existe en **ambos** grupos (semáforo y tipo_pendiente); la primera
búsqueda encontró y activó el chip del grupo semáforo, y una búsqueda
posterior (más específica, correcta) volvió a hacer clic en el MISMO chip,
cancelando su propio toggle. El análisis matemático del resultado observado
(3 = solo `tipo_pendiente=nuevo` sin filtro de semáforo; 4 = solo
`semaforo=sin dato` sin filtro de tipo_pendiente) confirmó que era
exactamente el patrón de un doble-toggle accidental, no un fallo de la
lógica AND de producción. Fix: reescribir el arnés para (a) desambiguar
siempre por grupo (`filtros.children[0]`/`[1]`, nunca por texto global) y
(b) reconstruir el DOM desde cero para cada combinación probada (sin arrastre
de estado entre pruebas). Re-verificado: las 3 combinaciones + limpieza dieron
los conteos esperados exactos (sección 4 del reporte final). Segundo bug
menor, mismo arnés: olvidé asignar `id="datos-cartera"` al elemento simulado
del JSON embebido en la primera versión del shim, causando una excepción
`Cannot read properties of null` — corregido antes de la primera corrida
válida.

**No se encontraron bugs en el código de producción**
(`36_generar_panorama_visual.R`).

## 6. Verificación de invariantes (🔒)

| Invariante | Veredicto | Evidencia |
|---|---|---|
| Orden de cards NO cambia | **PASA** | Comparación rigurosa: código VIEJO (git HEAD) vs código NUEVO, ambos ejecutados con la **misma** `inventario_cartera.json` (aislando el cambio de código del *drift* de datos externo entre sesiones). `diff` de los 17 encabezados `## <nombre>` del `.md` entre baseline y nuevo: **0 diferencias**, orden idéntico. |
| Contrato de datos NO cambia | **PASA** | `construir_objeto()` no aparece en el diff del commit (confirmado revisando los rangos de línea afectados: solo css ~546-596, JS ~616-770, html paste0 ~792-794). Ningún campo nuevo en el objeto JSON. |
| `panorama_visual.md` sin cambios de contenido/formato | **PASA** | Mismo método de aislamiento: `.md` generado por código VIEJO vs NUEVO con datos idénticos → **0 diferencias** (excluyendo la línea `Generado:`). |
| Autocontención (0 red) | **PASA** | `grep -coE '<link\|@import\|src=.?http\|href=.?http\|url\(http'` = 0. |
| Degradación con gracia (semaforo/tipo_pendiente=NA) | **PASA** | Los 4 hermanos sin `ESTADO.md` (`semaforo=null`) siguen renderizando fila completa; cuentan en el KPI "sin dato" (4) y en el filtro "sin dato" de ambos grupos; no se excluyen silenciosamente de ningún conteo. |
| 0 glifos Unicode decorativos nuevos | **PASA** | El punto de semáforo (preexistente) se reutiliza tal cual; KPIs/banda/filtros no introducen ningún carácter no-ASCII fuera de los ya envueltos en `u8()` (verificado: 0 mojibake, ver sección 9). |

## 7. Decisiones del usuario registradas

Ninguna requerida durante la ejecución: las dos únicas ambigüedades
encontradas (color del borde de la banda; mecanismo de lookup para
filtrar/scrollear) se resolvieron con criterio de implementador, documentando
la razón (sección 3), sin tocar ningún invariante 🔒 ni una decisión
estratégica genuinamente irresoluble sin el titular.

## 8. Pendientes abiertos / # REVISAR

- **Verificación visual a 375px no realizada en navegador real.** Este
  entorno no tiene un navegador disponible dentro del confinamiento del repo
  (mismo límite ya aceptado en sesiones anteriores de este proyecto: el
  preview tool requiere un `launch.json` fuera de la raíz confinada). Se
  verificó **estructuralmente**: las 3 media queries (`@max-width:640px` y
  `@max-width:420px` para `.kpis`; `@max-width:420px` para
  `.filtro-grupo`) existen, el CSS está bien formado (75 llaves abiertas =
  75 cerradas) y la cascada aplica correctamente la regla más angosta a
  375px (1 columna de KPIs; filtro-grupo en columna). No es verificación
  píxel-a-píxel; queda como deuda si se requiere verificación visual real en un futuro
  ciclo con acceso a navegador.
- **P-DESIGN-PANORAMA-ADOPCION queda parcialmente adoptado.** El handoff
  completo propone además un header con hora de generación, tags de
  categoría en la fila expandida, y una vista móvil con menús desplegables
  distintos a los chips aquí implementados. Esta sesión adoptó
  específicamente lo pedido (KPIs + banda + filtros); el resto del patrón
  visual del handoff no se tocó y puede quedar como candidato de una sesión
  futura si el titular lo pide explícitamente.

## 9. Estado de cifras/datos críticos

- KPIs por semáforo: activo=12, pausa=1, bloqueado=0, cerrado=0, sin dato=4.
  **Suma = 17 = n_total**, byte-exacto.
- Banda de atención: 1 card (`slep_georreferenciacion`), **= n_prioritarios**
  (log: "1 bug/bloqueante en cabeza").
- 0 referencias de red, 0 mojibake (HTML y MD).
- Idempotencia: 2 corridas consecutivas de `run_all()` → HTML y MD
  byte-idénticos (excluyendo `Generado:`).
- Orden de cards y contenido de `panorama_visual.md`: idénticos al código
  anterior con los mismos datos (sección 6).

## 10. Notas para el revisor

- El punto más importante a revisar con ojo crítico: la decisión de color
  del borde de la banda de atención (semáforo propio del ítem, no un rojo
  fijo) — es una interpretación razonable del handoff pero no estaba
  explícita en el encargo; si el titular prefiere un color fijo (p. ej.
  siempre `--danger`, ya que el criterio de entrada a la banda es
  tipo_pendiente, no semáforo), es un cambio de una línea de CSS.
- El mapa `FILAS_POR_SLUG` (en vez de `querySelectorAll`) es una decisión de
  implementación defendible pero es la primera vez que este script usa un
  lookup de elementos por slug en vez de reconstruir/consultar el DOM; vale
  la pena mantener el patrón si se agregan más interacciones cruzadas
  (banda ↔ lista) en el futuro, para no mezclar dos estilos.
- El bug del arnés de prueba (sección 5) es un buen recordatorio: al probar
  filtros con etiquetas de texto compartidas entre grupos (aquí, "sin
  dato" existe en ambos), la desambiguación debe ser siempre por grupo/DOM,
  nunca por texto plano — aplica tanto a pruebas futuras de este script como
  a cualquier extensión de los propios filtros de producción.
- `40_salidas/panorama.md` (paso 35) también cambió en este commit porque
  se regeneró junto con el pipeline completo; su contenido refleja el
  *drift* real de datos entre sesiones (p. ej. `categoria_desempeno` ahora
  tiene `tipo_pendiente=deuda_heredada` con `semaforo=activo`, distinto de
  lecturas anteriores), no cambios de código del paso 35 (no tocado).
