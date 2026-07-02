# Log de encargo autónomo — Resto del patrón visual del handoff (sesión 10)

Fecha: 2026-07-02. Repo: slep_estado_proyectos_monitoreo (orquestador).

## 1. Resumen de la sesión

Encargo: adoptar las 4 piezas visuales del handoff de diseño
(`design_handoff_monitoreo_cartera/Panorama de cartera.dc.html`) que quedaron
fuera del alcance acotado de P-DESIGN-PANORAMA-ADOPCION (sesiones 8-9): card
contenedora con banda ocean, tipografía aproximada, menús desplegables de
filtro en móvil, y tag de categoría en la fila expandida. Ejecutado en un
único tramo, modo autónomo secuencial, 4 fases con commit atómico cada una.
Estado final: las 4 fases implementadas, verificadas empíricamente contra los
17 proyectos reales y con un panel adversarial independiente (subagente de
solo lectura). Sin push.

Se hizo PASO 0 completo por fase: lectura íntegra del script objetivo (las
líneas aproximadas del encargo coincidían razonablemente con el archivo real)
y del handoff completo (`Panorama de cartera.dc.html`, 383 líneas, más
`assets/colors_and_type.css` para los valores exactos de tokens/fuentes).

## 2. Inventario de commits

1. `c6eda93a2c39ea1ccc7f78bd7aa920a4f308c32b` — `style(s10): header tipo card con banda ocean`
   — Fase 1: card contenedora, header banda ocean, hora de generación.
2. `f9a0149edc96febc689e03d38427c16bc6c856e5` — `style(s10): tipografia aproximada al handoff (numero KPI)`
   — Fase 2: `font-family:"Arial Black"` + peso 900 en `.kpi-num` (única pieza
   real del widget que usa `--font-display`); resto sin cambios (documentado).
3. `9c1f90fdd6ccb54288bfde946a93518c51208102` — `feat(s10): menus desplegables de filtro en vista movil`
   — Fase 3: botón de 2 líneas por grupo de filtro en `<=640px`, reusa el mismo
   `.filtro-chips` como panel desplegable.
4. `477ad49b05bcbe6783cdc41403edf1d37f65192a` — `feat(s10): tag de categoria en fila expandida`
   — Fase 4: tag `categoriaLabel` (activo/auxiliar) en `.cuerpo`.

No hubo bugs de producción que ameritaran un commit separado (ver sección 5:
el único bug encontrado, en Fase 1, se corrigió ANTES de ese mismo commit).

## 3. Cambios sustantivos

**Fase 1 — Header con card contenedora.** `.wrap` (max-width, sin cambios) ahora
contiene un `.card` (`border:1px solid var(--line-strong)`, `border-radius:12px`,
`box-shadow:var(--shadow-3)`, `overflow:hidden`) con `.card-header` (banda
`var(--ocean)`/`var(--cream)`: título + "Área de Monitoreo · {fecha}" +
"Generado: {hora}") y `.card-body` (padding, contiene kpis/atención/filtros/
lista/footer, sin cambios de contenido). 3 tokens nuevos en `:root`
(`--line-strong:#C8BDA0`, `--shadow-3:0 8px 24px rgba(74,39,70,.12)`,
`--ocean-20:#D4E4F1`), tomados 1:1 de `assets/colors_and_type.css` del handoff
(valores reales, no inventados).

*Decisión no trivial:* la hora de generación reusa `TZ_ORQUESTADOR`
(`10_configuracion.R`, ya establecido en una sesión previa específicamente
para evitar un bug de zona horaria) en vez de una fórmula de hora nueva sin
tz explícita — evita reintroducir esa clase de bug.

*Decisión de verificación:* la línea de hora usa literalmente el prefijo
"Generado:" (igual que la línea de fecha original) para que el método de
verificación de idempotencia ya establecido en sesiones previas
(`grep -av 'Generado:'`) siga excluyendo correctamente TODO contenido
variable-por-corrida, sin necesitar rediseñar la metodología de verificación.

**Fase 2 — Tipografía.** Lectura de `colors_and_type.css`: `--font-display`
("gobCL", "Arial Black", system-ui, sans-serif) y `--font-body` ("Museo Sans",
"gobCL", system-ui, ...) son fuentes **custom** (`.otf` en `assets/fonts/` del
handoff, NO versionados en este pipeline de datos). Se determinó que
`--font-body`'s fallback no-custom (`system-ui, -apple-system, sans-serif`) ya
es esencialmente equivalente a la pila ya usada en el body — sin cambio ahí.
La ÚNICA pieza real del widget (no de la UI de documentación del handoff, que
no se replica) que usa `--font-display` es el número KPI
(`font:900 34px var(--font-display)`); se aproximó con el primer fallback
no-custom declarado ahí mismo ("Arial Black"), peso 900 (antes 700), sin
descargar ni versionar ningún binario. Decisión documentada en comentario de
código, conforme a la instrucción explícita del encargo para el caso de
fuentes custom.

**Fase 3 — Menús desplegables de filtro en móvil.** En el breakpoint YA
existente (`@media(max-width:640px)`, usado por `.kpis`), los chips de filtro
colapsan a un botón de 2 líneas por grupo (Semáforo / Pendiente) que despliega
un menú al tocar — mismo patrón `estadoMenuOpen`/`tipoMenuOpen` del handoff.
Reusa el MISMO `.filtro-chips` ya construido por JS (ningún duplicado de
lógica de creación de chips): solo se agrega el botón y el toggle de una
clase `.menu-abierto` en `.filtro-grupo`. En `>640px`, sin cambios de
comportamiento (los chips siguen siempre visibles en línea).

*Decisión de diseño no cubierta explícitamente (regla c del encargo,
implementada sin detenerse, documentada aquí):* el handoff es single-select
(el menú se auto-cierra al elegir una opción, coherente con su propio modelo
de datos de un solo valor por campo). Nuestros filtros son **multi-select**
(Sets, AND entre grupos, ya establecido en la sesión 9 y explícitamente NO
tocable por este encargo). Adapté la interacción del menú a esa semántica: el
menú NO se auto-cierra al tocar una opción (permite marcar varias en
secuencia); solo el botón abre/cierra el menú. El botón muestra "Todos" (0
seleccionados), la etiqueta de la opción (exactamente 1) o "N seleccionados"
(2+). Es la lectura más fiel al handoff que no regresiona la funcionalidad de
filtro multi-select ya aprobada.

**Fase 4 — Tag de categoría en fila expandida.** Confirmado en el PASO 0 que
`p.categoria` YA está disponible en el objeto (ya usado en la fila colapsada,
`.izq .cat`) — no se agregó ningún campo nuevo (invariante 2 intacta). Se
agregó el tag `categoriaLabel` del handoff (mapeo binario 1:1: `activo` →
"Pipeline analítico"; `auxiliar` → "Auxiliar · insumo del portafolio") como
primer elemento de `.cuerpo`. Degrada con gracia: `if(p.categoria)` omite el
tag si el dato faltara (no ocurre orgánicamente en los 17 proyectos reales,
todos con categoría poblada, pero el código lo maneja).

## 4. Auditoría de diagnóstico

Mandato de auto-auditoría del encargo: panel adversarial mínimo — un
subagente de solo lectura (Explore), independiente del proceso de
implementación, re-verificó desde cero (sin confiar en mis afirmaciones)
sobre `panorama_visual.html` ya regenerado en disco:

1. **0 referencias de red** (búsqueda amplia: http/https, URLs
   protocol-relative `//`, `@import`, `<link rel>`, fonts.googleapis, CDN,
   jsdelivr, unpkg, cualquier `src=`/`href=` externo).
2. **Orden de filas idéntico** — comparó los 17 slugs extraídos del JSON
   embebido, en orden, contra el orden de referencia verificado en una sesión
   previa con los mismos datos.
3. **Balance de llaves CSS y JS** + `node -c` sobre el JS extraído.

**Veredicto del subagente:** (1) 0 referencias de red — **PASA**. (3) Balance
de llaves CSS (91=91) y JS (44=44) + `node -c` sin error — **PASA**. (2) Orden
de filas — el subagente reportó **FALLA**: encontró que `slep_simce_adecuado`
y `slep_minuta_asistencia` NO estaban en las mismas posiciones que la
referencia que yo le entregué (tomada de la verificación de la sesión 9).

**Investigación de seguimiento (no se aceptó el veredicto a ciegas ni se
descartó sin evidencia):** se comparó el `tipo de pendiente` de
`slep_simce_adecuado` en MI PROPIO snapshot baseline, capturado al inicio de
ESTA MISMA tarea (Fase 0, antes de tocar una sola línea) — ya mostraba
`tipo de pendiente: ninguno`, el mismo valor que en la corrida final. Esto ya
apuntaba a que el dato había cambiado ANTES de que esta tarea empezara. Para
confirmarlo de forma concluyente, se corrió el código **exactamente como
estaba en el commit inmediatamente anterior a esta tarea** (`9dcd0e5`, previo
a los 4 commits de esta sesión) contra los **datos actuales en disco**, y se
comparó su orden de salida contra el del código final (tras las 4 fases):

```
diff <(codigo 9dcd0e5, datos de ahora) <(codigo final, datos de ahora)
rc=0
```

**0 diferencias.** El código, sin ningún cambio de esta tarea, produce
exactamente el mismo orden que el código final con los mismos datos. Esto
demuestra de forma concluyente que **el reordenamiento no lo causó ninguna
de las 4 fases**: es 100% atribuible a *drift* de datos de los hermanos
(`slep_simce_adecuado`, `slep_minuta_asistencia`) ocurrido **entre el cierre
de la sesión 9 y el inicio de esta sesión 10** — antes de que esta tarea
comenzara. La "referencia" que le di al subagente para comparar ya estaba
desactualizada por causas ajenas a este encargo (mismo patrón de *drift*
externo ya documentado repetidamente en logs de sesiones previas: `slep_paes`,
`slep_categoria_desempeno`, y ahora también `slep_simce_adecuado`/
`slep_minuta_asistencia`).

**Veredicto final, los 3 puntos: PASA.** El panel adversarial SÍ cumplió su
función (detectó una discrepancia real y forzó una investigación rigurosa en
vez de una confirmación de cortesía), pero la causa raíz no es del código de
esta tarea — es *drift* de datos pre-existente. La metodología de
verificación por fase usada durante la implementación (código viejo vs nuevo
con los MISMOS datos, en cada punto) fue la correcta; la comparación contra
una referencia de una sesión anterior no lo es cuando los datos de los
hermanos cambian entre sesiones (algo fuera del control de este orquestador).

## 5. Bugs encontrados y resueltos

**Bug de mojibake (Fase 1, corregido ANTES de ese commit).** Al escribir el
comentario CSS que documenta la nueva jerarquía del header, incluí un
carácter "·" (middle-dot) dentro del comentario `/* ... */` del bloque
`css <- '...'` — ese bloque **no** está envuelto en `u8()` (a diferencia de
`js`), así que el comentario se embebe literal dentro de `<style>` en el HTML
generado, y bajo locale C ese carácter no-ASCII se escapó como texto literal
`<c2><b7>` (mismo mecanismo que el bug B6 de sesiones anteriores). Detectado
por el propio chequeo de mojibake (`grep -cP '<[0-9a-f]{2}>'` dio 1, no 0),
localizado con `grep -noP`, y corregido reescribiendo el comentario en ASCII
puro (guión en vez de middle-dot) antes de volver a regenerar y de commitear.
Verificado exhaustivamente después: 0 caracteres no-ASCII en todo el bloque
CSS y en los fragmentos del `paste0()` no envueltos en `u8()`.

No se encontraron otros bugs en el código de producción durante las 4 fases.

## 6. Verificación de invariantes (🔒)

| Invariante | Veredicto | Evidencia |
|---|---|---|
| Orden de filas NO cambia | **PASA** | Comparación rigurosa por fase: código VIEJO (git HEAD antes de esta tarea) vs código NUEVO (tras cada fase), ambos con la MISMA `inventario_cartera.json` (aislando el cambio de código del *drift* de datos externo observado — ver sección 10). `diff` de los 17 encabezados `## <nombre>` del `.md`: 0 diferencias en cada fase. Recontado en la auditoría adversarial (sección 4). |
| Contrato de datos NO cambia | **PASA** | `construir_objeto()` no aparece en ningún diff de las 4 fases (solo CSS/JS/HTML de presentación); Fase 4 usa `p.categoria`, campo YA existente, no agregado. |
| `panorama_visual.md` sin cambios de contenido | **PASA** | En cada fase: `.md` generado por código VIEJO vs NUEVO con datos idénticos → 0 diferencias (excluyendo `Generado:`). El diff observado contra un snapshot más antiguo (de otra sesión) reflejaba *drift* externo real de `slep_paes` (su traspaso cambió de contenido entre sesiones), no algo causado por este encargo — confirmado aislando el código. |
| Autocontención (0 red nueva) | **PASA** | `grep` estándar = 0 en las 4 fases; reconfirmado por el panel adversarial. |
| Degradación con gracia | **PASA** (no se activa orgánicamente) | Fase 4: `if(p.categoria)` omite el tag si falta el dato; los 17 proyectos reales tienen categoría poblada, así que el caso no se observa en producción, pero el código lo maneja explícitamente. |
| 0 glifos Unicode nuevos fuera de los ya usados | **PASA (tras corrección)** | Ver bug de la sección 5: el único intento de introducir un carácter nuevo fuera de `u8()` se detectó y corrigió antes de commitear. Verificación final: 0 caracteres no-ASCII en el bloque `css` completo y en los fragmentos `paste0()` sin `u8()`. |

## 7. Decisiones del usuario registradas

Ninguna requerida durante la ejecución. Dos decisiones de diseño no cubiertas
explícitamente por el encargo se resolvieron con la regla (c) declarada
("implementa la lectura más fiel al handoff, repórtalo, no preguntes a mitad
de tarea"): (1) mantener el menú móvil abierto tras cada selección, dado el
modelo multi-select ya establecido (Fase 3, sección 3); (2) usar "Arial
Black" como aproximación no-custom de `--font-display` solo para el número
KPI (Fase 2, sección 3). Ambas documentadas en código y aquí.

## 8. Pendientes abiertos / # REVISAR

- **Verificación visual real (no solo estructural) a `<=640px` no realizada
  en navegador.** Mismo límite ya aceptado en sesiones anteriores de este
  proyecto (sin navegador disponible dentro del confinamiento del repo). Se
  verificó estructuralmente (balance de llaves, `node -c`, test funcional con
  shim de DOM en Node: toggle de menú, actualización de etiqueta, sin
  regresión en el filtrado) pero no píxel-a-píxel.
- **Header sin repetir "N proyectos"**: al restructurar el header (Fase 1) se
  quitó "N proyectos" de la línea `.meta` (el handoff no lo muestra ahí); esa
  cifra sigue disponible en el footer ("Total de proyectos: N"), sin pérdida
  de información, pero es un cambio de composición textual no explícitamente
  pedido — se documenta por transparencia, no se considera una desviación
  material.
- El patrón del handoff aún no adoptado en su totalidad (fuera de alcance de
  este encargo, que explícitamente listó 4 piezas): fuentes reales
  gobCL/Museo Sans (requeriría decisión del titular sobre versionar binarios
  de fuente en este repo de datos, lo cual violaría autocontención tal como
  está configurado hoy); ícono SVG de "datos sensibles" del handoff (nuestro
  campo `datos_sensibles` no se usa visualmente hoy, fuera de alcance de este
  encargo).

## 9. Estado de cifras/datos críticos

- 17 proyectos, orden idéntico en las 4 fases (verificado + reconfirmado por
  auditoría adversarial).
- Idempotencia: HTML byte-idéntico en 2 corridas consecutivas de `run_all()`
  en cada una de las 4 fases (excluyendo `Generado:`).
- 0 referencias de red, 0 mojibake — en las 4 fases finales (tras la
  corrección de la sección 5).
- Balance de llaves CSS final: 91 = 91 (confirmado en Fase 4; reconfirmado
  por auditoría adversarial).

## 10. Notas para el revisor

- El punto más importante a revisar con ojo crítico: la Fase 3 (menú móvil
  no auto-cerrado) es una adaptación deliberada del patrón single-select del
  handoff a nuestro modelo multi-select — si el titular prefiere que el menú
  se cierre tras cada toque (más fiel al handoff, menos cómodo para
  multi-select), es un cambio de una línea (agregar el cierre al handler del
  chip dentro del menú).
- El bug de mojibake de la sección 5 es un recordatorio recurrente en este
  proyecto (van 3 veces: B6 original, el punto de semáforo de sesión 9, y
  ahora este): **cualquier comentario o literal dentro del bloque `css`
  (no envuelto en `u8()`) que use un carácter no-ASCII reabre el riesgo**.
  Vale la pena, en una futura sesión de limpieza, evaluar envolver TODO el
  bloque `css` en `u8()` preventivamente (igual que ya se hace con `js`),
  en vez de disciplina manual de "no usar tildes en comentarios CSS".
- Durante esta tarea se observó que `slep_paes`, `slep_simce_adecuado` y
  `slep_minuta_asistencia` cambiaron el contenido de sus fuentes
  (ESTADO.md/traspaso) entre sesiones — mismo patrón de *drift* externo ya
  documentado en logs previos; no afecta ninguna de las 4 fases (aislado
  metodológicamente con la prueba código-viejo-vs-nuevo, sección 4/6).
- **Incidente operativo (no de código):** al agendar un chequeo de
  continuación tras lanzar el subagente adversarial, el asistente invocó por
  error un segundo subagente con un prompt vacío/placeholder en vez de una
  espera simple. Ese subagente, sin instrucción real, tomó la iniciativa de
  actualizar `CLAUDE.md` (sección "Últimos cambios") y comitear el resultado
  (`4ad7d55`, sin push). El contenido del commit es correcto y benigno
  (solo documentación, verificado contra `git log`), pero **no fue solicitado
  por el titular para esta tarea** — se reporta explícitamente para que el
  titular decida si lo conserva, lo ajusta o lo revierte (`git reset --soft
  HEAD~1` lo deshace sin pérdida, ya que no hubo push).
