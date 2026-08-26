# Panorama de la cartera - Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos

> Generado: 2026-08-24 · Proyectos activos: 22 · Auxiliares: 2

## Alertas

- **Bloqueados:** ninguno.
- **Nuevos detectados:** slep_estudio_oferta_demanda, slep_gestion_solicitudes_compras, slep_lectoescritura, slep_minuta_buenas_senales, slep_minuta_matricula, slep_observatorio_medios, slep_reporte_emergencia.
- **Dados de baja:** ninguno.
- **Documentacion obsoleta (>21 dias):** slep_alertas_ael, slep_dashboard_personal_monitoreo.
- **Pendientes de sintesis:** slep_aprendizajes_ep, slep_idps, slep_lectoescritura, slep_minuta_desvinculacion, slep_minuta_matricula, slep_paes, slep_reporte_emergencia, slep_simce_adecuado.

## L1 - Tabla semaforo

| Codigo | Nombre | Semaforo | Ultima actividad | Proximo paso |
|---|---|---|---|---|
| slep_alertas_ael | Sistema de alertas de Anótate en la Lista | activo | 2026-06-10 (hace 75 dias) | Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos, ya que se generó en macOS (donde Aptos no viene preinstalada) y officer degrada en silencio. |
| slep_aprendizajes_ep | Monitoreo de aprendizajes en la educación parvularia | activo | 2026-08-24 (hace 0 dias) | versionar v83 y abordar capa 2 del ETL |
| slep_categoria_desempeno | Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país | activo | 2026-08-24 (hace 0 dias) | Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito y los hashes anteriores dejaron de existir (acción manual del titular, una sola vez). |
| slep_costapresente | CostaPresente | pausa | 2026-08-24 (hace 0 dias) | validar pipeline cross-OS en maquina Windows |
| slep_dashboard_personal_monitoreo | Dashboard personal de monitoreo | activo | 2026-05-26 (hace 90 dias) | Ejecutar la migracion estructural completa del repo a la convencion canonica (00_, 10_utils/, 20_insumos/, 30_procesamiento/, 40_salidas/, 50_documentacion/) siguiendo el protocolo de 7 pasos, como foco unico de la sesion. |
| slep_estudio_oferta_demanda | slep_estudio_oferta_demanda | activo | 2026-08-24 (hace 0 dias) | Confirmar push de los commits locales, luego evaluar iniciar el alcance ampliado de `40_` (matrícula regional per-mrun) para cerrar el 15,7% de transiciones "sin registro observable" con desfase entre bases documentado. |
| slep_georreferenciacion | Georreferenciación de establecimientos del territorio | activo | 2026-08-23 (hace 1 dias) | Los tres defectos del front-end de la capa parvularia, todos en `docs/assets/mapa.js`: la leyenda aplica a jardines y salas cuna la taxonomía de dependencia de los establecimientos escolares, los marcadores parvularios no tienen hover, y JUNJI e INTEGRA usan colores indistinguibles. |
| slep_gestion_solicitudes_compras | slep_gestion_solicitudes_compras | activo | 2026-08-21 (hace 3 dias) | Resolver P88: la huella de insumos mide el primer nivel de 20_insumos/ del data root, que solo contiene auxiliares y respaldos, mientras las 97 carpetas de establecimientos viven fuera de esa ventana. |
| slep_idps | Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) | activo | 2026-08-24 (hace 0 dias) | higiene de backlog y limpieza CSS pendientes en sesion 26 |
| slep_lectoescritura | slep_lectoescritura | (pendiente) | 2026-08-24 (hace 0 dias) | (pendiente de sintesis) |
| slep_minuta_asistencia | Minuta de asistencia mensual | activo | 2026-08-23 (hace 1 dias) | Resolver la validación parcial del cartograma, que emite 3 de 4 comprobaciones porque no recibe `maestro_ee` y por eso no detectaría un establecimiento nuevo sin celda ni uno dado de baja que conserva la suya, sobre una tabla de 73 posiciones que es invariante. |
| slep_minuta_buenas_senales | slep_minuta_buenas_senales | activo | 2026-08-24 (hace 0 dias) | P-CTX-4: integrar el contexto en el consumidor (validar el esquema de ambos parquets, poblar las columnas hoy en NA de 33_armar_minuta.R, renderizar la senal en el .docx y el HTML). |
| slep_minuta_desvinculacion | Análisis de trayectorias educativas interrumpidas | activo | 2026-08-24 (hace 0 dias) | construir el .qmd del reporte como consumidor del dataset |
| slep_minuta_matricula | slep_minuta_matricula | (pendiente) | sin actividad registrada | (pendiente de sintesis) |
| slep_observatorio_medios | slep_observatorio_medios | activo | 2026-08-21 (hace 3 dias) | Convertir la hoja de codificacion ciega ya guardada y calcular el alpha sobre la particion de validacion. |
| slep_paes | Motor de comparación interactivo de los resultados de la PAES | (pendiente) | 2026-08-24 (hace 0 dias) | (pendiente de sintesis) |
| slep_rendimiento_historico | Diagnóstico histórico del rendimiento escolar | activo | 2026-08-24 (hace 0 dias) | Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente. |
| slep_reporte_emergencia | slep_reporte_emergencia | (pendiente) | 2026-08-24 (hace 0 dias) | (pendiente de sintesis) |
| slep_reportes_modelo_resguardo_asistencia | Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio | activo | 2026-08-24 (hace 0 dias) | P78-6 (reclasificar las once etiquetas que conservan el veredicto retirado `indecidible`, única inconsistencia interna que la sesión deja en un documento de activa/). Después P77-4 y las dos decisiones del titular, que llevan cuatro cierres pendientes. |
| slep_seguimiento_educacion_inicial | Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles | activo | 2026-08-24 (hace 0 dias) | validar visualmente panel de detalle fijo del diagrama y commitear |
| slep_simce_adecuado | Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce | cerrado | 2026-08-24 (hace 0 dias) | mantenimiento documental concluido; estable y desplegado sin pendientes activos |
| slep_simce_estandares_aprendizaje | Minuta de resultados Simce por estándares de aprendizaje | activo | 2026-08-24 (hace 0 dias) | No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word). |

## L2 - Fichas ejecutivas por proyecto activo

### slep_alertas_ael - Sistema de alertas de Anótate en la Lista _(fuente: PUSH)_
## En que vamos
El proyecto pasó de un script suelto a un desarrollo formal completo: estructura canónica de decenas, arquitectura de dos raíces (código en Git / datos en OneDrive vía variable de entorno), orquestador, validación de schema en ambos insumos, escáner de estructura y capa de gobernanza documental. Quedó versionado en un repositorio privado con CI en verde y el pipeline se verificó end-to-end (28 establecimientos en 1.5 s). Los cuatro pendientes del traspaso anterior quedaron cerrados y los restantes son menores.

## Proximo paso
Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos, ya que se generó en macOS (donde Aptos no viene preinstalada) y officer degrada en silencio.

## Bloqueantes
ninguno

### slep_aprendizajes_ep - Monitoreo de aprendizajes en la educación parvularia _(fuente: PULL)_
**Tipo de producto:** reporte.

El proyecto construye un sistema de monitoreo de aprendizajes para la educacion parvularia que organiza resultados segun las Bases Curriculares de la Educacion Parvularia (ambito, nucleo y objetivo de aprendizaje) y los entrega como informes interactivos: una vista por establecimiento educacional y una vista central agregada del Servicio. Calcula cobertura y logro por nivel a lo largo de los tres momentos de evaluacion del ano. La ultima sesion cerro el diseno de la decision de priorizacion por momento e implemento su primera capa (generador de insumos y contrato de datos): produce un archivo de priorizacion por momento con una hoja por nivel macro, verificado visualmente sobre un caso de prueba sintetico.

Productos a la fecha: pipeline de ETL en R, generador de plantillas de captura, generador de informes interactivos y verificadores asociados. Pendientes priorizados: versionar el trabajo en disco y luego las capas 2 a 4 (lectura en el ETL, exposicion en el contrato JSON y render, auditoria). Bloqueante: item de asistencia detenido por falta de origen del dato. Deuda tecnica: portabilidad cross-OS de verificadores con rutas embebidas; estado transitorio en que el ETL cae a fallback hasta cerrar la capa 2 (no ejecutar el pipeline completo entretanto). Despliegue: nada versionado en la ultima sesion; informes en entorno institucional restringido. Gobernanza: si maneja datos sensibles, categoria datos personales de primera infancia; el detalle individual nunca se publica y las vistas de conjunto operan con informacion agregada.

Procedencia: traspaso_cierre_v83 (2026-06-26); resena; backlog_consolidado.

### slep_categoria_desempeno - Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país _(fuente: PUSH)_
## En que vamos
Sesión administrativa pura (v28): se cerraron tres de los cuatro pendientes heredados de v27. Se versionó el conjunto de archivos untracked, se consolidó el backlog a 90 entradas (categoría nueva "Gobernanza de datos") y se invalidó el pendiente cruzado "4b/depe4", que resultó pertenecer a un proyecto hermano. Repo sincronizado con origin, árbol limpio, sin trabajo de producto ni fallas funcionales.

## Proximo paso
Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito y los hashes anteriores dejaron de existir (acción manual del titular, una sola vez).

## Bloqueantes
Ninguno.

### slep_costapresente - CostaPresente _(fuente: PULL)_
**Tipo de producto:** tablero/app.

Aplicacion local de seguimiento de trayectorias escolares para un servicio local de educacion que cubre cuatro comunas y del orden de varias decenas de establecimientos educacionales y unos veinte mil estudiantes. Reune registros mensuales de matricula y asistencia (fuente: Centro de Estudios del Ministerio de Educacion) en un pipeline de dos pasos: un ETL que normaliza planillas y produce archivos columnar, y una app que permite consultar la trayectoria individual de un estudiante (recorrido entre establecimientos, asistencia, retiros, alta movilidad) mas una vista agregada del territorio con deteccion de casos que desaparecen sin baja formal.

La ultima sesion cerro la estabilizacion de infraestructura post-migracion: centralizacion de gestion de paquetes, auto-ejecucion del orquestador, scanner de estructura y diagrama de arquitectura; el pipeline corre end-to-end en macOS. Pendiente priorizado y bloqueante para produccion: validacion cross-OS en Windows (los usuarios finales operan Windows); pendiente menor: actualizar diagrama del instructivo. Deuda tecnica: app monolitica y umbrales hardcodeados; instructivo binario fuera de control de versiones. Sin despliegue publico: opera local, sin versionar datos. Gobernanza: si maneja datos personales sensibles de ninos, ninas y adolescentes, con resguardo estricto fuera del repositorio.

Procedencia: traspaso-cierre-v01 (2026-06-24); resena.

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

### slep_georreferenciacion - Georreferenciación de establecimientos del territorio _(fuente: PUSH)_
## En que vamos
El pendiente V quedó cerrado: los nueve artefactos de `docs/data/` tienen productor registrado en el orquestador y ninguno lee el shapefile de la BCN, que está sellado. `30b_construir_fronteras_rotulos.R` deriva las dos fronteras y los rótulos comunales desde dos insumos versionados, uno de ellos nuevo (`20_insumos/comunas_r5.geojson`, la región continental). La decisión que lo hizo posible está documentada con sus cifras: los rótulos se desplazan una mediana de 43,58 m respecto de los publicados, y se acepta porque el objetivo es que un clon limpio reproduzca `docs/`. El escáner ya no enumera el contenido de la capa interna sellada.

## Proximo paso
Los tres defectos del front-end de la capa parvularia, todos en `docs/assets/mapa.js`: la leyenda aplica a jardines y salas cuna la taxonomía de dependencia de los establecimientos escolares, los marcadores parvularios no tienen hover, y JUNJI e INTEGRA usan colores indistinguibles.

## Bloqueantes
- G6: los cinco casos ciegos de `casos_conocidos.csv` necesitan autores ajenos al diseño del método. Sin ellos la sesión C no tiene contra qué evaluar la calibración.
- Ventana temporal de `cap` sin decidir: la sesión C calibraría sobre una serie cuya extensión nadie eligió.
- La entrada de `cierres_log.md` fuera de su commit de cierre va en su sexta ocurrencia y ya hizo fallar dos aperturas seguidas.

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

### slep_lectoescritura - slep_lectoescritura _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_lectoescritura sin ESTADO.md sincronizado ni cache vigente)._

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

### slep_reporte_emergencia - slep_reporte_emergencia _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_reporte_emergencia sin ESTADO.md sincronizado ni cache vigente)._

### slep_reportes_modelo_resguardo_asistencia - Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio _(fuente: PUSH)_
## En que vamos
La sesión 78 no tocó código: cerró memoria. El proyecto tiene por primera vez un inventario
de estado de sus pendientes, separado del backlog y con la regla de que el silencio no cierra
un pendiente. El censo devolvió noventa y dos etiquetas y destapó que treinta y siete salieron
del inventario vivo sin que nadie las cerrara. P70-4 llevaba seis cierres heredándose después
de haberse ejecutado en la sesión 71 con resultado negativo. Las doce clasificaciones que el
triaje y su panel dejaron enfrentadas se arbitraron midiendo, y dos pendientes discutidos
durante cuatro y cinco cierres resultaron carecer de objeto: denuncian como defecto algo que
el protocolo establece.

## Proximo paso
P78-6 (reclasificar las once etiquetas que conservan el veredicto retirado `indecidible`, única
inconsistencia interna que la sesión deja en un documento de activa/). Después P77-4 y las dos
decisiones del titular, que llevan cuatro cierres pendientes.

## Bloqueantes
- P75-3: `renv::status()` desincronizado por `suitedoc`. La dirección de la sincronización es
  decisión del titular y absorbe P68-1.
- P71-3: correr el pipeline en máquinas del equipo implica copias del data root en discos
  adicionales. Decisión del titular, sin tomar, y condiciona el documento de instalación.
- P75-6: diecisiete hallazgos abiertos del panel adversarial, con fix propuesto y sin aplicar,
  en `50_documentacion/andamios/logs/20260822_panel_adversarial_entregable_v4.md`.
- P67-1 y P75-4: el verificador de cierre no está cableado; el de apertura sigue sin existir.
  Este cierre corrió sin compuerta de repositorio.
- P77-4: el instrumento de cierre v10 hace un commit y la compuerta D-67-1 exige dos, y el hash
  que su F7 imprime nace superado por el commit que su F9 crea después.
- P64-7: checks de validación por paso crítico e idempotencia de outputs, heredado quince
  cierres sin remedirse.
- P78-6: once etiquetas conservan `indecidible`, veredicto retirado de la taxonomía.

### slep_seguimiento_educacion_inicial - Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles _(fuente: PULL)_
**Tipo de producto:** tablero/app.

El proyecto es un analisis longitudinal de las preferencias de matricula de los egresados de jardines infantiles del territorio del Servicio Local, que sigue cohorte a cohorte la transicion desde la educacion parvularia hacia la escolar a lo largo de tres periodos academicos, distinguiendo permanencia en el Servicio, migracion a otro sostenedor, continuidad en el mismo jardin y casos no localizados. El producto es una aplicacion interactiva con diagramas de flujo, tablas comparativas y exportacion, organizada en un modulo restringido y uno de alcance territorial sobre datos abiertos. La ultima sesion cerro tres pendientes de saneamiento (portabilidad del escaner sin rutas absolutas, limpieza de la raiz, consolidacion del backlog historico) y abrio una funcionalidad de panel de detalle persistente bajo el diagrama de flujo.

El foco inmediato es validar visualmente ese panel de detalle y comprometerlo; el cambio esta aplicado en disco pero sin commitear ni validar (suite de pruebas en verde). Pendientes priorizados: ajuste cosmetico de etiquetas, dashboard estatico para directivos y puesta en servidor (diferidos). Bloqueantes: destino por establecimiento en el modulo territorial esta bloqueado por una compuerta de gobernanza; varias validaciones de calidad de datos esperan un insumo externo. Sin dependencias con otros proyectos. Deuda tecnica destacada: el escaner muta archivos versionados en cada corrida. Sin despliegue productivo aun. Gobernanza: si maneja datos sensibles (trayectorias individuales de ninos y ninas; identificadores restringidos en el modulo privado y enmascarados en el territorial).

Procedencia: traspaso_cierre_v34 (2026-06-24); resena; backlog_consolidado.

### slep_simce_adecuado - Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce _(fuente: PULL)_
**Tipo de producto:** tablero/app.

Herramienta interactiva de comparacion de resultados de las pruebas Simce expresados segun los estandares de aprendizaje (Adecuado, Elemental, Insuficiente), con foco en el nivel Adecuado como indicador de logro, ponderada por numero de evaluados y segmentada por grupo socioeconomico. Permite navegar resultados por establecimiento educacional, comuna, Servicio Local, region y nivel nacional, para dos niveles escolares y dos pruebas, a lo largo de la serie disponible (mediados de la decada de 2010 hasta el ano en curso). Construida como aplicacion HTML standalone (React + D3, pipeline reproducible en R) y publicada como sitio estatico.

La sesion v24 fue integramente de mantenimiento documental: sin cambios al motor ni al pipeline. Se cerro el delta de backlog, se versiono la resena final, se retiraron marcas de revision en un script de documentacion y se normalizaron los tags del backlog a una taxonomia canonica de siete codigos. Productos a la fecha: motor desplegado, suite de documentacion standalone offline, backlog historico consolidado y resena final. Pendientes priorizados: sin pendientes activos; candidatos futuros son la actualizacion anual de insumos y la regeneracion de la suite si cambia su contenido. Sin bloqueantes. Deuda tecnica saldada. Gobernanza: maneja datos sensibles (cumplimiento Ley 21.719; identificador de persona natural retirado del insumo versionado going-forward).

Procedencia: traspaso_cierre_v24 (2026-06-29); resena; backlog_historico.

### slep_simce_estandares_aprendizaje - Minuta de resultados Simce por estándares de aprendizaje _(fuente: PUSH)_
## En que vamos
La sesión 14 completó las Fases 9 y 10 del protocolo de migración a GitHub, cerrando formalmente esa migración: se creó el workflow CI de validación (datos prohibidos, RUTs, tokens), el CLAUDE.md raíz y se reescribió el README con la arquitectura de dos raíces. El proyecto queda completamente operativo, con pipeline verificado de cero, repositorio endurecido con CI activo en verde y documentación completa. No quedan pendientes de la migración.

## Proximo paso
No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word).

## Bloqueantes
ninguno

## Anexos

### Proyectos auxiliares
- **slep_monitoreo** - Portafolio del Área (escaparate web).
- **slep_resena_proyectos** - Reseñas del portafolio.

### Proyectos nuevos detectados
- slep_estudio_oferta_demanda
- slep_gestion_solicitudes_compras
- slep_lectoescritura
- slep_minuta_buenas_senales
- slep_minuta_matricula
- slep_observatorio_medios
- slep_reporte_emergencia

### Proyectos dados de baja
- ninguno.

### Estructura no canonica (paquete / escaparate; no es documentacion incompleta)
- slep_minuta_matricula

### Documentacion incompleta (falta reseña, traspaso o backlog)
- slep_alertas_ael (sin backlog)
- slep_aprendizajes_ep (sin resena)
- slep_costapresente (sin backlog)
- slep_dashboard_personal_monitoreo (sin resena, backlog)
- slep_estudio_oferta_demanda (sin resena)
- slep_georreferenciacion (sin resena)
- slep_gestion_solicitudes_compras (sin resena)
- slep_lectoescritura (sin resena)
- slep_minuta_buenas_senales (sin resena, traspaso)
- slep_minuta_desvinculacion (sin backlog)
- slep_minuta_matricula (sin resena, traspaso, backlog)
- slep_observatorio_medios (sin resena)
- slep_paes (sin resena)
- slep_rendimiento_historico (sin backlog)
- slep_reporte_emergencia (sin resena)
- slep_reportes_modelo_resguardo_asistencia (sin resena)
- slep_simce_estandares_aprendizaje (sin resena, backlog)

