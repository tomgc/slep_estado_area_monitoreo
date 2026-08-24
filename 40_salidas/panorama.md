# Panorama de la cartera - Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos

> Generado: 2026-07-10 · Proyectos activos: 19 · Auxiliares: 2

## Alertas

- **Bloqueados:** ninguno.
- **Nuevos detectados:** slep_estudio_oferta_demanda, slep_lectoescritura, slep_minuta_buenas_senales, slep_minuta_matricula.
- **Dados de baja:** ninguno.
- **Documentacion obsoleta (>21 dias):** slep_alertas_ael, slep_dashboard_personal_monitoreo, slep_rendimiento_historico, slep_simce_estandares_aprendizaje.
- **Pendientes de sintesis:** slep_idps, slep_minuta_asistencia, slep_minuta_matricula, slep_paes, slep_reportes_modelo_resguardo_asistencia.

## L1 - Tabla semaforo

| Codigo | Nombre | Semaforo | Ultima actividad | Proximo paso |
|---|---|---|---|---|
| slep_alertas_ael | Sistema de alertas de Anótate en la Lista | activo | 2026-06-10 (hace 30 dias) | Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos, ya que se generó en macOS (donde Aptos no viene preinstalada) y officer degrada en silencio. |
| slep_aprendizajes_ep | Monitoreo de aprendizajes en la educación parvularia | activo | 2026-06-29 (hace 11 dias) | Versionar primero los 3 archivos de v83 y luego implementar la capa 2 de D013 (ETL `32_etl.R`) para que el ETL deje de caer a fallback. |
| slep_categoria_desempeno | Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país | activo | 2026-07-04 (hace 6 dias) | Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito y los hashes anteriores dejaron de existir (acción manual del titular, una sola vez). |
| slep_costapresente | CostaPresente | activo | 2026-06-24 (hace 16 dias) | Validar el pipeline completo (ETL + app) en una maquina Windows: configurar entorno, verificar la ruta de datos institucional y correr end-to-end con el mismo output que en macOS. |
| slep_dashboard_personal_monitoreo | Dashboard personal de monitoreo | activo | 2026-05-26 (hace 45 dias) | Ejecutar la migracion estructural completa del repo a la convencion canonica (00_, 10_utils/, 20_insumos/, 30_procesamiento/, 40_salidas/, 50_documentacion/) siguiendo el protocolo de 7 pasos, como foco unico de la sesion. |
| slep_estudio_oferta_demanda | slep_estudio_oferta_demanda | activo | 2026-07-10 (hace 0 dias) | Confirmar push de los commits locales, luego evaluar iniciar el alcance ampliado de `40_` (matrícula regional per-mrun) para cerrar el 15,7% de transiciones "sin registro observable" con desfase entre bases documentado. |
| slep_georreferenciacion | Georreferenciación de establecimientos del territorio | cerrado | 2026-06-29 (hace 11 dias) | ninguno |
| slep_idps | Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) | activo | 2026-07-05 (hace 5 dias) | higiene de backlog y limpieza CSS pendientes en sesion 26 |
| slep_lectoescritura | slep_lectoescritura | activo | 2026-07-09 (hace 1 dias) | Iniciar el producto: vistas longitudinales por instrumento en metrica nativa, por comuna/territorio, con NO APLICADO visible (PV1). No homologar entre escalas (decision §2.3). |
| slep_minuta_asistencia | Minuta de asistencia mensual | activo | 2026-07-09 (hace 1 dias) | limpieza de estructura de documentacion, luego refactor del orquestador canonico |
| slep_minuta_buenas_senales | slep_minuta_buenas_senales | activo | 2026-07-10 (hace 0 dias) | Revision visual del HTML contra el handoff y, si el titular confirma licencia de las tipografias (P12), embeberlas en el HTML via @font-face (P14, baja). |
| slep_minuta_desvinculacion | Análisis de trayectorias educativas interrumpidas | activo | 2026-06-30 (hace 10 dias) | Abordar el residuo de `flextable` en `00_run_all.R`: leer primero `41_minuta_desvinculacion_T2_2025.qmd` completo para confirmar si `flextable` aún se usa o es residuo, y si lo es, entregar `00_run_all.R` corregido. |
| slep_minuta_matricula | slep_minuta_matricula | (pendiente) | sin actividad registrada | (pendiente de sintesis) |
| slep_paes | Motor de comparación interactivo de los resultados de la PAES | (pendiente) | 2026-07-04 (hace 6 dias) | (pendiente de sintesis) |
| slep_rendimiento_historico | Diagnóstico histórico del rendimiento escolar | activo | 2026-06-15 (hace 25 dias) | Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente. |
| slep_reportes_modelo_resguardo_asistencia | Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio | activo | 2026-07-08 (hace 2 dias) | auditoria portabilidad cross-OS Windows que destraba variable canonica fase 2 |
| slep_seguimiento_educacion_inicial | Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles | activo | 2026-06-24 (hace 16 dias) | Validar visualmente el panel de detalle fijo (B1) en los módulos privado y público, y commitear el archivo de la app. |
| slep_simce_adecuado | Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce | activo | 2026-07-01 (hace 9 dias) | No hay pendientes activos ni bugs. Candidatos de sesión futura: regenerar la suite standalone (evaluar si `documentar.R` referencia terminología "entidad" a actualizar), actualización anual de insumos Simce 2025/2026. |
| slep_simce_estandares_aprendizaje | Minuta de resultados Simce por estándares de aprendizaje | activo | 2026-05-28 (hace 43 dias) | No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word). |

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
Se cerró el diseño de la Decisión 013 (priorización por momento) y se implementó su capa 1: el generador `36_generar_priorizacion.R` produce 72 libros por momento con una hoja por macro, más el contrato §2.ter reconciliado. Todo verificado visualmente en el gemelo, pero quedó en disco SIN versionar (la sesión no hizo operaciones git). El ETL sigue leyendo el formato viejo y cae a fallback, por lo que no debe correrse run_all ni el ETL hasta cerrar la capa 2.

## Proximo paso
Versionar primero los 3 archivos de v83 y luego implementar la capa 2 de D013 (ETL `32_etl.R`) para que el ETL deje de caer a fallback.

## Bloqueantes
ninguno

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

### slep_georreferenciacion - Georreferenciación de establecimientos del territorio _(fuente: PUSH)_
## En que vamos
Se construyó, auditó y commiteó la variante de escala única continua del afiche A0 (97 establecimientos), corrigiendo la regresión donde la etiqueta de una comuna tapaba un pin mediante un offset calibrado por código y el switch REUSAR_PNG. El titular reposicionó a mano las 4 etiquetas de comuna al océano en Affinity y exportó el PDF plotter-ready (300 DPI, fuentes incrustadas); el producto original con inset permanece byte-idéntico. Ambas variantes quedaron finalizadas y entregadas; el proyecto se da por cerrado.

## Proximo paso
ninguno

## Bloqueantes
ninguno

### slep_idps - Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) _(fuente: PULL)_
**Tipo de producto:** tablero/app.

El proyecto es un motor de comparacion interactivo de los Indicadores de Desarrollo Personal y Social (IDPS), publicado como una aplicacion web autocontenida que muestra resultados por establecimiento educacional, segmentados de forma permanente por grupo socioeconomico y sin agregacion territorial, con serie historica desde 2014 hasta 2025. La ultima sesion (cierre v25) verifico que la integracion del historico ya estaba completa, documento la cobertura y sus huecos (no aplicacion del instrumento) en cuatro capas, y entrego tres mejoras de la vista historica: valor de la media movil vigente, distancia respecto del grupo socioeconomico en el tooltip de indicador, y senaletica de significancia por barra para anios sin comparacion publicada.

Productos a la fecha: motor desplegado en produccion, parquet intacto, backlog consolidado en v25/147. Sin bloqueantes activos (un item depende de un proyecto hermano). Pendientes priorizados para la proxima sesion: higiene del backlog (subdividir la categoria de rediseno UI, ~34%), afinar prosa de documentacion y limpiar una regla CSS huerfana; mas adelante, suite/corpus y extraccion a paquete R interno. Deuda tecnica menor (CSS muerto, doble lectura de glifos) sin riesgo. Publicacion vigente via GitHub Pages con gate visual del titular antes de cada despliegue. Gobernanza: no maneja datos sensibles; trabaja solo con agregados publicos por establecimiento, depurados de identificadores personales.

Procedencia: traspaso_cierre_v25 (2026-06-25); resena; backlog_historico.

### slep_lectoescritura - slep_lectoescritura _(fuente: PUSH)_
## En que vamos
Etapa 2 completa: el esquema dejo de ser DIA-especifico (dimension `nivel`
generica) y se integraron SIMCE lectura y PAES competencia lectora como instancias
del esquema agnostico. Motor de cobertura unico y indicadores multi-fuente en
metrica nativa (sin homologar), pipeline idempotente, etapa 2 respaldada en el
remoto (vertical DIA en main; P2 en la rama feat/ingesta-simce-paes).

## Proximo paso
Iniciar el producto: vistas longitudinales por instrumento en metrica nativa, por
comuna/territorio, con NO APLICADO visible (PV1). No homologar entre escalas
(decision §2.3).

## Bloqueantes
ninguno

### slep_minuta_asistencia - Minuta de asistencia mensual _(fuente: PULL)_
**Tipo de producto:** reporte.

La Minuta Mensual de Asistencia del SLEP Costa Central es un pipeline reproducible en R/Quarto que consolida los registros diarios de asistencia provistos por el Ministerio de Educacion y produce un reporte ejecutivo (Word mas graficos) con tasas de asistencia por territorio, comuna, macrogrupo de ensenanza, nivel y establecimiento educacional, ademas de rachas de inasistencia y alertas por umbrales de gestion. Esta dirigido a la conduccion del Servicio para apoyar la priorizacion y el seguimiento de metas. La ultima sesion fue multifrente: normalizo la configuracion de entorno, genero y audito las minutas de marzo, abril y mayo de 2026 (aptas para distribucion), y cerro el diseno de un proyecto separado de reporte para directores.

Productos entregados: minutas mensuales operativas y auditadas hasta mayo 2026. Pendientes priorizados: limpieza de estructura documental, refactor a orquestador canonico, y la minuta recurrente de junio. Sin bloqueantes. Deuda tecnica: nomenclatura mixta de traspasos (grafia historica CONTEXTO_VNN para las sesiones 10-35, vigente traspaso-cierre-vNN desde la 36) y override de ruta inactivo. Despliegue interno; no publicado. Gobernanza: si maneja datos personales sensibles de NNA (asistencia individual), resguardados en entorno restringido fuera del repositorio; solo se difunden agregados.

Procedencia: traspaso-cierre-v64 (2026-06-23); resena.

### slep_minuta_buenas_senales - slep_minuta_buenas_senales _(fuente: PUSH)_
## En que vamos
Pipeline de 5 pasos operativo, sin bugs. El HTML interactivo (35_minuta_html.qmd)
quedó alineado al sistema visual hifi de marca (handoff de Claude Design): tokens
SLEP completos, grilla de indicadores de 5 columnas, franjas "por qué se destaca",
chip de categoria, pie de fuente, segmentador como button, coma decimal chilena.
Recreado en 12 fases + limpieza, con binding a los parquets intacto (13 fichas =
13 del parquet), y mergeado a main con --no-ff (pusheado). El backlog se
sincronizo (faltaban las sesiones 8 y 9, no una).
## Proximo paso
Revision visual del HTML contra el handoff y, si el titular confirma licencia de
las tipografias (P12), embeberlas en el HTML via @font-face (P14, baja).
## Bloqueantes
ninguno

### slep_minuta_desvinculacion - Análisis de trayectorias educativas interrumpidas _(fuente: PUSH)_
## En que vamos
La sesión S37 cerró la Prioridad 1 de higiene de repo destapada en S36: des-trackeó 10 archivos ya cubiertos por el `.gitignore` y renombró `.env.example` a `.Renviron.example`, corrigiendo de paso una exclusión funcional rota en el CI y actualizando tres deudas del README ya resueltas. Se hicieron dos commits atómicos limpios, ninguno pusheado (rama ahead 18 de origin). El pipeline no se tocó; sin regresiones esperadas y sin bugs de código en la sesión.

## Proximo paso
Abordar el residuo de `flextable` en `00_run_all.R`: leer primero `41_minuta_desvinculacion_T2_2025.qmd` completo para confirmar si `flextable` aún se usa o es residuo, y si lo es, entregar `00_run_all.R` corregido.

## Bloqueantes
ninguno

### slep_minuta_matricula - slep_minuta_matricula _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_minuta_matricula sin ESTADO.md sincronizado ni cache vigente)._

### slep_paes - Motor de comparación interactivo de los resultados de la PAES _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_paes sin ESTADO.md sincronizado ni cache vigente)._

### slep_rendimiento_historico - Diagnóstico histórico del rendimiento escolar _(fuente: PUSH)_
## En que vamos
Se cerró el sistema visual del reporte (P16: fuentes de marca, chip de transición, portada editorial, facets del benchmark y salida docx), todo verificado end-to-end en HTML y docx. Además se corrigió en raíz una inconsistencia metodológica clave alineando las tasas de situación final del reporte a la base CEM (P+R+Y), y se re-especificó el sidequest de la planilla RBD a 3 categorías con auditoría limpia. El pipeline corre verde de cero y los outputs del Módulo A quedaron regenerados con la nueva base.

## Proximo paso
Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente.

## Bloqueantes
ninguno

### slep_reportes_modelo_resguardo_asistencia - Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio _(fuente: PULL)_
**Tipo de producto:** reporte.

Proyecto que genera mensualmente, por lote, un reporte por direccion para todos los establecimientos educacionales del territorio, implementando el Modelo de Resguardo de la Asistencia Educativa. Cada entrega combina un PDF (Quarto, typst, tinytable) y una planilla por establecimiento: describe la asistencia propia, la situa de forma anonimizada frente al territorio y a un grupo de vulnerabilidad similar (percentiles y medianas, sin nominar a otros establecimientos), y cierra con alertas nominales de estudiantes del propio establecimiento. La ultima sesion fue puramente documental: dejo el backlog acumulativo al dia como fuente viva, sin cambios de logica ni pipeline. Productos entregados: pipeline reproducible con corrida de lote completa exitosa y suite de documentacion.

Pendientes priorizados: auditoria de portabilidad cross-OS, auditoria linea a linea del pipeline, retiro de fallback de variable de entorno y pulido de advertencias de render. Sin bloqueantes activos; el repositorio esta al dia. Dependencia: es variante de la minuta ejecutiva de asistencia, ya desacoplada en una capa propia. Deuda tecnica: esquema dual de caracterizacion e insumos en almacenamiento externo. Despliegue estable, ejecucion mensual sistematica. Gobernanza: si maneja datos sensibles, categoria reforzada por tratarse de datos de ninos, ninas y adolescentes (Ley 21.719), con acceso individual restringido a la propia direccion.

Procedencia: traspaso_cierre_v38 (2026-06-21); resena; backlog_acumulativo.

### slep_seguimiento_educacion_inicial - Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles _(fuente: PUSH)_
## En que vamos
La sesión 34 saldó tres pendientes de bajo riesgo (escáner sin ruta absoluta, limpieza de la raíz del repo y consolidación del backlog histórico) y abrió el panel de detalle fijo del diagrama Sankey con el enfoque B1: captura de clicks vía onRender que vuelca el detalle a un panel persistente bajo el diagrama. El cambio en la app pasó parse() y los 191 tests, pero quedó SIN commitear y SIN validación visual. La rama principal está limpia; la versión con B1 vive solo en el working tree.

## Proximo paso
Validar visualmente el panel de detalle fijo (B1) en los módulos privado y público, y commitear el archivo de la app.

## Bloqueantes
ninguno

### slep_simce_adecuado - Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce _(fuente: PUSH)_
## En que vamos
Sesión 25: renombrado UI "entidad"→"territorio" (33 líneas, identificadores de código intactos), regeneración y deploy del motor, y reparación de un truncamiento del backlog originado en s24 (con un intento fallido revertido). Sesión 26: auditoría de dos hallazgos heredados de gobernanza documental (A-s25-4: `POLITICA_PROYECTO.md` duplicado en raíz resultó ser v6 obsoleta de jun-12, eliminada; `ESTADO.md` confirmado legítimo). Cerrado A-s25-3: `backlog_historico.md` renombrado a `backlog_acumulativo.md` (nombre canónico) y referencia actualizada en README. Sidequest: script `34_historico_pct_adecuado_costa_central.R` (histórico ponderado de % Adecuado, todos los GSE combinados, Costa Central, 4 hojas 4b/2m × lect/mate) ejecutado, verificado y versionado. Proyecto estable y desplegado, working tree limpio.

## Proximo paso
No hay pendientes activos ni bugs. Candidatos de sesión futura: regenerar la suite standalone (evaluar si `documentar.R` referencia terminología "entidad" a actualizar), actualización anual de insumos Simce 2025/2026.

## Bloqueantes
ninguno

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
- slep_lectoescritura
- slep_minuta_buenas_senales
- slep_minuta_matricula

### Proyectos dados de baja
- ninguno.

### Estructura no canonica (paquete / escaparate; no es documentacion incompleta)
- slep_minuta_matricula

### Documentacion incompleta (falta reseña, traspaso o backlog)
- slep_alertas_ael (sin backlog)
- slep_costapresente (sin backlog)
- slep_dashboard_personal_monitoreo (sin resena, backlog)
- slep_estudio_oferta_demanda (sin resena)
- slep_georreferenciacion (sin resena, backlog)
- slep_lectoescritura (sin resena)
- slep_minuta_asistencia (sin backlog)
- slep_minuta_buenas_senales (sin resena, traspaso)
- slep_minuta_desvinculacion (sin backlog)
- slep_minuta_matricula (sin resena, traspaso, backlog)
- slep_paes (sin resena)
- slep_rendimiento_historico (sin backlog)
- slep_simce_estandares_aprendizaje (sin resena, backlog)

