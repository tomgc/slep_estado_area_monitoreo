---
slug: slep_dashboard_personal_monitoreo
sello_ruta: slep_dashboard_personal_monitoreo/50_documentacion/traspasos/traspaso_cierre_v17.md
sello_mtime: 2026-05-26
sello_hash: 36f61886a281487431e31e0b1336fd37
semaforo: pausa
proximo_paso: ejecutar migracion estructural y materializar plantilla y contratos de consolidado
---
**Tipo de producto:** tablero/app.

Sin resena; estado derivado del ultimo traspaso. Objetivo (declarado en README/traspaso): herramienta personal interna de monitoreo y seguimiento que consolida indicadores esenciales en un dashboard HTML autocontenido, regenerado reproduciblemente desde datos crudos, cubriendo dominios de asistencia, desvinculacion, SIMCE, educacion inicial y contexto territorial mas una vista ejecutiva. La ultima sesion cerro un pendiente de incorporacion documental via PR, diagnostico que la validacion numerica esta bloqueada y pivoto a disenar contratos formales entre el dashboard y sus sistemas emisores. Productos a la fecha: estructura base y helpers de render operativos contra un fixture demo sanitizado; funciones de calculo para dos dominios maduros; plantilla de contrato de consolidado aprobada (aun no escrita al repo) y mapa de dominios/emisores.

Pendientes priorizados: migracion estructural del repo, materializacion de plantilla y cinco contratos, y validacion numerica. Bloqueante principal: no existe canal formal por el cual los emisores depositen consolidados accesibles; variable de ruta de datos apunta a ubicacion obsoleta. Dependencias: sistemas emisores hermanos de asistencia, desvinculacion, SIMCE y educacion inicial (solo dos maduros). Deuda/riesgo: asimetria estructural con la convencion del Area y nomenclatura de contrato bilateral pendiente. Publicacion: no desplegado; render solo local. Gobernanza: si maneja datos sensibles (el repositorio los excluye y consume desde ruta externa). Frescura: ultima actividad hace mas de tres semanas (señal de obsolescencia documental, no de error).

Procedencia: traspaso_cierre_v17 (2026-05-26); sin resena.
