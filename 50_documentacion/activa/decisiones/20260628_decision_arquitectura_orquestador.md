# Decision - Arquitectura del orquestador de cartera (sesion 1)

Fecha: 2026-06-28. Tipo: NEW PROJECT, Rama A. Autor: Area de Monitoreo y
Seguimiento de Procesos y Resultados Educativos.

## D1 - Paso `35_compilar_panorama.R` separado (no logica en `00_run_all.R`)

**Decision.** El pipeline tiene cinco pasos `31->35`, no cuatro. El encargo
describia `31->34` y que `00_run_all.R` "corre 31->34 y compila panorama". Se
agrego un quinto script `35_compilar_panorama.R` para el ensamblado del
panorama.

**Alternativas.** (a) Compilar el panorama dentro de `00_run_all.R`:
descartada porque POLITICA 4 exige que el orquestador solo orqueste, sin logica
de negocio. (b) Compilar el panorama dentro de `34_compilar_inventario.R`:
descartada por responsabilidad unica (34 produce hechos deterministas; 35
mezcla hechos con prosa de cache). (c) Script `35` dedicado: elegida.

**Justificacion.** Mantiene `00_run_all.R` limpio, respeta decenas/correlativos
(31-35 sin huecos) y separa el inventario byte-estable (34) del panorama
(35), que por diseno NO es byte-estable (incluye fecha de generacion y "hace N
dias"). Consistente con la frase del encargo "corre 31->34 y compila panorama":
35 ES la compilacion del panorama.

## D2 - Division determinista vs. sintesis, y el sello de frescura

**Decision.** 31-34 producen hechos verificables (cero interpretacion). La
prosa de estado (fichas L2) la redacta el agente en `40_salidas/cache/<slug>.md`
con un front matter-sello (`sello_hash` = md5 del traspaso vigente, `semaforo`,
`proximo_paso`). 35 ensambla el panorama: tabla L1 y alertas desde el
inventario; fichas L2 desde el cache. Si `sello_hash` del cache != md5 del
traspaso en el inventario, 35 marca el proyecto como "pendiente de sintesis"
(la ficha igual se muestra, etiquetada).

**Implicancia.** Dos idempotencias distintas: la determinista (31-34) la
garantiza el codigo y es byte-estable; la de sintesis es disciplina del agente
(reutilizar el cache literal mientras el sello no cambie, re-redactar solo los
proyectos con sello nuevo).

## D3 - Confinamiento de escritura por codigo (`escribir_seguro`)

**Decision.** Toda escritura pasa por `escribir_seguro()` (10_utils.R), que
valida via `normalizePath` del directorio destino que la ruta cuelgue de
`RAIZ_ORQUESTADOR` y aborta con `stop()` si no. Cierra R1 por codigo, no por
disciplina. Probado en `tests/test_orquestador.R`.

## D4 - Resolucion de `slep_minuta_asistencia`: la grafia CONTEXTO es historica

**Decision.** El traspaso vigente se resuelve por maximo correlativo entero
(regex `(?i)v0*(\d+)`, dedup por entero). En `slep_minuta_asistencia` esto da
`traspaso-cierre-v64`, no un `CONTEXTO_VNN`: las grafias no coexisten en el mismo
correlativo sino en secuencia (CONTEXTO v10-v35, traspaso-cierre v36-v64). La
expectativa previa de que CONTEXTO fuera el vigente queda corregida por el dato
real; la regla determinista, endosada por el titular, produce el resultado
correcto. Registrado como caso esperado en el reporte de cobertura (C2).

## D5 - Exclusion de `*.git` del universo

**Decision.** El descubrimiento excluye por patron (`PATRON_EXCLUIR_UNIVERSO =
"\\.git$"`) las entradas que matchean `slep_*` pero son respaldos bare de git
(p. ej. `slep_repo_backup_YYYYMMDD.git`). Es un filtro por patron, no una lista
hardcodeada de proyectos. La funcion `descubrir_hermanos()` (10_configuracion.R)
es la fuente unica del universo para 31 y para la validacion.

## D6 - E/S de CSV con `readr` (UTF-8 robusto frente al locale C)

**Decision.** El registro se lee y escribe con `readr::read_csv` /
`readr::write_csv`. `utils::write.csv` en un locale `C` (el de esta maquina)
escapa los acentos como `<U+00F3>`, corrompiendo `nombre_real` (ó, í, ñ) que el
titular edita a mano. `readr` escribe bytes UTF-8 independiente del locale.
Analogamente, las salidas de texto del panorama y el escaner se escriben con
`writeLines(..., useBytes = TRUE)` y se evita concatenar literales no-ASCII con
datos acentuados via `sprintf` (separadores ASCII en estructura).

## D7 - Saneamiento de rutas en salidas (R3)

**Decision.** Ninguna salida (`inventario_cartera.*`, `panorama.md`, cache)
contiene rutas absolutas con `/Users/<nombre>/`. Las rutas a documentos de los
hermanos se almacenan relativas a `RAIZ_PROYECTOS` (`relativizar()` en 34).
