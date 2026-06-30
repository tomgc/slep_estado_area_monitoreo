# Panorama visual de la cartera — Área de Monitoreo

Generado: 2026-06-29 · 16 proyectos

> Versión texto del panorama visual (mismo orden y campos que las cards).

## Análisis de trayectorias educativas interrumpidas
- **slug:** `slep_minuta_desvinculacion`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-29
- **próximos pasos:**
  - Inventario de pendientes
  - §1.5 diferencia_matricula (caracterización EE, 6 cols actuales no la tienen).
  - §4.6 tipos_ensenanza_ee (ídem).

## Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce
- **slug:** `slep_simce_adecuado`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-29
- **próximos pasos:**
  - Regenerar suite si cambia contenido de documentar.R (requiere npm + red).
  - Actualización anual de insumos Simce (cuando la Agencia publique 2025 final o 2026).
  - Incorporar entradas 121–124 del backlog en la próxima sesión que registre cambios.

## Georreferenciación de establecimientos del territorio
- **slug:** `slep_georreferenciacion`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-28
- **próximos pasos:**
  - Inventario de pendientes
  - Auditoría de cierre (política 5.6, preguntas "Cierre")
  - ¿Pipeline corre de cero sin intervención manual? Parcial: 30_preparar_comunas.R y 33b

## Monitoreo de aprendizajes en la educación parvularia
- **slug:** `slep_aprendizajes_ep`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-26

## Portafolio del Área (escaparate web)
- **slug:** `slep_monitoreo`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-26
- **rese<c3><b1>a del itinerario:** El sitio `tomgc.github.io/slep_monitoreo` es una página estática institucional de presentación del Área de Monitoreo de Procesos y Resultados Educativos, dentro de la Subdirección de Apoyo Técnico Pedagógico del SLEP Costa Central. Es single-page, sin dependencias externas, alojado en GitHub Pages. Su propósito es comunicar qué hace el Área, su trayectoria, ejemplos de trabajo, su equipo y un glosario técnico. El desarrollo se inició el 2026-04-09 (commit base v1.2) y la primera sesión documentada con cierre de traspaso es el 2026-05-25 (esta).
- **próximos pasos:**
  - Inventario de pendientes
  - Tipo: contenido. Impacto: medio. El proyecto "Minutas de resultados de las pruebas Simce" se eliminó de data.js en v05; el usuario aportará…
  - Enfoque: pedir los 3 PDF, redactar objetivo + síntesis, asignar id (sugerido simce_cc), insertar con su orden; luego sus capturas siguiendo…

## Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS)
- **slug:** `slep_idps`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-25
- **rese<c3><b1>a del itinerario:** `slep_idps` es un motor de visualización interactivo de los Indicadores de Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación. Produce un HTML autocontenido (React 18 + D3 v7 inline) publicado en GitHub Pages que muestra el dato por establecimiento educacional, sin agregación territorial, segmentado por grupo socioeconómico (GSE), con serie histórica 2014→2025. Para el equipo de Monitoreo y Seguimiento del SLEP Costa Central y, desde v05, para cualquier SLEP/comuna del país. Hermano de `slep_simce_adecuado` y `slep_categoria_desempeno`, de los que reutiliza catálogos…
- **próximos pasos:**
  - Qué: se verificó que el histórico 2014–2025 ya está integrado en el parquet (rama 3b del 34), idempotente (md5 intacto tras re-correr), y s…
  - Por qué (R10): el pendiente heredado describía premisas falsas. No se fabricó trabajo de integración inexistente (B.1); se reorientó a docu…
  - Cobertura real (verificada contra parquet): indicador 2014–2025; dimensión 2018 + 2022–2025; niveles 2023–2025 (2024 para 6b/8b). Por grado…

## Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio
- **slug:** `slep_reportes_modelo_resguardo_asistencia`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-20
- **rese<c3><b1>a del itinerario:** `slep_reportes_modelo_resguardo_asistencia` genera, por lote y cada mes, un reporte por director/a para los 73 establecimientos del SLEP Costa Central, implementando el "Modelo de Resguardo de la Asistencia Educativa del Territorio": un PDF (Quarto + typst + tinytable) más una planilla xlsx por establecimiento. Cada reporte muestra la asistencia del propio EE y su posición frente al territorio de forma anonimizada (percentiles y medianas, sin nombrar a otros EE) y cierra con la identificación nominal de los estudiantes en alerta del propio EE. Es variante de la minuta ejecutiva (`slep_minuta_…
- **próximos pasos:**
  - Inventario de pendientes
  - Auditoría de cierre (política 5.6)
  - ¿Pipeline corre de cero sin intervención manual? → Sí (sin cambios de pipeline esta sesión;

## Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país
- **slug:** `slep_categoria_desempeno`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-19
- **rese<c3><b1>a del itinerario:** slep_categoria_desempeno es un motor interactivo (R + HTML autocontenido) que compara la distribución de establecimientos por Categoría de Desempeño (Alto / Medio / Medio-Bajo / Insuficiente) de la Agencia de Calidad, entre comunas, SLEPs, regiones y el nivel nacional, separando básica y media. Pipeline en R (xlsx → parquet → JSON embebido → HTML), publicado en GitHub Pages. Para el equipo de Monitoreo del SLEP Costa Central, desde 2026. Datos públicos. (Nota v03: la opción "nacional" del selector se eliminó en la sesión 3 por volumen de EE; se agregó selección de establecimiento individual. …
- **próximos pasos:**
  - Inventario de pendientes
  - Evaluación de deuda técnica
  - Auditoría de cierre (política 5.6)

## Minuta de asistencia mensual
- **slug:** `slep_minuta_asistencia`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-15
- **próximos pasos:**
  - Inventario de pendientes
  - Tipo: deuda técnica / refactor estructural. Complejidad: Media. Estado: aprobado, no iniciado.
  - Qué: partir 32_render_minuta.R (hoy hace prep+render+SVG en un archivo) en pasos atómicos, para que 00_run_all.R orqueste con from/to/only/…

## Diagnóstico histórico del rendimiento escolar
- **slug:** `slep_rendimiento_historico`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-15
- **próximos pasos:**
  - Ancla de sanidad CEM: promoción municipal-nacional ≈ 94% (2023) en el HTML.
  - Abrir el .docx y confirmar estilos de marca.
  - P24 (nuevo) — Warning de Módulo B: "micro CC: 7406 registros

## Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles
- **slug:** `slep_seguimiento_educacion_inicial`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-14
- **rese<c3><b1>a del itinerario:** Seguimiento Educación Inicial es un sistema de análisis longitudinal de cohortes de párvulos para el SLEP Costa Central (Viña del Mar, Concón, Quintero, Puchuncaví). Rastrea transiciones de educación parvularia a básica en tres periodos académicos (2023→2024, 2024→2025, 2025→2026). Dos módulos: el privado (RUT real, retención en el directorio de 97 establecimientos SLEP CC) y el público (MRUN enmascarado, flujos territoriales entre todos los sostenedores de las cuatro comunas, sobre datos abiertos Mineduc). Interfaz Shiny offline unificada con selector de módulo, Sankey echarts4r, tablas reac…
- **próximos pasos:**
  - Inventario de pendientes vigentes
  - Auditoría de cierre (POLITICA §5.6)
  - #2 ¿pipeline corre de cero sin intervención? → Sí.

## Sistema de alertas de Anótate en la Lista
- **slug:** `slep_alertas_ael`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-06-09
- **próximos pasos:**
  - Archivo(s) afectado(s): 30_procesamiento/31_alertas_establecimientos.R (usa validar_columnas() de 10_utils.R).
  - Categoría temática: Validación y robustez.
  - Qué se hizo: Tras cada read_excel(), verificación de las 8 columnas esperadas de AEL y las 3 de correos; error descriptivo con columnas fal…

## CostaPresente
- **slug:** `slep_costapresente`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-05-31
- **próximos pasos:**
  - Pendiente 1 (P1): Validación cross-OS en Windows
  - Descripción: Clonar el repo en una máquina Windows, configurar ~/.Renviron, verificar NBSP en ruta OneDrive, ejecutar pipeline ETL + App en…
  - Contexto: Todo el desarrollo y pruebas han sido en macOS arm64. Los colegas que usarán la app son usuarios Windows. La portabilidad real no…

## Minuta de resultados Simce por estándares de aprendizaje
- **slug:** `slep_simce_estandares_aprendizaje`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-05-27
- **próximos pasos:**
  - 11.1 Pendientes activos
  - Incorporar datos SIMCE de un año nuevo al pipeline.
  - Actualizar o extender gráficos G1–G6.

## Dashboard personal de monitoreo
- **slug:** `slep_dashboard_personal_monitoreo`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** 2026-05-25
- **próximos pasos:**
  - Archivo(s) afectado(s): docs/traspaso/traspaso_cierre_v17.md (nuevo), docs/referencia/principios_desarrollo_v3.md (eliminado).
  - Categoría temática: Mecánica de PR / Incorporación de traspaso.
  - Qué se hizo: Una segunda sesión de Claude Code se abrió desde la ruta nueva /Users/tomgc/Projects/slep_dashboard_personal_monitoreo/. Se di…

## Reseñas del portafolio
- **slug:** `slep_resena_proyectos`
- **estado:** sin clasificar
- **datos sensibles:** sin clasificar
- **última actualización:** sin traspaso

