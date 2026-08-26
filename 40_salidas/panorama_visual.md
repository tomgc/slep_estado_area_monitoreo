# Cartera de proyectos Área de Monitoreo

Generado: 2026-08-24 · 24 proyectos

> Versión texto del panorama visual (mismo orden y campos que las filas; orden por tipo_pendiente, estado y fecha).

## Monitoreo de aprendizajes en la educación parvularia
- **slug:** `slep_aprendizajes_ep`
- **tipo de pendiente:** bloqueante
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-18
- **reseña del itinerario:** `slep_aprendizajes_ep` es el sistema de procesamiento y reporte de las evaluaciones de aprendizaje de párvulos del SLEP Costa Central (unidad SATP). Toma las evaluaciones que las educadoras registran en plantillas Excel contra el marco curricular de las Bases Curriculares de la Educación Parvularia 2018, las consolida, las transforma en un contrato de datos JSON y genera informes HTML autocontenidos para educadoras, directoras y nivel central, sobre 24 jardines infantiles y 73 salas. Está construido en R (ETL, consolidador, generador de informes) con una capa de render en JavaScript y CSS, ve…
- **próximos pasos:**
  - Inventario
  - Evaluación de deuda técnica
  - Auditoría de cierre

## slep_lectoescritura
- **slug:** `slep_lectoescritura`
- **tipo de pendiente:** bloqueante
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-07-12
- **reseña del itinerario:** slep_lectoescritura es la plataforma de monitoreo del desarrollo de la lectoescritura de los estudiantes del SLEP Costa Central. Integra las principales evaluaciones de lectura del territorio (SIMCE Lectura, DIA/Reactivación, PAES Competencia Lectora, y fuentes futuras como DIA Educación Parvularia y evaluaciones en jardines) en una vista comparable en el tiempo, para orientar decisiones técnico-pedagógicas. Construida en R (arquitectura de dos raíces: código en GitHub privado, datos en OneDrive institucional), para el equipo de análisis del SLEP. Iniciada el 2026-07-08.
- **próximos pasos:**
  - Inventario
  - *Descripción:* el fix de BUG-08-01 mudó 24 celdas de aplicado a sin_aplicacion,
  - *Hecho de dominio (establecido por el titular al cierre de esta sesión):* SIMCE se

## CostaPresente
- **slug:** `slep_costapresente`
- **tipo de pendiente:** bloqueante
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-05-31
- **próximos pasos:**
  - Pendiente 1 (P1): Validación cross-OS en Windows
  - Descripción: Clonar el repo en una máquina Windows, configurar ~/.Renviron, verificar NBSP en ruta OneDrive, ejecutar pipeline ETL + App en…
  - Contexto: Todo el desarrollo y pruebas han sido en macOS arm64. Los colegas que usarán la app son usuarios Windows. La portabilidad real no…

## Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país
- **slug:** `slep_categoria_desempeno`
- **tipo de pendiente:** deuda heredada
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-07-02
- **reseña del itinerario:** slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que compara la distribución de establecimientos por Categoría de Desempeño (Alto / Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas, SLEPs, regiones y el nivel nacional, separando básica y media. Pipeline en R (xlsx → parquet → JSON embebido → HTML), publicado en GitHub Pages. Para el equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos públicos. (Nota v03: la opción "nacional" del selector se eliminó en la sesión 3 por volumen de EE; se agregó selección de establecimiento individual. …
- **próximos pasos:**
  - Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito y los hashes anteriores dejaron de existir (acción manual del titular, una sola vez).
  - Qué: entrada 90 (incidente PII, ver traspaso v27 §4) agregada al
  - Por qué: v26 no generó entrada (mantenimiento de suite, precedente

## Minuta de asistencia mensual
- **slug:** `slep_minuta_asistencia`
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-22
- **reseña del itinerario:** `slep_minuta_asistencia` es el pipeline que transforma los datos de asistencia escolar del CEM (Centro de Estudios MINEDUC) en la minuta mensual de asistencia del SLEP Costa Central, un documento de apoyo a la toma de decisiones dirigido al Director Ejecutivo y al equipo directivo. Cubre aproximadamente 73 establecimientos educacionales y entre 17.500 y 20.000 estudiantes en cuatro comunas costeras: Viña del Mar, Concón, Quintero y Puchuncaví. Está escrito en R y Quarto, con `data.table` y `future.apply` en el procesamiento, y produce tablas, scatter, un cartograma de teselas y series de comp…
- **próximos pasos:**
  - Resolver la validación parcial del cartograma, que emite 3 de 4 comprobaciones porque no recibe `maestro_ee` y por eso no detectaría un establecimiento nuevo sin celda ni uno dado de baja que conserva la suya, sobre una tabla de 73 posiciones que es invariante.
  - 11.1 Inventario
  - 11.2 Evaluación de deuda técnica

## slep_gestion_solicitudes_compras
- **slug:** `slep_gestion_solicitudes_compras`
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-21
- **reseña del itinerario:** Sistema de gestión de solicitudes de compra del SLEP Costa Central: lee las planillas xlsx que los establecimientos educacionales completan en carpetas compartidas de OneDrive, valida su integridad (los usuarios introducen modificaciones no solicitadas), consolida la demanda para compra al por mayor y publica un panel web de seguimiento (Cloudflare Pages tras Access) para el equipo del SLEP. Herramientas: R (pipeline), HTML/CSS/JS estático (sitio), Claude Code (ejecución), arquitectura de dos raíces. Desde 2026-07-22.
- **próximos pasos:**
  - Resolver P88: la huella de insumos mide el primer nivel de 20_insumos/ del data root, que solo contiene auxiliares y respaldos, mientras las 97 carpetas de establecimientos viven fuera de esa ventana.
  - Inventario
  - Evaluación de deuda técnica

## Portafolio del Área (escaparate web)
- **slug:** `slep_monitoreo`
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-05
- **reseña del itinerario:** El sitio `tomgc.github.io/slep_monitoreo` es una página estática institucional de presentación del Área de Monitoreo de Procesos y Resultados Educativos, dentro de la Subdirección de Apoyo Técnico Pedagógico del SLEP Costa Central. Es single-page, sin dependencias externas, alojado en GitHub Pages. Su propósito es comunicar qué hace el Área, su trayectoria, ejemplos de trabajo, su equipo y un glosario técnico. El desarrollo se inició el 2026-04-09 (commit base v1.2) y la primera sesión documentada con cierre de traspaso es el 2026-05-25 (esta).
- **próximos pasos:**
  - Redactar el elemento 3 de la sección Formación (P1, prioridad 2 de la §11.4 del traspaso v17, que pasa a ser la primera al cerrarse P3). Un elemento por sesión y no los tres: el fundamento §10 concede dos intentos por elemento, y el 3 es el que usa un caso real del Área, de modo que exige decisiones del titular sobre qué se cuenta y cómo. Debe mantenerse en términos conceptuales, sin nombrar establecimientos. Criterio de éxito: texto aprobado contra los siete criterios del fundamento §9.
  - 11.1 Inventario
  - 11.2 Evaluación de deuda técnica

## Diagnóstico histórico del rendimiento escolar
- **slug:** `slep_rendimiento_historico`
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-15
- **próximos pasos:**
  - Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente.
  - Ancla de sanidad CEM: promoción municipal-nacional ≈ 94% (2023) en el HTML.
  - Abrir el .docx y confirmar estilos de marca.

## Dashboard personal de monitoreo
- **slug:** `slep_dashboard_personal_monitoreo`
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-05-25
- **próximos pasos:**
  - Ejecutar la migracion estructural completa del repo a la convencion canonica (00_, 10_utils/, 20_insumos/, 30_procesamiento/, 40_salidas/, 50_documentacion/) siguiendo el protocolo de 7 pasos, como foco unico de la sesion.
  - Archivo(s) afectado(s): docs/traspaso/traspaso_cierre_v17.md (nuevo), docs/referencia/principios_desarrollo_v3.md (eliminado).
  - Categoría temática: Mecánica de PR / Incorporación de traspaso.

## Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS)
- **slug:** `slep_idps`
- **tipo de pendiente:** deuda tecnica
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso
- **reseña del itinerario:** `slep_idps` es un motor de visualización interactivo de los Indicadores de Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación. Produce un HTML autocontenido (React 18 + D3 v7 inline) publicado en GitHub Pages que muestra el dato por establecimiento educacional, sin agregación territorial, segmentado por grupo socioeconómico (GSE), con serie histórica 2014→2025. Para el equipo de Monitoreo y Seguimiento del SLEP Costa Central y, desde v05, para cualquier SLEP/comuna del país. Hermano de `slep_simce_adecuado` y `slep_categoria_desempeno`, de los que reutiliza catálogos…
- **próximos pasos:**
  - Item 11 (bloqueado, sin nueva información)
  - Tooltip "vs evaluación anterior": de title a body (cosmético, menor)

## Georreferenciación de establecimientos del territorio
- **slug:** `slep_georreferenciacion`
- **tipo de pendiente:** nuevo
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-23
- **reseña del itinerario:** Producir productos cartográficos y de visualización de datos para el SLEP Costa Central (Servicio Local de Educación Pública que cubre Puchuncaví, Quintero, Concón y Viña del Mar, Región de Valparaíso). El proyecto nació en junio de 2026 como un afiche cartográfico estático imprimible en plóter (A0, 841×1189 mm) que georreferencia los 97 establecimientos educacionales del territorio del SLEP, y creció hasta abarcar tres productos: - Variante 1 (afiche con inset): panel norte (Puchuncaví, Quintero, Concón) más inset de Viña del Mar a escala separada. Completada en las sesiones 1–3. - Variante …
- **próximos pasos:**
  - Los tres defectos del front-end de la capa parvularia, todos en `docs/assets/mapa.js`: la leyenda aplica a jardines y salas cuna la taxonomía de dependencia de los establecimientos escolares, los marcadores parvularios no tienen hover, y JUNJI e INTEGRA usan colores indistinguibles.
  - Duda 14. supuesto: el desplazamiento de los rótulos no es visible a la escala a la que el mapa se usa. predicado: a la escala inicial que m…
  - Duda 15. supuesto: la simplificación del insumo regional no altera ninguna decisión del pipeline distinta del filtro de georreferencia que …

## slep_estudio_oferta_demanda
- **slug:** `slep_estudio_oferta_demanda`
- **tipo de pendiente:** nuevo
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-07-10
- **reseña del itinerario:** Estudio de oferta y demanda del servicio educativo del SLEP Costa Central: diagnostico territorial y proyeccion de la red educativa, a partir de microdatos de Censo 2024 (INE) y Casen 2024 (MDSF), y de los registros oficiales de establecimientos (directorio MINEDUC, caracterizacion SLEP CC). Unidad de analisis: el establecimiento (RBD). Comunas del SLEP CC: Vina del Mar, Concon, Quintero, Puchuncavi. Foco territorial: Region de Valparaiso (05), aplicado como vista en codigo (sin recorte en disco). Herramientas: R (tidyverse, arrow, haven, sf, renv), arquitectura de dos raices. Desde 2026-07-0…
- **próximos pasos:**
  - Confirmar push de los commits locales, luego evaluar iniciar el alcance ampliado de `40_` (matrícula regional per-mrun) para cerrar el 15,7% de transiciones "sin registro observable" con desfase entre bases documentado.
  - ¿Pipeline corre de cero sin intervención manual? → Sí para 31→40; 92_ sigue
  - ¿Cada transformación crítica tiene check de validación? → Sí; el eje 40_ tiene

## Motor de comparación interactivo de los resultados de la PAES
- **slug:** `slep_paes`
- **tipo de pendiente:** nuevo
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** FALSE
- **última actualización:** 2026-07-04
- **reseña del itinerario:** slep_paes es el cuarto panorama nacional del Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos del SLEP Costa Central, construido con datos 100% públicos del DEMRE/MINEDUC sobre la PAES (Prueba de Acceso a la Educación Superior), publicado como sitio HTML autocontenido en GitHub Pages, navegable por territorio, leído desde dos focos pares (cobertura y rendimiento), hermano arquitectónico de slep_categoria_desempeno, slep_idps y slep_simce_adecuado.
- **próximos pasos:**
  - Archivos: ninguno modificado; solo verificación (git status, git log,
  - Categoría: gate del titular / verificación.
  - Qué: confirmado que HEAD local (e632e4e) ya coincidía con

## Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles
- **slug:** `slep_seguimiento_educacion_inicial`
- **tipo de pendiente:** nuevo
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-14
- **reseña del itinerario:** Seguimiento Educación Inicial es un sistema de análisis longitudinal de cohortes de párvulos para el SLEP Costa Central (Viña del Mar, Concón, Quintero, Puchuncaví). Rastrea transiciones de educación parvularia a básica en tres periodos académicos (2023→2024, 2024→2025, 2025→2026). Dos módulos: el privado (RUT real, retención en el directorio de 97 establecimientos SLEP CC) y el público (MRUN enmascarado, flujos territoriales entre todos los sostenedores de las cuatro comunas, sobre datos abiertos Mineduc). Interfaz Shiny offline unificada con selector de módulo, Sankey echarts4r, tablas reac…
- **próximos pasos:**
  - Inventario de pendientes vigentes
  - Auditoría de cierre (POLITICA §5.6)
  - #2 ¿pipeline corre de cero sin intervención? → Sí.

## slep_minuta_buenas_senales
- **slug:** `slep_minuta_buenas_senales`
- **tipo de pendiente:** nuevo
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso
- **reseña del itinerario:** slep_minuta_buenas_senales consolida indicadores positivos de distintos proyectos SLEP en una minuta breve para el equipo de comunicaciones, con el propósito de difundir buenas noticias de la educación pública del territorio (4 comunas, SLEP Costa Central). Es puramente consumidor: no decide qué es "positivo"; esa regla vive en cada proyecto fuente vía el contrato `indicadores_positivos`.
- **próximos pasos:**
  - P-CTX-4: integrar el contexto en el consumidor (validar el esquema de ambos parquets, poblar las columnas hoy en NA de 33_armar_minuta.R, renderizar la senal en el .docx y el HTML).

## Sistema de alertas de Anótate en la Lista
- **slug:** `slep_alertas_ael`
- **tipo de pendiente:** cosmetica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-09
- **próximos pasos:**
  - Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos, ya que se generó en macOS (donde Aptos no viene preinstalada) y officer degrada en silencio.
  - Archivo(s) afectado(s): 30_procesamiento/31_alertas_establecimientos.R (usa validar_columnas() de 10_utils.R).
  - Categoría temática: Validación y robustez.

## Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce
- **slug:** `slep_simce_adecuado`
- **tipo de pendiente:** ninguno
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-07-01
- **próximos pasos:**
  - ¿Pipeline corre de cero sin intervención manual? → Sí, no tocado esta sesión.
  - ¿Outputs reproducibles e idempotentes? → Sí, 34_historico_pct_adecuado_costa_central.R usa overwrite=TRUE.
  - ¿Decisiones metodológicas como constantes nombradas? → Sí (COMUNAS_COSTA_CENTRAL_COD, DEPE2_SLEP).

## Minuta de resultados Simce por estándares de aprendizaje
- **slug:** `slep_simce_estandares_aprendizaje`
- **tipo de pendiente:** ninguno
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-05-27
- **próximos pasos:**
  - No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word).
  - 11.1 Pendientes activos
  - Incorporar datos SIMCE de un año nuevo al pipeline.

## Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio
- **slug:** `slep_reportes_modelo_resguardo_asistencia`
- **tipo de pendiente:** no_bloqueante
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-23
- **reseña del itinerario:** `slep_reportes_modelo_resguardo_asistencia` genera, por lote y cada mes, un reporte por director/a para los 73 establecimientos del SLEP Costa Central, implementando el "Modelo de Resguardo de la Asistencia Educativa del Territorio": un PDF (Quarto + typst + tinytable) más una planilla xlsx por establecimiento. Cada reporte muestra la asistencia del propio EE y su posición frente al territorio de forma anonimizada (percentiles y medianas, sin nombrar a otros EE) y cierra con la identificación nominal de los estudiantes en alerta del propio EE. Es variante de la minuta ejecutiva (`slep_minuta_…
- **próximos pasos:**
  - P78-6 (reclasificar las once etiquetas que conservan el veredicto retirado `indecidible`, única inconsistencia interna que la sesión deja en un documento de activa/). Después P77-4 y las dos decisiones del titular, que llevan cuatro cierres pendientes.
  - Archivos: 50_documentacion/activa/50_inventario_pendientes.md (nuevo); backlog entrada 405.
  - Categoría: Documentación, decisiones y gobernanza.

## slep_observatorio_medios
- **slug:** `slep_observatorio_medios`
- **tipo de pendiente:** funcionalidad
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-21
- **reseña del itinerario:** El Observatorio de Medios SLEP es un observatorio permanente de prensa sobre los Servicios Locales de Educación Pública de Chile, cuyo caso inicial es el SLEP Costa Central (Concón, Puchuncaví, Quintero y Viña del Mar). Produce una base histórica acumulativa de cobertura mediática clasificada con codebook versionado, indicadores comparables entre períodos, medios y servicios, informes periódicos y una biblioteca propia de las piezas capturadas. Se construye en R (Positron, Quarto, DuckDB) sobre un repositorio Git privado, para el Área de Monitoreo y Seguimiento de Procesos y Resultados Educat…
- **próximos pasos:**
  - Convertir la hoja de codificacion ciega ya guardada y calcular el alpha sobre la particion de validacion.
  - Inventario
  - Evaluación de deuda técnica

## slep_reporte_emergencia
- **slug:** `slep_reporte_emergencia`
- **tipo de pendiente:** verificacion_y_decision_titular
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-07-24
- **reseña del itinerario:** Panel web de emergencia del Área de Monitoreo del SLEP Costa Central: pipeline R que procesa el export del Microsoft Forms de reportes de afectación por establecimiento educacional y publica un sitio estático autocontenido en Cloudflare Pages tras Cloudflare Access, regenerado varias veces al día durante la contingencia. Fase 1 = reporte legible; Fase 2 = mapa Leaflet. Audiencia: equipo del Área y jefatura SLEP, también en celulares. Desde 2026-07-15.

## Análisis de trayectorias educativas interrumpidas
- **slug:** `slep_minuta_desvinculacion`
- **tipo de pendiente:** sin dato
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-30
- **próximos pasos:**
  - Inventario de pendientes
  - P-AUDITORIA: despachar el encargo de auditoría externa (2 acciones del titular: editar 37_validacion_predictiva.txt con fila agregada "otro…
  - Tarea 2 paso 3 (modelo B3): bloqueado por diseño hasta primera respuesta de auditoría.

## slep_minuta_matricula
- **slug:** `slep_minuta_matricula`
- **tipo de pendiente:** sin dato
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso

## Reseñas del portafolio
- **slug:** `slep_resena_proyectos`
- **tipo de pendiente:** sin dato
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso

