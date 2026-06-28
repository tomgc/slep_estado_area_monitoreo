---
slug: slep_minuta_desvinculacion
sello_ruta: slep_minuta_desvinculacion/50_documentacion/traspasos/traspaso_cierre_v28.md
sello_mtime: 2026-06-28
sello_hash: e94224014d5a21fd6d44744909064f73
semaforo: activo
proximo_paso: construir capa de datos del reporte (script 39, P-DOC)
---
**Tipo de producto:** reporte.

El proyecto produce un analisis periodico de las trayectorias interrumpidas de estudiantes en el territorio del Servicio, para caracterizar la desvinculacion escolar y anticiparla mediante alerta temprana basada en asistencia previa. Combina registros administrativos de matricula/situacion y panel de asistencia con caracterizacion propia de los establecimientos educacionales, reconstruye la poblacion por periodo, identifica casos de desvinculacion en una ventana definida y estima riesgo con un modelo entrenado con anos anteriores. La ultima sesion cerro un commit de orquestacion, verifico que la validacion predictiva ya es produccion, resolvio el feedback de los indicadores (decisiones de alcance y discretizacion de tramos de riesgo) y diagnostico que la capa de datos del reporte aun no existe.

Productos a la fecha: pipeline de procesamiento operativo, dataset de entrenamiento y modelo validado. Pendientes priorizados: construir el productor unico de la capa de datos documental (bloqueante), luego el reporte Quarto; falta extraer la dimension de macrozona. Bloqueantes: insumo de planilla ausente para corrida integra; capa de datos documental inexistente. Deuda tecnica menor: residuos cosmeticos del renombrado de scripts. Sin despliegue publico; productos en contexto institucional cerrado. Gobernanza: si maneja datos personales sensibles de menores, confinados a entorno restringido y separados del codigo.

Procedencia: traspaso_cierre_v28 (2026-06-28); resena.
