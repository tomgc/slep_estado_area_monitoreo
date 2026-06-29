---
slug: slep_minuta_desvinculacion
sello_ruta: slep_minuta_desvinculacion/50_documentacion/traspasos/traspaso_cierre_v29.md
sello_mtime: 2026-06-29
sello_hash: 831d4d554eefc79ad2378327aa0dd511
semaforo: activo
proximo_paso: construir el .qmd del reporte como consumidor del dataset
---
**Tipo de producto:** reporte.

El proyecto produce un analisis periodico de trayectorias escolares interrumpidas para un servicio educativo territorial de cuatro comunas: identifica y caracteriza a estudiantes desvinculados (dos cohortes: retiro formal y no re-matricula) e incorpora alerta temprana mediante un modelo de riesgo entrenado con asistencia previa. La sesion v29 cerro la capa de datos del reporte: se creo el productor unico del conjunto de datos del documento (paso 8 del orquestador), que materializa un universo acotado de estudiantes por establecimiento con cobertura demografica casi completa y sin avisos de integridad; ejecucion validada. Productos a la fecha: pipeline completo de procesamiento, conjunto de entrenamiento, modelo predictivo validado y dataset del documento en disco.

Pendientes priorizados: empujar el commit de cierre al remoto; fijar la funcion de tramos de riesgo; y construir el reporte (Fase 4), entregable final aun no iniciado pero ya desbloqueado. Sin bloqueantes; dependencias internas entre tramos y secciones del reporte. Deuda tecnica: refactor de cruce de cohortes a funciones compartidas y ampliacion del catalogo de establecimientos para dos indicadores diferidos. Publicacion: circulacion institucional cerrada, sin exposicion publica. Gobernanza: SI maneja datos sensibles de NNA (identificadores, asistencia, matricula), con datos confinados a entorno restringido y separados del codigo; desde la sesion anterior se agrego gobernanza_datos.md (cierre de H4).

Procedencia: traspaso_cierre_v29 (2026-06-29); resena.
