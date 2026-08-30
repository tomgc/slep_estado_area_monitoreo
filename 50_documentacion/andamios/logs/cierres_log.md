## v12 — 2026-08-26

**Instrumento:** `cierre_sesion_autonomo_cc_v11.md`. **Paquete:** `paquete_cierre_v12.md`
(distribuido y eliminado en F8). **Sesion:** 12. **Tramo:** 68→77.

### Fases

| Fase | Resultado |
|---|---|
| F0 | Pasa con un levantamiento explicito del titular (ver Desviaciones). |
| F1 | Copia de trabajo en `mktemp -d`; F2-F5 ejecutados ahi. |
| F2 | Tres inserciones por posicion estructural, sin anclaje a cadena. |
| F3 | Cero disparos genuinos; catalogo aplicable inexistente (log ausente). |
| F4 | I1-I7 verdes tras resolver el campo `commit_cierre` (ver Desviaciones). |
| F5 | Compuerta pasada. |
| F6 | Escaner FALLIDO (ver Desviaciones); archivado de 11 traspasos; copia de destinos. |
| F7 | Commit de documentacion `acdc6ff`. |
| F8 | Distribucion verificada byte a byte; vehiculo eliminado. |
| F9 | Log, commit del log + ESTADO.md, push conjunto. |

### Disparos por rotulo del catalogo (seccion 5 del instrumento)

**catalogo aplicable: sin historia previa** (`cierres_log.md` no existia; este cierre lo funda).

| ID | Disparos |
|---|---|
| R1–R12 | 0 |

`catalogo no aplicable: R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12 (12 de 12)`

Dos coincidencias textuales se descartaron por inspeccion: R2 engancho con "El tramo
55-61" del delta recien insertado (no es un mapa de tramos) y R12 con "umbral de 2%"
en la prosa preexistente del delta (cita de SETTINGS §2.2.5, no un recuento tematico).
**Consecuencia para el cierre siguiente:** el catalogo aplicable seguira vacio, asi que
la regla 7.3 no podra detener sobre este archivo hasta que algun rotulo dispare.

### Cifras sin rotulo (zonas declarativas, excluido el Detalle cronologico)

| Cifra | Donde | Resolucion |
|---|---|---|
| 67 | Delta: "que llego a la 67" | (a) candidata a rotulo nuevo, gobernada por `backlog_total_previo` |
| 68-77 | Delta: "10 entradas nuevas (68-77)" | (a) candidata a rotulo nuevo, gobernada por `backlog_tramo` |
| 10 | Delta: "10 entradas nuevas" | (a) candidata a rotulo nuevo, gobernada por `backlog_entradas_nuevas` |
| 55-61 | Nota del hueco y delta | (b) cifra historica legitima: el tramo perdido es fijo |
| 3,6,2,5,4,8,7,8,5,5,2,3,1 | Clasificacion tematica | (c) el archivo se contradice: la tabla suma 59 y cubre solo hasta la entrada 54; no se actualizo para 62-77. No la corrige este cierre porque no es una de las tres inserciones de F2 |
| 20, 25 | Delta, campo `lectura` | (b) cifra historica del censo de la sesion 12 |

La primera aparicion de las tres candidatas (a) funda su registro: si reaparecen en el
cierre v13 sin rotulo asignado, son rotulos faltantes y no coincidencia.

### Invariantes

| # | Resultado | Evidencia |
|---|---|---|
| I1 | VERDE | 70 numeros en el Detalle: 1-54 mas 62-77, `diff` contra la serie esperada vacio, `uniq -d` vacio |
| I2 | VERDE | Suma de la columna Cambios = 77 = `backlog_total_nuevo` (67+10) |
| I3 | VERDE | Filas de sesion 11 → 12 |
| I4 | VERDE | Unica aparicion de magnitud previa: la cabecera `**Sesion 11 (entradas 62-67…)**`, contexto historico legitimo |
| I5 | AMARILLO | El campo `taxonomia` declara "Las diez entradas", una autorreferencia de cifra. Coincide con `backlog_entradas_nuevas: 10`, asi que no esta stale; se declara en vez de editarse porque es texto de autoria |
| I6 | VERDE | RUT 0, rutas `/Users/` 0, credenciales 0, coautoria de la herramienta 0, placeholders 0 en los tres destinos |
| I7 | VERDE | 11 traspasos a `traspasos/archivo/`; exactamente 1 vigente (`traspaso_cierre_v12.md`) |

### Desviaciones

1. **F0.7 levantada por decision explicita del titular.** `backlog_acumulativo.md` llego
   sucio al cierre (trabajo del encargo A-02, que el titular ordeno no commitear). No se
   podia limpiar sin romper F0.5: `backlog_total_previo: 67` solo es cierto de ese arbol,
   porque en `HEAD` el backlog terminaba en 54. F0.7 y F0.5 eran incumplibles a la vez.
   El titular opto por levantar F0.7 y que F7 absorbiera la modificacion, que es lo que
   F7 hace por diseno (el backlog esta en su `git add` selectivo).
2. **La tercera insercion de F2 se hizo como prosa, no como fila.** La seccion
   `## Delta del backlog` no tiene ninguna fila que empiece por `|`, asi que "final de
   la tabla" no tenia referente. Por decision del titular se anexo un bloque de prosa con
   `foco`, `taxonomia` y `lectura`, respetando la forma que la seccion tiene desde su
   creacion. Convertirla en tabla habria exigido reescribir registro historico cerrado
   (POLITICA §10).
3. **`commit_cierre` lleva el hash de F7, no el de F9, y `ESTADO.md` viaja en el commit
   del log.** El instrumento (F10) exige el hash del commit de log, pero F7 commitea
   `ESTADO.md` antes de que ese commit exista: ningun archivo puede contener el hash de
   un commit posterior. Es la misma imposibilidad que el propio instrumento reconoce para
   el log. Por decision del titular el valor es el hash de F7; para que ningun commit
   llegara a contener el marcador `ESCRIBE_EJECUTOR`, `ESTADO.md` se excluyo de F7 y se
   commitea aqui junto al log. F9 commitea por tanto dos rutas, no una.
   **El instrumento necesita enmienda en este punto:** tal como esta redactado, F10 pide
   un valor que su propio orden de fases hace inalcanzable.
4. **El escaner no corrio (`sello_escaner: regenerar` incumplido).** `Rscript
   00_escanear_proyecto.R` aborto: el merge del tramo B trajo `.Rprofile` con
   `renv/activate.R` y el lockfile de 38 paquetes, pero la biblioteca del proyecto esta
   vacia, asi que `renv` hizo bootstrap y luego fallo con "no hay paquete llamado
   'rprojroot'". No se ejecuto `renv::restore()` porque el encargo del tramo B lo
   prohibe expresamente y su costo es del titular. El bootstrap no dejo residuo
   versionado (`renv/library/` esta en `renv/.gitignore`). Las salidas de
   `50_documentacion/estructura/` quedan como las dejo el merge y no entran en F7.
5. **La fila del resumen se inserto antes de la fila `**Total**`, no al final literal de
   la tabla.** "Final de la tabla" segun F2 seria despues del Total, lo que romperia la
   tabla. Se recalculo el Total de 67 a 77.
6. **El bloque BACKLOG_ENTRADAS no traia encabezado de sesion.** Se compuso
   `**Sesion 12 (entradas 68-77):**` siguiendo la convencion del archivo, donde todas
   las entradas viven bajo una cabecera de esa forma.

### Sucios preexistentes ajenos al cierre

Ninguno. Al entrar a F0 el arbol solo tenia `M backlog_acumulativo.md` (materia del
cierre, ver desviacion 1) y `?? paquete_cierre_v12.md` (el vehiculo). El descuento que
F10 aplica a su predicado es, por tanto, vacio.

### Estado del push

`push_autorizado: si`. **Por publicar** en el push conjunto del final de esta fase:
commit de documentacion `acdc6ff` y el commit de log de este mismo cierre. Viaja tambien
`2ac0c78` (`docs(sesion-12): encargos, censo y ruta del comando unico`), que estaba sin
publicar desde antes del cierre.

**Hash de documentacion (F7):** `acdc6ff`. El hash del commit de log no puede vivir en el
log; queda en el eco de F10 y en git.

---

## v13 — 2026-08-27

**Instrumento:** `cierre_sesion_autonomo_cc_v11.md`. **Paquete:** `paquete_cierre_v13.md`
(segunda emision; distribuido y eliminado en F8). **Sesion:** 13. **Tramo:** 78→89.

### Fases

| Fase | Resultado |
|---|---|
| F0 | Pasa entera, sin levantamientos. |
| F1 | Copia de trabajo en `mktemp -d`; F2-F5 ejecutados ahi. |
| F2 | Tres inserciones por posicion estructural; los cuatro encabezados usados aparecen exactamente una vez. |
| F3 | R12 dispara 1 vez y se aplica; catalogo aplicable vacio (v12 no dejo ninguno). |
| F4 | I1-I4, I6, I7 verdes; I5 amarillo declarado. |
| F5 | Compuerta pasada. |
| F6 | Escaner OK (snapshot `20260827_095403`, poda de 1 sello); `git mv` de `traspaso_cierre_v12.md` a `archivo/`; copia de los tres destinos. |
| F7 | Commit de documentacion `8213560`. |
| F8 | Distribucion verificada byte a byte en los tres bloques; vehiculo eliminado. |
| F9 | Log, commit del log y push conjunto de los dos commits. |

### Disparos por rotulo del catalogo (seccion 5 del instrumento)

**catalogo aplicable: vacio** (la seccion v12 registra R1-R12 con cero disparos, y la
regla 7.3 solo detiene sobre rotulos que dispararon en el cierre anterior). Ningun cero
de hoy puede detener, por construccion.

| ID | Disparos |
|---|---|
| R12 | 1 (primera vez que dispara en este archivo) |
| R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11 | 0 |

`catalogo no aplicable: R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11 (11 de 12)`

**R12, texto resultante:** `| **Total** | **89** | Cuadra con el total del resumen por
sesion. |`. Aplicarlo obligo ademas a reescribir la columna `N` completa de la
`Clasificacion tematica`, que no es una de las tres inserciones de F2: sin eso el Total
habria contradicho la suma de sus propias categorias. La asignacion entrada por entrada
es autoria (campo `taxonomia` del paquete); el ejecutor solo la transcribio y verifico
que suma 89.

**Consecuencia para el cierre siguiente:** el catalogo aplicable pasa a ser **{R12}**. Un
cierre v14 en que R12 no dispare detiene por la regla 7.3.

Una coincidencia textual se descarto por inspeccion, la misma que v12: "umbral de 2%" en
la prosa preexistente del delta es una cita de SETTINGS 2.2.5, no un recuento tematico.

### Cifras sin rotulo (zonas declarativas, excluido el Detalle cronologico)

| Cifra | Donde | Resolucion |
|---|---|---|
| 70 | `**Cobertura (s13).**` — "se re-derivo entrada por entrada sobre las 70 presentes" | (a) candidata a rotulo nuevo **R13**, magnitud `backlog_total_nuevo` menos perdidas (hoy 82). No se edito: es prosa de autoria que describe una accion fechada. Segunda aparicion sin resolver la convierte en rotulo faltante |
| 59, 54, 5 | Misma nota, correccion del sobreconteo previo | (b) cifras historicas fechadas de un tramo cerrado |
| 67 / 68-77 / 10 | Delta de v12, las tres candidatas (a) que dejo abiertas aquel cierre | **(b) historicas legitimas.** Cada bloque del Delta es un registro por sesion: se escribe una vez, describe su propia sesion y no envejece. Reaparecen como texto nuevo del tramo 78-89, no como supervivientes stale. Quedan cerradas y no vuelven a listarse |

### Invariantes

| # | Resultado | Evidencia |
|---|---|---|
| I1 | VERDE | 82 numeros en el Detalle: 1-54 mas 62-89. `diff` contra la serie esperada vacio; `uniq -d` vacio. El hueco 55-61 es la perdida declarada y permanente |
| I2 | VERDE | Suma de la columna Cambios = 18+6+8+13+8+1+0+2+2+3+6+10+12 = 89 = `backlog_total_nuevo` (77+12) |
| I3 | VERDE | Filas de sesion 12 → 13 |
| I4 | VERDE | Ver clasificacion abajo |
| I5 | AMARILLO | El campo `taxonomia` declara "Las doce entradas nuevas", autorreferencia de cifra. Coincide con `backlog_entradas_nuevas: 12`, asi que no esta stale; se declara en vez de editarse porque es texto de autoria. Mismo caso que v12 |
| I6 | VERDE | RUT 0, `/Users/` 0, credenciales 0, coautoria de la herramienta 0, placeholders 0, en los tres destinos y en las salidas del escaner |
| I7 | VERDE | `traspasos/` queda con exactamente 1 vigente (`traspaso_cierre_v13.md`); 12 en `traspasos/archivo/` |

### I4 — apariciones clasificadas

| Linea | Aparicion | Clasificacion |
|---|---|---|
| 256 | `**Sesion 12 (entradas 68-77):**` | Historica legitima: cabecera de un tramo cerrado |
| 301 | `77. Reconstruccion parcial del backlog...` | Historica legitima: el numero de la propia entrada |
| 350 | `10 entradas nuevas (68-77) respecto al estado...` | Historica legitima: bloque del delta de v12 |
| 367 | `` `traspaso_cierre_v12.md` (que llego a la 77) `` | Historica legitima: referencia hacia atras escrita por el ejecutor en el delta nuevo |

**No queda ninguna aparicion viva de `backlog_total_previo`.** La unica que habia —el
Total de la `Clasificacion tematica`— es la que R12 llevo a 89. `70` aparece en la nota de
cobertura y se declara arriba como cifra sin rotulo, no como magnitud de I4: no es
`backlog_total_previo`, ni el numero de sesion anterior, ni el recuento de filas anterior.

### Desviaciones

1. **La primera emision del paquete se detuvo en F5 con I4 en rojo.** La `Clasificacion
   tematica` sumaba 77 y su fila de cierre afirma "Cuadra con el total del resumen por
   sesion", que el cierre llevaba a 89. Aplicar R12 solo habria dejado el Total
   contradiciendo la suma de sus categorias; no aplicarlo habria dejado
   `backlog_total_previo` vivo. Cuadrarla exigia repartir las 12 entradas nuevas entre
   categorias, y el paquete traia `taxonomia: Sin cambios`, que no podia ser cierto. La
   segunda emision trae la asignacion entrada por entrada y el rojo desaparece sin que el
   ejecutor interprete nada. **Costo: una reemision del paquete, cero reversiones del
   arbol** (F6 nunca corrio en el primer intento).
2. **El escaner corre antes de los `git mv` y de las copias**, que es el orden que F6
   prescribe. Consecuencia: el snapshot `20260827_095403` no muestra
   `traspaso_cierre_v13.md` ni el archivado de v12. No se re-ejecuto porque el orden es
   del instrumento y una segunda corrida podaria otro sello.
3. **`commit_cierre: 88394ad` es el `main` previo al cierre**, ni el hash de F7 ni el de
   F9. Es la misma imposibilidad que v12 declaro en su desviacion 3: ningun archivo
   commiteado puede contener el hash de su propio commit ni el de uno posterior. El valor
   correcto segun F10 —el hash del commit de log— va en el eco y en git.
4. **La fila del resumen se inserto antes de la fila `**Total**`**, no al final literal de
   la tabla, y el Total se recalculo de 77 a 89 (82 conservadas, 7 perdidas). Misma
   desviacion 5 de v12.
5. **La tercera insercion es prosa, no fila.** `## Delta del backlog` no tiene ninguna fila
   que empiece por `|`; se anexo un bloque en la forma que la seccion tiene desde su
   creacion. Misma desviacion 2 de v12.
6. **La columna `Modelo` de la fila del resumen dice "Opus 5"**, grafia de la fila
   anterior. El front matter no declara el modelo, asi que es el unico campo de la fila
   que no sale ni de las magnitudes ni de `BACKLOG_NARRATIVA`.
7. **Artefacto preexistente en el Detalle cronologico.** La linea `0304334. [codigo]`
   (continuacion envuelta de la entrada 75, donde el hash de un commit quedo a inicio de
   linea) es indistinguible de una entrada numerada para cualquier chequeo de I1. Se
   excluyo a mano. No se corrige aqui: es registro historico y POLITICA 10 prohibe
   reescribirlo.
8. **R13 propuesto y no incorporado al catalogo.** La seccion 5 del instrumento manda
   agregarlo "en el mismo turno", pero el instrumento vive en `herramientas_dev`, otro
   repositorio, y este cierre esta acotado al repo del directorio de trabajo. Queda
   declarado aqui con su ID y su magnitud para que no se pierda.

### Sucios preexistentes ajenos al cierre

Ninguno. Al entrar a F0 el arbol solo tenia `?? paquete_cierre_v13.md`, que es el
vehiculo. **El descuento que F10 aplica a su predicado es, por tanto, vacio: `git status
--porcelain` debe quedar completamente vacio.**

### Estado del push

`push_autorizado: si`. **Por publicar** en el push conjunto del final de esta fase: el
commit de documentacion `8213560` y el commit de log de este mismo cierre.

**Hash de documentacion (F7):** `8213560`. El hash del commit de log no puede vivir en el
log; queda en el eco de F10 y en git.

## v14 — 2026-08-27

**Instrumento:** `cierre_sesion_autonomo_cc_v11.md`. **Paquete:** `paquete_cierre_v14.md`
(segunda emision; distribuido y eliminado en F8). **Sesion:** 14. **Tramo:** 90→104.
**Ejecutado el:** 2026-08-30 (el `fecha_cierre` del paquete es 2026-08-27).

### Fases

| Fase | Resultado |
|---|---|
| F0 | Pasa entera en la segunda emision. Correlativo triple v14; magnitudes contra disco (previo 89, 15 entradas, 90→104 contiguas); `settings_version` identica a la linea 3 real de SETTINGS v34; `compuerta_dudas: 4 registradas` con las cuatro entradas C-14-1..4 y sus tres campos; arbol limpio en lo que el cierre escribe. |
| F1 | Copia de trabajo en `mktemp -d`; F2-F5 ejecutados ahi. |
| F2 | Tres inserciones por posicion estructural; los cuatro encabezados usados aparecen exactamente una vez. |
| F3 | R12 dispara 1 vez y se aplica; catalogo aplicable {R12} satisfecho. |
| F4 | I1-I4, I6, I7 verdes; I5 amarillo declarado. |
| F5 | Compuerta pasada. |
| F6 | Escaner OK (snapshot `20260830_010532`, poda de 2 sellos, 2 conservados); `git mv` de `traspaso_cierre_v13.md` a `archivo/`; copia de los tres destinos. |
| F7 | Commit de documentacion `ee51e60`. |
| F8 | Distribucion verificada en los tres bloques (traspaso y ESTADO byte a byte por `diff`; bloque de entradas presente literal, 2792 bytes); vehiculo eliminado. |
| F9 | Log, commit del log y push conjunto de los dos commits. |

### Disparos por rotulo del catalogo (seccion 5 del instrumento)

**catalogo aplicable: {R12}**, extraido de la tabla de rotulos de la seccion v13.
R12 disparo y se aplico, asi que la regla 7.3 no detiene.

| ID | Disparos |
|---|---|
| R12 | 1 |
| R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11 | 0 |

`catalogo no aplicable: R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11 (11 de 12)`

**R12, texto resultante:** `| **Total** | **104** | Cuadra con el total del resumen por
sesion. |`. Como en v13, aplicarlo obligo a reescribir la columna `N` completa de la
`Clasificacion tematica`, que no es una de las tres inserciones de F2. El reparto entrada
por entrada viene del campo `taxonomia` del paquete (autoria); el ejecutor solo lo
transcribio y verifico tres cosas: que las 15 categorias declaradas son exactamente las 15
de la tabla, que las 15 entradas nuevas se reparten sin duplicados ni omisiones, y que la
columna suma 104. Siete celdas cambian: Andamiaje/estructura 7→8, Pipeline determinista
6→7, Utilidades/gobernanza por codigo 3→4, Robustez/bugfix 9→17, Estandarizacion de
cartera 12→13, Informe visual (P4) 5→7, Cierre de deuda menor 3→4.

Una coincidencia textual se descarto por inspeccion: `"Ultima actualizacion"` en la entrada
46 del Detalle cronologico es el nombre de una cadena hardcodeada del panorama citada
dentro de una entrada, no un puntero de mantenimiento (R11).

**Consecuencia para el cierre siguiente:** el catalogo aplicable sigue siendo **{R12}**.

### Cifras sin rotulo (zonas declarativas, excluido el Detalle cronologico)

| Cifra | Donde | Resolucion |
|---|---|---|
| 70 | `**Cobertura (s13).**` — "se re-derivo entrada por entrada sobre las 70 presentes" | (a) **segunda aparicion sin resolver**: por la regla de F3 deja de ser coincidencia y es un rotulo faltante. Es el R13 que v13 propuso. Con total 104 y 7 perdidas el valor derivado seria 97, no 70. No se edita: es prosa fechada de autoria, y el catalogo vive en `herramientas_dev`. Queda con pendiente propio en el traspaso (P-25-16 para la causa, R13 para el rotulo) |
| bloques del Delta (48-54, 68-77, 78-89 y sus cifras) | Seccion `## Delta del backlog` | (b) historicas legitimas. Cerradas en v13 y no se vuelven a listar |
| 5, 6, 10, 2 | Encabezado del archivo: referencias a `§10`, `§2.2.5`, sesiones 5 y 6 de su propia historia de extraccion | (b) historicas legitimas: prosa fechada sobre tramos cerrados |

### Invariantes

| # | Resultado | Evidencia |
|---|---|---|
| I1 | VERDE | 97 numeros en el Detalle: 1-54 mas 62-104. Serie identica a la esperada, `duplicados` vacio, `faltan` vacio, `sobran` vacio. El hueco 55-61 es la perdida declarada y permanente |
| I2 | VERDE | Suma de la columna Cambios = 104 = `backlog_total_nuevo` (89+15). Ademas la `Clasificacion tematica` suma 104 sobre sus 15 categorias, que es la cuadratura que la primera emision no podia dar |
| I3 | VERDE | Filas de sesion 13 → 14 |
| I4 | VERDE | Ver clasificacion abajo. Ninguna aparicion viva de `backlog_total_previo` |
| I5 | AMARILLO | Los campos `taxonomia` y `lectura` declaran cifras derivadas ("15 entradas nuevas", "Las quince", "Total 104", "de 9 a 17"). Se verificaron todas contra lo computado y ninguna esta stale: 15 = `backlog_entradas_nuevas`, 104 = suma de la columna N, y Robustez/bugfix = 17 es en efecto el maximo de la tabla. Se declara en vez de editarse porque es texto de autoria. Mismo caso que v12 y v13 |
| I6 | VERDE | RUT 0, `/Users/` 0, credenciales 0, coautoria de la herramienta 0, placeholders 0, en los tres destinos |
| I7 | VERDE | `traspasos/` queda con exactamente 1 vigente (`traspaso_cierre_v14.md`); 13 en `traspasos/archivo/` |

### I4 — apariciones clasificadas

| Linea | Aparicion | Clasificacion |
|---|---|---|
| 92 | `\| 13 \| v13 \| 12 \| Opus 5 \| ...` | Historica legitima: fila de resumen de una sesion cerrada |
| 309 | `**Sesion 13 (entradas 78-89):**` | Historica legitima: cabecera de un tramo cerrado |
| 399 | `12 entradas nuevas (78-89) respecto al estado...` | Historica legitima: bloque del delta de v13 |
| 405 | `menor 89; Rescate e integracion del repositorio 79.` | Historica legitima: numero de entrada dentro del reparto tematico de v13 |
| 413 | `` `traspaso_cierre_v13.md` (que llego a la 89) `` | Historica legitima: referencia hacia atras del bloque del delta nuevo |

El `89` que si era magnitud viva —el Total de la `Clasificacion tematica`— es el que R12
llevo a 104, y esta vez la columna que lo sostiene tambien llego a 104.

### Desviaciones

1. **La primera emision del paquete se detuvo en F5, reincidencia de la desviacion 1 de
   v13.** Traia `taxonomia: sin cambios`, que no puede ser cierto: aplicar R12 dejaba el
   Total en 104 sobre categorias que suman 89, y no aplicarlo dejaba `backlog_total_previo`
   vivo y a R12 con cero disparos, que detiene por la regla 7.3. Repartir las 15 entradas
   es autoria y el ejecutor no la suple. La segunda emision trae el reparto entrada por
   entrada y la columna N completa. **Costo: una reemision del paquete, cero reversiones
   del arbol** (F6 nunca corrio en el primer intento). Causa estructural declarada por el
   propio traspaso como P-25-16: el redactor no recibe el backlog y por eso no puede
   derivar `taxonomia` en la primera vuelta.
2. **Divergencia de forma corregida entre emisiones.** La primera traia el bloque como
   `### Sesión 14 (2026-08-27)`, con tilde y nivel de encabezado, contra la forma del
   archivo (`**Sesion N (entradas X-Y):**`, sin tildes). F8 exige distribucion byte a byte,
   asi que el ejecutor no podia normalizarlo; la segunda emision llego ya en la forma del
   archivo y la friccion quedo registrada en el traspaso.
3. **El escaner corre antes de los `git mv` y de las copias**, que es el orden que F6
   prescribe. Consecuencia: el snapshot `20260830_010532` no muestra
   `traspaso_cierre_v14.md` ni el archivado de v13. No se re-ejecuto porque el orden es del
   instrumento y una segunda corrida podaria otro sello.
4. **El cierre se ejecuto el 2026-08-30 y el paquete declara `fecha_cierre: 2026-08-27`.**
   La discrepancia es real y se conserva: la fecha del paquete es la de la sesion que se
   cierra, y el sello del escaner es el de la corrida. No hay rotulo del catalogo gobernado
   por `fecha_cierre` que dispare en este archivo (R2 y R11 dan cero), asi que la
   discrepancia no propaga a ninguna afirmacion del backlog.
5. **`commit_cierre: e93fa5f` es el `main` previo al cierre**, ni el hash de F7 ni el de
   F9. Misma imposibilidad declarada en v12 y v13: ningun archivo commiteado puede contener
   el hash de su propio commit ni el de uno posterior. El valor correcto segun F10 —el hash
   del commit de log— va en el eco y en git.
6. **La fila del resumen se inserto antes de la fila `**Total**`**, no al final literal de
   la tabla, y el Total se recalculo de 89 a 104 (97 conservadas, 7 perdidas). Misma
   desviacion de v12 y v13.
7. **La tercera insercion es prosa, no fila.** `## Delta del backlog` no tiene ninguna fila
   que empiece por `|`; se anexo un bloque en la forma que la seccion tiene desde su
   creacion, compuesto con los campos `taxonomia` y `lectura`. Misma desviacion de v12 y v13.
8. **La columna `Modelo` de la fila del resumen dice "Opus 5"**, grafia de la fila anterior.
   El front matter no declara el modelo, asi que es el unico campo de la fila que no sale ni
   de las magnitudes ni de `BACKLOG_NARRATIVA`.
9. **Artefacto preexistente en el Detalle cronologico.** La linea `0304334. [codigo]`
   (continuacion envuelta de la entrada 75) es indistinguible de una entrada numerada para
   cualquier chequeo de I1. Se excluyo a mano. No se corrige aqui: es registro historico y
   POLITICA 10 prohibe reescribirlo. Misma desviacion 7 de v13.
10. **R13 sigue propuesto y no incorporado al catalogo**, tercera sesion consecutiva. El
    instrumento vive en `herramientas_dev` y este cierre esta acotado al repo del directorio
    de trabajo. La novedad de este cierre es que la cifra que lo motiva (`70`) cumplio su
    segunda aparicion sin resolver, que por la regla de F3 la convierte en rotulo faltante y
    no en coincidencia.

### Sucios preexistentes ajenos al cierre

Cuatro archivos sin seguimiento, depositados por los encargos de la sesion y ajenos a lo
que el cierre escribe. **No se commitean** y son el descuento exacto que F10 aplica a su
predicado:

- `50_documentacion/andamios/20260827_encargo_ruta_v14b.md`
- `50_documentacion/andamios/20260827_encargo_universo_v14c.md`
- `50_documentacion/andamios/logs/20260827_ruta_v14b_log.md`
- `50_documentacion/andamios/logs/20260827_universo_v14c_log.md`

### Estado del push

`push_autorizado: si`. **Por publicar** en el push conjunto del final de esta fase: el
commit de documentacion `ee51e60` y el commit de log de este mismo cierre.

**Hash de documentacion (F7):** `ee51e60`. El hash del commit de log no puede vivir en el
log; queda en el eco de F10 y en git.
