---
slug: slep_minuta_asistencia
sello_ruta: slep_minuta_asistencia/50_documentacion/traspasos/traspaso-cierre-v64.md
sello_mtime: 2026-06-23
sello_hash: f4f231fa8d82dfa47581e67a8279ad24
semaforo: activo
proximo_paso: limpieza de estructura de documentacion, luego refactor del orquestador canonico
---
**Tipo de producto:** reporte.

La Minuta Mensual de Asistencia del SLEP Costa Central es un pipeline reproducible en R/Quarto que consolida los registros diarios de asistencia provistos por el Ministerio de Educacion y produce un reporte ejecutivo (Word mas graficos) con tasas de asistencia por territorio, comuna, macrogrupo de ensenanza, nivel y establecimiento educacional, ademas de rachas de inasistencia y alertas por umbrales de gestion. Esta dirigido a la conduccion del Servicio para apoyar la priorizacion y el seguimiento de metas. La ultima sesion fue multifrente: normalizo la configuracion de entorno, genero y audito las minutas de marzo, abril y mayo de 2026 (aptas para distribucion), y cerro el diseno de un proyecto separado de reporte para directores.

Productos entregados: minutas mensuales operativas y auditadas hasta mayo 2026. Pendientes priorizados: limpieza de estructura documental, refactor a orquestador canonico, y la minuta recurrente de junio. Sin bloqueantes. Deuda tecnica: nomenclatura mixta de traspasos (grafia historica CONTEXTO_VNN para las sesiones 10-35, vigente traspaso-cierre-vNN desde la 36) y override de ruta inactivo. Despliegue interno; no publicado. Gobernanza: si maneja datos personales sensibles de NNA (asistencia individual), resguardados en entorno restringido fuera del repositorio; solo se difunden agregados.

Procedencia: traspaso-cierre-v64 (2026-06-23); resena.
