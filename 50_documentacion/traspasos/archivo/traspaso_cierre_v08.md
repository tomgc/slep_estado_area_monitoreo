# Traspaso de cierre v08 — slep_estado_proyectos_monitoreo

## 1. Identificación
- **Proyecto:** slep_estado_proyectos_monitoreo. **Versión:** v08. **Fecha:** 2026-07-01. **Sesión:** 8 (CONTINUATION).
- **Foco:** evaluación del handoff de Claude Design contra el contrato de datos real; implementación de consumo de `semaforo` desde `ESTADO.md` (Fase 2 PUSH) en `36_generar_panorama_visual.R`; push a `origin/main`; resolución (por refutación) de P-ESTADO-3-SIN-TRASPASO; fix de descubrimiento de directorios `_BACKUP`.
- **Entorno:** Claude (conversacional) + Claude Code (terminal, ejecución real). R, macOS.
- **Archivos modificados:** `36_generar_panorama_visual.R` (+193/-9); `10_utils/10_configuracion.R` (`PATRON_EXCLUIR_UNIVERSO`); 5 artefactos regenerados en `40_salidas/`.

## 2. Resumen ejecutivo

Sesión productiva con cuatro hilos de trabajo. Se evaluó el handoff de Claude Design (patrón "Triage + Lista de monitoreo", una sola alternativa entregada en vez de las 2-3 pedidas) contra `36_generar_panorama_visual.R`: se detectó que el `estado` del handoff no correspondía a `estado_proyecto` (taxonomía de ciclo de vida) sino a `semaforo` de `ESTADO.md` (Fase 2), no consumido aún por el script. Se descartó el campo `bloqueante` del handoff por falta de fuente. Se diseñó y ejecutó un encargo a Claude Code que extiende `36` para consumir `semaforo` con fallback a PULL; Claude Code detectó en su PASO 0 que `32`/`35` ya implementaban parseo y desync, y optó correctamente por reusar esa lógica en vez de duplicarla (decisión declarada, verificada empíricamente). Se hizo push a `origin/main` (4 commits). Se investigó P-ESTADO-3-SIN-TRASPASO: el supuesto de "3 hermanos sin traspaso" quedó refutado para 2 de 3 (grafía con guión medio, ya detectada correctamente por el `[_-]` de `32`); el error real fue de una tarea anterior con glob limitado. Se encontró y corrigió un riesgo lateral: un directorio `_BACKUP` no excluido del descubrimiento de hermanos.

## 3. Estado al cierre

**Qué funciona (última ejecución exitosa, esta sesión):**
- `36_generar_panorama_visual.R` genera campo `semaforo` (12/17 con dato, 4 sin `ESTADO.md`, 1 esquema anómalo degradado con gracia), verificado idempotente en 4 artefactos, 0 mojibake, 0 referencias de red, test funcional DOM sin excepciones.
- Push a `origin/main` completado (pendiente confirmación explícita del hash final en el próximo `git status`, ver instrucciones sección 12).
- `PATRON_EXCLUIR_UNIVERSO` excluye directorios `_BACKUP`; verificado con `run_all(only=1)` (17/17, 0 falsos positivos/negativos).
- 32/localizar_documentos.R confirmado correcto: detecta ambas grafías de traspaso (`[_-]`) en los 17 hermanos.

**Qué no funciona / queda pendiente:**
- Orden de filas del panorama sigue por `tipo_pendiente`→`estado_proyecto`→fecha; NO se reordenó por `semaforo` (decisión deliberada de Claude Code, fuera del alcance de Fase 5 del encargo).
- `slep_categoria_desempeno`: `ESTADO.md` con esquema ajeno al contrato Fase 2 (autodescrito como pendiente de reconciliar en su propia sesión 27); fuera de alcance de este repo (R1).
- `slep_resena_proyectos`: único hermano genuinamente sin traspaso.
- P-PAES-DOCUMENTAR: sin cambios.
- Fallback standalone de `leer_estado_hermano()` sin test automatizado permanente (deuda menor, verificado manualmente).

**Delta respecto a v07:** +1 feature (semaforo en panorama); +1 push; +2 pendientes refutados/cerrados (P-ESTADO-3-SIN-TRASPASO reducido a 1 hermano real); +1 fix (exclusión `_BACKUP`); +1 error del asistente (efecto colateral no verificado de `run_all(only=1)`).

## 4. Registro detallado de cambios

**Cambio 1 — Evaluación del handoff de Claude Design.** Contraste campo a campo contra `36`. Hallazgo: `estado` del handoff ≠ `estado_proyecto` del script; corresponde a `semaforo` de `ESTADO.md` (Fase 2 PUSH), no consumido aún. Campo `bloqueante` descartado (sin fuente). Solo 1 alternativa entregada (no 2-3 como pedía la instrucción original de s7). Handoff dejado en `50_documentacion/andamios/design_handoff_monitoreo_cartera/` como referencia, no como fuente de datos.

**Cambio 2 — Plan de contrato de datos (P-FASE2-CONSUME-ESTADO-EN-36).** Decisiones del titular: `semaforo` reemplaza a `estado_proyecto` como fuente primaria de UI/ordenamiento (pero `estado_proyecto` no se elimina del objeto); en conflicto, `ESTADO.md` manda sobre el inventario, con `WARN` registrado; desincronización cae a PULL reusando la regla ya normada en SETTINGS §2.1bis.

**Cambio 3 — Implementación (Claude Code, commit `1b99840`).** Extensión de `construir_objeto()` con campo `semaforo`; indicador de color en fila (HTML) y línea en `.md`. Desviación de diseño declarada y correcta: en vez de duplicar parseo/desync dentro de `36` (como pedía la letra del encargo), se reusó `lista_documentos` en sesión (camino primario, cero parsing nuevo) con fallback standalone que replica la misma fórmula de `32` (`MARGEN_DESYNC_DIAS`, `TZ_ORQUESTADOR`). Evita duplicar lógica que podría divergir (reintroducir el falso-desync de medianoche ya corregido). Verificado: 13/13 hermanos con `ESTADO.md`, 0 divergencias, ambos caminos (primario y standalone) producen resultados idénticos. Orden de filas NO se tocó (tensión entre el invariante "semaforo fuente primaria" y el alcance acotado de Fase 5; documentado, no resuelto unilateralmente). Log completo en `50_documentacion/andamios/logs/20260701_panorama_semaforo_log.md`. Commits: `1b99840` (feat) + `94c4b8a` (docs, log).

**Cambio 4 — Push a `origin/main`.** Encargado a Claude Code tras aprobación explícita.

**Cambio 5 — Investigación P-ESTADO-3-SIN-TRASPASO (refutación).** Diagnóstico completo de los 17 hermanos: `slep_costapresente` (v01) y `slep_minuta_asistencia` (v65, 30 traspasos, actividad reciente) sí tienen traspasos reales, en grafía guión medio. El patrón real de `32` (`(?i)^(traspaso[_-]cierre[_-]v\d+|contexto_v\d+)\.md$`) ya usa clase de caracteres `[_-]` y detecta ambas grafías correctamente en los 17 hermanos. El supuesto de "3 sin traspaso" fue error de una tarea anterior (glob de subagente limitado a guión bajo), no defecto del orquestador. Único hermano real sin traspaso: `slep_resena_proyectos`.

**Cambio 6 — Hallazgo lateral y fix: exclusión de directorios `_BACKUP`.** Durante el diagnóstico anterior apareció `slep_categoria_desempeno_BACKUP_PRE_FILTER_REPO`, no excluido por `PATRON_EXCLUIR_UNIVERSO` (solo `\.git$`). Riesgo: contaminación del inventario en el próximo `run_all()` completo. Fix aplicado: `PATRON_EXCLUIR_UNIVERSO <- "(?i)\\.git$|_backup(_|$)"` (generalizado, no hardcodeado al nombre específico; cubre infijo y sufijo). Verificado contra los 17 slugs reales + 2 casos sintéticos: 0 falsos positivos, 2/2 verdaderos positivos. `run_all(only=1)` confirma 17/17, 0 nuevos. Commit `04f8436`.

## 5. Backlog acumulativo

Ver `50_documentacion/activa/backlog_acumulativo.md`. Pendiente de actualizar con 2 entradas nuevas de esta sesión (semaforo en panorama; fix exclusión backup) — no se generó el archivo actualizado en este chat; queda como acción de apertura de s9 o tarea aparte a Claude Code.

## 6. Bugs de la sesión

**Bug 1 (real, corregido):** `PATRON_EXCLUIR_UNIVERSO` no excluía directorios de respaldo (`_BACKUP`), riesgo de contaminar el inventario de hermanos. Causa raíz: patrón original solo cubría `.git$`, sin anticipar convención de respaldo local. Fix: sección 4, cambio 6. Verificado.

**No-bug (descartado tras diagnóstico):** P-ESTADO-3-SIN-TRASPASO no era un bug del orquestador; `32` ya manejaba ambas grafías correctamente.

## 7. Aprendizajes y restricciones (nuevos en s8)

- **Handoffs de diseño externos son referenciales, no contrato de datos.** Todo campo de un handoff (Claude Design u otro) debe contrastarse explícitamente contra el modelo de datos real del pipeline antes de aceptarse; un campo con nombre similar (`estado`) puede corresponder a una taxonomía distinta (`semaforo` vs. `estado_proyecto`).
- **Comandos de verificación pueden tener efectos colaterales no anticipados.** `run_all(only=N)` no es de solo-lectura per se: el paso 1 sincroniza `registro_proyectos.csv`. Todo comando usado para diagnóstico debe verificarse como realmente de solo-lectura antes de ejecutarse contra el estado real, o revisarse con `git status`/`git diff` inmediatamente después (patrón que el propio Claude Code aplicó correctamente al detectar y revertir la escritura espuria).
- **Un supuesto heredado de una sesión previa (p. ej. "3 hermanos sin traspaso") debe reverificarse contra el código real antes de actuar sobre él**, no solo repetirse en el traspaso siguiente: refuerza el patrón ya señalado en v06/v07 (inferir vs. verificar).

## 8. Decisiones de diseño

**Decisión — Adopción parcial del patrón visual de Claude Design.** Se adopta el indicador de `semaforo` por fila (implementado). Se NO adopta (aún) el rediseño completo (KPIs + banda "requieren atención hoy" + filtros), que queda como decisión futura explícita (P-DESIGN-PANORAMA-ADOPCION). Alternativas consideradas: adoptar el rediseño completo ahora (descartada: requiere decisión de UX no tomada, y depende de que el campo `bloqueante` exista, lo cual se descartó). Justificación: separar el prerequisito técnico (contrato de datos) de la decisión de UX evita mezclar dos cambios conceptuales en una intervención (regla de sesión).

**Decisión — `semaforo` fuente primaria de UI, NO de ordenamiento (por ahora).** El orden de filas permanece `tipo_pendiente`→`estado_proyecto`→fecha (decisión de s6, P-FASE2-PIEZA-C). Reordenar por `semaforo` requiere decisión explícita del titular en sesión futura.

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `PATRON_EXCLUIR_UNIVERSO` | `(?i)\.git$\|_backup(_\|$)` | `10_utils/10_configuracion.R` | **Cambiada esta sesión** (antes: `\.git$` solo) |
| `PATRON_TRASPASO` | `(?i)^(traspaso[_-]cierre[_-]v\d+\|contexto_v\d+)\.md$` | `32_localizar_documentos.R` | Sin cambios; confirmado correcto (detecta ambas grafías) |
| `MARGEN_DESYNC_DIAS`, `TZ_ORQUESTADOR` | sin cambios | `32_localizar_documentos.R` | Reusados (no reimplementados) por el fallback standalone de `36` |

## 10. Arquitectura de archivos

Sin cambios estructurales. Escáner de apertura (2026-07-01 17:37:57) sigue vigente; no re-ejecutado al cierre porque solo cambiaron 2 archivos de código + artefactos regenerados (mismo patrón de rutas).

## 11. Pendientes y ruta sugerida

**P-DESIGN-PANORAMA-ADOPCION** — descripción: decidir si se adopta el rediseño completo del handoff (KPIs + banda + filtros) o se mantiene el acordeón extendido con indicador de semáforo. Tipo: nuevo. Impacto: alto (UX del entregable principal). Complejidad: alta (requiere JS de filtrado/expansión nuevo, sin el runtime `support.js` del handoff). Dependencias: ninguna técnica ya (el contrato de datos está resuelto). Criterio de éxito: decisión explícita documentada como decisión de diseño.

**Reordenar filas por `semaforo`** — descripción: evaluar si el ordenamiento debe migrar de `tipo_pendiente` a `semaforo` como criterio primario. Tipo: mejora visual / decisión de diseño. Complejidad: baja (cambio acotado en `order()`). Dependencias: decisión del titular. Criterio de éxito: decisión registrada, cambio implementado y verificado si se aprueba.

**Backlog acumulativo desactualizado** — descripción: `backlog_acumulativo.md` no refleja los cambios de s8 (semaforo, fix backup). Tipo: documentación. Complejidad: baja. Criterio de éxito: archivo actualizado con 2 entradas nuevas, numeración correlativa continuada desde 54.

**P-PAES-DOCUMENTAR** — sin cambios, bloqueante externo.

**slep_categoria_desempeno esquema ESTADO.md ajeno** — fuera de alcance de este repo (R1); su propia sesión 27 ya lo reconoce como pendiente.

**Fallback standalone de `leer_estado_hermano()` sin test automatizado** — deuda menor, verificado manualmente esta sesión.

**Auditoría de cierre (política 5.6, preguntas "Cierre"):**
- ¿Outputs reproducibles e idempotentes? Sí, verificado (4 artefactos, 2 corridas, md5 estable, sesión 8).
- ¿Decisiones metodológicas como constantes nombradas? Sí; `PATRON_EXCLUIR_UNIVERSO` documentado con comentario de por qué (evitar hardcodear nombre específico).
- ¿Cada transformación crítica tiene check de validación? Sí para los cambios de esta sesión (verificación empírica en ambos: semaforo y exclusión backup).
- ¿Nombres sin tildes/ñ/espacios? Sí, sin desviaciones.

**Ruta sugerida para sesión 9:** Prioridad 1: actualizar `backlog_acumulativo.md` con las entradas de s8. Prioridad 2: decidir P-DESIGN-PANORAMA-ADOPCION (rediseño completo vs. mantener acordeón extendido) y, si aplica, el reordenamiento por `semaforo`. Prioridad 3: verificar si `slep_resena_proyectos` generó su primer traspaso (reduciría a 0 el pendiente de cobertura).

## 12. Instrucciones específicas para la sesión 9

- ⚠️ Antes de correr cualquier comando de "solo verificación" (`run_all(only=N)`, etc.), confirmar si tiene efectos colaterales de escritura; si los tiene, revisar `git status`/`git diff` inmediatamente después.
- ⚠️ Todo handoff de diseño externo (Claude Design u otro) se contrasta campo a campo contra el modelo de datos real antes de aceptarse como contrato.
- ✅ Confirmar en apertura el hash final de `origin/main` tras el push de esta sesión (no verificado explícitamente en el chat, solo encargado).
- ✅ Actualizar `backlog_acumulativo.md` con las 2 entradas de s8 antes de cualquier otro trabajo sustantivo.
- 🔒 Sin escritura a hermanos sin autorización explícita por repo/operación (sin cambios).
- 🔒 Documentos normativos (POLITICA, SETTINGS) nunca se commitean sin aprobación explícita del titular (gate §0.3).
- 🔒 Orden de filas del panorama permanece `tipo_pendiente`→`estado_proyecto`→fecha hasta decisión explícita del titular (no reordenar por `semaforo` sin esa decisión).

## 13. Fragmentos de referencia

```r
# PATRON_EXCLUIR_UNIVERSO (10_utils/10_configuracion.R) — corregido s8.
# Excluye .git y cualquier directorio con "_backup" como infijo o sufijo
# (case-insensitive), sin hardcodear el nombre especifico del caso real.
PATRON_EXCLUIR_UNIVERSO <- "(?i)\\.git$|_backup(_|$)"
```

```r
# PATRON_TRASPASO (32_localizar_documentos.R) — sin cambios, confirmado correcto.
# La clase [_-] ya cubre ambas grafias (guion bajo / guion medio).
PATRON_TRASPASO <- "(?i)^(traspaso[_-]cierre[_-]v\\d+|contexto_v\\d+)\\.md$"
```

## 14. Reapertura

**Nombre del chat:** `slep_estado_proyectos_monitoreo, sesión 9 (Sonnet 5)`

**Mensaje de apertura pre-armado:**
> Continuemos con slep_estado_proyectos_monitoreo. Tipo CONTINUATION. El protocolo (POLITICA_PROYECTO.md v5.2 + SETTINGS_Y_PROMPTS_OPERACIONALES.md v7) vive en la knowledge base del Project y se lee desde ahí. Adjunto el traspaso v08 y el escáner actualizado.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base* (verificar al día, NO adjuntar): `POLITICA_PROYECTO.md` (v5.2), `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (v7).
2. *Opcionales según foco real de s9*: `36_generar_panorama_visual.R` completo si se aborda P-DESIGN-PANORAMA-ADOPCION; handoff de Claude Design (ya en `andamios/`, no requiere re-adjuntar).
3. *Específicos de la sesión (SÍ se adjuntan):* `traspaso_cierre_v08.md` (este archivo); escáner actualizado (`estructura_actual.md`, re-ejecutar al abrir si hubo cambios entre cierre y apertura).

**Nota final obligatoria:** ningún documento normativo cambió de versión durante esta sesión; sin advertencia de desactualización.

## 15. Errores del asistente

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron |
|---|---|---|---|---|---|---|
| Durante el diagnóstico de grafías de traspaso, al ejecutar `run_all(only=1)` como verificación | Detectado por Claude Code mismo, antes de reportar, corregido en el acto | Se asumió que `run_all(only=1)` era de solo-lectura para efectos de diagnóstico; en realidad el paso 1 sincroniza `registro_proyectos.csv` como efecto colateral, escribiendo una fila espuria para un directorio backup detectado | POLITICA §0.2 (no deducir, verificar estado real); B.1 | Se asumió "solo verificación" por el propósito de la tarea (diagnóstico), sin verificar si el comando en sí tenía efectos de escritura, mismo patrón raíz que asumir la firma de `run_all(refrescar=TRUE)` en s7 | POLITICA §0.2; B.1 | variante del patrón ya registrado en v06/v07 (asumir contra el código real sin verificar), ahora sobre efectos colaterales de un comando en vez de su firma o un campo de dato |

**Nota del asistente:** el error fue autodetectado y corregido dentro del mismo turno (verificación con `git status`/`git diff`, reversión antes de commitear), sin llegar a afectar ningún artefacto entregado. Se registra igual porque el patrón raíz (asumir sin verificar contra el código real) es el tercer caso de esta familia en 3 sesiones consecutivas (v06, v07, v08) — candidato firme para análisis cruzado entre proyectos de la cartera (SETTINGS §2.2.15): si la salvaguarda actual (POLITICA §0.2, redactada como regla general de "no deducir") no ha bastado en 3 ocasiones seguidas dentro del mismo proyecto, es evidencia de que el texto de la regla necesita reformularse con un caso de uso más específico (efectos colaterales de comandos de diagnóstico), no solo repetirse.
