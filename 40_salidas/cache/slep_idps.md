---
slug: slep_idps
sello_ruta: slep_idps/50_documentacion/traspasos/traspaso_cierre_v25.md
sello_mtime: 2026-06-25
sello_hash: b1706aa7e029220614d95b0091360a7e
semaforo: activo
proximo_paso: higiene de backlog y limpieza CSS pendientes en sesion 26
---
**Tipo de producto:** tablero/app.

El proyecto es un motor de comparacion interactivo de los Indicadores de Desarrollo Personal y Social (IDPS), publicado como una aplicacion web autocontenida que muestra resultados por establecimiento educacional, segmentados de forma permanente por grupo socioeconomico y sin agregacion territorial, con serie historica desde 2014 hasta 2025. La ultima sesion (cierre v25) verifico que la integracion del historico ya estaba completa, documento la cobertura y sus huecos (no aplicacion del instrumento) en cuatro capas, y entrego tres mejoras de la vista historica: valor de la media movil vigente, distancia respecto del grupo socioeconomico en el tooltip de indicador, y senaletica de significancia por barra para anios sin comparacion publicada.

Productos a la fecha: motor desplegado en produccion, parquet intacto, backlog consolidado en v25/147. Sin bloqueantes activos (un item depende de un proyecto hermano). Pendientes priorizados para la proxima sesion: higiene del backlog (subdividir la categoria de rediseno UI, ~34%), afinar prosa de documentacion y limpiar una regla CSS huerfana; mas adelante, suite/corpus y extraccion a paquete R interno. Deuda tecnica menor (CSS muerto, doble lectura de glifos) sin riesgo. Publicacion vigente via GitHub Pages con gate visual del titular antes de cada despliegue. Gobernanza: no maneja datos sensibles; trabaja solo con agregados publicos por establecimiento, depurados de identificadores personales.

Procedencia: traspaso_cierre_v25 (2026-06-25); resena; backlog_historico.
