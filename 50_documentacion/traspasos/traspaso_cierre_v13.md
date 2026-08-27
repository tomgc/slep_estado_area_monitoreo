# Traspaso de cierre v13

## 1. Identificación

- **Proyecto:** `slep_estado_proyectos_monitoreo` (remoto: `tomgc/slep_estado_area_monitoreo`)
- **Versión:** v13
- **Fecha de cierre:** 2026-08-27
- **Sesión:** 13, CONTINUATION
- **Foco:** apertura bloqueada por `cierre_incompleto`, resuelta ejecutando D-01; retorno
  del pipeline a operación; censo de backlogs de la cartera; diagnóstico y corrección de
  `data.js`; ordenación del repositorio.
- **Entorno:** R sobre Positron, macOS, `renv` restaurado (33 paquetes más `renv`),
  Claude Code v2.1.238 en modo autónomo.
- **Archivos principales modificados:** `30_procesamiento/36_generar_panorama_visual.R`,
  `00_escanear_proyecto.R`, `50_documentacion/activa/backlog_acumulativo.md`,
  `50_documentacion/activa/ESTADO.md`, `README.md`, `.gitignore`, ocho andamios nuevos.
- **`main` previo al cierre:** `88394ad`.

## 2. Resumen ejecutivo

La sesión abrió con el candado 0bis en rojo por `cierre_incompleto`, que la sesión 12
dejó declarado apuntando a I8. Resolverlo exigió despachar D-01 antes de trabajar:
`registro_proyectos.csv` pasó a `40_salidas/` y salió del control de versiones, con guarda
de ausencia en sus dos lectores reales. Con el candado abierto, `renv::restore()` devolvió
el pipeline a operación y el escáner apagó I7. El censo de backlogs de la cartera
respondió la duda 6 heredada: la pérdida de las entradas 55-61 es un accidente aislado y
no un patrón, con un solo hueco interno en 26 directorios y ese hueco es el propio. El
diagnóstico A-05 desmontó dos supuestos de un año: `data.js` no tenía un defecto sino
tres apilados, y `estado_proyecto` nunca fue un bug de extracción sino una columna jamás
curada. Corregidos los tres defectos de `data.js`, once fichas del panorama recuperaron
`tipo`, `objetivo` y `sintesis`, y la prueba del desplazamiento demostró que el mapeo
viejo habría cruzado contenido editorial en nueve de doce. La ordenación del repositorio
quedó en PR sin mergear. Al cierre aparece un pendiente que ninguna de las trece sesiones
había visto: `semaforo` llega nulo al panorama publicado.

## 3. Estado al cierre

**Funciona.** El pipeline corre completo: `run_all(only = 1)` y `run_all(only = 6)`
ejecutados en la sesión sin error. `data.js` parsea sus 12 entradas con cero advertencias,
incluidas formas anidadas que el origen todavía no publica. El registro se genera en
`40_salidas/` con 25 filas de datos. `main` está publicado y sincronizado en `88394ad`.

**No funciona.** `semaforo`, `estado_proyecto` y `datos_sensibles` llegan nulos a las
fichas del panorama publicado (síntoma observable: el bloque JSON de cualquier ficha del
HTML). La detección de desync sigue usando `mtime` en vez de `vNN`. El paso 1 no es
idempotente sobre campos curados vacíos.

**Delta respecto a v12.** El repositorio pasó de tener un cierre declarado incompleto a
tener el candado abierto y el hueco cerrado. El pipeline pasó de inoperante a operativo.
El panorama pasó de cero fichas con contenido editorial a once. La cartera pasó de
"posible pérdida de memoria generalizada" a "accidente aislado, medido". El inventario de
pendientes pasó de 13 entradas propias a un inventario re-derivado y verificado contra
disco.

## 4. Registro detallado de cambios

**4.1 Mudanza de `registro_proyectos.csv` (D-01).** `git mv` a `40_salidas/`, salida del
índice con `git rm --cached`, entrada en `.gitignore`, actualización de la constante y
guarda de ausencia con causa y remedio en sus lectores. Verificado por cuatro controles
(referencias vivas, versionado, existencia en disco, cobertura del ignore). Resuelve I8 y
POLITICA §1.3 punto 5 a la vez. Commit `3245400`.

**4.2 Apertura del candado.** `cierre_incompleto` a `no` y `sesion_abierta` a `true`, sin
tocar prosa ni `sesion_actual`. Commit `ba3b617`.

**4.3 Restauración de `renv` y escáner.** Los 33 paquetes se enlazaron desde el caché
global, ninguno se compiló. `renv/library` existía pero era un esqueleto vacío, lo que
contradecía la lectura de la apertura. Commit `4d3c046`.

**4.4 Censo de backlogs de la cartera.** Instrumento con seis casos de autotest, dos de
ellos controles negativos. Cinco premisas del encargo resultaron falsas y se corrigieron
en ejecución. Commit `3c32b5b`.

**4.5 Cuadratura de la clasificación temática.** La tabla sumaba 59 sobre un total
declarado de 77, y la causa no era ausencia de entradas nuevas: la tabla vieja contaba
sub-items como entradas. Se re-derivó completa, una entrada una categoría, con categoría
nueva "Rescate e integración del repositorio" y fila explícita de pérdidas. Commit
`d527fd6`.

**4.6 Versionado del instrumental del censo.** Motor y arnés pasaron del scratchpad a
`andamios/`, el arnés reescrito autocontenido para correr desde cualquier directorio.
Commits `e6e6a2c` y `b89d2f9`.

**4.7 Corrección de descripciones del registro.** `README.md`, `CLAUDE.md` y
`ventana_insumos` describían el mundo anterior a D-01. Commit `fee9c63`.

**4.8 Diagnóstico A-05.** Solo lectura, con informe y sin corrección. Commit `95a77c6`.

**4.9 Corrección del frente A.** Ruta a `docs/data.js`, saneador de claves generalizado y
mapeo reclavado por `id`, con guarda que aborta ante omisión silenciosa y admite `NA`
declarado. Commits `7726627` y `07f2450`.

**4.10 Endurecimiento del parser.** Recorrido único con strings enmascarados que cuenta
profundidad de llaves, inmune a la próxima clave y a la próxima forma. Absorbió el
saneador del cambio anterior. Commits `d449ffb` y `de328bf`.

**4.11 Ordenación del repositorio (A-03).** Cuatro bloques, dos archivos superados a
`_archivo/20260826/`, `EXCLUIR_DIRS` completado, marcador depositado. **En rama, sin
mergear:** PR #4. Commits `5c90656`, `283d19d`, `f444990`.

**4.12 Línea base del registro.** Copia fechada en `andamios/` antes de que A-20 lo toque:
el archivo dejó de versionarse y la evidencia de qué celdas estaban vacías a propósito
vivía en un solo lugar, fuera del repo. Commit `88394ad`.

## 5. Backlog acumulativo

Doce entradas nuevas, 78 a 89, en el bloque `BACKLOG_ENTRADAS` de este paquete. Su
reparto entre las catorce categorias vigentes va en `BACKLOG_NARRATIVA`, campo
`taxonomia`: sin categorias nuevas, y la columna `N` pasa a sumar 89. La categoria que
mas crece es Robustez/bugfix, de 6 a 9.

## 6. Bugs de la sesión

**B13-01 — `data.js`, tres defectos apilados.** Síntoma: `tipo`, `objetivo` y `sintesis`
nulos en los 24. Causa raíz: ruta a `~/Projects/slep_monitoreo/data.js` (el origen movió
el sitio a `docs/` en `00a1af3`), saneador con lista blanca de siete claves (el origen
agregó `id` en `15dc047`), y `MAPEO_ORDEN_SLUG` clavado por posición (el origen insertó un
proyecto en la 3). Solución: `36_generar_panorama_visual.R`, líneas 38, 204 y 64-76.
Verificación: 12 entradas parseadas, 11 fichas pobladas, y prueba del desplazamiento que
demuestra que el mapeo viejo cruza contenido en 9 de 12. **Patrón general:** cuando un
defecto tiene varias causas apiladas, corregir una sola reproduce el síntoma idéntico y
produce la conclusión falsa de que esa causa no era el problema. Estado: resuelto.

**B13-02 — Parser incapaz ante objetos anidados.** Síntoma latente: el separador
`\{[^{}]*\}` rompería ante `valor: [{icono, texto}]`, forma que el catálogo del origen ya
propone. Solución: recorrido único con strings enmascarados y conteo de profundidad.
Verificación: caso sintético con las cuatro formas que hoy rompen, más los 12 reales, todos
parseando, y salida idéntica sobre el `data.js` real. **Patrón general:** un parser que
enumera las formas que conoce falla ante la siguiente; la corrección es tolerar, no
ampliar la lista. Estado: resuelto.

**B13-03 — Paso 1 no idempotente.** Síntoma: campos curados vacíos pasan al texto literal
`NA` en la segunda corrida. Causa raíz: `readr` parsea `""` como `NA`, `nzchar(NA)` devuelve
`TRUE`, y la rama que conserva el valor previo se queda con el `NA`.
`31_descubrir_proyectos.R:131-137` y `:178-179`. Estado: pendiente (O-20), reparado a nivel
de dato en las 7 filas dañadas.

## 7. Aprendizajes y restricciones descubiertas

1. **Un archivo movido a un directorio ignorado sigue versionado; uno nuevo, no.**
   `.gitignore` no gobierna rutas ya en el índice. `_archivo/` está en `.gitignore:17`, así
   que la regla de POLITICA 1.5 ("nada se borra") solo se cumple para lo que llega ahí por
   `git mv`. Cualquier archivo nuevo depositado en `_archivo/` queda fuera de git sin aviso,
   que es la forma exacta en que se perdieron las entradas 55-61.
2. **Instruir al ejecutor a corregir las premisas falsas en vez de obedecerlas.** Siete
   encargos consecutivos llevaron premisas equivocadas. La cláusula que las hizo visibles
   se instaló por accidente en A-00 y después de forma explícita. Sin ella, siete encargos
   habrían ejecutado siete descripciones falsas del sistema. Vale como cláusula fija de
   todo encargo, junto al control negativo.
3. **Un control negativo que solo prueba sobre-detección no prueba el instrumento.** Los
   cinco falsos positivos del censo fueron todos por detectar de más. La capacidad de
   detectar un hueco real nunca se probó contra un hueco plantado.
4. **Medir en el origen antes de suponer una cadena de extracción.** El primer paso de
   A-05 sobre `estado_proyecto` invalidó toda la hipótesis del encargo: el campo no estaba
   en los `ESTADO.md` de los hermanos ni el código lo buscaba ahí.
5. **Una línea base que no se puede volver a correr es una foto.** El motor del censo vivía
   en el scratchpad; el arnés que lo valida, también, y por separado.

## 8. Decisiones de diseño

- **D-01:** `registro_proyectos.csv` a `40_salidas/` y fuera del control de versiones.
  Alternativas: excepción declarada por escrito, o dejar de versionarlo sin moverlo.
  Justificación: es artefacto intermedio del pipeline, no insumo; la excepción escrita es
  deuda que hay que defender en cada auditoría.
- **D-02, D-03:** autorizaciones de escritura por repo, nominales y acotadas a su sesión.
- **D-04:** en `slep_paes` manda `gobernanza_datos.md`; `ESTADO.md` es destilación.
- **D-05:** los directorios sin `.git` quedan fuera del universo del paso 1 y se registran
  como candidatos a migración.
- **Guarda del mapeo de `data.js`:** aborta ante omisión silenciosa (id fuera de tabla, id
  sin campo, slug duplicado) y admite `NA` declarado con advertencia nombrada. `simce`
  existe en el sitio y no en la cartera: abortar por él dejaría el paso inejecutable por un
  dato verdadero. La distinción es entre "no lo encontré" y "declaré que no existe".
- **Parche del instrumento de cierre: descartado.** El asistente redactó una v12 del
  instrumento y una v35 de SETTINGS para O-16 y O-18 sin advertir que el instrumento es
  transversal a los 25 hermanos y su cambio obliga a repropagarlo. El titular lo rechazó.
  Los dos defectos siguen abiertos y su corrección requiere sesión propia.

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `RUTA_DATA_JS_PORTAFOLIO` | `~/Projects/slep_monitoreo/data.js` | `.../docs/data.js` | `36_generar_panorama_visual.R:38` | El origen movió el sitio (`00a1af3`) |
| `MAPEO_ORDEN_SLUG` | mapeo por posición | mapeo por `id` | `36_generar_panorama_visual.R:64-76` | El origen insertó un proyecto en la posición 3 |
| `EXCLUIR_DIRS` | `.git`, `.Rproj.user`, `renv`, `.quarto` | más `node_modules`, `packrat`, `venv` | `00_escanear_proyecto.R` | POLITICA §7.2. **En rama, sin mergear** |
| `RUTA_INSUMOS` | en uso | sin usos | `10_utils/10_configuracion.R:94` | Huérfana tras D-01; no eliminada |

Fuente canónica de las vigentes: `10_utils/10_configuracion.R`.

## 10. Arquitectura de archivos

El escáner corrió el 26 a las 18:29 y vuelve a correr en este cierre. `traspasos/`
quedó con un solo archivo a la vista y `archivo/` con once, contra los doce que el
inventario de la sesión 12 declaraba: ese dato era falso. `_archivo/20260826/` existe solo
en la rama de ordenación.

## 11. Pendientes y ruta sugerida

### Inventario

El inventario completo, con tipo, complejidad, precauciones y criterio de éxito por
pendiente, está en `50_documentacion/andamios/20260826_pendientes_ruta_e_itinerario.md`,
que es su fuente. Aquí solo lo que cambió al cierre o no está allí:

| Id | Pendiente | Tipo | Complejidad | Criterio de éxito |
|---|---|---|---|---|
| **O-38** | `semaforo` llega nulo a todas las fichas del panorama publicado, junto a `estado_proyecto` y `datos_sensibles` | bug activo | Media | Diagnóstico que nombre archivo y línea donde se pierde, midiendo primero en origen (los `ESTADO.md` de los hermanos) antes de suponer extracción |
| **O-37** | `_archivo/` está en `.gitignore:17`: lo movido conserva versionado, lo nuevo no | bloqueante latente | Baja | Decisión sobre si `_archivo/` debe versionarse, y guarda que impida depositar ahí archivos nuevos sin versionar |
| **O-23** | Corregido en su descripción: `20_insumos/` y `RUTA_INSUMOS` existen; el pendiente es solo la constante sin usos | deuda técnica | Baja | Constante eliminada sin referencias huérfanas |
| **A-03** | Los tres commits viven en `ordenacion/20260826`; el marcador 4bis y el fix del escáner no están en `main` | manual del titular | Baja | PR #4 mergeado |

### Evaluación de deuda técnica

**Zonas frágiles.** El paso 6 concentra ruta, parseo, mapeo y render en un archivo de 50K,
y los tres defectos apilados de B13-01 vivían todos ahí. Toda dependencia con el sitio del
Área es implícita: dos commits del hermano (`00a1af3`, `15dc047`) rompieron el paso sin que
nada lo detectara hasta el diagnóstico. **Oportunidad:** un contrato declarado con
`data.js`, verificado en cada corrida, convertiría esas roturas en un error nombrado en vez
de en campos nulos.

### Auditoría de cierre (POLITICA 5.6)

| # | Pregunta | Respuesta |
|---|---|---|
| 1 | ¿Datos crudos aislados e inmutables? | Sí, tras D-01 |
| 2 | ¿Pipeline corre de cero? | Sí |
| 3 | ¿Paquetes, rutas y constantes al inicio? | Sí |
| 4 | ¿Estructura respeta la política? | En rama, no en `main` → pendiente PR #4 |
| 4bis | ¿Existe `50_ordenacion_repositorio.md`? | Solo en la rama → el gatillo sigue encendido en `main` |
| 4ter | ¿Existe `50_locale_utf8.md`? | Sí |
| 8 | ¿Nombres sin tildes, ñ ni espacios? | No: `Panorama de cartera.dc.html` en `andamios/`, congelado. **Excepción declarada** (O-19) |
| 9 | ¿Guarda de locale vista fallar? | No → O-11 |

### Salida de la compuerta de dudas

**2 registradas.**

| Campo | Duda 1 | Duda 2 |
|---|---|---|
| `supuesto` | El censo de backlogs detecta un hueco real, y no solo produce falsos positivos por sobre-detección | `semaforo` llega nulo por la misma causa que `estado_proyecto`, es decir una columna sin curar y no un defecto de extracción |
| `predicado` | Plantando un hueco en una copia de un repo clasificado `calza`, el instrumento lo clasifica `hueco_interno` y nombra los números faltantes | Los `ESTADO.md` de los hermanos traen `semaforo` con valor, y el campo se pierde en algún punto entre la lectura y la salida |
| `medicion` | Copia local de un repo `calza`, borrado de dos entradas intermedias, corrida del motor desde `andamios/`, contraste del veredicto | Tabla de los 23 hermanos con `ESTADO.md`, campo `semaforo`, presente o ausente; y traza del campo por etapa si está presente |

Las dos quedaron sin medir. La primera porque su control positivo necesita diseño y no un
comando improvisado; la segunda porque O-38 apareció en la verificación final del cierre.

### Ruta sugerida para la sesión 14

1. **O-38**, diagnóstico de `semaforo`. Tipo bug activo, y es el campo por el que el
   titular lee la cartera de un vistazo. Criterio de éxito: archivo y línea, midiendo en
   origen primero. Prioridad 1 por §1.2.4: bug activo del producto publicado.
2. **Duda 1**, control positivo del censo. Es la única de las dos dudas que puede cambiar
   una decisión ya tomada.
3. **A-06**, guarda de locale. El más barato; cierra la pregunta 9 de la auditoría.
4. **A-20**, cola de código menor (O-20, O-23, O-24, O-26, O-32), con la línea base del
   registro ya versionada como referencia.

**Diferir:** A-21 (curación del registro) hasta que A-20 arregle la idempotencia, porque
curar sobre un archivo que el paso 1 corrompe en la corrida siguiente es trabajo perdido.
Y toda la ruta del comando único (E0 a E6) hasta que O-38 esté cerrado.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ **NO** dar por cerrada la ordenación del repositorio sin haber mergeado el PR #4: el
  marcador 4bis y el fix del escáner no están en `main`.
- ⚠️ **NO** depositar archivos nuevos en `_archivo/` sin comprobar que quedan versionados:
  `.gitignore:17` los ignora y solo lo movido conserva el versionado (O-37).
- ⚠️ **NO** diagnosticar `semaforo` suponiendo una cadena de extracción: medir primero en
  los `ESTADO.md` de los hermanos, como en A-05.
- ⚠️ **NO** curar `estado_proyecto` sin fijar antes su dominio contra `RANGO_ESTADO` del
  paso 6: el enum equivocado tumbó ese paso en la sesión 6.
- ⚠️ **NO** modificar el instrumento de cierre ni SETTINGS desde una sesión de este
  proyecto: son transversales a los 25 hermanos y su cambio obliga a repropagarlos.
- ✅ **ANTES** de escribir un encargo, verificar contra disco cada premisa de hecho que
  contenga; y en el propio encargo, instruir al ejecutor a corregir las que resulten falsas
  en vez de obedecerlas.
- ✅ **ANTES** de dar por bueno un control negativo, comprobar que también detecta el error
  contrario al que fue diseñado a evitar.
- ✅ **ANTES** de afirmar el estado del repositorio, correr el comando: el inventario de la
  sesión 12 declaraba 12 traspasos a la vista y había uno.
- 🔒 El instrumento del censo (motor y arnés) vive en `andamios/` y está congelado.
- 🔒 Las entradas 55 a 61 del backlog están perdidas y su hueco es permanente.
- 🔒 Los normativos no se versionan en este repositorio.
- 🔒 La cartera está en producción permanente: `slep_reportes_modelo_resguardo_asistencia`
  cerró su sesión v86 entre dos corridas de esta sesión.

## 13. Fragmentos de código de referencia

Sin patrones nuevos que el traspaso deba transcribir. Los dos instrumentos de esta sesión
son archivos ejecutables versionados: `20260826_censo_backlogs_motor.R` y
`20260826_censo_backlogs_autotest.R`, ambos en `andamios/`.

**Catálogo de modos de mentir del censo**, para quien lo vuelva a correr: convención
`C-NNN` no cubierta por los patrones; estilos de numeración mezclados en un mismo archivo;
hash de git leído como rango (`df9a633` como "9 a 633"); patrón laxo que mide conteos de
líneas y versiones; correlativo denso con atípicos.

## 14. Reapertura

Continuemos con `slep_estado_proyectos_monitoreo`. Tipo CONTINUATION. El protocolo
(`POLITICA_PROYECTO.md` + `SETTINGS_Y_PROMPTS_OPERACIONALES.md`) vive en la knowledge base
del Project y se lee desde ahí.
Documentos:
1. Knowledge base (no adjuntar, verificar versión): `POLITICA_PROYECTO.md` v5.8,
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md` v34.
2. Adjuntar: `traspaso_cierre_v13.md`.
Contexto que el traspaso no alcanza a cubrir: nada, salvo lo que el propio cierre
descubra.
Estado esperado en la apertura: `main` publicado y sincronizado. Candado 0bis en rojo por
`cierre_incompleto`, que declara el PR #4 sin mergear. Si ya lo mergeaste, el campo pasa a
`no` y el candado abre normal.
Foco sugerido, en este orden:
1. Diagnóstico de O-38 (`semaforo` nulo en el panorama publicado), midiendo en origen antes
   de suponer extracción.
2. Control positivo del censo (duda 1): plantar un hueco real y comprobar que lo detecta.
3. A-06, guarda de locale.
El inventario completo de pendientes está en
`50_documentacion/andamios/20260826_pendientes_ruta_e_itinerario.md`, con la corrección de
O-23 y el agregado de O-37 y O-38 que este traspaso declara.

## 15. Errores del asistente

| Campo | E13-01 | E13-02 | E13-03 |
|---|---|---|---|
| `momento` | Redacción del encargo A-00 | Redacción del encargo A-00, §4.5 | Turno posterior al censo, entrega del encargo de duda 6 |
| `disparador` | Claude Code lo señaló en ejecución | Claude Code lo corrigió en ejecución | Usuario lo corrigió |
| `que_paso` | La regla de detención exigía árbol limpio, condición que el propio archivo del encargo hacía imposible de cumplir | Afirmó que el paso 32 lee `registro_proyectos.csv`; los lectores reales son el 34 y el 36 | Declaró destino de un encargo sin materializar el archivo |
| `regla_violada` | SETTINGS §4.7 y POLITICA §5.6: precondición verificable | userPreferences, marcador de fuente: premisa fáctica de encargo exige fuente | userPreferences, materialización: el artefacto se entrega como archivo |
| `causa_raiz` | Escribió la precondición sin simular su cumplimiento con el encargo ya en disco | Dedujo el lector por el número de paso en vez de leer el código | Compuso la respuesta alrededor del encabezado de destino y no ejecutó la creación |
| `salvaguarda_presente` | SETTINGS + userPreferences | userPreferences + POLITICA | userPreferences |
| `patron` | PAT-13, precondición que mide un proxy y no el riesgo | PAT-01, sobre consumidor de un archivo | PAT-06, destino anunciado sin archivo |
| `gatillo_observable` | `encargos-premisas`: precondición que el propio artefacto del encargo falsea | `afirmar-sin-leer`: consumidor de archivo nombrado sin grep | `entrega-sin-destino-o-nombre`: destino declarado sin llamada de creación |
| `intentos_previos` | 0 | 0 | 0 |
| `costo` | Una detención y una adjudicación del titular, repetida en A-05 | Ninguno: el ejecutor corrigió y puso la guarda donde correspondía | Un turno perdido |

| Campo | E13-04 | E13-05 | E13-06 |
|---|---|---|---|
| `momento` | Propuesta y redacción del parche v35/v12 | Entrega del encargo A-03 | Petición del instrumento de cierre al titular |
| `disparador` | Usuario lo corrigió | Usuario lo corrigió | Asistente lo señaló al encontrarlo en la knowledge base |
| `que_paso` | Redactó un parche a dos documentos transversales a los 25 hermanos sin advertir que obliga a repropagarlos, y lo ejecutó tras un "vamos con tu recomendación" que describía el cambio como local | Entregó el encargo diciendo que iba sin bloque de Claude Code, dejando la aprobación sin salida | Pidió al titular el instrumento de cierre, que estaba en la knowledge base del Project |
| `regla_violada` | POLITICA §0.3, compuerta de gobernanza: aprobación explícita informada | userPreferences, formato de mensajes a Claude Code | userPreferences, gobernanza de sesión: los protocolos viven en la knowledge base, no se piden adjuntos |
| `causa_raiz` | Trató el alcance transversal como detalle de implementación y no como el hecho que define la decisión | Aplicó literalmente la regla del protocolo (aprobación previa) sin cerrar el circuito de qué sigue tras aprobar | Buscó el instrumento dentro de SETTINGS y, al no hallarlo, asumió ausencia en vez de buscarlo como archivo propio |
| `salvaguarda_presente` | POLITICA + userPreferences | userPreferences | userPreferences |
| `patron` | PAT-07, restricción de alcance no propagada al diseño del parche | PAT-05, división titular/asistente mal cerrada | PAT-01, ausencia inferida sin agotar la búsqueda |
| `gatillo_observable` | `restriccion-no-propagada`: artefacto transversal modificado desde sesión de un proyecto | `entrega-sin-destino-o-nombre`: artefacto aprobable sin vía de ejecución | `ausencia-adjuntos`: insumo pedido al titular sin agotar la knowledge base |
| `intentos_previos` | 0 | 0 | 1: buscó por grep dentro de SETTINGS y concluyó ausencia |
| `costo` | Dos artefactos rehechos y descartados; una molestia del titular | Un turno perdido y un relevamiento repetido | Un adjunto innecesario del titular |

| Campo | E13-07 | E13-08 |
|---|---|---|
| `momento` | Redacción del encargo A-03 | Dos sugerencias de cierre de sesión |
| `disparador` | Claude Code lo señaló en el relevamiento | Usuario lo corrigió |
| `que_paso` | Declaró 12 traspasos a la vista, heredado del inventario de la sesión 12; había uno | Atribuyó a degradación de contexto lo que era, la segunda vez, consecuencia de su propia omisión de la instrucción a Claude Code |
| `regla_violada` | userPreferences, marcador de fuente: estado de repositorio exige fuente de esta sesión | userPreferences, higiene de sesión: el síntoma debe ser el diagnosticado |
| `causa_raiz` | Arrastró una cifra de un documento anterior sin verificarla, después de haber declarado ese mismo patrón en el turno previo | Leyó la repetición como síntoma del interlocutor sin considerar su propia causa |
| `salvaguarda_presente` | userPreferences | userPreferences |
| `patron` | PAT-01, cifra heredada de documento anterior | PAT-01, diagnóstico sin verificar la causa propia |
| `gatillo_observable` | `estado-git`: conteo de archivos del repo afirmado sin `ls` | `otro`: atribución de causa sin descartar la propia |
| `intentos_previos` | 0 | 1: la primera sugerencia sí correspondía |
| `costo` | Un encargo reescrito por completo | Una molestia del titular |

| Campo | E13-09 |
|---|---|
| `momento` | Redacción del paquete de cierre v13 |
| `disparador` | Claude Code detuvo en F5 con I4 en rojo |
| `que_paso` | Declaró `taxonomia: Sin cambios` mientras aportaba doce entradas nuevas sin clasificar, lo que dejaba la Clasificación temática contradiciendo su propio total, y usó para el bloque de entradas una convención de encabezado y numeración distinta de la del archivo |
| `regla_violada` | Instrumento de cierre §2, bloque `BACKLOG_NARRATIVA`: `taxonomia` declara categorías nuevas o reclasificaciones; e I4, ninguna afirmación viva puede quedar falsa |
| `causa_raiz` | Leyó "sin categorías nuevas" como equivalente a "sin cambios en la tabla", cuando doce entradas cambian la columna `N` aunque no creen categorías. La convención del bloque la escribió de memoria en vez de mirar el archivo |
| `salvaguarda_presente` | Instrumento de cierre + SETTINGS |
| `patron` | PAT-01, sobre la propia estructura del archivo que se está editando |
| `gatillo_observable` | `cifras-datos`: tabla con total declarado modificada sin recalcular sus componentes |
| `intentos_previos` | 0 |
| `costo` | Una detención en F5 y una reemisión del paquete |

**Patrón de la sesión.** Ocho de los nueve errores son de la misma familia: afirmar el
estado del sistema sin haberlo medido, y hacerlo dentro de encargos, donde la afirmación
se convierte en instrucción. Aparecieron en A-00, A-05, A-17, A-18, A-19, A-03 y en el propio paquete de cierre, es
decir en todos los artefactos con premisas de hecho. La salvaguarda que funcionó no fue verificar
más, sino instruir al ejecutor a corregir y nombrar las premisas falsas. Se propone como
cláusula fija.

**Fricciones.**

- `friccion: entregar como descargable un inventario que el titular quería leer en el chat → se repitió en el chat sin el archivo`
- `friccion: recomendar el siguiente encargo al final de casi cada turno, aun cuando el titular no lo había pedido → se limitó a los turnos en que había decisión abierta`
