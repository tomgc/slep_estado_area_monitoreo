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
