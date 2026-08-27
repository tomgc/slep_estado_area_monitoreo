# Cartera de proyectos Área de Monitoreo

Generado: 2026-08-27 · 24 proyectos

> Versión texto del panorama visual (mismo orden y campos que las filas; orden por tipo_pendiente, estado y fecha).

## Monitoreo de aprendizajes en la educación parvularia
- **slug:** `slep_aprendizajes_ep`
- **tipo:** Monitoreo
- **tipo de pendiente:** bloqueante
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-18
- **síntesis:** En conjunto con la coordinación de Educación Parvularia del Área de Mejora Continua y siguiendo los principios de las Bases Curriculares de la Educación Parvularia vigentes, construimos un sistema de monitoreo de aprendizajes para la educación inicial del SLEP Costa Central. Este sistema organiza las evaluaciones realizadas por las educadoras por ámbito, núcleo y objetivo de aprendizaje y los presenta en informes interactivos que permiten segmentar los resultados por momento evaluativo (diagnóstico, primer semestre y segundo semestre) y diversos niveles de agrupación (territorio, jardín infantil, educadora y párvulo). Su aporte es hacer visible, en un mismo lugar, la cobertura curricular y el logro de los objetivos de aprendizaje a lo largo de los tres momentos de evaluación del año, lo que permite realizar un seguimiento longitudinal y una priorización pedagógica pertinente y oportuna para cada nivel de la educación inicial.
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
- **tipo:** Plataforma · CostaPresente
- **tipo de pendiente:** bloqueante
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-05-31
- **síntesis:** CostaPresente nace para apoyar el seguimiento de las trayectorias escolares de los estudiantes que, en algún momento de los últimos años, han pasado por algún establecimiento del SLEP Costa Central. A partir de registros mensuales de asistencia reconstruye, para cada estudiante, dónde ha estado matriculado y cómo ha evolucionado su escolaridad en términos de asistencia, promoción y retiros.
- **próximos pasos:**
  - Pendiente 1 (P1): Validación cross-OS en Windows
  - Descripción: Clonar el repo en una máquina Windows, configurar ~/.Renviron, verificar NBSP en ruta OneDrive, ejecutar pipeline ETL + App en…
  - Contexto: Todo el desarrollo y pruebas han sido en macOS arm64. Los colegas que usarán la app son usuarios Windows. La portabilidad real no…

## Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio
- **slug:** `slep_reportes_modelo_resguardo_asistencia`
- **tipo:** Reporte · Directores/as
- **tipo de pendiente:** bloqueante
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso
- **síntesis:** El Plan para el Fortalecimiento de la Asistencia Educativa del SLEP Costa Central fija como uno de sus objetivos establecer un marco institucional de trabajo en materia de asistencia para todos los establecimientos del territorio. Lo anterior se materializa a través del Modelo de Resguardo de la Asistencia Educativa del Territorio, el cual, además de orientaciones, planes de acción y actividades de socialización, evaluación y mejora, tiene como uno de sus componentes un reporte sobre esta temática dirigido a todos los directores y directoras del SLEP. Este reporte entrega información pertinente, oportuna, precisa y accionable sobre la asistencia de cada establecimiento. Tiene una frecuencia mensual e incluye, además de indicadores con distintos grados de segmentación, el detalle de cada estudiante que gatilla una de las alertas definidas como críticas para el resguardo de su trayectoria educativa.
- **reseña del itinerario:** `slep_reportes_modelo_resguardo_asistencia` genera, por lote y cada mes, un reporte por director/a para los 73 establecimientos del SLEP Costa Central, implementando el "Modelo de Resguardo de la Asistencia Educativa del Territorio": un PDF (Quarto + typst + tinytable) más una planilla xlsx por establecimiento. Cada reporte muestra la asistencia del propio EE y su posición frente al territorio de forma anonimizada (percentiles y medianas, sin nombrar a otros EE) y cierra con la identificación nominal de los estudiantes en alerta del propio EE. Es variante de la minuta ejecutiva (`slep_minuta_…
- **próximos pasos:**
  - Resolver P86-1 con decisión formal del titular: declarar el tratamiento de origen étnico en gobernanza_datos.md o dejar de exigir la columna. Es el único bloqueante que ocurre en cada corrida y no depende de ninguna medición pendiente.

## Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país
- **slug:** `slep_categoria_desempeno`
- **tipo:** Motor de comparación
- **tipo de pendiente:** deuda heredada
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-07-02
- **síntesis:** Las Categorías de Desempeño son uno de los componentes clave del Sistema de Aseguramiento de la Calidad de la Educación. Esta ordenación evalúa a cada establecimiento bajo un modelo de rendimiento ajustado al contexto, el cual cruza sus resultados educativos y formativos con el perfil de vulnerabilidad de sus estudiantes para determinar qué tan cerca o lejos están de lo esperado. Para facilitar el análisis de estos datos, desarrollamos una herramienta interactiva que organiza la información a escala nacional y permite explorarla de manera dinámica por comuna, Servicio Local de Educación Pública (SLEP), región y nivel país, distinguiendo con precisión la educación básica de la media. Su aporte es ofrecer, en una sola herramienta, dos lecturas complementarias: la distribución de los establecimientos por categoría en cada territorio y la evolución de cada establecimiento en el tiempo. Como la Categoría de Desempeño ya incorpora el contexto socioeconómico en su construcción, el motor presenta las clasificaciones tal como las publica la Agencia de Calidad de la Educación, sin segmentaciones adicionales.
- **reseña del itinerario:** slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que compara la distribución de establecimientos por Categoría de Desempeño (Alto / Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas, SLEPs, regiones y el nivel nacional, separando básica y media. Pipeline en R (xlsx → parquet → JSON embebido → HTML), publicado en GitHub Pages. Para el equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos públicos. (Nota v03: la opción "nacional" del selector se eliminó en la sesión 3 por volumen de EE; se agregó selección de establecimiento individual. …
- **próximos pasos:**
  - Re-clonar cualquier clon previo del repositorio, ya que el historial fue reescrito y los hashes anteriores dejaron de existir (acción manual del titular, una sola vez).
  - Qué: entrada 90 (incidente PII, ver traspaso v27 §4) agregada al
  - Por qué: v26 no generó entrada (mantenimiento de suite, precedente

## Minuta de asistencia mensual
- **slug:** `slep_minuta_asistencia`
- **tipo:** Minuta · Dirección Ejecutiva
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-08-22
- **síntesis:** La asistencia escolar es uno de los principales barómetros de la trayectoria educativa de un estudiante. En este contexto, la minuta mensual de asistencia surge a partir de una necesidad concreta para la gestión del servicio educativo gestionado por el SLEP Costa Central en el territorio. En este reporte, dirigido al Director Ejecutivo y construido a partir del análisis de los registros de asistencia diaria de cada estudiante del territorio, se le informa respecto a los principales indicadores que se desprenden de esta variable, segmentándola a nivel de territorio, comuna, tipo de enseñanza, establecimiento y nivel educativo, entre otros. Contiene una selección de alertas de inasistencia priorizadas para la toma de decisiones, así como una proyección de la asistencia anual basada en años anteriores.
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

## Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce
- **slug:** `slep_simce_adecuado`
- **tipo:** Motor de comparación
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-07-01
- **síntesis:** Desarrollamos un motor de comparación interactivo de los resultados de las pruebas Simce expresados según los estándares de aprendizaje, que clasifican el logro de los estudiantes en tres niveles: Adecuado, Elemental e Insuficiente. La herramienta organiza esta información a escala nacional, ponderando los resultados de cada prueba según el número de estudiantes que la rindió, permitiendo recorrer los resultados por establecimiento, comuna, SLEP, región y nivel nacional, a lo largo de todos los años para los cuales existen resultados. Su pantalla única de visualización pone especial atención en el nivel Adecuado (el más exigente) como indicador de logro, con la mirada puesta en cómo evoluciona en cada territorio y cómo se compara entre grupos socioeconómicos equivalentes.
- **próximos pasos:**
  - Regenerar el motor con `33_generar_html.R` y verificar visualmente la migración tipográfica, con foco en la tabla comparativa (contenedor `min-width:1000px`) y los popups RBD.
  - ¿Pipeline corre de cero sin intervención manual? → Sí, no tocado esta sesión.
  - ¿Outputs reproducibles e idempotentes? → Sí, 34_historico_pct_adecuado_costa_central.R usa overwrite=TRUE.

## Diagnóstico histórico del rendimiento escolar
- **slug:** `slep_rendimiento_historico`
- **tipo:** Diagnóstico
- **tipo de pendiente:** deuda tecnica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-15
- **síntesis:** Diagnóstico longitudinal y multidimensional de las bases de rendimiento escolar del Mineduc (2002-2025) con el propósito de caracterizar las trayectorias educativas de los estudiantes de los establecimientos educacionales del SLEP Costa Central y cuantificar las variaciones en las tasas de promoción y reprobación. Al vincular estas variables de resultado con la caracterización socioeducativa del estudiante (sexo registral, edad, país de origen, pertenencia a pueblos originarios y condición de alumno integrado, entre otras) y con las particularidades de los establecimientos (emplazamiento rural o urbano, tipos de enseñanza y régimen de jornada, entre otros), buscamos identificar brechas de equidad intra-territoriales, contrastar el desempeño del SLEP frente a otros territorios de la Región de Valparaíso y el nivel nacional y modelar sistemas de alerta temprana basados en la asistencia crónica y el rendimiento académico, para focalizar de forma oportuna y precisa los recursos pedagógicos y de apoyo psicosocial.
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
- **tipo:** Motor de comparación
- **tipo de pendiente:** deuda tecnica
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso
- **síntesis:** Los Indicadores de Desarrollo Personal y Social (IDPS) que la Agencia mide junto al Simce capturan aspectos que, si bien están planteados como no estrictamente académicos, resultan fundamentales para comprender de manera integral la experiencia educativa de los estudiantes. Estos indicadores (autoestima académica y motivación, clima de convivencia, participación y formación ciudadana, y hábitos de vida saludable) sirven de barómetro para leer en contexto los resultados de las pruebas académicas del Simce. Para analizar estos resultados, desarrollamos un motor de comparación interactivo que organiza y visualiza los resultados de todo el país y desde el inicio de su medición, a través del cual es posible navegar por los resultados actuales e históricos de un establecimiento, además de explorar uno o múltiples territorios de manera simultánea y comparativa.
- **reseña del itinerario:** `slep_idps` es un motor de visualización interactivo de los Indicadores de Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación. Produce un HTML autocontenido (React 18 + D3 v7 inline) publicado en GitHub Pages que muestra el dato por establecimiento educacional, sin agregación territorial, segmentado por grupo socioeconómico (GSE), con serie histórica 2014→2025. Para el equipo de Monitoreo y Seguimiento del SLEP Costa Central y, desde v05, para cualquier SLEP/comuna del país. Hermano de `slep_simce_adecuado` y `slep_categoria_desempeno`, de los que reutiliza catálogos…
- **próximos pasos:**
  - Item 11 (bloqueado, sin nueva información)
  - Tooltip "vs evaluación anterior": de title a body (cosmético, menor)

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
- **tipo:** Análisis longitudinal
- **tipo de pendiente:** nuevo
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-14
- **síntesis:** Para los párvulos y sus familias, las transiciones entre los niveles iniciales son momentos clave de su trayectoria educativa. Para un sostenedor, esta información es un insumo estratégico para la toma de decisiones en torno a las proyecciones del servicio educativo que ofrece. A partir de la sistematización y análisis de las preferencias de matrícula de los egresados de jardines infantiles del SLEP Costa Central, identificamos y visualizamos los itinerarios de los párvulos desde los niveles medios hacia los niveles de transición en las escuelas. El resultado es una aplicación interactiva con diagramas de flujo y tablas comparativas que permiten cuantificar el número de niños y niñas que permanecen en nuestras comunidades, cuántos migran a establecimientos de otros sostenedores y cuántos no se logran localizar. Su aporte es ofrecer al territorio una mirada de la continuidad de las trayectorias en un tramo crítico, con información útil para decisiones de oferta y de captación.
- **reseña del itinerario:** Seguimiento Educación Inicial es un sistema de análisis longitudinal de cohortes de párvulos para el SLEP Costa Central (Viña del Mar, Concón, Quintero, Puchuncaví). Rastrea transiciones de educación parvularia a básica en tres periodos académicos (2023→2024, 2024→2025, 2025→2026). Dos módulos: el privado (RUT real, retención en el directorio de 97 establecimientos SLEP CC) y el público (MRUN enmascarado, flujos territoriales entre todos los sostenedores de las cuatro comunas, sobre datos abiertos Mineduc). Interfaz Shiny offline unificada con selector de módulo, Sankey echarts4r, tablas reac…
- **próximos pasos:**
  - Inventario de pendientes vigentes
  - Auditoría de cierre (POLITICA §5.6)
  - #2 ¿pipeline corre de cero sin intervención? → Sí.

## Georreferenciación de establecimientos del territorio
- **slug:** `slep_georreferenciacion`
- **tipo de pendiente:** nuevo
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso

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
- **tipo:** Sistema de alertas
- **tipo de pendiente:** cosmetica
- **semaforo:** activo
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-09
- **síntesis:** El sistema de alertas de Anótate en la Lista (AEL) automatiza una tarea recurrente del trabajo de monitoreo de listas de espera: avisar a los establecimientos del territorio cuando registran vacantes sin asignar en AEL, que canaliza la búsqueda de cupos y matrícula. A partir del reporte quincenal que emite la Dirección de Educación Pública (DEP) a partir de los datos del Mineduc, el sistema identifica los establecimientos con vacantes y lista de espera y prepara, para cada uno, una comunicación personalizada lista para enviar a cada director o directora. Este mensaje incluye, para cada nivel del establecimiento, los cupos declarados, la matrícula actual y las vacantes sin asignar.
- **próximos pasos:**
  - Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos, ya que se generó en macOS (donde Aptos no viene preinstalada) y officer degrada en silencio.
  - Archivo(s) afectado(s): 30_procesamiento/31_alertas_establecimientos.R (usa validar_columnas() de 10_utils.R).
  - Categoría temática: Validación y robustez.

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
- **tipo:** Minuta · Dirección Ejecutiva
- **tipo de pendiente:** sin dato
- **semaforo:** sin dato
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-30
- **síntesis:** La desvinculación escolar, entendida como la interrupción de la trayectoria educativa de un estudiante, es uno de los fenómenos más sensibles para un servicio educativo y, habitualmente, se aborda cuando ya ha ocurrido. Para revertir esta lógica, este reporte analiza las trayectorias interrumpidas e irregulares de los estudiantes del SLEP Costa Central con el fin de caracterizar este fenómeno en el territorio y, fundamentalmente, anticipar su ocurrencia. Este documento, dirigido al Director Ejecutivo, se alimenta de los “Reportes para el seguimiento de estudiantes con trayectorias interrumpidas o irregulares” que el Centro de Estudios del Mineduc (CEM) presenta con regularidad trimestral. A partir de su procesamiento y cruce con los datos de asistencia diaria, además de otras variables sociodemográficas, se generan alertas tempranas orientadas a la acción, permitiendo la identificación de cohortes vulnerables, la priorización de establecimientos educacionales según su nivel de riesgo y la presentación de evidencia clave para el diseño de estrategias de intervención.
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

