---
slug: slep_aprendizajes_ep
sello_ruta: slep_aprendizajes_ep/50_documentacion/traspasos/traspaso_cierre_v83.md
sello_mtime: 2026-06-26
sello_hash: 0f855482040111714b774b588682b7e8
semaforo: activo
proximo_paso: versionar v83 y abordar capa 2 del ETL
---
**Tipo de producto:** reporte.

El proyecto construye un sistema de monitoreo de aprendizajes para la educacion parvularia que organiza resultados segun las Bases Curriculares de la Educacion Parvularia (ambito, nucleo y objetivo de aprendizaje) y los entrega como informes interactivos: una vista por establecimiento educacional y una vista central agregada del Servicio. Calcula cobertura y logro por nivel a lo largo de los tres momentos de evaluacion del ano. La ultima sesion cerro el diseno de la decision de priorizacion por momento e implemento su primera capa (generador de insumos y contrato de datos): produce un archivo de priorizacion por momento con una hoja por nivel macro, verificado visualmente sobre un caso de prueba sintetico.

Productos a la fecha: pipeline de ETL en R, generador de plantillas de captura, generador de informes interactivos y verificadores asociados. Pendientes priorizados: versionar el trabajo en disco y luego las capas 2 a 4 (lectura en el ETL, exposicion en el contrato JSON y render, auditoria). Bloqueante: item de asistencia detenido por falta de origen del dato. Deuda tecnica: portabilidad cross-OS de verificadores con rutas embebidas; estado transitorio en que el ETL cae a fallback hasta cerrar la capa 2 (no ejecutar el pipeline completo entretanto). Despliegue: nada versionado en la ultima sesion; informes en entorno institucional restringido. Gobernanza: si maneja datos sensibles, categoria datos personales de primera infancia; el detalle individual nunca se publica y las vistas de conjunto operan con informacion agregada.

Procedencia: traspaso_cierre_v83 (2026-06-26); resena; backlog_consolidado.
