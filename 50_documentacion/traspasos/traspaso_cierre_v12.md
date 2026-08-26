# Traspaso de cierre v12

## 1. Identificación

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Remoto:** `tomgc/slep_estado_area_monitoreo` (desalineación aceptada por decisión
  formal, `20260710_decision_desalineacion_nombres_repos.md`)
- **Versión:** v12
- **Fecha:** 2026-08-26 (sesión iniciada el 2026-08-24)
- **Sesión:** 12
- **Foco:** apertura de emergencia y rescate del repositorio tras 44 días sin
  integrar, primer censo completo del estado documental de la cartera, y trazado de la
  ruta hacia un comando único de actualización y publicación.
- **Entorno:** macOS, R 4.5.2, Positron, Claude conversacional (Opus 5) + Claude Code
  (Opus 5), git y `gh`.
- **Archivos principales modificados:** `30_procesamiento/36_generar_panorama_visual.R`,
  `20_insumos/registro_proyectos.csv`, `40_salidas/` (5 archivos),
  `50_documentacion/activa/backlog_acumulativo.md`,
  `50_documentacion/activa/ESTADO.md`, y ocho documentos nuevos en
  `50_documentacion/andamios/`.

## 2. Resumen ejecutivo

La sesión abrió en emergencia: el punto 0bis falló por las cuatro causas a la vez (sin
campos de candado, árbol sucio, stash pendiente, diez commits sin integrar), con dos
traspasos existiendo solo en disco desde hacía 44 días. Antes de tocar nada se
fotografió el estado y se descubrió que la knowledge base no estaba atrasada sino cinco
y veintiséis versiones por delante de lo que el traspaso v11 asumía, con el candado de
cierre como cambio de mayor peso. Se produjo la revisión línea por línea de los dos
normativos y se ejecutó un censo de solo lectura sobre los 25 directorios `slep_*`, con
autotest de ocho casos y dos controles negativos, que reveló que 20 de 25 hermanos no
tienen ningún campo de candado, que 14 incumplen el invariante I5, y que el mayor riesgo
de pérdida de la cartera se había desplazado a `slep_rendimiento_historico`. El rescate
se ejecutó en dos tramos: el A preservó y publicó en una rama nueva todo el trabajo de
las sesiones 10 a 12 sin tocar el remoto, y el B integró el remoto y la rama de rescate,
dejando `main` sincronizado en `0 0`. En paralelo se corrigió un bug que tumbaba el paso
6 ante cualquier hermano con `tipo_pendiente` fuera del enum. El intento de reconstruir
el backlog destapó el hallazgo más serio de la sesión: las entradas 55 a 61 nunca
llegaron a git y son irrecuperables. Quedan pendientes dos degradaciones del panorama y
la ruta de siete encargos hacia el comando único, ya trazada y entregada.

## 3. Estado al cierre

**Qué funciona** (última ejecución exitosa: `run_all(only = 6)`, 2026-08-24 11:06):

- Pipeline de seis pasos sobre 24 hermanos.
- Descubrimiento por convención de nombre: incorporó siete hermanos nuevos sin edición
  manual del registro.
- `panorama_visual.html` con 24 proyectos, 16 con backlog, 13 con semáforo.
- Guarda de locale UTF-8, activa y reportando en cada corrida.
- `main` sincronizado con `origin/main` en `1c74ad0`, estado `0 0`, con `renv`
  incorporado.

**Qué no funciona** (síntoma observable, del log de esa corrida):

- `data.js no disponible o sin entradas parseables`: `tipo`, `objetivo` y `sintesis`
  nulos en los 24.
- `24 sin estado_proyecto`: el campo sale vacío en todos, sin excepción.
- El paso 2 detecta desincronización por `mtime` con margen de un día, lo que produjo
  cuatro `PULL` falsos.
- `renv` declara 38 paquetes y no hay biblioteca local: el pipeline no corre hasta que
  el titular ejecute `renv::restore()`.

**Delta respecto a v11:**

- El universo pasó de 21 hermanos más orquestador a **24 hermanos** descubiertos por el
  pipeline (25 directorios en disco, dos de ellos sin `.git`).
- El pendiente P1 de v11 (rescate de `slep_reportes_modelo_resguardo_asistencia`)
  **quedó obsoleto**: ese repo está hoy en v78, limpio, con un solo traspaso a la vista
  y candado completo.
- El repositorio propio pasó de dos traspasos sin versionar a cero, y de diez commits
  detrás a `0 0`.
- Los normativos dejaron de versionarse en este repo.
- `ESTADO.md` pasó del esquema de SETTINGS v5 al de la v34.

## 4. Registro detallado de cambios

**4.1 Bugfix del paso 6: acceso por `[[` sobre vector con nombres**

- **Archivo:** `30_procesamiento/36_generar_panorama_visual.R`, funciones
  `rango_tp_de()` y `rango_de()`. Commit `0304334`.
- **Qué se hizo:** `RANGO_TIPO_PENDIENTE[[tp]]` pasó a
  `unname(RANGO_TIPO_PENDIENTE[as.character(tp)])` con guarda `is.na()`, e idéntico en
  `RANGO_ESTADO`.
- **Por qué:** sobre un vector atómico con nombres, `[[` con un nombre inexistente
  **aborta**; no devuelve `NULL`. El fallback escrito con `is.null()` era inalcanzable
  por construcción, y bastaba un hermano con `tipo_pendiente` fuera del enum para tumbar
  el paso 6 entero.
- **Cómo se verificó:** `run_all(only = 6)` completo sin error, 24 proyectos, con los
  tres hermanos fuera de enum presentes en el chequeo cruzado.
- **Dependencias afectadas:** ninguna. El `diff` toca exclusivamente esas dos funciones,
  verificado contra el original.

**4.2 Rescate, tramo A: preservación y publicación**

- **Qué se hizo:** rama `rescate/20260824` con cuatro commits selectivos (`f4fc840`,
  `e91bc30`, `a8272e0`, `98a4097`) que publican los traspasos v10 y v11, los artefactos
  de las sesiones 11 y 12, y las salidas regeneradas.
- **Por qué:** una rama nueva se puede pushear estando diez commits detrás, porque crea
  una referencia que no existe en el remoto y no modifica ninguna existente. Es la única
  operación que quita el riesgo de pérdida sin tocar la integración.
- **Cómo se verificó:** `ls-remote` devolvió `98a4097d21edd...`, idéntico al `HEAD`
  local. Un commit local no está publicado hasta que esos dos hashes coinciden.
- **Tensión resuelta:** preservación contra POLITICA 1.3.1. Se preservó primero; la
  ordenación es tarea aparte, y mezclarlas haría indistinguible qué movimiento fue
  rescate y cuál fue orden.

**4.3 Regresión normativa en el árbol de trabajo, detectada y revertida**

- **Síntoma:** `50_documentacion/activa/` tenía POLITICA v5.6 y SETTINGS v16 en disco y
  en el índice, mientras `HEAD` conservaba v5.8 y v34. El índice traía 901 borrados en
  SETTINGS y 125 en POLITICA.
- **Riesgo:** un commit habría consolidado el retroceso de dieciocho versiones de
  SETTINGS, y el árbol era la copia de la que el encargo del tramo B pensaba preservar.
- **Solución:** `git restore --source=HEAD --staged --worktree` sobre ambos archivos.
- **Cómo se verificó:** las dos líneas de versión en disco volvieron a transcribir
  `Versión 5.8` y `Versión 34`.
- **Consecuencia de diseño:** el encargo del tramo B se reescribió para extraer la copia
  de preservación de `HEAD` y no del disco.

**4.4 Rescate, tramo B: integración de dos ramas**

- **Qué se hizo:** dos merges. El primero (`5953106`) integró `origin/main`, con
  conflicto `modify/delete` en los dos normativos, resuelto aceptando el borrado que
  impone `e24bceb`. El segundo (`1c74ad0`) integró `origin/rescate/20260824`, con cinco
  conflictos en `40_salidas/` resueltos con `--ours`. Los traspasos v10 y v11 entraron
  como archivos nuevos, sin conflicto.
- **Por qué dos:** sin el segundo, los traspasos v10 y v11 seguían viviendo solo en la
  rama de rescate y el correlativo del próximo cierre habría colisionado con un v10 ya
  existente.
- **Cómo se verificó:** `sha256` de los tres normativos preservados desde `HEAD`,
  idénticos a los repuestos; `check-ignore` confirmando las líneas 44, 45 y 46 del
  `.gitignore`; `ls-remote` de `main` igual a `HEAD`; estado final `0 0`.
- **Precaución aplicada:** la copia se extrajo **antes** del merge y **desde `HEAD`**,
  porque `git rm` sobre el conflicto borra el archivo del disco y el disco tenía la
  versión mala.

**4.5 Revisión línea por línea de la knowledge base**

- **Producto:** `50_documentacion/andamios/20260824_delta_normativo_kb.md`.
- **Qué se hizo:** lectura íntegra de POLITICA v5.8 y SETTINGS v34 contra las v5.3 y v8
  que el traspaso v11 citaba, con la tabla de obligaciones que el delta impone al
  proyecto en sus dos roles, como repositorio y como orquestador.

**4.6 Censo de solo lectura de la cartera**

- **Productos:** el encargo (602 líneas) y sus dos salidas (informe de 883 líneas y CSV
  de 26 por 58).
- **Qué se hizo:** medir en los 25 directorios el estado documental, los campos de
  candado, la integridad del historial de traspasos, la coherencia de gobernanza de
  datos y el catálogo de documentos de decisión.
- **Cómo se verificó:** autotest de ocho casos previo a la recolección, con dos
  controles negativos, y cinco verificaciones finales sobre los artefactos.
- **Tensión resuelta:** el autotest atrapó un defecto real del clasificador de
  `ventana_insumos` en la primera corrida, que sin control negativo habría producido un
  censo verde y equivocado.

**4.7 Reconstrucción parcial del backlog y hallazgo de pérdida irrecuperable**

- **Qué se hizo:** trasladar al backlog las entradas 62 a 67 desde el traspaso v11 §5,
  agregar filas de resumen para las sesiones 7 a 11, y **declarar dentro del archivo**
  que las entradas 55 a 61 se perdieron.
- **Hallazgo:** el traspaso v10 §4.1 registra que el volcado de 55-61 ocurrió, pero
  `git log --all --follow` sobre el backlog tiene solo dos commits y ninguna versión con
  61 entradas llegó jamás a git. El trabajo se hizo sobre una copia que se perdió.
- **Por qué no se reconstruyen:** los temas constan en v09 §5 y v10 §4, pero escribir
  las entradas desde ahí sería redacción nueva sobre registro histórico.
- **Cómo se verificó:** las entradas 1 a 54 quedaron byte a byte idénticas al respaldo
  (`cmp` sin diferencias sobre 137 líneas); la serie resultante es `1..54` más `62..67`
  sin repeticiones; el `diff` tiene 28 inserciones y un único borrado, la fila de total.

**4.8 Trazado de la ruta hacia el comando único**

- **Productos:** `20260824_ruta_comando_unico.md` (siete encargos, con contrato de log
  en `.jsonl` y criterio evaluable por encargo) y `20260824_pendientes_y_encargos.md`
  (21 pendientes, 16 encargos autónomos, cinco decisiones no delegables, ocho sesiones).

## 5. Backlog acumulativo

Entradas nuevas 68 a 77, en el bloque BACKLOG_ENTRADAS de este paquete. El archivo llega
hoy a la 67, con el hueco 55-61 declarado en su propio cuerpo.

## 6. Bugs de la sesión

**B1 — El paso 6 aborta ante `tipo_pendiente` fuera del enum**

- **Síntoma observable:** `Error in RANGO_TIPO_PENDIENTE[[tp]]: subíndice fuera de los
  límites`, traceback en `36_generar_panorama_visual.R:465`.
- **Causa raíz:** `[[` sobre un vector atómico con nombres aborta ante un nombre
  inexistente; solo `[` devuelve `NA`. El fallback `if (is.null(r))` nunca se ejecutaba.
- **Solución exacta:** funciones `rango_tp_de()` y `rango_de()`, acceso por `[` con
  guarda `is.na()`. Commit `0304334`.
- **Criterio de verificación:** `run_all(only = 6)` completa los 24 proyectos con los
  tres hermanos fuera de enum presentes.
- **Patrón general aprendido:** un fallback escrito contra el modo de fallo equivocado
  no es una salvaguarda, es una decoración. Antes de escribir un fallback, verificar
  cuál es el modo de fallo real del accesor.
- **Estado:** resuelto.

## 7. Aprendizajes y restricciones descubiertas

**A24 — La concurrencia de la cartera es condición permanente, no anomalía.** El censo
detectó escrituras ajenas en 13 de 25 repos durante su propia ejecución. Regla: todo
instrumento que recorra la cartera declara el instante de cada medición, degrada la fila
que no pudo medir en vez de abortar, y nunca asume que el universo estuvo quieto.
Ejemplo: corridas previas del censo veían 10 repos con traspasos sin versionar; el
informe final midió 4, y la diferencia la produjo una ola de repropagación externa.

**A25 — Un invariante que pasa mientras la condición que dice proteger está ausente es
peor que un invariante ausente.** Aplicado esta sesión al diseño del censo: cada
clasificador demuestra en la misma corrida que detecta una condición plantada.

**A26 — Una rama nueva se puede publicar estando detrás del remoto.** Es la operación
que quita el riesgo de pérdida sin tocar la integración. Si se ignora, el rescate se
pospone hasta resolver el merge y el trabajo sigue en un solo disco mientras tanto.

**A27 — Antes de resolver un conflicto `modify/delete`, la versión local se copia fuera
del repositorio, y se copia desde `HEAD`, no desde el disco.** `git rm` sobre el
conflicto borra el archivo del disco. Y el disco puede no ser la copia buena: esta
sesión encontró el árbol de trabajo dieciocho versiones atrás de `HEAD`.

**A28 — Un grep de compuerta mide una cadena, no un riesgo.** Los tres grupos que
detuvieron el tramo A eran falsos positivos, todos por prohibir la cadena en vez de la
condición dañina. Regla: al escribir un grep de compuerta, enunciar primero qué
condición hace daño y recién después la expresión que la detecta, y declarar en el mismo
encargo las excepciones previsibles.

**A29 — Un traspaso que declara haber escrito un archivo no prueba que el archivo se
haya versionado.** Las entradas 55 a 61 del backlog constan como volcadas en el traspaso
v10 y no existen en ningún commit. Regla: la afirmación "se actualizó el archivo X" solo
vale acompañada del hash del commit que lo contiene. El invariante I1 del candado existe
precisamente para esto y en la sesión 10 todavía no existía.

**A30 — La norma puede quedar atrás del instrumento, y el redactor no tiene cómo
saberlo.** SETTINGS §2.1 describe el instrumento de cierre v10 (tres bloques, sin
delimitadores) mientras en disco está el v11 (cuatro bloques delimitados por triple
ángulo, más `BACKLOG_NARRATIVA`). El redactor no puede leer el instrumento por regla
explícita, así que la desincronización solo se detecta cuando el cierre falla. Regla:
cuando el instrumento cambie su contrato con el paquete, SETTINGS §2.1 se actualiza en
el mismo acto.

## 8. Decisiones de diseño

**D-12.1 — Los normativos no se versionan en este repositorio; se conservan en disco
como ignorados.**

- **Alternativas:** (a) aceptar el borrado y dejarlos solo en la knowledge base; (b)
  conservar copia local ignorada; (c) revertir la decisión de cartera.
- **Justificación:** el `.gitignore` de `e24bceb` ignora por nombre y no borra del
  disco. La (b) respeta la decisión de cartera y deja a Claude Code leyendo la v5.8 y la
  v34 en vez de la v5.7 y la v31 que traía el remoto.
- **Implicancia:** el contenido normativo de este repo deja de tener historial. Su
  versionado vive en la knowledge base del Project, y `settings_version` deja de ser
  verificable contra un archivo versionado.

**D-12.2 — El rescate se hace en dos tramos separados, y la ordenación no entra en
ninguno.**

- **Justificación:** mezclar rescate con reordenamiento hace indistinguible en el
  historial qué movimiento fue cuál, y la ordenación exige árbol limpio, que solo existe
  después del rescate.
- **Implicancia:** la ordenación queda como pendiente O-03, salvo el archivado de
  traspasos que el propio instrumento de cierre ejecuta.

**D-12.3 — Las entradas 55 a 61 del backlog no se reconstruyen.**

- **Alternativas:** (a) reconstruirlas desde los temas que v09 §5 y v10 §4 enumeran; (b)
  trasladar solo 62-67 y declarar el hueco.
- **Justificación:** (a) sería redacción nueva sobre registro histórico, con el texto de
  quien cierra hoy atribuido a sesiones de hace dos meses. Un hueco declarado es
  honesto; una reconstrucción verosímil es una falsificación cómoda.
- **Implicancia:** el backlog tiene 60 entradas conservadas sobre 67 numeradas, y la
  declaración vive dentro del propio archivo para que el salto sea legible sin
  investigarlo.

**D-12.4 — Los acentos del texto trasladado se conservan aunque el archivo destino no
los use.**

- **Justificación:** el invariante de traslado prohíbe uniformar estilo. Quitarlos
  habría sido modificar el texto.
- **Implicancia:** el backlog queda con dos registros ortográficos, visible y
  deliberado.

## 9. Constantes y parámetros

Sin cambios de valor. `RANGO_TIPO_PENDIENTE` y `RANGO_ESTADO` conservan su contenido; lo
que cambió es el accesor que las consulta. Vigentes en
`30_procesamiento/36_generar_panorama_visual.R` (líneas 43 a 53) y en
`10_utils/10_configuracion.R`.

## 10. Arquitectura de archivos

Escáner regenerado en este cierre. Cambios estructurales: ocho documentos nuevos en
`50_documentacion/andamios/`, los traspasos v10 y v11 incorporados al control de
versiones, la incorporación por el merge de `renv/`, `renv.lock`, `.Rprofile`,
`.Renviron.example` y `10_utils/10_validar_portabilidad.R`, y la salida de los tres
normativos del árbol versionado.

Verificación contra la política: `50_documentacion/traspasos/` queda con un solo archivo
tras el archivado de este cierre. Persisten dos incumplimientos de POLITICA §2
(`esbozo_fase2_estado_estandarizado.md` y `reporte_cobertura_documental.md` sin prefijo
`50_` y fuera de las seis excepciones), registrados como pendiente O-13.

## 11. Pendientes y ruta sugerida

El inventario completo (21 pendientes, cinco decisiones no delegables, 16 encargos
autónomos) vive en `50_documentacion/andamios/20260824_pendientes_y_encargos.md`. La
ruta de los siete encargos hacia el comando único vive en
`50_documentacion/andamios/20260824_ruta_comando_unico.md`. No se re-copian aquí.

**Los seis pendientes de mayor prioridad:**

| Id | Pendiente | Tipo | Complejidad | Criterio de éxito |
|---|---|---|---|---|
| O-14 | `renv::restore()` de los 38 paquetes antes de correr el pipeline | bloqueante | Baja | `run_all()` completa los seis pasos |
| O-05 | `data.js` no disponible | bug activo | Media | Cero eventos con esa causa en la corrida |
| O-06 | `estado_proyecto` vacío en los 24 | bug activo | Media | Proyectos con el campo no nulo, mayor que cero |
| O-15 | SETTINGS §2.1 describe el instrumento v10 y en disco está el v11 | documentación normativa | Baja | La sección describe cuatro bloques y `BACKLOG_NARRATIVA` |
| O-09 | `registro_proyectos.csv` versionado y escrito por el paso 1 | decisión | Media | I8 pasa, o existe la excepción declarada por escrito |
| C-01 | Rescate de `slep_rendimiento_historico` | bloqueante de cartera | Alta | Cuatro traspasos alcanzables desde `origin`, `ESTADO.md` presente, árbol limpio |

**Micro-pendiente:** la fila de la sesión 6 en el resumen del backlog dice `(en curso)`
aunque esa sesión cerró con traspaso v06. Corregirla no estaba en el alcance del encargo
A-02.

**Evaluación de deuda técnica.** Tres zonas frágiles.
`20_insumos/registro_proyectos.csv`, versionado y escrito por el pipeline, viola
POLITICA §1.3 punto 5 e I8 a la vez. El detector de desincronización por `mtime` produce
falsos positivos cada vez que una operación de filesystem toca un traspaso, cosa que en
una cartera concurrente ocurre a diario. Y el backlog, cuya pérdida de siete entradas
demuestra que ningún artefacto de memoria estaba protegido por commit antes de la ola
del candado.

**Auditoría de cierre (política 5.6):**

| # | Pregunta | Respuesta |
|---|---|---|
| 1 | ¿Datos crudos aislados e inmutables? | No — pendiente O-09 |
| 2 | ¿Pipeline corre de cero sin intervención? | Parcial — requiere `renv::restore()`, pendiente O-14 |
| 3 | ¿Paquetes, rutas y constantes al inicio? | No verificado en esta sesión |
| 4 | ¿La estructura respeta la política? | Parcial — pendiente O-13 |
| 4bis | ¿Existe `50_ordenacion_repositorio.md`? | No — pendiente O-03, gatillo encendido |
| 4ter | ¿Existe `50_locale_utf8.md`? | Sí |
| 8 | ¿Nombres sin tildes, ñ ni espacios? | Sí |
| 9 | ¿Guarda de locale vista fallar? | No — pendiente O-11 |

Toda respuesta "no" está registrada como pendiente en el inventario.

**Salida de la compuerta de dudas: seis registradas.**

| # | `supuesto` | `predicado` | `medicion` |
|---|---|---|---|
| 1 | Los normativos quedaron en disco, ignorados y con contenido v5.8/v34 | `check-ignore` devuelve ambas rutas y sus líneas de versión transcriben 5.8 y 34 | `git check-ignore -v` más `grep -m1 -i versi` |
| 2 | El bugfix no alteró el orden del acordeón para los hermanos con enum válido | La secuencia de slugs del HTML nuevo es idéntica a la del HTML de la sesión 11, salvo los tres fuera de enum | extraer y comparar la lista ordenada de slugs de ambos HTML |
| 3 | Las columnas `adelante` y `detras` del censo siguen siendo válidas | Para al menos uno de tres repos, el conteo tras `fetch` difiere del que el CSV declara | `fetch` más `rev-list --count` en tres repos, contra el CSV |
| 4 | Los tres hermanos con `tipo_pendiente` fuera de enum caen al final del acordeón y eso es aceptable | En el HTML, `slep_reporte_emergencia` aparece después de los `cosmetica` y `ninguno` | inspección de la secuencia de cards del HTML |
| 5 | Las cinco salidas resueltas con `--ours` en el merge 2 son las que corresponden | Las cinco son byte a byte las de `6155f28` | `git show 6155f28:<ruta>` contra el disco, para las cinco |
| 6 | La pérdida de las entradas 55-61 es un caso aislado y no un patrón de la cartera | Ningún otro repo de la cartera tiene un backlog cuyo último número declarado en su traspaso vigente supere al del archivo | comparar, por repo, el último número del backlog contra el declarado en su traspaso |

Ninguna se cerró en sesión: ninguna cumple el criterio estrecho de operación
irreversible, cifra ya publicada o re-trabajo mayor que la propia verificación. La 6 es
la más importante y la más barata, y encabeza la ruta siguiente.

**Ruta sugerida para la próxima sesión.** Sesión 13, tipo CONTINUATION: cerrar la duda 6
(si hay más backlogs de la cartera con entradas perdidas), ejecutar O-14
(`renv::restore()`) para devolver el pipeline a operación, y despachar las cinco
decisiones D-01 a D-05 del inventario, que son respuestas cortas y desbloquean cuatro
encargos. Diferir todo lo que toque código hasta que A-05 (diagnóstico de `data.js` y de
`estado_proyecto`) esté hecho: corregir sin diagnosticar es cambiar rutas a ciegas.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ **NO** correr `run_all()` antes de `renv::restore()`: el merge incorporó `renv` con
  38 paquetes y no hay biblioteca local.
- ⚠️ **NO** reconstruir las entradas 55 a 61 del backlog desde los temas que v09 y v10
  enumeran: sería redacción nueva sobre registro histórico.
- ⚠️ **NO** corregir `data.js` cambiando la ruta sin haber diagnosticado antes dónde la
  busca el paso 6 y si el archivo cambió de formato.
- ⚠️ **NO** escribir un paso que commitee `registro_proyectos.csv` automáticamente antes
  de resolver la decisión D-01.
- ✅ **ANTES** de commitear cualquier artefacto en un repo hermano, verificar el working
  tree **completo**, no solo el archivo objetivo (A23).
- ✅ **ANTES** de asumir que un `ESTADO.md` está vigente, comparar `sesion_actual` contra
  la `vNN` del traspaso, nunca contra el `mtime` (A22).
- ✅ **ANTES** de resolver un conflicto `modify/delete`, copiar la versión local fuera
  del repositorio **desde `HEAD`** (A27).
- ✅ **ANTES** de afirmar que un archivo se actualizó, citar el hash del commit que lo
  contiene (A29).
- 🔒 La cartera está en producción permanente y otros procesos escriben mientras este
  proyecto lee. No se espera a que se detengan (A24).
- 🔒 El universo del pipeline son **24 hermanos** descubiertos por convención de nombre.
  `registro_proyectos.csv` es destino, no fuente (A21).
- 🔒 Los normativos **no se versionan** en este repositorio.
- 🔒 La rama `rescate/20260824` no se borra sin decisión explícita del titular.
- 🔒 Las entradas 55 a 61 del backlog están perdidas y su hueco es permanente.

## 13. Fragmentos de código de referencia

**Acceso seguro a un vector con nombres** (patrón nuevo, aplicable a toda tabla de
lookup del proyecto):

```r
# `[[` con un nombre inexistente ABORTA. Solo `[` devuelve NA y permite un
# fallback alcanzable. La guarda va sobre is.na(), nunca sobre is.null().
rango_de_tabla <- function(clave, tabla, defecto) {
  if (is.na(clave)) return(defecto)
  r <- unname(tabla[as.character(clave)])
  if (is.na(r)) defecto else r
}
```

**Publicación de una rama de rescate estando detrás del remoto** (patrón nuevo,
aplicable a cualquier repo de la cartera en apertura de emergencia):

```bash
# Una rama nueva se publica sin integrar: crea una referencia que no existe en
# origin y no modifica ninguna existente. Quita el riesgo de perdida hoy.
git switch -c rescate/$(date +%Y%m%d)
git add <rutas explicitas>            # nunca -A
git commit -m "docs(traspasos): versiona los cierres pendientes"
git push -u origin rescate/$(date +%Y%m%d)
git ls-remote --heads origin rescate/$(date +%Y%m%d)   # debe igualar a HEAD
```

**Preservación antes de un conflicto modify/delete** (patrón nuevo, corregido tras
encontrar el disco desactualizado respecto de `HEAD`):

```bash
# Desde HEAD y NUNCA desde el disco: el arbol de trabajo puede estar atras.
git show HEAD:<ruta> > /tmp/preservado_<nombre>
grep -m1 -i 'versi' /tmp/preservado_<nombre>   # verificar que es la copia buena
```

Los patrones estables del proyecto viven en `CLAUDE.md` (hoy ignorado, en disco) y en
`10_utils/10_configuracion.R`; este traspaso los referencia por nombre.

## 14. Reapertura

Continuemos con `slep_estado_proyectos_monitoreo`. Tipo CONTINUATION. El protocolo
(`POLITICA_PROYECTO.md` + `SETTINGS_Y_PROMPTS_OPERACIONALES.md`) vive en la knowledge
base del Project y se lee desde ahí.

Documentos:

1. Knowledge base (no adjuntar, verificar versión): `POLITICA_PROYECTO.md` v5.8,
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md` v34.
2. Adjuntar: `traspaso_cierre_v12.md`.

Foco sugerido: cerrar la duda 6 de la compuerta (si hay más backlogs de la cartera con
entradas perdidas), ejecutar `renv::restore()` para devolver el pipeline a operación, y
despachar las decisiones D-01 a D-05. El inventario completo está en
`50_documentacion/andamios/20260824_pendientes_y_encargos.md`.

`main` previo al commit de cierre: `1c74ad0`, estado `0 0` contra `origin/main` (fuente:
reporte del tramo B, 2026-08-26).

## 15. Errores del asistente

| `momento` | `disparador` | `que_paso` | `regla_violada` | `causa_raiz` | `salvaguarda_presente` | `patron` | `gatillo_observable` | `intentos_previos` | `costo` |
|---|---|---|---|---|---|---|---|---|---|
| Redacción del §4.5 del encargo de censo | Claude Code se detuvo ante la ambigüedad | El §4.5 afirmaba "ocho de los nueve invariantes son observables" y fijaba el resumen en N/8, mientras la misma tabla listaba nueve filas medidas | SETTINGS §1.2.6, generar-verificar-consumar | La cifra venía de un borrador donde I7 no se medía; al agregar el §4.6 se actualizó la tabla y no la oración que la introduce | SETTINGS §1.2.6 y marcador de cifra | PAT-02 | `cifras-datos` | 1 | Un turno de Claude Code detenido |
| Presentación del plan del tramo A | El titular lo señaló | Se declaró `→ destino:` y se emitió el gatillo apuntando a un encargo que nunca se escribió | SETTINGS §1.2.6 y GR-06b | Se trató el destino declarado como si fuera la entrega: se cumplió el marcador y no el acto que señala | GR-06b y preferencias del titular | PAT-06 | `entrega-sin-destino-o-nombre` | 0 | Un turno perdido |
| Redacción del §5 del encargo del tramo A | Claude Code se detuvo tres veces seguidas | Los tres greps de gobernanza produjeron falsos positivos que detuvieron el rescate | Principio de que una compuerta mide el riesgo y no su proxy | Se prohibió la cadena en vez de la condición dañina; la excepción escrita para `andamios/` no se sostenía en el fundamento que la levantaba | Ninguna: el encargo era propio | PAT-13 | `salvaguarda-mide-proxy` | 2 | Tres turnos de consulta y tres redacciones correctivas |
| Diagnóstico del tramo B | El titular respondió "tu recomendación" | Se escaló a decisión del titular una pregunta sobre `renv` verificable con comandos de solo lectura | Preferencias del titular: interrumpir solo por decisión estratégica | Se confundió "no lo sé" con "no es decidible por mí" | Preferencias del titular | PAT-01 | `interrupcion-innecesaria` | 0 | Un turno |
| §4 del encargo del tramo B v1 | Claude Code detectó la regresión al abrir la v2 | El encargo mandaba preservar los normativos copiándolos **desde el disco**, sin verificar antes que el disco tuviera la copia vigente. El disco estaba dieciocho versiones atrás de `HEAD` | POLITICA 0.6: el estado de un archivo no leído en la sesión es hipótesis, no hecho | Se asumió que el árbol de trabajo era la fuente buena porque lo había sido dos días antes | POLITICA 0.6 | PAT-04 | `premisa-heredada-no-verificada` | 0 | Una reescritura completa del encargo |
| Emisión del primer `paquete_cierre_v12.md` | El instrumento detuvo el cierre con cinco causas | El paquete se emitió en el formato del instrumento v10 (tres bloques, sin delimitadores), declaró el tramo B como consumado sin que hubiera corrido sobre `main`, y fijó un tramo de backlog fuera del rango que el instrumento exige | POLITICA 0.6 sobre el estado del repositorio, y SETTINGS §2.1 sobre el contrato del paquete | Dos causas distintas: la afirmación sobre el tramo B se escribió sin marcador de fuente, y el formato salió de SETTINGS §2.1, que describe un instrumento anterior al que hay en disco | POLITICA 0.6; ninguna para el formato, porque la norma estaba desactualizada | PAT-04 y PAT-02 | `estado-repo-sin-fuente` | 0 | Un cierre abortado y un paquete completo reescrito |

