---
slug: slep_reportes_modelo_resguardo_asistencia
sello_ruta: slep_reportes_modelo_resguardo_asistencia/50_documentacion/traspasos/traspaso_cierre_v38.md
sello_mtime: 2026-06-21
sello_hash: 147be45bc1d6f69394a4dfc99c100e1d
semaforo: activo
proximo_paso: auditoria portabilidad cross-OS Windows que destraba variable canonica fase 2
---
**Tipo de producto:** reporte.

Proyecto que genera mensualmente, por lote, un reporte por direccion para todos los establecimientos educacionales del territorio, implementando el Modelo de Resguardo de la Asistencia Educativa. Cada entrega combina un PDF (Quarto, typst, tinytable) y una planilla por establecimiento: describe la asistencia propia, la situa de forma anonimizada frente al territorio y a un grupo de vulnerabilidad similar (percentiles y medianas, sin nominar a otros establecimientos), y cierra con alertas nominales de estudiantes del propio establecimiento. La ultima sesion fue puramente documental: dejo el backlog acumulativo al dia como fuente viva, sin cambios de logica ni pipeline. Productos entregados: pipeline reproducible con corrida de lote completa exitosa y suite de documentacion.

Pendientes priorizados: auditoria de portabilidad cross-OS, auditoria linea a linea del pipeline, retiro de fallback de variable de entorno y pulido de advertencias de render. Sin bloqueantes activos; el repositorio esta al dia. Dependencia: es variante de la minuta ejecutiva de asistencia, ya desacoplada en una capa propia. Deuda tecnica: esquema dual de caracterizacion e insumos en almacenamiento externo. Despliegue estable, ejecucion mensual sistematica. Gobernanza: si maneja datos sensibles, categoria reforzada por tratarse de datos de ninos, ninas y adolescentes (Ley 21.719), con acceso individual restringido a la propia direccion.

Procedencia: traspaso_cierre_v38 (2026-06-21); resena; backlog_acumulativo.
