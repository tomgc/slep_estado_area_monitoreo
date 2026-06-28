---
slug: slep_seguimiento_educacion_inicial
sello_ruta: slep_seguimiento_educacion_inicial/50_documentacion/traspasos/traspaso_cierre_v34.md
sello_mtime: 2026-06-24
sello_hash: 607d7e4de4396b570ffe4bc867e16fc0
semaforo: activo
proximo_paso: validar visualmente panel de detalle fijo del diagrama y commitear
---
**Tipo de producto:** tablero/app.

El proyecto es un analisis longitudinal de las preferencias de matricula de los egresados de jardines infantiles del territorio del Servicio Local, que sigue cohorte a cohorte la transicion desde la educacion parvularia hacia la escolar a lo largo de tres periodos academicos, distinguiendo permanencia en el Servicio, migracion a otro sostenedor, continuidad en el mismo jardin y casos no localizados. El producto es una aplicacion interactiva con diagramas de flujo, tablas comparativas y exportacion, organizada en un modulo restringido y uno de alcance territorial sobre datos abiertos. La ultima sesion cerro tres pendientes de saneamiento (portabilidad del escaner sin rutas absolutas, limpieza de la raiz, consolidacion del backlog historico) y abrio una funcionalidad de panel de detalle persistente bajo el diagrama de flujo.

El foco inmediato es validar visualmente ese panel de detalle y comprometerlo; el cambio esta aplicado en disco pero sin commitear ni validar (suite de pruebas en verde). Pendientes priorizados: ajuste cosmetico de etiquetas, dashboard estatico para directivos y puesta en servidor (diferidos). Bloqueantes: destino por establecimiento en el modulo territorial esta bloqueado por una compuerta de gobernanza; varias validaciones de calidad de datos esperan un insumo externo. Sin dependencias con otros proyectos. Deuda tecnica destacada: el escaner muta archivos versionados en cada corrida. Sin despliegue productivo aun. Gobernanza: si maneja datos sensibles (trayectorias individuales de ninos y ninas; identificadores restringidos en el modulo privado y enmascarados en el territorial).

Procedencia: traspaso_cierre_v34 (2026-06-24); resena; backlog_consolidado.
