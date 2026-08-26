# Traspaso de cierre — v11

## 1. Identificación

- **Proyecto:** `slep_estado_proyectos_monitoreo` (remoto: `tomgc/slep_estado_area_monitoreo`)
- **Versión:** v11
- **Fecha:** 2026-07-10
- **Sesión:** 11. Foco: resolución del pendiente P3 (desalineación de nombres
  directorio-local vs. repo-remoto) e incorporación de los hermanos nuevos
  descubiertos en disco.
- **Entorno:** R / Positron; Claude conversacional (análisis) + Claude Code
  (ejecución autónoma).
- **Archivos principales modificados:** `20_insumos/registro_proyectos.csv`
  (regenerado por `run_all()`: 17 → 21 hermanos), `40_salidas/*` (inventario,
  panorama, panorama_visual regenerados).
- **Archivos nuevos:**
  `50_documentacion/andamios/20260710_inventario_repos_y_nuevos.md`,
  `50_documentacion/activa/decisiones/20260710_decision_desalineacion_nombres_repos.md`.

## 2. Resumen ejecutivo

La sesión resolvió por completo el pendiente P3 y, en el camino, corrigió una
premisa estructural errónea: el universo real de la cartera es de **21 hermanos +
orquestador**, no 17. Un inventario de solo-lectura sobre los 22 directorios
`slep_*` confirmó los 2 casos de desalineación conocidos, detectó un tercero
(`slep_lectoescritura`), y descubrió 4 hermanos nuevos ausentes del registro. Las
3 desalineaciones se resolvieron por decisión formal: mapeo aceptado para
`slep_georreferenciacion` (proyecto cerrado) y para el orquestador (ancla del
sistema), y alineación real para `slep_lectoescritura` (remoto renombrado a la
forma corta canónica). `run_all()` corrió limpio (6/6) e incorporó los 4 nuevos al
registro sin bajas espurias. Al verificar el estado de los `ESTADO.md`, se
descubrió deuda de propagación Fase 2 real (4 proyectos con `sesion_actual` menor
que la vNN de su último traspaso) y, más grave, que 2 de esos traspasos estaban
**sin versionar**. El rescate de uno (`slep_paes`) se completó; el del otro
(`slep_reportes_modelo_resguardo_asistencia`) se abortó al descubrirse que ese
repo tiene una sesión entera cortada a mitad de cierre, lo que excede el alcance
del orquestador y queda como pendiente de sesión propia.

## 3. Estado al cierre

**Qué funciona:**
- `run_all()` corre limpio, 6/6 pasos, 1.35 s (última ejecución: 2026-07-10 11:37).
- El registro refleja el universo real: 21 hermanos, 4 nuevos incorporados,
  0 bajas.
- El panorama visual se genera con 21 proyectos, 15 en PUSH, 6 en PULL.
- El detector de desync (`resolver_estado()`) funciona correctamente: se auditó
  contra la hipótesis de falso positivo y resultó verdadero positivo en los 4 casos.

**Qué no funciona / deuda visible:**
- 4 hermanos con `ESTADO.md` desactualizado (deuda de propagación Fase 2, ver §11).
- 4 hermanos nuevos con metadatos sin curar en el registro.
- `slep_reportes_modelo_resguardo_asistencia` con sesión cortada a mitad de cierre.

**Delta respecto a v10:**
- Universo corregido: 17 → 21 hermanos (la cifra de v10 estaba desactualizada).
- P3 cerrado (era el pendiente principal heredado).
- Casos P3: 2 → 3 (uno nuevo detectado y resuelto).

## 4. Registro detallado de cambios

### 4.1 Inventario de repos y proyectos nuevos (andamio)
- **Archivo:** `50_documentacion/andamios/20260710_inventario_repos_y_nuevos.md`
- **Categoría:** diagnóstico / deuda de datos.
- **Qué:** cruce de solo-lectura de los 22 directorios `slep_*` de `~/Projects/`:
  nombre local vs. remoto (`git remote -v`), presencia en el registro, presencia
  de `ESTADO.md` y de traspasos.
- **Por qué:** P3 exigía inventariar la desalineación; el titular añadió el
  descubrimiento de proyectos nuevos al alcance.
- **Cómo se verificó:** ejecución de solo-lectura, sin `fetch`/`push`/`run_all()`;
  archivo dejado untracked para revisión.
- **Hallazgo metodológico:** el descubrimiento es **por convención pura**
  (`descubrir_hermanos()` filtra `startsWith("slep_")` sobre los subdirectorios de
  `RAIZ_PROYECTOS`); el CSV es **destino de sincronización y metadatos curados**,
  no allowlist. Consecuencia: un proyecto nuevo no requiere edición manual del CSV
  para incorporarse; entra solo en el próximo `run_all()`. Esto disparó la regla de
  detención del encargo y obligó a sustituir `en_registro_csv` por
  `descubierto_por_pipeline` como criterio.

### 4.2 Decisión formal sobre las 3 desalineaciones de nombre
- **Archivo:** `50_documentacion/activa/decisiones/20260710_decision_desalineacion_nombres_repos.md`
- **Categoría:** gobernanza documental.
- **Qué:** decisión por caso, con alternativas y justificación (ver §8).
- **Por qué:** convertir deuda tácita en decisión trazable, para que no se
  re-descubra en cada auditoría.

### 4.3 Alineación del nombre remoto de `slep_lectoescritura`
- **Categoría:** deuda de nomenclatura.
- **Qué:** `gh repo rename slep_lectoescritura --repo tomgc/slep_desarrollo_lectoescritura`
  + `git remote set-url origin` en el directorio local.
- **Por qué:** era el único de los 3 casos donde alinear era barato (proyecto
  activo aún no sincronizado al registro, sin `ESTADO.md` consumido todavía).
- **Cómo se verificó:** `git remote -v` antes y después; `git ls-remote origin HEAD`
  resuelve (`54b56bd3f2ad703b3d7f8132cf9a6d1c82d869f4`). Protocolo HTTPS. Sin push,
  sin colisión de nombre (verificada antes de mutar).

### 4.4 Incorporación de los 4 hermanos nuevos al registro
- **Archivo:** `20_insumos/registro_proyectos.csv` (regenerado por `run_all()`).
- **Categoría:** deuda de datos.
- **Qué:** `run_all()` completo. Paso 1: `Registro sincronizado: 21 filas (4 nuevos,
  0 bajas)`. Nuevos: `slep_estudio_oferta_demanda`, `slep_lectoescritura`,
  `slep_minuta_buenas_senales`, `slep_minuta_matricula`.
- **Cómo se verificó:** log completo del pipeline; chequeo cruzado de precedencia
  del paso 6 marcó **OK en las 21 filas**; los 3 nuevos con traspaso entraron como
  PUSH, el placeholder (`slep_minuta_matricula`) como PULL (sin `ESTADO.md`), que
  es el comportamiento correcto.
- **Pendiente asociado:** los 4 entraron con metadatos sin curar (`nombre_real`,
  `alias_corto`, `notas`, `datos_sensibles`).

### 4.5 Rescate del traspaso sin versionar de `slep_paes`
- **Categoría:** contención de riesgo / gobernanza.
- **Qué:** commit + push de `50_documentacion/traspasos/traspaso_cierre_v07.md`
  en `slep_paes` (estaba untracked: el cierre existía en disco pero no en el
  historial).
- **Cómo se verificó:** gate de gobernanza previo (RUT 0, emails 0, rutas `/Users/`
  0, sin nombres de personas ni de establecimientos; traspaso leído íntegro, 298
  líneas); solo el traspaso staged; commit
  `087a80bf6f55d8238ad4bfbf6477f4f25ecad5bb`; push confirmado contra `origin/main`.

## 5. Backlog acumulativo

Ver `50_documentacion/activa/backlog_acumulativo.md`. Entradas nuevas de esta
sesión (62-67), numeración correlativa global continuando desde la 61 de v10:

- **62.** Inventario de solo-lectura de los 22 directorios `slep_*`: nombre local
  vs. remoto, registro, `ESTADO.md`, traspasos.
- **63.** Corrección del universo de la cartera: 17 → 21 hermanos + orquestador.
- **64.** Decisión formal sobre las 3 desalineaciones de nombre (2 mapeos
  aceptados, 1 alineación real).
- **65.** Alineación del remoto de `slep_lectoescritura` a la forma corta canónica.
- **66.** Incorporación de los 4 hermanos nuevos al registro vía `run_all()`.
- **67.** Rescate del traspaso v07 de `slep_paes` (untracked → versionado).

**Delta:** 6 entradas nuevas. Sin refinamientos de taxonomía ni reclasificaciones.

## 6. Bugs de la sesión

**No aplica en esta sesión.** No se detectaron bugs de código. Se auditó
explícitamente la hipótesis de que el detector de desync (`resolver_estado()`)
produjera falsos positivos por usar `mtime` como criterio de frescura; el
diagnóstico descartó la hipótesis (4 de 4 verdaderos positivos). El detector
funciona.

## 7. Aprendizajes y restricciones descubiertas

### A21 — El descubrimiento por convención hace del CSV un destino, no una fuente
- **Regla:** `registro_proyectos.csv` no gobierna el universo: lo refleja.
  `descubrir_hermanos()` descubre por patrón de nombre sobre el filesystem
  (`startsWith("slep_")`), y `31_` regenera el CSV desde lo descubierto,
  preservando columnas curadas y conservando desaparecidos como `categoria="baja"`.
- **Contexto (qué pasa si se viola):** tratar el CSV como allowlist lleva a
  "incorporar" proyectos editándolo a mano, cuando basta correr `run_all()`.
  Inversamente, renombrar un **directorio local** sí cambia el slug descubierto y
  produce baja + alta; renombrar el **remoto** no afecta al pipeline.
- **Principio:** B.1 (sin supuestos implícitos) — verificar contra el código real,
  no inferir el rol de un archivo por su nombre.

### A22 — El mtime no es evidencia de cierre; la vNN declarada sí
- **Regla:** para juzgar si un `ESTADO.md` está vigente, el criterio robusto es
  comparar su `sesion_actual` contra la vNN del último traspaso (y su
  `ultima_actividad` contra la fecha declarada *dentro* del traspaso), no contra el
  `mtime` del archivo en disco. El mtime se altera por operaciones de filesystem
  (pull, checkout, sync) sin que haya habido cierre nuevo.
- **Contexto:** en esta sesión la hipótesis de falso positivo por mtime resultó
  falsa, pero el método de discriminación es el que hay que conservar: se verificó
  contra `sesion_actual` y contra la fecha declarada, no contra el mtime.
- **Nota:** el detector actual del orquestador usa mtime y **acertó** en los 4
  casos. No se cambia lo que funciona; queda anotado como zona a vigilar si
  aparecen falsos positivos futuros.

### A23 — Un repo con la sesión cortada no se rescata con un commit acotado
- **Regla:** antes de commitear un artefacto suelto en un repo hermano, verificar
  el estado **general** del working tree e índice, no solo la presencia del archivo
  objetivo. Un traspaso untracked puede ser el síntoma visible de un cierre entero
  a medias (más traspasos sin versionar, código sin commitear, índice a medio
  stagear).
- **Contexto:** commitear el traspaso v42 dejando el v41 untracked habría producido
  un historial incoherente (un cierre que referencia un estado anterior
  inexistente): peor que no hacer nada.
- **Principio:** B.1 — el encargo se construyó sobre un diagnóstico parcial.

## 8. Decisiones de diseño

### D1 — Mapeo aceptado para las desalineaciones de `georreferenciacion` y del orquestador
- **Alternativas:** renombrar el directorio local; renombrar el remoto; aceptar el
  mapeo (elegida).
- **Justificación:** `slep_georreferenciacion` está cerrado (`semaforo=cerrado`);
  renombrar un proyecto terminado no aporta y arriesga romper referencias. El
  orquestador es el ancla del sistema (`SLUG_ORQUESTADOR`, rutas de configuración,
  `.Rproj`, autoexclusión del universo): el costo de alinear supera con creces un
  beneficio cosmético, y su desalineación no afecta el descubrimiento.
- **Implicancia:** las operaciones remotas sobre estos dos usan el nombre remoto
  (`slep_territorio_costa_central`, `slep_estado_area_monitoreo`). Deuda de
  nomenclatura **aceptada**, no pendiente.

### D2 — Forma corta como nombre canónico de lectoescritura
- **Alternativas:** adoptar la forma larga del remoto renombrando el directorio
  local (arrastra cambio de slug: baja + alta en el registro); alinear a la forma
  corta renombrando el remoto (elegida); aceptar el mapeo.
- **Justificación:** proyecto activo y nuevo, aún sin fila en el registro ni
  `ESTADO.md` consumido: el momento más barato para alinear. La forma corta es la
  que el pipeline ya produce por convención y es consistente con el resto de la
  cartera (ningún hermano lleva prefijo `desarrollo_`). El rename recae en el
  remoto: sin efecto sobre slug, rutas ni descubrimiento.

### D3 — No sanear el nombre propio del titular en un traspaso ya escrito
- **Contexto:** el gate de gobernanza detuvo el commit del traspaso v42 de
  `slep_reportes_...` al encontrar "Tomás" (nombre de pila del titular) en 2 líneas.
- **Decisión:** levantar la detención sin sanear.
- **Justificación:** es autorreferencia del titular en su propia documentación, en
  repo privado; no es dato de un tercero ni de NNA (el marco de las Leyes 19.628 /
  21.719 protege datos de terceros). Además, los traspasos son registro histórico:
  se agregan, no se reescriben. El costo de sanear supera un riesgo nulo.
- **Nota:** el gate hizo lo correcto al detenerse y escalar la decisión en vez de
  resolverla por su cuenta.

### D4 — Abortar el rescate de `slep_reportes_...` en vez de completarlo parcialmente
- **Alternativas:** des-stagear las entradas preexistentes y commitear solo el v42;
  dejar que el titular revise; abortar y escalar a sesión propia (elegida).
- **Justificación:** versionar el v42 dejando el v41 untracked y el pipeline
  modificado sin commitear produce un historial incoherente. Un repo a medio cerrar
  se rescata en su propia sesión CONTINUATION, con su traspaso y contexto delante,
  no con un commit acotado desde el orquestador.
- **Implicancia:** el repo quedó **exactamente** como se encontró (el `git add` de
  Claude Code fue revertido con `git restore --staged`; las 4 entradas de
  `estructura/` preexistentes no se tocaron).

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `MARGEN_DESYNC_DIAS` | `1L` | `10_configuracion.R` | Sin cambios |
| `PATRON_EXCLUIR_UNIVERSO` | `(?i)\.git$\|_backup(_\|$)` | `10_configuracion.R` | Sin cambios; ningún directorio lo matcheó |
| `SLUG_ORQUESTADOR` | `slep_estado_proyectos_monitoreo` | `10_configuracion.R` | Autoexclusión del universo |
| `LEER_GIT` | `FALSE` | `10_configuracion.R` | Sin cambios |

## 10. Arquitectura de archivos

Estructura sin cambios estructurales. Dos archivos nuevos:
- `50_documentacion/andamios/20260710_inventario_repos_y_nuevos.md` (andamio
  congelado).
- `50_documentacion/activa/decisiones/20260710_decision_desalineacion_nombres_repos.md`.

**Nota:** el escáner referenciado (`estructura_actual.md`) es del 2026-07-02 y no
incluye estos dos archivos. Correr `00_escanear_proyecto.R` al abrir la sesión 12.

## 11. Pendientes y ruta sugerida

### P1 — Rescate de `slep_reportes_modelo_resguardo_asistencia` (sesión cortada)
- **Descripción:** el repo tiene una sesión entera cortada a mitad de cierre:
  `traspaso_cierre_v41.md` **y** `traspaso_cierre_v42.md` untracked, los scripts
  `31/32/33/34` modificados sin versionar, e índice a medio stagear (2 renames de
  `estructura/` + 2 `estructura_actual` modificados).
- **Tipo:** bloqueante (riesgo de pérdida irreversible de memoria del proyecto).
- **Impacto:** dos cierres existen solo en un disco; si se pierde la máquina, se
  pierden. Es el pendiente de mayor gravedad de la cartera.
- **Dependencias:** ninguna. Debe hacerse en sesión CONTINUATION **de ese
  proyecto**, no desde el orquestador.
- **Complejidad:** Media (hay que reconstruir qué quedó a medias y en qué orden
  commitear).
- **Precauciones:** 🔒 no commitear el v42 sin el v41 (historial incoherente).
  Revisar qué hacen los cambios de `31/32/33/34` antes de versionarlos.
- **Criterio de éxito:** ambos traspasos versionados y pusheados, en orden; working
  tree limpio o con lo pendiente declarado.

### P2 — Re-destilar 4 `ESTADO.md` desactualizados (deuda Fase 2)
- **Descripción:** `slep_idps` (ESTADO en s26, traspaso v28), `slep_minuta_asistencia`
  (v65 / v68), `slep_paes` (v04 / v07), `slep_reportes_...` (v40 / v42). En los 4,
  `sesion_actual` < vNN del último traspaso: hubo cierres que no regeneraron el
  `ESTADO.md` (SETTINGS §2.1bis incumplida en esos cierres).
- **Tipo:** deuda técnica.
- **Impacto:** bajo. El orquestador degrada correctamente a PULL y lee del traspaso,
  que es *más fresco*. No hay cifra errónea publicada; solo se pierde la lectura
  barata de Fase 2.
- **Dependencias:** el de `slep_reportes_...` depende de P1 (su traspaso fuente aún
  no está versionado). El de `slep_paes` está **bloqueado** por la inconsistencia de
  gobernanza no resuelta (ver P3): su campo `maneja_sensibles` es justo el que está
  en disputa entre `ESTADO.md` y `gobernanza_datos.md`.
- **Complejidad:** Baja por proyecto.
- **Criterio de éxito:** `run_all()` posterior muestra los 4 en PUSH.

### P3 — Reconciliar la gobernanza de `slep_paes` (heredado de v10)
- **Descripción:** inconsistencia entre `ESTADO.md` y `gobernanza_datos.md` de
  `slep_paes` sobre la categoría de datos.
- **Tipo:** deuda heredada.
- **Dependencias:** bloquea la re-destilación de su `ESTADO.md` (P2).
- **Complejidad:** Baja, pero requiere decisión del titular.

### P4 — Curar metadatos de los 4 hermanos nuevos
- **Descripción:** `nombre_real`, `alias_corto`, `notas`, `datos_sensibles` de
  `slep_estudio_oferta_demanda`, `slep_lectoescritura`, `slep_minuta_buenas_senales`,
  `slep_minuta_matricula`. El pipeline preserva estas columnas una vez escritas.
- **Tipo:** deuda de datos.
- **Impacto:** cosmético en el panorama (los proyectos aparecen sin nombre curado).
- **Complejidad:** Baja. Edición manual del CSV (tarea del titular, regla 0.4).
- **Fuente sugerida:** `data.js` del sitio del SLEP Costa Central para `nombre_real`.

### P5 — Decidir el destino de `slep_minuta_matricula`
- **Descripción:** directorio sin `.git`, sin estructura canónica, sin traspaso ni
  `ESTADO.md`. Pasa el filtro de nombre de `31_` y aparece en el panorama como
  `no_canonica` / PULL sin fuente.
- **Tipo:** nuevo (decisión).
- **Opciones:** inicializar como proyecto Rama A/B con estructura canónica; o
  renombrarlo fuera del patrón `slep_*` para que el pipeline lo ignore.
- **Complejidad:** Baja.

### P6 — Verificación visual real ≤640px (heredado de v10)
- **Descripción:** la verificación estructural se hizo; falta confirmar el render
  real en móvil.
- **Tipo:** cosmética.
- **Dependencias:** requiere navegador disponible en el entorno de Claude Code.

### Auditoría de cierre (POLITICA 5.6)

| # | Pregunta | Respuesta |
|---|---|---|
| 2 | ¿El pipeline corre de cero sin intervención manual? | Sí — `run_all()` 6/6 limpio |
| 5 | ¿Cada transformación crítica tiene check de validación? | Sí — chequeo cruzado de precedencia (paso 6), OK en 21/21 |
| 6 | ¿Los outputs son reproducibles e idempotentes? | Sí |
| 7 | ¿Decisiones metodológicas como constantes nombradas? | Sí — sin números mágicos nuevos |
| 8 | ¿Nombres sin tildes, ñ ni espacios? | Sí — verificado en los 2 archivos nuevos |

Sin respuestas "no": no se agregan pendientes por auditoría.

### Ruta sugerida para la sesión 12

1. **P1** (rescate de `slep_reportes_...`) — **en sesión propia de ese proyecto**,
   no del orquestador. Es lo único con riesgo de pérdida irreversible.
2. **P4** (curar metadatos) — barato, cierra el ciclo de la incorporación de hoy.
3. **P3 → P2** (gobernanza de `paes`, luego re-destilar los `ESTADO.md`) — en ese
   orden, porque P3 desbloquea P2.

**Diferir:** P5 y P6 (sin urgencia, sin dependencias).

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ **NO** commitear el traspaso v42 de `slep_reportes_...` sin versionar antes el
  v41: produce un historial incoherente.
- ⚠️ **NO** re-destilar el `ESTADO.md` de `slep_paes` sin resolver antes su
  inconsistencia de gobernanza (P3): el campo `maneja_sensibles` es el que está en
  disputa.
- ✅ **ANTES** de commitear un artefacto suelto en un repo hermano, verificar el
  estado **general** del working tree e índice (A23), no solo la presencia del
  archivo objetivo.
- ✅ **ANTES** de asumir que un `ESTADO.md` está vigente, comparar su
  `sesion_actual` contra la vNN del último traspaso (A22). No basta la afirmación de
  que "se actualizan en cada cierre".
- 🔒 El universo de la cartera es **21 hermanos + orquestador**. La cifra "17" de
  traspasos anteriores está obsoleta.
- 🔒 El registro (`registro_proyectos.csv`) es **destino**, no fuente: no se editan
  altas a mano; se corre `run_all()` (A21). Sí se editan a mano las columnas curadas.
- 🔒 Las desalineaciones de `slep_georreferenciacion` y del orquestador son **deuda
  aceptada por decisión formal**, no pendientes. No re-abrirlas.
- 🔒 Escritura en repos hermanos: requiere autorización explícita del titular, por
  repo y por operación.

## 13. Fragmentos de código de referencia

Correr el pipeline desde consola (el guard de autoejecución solo dispara bajo
`Rscript`; con `source()` desde consola hay que invocar `run_all()` explícitamente):

```r
source("/Users/tomgc/Projects/slep_estado_proyectos_monitoreo/00_run_all.R")
run_all()
```

Verificar el nombre remoto real de un repo (nunca inferirlo del directorio local):

```bash
cd /Users/tomgc/Projects/<repo>
git remote -v
```

## 14. Reapertura

- **Nombre del chat:** `slep_estado_proyectos_monitoreo, sesión 12 (Claude Opus 4.8)`
- **Mensaje de apertura pre-armado:**

  > Continuemos con `slep_estado_proyectos_monitoreo`. Tipo CONTINUATION. El
  > protocolo (`POLITICA_PROYECTO.md` + `SETTINGS_Y_PROMPTS_OPERACIONALES.md`) vive
  > en la knowledge base del Project y se lee desde ahí. Adjunto el traspaso v11 y
  > el escáner actualizado.

- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base* (NO adjuntar; verificar que estén al día):
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
     **⚠️ Pendiente de sincronización:** la knowledge base tiene v5.2 / v7; el repo
     local declara v5.3 / v8. Subir las versiones vigentes antes de abrir la sesión 12.
  2. *Opcionales según el foco:* `gobernanza_datos.md` de `slep_paes` si se aborda P3.
  3. *Específicos (SÍ adjuntar):* `traspaso_cierre_v11.md`; `estructura_actual.md`
     (correr el escáner primero: el vigente es del 2026-07-02 y no incluye los dos
     archivos nuevos de esta sesión).

- **Nota final:** si `slep_reportes_modelo_resguardo_asistencia` se rescata en su
  propia sesión antes de la 12, avisarlo al abrir: cambia el estado de P1 y P2.

## 15. Errores del asistente (POLITICA 0.5)

| Campo | Error 1 |
|---|---|
| `momento` | Tras completar el inventario P3, al proponer el siguiente paso |
| `disparador` | Usuario lo corrigió ("recuerda no preguntarme que hacer") |
| `que_paso` | Presenté un menú de opciones preguntando qué tarea tomar, en vez de listar pendientes y proponer una ruta con recomendación |
| `regla_violada` | POLITICA §0.3 (autonomía con interrupciones mínimas) + `userPreferences` (autonomía) + SETTINGS §1.2.4 (Fase C: el asistente propone, no espera que el usuario diga qué hacer) |
| `causa_raiz` | Traté una decisión de priorización táctica (qué pendiente abordar) como si fuera una decisión estratégica que requiere gate del titular. La regla es clara: los gates son para continuidad del proyecto y gobernanza, no para el orden del trabajo ya aprobado |
| `salvaguarda_presente` | POLITICA + SETTINGS + `userPreferences` (tres documentos) |
| `patron` | Variante del patrón ya registrado en v10 §15 (fragmentar de más entre tareas ya aprobadas) |

| Campo | Error 2 |
|---|---|
| `momento` | Al redactar el encargo de rescate de los 2 traspasos untracked (P1) |
| `disparador` | Claude Code lo señaló al detenerse ante el índice pre-sucio |
| `que_paso` | Construí el encargo sobre un diagnóstico parcial: asumí que el único problema de `slep_reportes_...` era el traspaso v42 untracked, cuando el repo tenía una sesión entera cortada (v41 también untracked, pipeline modificado, índice a medio stagear). Presenté la operación como acotada y de bajo riesgo |
| `regla_violada` | B.1 (pensar antes de codificar: sin supuestos implícitos) + SETTINGS §1.2.6 (nunca operar sobre un estado supuesto: leer el estado real primero) |
| `causa_raiz` | El inventario de la sesión solo consultó el traspaso de vNN más alta y su presencia en el índice; nunca miró el `git status` general de los repos hermanos. Extendí una conclusión válida sobre un archivo a una conclusión inválida sobre el repo completo |
| `salvaguarda_presente` | POLITICA (§5.1, B.1) + SETTINGS (§1.2.6) |
| `patron` | Variante del patrón dominante de la cartera: **asumir estado en vez de verificarlo contra el sistema real** (registrado en v6-v10) |

**Nota de análisis cruzado:** el error 2 es la enésima aparición del mismo patrón
(asumir-sin-verificar). Las salvaguardas existentes (B.1, §1.2.6) lo enuncian pero
no lo previenen. Lo que **sí** lo atrapó en esta sesión fue una salvaguarda
distinta: la **regla de detención del encargo** ("si algo distinto al objetivo queda
staged, PARA"), que operó en el ejecutor y no en el redactor. Sugerencia para
`herramientas_dev`: los encargos a Claude Code deben incluir sistemáticamente un
Paso 0 de lectura del estado **general** del repo (no solo del artefacto objetivo)
cuando la operación toca un repo hermano. Es la contramedida que funcionó.
