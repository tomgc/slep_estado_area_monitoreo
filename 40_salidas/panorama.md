# Panorama de la cartera - Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos

> Generado: 2026-08-27 · Proyectos activos: 24 · Auxiliares: 2

## Alertas

- **Bloqueados:** ninguno.
- **Nuevos detectados:** ninguno.
- **Dados de baja:** slep_georreferenciacion.
- **Documentacion obsoleta (>21 dias):** slep_alertas_ael, slep_dashboard_personal_monitoreo.
- **Pendientes de sintesis:** slep_idps, slep_minuta_desvinculacion, slep_minuta_matricula, slep_paes, slep_territorio_costa_central.

## L1 - Tabla semaforo

| Codigo | Nombre | Semaforo | Ultima actividad | Proximo paso |
|---|---|---|---|---|
| slep_alertas_ael | Sistema de alertas de Anótate en la Lista | activo | 2026-06-10 (hace 78 dias) | Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos, ya que se generó en macOS (donde Aptos no viene preinstalada) y officer degrada en silencio. |
| slep_aprendizajes_ep | Monitoreo de aprendizajes en la educación parvularia | activo | 2026-08-24 (hace 3 dias) | Sembrar el root de verificación para cerrar la acreditación pendiente, abrir la PR y autorizar el merge, para poder correr por primera vez el pipeline completo sobre datos reales. |
| slep_categoria_desempeno | Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país | activo | 2026-08-24 (hace 3 dias) | Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito y los hashes anteriores dejaron de existir (acción manual del titular, una sola vez). |
| slep_costapresente | CostaPresente | activo | 2026-08-24 (hace 3 dias) | Validar el pipeline completo (ETL + app) en una maquina Windows: configurar entorno, verificar la ruta de datos institucional y correr end-to-end con el mismo output que en macOS. |
| slep_dashboard_personal_monitoreo | Dashboard personal de monitoreo | activo | 2026-05-26 (hace 93 dias) | Ejecutar la migracion estructural completa del repo a la convencion canonica (00_, 10_utils/, 20_insumos/, 30_procesamiento/, 40_salidas/, 50_documentacion/) siguiendo el protocolo de 7 pasos, como foco unico de la sesion. |
| slep_estudio_oferta_demanda | slep_estudio_oferta_demanda | activo | 2026-08-24 (hace 3 dias) | Confirmar push de los commits locales, luego evaluar iniciar el alcance ampliado de `40_` (matrícula regional per-mrun) para cerrar el 15,7% de transiciones "sin registro observable" con desfase entre bases documentado. |
| slep_gestion_solicitudes_compras | slep_gestion_solicitudes_compras | activo | 2026-08-21 (hace 6 dias) | Resolver P88: la huella de insumos mide el primer nivel de 20_insumos/ del data root, que solo contiene auxiliares y respaldos, mientras las 97 carpetas de establecimientos viven fuera de esa ventana. |
| slep_idps | Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) | activo | 2026-08-24 (hace 3 dias) | higiene de backlog y limpieza CSS pendientes en sesion 26 |
| slep_lectoescritura | slep_lectoescritura | activo | 2026-08-24 (hace 3 dias) | El fix del bug destapo un problema de modelo: el reporte publica una "cobertura SIMCE" que no deberia existir. SIMCE (y PAES) se aplican de forma externa y censal por la Agencia; su cobertura es 100% por construccion y el SLEP no la controla. Hay que decidir si los instrumentos externos salen del modelo tripartito y que estado reemplaza a la cobertura para ellos (las celdas afectadas son establecimientos que SI rindieron y cuyo resultado la Agencia no publico). Toca el invariante tripartito y la decision 20260708_decision_modelo_fuentes.md. |
| slep_minuta_asistencia | Minuta de asistencia mensual | activo | 2026-08-22 (hace 5 dias) | Resolver la validación parcial del cartograma, que emite 3 de 4 comprobaciones porque no recibe `maestro_ee` y por eso no detectaría un establecimiento nuevo sin celda ni uno dado de baja que conserva la suya, sobre una tabla de 73 posiciones que es invariante. |
| slep_minuta_buenas_senales | slep_minuta_buenas_senales | activo | 2026-08-24 (hace 3 dias) | P-CTX-4: integrar el contexto en el consumidor (validar el esquema de ambos parquets, poblar las columnas hoy en NA de 33_armar_minuta.R, renderizar la senal en el .docx y el HTML). |
| slep_minuta_desvinculacion | Análisis de trayectorias educativas interrumpidas | activo | 2026-08-24 (hace 3 dias) | construir el .qmd del reporte como consumidor del dataset |
| slep_minuta_matricula | slep_minuta_matricula | (pendiente) | sin actividad registrada | (pendiente de sintesis) |
| slep_normativa_convivencia | slep_normativa_convivencia | activo | 2026-08-27 (hace 0 dias) | Entregar la pauta de validación al equipo de convivencia (4 bloques: OCR, 34 temas frágiles, piezas, decisión del slug del DFL 1) junto con el CSV del cruce referencia↔instrumentos. Cuando respondan, la vía A arranca con el guion del ensayo como mapa. La sesión de alcance del módulo de reglamentos espera el cruce completado. El `commit_cierre` de este archivo lo actualiza la apertura siguiente con el hash del eco del cierre v02. |
| slep_observatorio_medios | slep_observatorio_medios | activo | 2026-08-21 (hace 6 dias) | Convertir la hoja de codificacion ciega ya guardada y calcular el alpha sobre la particion de validacion. |
| slep_paes | Motor de comparación interactivo de los resultados de la PAES | (pendiente) | 2026-08-24 (hace 3 dias) | (pendiente de sintesis) |
| slep_rendimiento_historico | Diagnóstico histórico del rendimiento escolar | activo | 2026-08-24 (hace 3 dias) | Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente. |
| slep_reporte_emergencia | slep_reporte_emergencia | amarillo | 2026-08-24 (hace 3 dias) | (pendiente de sintesis) |
| slep_reportes_modelo_resguardo_asistencia | Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio | activo | 2026-08-27 (hace 0 dias) | Resolver P86-1 con decisión formal del titular: declarar el tratamiento de origen étnico en gobernanza_datos.md o dejar de exigir la columna. Es el único bloqueante que ocurre en cada corrida y no depende de ninguna medición pendiente. |
| slep_seguimiento_educacion_inicial | Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles | activo | 2026-08-24 (hace 3 dias) | Validar visualmente el panel de detalle fijo (B1) en los módulos privado y público, y commitear el archivo de la app. |
| slep_servicio_educativo_regional | slep_servicio_educativo_regional | activo | 2026-08-27 (hace 0 dias) | Redactar el acta complementaria del fork (`decision_fork_genesis_sin_historial`), que bloquea la ejecución limpia del fork porque su encargo debe citar decisiones que hoy sólo viven en un andamio de análisis. |
| slep_simce_adecuado | Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce | activo | 2026-08-27 (hace 0 dias) | Regenerar el motor con `33_generar_html.R` y verificar visualmente la migración tipográfica, con foco en la tabla comparativa (contenedor `min-width:1000px`) y los popups RBD. |
| slep_simce_estandares_aprendizaje | Minuta de resultados Simce por estándares de aprendizaje | activo | 2026-08-24 (hace 3 dias) | No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word). |
| slep_territorio_costa_central | slep_territorio_costa_central | (pendiente) | sin actividad registrada | (pendiente de sintesis) |

## L2 - Fichas ejecutivas por proyecto activo

### slep_alertas_ael - Sistema de alertas de Anótate en la Lista _(fuente: PUSH)_
## En que vamos
El proyecto pasó de un script suelto a un desarrollo formal completo: estructura canónica de decenas, arquitectura de dos raíces (código en Git / datos en OneDrive vía variable de entorno), orquestador, validación de schema en ambos insumos, escáner de estructura y capa de gobernanza documental. Quedó versionado en un repositorio privado con CI en verde y el pipeline se verificó end-to-end (28 establecimientos en 1.5 s). Los cuatro pendientes del traspaso anterior quedaron cerrados y los restantes son menores.

## Proximo paso
Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos, ya que se generó en macOS (donde Aptos no viene preinstalada) y officer degrada en silencio.

## Bloqueantes
ninguno

### slep_aprendizajes_ep - Monitoreo de aprendizajes en la educación parvularia _(fuente: PUSH)_
## En que vamos
Llegó el primer lote real de evaluaciones (un jardín, dos salas, cuarenta y ocho párvulos, ventana
diagnóstica) y el pipeline abortaba exigiendo un insumo de matrícula que el proyecto ya no recibe.
El arreglo está completo en la rama `fix/contrato-insumos-matricula`, publicada y con siete
confirmaciones: el universo de párvulos se deriva ahora del consolidado de plantillas retornadas y la
garantía de denominador completo viajó con él.

## Proximo paso
Sembrar el root de verificación para cerrar la acreditación pendiente, abrir la PR y autorizar el
merge, para poder correr por primera vez el pipeline completo sobre datos reales.

## Bloqueantes
- La PR no está creada: `gh` no está instalado en la máquina Windows (el enlace de creación lo
  devolvió el push).
- La mitad 1 del criterio de aceptación quedó congelada: el root de verificación no está sembrado y
  sembrarlo no estaba entre las autorizaciones del ejecutor.

### slep_categoria_desempeno - Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país _(fuente: PUSH)_
## En que vamos
Sesión administrativa pura (v28): se cerraron tres de los cuatro pendientes heredados de v27. Se versionó el conjunto de archivos untracked, se consolidó el backlog a 90 entradas (categoría nueva "Gobernanza de datos") y se invalidó el pendiente cruzado "4b/depe4", que resultó pertenecer a un proyecto hermano. Repo sincronizado con origin, árbol limpio, sin trabajo de producto ni fallas funcionales.

## Proximo paso
Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito y los hashes anteriores dejaron de existir (acción manual del titular, una sola vez).

## Bloqueantes
Ninguno.

### slep_costapresente - CostaPresente _(fuente: PUSH)_
## En que vamos
El pipeline ETL + app Shiny corre end-to-end en macOS sin errores. Se estabilizo la infraestructura post-migracion a Git: bootstrapping de paquetes centralizado, orquestador que auto-ejecuta el pipeline al sourcearlo, y diagrama de arquitectura actualizado. El proyecto funciona; falta validar portabilidad real en el sistema operativo de los usuarios finales.

## Proximo paso
Validar el pipeline completo (ETL + app) en una maquina Windows: configurar entorno, verificar la ruta de datos institucional y correr end-to-end con el mismo output que en macOS.

## Bloqueantes
- Validacion cross-OS en Windows requiere acceso fisico a una maquina Windows; sin esta verificacion el proyecto no puede considerarse listo para distribucion.

### slep_dashboard_personal_monitoreo - Dashboard personal de monitoreo _(fuente: PUSH)_
## En que vamos
La sesion 16 cerro el housekeeping post-rename del repo (PR #29) e incorporo traspasos pendientes (PR #28), dejando la identidad consolidada y el working tree limpio. El intento de validacion numerica de SIMCE quedo bloqueado al descubrir que no existe canal formal por el que los emisores depositen consolidados reales accesibles desde el dashboard; la sesion pivoto a disenar y aprobar una plantilla unificada de contrato de consolidado para los dominios. El repo queda listo como foco unico para la migracion estructural.

## Proximo paso
Ejecutar la migracion estructural completa del repo a la convencion canonica (00_, 10_utils/, 20_insumos/, 30_procesamiento/, 40_salidas/, 50_documentacion/) siguiendo el protocolo de 7 pasos, como foco unico de la sesion.

## Bloqueantes
- No existe canal formal emisor -> dashboard para depositar consolidados reales accesibles (variable de datos apunta hoy a una ruta desactivada). No bloquea la migracion estructural, pero si la validacion SIMCE, la aplicacion de contratos y la operacion contra data real.

### slep_estudio_oferta_demanda - slep_estudio_oferta_demanda _(fuente: PUSH)_
## En que vamos
Primer eje multi-fuente (`40_trayectoria_integrada`) completo: cruza matrícula
y situación final por `mrun`, con clasificación de salida en 5 estados sin
inferir abandono. Se corrigió un error de diseño de su primer intento (supuesto
de productos per-mrun no verificado) y se extendieron `36_`/`39_` con productos
per-mrun × anio reutilizables. Panel adversarial del eje parcialmente degradado
(agentes de subproceso cayeron por límite de sesión); sustituido por
re-derivación independiente inline, con una deuda de re-verificación pendiente.
## Proximo paso
Confirmar push de los commits locales, luego evaluar iniciar el alcance
ampliado de `40_` (matrícula regional per-mrun) para cerrar el 15,7% de
transiciones "sin registro observable" con desfase entre bases documentado.
## Bloqueantes
ninguno

### slep_gestion_solicitudes_compras - slep_gestion_solicitudes_compras _(fuente: PUSH)_
## En que vamos
El sitio sigue publicado con el corte 20260820_2042: universo completo de 77
establecimientos, 240 productos y cero exclusiones. La sesion 16 escribio y
calibro 95_verificar_cierre.R como instrumental compartido de la cartera y lo
corrio contra este proyecto hasta dejar la compuerta de repositorio en 9/9, con
la decision archivada que autoriza sus datos versionados.

## Proximo paso
Resolver P88: la huella de insumos mide el primer nivel de 20_insumos/ del data
root, que solo contiene auxiliares y respaldos, mientras las 97 carpetas de
establecimientos viven fuera de esa ventana.

## Bloqueantes
- P88: insumos_verificados certifica hoy un directorio sin planillas. La salida
  es reubicar las carpetas bajo el 20_insumos/ del data root, o declarar la
  huella de este proyecto explicitamente parcial.
- P89: commit_cierre no puede nombrar el commit que lo contiene, asi que nombra
  el ultimo commit previo al cierre. Un desfase de un commit en 0bis no es senal
  de trabajo perdido mientras este pendiente siga abierto.
- P12: acto institucional del titular, que define la fase del proyecto.

### slep_idps - Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) _(fuente: PULL)_
**Tipo de producto:** tablero/app.

El proyecto es un motor de comparacion interactivo de los Indicadores de Desarrollo Personal y Social (IDPS), publicado como una aplicacion web autocontenida que muestra resultados por establecimiento educacional, segmentados de forma permanente por grupo socioeconomico y sin agregacion territorial, con serie historica desde 2014 hasta 2025. La ultima sesion (cierre v25) verifico que la integracion del historico ya estaba completa, documento la cobertura y sus huecos (no aplicacion del instrumento) en cuatro capas, y entrego tres mejoras de la vista historica: valor de la media movil vigente, distancia respecto del grupo socioeconomico en el tooltip de indicador, y senaletica de significancia por barra para anios sin comparacion publicada.

Productos a la fecha: motor desplegado en produccion, parquet intacto, backlog consolidado en v25/147. Sin bloqueantes activos (un item depende de un proyecto hermano). Pendientes priorizados para la proxima sesion: higiene del backlog (subdividir la categoria de rediseno UI, ~34%), afinar prosa de documentacion y limpiar una regla CSS huerfana; mas adelante, suite/corpus y extraccion a paquete R interno. Deuda tecnica menor (CSS muerto, doble lectura de glifos) sin riesgo. Publicacion vigente via GitHub Pages con gate visual del titular antes de cada despliegue. Gobernanza: no maneja datos sensibles; trabaja solo con agregados publicos por establecimiento, depurados de identificadores personales.

Procedencia: traspaso_cierre_v25 (2026-06-25); resena; backlog_historico.

### slep_lectoescritura - slep_lectoescritura _(fuente: PUSH)_
## En que vamos
Sesion de mayor volumen del proyecto (10 cambios, 17 commits). Se salda la higiene de
repo (main en 80d1fd4, una sola rama) y, con la primera validacion en vivo del reporte
por el titular, se ejecutan tres lotes de ajustes de presentacion: prohibicion de
escala semaforo como invariante permanente, nomenclatura ordinal arabiga, escala
tipografica estandarizada, filtro de universo por instrumento en las tablas, botones de
comuna multi-toggle, eje PAES anclado al rango del instrumento y rediseno del grafico
SIMCE por referencia aprobada del proyecto hermano. Se detecta y corrige un bug de
cifras publicadas: los Estandares SIMCE no sumaban 100 porque el ETL aceptaba como dato
valido el codigo 0/0/0 con que la fuente marca "resultado no publicado"; parquet
regenerados con guardarrailes permanentes.

## Proximo paso
El fix del bug destapo un problema de modelo: el reporte publica una "cobertura SIMCE"
que no deberia existir. SIMCE (y PAES) se aplican de forma externa y censal por la
Agencia; su cobertura es 100% por construccion y el SLEP no la controla. Hay que
decidir si los instrumentos externos salen del modelo tripartito y que estado reemplaza
a la cobertura para ellos (las celdas afectadas son establecimientos que SI rindieron y
cuyo resultado la Agencia no publico). Toca el invariante tripartito y la decision
20260708_decision_modelo_fuentes.md.

## Bloqueantes
La decision de modelo sobre cobertura de instrumentos externos bloquea el push de la
rama feat/ajustes-presentacion (17 commits), porque esa rama publica las cifras de
cobertura que la decision puede eliminar.

### slep_minuta_asistencia - Minuta de asistencia mensual _(fuente: PUSH)_
## En que vamos
La sesión cerró los dos pendientes que traía y uno que apareció en el camino. P10 quedó resuelto con las copias normativas del repositorio en SETTINGS v34 y POLITICA v5.8 y con `ESTADO.md` completo. P1 quedó resuelto blindando `run_all()` contra la purga que `31` ejecuta en su línea 71, verificado en gate presencial con el aviso de reposición disparando dos veces. renv, que estaba activado desde el 19 de agosto sin biblioteca, quedó normalizado: seis paquetes de la capa DOCX podados, cinco repositorios binarios declarados, 121 paquetes restaurados en 76 segundos sin una sola compilación desde fuente, y el pipeline completo corriendo bajo esa biblioteca.

## Proximo paso
Resolver la validación parcial del cartograma, que emite 3 de 4 comprobaciones porque no recibe `maestro_ee` y por eso no detectaría un establecimiento nuevo sin celda ni uno dado de baja que conserva la suya, sobre una tabla de 73 posiciones que es invariante.

## Bloqueantes
ninguno

### slep_minuta_buenas_senales - slep_minuta_buenas_senales _(fuente: PUSH)_
## En que vamos
Se cerro la frontera contexto/positivo que bloqueaba el proyecto: SIMCE e IDPS entran por un carril nuevo de contexto formalizado, con su propio contrato v1 (15 columnas, validacion estricta). Ambos productores ya lo implementan y pasaron sus chequeos de trazabilidad: contexto_idps.parquet (39.591 filas) y contexto_simce.parquet (61.853 filas). El consumidor todavia no consume ninguno de los dos: su pipeline de 5 pasos sigue operativo y sin bugs, con las columnas de contexto materializadas en NA.

## Proximo paso
P-CTX-4: integrar el contexto en el consumidor (validar el esquema de ambos parquets, poblar las columnas hoy en NA de 33_armar_minuta.R, renderizar la senal en el .docx y el HTML).

## Bloqueantes
- P-CTX-5: revision y push del titular de las dos ramas feat/contrato-contexto (slep_idps y slep_simce_adecuado, 4 commits locales). Precondicion de P-CTX-4.
- Copia manual de contexto_idps.parquet y contexto_simce.parquet a 20_insumos/ del consumidor.

### slep_minuta_desvinculacion - Análisis de trayectorias educativas interrumpidas _(fuente: PULL)_
**Tipo de producto:** reporte.

El proyecto produce un analisis periodico de trayectorias escolares interrumpidas para un servicio educativo territorial de cuatro comunas: identifica y caracteriza a estudiantes desvinculados (dos cohortes: retiro formal y no re-matricula) e incorpora alerta temprana mediante un modelo de riesgo entrenado con asistencia previa. La sesion v29 cerro la capa de datos del reporte: se creo el productor unico del conjunto de datos del documento (paso 8 del orquestador), que materializa un universo acotado de estudiantes por establecimiento con cobertura demografica casi completa y sin avisos de integridad; ejecucion validada. Productos a la fecha: pipeline completo de procesamiento, conjunto de entrenamiento, modelo predictivo validado y dataset del documento en disco.

Pendientes priorizados: empujar el commit de cierre al remoto; fijar la funcion de tramos de riesgo; y construir el reporte (Fase 4), entregable final aun no iniciado pero ya desbloqueado. Sin bloqueantes; dependencias internas entre tramos y secciones del reporte. Deuda tecnica: refactor de cruce de cohortes a funciones compartidas y ampliacion del catalogo de establecimientos para dos indicadores diferidos. Publicacion: circulacion institucional cerrada, sin exposicion publica. Gobernanza: SI maneja datos sensibles de NNA (identificadores, asistencia, matricula), con datos confinados a entorno restringido y separados del codigo; desde la sesion anterior se agrego gobernanza_datos.md (cierre de H4).

Procedencia: traspaso_cierre_v29 (2026-06-29); resena.

### slep_minuta_matricula - slep_minuta_matricula _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_minuta_matricula sin ESTADO.md sincronizado ni cache vigente)._

### slep_normativa_convivencia - slep_normativa_convivencia _(fuente: PUSH)_
## En que vamos

La sesión 2 dejó el proyecto sin pendientes de máquina: 25 normas y 682
artículos publicados, 552 relaciones con 67 descartes registrados, compuerta de
firma endurecida en dos rondas y ensayada de punta a punta en un clon, CI con
versiones fijadas y autoprueba de la compuerta de coincidencia parcial en cada
despliegue. Las 22 piezas interpretativas siguen en borrador con 0 publicadas, y
todo el material de validación humana está listo para entregarse.

## Proximo paso

Entregar la pauta de validación al equipo de convivencia (4 bloques: OCR,
34 temas frágiles, piezas, decisión del slug del DFL 1) junto con el CSV del
cruce referencia↔instrumentos. Cuando respondan, la vía A arranca con el guion
del ensayo como mapa. La sesión de alcance del módulo de reglamentos espera el
cruce completado. El `commit_cierre` de este archivo lo actualiza la apertura
siguiente con el hash del eco del cierre v02.

## Bloqueantes

- Revisión humana de 84 páginas (75 OCR + 9 del dictamen 078) en 5 documentos
  (bloqueante de contenido): sin `ocr_revisado` firmado, ese texto no es
  citable.
- Validación de 34 asignaciones frágiles de tema y de las primeras piezas
  (bloqueante de calidad): sustentan las páginas temáticas y la capa
  interpretativa.
- Ninguno frena trabajo de máquina, porque no queda trabajo de máquina: ambos
  son la vía A.

### slep_observatorio_medios - slep_observatorio_medios _(fuente: PUSH)_
## En que vamos

La sesion dio al proyecto la instrumentacion que le faltaba y cerro la gobernanza
del catalogo de medios: hay punto de arranque, escaner de estructura, guarda de
locale verificada, seis scripts de pipeline con modo seco uniforme, y el catalogo
operativo paso a ser salida reproducible del canonico. La particion del gold
standard quedo resuelta y el pipeline quedo blindado contra corridas que destruyan
la codificacion humana. El repositorio arranca en un clon limpio.

## Proximo paso

Convertir la hoja de codificacion ciega ya guardada y calcular el alpha sobre la
particion de validacion.

## Bloqueantes

- La codificacion ciega del titular es el unico insumo que el proyecto espera; sin
  ella no hay alpha, ni codebook siguiente, ni entidades relacionales.
- La submuestra de validacion quedo bajo el umbral declarado en el traspaso v02:
  la decision de ampliarla o no se toma con el alpha a la vista.
- La restauracion de renv sin cache local no se ha probado: la prueba de clon
  limpio resolvio todo desde la cache de esta maquina.
- La copia de POLITICA_PROYECTO.md de la knowledge base esta en 5.7 y la del
  repositorio en 5.8: actualizarla antes de abrir la proxima sesion.

### slep_paes - Motor de comparación interactivo de los resultados de la PAES _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_paes sin ESTADO.md sincronizado ni cache vigente)._

### slep_rendimiento_historico - Diagnóstico histórico del rendimiento escolar _(fuente: PUSH)_
## En que vamos
Se cerró el sistema visual del reporte (P16: fuentes de marca, chip de transición, portada editorial, facets del benchmark y salida docx), todo verificado end-to-end en HTML y docx. Además se corrigió en raíz una inconsistencia metodológica clave alineando las tasas de situación final del reporte a la base CEM (P+R+Y), y se re-especificó el sidequest de la planilla RBD a 3 categorías con auditoría limpia. El pipeline corre verde de cero y los outputs del Módulo A quedaron regenerados con la nueva base.

## Proximo paso
Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente.

## Bloqueantes
ninguno

### slep_reporte_emergencia - slep_reporte_emergencia _(fuente: PUSH)_
## Dónde está el proyecto

Pipeline sano y sin cambios: `origin/main = be38235`, suite 3672 verdes, árbol
limpio, cero commits en la sesión 51. El flujo de captura de Power Automate se
construyó y quedó **activo pero no acreditado**: deposita las respuestas de
multiselección en formato JSON donde el pipeline espera texto separado por punto y
coma, en las columnas 16, 17, 20 y 26.

## Qué bloquea

La captura automática escribe sobre el insumo de producción durante emergencia
activa con ese formato sin resolver. El efecto no es un aborto sino un parseo
incorrecto silencioso. Además queda una fila de prueba (Id 591) dentro del `.xlsx`,
que la spec marca como compuerta bloqueante antes de publicar cualquier corte.

## Qué sigue

Cerrar el frente de Power Automate en la sesión 52: eliminar la fila de prueba,
decidir dónde normalizar el JSON (decisión del titular, no de implementación),
verificar el mapeo corregido del RBD, probar la rama de falla y medir el impacto de
`Hora de inicio` vacía. Después, la reconciliación del conteo del backlog, diferida
por tercera sesión consecutiva.

### slep_reportes_modelo_resguardo_asistencia - Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio _(fuente: PUSH)_
## En que vamos
La sesión 86 cerró P85-1 con decisión formal: el formato de destino del anexo nominal son
31 columnas que contienen las 18 de la planilla de referencia, y D-73-1 queda resuelto por
cumplimiento. Después el foco pivotó dos veces por hallazgos propios: la asistencia
acumulada promedia porcentajes mensuales en vez de dividir días asistidos por días
matriculados, y el pipeline exige y publica origen étnico de NNA sin que gobernanza_datos.md
lo nombre. No se tocó una línea de código.

## Proximo paso
Resolver P86-1 con decisión formal del titular: declarar el tratamiento de origen étnico en
gobernanza_datos.md o dejar de exigir la columna. Es el único bloqueante que ocurre en cada
corrida y no depende de ninguna medición pendiente.

## Bloqueantes
- P86-1: el pipeline exige, deriva, persiste y publica origen étnico de NNA, y
  gobernanza_datos.md no contiene la palabra etnia ni una vez.
- P86-2: la asistencia acumulada no mide lo que el modelo define. 1.163 estudiantes cambian
  de tramo y 12 de 73 EE mueven su cifra publicada sobre 1 pp. Absorbe P80-4.
- P86-3: la operación de agregación del indicador no está escrita en ningún documento. Va
  antes que P86-2: al revés se decide sin árbitro.
- P86-5: 2026-05 tiene 83 PDF para 73 establecimientos y 2026-06 se emitió para uno solo.
- P86-4: las fases 2, 3 y 4 del encargo de denominador quedaron sin ejecutar por la
  detención en D4.
- P85-1: cerrado por la decisión del 2026-08-26.
- P84-1: H-06 sin ejecutar. Mide el canal por el que salen datos nominales de NNA.
- P84-2: diez hallazgos abiertos del triaje, niveles 3 a 6.
- P85-3: H-08, último del nivel 3. Requiere tres archivos que la sesión 85 no leyó.
- P80-1: no hay una sola fila de la planilla de suspensiones respaldada por una
  resolución real. La planilla debe seguir VACÍA.
- P84-7: el borde de la reconciliación ponderada quedó medido idéntico en tres sesiones.
  Decisión del titular sobre qué representa el umbral.
- P85-5: 53 aserciones no se ejercen en un clon sin la raíz de datos.
- P85-6: los verificadores de encargo necesitan control positivo obligatorio.
- P85-7: el gatillo afirmar-sin-leer reincide; la sesión 86 aporta dos casos más.
- P86-10: el escáner se regenera antes del depósito del traspaso, tercera sesión seguida.
- P82-1: el detalle por establecimiento sigue recuperable desde el historial de git.
- P75-3: renv desincronizado, confirmado estructural en un clon recién restaurado.
- P84-3 y P84-4: ampliar el inventario con scatter_muestra sigue sin decidirse.
- P83-4: la categoría de documentación y gobernanza sigue creciendo sobre el resto.
- P84-11: los scatter temporales se escriben con RBD en el nombre dentro del árbol
  versionado.
- P82-2: dos corridas dejan dos informes de medición vigentes sin declarar cuál rige.
- P71-3: correr el pipeline en máquinas del equipo implica copias del data root.
- P67-1 y P75-4: el verificador de cierre no está cableado y el de apertura no existe.
- P77-4: el instrumento de cierre y su enmienda de dos commits.
- P64-7: checks de validación por paso crítico e idempotencia de outputs, heredado
  veintitrés cierres.

### slep_seguimiento_educacion_inicial - Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles _(fuente: PUSH)_
## En que vamos
La sesión 34 saldó tres pendientes de bajo riesgo (escáner sin ruta absoluta, limpieza de la raíz del repo y consolidación del backlog histórico) y abrió el panel de detalle fijo del diagrama Sankey con el enfoque B1: captura de clicks vía onRender que vuelca el detalle a un panel persistente bajo el diagrama. El cambio en la app pasó parse() y los 191 tests, pero quedó SIN commitear y SIN validación visual. La rama principal está limpia; la versión con B1 vive solo en el working tree.

## Proximo paso
Validar visualmente el panel de detalle fijo (B1) en los módulos privado y público, y commitear el archivo de la app.

## Bloqueantes
ninguno

### slep_servicio_educativo_regional - slep_servicio_educativo_regional _(fuente: PUSH)_
## En que vamos
La sesión midió las cinco premisas del acta del fork y con ese resultado cambió la estrategia: el censo no estaba expuesto, pero vive en 148 de 299 commits, así que purgar el historial resultó el camino caro y se decidió fundar el fork sin `.git`. Eso obligó a publicar antes el historial en otro remoto, y la sesión ejecutó la mudanza completa: el proyecto se llama ahora `slep_servicio_educativo_regional` en remoto, directorio, `.Rproj` y slug, y vive en un repositorio privado propio. El remoto antiguo quedó privado a la espera del fork.
## Proximo paso
Redactar el acta complementaria del fork (`decision_fork_genesis_sin_historial`), que bloquea la ejecución limpia del fork porque su encargo debe citar decisiones que hoy sólo viven en un andamio de análisis.
## Bloqueantes
- P30-5: el acta complementaria del fork sin redactar. El encargo del fork no puede citar decisiones que viven sólo en un andamio.
- P30-4: `CLAUDE.md` documenta `obtener_data_root_proyecto()` y una arquitectura de dos raíces que el código no implementa, y declara público un repositorio que hoy es privado.

### slep_simce_adecuado - Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce _(fuente: PUSH)_
## En que vamos
Sesión 27 corrigió la terminología "entidad"→"territorio" en el texto UI de `documentar.R` (commit `6a1c8b6`) y migró la escala tipográfica de `33_motor_template.html` a 7 variables CSS con piso de 12px (commit `d1d04f6`, 77 de 96 declaraciones). Las 19 declaraciones de D3 SVG y objetos JS quedaron fuera por decisión D-s27-1. La migración está commiteada y pusheada pero nunca se abrió en un navegador. Sesión 28 abierta el 2026-08-26.

## Proximo paso
Regenerar el motor con `33_generar_html.R` y verificar visualmente la migración tipográfica, con foco en la tabla comparativa (contenedor `min-width:1000px`) y los popups RBD.

## Bloqueantes
ninguno

### slep_simce_estandares_aprendizaje - Minuta de resultados Simce por estándares de aprendizaje _(fuente: PUSH)_
## En que vamos
La sesión 14 completó las Fases 9 y 10 del protocolo de migración a GitHub, cerrando formalmente esa migración: se creó el workflow CI de validación (datos prohibidos, RUTs, tokens), el CLAUDE.md raíz y se reescribió el README con la arquitectura de dos raíces. El proyecto queda completamente operativo, con pipeline verificado de cero, repositorio endurecido con CI activo en verde y documentación completa. No quedan pendientes de la migración.

## Proximo paso
No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word).

## Bloqueantes
ninguno

### slep_territorio_costa_central - slep_territorio_costa_central _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_territorio_costa_central sin ESTADO.md sincronizado ni cache vigente)._

## Anexos

### Proyectos auxiliares
- **slep_monitoreo** - Portafolio del Área (escaparate web).
- **slep_resena_proyectos** - Reseñas del portafolio.

### Proyectos nuevos detectados
- ninguno.

### Proyectos dados de baja
- slep_georreferenciacion

### Estructura no canonica (paquete / escaparate; no es documentacion incompleta)
- slep_minuta_matricula
- slep_territorio_costa_central

### Documentacion incompleta (falta reseña, traspaso o backlog)
- slep_alertas_ael (sin backlog)
- slep_aprendizajes_ep (sin resena)
- slep_costapresente (sin backlog)
- slep_dashboard_personal_monitoreo (sin resena, backlog)
- slep_estudio_oferta_demanda (sin resena)
- slep_gestion_solicitudes_compras (sin resena)
- slep_lectoescritura (sin resena)
- slep_minuta_buenas_senales (sin resena)
- slep_minuta_desvinculacion (sin backlog)
- slep_minuta_matricula (sin resena, traspaso, backlog)
- slep_normativa_convivencia (sin resena)
- slep_observatorio_medios (sin resena)
- slep_paes (sin resena)
- slep_rendimiento_historico (sin backlog)
- slep_reporte_emergencia (sin resena)
- slep_reportes_modelo_resguardo_asistencia (sin resena)
- slep_servicio_educativo_regional (sin resena)
- slep_simce_estandares_aprendizaje (sin resena, backlog)
- slep_territorio_costa_central (sin resena, traspaso, backlog)

