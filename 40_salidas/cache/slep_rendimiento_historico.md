---
slug: slep_rendimiento_historico
sello_ruta: slep_rendimiento_historico/50_documentacion/traspasos/traspaso_cierre_v05.md
sello_mtime: 2026-06-15
sello_hash: e7ab018d126accaaab5487afeb79197f
semaforo: activo
proximo_paso: confirmar verificaciones visuales y tomar warning de duplicados en cohortes
---
**Tipo de producto:** reporte.

El proyecto reconstruye un diagnostico historico (mas de una decada) del rendimiento escolar de los establecimientos educacionales de un Servicio Local de Educacion, integrando promocion, reprobacion, retiro, asistencia y rezago, distinguiendo basica de media y comparando el territorio con referentes nacionales. El entregable es un reporte de doble publico: lectura ejecutiva para la conduccion y detalle por comuna y establecimiento educacional para equipos tecnicos, con analisis complementarios de desvinculacion, trayectorias de cohortes y movilidad. La ultima sesion cerro el sistema visual del reporte (fuentes de marca embebidas, portada editorial, salida HTML y docx verificadas end-to-end) y corrigio en raiz el denominador de las tasas de situacion final, alineandolo con la metodologia institucional de referencia.

Productos a la fecha: pipeline reproducible completo, salidas agregadas sin identificadores, reporte HTML/docx y una planilla auxiliar auditada sin discrepancias. Pendientes priorizados: verificacion visual del titular (no bloqueante), investigar un warning de registros estudiante-ano duplicados colapsados, unificar tokens de marca duplicados y migracion a control de versiones. Sin bloqueantes. Deuda tecnica: doble fuente de verdad de colores y posible problema de fuente en cohortes. Publicacion: salida autocontenida generada localmente, no versionada. Gobernanza: si maneja datos sensibles (registros individuales con identificadores nominativos), resguardados en entorno institucional restringido y fuera de los repositorios; los productos del diagnostico son agregados sin identificadores.

Procedencia: traspaso_cierre_v05 (2026-06-15); resena.
