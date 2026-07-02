# Log de encargo autónomo — Semáforo de ESTADO.md en el panorama visual

Fecha: 2026-07-01. Repo: slep_estado_proyectos_monitoreo (orquestador).

## 1. Resumen de la sesión

Encargo: extender `36_generar_panorama_visual.R` para consumir `semaforo` desde
`ESTADO.md` de cada hermano (Fase 2 PUSH), con fallback a PULL, usando como
referencia visual el handoff de Claude Design en
`50_documentacion/andamios/design_handoff_monitoreo_cartera/` (NO como fuente de
datos). Ejecutado en un único tramo, modo autónomo secuencial. Estado final:
implementado, verificado empíricamente (17/17 objetos con campo `semaforo`,
idempotente, 0 mojibake, 0 errores en test funcional), commiteado. Sin push.

Antes de escribir código se hizo un PASO 0 de lectura completa: el script
objetivo, el handoff (README + `colors_and_type.css`), un barrido de los 17
`ESTADO.md` reales, el backlog acumulativo (entradas 48-54) y la plantilla de
este mismo log. Ese barrido cambió el diseño de la implementación respecto a
la letra literal del encargo (ver sección 3).

## 2. Inventario de commits

1. `1b99840` — `feat(paso 36): consumir semaforo de ESTADO.md (Fase 2 PUSH) con fallback a PULL`
   — único commit de esta tarea. Toca `30_procesamiento/36_generar_panorama_visual.R`
   y los 5 artefactos regenerados en `40_salidas/` (`inventario_cartera.json`,
   `inventario_cartera.parquet`, `panorama.md`, `panorama_visual.html`,
   `panorama_visual.md`). Sin push.

No hubo commits de diagnóstico/fix separados: el único bug encontrado (ver
sección 5) se corrigió antes de commitear, dentro del mismo tramo de
verificación.

## 3. Cambios sustantivos

**Qué:** nuevo campo `semaforo` (activo|pausa|bloqueado|cerrado) por proyecto,
mostrado como indicador de color junto a `tipo_pendiente` en cada fila del
acordeón (HTML) y como línea `- **semaforo:** X` en el `.md`. El campo
`proximo_paso` de la sección `## Proximo paso` de `ESTADO.md` se antepone (no
reemplaza) a `proximos_pasos` cuando el hermano está sincronizado.

**Por qué esta forma de implementarlo (tensión resuelta):** el encargo pedía
literalmente una función nueva `leer_estado_md()` con su propia detección de
desincronización dentro de 36 (Fase 1/2). El PASO 0 encontró que
`32_localizar_documentos.R` **ya implementa exactamente esto** —
`resolver_estado()` parsea el front matter (`parsear_front_matter()`,
compartido vía `10_utils.R`), detecta desync con margen de tolerancia
(`MARGEN_DESYNC_DIAS`, `TZ_ORQUESTADOR`, ambos de una sesión previa,
P-DESYNC-MARGEN) y ya persiste `tipo_pendiente` en el inventario (34). Además,
`35_compilar_panorama.R` **ya lee `semaforo`** vía
`lista_documentos[[slug]]$estado$meta$semaforo` (precedente ya establecido en
el código, aparentemente por edición directa del titular).

Reimplementar una segunda detección de desync dentro de 36 —tal como la
describe literalmente la Fase 2 del encargo, sin mención de margen— habría
reintroducido el falso-desync de medianoche que se corrigió en una sesión
anterior, y podría producir un veredicto PUSH/PULL **distinto** al de
`panorama.md` para el mismo hermano en la misma corrida (bug de consistencia
entre los dos artefactos). Se optó por un diseño híbrido:

- **Camino primario:** `leer_estado_hermano()` reusa `lista_documentos` EN
  SESIÓN (si 36 corrió como parte de un `run_all()` completo, tras el paso 32)
  — cero parsing nuevo, cero riesgo de divergencia.
- **Camino de respaldo (standalone):** si `lista_documentos` no existe en
  sesión (p. ej. `run_all(only=6)`, patrón de iteración muy usado en este
  proyecto), releo `ESTADO.md` reusando el MISMO parser
  (`parsear_front_matter`) y la MISMA fórmula/constantes de margen
  (`MARGEN_DESYNC_DIAS`, `TZ_ORQUESTADOR`) para no divergir del camino
  primario. Verificado que ambos caminos producen resultados **idénticos**
  contra los 17 hermanos reales (sección 4).

**Archivos tocados:** solo `30_procesamiento/36_generar_panorama_visual.R`
(+193/-9 líneas) más los 5 artefactos regenerados en `40_salidas/`. No se tocó
`32_localizar_documentos.R` ni `34_compilar_inventario.R`.

**Cómo se verificó:** ver sección 4 (auditoría) y la lista de checks en el
reporte al chat (idempotencia en 4 artefactos, 0 mojibake, 0 referencias de
red, test funcional en Node con shim de DOM — 17 filas, 17 puntos de color,
conteo por clase exacto, 0 excepciones).

**Decisión de diseño no trivial — orden de las filas:** el invariante 🔒 del
encargo dice "semaforo es la fuente PRIMARIA para ordenamiento y UI", pero la
Fase 5 del mismo encargo dice explícitamente "esta fase SOLO agrega indicador
de semáforo a la fila, no la reestructura completa del handoff". El orden
actual (`tipo_pendiente` → `estado_proyecto` → fecha, P-FASE2-PIEZA-C) fue una
decisión **explícita y muy reciente del titular** ("Decision del titular
(sesion 6)", ya en el código). Reordenar por `semaforo` aquí habría deshecho
esa decisión sin que este encargo lo pidiera expresamente en sus Fases
numeradas. Se optó por **no tocar el orden** y dejarlo marcado como pendiente
(sección 8) para una futura sesión de adopción completa del handoff
(P-DESIGN-PANORAMA-ADOPCION), en vez de decidir unilateralmente cuál de las
dos frases del encargo pesa más.

**Paleta:** `--amber:#C0871B` y `--danger:#EE2D49` tomados 1:1 de
`design_handoff_monitoreo_cartera/assets/colors_and_type.css` (`--mark-red`) y
del README del handoff ("en pausa #C0871B ámbar derivado"), no inventados. El
indicador es un `<span>` con color de fondo puro CSS (círculo vía
`border-radius`), **sin glifos Unicode** (nada de "●"/"•"): esto evita
introducir un literal no-ASCII nuevo fuera de los bloques ya envueltos en
`u8()` (helper del fix B6), que habría reabierto el riesgo de mojibake.

## 4. Auditoría de diagnóstico

Mandato de auto-auditoría del encargo: imprimir en consola, por cada hermano
con `ESTADO.md`, `semaforo_estado_md` vs `tipo_pendiente_inventario` vs
`tipo_pendiente_final`, para confirmar que "ESTADO.md manda" se aplicó en cada
caso (no solo en el feliz). Implementado como bloque de auditoría justo
después de construir `objetos`, antes del reordenamiento (Fase 2 del script).

**Veredicto:** 13/13 hermanos con `ESTADO.md` → **OK** (sin divergencia; 0
reconciliaciones aplicadas, 0 WARN nuevas). Esto es estructuralmente esperado
con el diseño elegido (semaforo y `tipo_pendiente` vienen de la MISMA lectura
de `ESTADO.md` ya hecha por 32/34, no de dos fuentes independientes que
puedan desincronizarse entre sí) — la auditoría lo confirmó empíricamente en
vez de asumirlo por diseño.

**Caso especial detectado y confirmado por la auditoría —
`slep_categoria_desempeno`:** su `ESTADO.md` tiene un esquema **completamente
distinto** al canónico (claves `proyecto`/`ultima_sesion`/`estado_git`/etc. en
vez de `slug`/`semaforo`/`tipo_pendiente`; sección `## Estado` +
`## Foco próxima sesión` en vez de `## Proximo paso`). El propio archivo se
autodescribe como "no presenciado por s26 (a reconciliar en s27)" — es decir,
el propio hermano ya sabe que su ESTADO.md diverge del contrato. La
degradación con gracia (mismo idioma que `parsear_data_js`) lo absorbió
correctamente: `ultima_actividad` SÍ se parseó (es una clave genérica que
coincide), por lo que `sincronizado=TRUE`, pero `semaforo`/`tipo_pendiente`
quedan `NA` porque esas claves específicas no existen en ese archivo. Sin
error, sin caída del pipeline, exactamente como diseñado. **No se corrigió ni
se tocó ese archivo** (es de otro repo, fuera de alcance de este encargo;
además el propio hermano ya lo tiene anotado como pendiente de reconciliar en
su propia sesión 27).

Tabla completa de la auditoría (13 filas), tal como se imprimió en consola:

```
slep_alertas_ael                     semaforo_estado_md=activo  tp_inventario=cosmetica    tp_final=cosmetica    sincronizado=TRUE  OK
slep_aprendizajes_ep                 semaforo_estado_md=activo  tp_inventario=nuevo        tp_final=nuevo        sincronizado=TRUE  OK
slep_categoria_desempeno             semaforo_estado_md=NA      tp_inventario=NA           tp_final=NA           sincronizado=TRUE  OK
slep_dashboard_personal_monitoreo    semaforo_estado_md=activo  tp_inventario=deuda_tecnica tp_final=deuda_tecnica sincronizado=TRUE  OK
slep_georreferenciacion              semaforo_estado_md=pausa   tp_inventario=bloqueante   tp_final=bloqueante   sincronizado=TRUE  OK
slep_idps                            semaforo_estado_md=activo  tp_inventario=deuda_tecnica tp_final=deuda_tecnica sincronizado=TRUE  OK
slep_minuta_desvinculacion           semaforo_estado_md=activo  tp_inventario=deuda_tecnica tp_final=deuda_tecnica sincronizado=TRUE  OK
slep_monitoreo                       semaforo_estado_md=activo  tp_inventario=nuevo        tp_final=nuevo        sincronizado=TRUE  OK
slep_rendimiento_historico            semaforo_estado_md=activo  tp_inventario=deuda_tecnica tp_final=deuda_tecnica sincronizado=TRUE  OK
slep_reportes_modelo_resguardo_asistencia semaforo_estado_md=activo tp_inventario=deuda_tecnica tp_final=deuda_tecnica sincronizado=TRUE OK
slep_seguimiento_educacion_inicial   semaforo_estado_md=activo  tp_inventario=nuevo        tp_final=nuevo        sincronizado=TRUE  OK
slep_simce_adecuado                  semaforo_estado_md=activo  tp_inventario=ninguno      tp_final=ninguno      sincronizado=TRUE  OK
slep_simce_estandares_aprendizaje    semaforo_estado_md=activo  tp_inventario=ninguno      tp_final=ninguno      sincronizado=TRUE  OK
```

## 5. Bugs encontrados y resueltos

**Bug en el arnés de prueba (no en el script de producción).** Al verificar el
render con un shim de DOM en Node, sobreescribí `global.console = {log: ()=>{},
...}` para silenciar el ruido del JS bajo prueba, pero eso también silenció mis
propios `console.log` de diagnóstico (el harness no imprimía nada, con exit
code 0). Causa raíz: un único objeto `console` global compartido entre el
arnés y el código bajo prueba. Fix: aislar el `console` fake dentro de una
`new Function('console', codigoJS)`, dejando el `console.log` real del arnés
intacto. Verificado: el test volvió a imprimir correctamente. Este bug no tocó
ningún artefacto entregado (era puramente de la herramienta de verificación).

No se encontraron bugs en el código de producción (`36_generar_panorama_visual.R`).

## 6. Verificación de invariantes (🔒)

| Invariante | Veredicto | Evidencia |
|---|---|---|
| Lectura de hermanos confinada a `50_documentacion/` (R2) | **PASA** | `leer_estado_hermano()` solo lee `<slug>/50_documentacion/activa/ESTADO.md`; mismo patrón que traspaso/backlog ya usado en el script. |
| `estado_proyecto` permanece sin cambios en el JSON | **PASA** | Campo no tocado; sigue presente en `construir_objeto()`, verificado en el diff (`git diff` no lo modifica). |
| `semaforo` es fuente primaria para UI cuando disponible/sincronizada | **PASA (parcial, ver nota)** | Indicador de color primario por fila implementado. Para ORDENAMIENTO se dejó explícitamente sin tocar (ver sección 3, decisión de diseño) — marcado como pendiente, no como incumplimiento silencioso. |
| Conciliación tipo_pendiente: ESTADO.md manda si difiere del inventario, WARN con slug+ambos valores | **PASA** | Implementado (override + `advertencias`); 0 divergencias reales encontradas (auditoría, sección 4), por lo que nunca se disparó en esta corrida — verificado que el mecanismo existe y está cableado, no solo que "no hizo falta". |
| Desincronización: `ultima_actividad` < mtime traspaso → PULL (semaforo=NA) + advertencia | **PASA** | Reusa `resolver_estado()` (32, con margen `MARGEN_DESYNC_DIAS`) en el camino primario; camino de respaldo standalone replica la MISMA fórmula. Verificado con test controlado (scratch, sin tocar hermanos): ambos caminos producen `semaforo=NA` cuando desincronizado. |
| Sin ESTADO.md → PULL directo (semaforo=NA), sin error | **PASA** | `slep_costapresente`, `slep_minuta_asistencia`, `slep_paes`, `slep_resena_proyectos`: `semaforo:null` en el JSON, 0 líneas `[ERROR]` en el log. |
| No tocar `20_insumos/`, no escribir a hermanos, no commitear POLITICA/SETTINGS | **PASA** | `git status` confirma `POLITICA_PROYECTO.md`/`SETTINGS_Y_PROMPTS_OPERACIONALES.md` fuera del stage; ningún archivo de hermano escrito (solo lectura, verificado por diseño de `leer_estado_hermano()`). |
| HTML 100% autocontenido (cero red) | **PASA** | `grep -coE '<link\|@import\|src=.?http\|href=.?http\|url\(http'` = 0. |
| 0 mojibake (B6 no reaparece) | **PASA** | `grep -cP '<[0-9a-f]{2}>'` = 0 en `.html` y `.md`. Literal no-ASCII nuevo evitado deliberadamente (indicador sin glifo Unicode). |

## 7. Decisiones del usuario registradas

Ninguna requerida durante la ejecución: el encargo llegó completo y las
ambigüedades encontradas (duplicación de lógica de desync, tensión entre el
invariante de ordenamiento y la Fase 5) se resolvieron con criterio de
implementador dentro del margen de autonomía declarado (0.3), documentando la
razón en vez de detener la tarea o inventar sin declarar. Ninguna tocaba
gobernanza de datos ni una decisión estratégica genuinamente irresoluble sin
el titular.

## 8. Pendientes abiertos / # REVISAR

- `# REVISAR` — **Orden de las filas por semáforo.** El invariante 🔒 del
  encargo sugiere `semaforo` como criterio primario de ordenamiento; esta
  sesión lo dejó SIN tocar (sigue `tipo_pendiente` → `estado_proyecto` →
  fecha, P-FASE2-PIEZA-C) por ser una decisión explícita y reciente del
  titular que este encargo no pedía reabrir en sus Fases numeradas. Si se
  quiere adoptar el orden del handoff (`tipo` → `estado`/semáforo → fecha),
  requiere una decisión explícita del titular en una sesión futura.
- `# REVISAR` — **`slep_categoria_desempeno`: ESTADO.md con esquema ajeno al
  contrato Fase 2 PUSH.** No es un bug de este orquestador (es contenido de
  un hermano, fuera de alcance R1); el propio archivo ya se autodescribe como
  pendiente de reconciliar en su sesión 27. Se degrada con gracia
  (`semaforo=NA`), sin bloquear nada.
- **P-DESIGN-PANORAMA-ADOPCION** (mencionado por el propio encargo, no creado
  como entrada de backlog en esta sesión): el handoff completo propone un
  patrón Triage (KPIs + banda "requieren atención hoy" + filtros); esta
  sesión solo agregó el indicador de semáforo a la fila existente, sin
  adoptar el rediseño completo. Queda como candidato de una sesión futura,
  con decisión estratégica del titular sobre si se adopta.
- **Fallback standalone de `leer_estado_hermano()` no está cubierto por un
  test automatizado permanente** — se verificó manualmente (scratch +
  `run_all(only=6)` real) en esta sesión, pero no quedó como test repetible.
  Bajo riesgo (la fórmula es idéntica a la del camino primario, ya probado en
  producción), pero se anota como deuda menor.

## 9. Estado de cifras/datos críticos

- `n_total` (17 proyectos) sin cambios.
- `estado_proyecto`, `tipo_pendiente`, `categoria`, `datos_sensibles`:
  intactos, no tocados por este cambio (verificado en el diff de
  `construir_objeto()`: solo se agregó el campo `semaforo`, no se modificó
  ningún campo existente).
- Idempotencia verificada en los 4 artefactos regenerados
  (`panorama_visual.html`, `panorama_visual.md`, `panorama.md`,
  `inventario_cartera.parquet`) con md5 estable en 2 corridas completas de
  `run_all()` (excluyendo la línea `Generado:` con timestamp).
- `n_con_semaforo = 12` de 17 (11 activo + 1 pausa); `5` con `semaforo=null`
  (4 sin `ESTADO.md` + 1 con esquema anómalo).

## 10. Notas para el revisor

- El punto más importante a revisar con ojo crítico: la decisión de **no**
  reimplementar el parseo/desync independiente en 36 (sección 3). Si el
  titular prefiere que 36 tenga su propia lógica autocontenida —aunque
  duplique 32— por razones de aislamiento entre módulos, esta decisión
  debería revertirse explícitamente; tal como quedó, 36 depende (en su camino
  primario) de que 32 haya corrido en la misma sesión, con un fallback
  standalone que replica la fórmula pero no la referencia directamente
  (riesgo de deriva silenciosa si `MARGEN_DESYNC_DIAS`/`TZ_ORQUESTADOR`
  cambian de nombre o semántica en 32 sin actualizar 36 en paralelo).
- Vale la pena, en una sesión de limpieza, evaluar si conviene mover
  `leer_estado_hermano()` (o su lógica de fallback) a `10_utils.R` para que
  ambos scripts (32 y 36) compartan una única implementación, en vez de dos
  que coinciden HOY por construcción cuidadosa pero podrían divergir en el
  futuro si alguien edita solo una de las dos.
- El indicador visual (punto de color CSS puro, sin glifo Unicode) es una
  decisión deliberada, no un descuido: revisar que futuras adiciones a este
  script sigan el mismo cuidado con literales no-ASCII fuera de los bloques
  `u8()` (B6 ya se corrigió dos veces en este proyecto; es un patrón de
  riesgo recurrente).
- `panorama.md` (paso 35, no tocado en esta sesión) cambió en el mismo commit
  porque se regeneró junto con el resto del pipeline; su diff refleja *drift*
  externo (el `ESTADO.md` de `categoria_desempeno` cambió de esquema entre
  sesiones; `costapresente` usa el mecanismo *legacy* de caché PULL de 35,
  no relacionado con `ESTADO.md`). No se investigó más a fondo por estar
  fuera del alcance de este encargo (paso 35 no se tocó).
