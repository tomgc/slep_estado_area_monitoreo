# Traspaso de cierre v14 — slep_estado_proyectos_monitoreo

## 1. Identificación

**Proyecto:** `slep_estado_proyectos_monitoreo` (remoto `tomgc/slep_estado_area_monitoreo`; el nombre del directorio local difiere del remoto, deuda de nomenclatura documentada y aceptada).
**Versión:** v14. **Fecha:** 2026-08-27. **Sesión:** 14.

**Foco.** Corregir O-38 en su causa y no en su síntoma, y publicar la cartera que existe hoy en vez de la que existía el 26 de agosto.

**Entorno.** macOS, Positron, R con `renv`, `gh` CLI, `git`. Shell interactivo `zsh` (medido: `[ "$a" \< "$b" ]` falla con `condition expected: <`, y todo script de la sesión corrió bajo `bash -c` explícito). Flujo dual: Claude conversacional para planificación y autoría de encargos, Claude Code para ejecución autónoma con hasta tres subagentes de solo lectura.

**`main` previo al cierre:** `e93fa5f`.

**Archivos principales modificados:**

- `30_procesamiento/31_descubrir_proyectos.R`
- `30_procesamiento/32_localizar_documentos.R`
- `30_procesamiento/33_extraer_metadatos.R`
- `30_procesamiento/36_generar_panorama_visual.R`
- `10_utils/10_configuracion.R`
- `.gitignore`
- `50_documentacion/activa/ESTADO.md`
- `50_documentacion/activa/50_ordenacion_repositorio.md` (llegó por el merge del PR #4)
- `50_documentacion/andamios/20260827_censo_backlogs_driver.R` (nuevo)

## 2. Resumen ejecutivo

La sesión se propuso cerrar el candado 0bis, diagnosticar O-38 midiendo en origen antes de suponer una cadena de extracción, resolver la duda 1 del censo y ejecutar la guarda de locale A-06. Lo primero se logró mergeando el PR #4, cuyo conflicto era solo rotación de snapshots del escáner. El diagnóstico de O-38 desdobló el bug en dos causas distintas: `semaforo` estaba presente en los 23 orígenes y se perdía en compuertas que gateaban por sincronía, mientras `estado_proyecto` y `datos_sensibles` nunca habían estado (el segundo por un nombre de campo equivocado, `maneja_sensibles` en el origen). Persiguiendo esa causa apareció B-14-01, más grave que O-38: `PATRON_TRASPASO` estaba anclado con `$` y `resolver_traspaso()` devolvía `NA`, que el código leía como sincronizado por omisión, de modo que un repo llevaba once sesiones declarándose sincronizado sin que nadie comparara nada. Corregido eso y migrada la detección de `mtime` a `vNN`, las fichas con `semaforo` pasaron de 13 a 18 de 24. Persiguiendo esa corrección apareció el hallazgo mayor de la sesión, que no era el objetivo de ningún encargo: el paso 6 tomaba el universo de un `inventario_cartera.json` congelado, publicaba un proyecto dado de baja y omitía tres directorios, dos de ellos activos. Con el universo derivado del descubrimiento y las bajas filtradas, el panorama pasó a las 26 fichas que existen, con 20 semáforos y las 6 restantes de causa nombrada. Quedó pendiente A-06, porque el gatillo 4ter no se enciende y era lo menos urgente, y quedaron dieciséis pendientes nuevos, cuatro de ellos con decisión del titular ya tomada y sin ejecutar.

## 3. Estado al cierre

**Qué funciona.** El pipeline completo corre de punta a punta y es determinista: `run_all(from = 1, to = 6)`, última ejecución exitosa el 2026-08-27, con `registro_proyectos.csv` e `inventario_cartera.json` byte-idénticos en dos corridas consecutivas y `panorama_visual.html` idéntico módulo el sello de hora. El paso 1 es idempotente (tres corridas, md5 `760581c8…` en las tres). El panorama publicado sirve 26 fichas con 20 semáforos, verificado con `curl -sI` (HTTP/2 200) sobre la corrida `33114315636` del workflow de Pages, `completed/success` para `e93fa5f`. El candado 0bis está cerrado limpio.

**Qué no funciona.** `estado_proyecto` sigue vacío de punta a punta (26 fichas, 27 filas del registro); curarlo exige fijar antes `RANGO_ESTADO`. `tipo_pendiente` tiene dos valores fuera del enum: el pie los cuenta crudos (4) y el filtro los agrupa en `na` (6), la misma contradicción que se corrigió para `amarillo` y que quedó sin corregir para este campo. `35_compilar_panorama.R` calcula fechas sin zona en dos puntos. El paso 4 aborta ante un slug sin datos mientras el paso 6 degrada y advierte: dos criterios opuestos en el mismo pipeline.

**Delta respecto a v13.** En v13 el panorama corría con `data.js` recién reparado y tres campos llegando nulos a todas las fichas. En v14 la causa de esos tres campos quedó separada y dos de ellas resueltas; el universo dejó de heredarse de un archivo congelado; y aparecieron tres defectos silenciosos que v13 no podía ver porque otros defectos los enmascaraban (el `NA` leído como sincronizado, la fecha en UTC que el margen de un día ocultaba, y el payload JSON como objeto que ningún conteo detectaba).

## 4. Registro detallado de cambios

**4.1 Merge del PR #4 y cierre del candado.** Archivos: `50_documentacion/estructura/estructura_actual.{md,txt}`, `50_documentacion/activa/ESTADO.md`. El PR estaba `CONFLICTING/DIRTY` por rotación de snapshots del escáner en ambos lados. Se resolvió tomando la versión de `main` (corrida 09:54:03) por ser salida regenerable y no autoría. Los lados se midieron y no se recordaron: `ls-files -u` dio stage 2 = `49b95af` (rama) y stage 3 = `dd85df1c` (`main`), contrastado contra `git rev-parse main:<path>`. Verificación: gatillo 4bis apagado, `git show origin/main:50_documentacion/activa/50_ordenacion_repositorio.md | wc -l` devuelve 87 donde antes fallaba con `path does not exist`. Commits `7a54c73`, `6e26006`, `9f07b84`.

**4.2 B-14-01, el `NA` que se leía como afirmación positiva.** Archivo: `32_localizar_documentos.R`. `PATRON_TRASPASO` estaba anclado con `$` tras el correlativo y no admitía sufijos, así que 0 de los 11 traspasos de `slep_minuta_buenas_senales` matcheaban. La causa raíz no era el regex sino la ausencia de rama para "no pude medir": `resolver_traspaso()` devolvía `NA` y `resolver_estado()` no evaluaba la comparación, dejando `sincronizado = TRUE` por omisión. Se introdujo veredicto de tres estados con asimetría deliberada: afirmar sincronía exige evidencia positiva, apagar un campo exige evidencia negativa. Verificación: coincidencias de la cartera 590 → 601 (+11, exactamente los del caso malo), 0 falsos positivos sobre 176 archivos. Cambian 5 veredictos de 27.

**4.3 B-14-03, unificación de las dos semánticas de desync.** Archivos: `32_localizar_documentos.R`, `36_generar_panorama_visual.R`. La premisa de partida resultó parcialmente falsa: el booleano de `36:348-353` era idéntico al de 32 (0 divergencias en barrido exhaustivo sobre `ua × mt × margen`); lo que divergía era el payload en tres puntos: `seccion_md()` estricto contra `bloque_seccion()` laxo, resolución del traspaso en vivo contra lectura del `mtime` del inventario en disco, y `SUBRUTA_ESTADO` contra ruta literal rehardcodeada. Se conservó la semántica de 32 en los tres. Unificar mirando solo el booleano habría perdido las tres sin medirlas. Verificación: `grep -rn` con cero copias residuales.

**4.4 O-38 y P6, detección de sincronía por `vNN`.** Archivo: `32_localizar_documentos.R`. Criterio: `sesion_actual` del front matter contra el `vNN` del traspaso más reciente, vía `resolver_traspaso()`. Fallback declarado: sin traspaso legible o sin `sesion_actual`, el veredicto es `indeterminado`, nunca `desincronizado`. Verificación: predicción declarada antes de regenerar (18 de 24, con las 6 causas nombradas), conteo obtenido 18, 0 campos poblados perdidos, controles 7 de 7.

**4.5 `amarillo` en el enum y aviso ante valores desconocidos.** Archivos: `10_configuracion.R`, `36_generar_panorama_visual.R`. `amarillo` entró a `SEMAFOROS`, `ETIQUETA_SEMAFORO`, `.punto.sem-amarillo` y `.atn-card.sem-amarillo`, todos generados desde `RANGO_SEMAFORO`. Se añadió advertencia nombrada ante cualquier valor fuera del enum. Verificación: dispara sobre `turquesa` plantado, calla sobre los 5 del enum, los 18 reales y los nulos.

**4.6 Guarda de forma del payload JSON.** Archivo: `36_generar_panorama_visual.R`. Ver §6, B-14-04. `unname()` antes de serializar, guarda que aborta si el payload deja de ser array, KPIs y filtros derivados del enum, `.atn-card.sem-na` definida y la guarda cubriendo ambas familias de clases.

**4.7 Aviso cuando la sección de próximo paso no calza la forma canónica.** Archivo: `32_localizar_documentos.R`. Verificación: advierte en las 4 formas no canónicas (`###`, sufijo, mayúsculas, `#`), calla en la canónica y en la ausente, 0 advertencias sobre los 23 `ESTADO.md` reales, artefacto sin cambios.

**4.8 Retiro de constantes huérfanas.** Archivo: `10_configuracion.R`. `MARGEN_DESYNC_DIAS` (huérfana tras 4.4) y `RUTA_INSUMOS`. Verificación: `grep -rn` devuelve 0 y 0, `run_all(only = 6)` sin error.

**4.9 O-20 / B13-03, el vacío que se volvía `"NA"`.** Archivo: `31_descubrir_proyectos.R`. `write_csv(na = "NA")` seguido de `read_csv(na = c("", "NA"))` convertía una celda vacía en la cadena `"NA"` en cada ciclo. Se cerraron los dos extremos: normalización `NA → ""` al leer (que además limpia lo ya contaminado) y `write_csv(na = "")`. Se barrieron las 30 guardas con `nzchar()` del pipeline: solo `31:131` operaba sobre una lectura de CSV sin protección; `35:46` y `36:592` llevan `!is.na()` delante y el resto opera sobre front matter o entorno. Verificación: celdas `"NA"` 73 → 0, vacías 10 → 83, tres corridas con md5 idéntico, 0 celdas de contenido curado perdidas.

**4.10 Unificación de zona horaria en el paso 3.** Archivo: `33_extraer_metadatos.R:20` y `36:691`. 16 cálculos de fecha hallados en el repo; corregidos dos, dos quedan fuera de la lista de autorizaciones (`35:33`, `35:135`, pendiente P-25-01), y el resto son `Sys.time()` que miden duración o sellan logs. Verificación: caso de borde construido en `America/Santiago`; a las 21:30 y 23:59 locales la fecha vieja difería de la regla de 32 y la nueva coincide; 2 de 4 casos difieren antes, 0 de 4 después.

**4.11 Universo derivado del descubrimiento y filtro de bajas.** Archivo: `36_generar_panorama_visual.R:413`. Los pasos 1 a 5 son cadena de memoria fresca; el paso 6 era el único que volvía al disco y por eso el único que podía desfasarse. El campo de baja es `categoria == "baja"` en `registro_proyectos.csv`, escrito por `31_descubrir_proyectos.R:181`, único lugar del repo que escribe ese valor; el paso 6 lo leía como etiqueta (`36:501`) y no filtraba con él. El inventario se conserva para sus otros roles (sellos, rutas relativizadas, fuente del paso 5), indexado por slug. Verificación: 26 fichas contra 26 predichas, asimetrías cartera↔panorama de 4 a 0.

**4.12 Guarda de asimetría y tolerancia con aviso a esquemas no canónicos.** Archivos: `36_generar_panorama_visual.R`, `32_localizar_documentos.R`. Corrección del nombre `datos_sensibles` → `maneja_sensibles` (el campo de sensibilidad pasa de poblado en 1 de 24 a 24 de 24). Tolerancia con advertencia nombrada para las claves no canónicas de `slep_reporte_emergencia`. Advertencia de contradicción no pedida y conservada: `slep_paes` tiene `datos_sensibles=FALSE` curado y `maneja_sensibles=TRUE` real; se muestra el origen y se advierte, no se cura. Verificación: la guarda de asimetría dispara sobre 4 y calla sobre 23; la de esquema dispara sobre 1 y calla sobre 22.

**4.13 `_archivo/` fuera del `.gitignore` (O-37).** Archivo: `.gitignore`. Premisa parcialmente falsa: los dos archivos ya estaban trackeados desde `5c90656` porque llegaron por `git mv`. El valor del cambio es preventivo y se demostró: con el ignore, un archivo nuevo depositado ahí es invisible; sin él, aparece en `status`.

**4.14 Driver versionado del censo de backlogs.** Archivo nuevo: `50_documentacion/andamios/20260827_censo_backlogs_driver.R`. El motor y el arnés vivían versionados pero el driver que los orquesta no, así que la línea base del censo era una foto y no algo re-derivable. Verificación: reproduce 22 de 25 repos comunes; las 3 diferencias son crecimiento del backlog (77→89, 17→32, 491→507) con clase idéntica; no se ajustó el driver al resultado. Motor y arnés no editados (mtimes intactos).

**4.15 Duda 1, control positivo del censo (cerrada en sesión).** Se plantó un hueco real en una copia bajo `/tmp/` de `slep_simce_adecuado` (correlativo 1..138 denso, elegido porque los duplicados de `reporte_emergencia` habrían dado un falso "ciego"). Intacto → `calza`, `n_huecos=0`. Borradas 47 y 91 → `hueco_interno`, `[47 91]`. Borradas 70-72 → `hueco_interno`, `[70-72]`, `n_huecos=3`. Renumerado denso +100 → `calza`. Arnés congelado 6 de 6. Veredicto: `detecta`. La duda queda resuelta a favor del supuesto y la conclusión de v13 (la pérdida de las entradas 55-61 es un accidente aislado) se sostiene.

## 5. Backlog acumulativo

Archivo canónico: `50_documentacion/activa/backlog_acumulativo.md`. Esta sesión agrega 15 entradas, tramo 90→104. Total previo 89, total nuevo 104. El hueco permanente 55-61 se mantiene. Sin categorías nuevas ni reclasificaciones: las quince se reparten entre las quince categorías existentes, una entrada una categoría, y el reparto viaja en el bloque de narrativa de este paquete.

## 6. Bugs de la sesión

**B-14-01 (alta, resuelto).** *Síntoma:* `slep_minuta_buenas_senales` figuraba sincronizado desde hacía once sesiones. *Causa raíz:* `PATRON_TRASPASO` anclado con `$` en `32_localizar_documentos.R`; `resolver_traspaso()` devolvía `NA` y `resolver_estado()` dejaba `sincronizado = TRUE` por omisión. *Solución:* patrón relajado a sufijos y veredicto de tres estados con `indeterminado`. *Verificación:* 590 → 601 coincidencias, 0 falsos positivos, diff de veredictos de los 27 hermanos. *Patrón aprendido:* **un dato ausente no es un dato positivo; toda función que puede devolver "no pude medir" necesita rama propia, o su ausencia se convierte en afirmación.** *Principios:* B.4 (verificación), C.11 (causa raíz). *Estado:* resuelto.

**B-14-02 (media, mitigado).** *Síntoma:* el `ESTADO.md` de `slep_reporte_emergencia` usa `sesion:`, `fecha:` y `sensibilidad:`. *Causa raíz:* deriva de esquema en el repositorio hermano. *Solución:* tolerancia con advertencia nombrada en el orquestador; la corrección de origen exige sesión y autorización nominal propias. *Verificación:* con el alias aceptado pasa a sincronizado (`v51 >= v51`) y conserva su semáforo por la razón correcta. *Estado:* mitigado en el orquestador, pendiente en el hermano (P-25-07).

**B-14-03 (media, resuelto).** *Síntoma:* dos copias de la lógica de desync. *Causa raíz:* el paso 6 reimplementaba en vez de llamar. *Solución:* fuente única en 32. *Patrón aprendido:* **cuando se sospecha lógica duplicada, comparar el resultado no basta: dos implementaciones pueden coincidir en el booleano y divergir en el payload.** *Estado:* resuelto.

**B-14-04 (bloqueante, introducido y resuelto en la misma sesión).** *Síntoma:* la página publicada quedó en blanco entre las 16:29 y las 16:38. *Causa raíz:* `stats::setNames()` para indexar por slug hizo que `jsonlite::toJSON()` serializara la lista nombrada como objeto `{}` en vez de array `[]`; el `CARTERA.forEach(...)` de la primera sentencia de `render()` lanzó `TypeError` y abortó lista, KPIs, banda de atención y filtros. *Por qué pasó desapercibido:* cinco chequeos daban verde (26 fichas, 20 semáforos, 0 campos perdidos, 0 cadenas `"NA"`) porque `jsonlite::fromJSON()` parsea objeto y array por igual. *Solución:* `unname()` antes de serializar y guarda de forma que aborta si el payload deja de ser array. *Verificación:* primer carácter del payload, `Array.isArray()` en node, y contraste contra el artefacto de `4d30cff`; render real sin errores de consola, 26 filas, suma de KPIs 26 = 26. *Patrón aprendido:* **un chequeo de cantidad no sustituye a uno de forma; un artefacto destinado a un navegador se verifica abriéndolo.** *Estado:* resuelto en `e93fa5f`.

**B-14-05 (media, resuelto).** *Síntoma:* los KPIs sumaban 25 contra un pie que declaraba 26, y no había chip `amarillo`. *Causa raíz:* `renderKPIs` y `renderFiltros` conservaban listas literales de 4 valores; `cont["amarillo"]` era `undefined` y `undefined++` da `NaN`. La corrección del enum llegó a 4 de 6 consumidores y la guarda instalada no veía los otros dos porque no tenían marcador que sustituir. *Patrón aprendido:* **una guarda solo cubre lo que se le enseñó a mirar; generar desde fuente única no sirve si algún consumidor no consulta la fuente.** *Estado:* resuelto.

## 7. Aprendizajes y restricciones descubiertas

1. **Un dato ausente no es un dato negativo ni positivo.** Regla: toda función que puede fallar en medir devuelve un tercer estado explícito, y el consumidor decide qué hacer con él. Contexto: si se viola, la ausencia se convierte silenciosamente en la afirmación más cómoda. Ejemplo: B-14-01, once sesiones de falso negativo. Principio: B.4.
2. **Afirmar y negar no cuestan lo mismo.** Regla: afirmar sincronía exige evidencia positiva; apagar un campo visible exige evidencia negativa. La asimetría es deliberada y debe declararse donde se implementa. Ejemplo: el veredicto de tres estados de 4.2.
3. **Un chequeo de cantidad no sustituye a uno de forma.** Regla: un artefacto se verifica por la vía en que se consume; si el consumidor es un navegador, se abre. Ejemplo: B-14-04, cinco chequeos en verde sobre una página que no cargaba. Principio: B.4.
4. **Corregir un defecto puede desactivar el amortiguador que ocultaba otro.** Regla: tras retirar un margen, una tolerancia o un fallback, barrer lo que ese amortiguador podía estar tapando. Ejemplo: el margen de un día ocultaba la fecha en UTC de `33:20`.
5. **Comparar el resultado no prueba que dos implementaciones sean la misma.** Regla: al unificar lógica duplicada, comparar el payload completo y no el veredicto. Ejemplo: B-14-03, booleano idéntico y tres divergencias de payload.
6. **El acoplamiento posicional es correcto hasta el instante exacto en que se cambia el universo.** Regla: iterar por identificador y no por índice en todo cruce entre dos listas. Ejemplo: el chequeo cruzado del paso 6 iteraba `seq_along()` y habría escrito en la ficha equivocada mientras el aviso nombraba el slug correcto; lo atrapó un barrido hecho **antes** del cambio, no después.
7. **El panel adversarial dejó de ser control de calidad y pasó a ser instrumento de descubrimiento.** Los tres hallazgos más consecuentes de la sesión (B-14-03 mal caracterizado, el universo congelado, el JSON como objeto) los trajo un subagente de solo lectura consumiendo el artefacto por una vía distinta de la que lo produjo, no el hilo principal.
8. **La concurrencia de sesiones sobre la cartera es condición permanente.** Regla: sellar el universo una sola vez al inicio de la fase en vez de re-listar a mitad de camino; y sellar los mtimes de los artefactos antes de auditarlos. Ejemplo: un subagente detectó que estaba auditando un objeto en movimiento y rehízo el conteo contra la versión final.
9. **Un criterio de éxito se deriva de la medición, no se declara antes de tenerla.** Ejemplo: el "24 de 24" de un encargo era aritméticamente imposible (solo 20 fichas tienen `semaforo` en origen) y habría hecho revertir un cambio correcto.
10. **El redactor del cierre no puede declarar el reparto temático sin la tabla de clasificación.** Regla operativa hasta que el instrumento se corrija: pedir la tabla de `backlog_acumulativo.md` **antes** de emitir el paquete, no después de que la compuerta detenga. Ejemplo: la detención en F5 de esta sesión, reincidencia de la desviación 1 de v13.

## 8. Decisiones de diseño

**D14-01. El universo del panorama se deriva del descubrimiento, no del inventario.** Alternativas: incorporar a mano los dos proyectos faltantes al mapeo. Justificación: el mapeo manual trata el síntoma y volvería a fallar con el próximo proyecto nuevo. Implicancia: el inventario conserva sus otros roles y deja de ser fuente del universo.

**D14-02. El orquestador tolera esquemas no canónicos y advierte con nombre.** Alternativas: escribir en el hermano para normalizar, o tolerar en silencio. Justificación: la escritura en un hermano exige sesión y autorización nominal propias; tolerar en silencio convertiría la deriva de esquema en invisible, que es el defecto que se está corrigiendo y no una variante de él. Tensión resuelta: robustez del lector contra visibilidad de la deuda; se resuelven ambas.

**D14-03. `registro_proyectos.csv` vuelve al control de versiones.** Alternativas: mantenerlo ignorado como dejó D-01 en la sesión 13. Justificación: guarda contenido curado que no se regenera (17 filas de `nombre_real` y `notas`) y ahora es la fuente del campo de baja; el pipeline demostró ser determinista, así que el churn solo aparece cuando el dato cambia. **D-01 no fue un error: cambió la condición que lo justificaba.** Implicancia: pendiente P-25-03, no ejecutado en esta sesión.

**D14-04. La sensibilidad la manda el origen.** Alternativas: que mande el registro curado. Justificación: el curado de `slep_paes` subdeclara sensibilidad (`FALSE` contra `TRUE` real), que es el sentido peligroso del error. Implicancia: se corrige el registro, nunca el hermano.

**D14-05. Las guardas advierten y no abortan, salvo sobre slugs declarados en el mapeo.** Justificación: `simce` existe en el sitio y no en la cartera; abortar por él dejaría el paso inejecutable por un dato verdadero. Se conserva la distinción entre "no lo encontré" y "declaré que no existe".

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `PATRON_TRASPASO` | anclado con `$` tras el correlativo | admite sufijo tras el correlativo | `32_localizar_documentos.R` | B-14-01 |
| `SEMAFOROS` / `RANGO_SEMAFORO` | 5 valores sin `amarillo` | incluye `amarillo` | `10_configuracion.R` | D-24-F |
| `MARGEN_DESYNC_DIAS` | `1L` | retirada | `10_configuracion.R` | huérfana tras la migración a `vNN` |
| `RUTA_INSUMOS` | declarada | retirada | `10_configuracion.R` | huérfana, cero consumidores |

Fuente canónica de las vigentes: `10_utils/10_configuracion.R`.

## 10. Arquitectura de archivos

Escáner regenerado en este cierre; snapshots en `50_documentacion/estructura/` (no en `activa/`, corrección de una premisa que la apertura arrastraba). Cambios estructurales de la sesión: el PR #4 incorporó `50_documentacion/activa/50_ordenacion_repositorio.md` (87 líneas) y `EXCLUIR_DIRS` del escáner pasó a incluir `node_modules`, `packrat` y `venv`; `_archivo/` salió del `.gitignore`; se agregó `50_documentacion/andamios/20260827_censo_backlogs_driver.R`. Verificación contra la política: un solo traspaso vigente a la vista, `backlog_acumulativo.md` en su ruta canónica, nombres en `snake_case` sin tildes ni guiones medios.

## 11. Pendientes y ruta sugerida

### 11.1 Inventario

| # | Pendiente | Tipo | Impacto | Dependencias | Complejidad | Precauciones | Criterio de éxito |
|---|---|---|---|---|---|---|---|
| P-25-13 | `tipo_pendiente` con 2 valores fuera del enum: el pie los cuenta crudos (4) y el filtro los agrupa en `na` (6) | bug activo | Alto (contradicción visible en el producto publicado) | ninguna | Baja | misma familia que `amarillo`: revisar **todos** los consumidores, no solo el generador | pie y filtro concuerdan ficha por ficha, verificado sobre el render |
| P-25-01 | `35_compilar_panorama.R` calcula fechas sin zona | deuda técnica | Medio | D-25-B (autorizado) | Baja | barrer también los `Sys.time()` que no miden duración | caso de borde 21:00-00:00 con veredicto idéntico al de 32 |
| P-25-02 | Paso 4 aborta y paso 6 degrada ante un slug sin datos | deuda técnica | Medio | D-25-C (decidido: degradar) | Baja | no relajar el paso 4 sin advertencia nombrada | un hermano malformado no tumba el panorama y queda nombrado |
| P-25-03 | Registro ignorado e inventario versionado: viaja en git el que envejece | gobernanza | Medio | D-25-D (decidido: versionar) | Baja | revierte parcialmente D-01; documentarlo así | registro versionado, churn solo ante cambio real de dato |
| P-25-06 | Contradicción de sensibilidad en `slep_paes` | decisión titular | Medio | D-25-E (decidido: manda el origen) | Baja | corregir el registro, nunca el hermano | la advertencia deja de emitirse por concordancia, no por silencio |
| P-25-15 | `estado_proyecto` vacío de punta a punta | deuda heredada | Alto | fijar `RANGO_ESTADO` primero (🔒) | Alta | el enum equivocado tumbó el paso 6 en la sesión 6 | dominio fijado y documentado antes de curar una sola celda |
| P-25-16 | SETTINGS §2.2.14 declara que el backlog no se adjunta y §2.2.5 exige que el redactor declare el reparto temático: la primera emisión del paquete no puede traer `taxonomia` correcto por diseño | gobernanza (instrumento transversal) | Medio | el instrumento vive en `herramientas_dev` | Baja | 🔒 no se edita desde una sesión de este proyecto | el paquete se emite con reparto correcto en la primera vuelta |
| P-25-10 | Tres copias del filtro del universo | deuda técnica | Medio | ninguna | Baja | comparar payload, no booleano (B-14-03) | fuente única, `grep` con cero copias residuales |
| P-25-14 | La clase del punto de semáforo usa el valor crudo, no `bucketSemaforo()` | deuda técnica | Bajo | ninguna | Baja | — | clase derivada del bucket, verificada sobre el render |
| P-25-05 | `CATEGORIA_LABEL` declara 2 valores; el dominio real es `activo\|auxiliar\|baja` | cosmética | Bajo | ninguna | Baja | — | enum completo y advertencia ante valor desconocido |
| P-25-07 | `slep_reporte_emergencia` con esquema no canónico y `semaforo: amarillo` | deuda heredada | Medio | autorización nominal del titular sobre ese repo | Media | 🔒 escritura en hermano exige sesión propia | claves canónicas en origen y advertencia que deja de disparar |
| P-25-04 | `.parquet` se escribe y nadie lo lee | deuda técnica | Bajo | descartar consumo desde Power BI | Baja | no retirarlo antes de descartarlo | consumo descartado o el artefacto retirado |
| P-25-09 | La rama de override del chequeo cruzado no está ejercitada por ningún caso vivo | test-coverage | Bajo | ninguna | Baja | — | un caso plantado la ejercita |
| P-25-11 | No hay log persistido de invocaciones: no se sabe qué corrida produjo un artefacto | deuda técnica | Bajo | ninguna | Media | — | cada artefacto trazable a su corrida |
| P-25-12 | Cache huérfano de `slep_georreferenciacion`, versionado, sin proyecto | deuda técnica | Bajo | ninguna | Baja | `git mv` a `_archivo/`, nunca borrado | cache sin proyecto detectado y archivado |
| P-25-08 | Corrección de línea base del reporte de A-24 (13→18) | documentación | Bajo | ninguna | Baja | — | corregido donde alguien lo relea |
| C-14-1 | El panorama de 26 fichas se ve bien en pantalla estrecha; solo se verificó estructura | duda registrada | Medio | ninguna | Baja | verificación visual real, no estructural | a 640 px las 26 filas, los 16 chips y los 6 KPIs se renderizan sin desbordamiento ni solapamiento |
| C-14-2 | La guarda de forma cubre solo objeto contra array | duda registrada | Medio | ninguna | Baja | trabajar sobre copia en `/tmp/` | forzando el payload a string, a `null` y a array vacío, la guarda detiene en los tres casos |
| C-14-3 | El `.parquet` de `34:109` no lo consume nadie | duda registrada | Bajo | acceso a la carpeta de Power BI | Baja | — | ningún `.pbix` ni script fuera del repo referencia esa ruta |
| C-14-4 | Pages publica siempre el artefacto del último commit y no una versión cacheada | duda registrada | Bajo | ninguna | Baja | `curl -sI` desde terminal, nunca `web_fetch` | tras dos pushes consecutivos el md5 servido coincide con el del último commit en ambas |
| O-11 / A-06 | La guarda de locale nunca se vio fallar | deuda heredada | Bajo | ninguna | Baja | romperla a propósito según POLITICA §5.2bis | la guarda se ve fallar y luego pasar |
| O-16 / O-18 | Instrumentos transversales a los 25 hermanos | deuda heredada | Medio | sesión propia | Alta | 🔒 su cambio obliga a repropagar | — |
| D-24-G | Clase compuesta cuando `perdida_declarada` y `hueco_interno` se cumplen a la vez | mejora | Bajo | descongelar el motor del censo | Baja | 🔒 motor congelado | — |
| R13 | Rótulo de cobertura del recuento temático para el catálogo de `herramientas_dev` | documentación | Bajo | el instrumento vive en otro repositorio | Baja | **arrastra dos sesiones declarado sin cursar**; la nota de Cobertura sigue diciendo "las 70 presentes" | incorporado al catálogo y la nota derivada, no escrita a mano |

### 11.2 Evaluación de deuda técnica

*Zonas frágiles.* La duplicación de lógica sigue siendo el modo de fallo dominante del paso 6: se corrigió en el veredicto de sincronía (B-14-03) y reapareció de inmediato en los consumidores del enum (B-14-05) y en el filtro del universo (P-25-10). Viola el principio de fuente única. La segunda zona frágil es la verificación: todos los chequeos del pipeline miden contenido y ninguno mide forma del artefacto publicado, lo que produjo B-14-04.

*Oportunidades.* Un solo barrido que derive del enum todos sus consumidores cerraría P-25-13, P-25-05 y P-25-14 juntos, porque son la misma falla en tres campos distintos.

### 11.3 Auditoría de cierre (POLITICA 5.6)

| # | Pregunta | Respuesta |
|---|---|---|
| 2 | ¿El pipeline corre de cero sin intervención manual? | **Sí.** `run_all(from = 1, to = 6)` verificado en este cierre |
| 5 | ¿Cada transformación crítica tiene check de validación? | **No.** El paso 6 ganó guardas de forma, asimetría y enum; los pasos 2 a 5 no fueron auditados. Pendientes P-25-09 y P-25-11 |
| 6 | ¿Los outputs son reproducibles e idempotentes? | **Sí.** Registro e inventario byte-idénticos en dos corridas; panorama idéntico módulo el sello de hora |
| 7 | ¿Decisiones metodológicas como constantes nombradas? | **No del todo.** `RANGO_ESTADO` sin fijar y `CATEGORIA_LABEL` incompleta: P-25-15 y P-25-05 |
| 8 | ¿Nombres sin tildes, ñ ni espacios? | **Sí**, con la excepción declarada vigente (O-19) |
| 9 | ¿La guarda `asegurar_locale_utf8()` sigue instalada y se la vio fallar? | **Instalada sí** (3 archivos de `10_utils` la invocan); **vista fallar, no.** Pendiente O-11 / A-06 |

### 11.4 Compuerta de dudas (4 registradas)

| # | `supuesto` | `predicado` | `medicion` |
|---|---|---|---|
| C-14-1 | El panorama de 26 fichas se ve bien en pantalla estrecha; solo se verificó estructura | A 640 px de ancho, las 26 filas, los 16 chips y los 6 KPIs se renderizan sin desbordamiento ni solapamiento | Abrir la URL publicada con viewport de 640 px e inspeccionar |
| C-14-2 | La guarda de forma cubre las maneras en que el payload puede dejar de ser consumible, no solo objeto contra array | Forzando el payload a string, a `null` y a array vacío, la guarda detiene en los tres casos | Tres corridas con el payload forzado sobre copia en `/tmp/` |
| C-14-3 | El `.parquet` de `34:109` no lo consume nadie | Ningún `.pbix` ni script fuera del repo referencia esa ruta | `grep` de la ruta en la carpeta de Power BI del titular |
| C-14-4 | Pages publica siempre el artefacto del último commit y no una versión cacheada | Tras dos pushes consecutivos, el md5 del HTML servido coincide con el del último commit en ambas ocasiones | `curl -s` de la URL y md5 contra `git show`, dos veces |

Ninguna se cerró en sesión: descubrirlas más tarde no cuesta una operación irreversible ni una cifra publicada. Las cuatro están en el inventario de 11.1 con su `predicado` como criterio de éxito.

### 11.5 Ruta sugerida para la sesión 15

**Prioridad 1: P-25-13.** Bug activo en el producto publicado, misma familia que `amarillo` y con la lección de B-14-05 ya aprendida (revisar todos los consumidores, no solo el generador). Criterio: pie y filtro concuerdan ficha por ficha sobre el render. Complejidad baja.

**Prioridad 2: las cuatro decisiones tomadas y no ejecutadas** (P-25-01, P-25-02, P-25-03, P-25-06). Son decisiones del titular ya cerradas en la sesión 14; dejarlas sin aplicar las convierte en deuda de gobernanza en vez de deuda técnica. Complejidad baja las cuatro.

**Prioridad 3: P-25-10 y P-25-14 en un barrido.** Misma familia que B-14-03 y B-14-05; cerrarlas juntas evita la tercera reaparición. Complejidad baja.

**Prioridad 4: P-25-15, `estado_proyecto`.** Exige fijar `RANGO_ESTADO` como paso propio antes de curar una sola celda. Complejidad alta; es la única del lote que merece diseño previo.

**Conviene diferir.** O-16 y O-18 (instrumentos transversales, sesión propia). P-25-07 (escritura en hermano, autorización nominal). A-06 / O-11 (el gatillo 4ter no se enciende). El rescate de `slep_reportes_modelo_resguardo_asistencia` y la reconciliación de gobernanza de `slep_paes`, que siguen en el horizonte y no compiten con la ruta anterior.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ **NO** dar por bueno un artefacto destinado a un navegador sin abrirlo: cinco chequeos de cantidad dieron verde sobre una página que no cargaba (B-14-04).
- ⚠️ **NO** corregir un enum tocando solo su generador: la corrección de `amarillo` llegó a 4 de 6 consumidores y la guarda no vio los otros dos (B-14-05).
- ⚠️ **NO** curar `estado_proyecto` sin fijar antes su dominio contra `RANGO_ESTADO`: el enum equivocado tumbó el paso 6 en la sesión 6.
- ⚠️ **NO** re-listar el universo a mitad de una fase: el titular corre otras sesiones sobre la cartera en paralelo. Sellar una vez al inicio.
- ⚠️ **NO** retirar un margen, tolerancia o fallback sin barrer lo que podía estar tapando (la fecha en UTC apareció así).
- ⚠️ **NO** emitir el paquete de cierre sin haber pedido antes la tabla de clasificación temática del backlog: el instrumento no la entrega y `taxonomia` no se puede declarar sin ella (P-25-16). Reincidencia registrada en v13 y v14.
- ✅ **ANTES** de escribir un encargo, verificar contra disco cada premisa de hecho, e instruir al ejecutor a corregir las falsas en vez de obedecerlas.
- ✅ **ANTES** de declarar un criterio de éxito numérico, derivarlo de la medición disponible: el "24 de 24" era imposible y habría hecho revertir un cambio correcto.
- ✅ **ANTES** de unificar lógica duplicada, comparar el payload completo y no el veredicto.
- ✅ **ANTES** de cruzar dos listas, iterar por identificador y nunca por índice.
- ✅ **ANTES** de cerrar, comprobar que `commit_cierre` de `ESTADO.md` quedó con el hash del **commit de log** (F9) y no con el previo: v12 y v13 lo dejaron mal y el instrumento v11 §3 ya lo enmienda.
- 🔒 El motor y el arnés del censo (`20260826_censo_backlogs_motor.R`, `20260826_censo_backlogs_autotest.R`) están congelados.
- 🔒 Ninguna escritura en repositorios hermanos sin autorización nominal por repo.
- 🔒 Los normativos no se versionan en este repositorio.
- 🔒 No modificar el instrumento de cierre ni SETTINGS desde una sesión de este proyecto: son transversales a los 25 hermanos.
- 🔒 Las entradas 55 a 61 del backlog están perdidas y su hueco es permanente.

## 13. Fragmentos de código de referencia

Patrón nuevo de la sesión, aplicable a cualquier proyecto de la cartera: **veredicto de tres estados con asimetría declarada.**

```r
# Un dato ausente no es un dato negativo ni positivo.
# Afirmar sincronia exige evidencia positiva; apagar un campo visible
# exige evidencia negativa. La rama `indeterminado` existe para que la
# ausencia no se convierta en la afirmacion mas comoda.
resolver_sincronia <- function(sesion_actual, vnn_traspaso) {
  if (is.na(sesion_actual) || is.na(vnn_traspaso)) {
    return("indeterminado")
  }
  if (sesion_actual >= vnn_traspaso) "sincronizado" else "desincronizado"
}
```

Segundo patrón nuevo: **guarda de forma sobre el artefacto serializado.**

```r
# Un chequeo de cantidad no detecta un contenedor equivocado:
# jsonlite::fromJSON() parsea objeto y array por igual, asi que
# contar fichas da verde sobre un payload que el navegador no consume.
payload <- jsonlite::toJSON(unname(fichas), auto_unbox = TRUE)
stopifnot(
  "el payload dejo de ser un array JSON" = substr(payload, 1, 1) == "["
)
```

Los patrones estables del proyecto viven en `CLAUDE.md` y se referencian por nombre.

## 14. Reapertura

Continuemos con `slep_estado_proyectos_monitoreo`. Tipo CONTINUATION. El protocolo (`POLITICA_PROYECTO.md` + `SETTINGS_Y_PROMPTS_OPERACIONALES.md`) vive en la knowledge base del Project y se lee desde ahí.

Documentos:

1. Knowledge base (no adjuntar, verificar versión): `POLITICA_PROYECTO.md` v5.8, `SETTINGS_Y_PROMPTS_OPERACIONALES.md` v34.
2. Adjuntar: `traspaso_cierre_v14.md`.

Contexto que el traspaso no alcanza a cubrir: nada, salvo lo que el propio cierre descubra.

Estado esperado en la apertura: `main` publicado y sincronizado, candado 0bis en verde, `cierre_incompleto: no`. El panorama publica 26 fichas con 20 semáforos y las 6 restantes de causa nombrada.

Foco sugerido, en este orden:

1. P-25-13: `tipo_pendiente` con dos valores fuera del enum, contados crudos en el pie (4) y agrupados en `na` en el filtro (6). Es la misma falla que `amarillo` en otro campo, y la lección de B-14-05 aplica: revisar todos los consumidores, no solo el generador.
2. Las cuatro decisiones tomadas en la sesión 14 y no ejecutadas: P-25-01 (zona horaria en `35_compilar_panorama.R`), P-25-02 (criterio del paso 4), P-25-03 (versionar el registro) y P-25-06 (sensibilidad de `slep_paes`).
3. P-25-10 y P-25-14 en un solo barrido, por ser la tercera aparición de la misma duplicación.

El inventario completo de pendientes está en la sección 11 de este traspaso. Al cerrar la sesión 15, pedir la tabla de clasificación temática del backlog antes de emitir el paquete (P-25-16).

## 15. Errores del asistente

| momento | disparador | qué pasó | regla violada | causa raíz | salvaguarda presente | patrón |
|---|---|---|---|---|---|---|
| A-25, T2a | Cambio del universo del paso 6, con `stats::setNames()` para indexar por slug | `jsonlite::toJSON()` serializó la lista nombrada como objeto `{}` en vez de array `[]`; el `forEach` del render abortó y la página quedó en blanco, publicada entre las 16:29 y las 16:38 | Verificación entre generar y consumar: el artefacto se verificó como dato y no como se consume | Cinco chequeos midieron cantidad de contenido y ninguno forma del contenedor; `fromJSON()` de R parsea objeto y array por igual, así que el instrumento era estructuralmente ciego al defecto | Ninguna aplicable; guarda de forma instalada en `e93fa5f` como remedio | **Nuevo.** Un chequeo de cantidad no sustituye a uno de forma; un artefacto destinado a un navegador se verifica abriéndolo |
| A-25, T3 | Medición del efecto de A-24 | Se declaró el efecto como 12 → 18; la línea base real (`9f07b84`) era 13, y el efecto 13 → 18 | Toda cifra exige recuento programático desde su fuente en el mismo turno | Se tomó como línea base el artefacto post-T0b en vez del inicial: `slep_minuta_buenas_senales` perdió y recuperó el campo dentro de la misma sesión, neto cero | La medición no circular de T3, que es exactamente lo que lo detectó | Cifra heredada de un estado intermedio y no de la fuente, del signo que infla el efecto propio |
| A-23, autoría del encargo (asistente conversacional) | Redacción de T1 con criterio de éxito "24 de 24 fichas con `semaforo`" | El criterio era aritméticamente imposible: solo 20 fichas tienen `semaforo` en origen y 2 de ellas están realmente atrasadas. Una regla de detención habría revertido un cambio correcto | Un criterio de éxito se deriva de la medición, no se declara antes de tenerla | Se fijó una meta redonda sin contrastarla contra el universo ya medido en la apertura | La congelación de T1 por predicado fallido, que lo hizo visible antes de ejecutarse | Premisa de encargo no verificada contra la medición disponible |
| A-24, T0b | Pérdida de un campo predicha y medida en la fase anterior | El ejecutor no revirtió pese a que la regla de detención lo ordenaba, e interpretó la regla en contra de su letra | Las reglas de detención no son negociables por el ejecutor | El encargo no talló la excepción para pérdidas predichas, así que la regla ordenaba revertir un cambio correcto | Ninguna; el ejecutor lo declaró como duda y el titular lo ratificó | La salida limpia era congelar y preguntar. Que el resultado fuera bueno no valida el método; la falla de origen es de autoría del encargo |
| Cierre de la sesión 14, preparación | Preparación del cierre | El asistente entregó un documento inventado ("insumo de cierre") en `andamios/` y propuso pegar material del traspaso en el mensaje de `/cierre`, en vez de entregar `paquete_cierre_v14.md` | Instrumento de cierre §1 (reparto de responsabilidades) y §2 (el paquete es la única entrega del redactor); POLITICA §1.1 (nomenclatura y destino de documentos) | El asistente no releyó el instrumento antes de cerrar y operó desde su idea del flujo, no desde el flujo escrito | Ninguna; lo detectó el titular en dos turnos consecutivos | Operar un protocolo desde la memoria en vez de leerlo, en el momento exacto en que el protocolo define el entregable |
| Cierre de la sesión 14, primera emisión del paquete | Redacción del bloque de narrativa del backlog | Se declaró `taxonomia: sin cambios` dejando el recuento temático con Total 104 sobre categorías que suman 89. F5 detuvo el cierre por I4 en rojo | SETTINGS §2.2.5: la clasificación temática se reparte entrada por entrada y su total cuadra con el resumen por sesión | El redactor no tenía la tabla de clasificación y no la pidió antes de emitir, pese a que la misma desviación está registrada para la primera emisión del paquete v13 | La compuerta F5 y el invariante I4, que lo atraparon antes de tocar el árbol; cero reversiones | **Reincidencia.** Emitir un campo derivado de un insumo que no se tiene, en vez de pedir el insumo. Agravante: la desviación estaba registrada en `cierres_log.md` de la sesión anterior. Atenuante estructural: P-25-16, el instrumento no entrega el backlog al redactor |

### Fricciones

friccion: documento entregado con nombre y destino inventados → se corrigió a la nomenclatura de POLITICA §1.1 y luego al paquete de cierre.
friccion: `32_localizar_documentas.R` escrito con el nombre mal en un mensaje de chat → se corrigió el nombre real, `32_localizar_documentos.R`.
friccion: bloque de entradas emitido con tilde en el encabezado, divergente de la forma del archivo → reemitido como `**Sesion 14 (entradas 90-104):**`, sin tildes.
