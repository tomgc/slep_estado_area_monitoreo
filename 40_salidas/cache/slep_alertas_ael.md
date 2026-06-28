---
slug: slep_alertas_ael
sello_ruta: slep_alertas_ael/50_documentacion/traspasos/traspaso-cierre-v02.md
sello_mtime: 2026-06-10
sello_hash: 9d5ac990f54efc4505dd96f8938ad088
semaforo: pausa
proximo_paso: verificar tipografia del documento, mover residuos, agregar tests unitarios
---
**Tipo de producto:** reporte.

El proyecto automatiza el aviso mensual a establecimientos educacionales del territorio que registran cupos sin asignar en el programa Anotate en la Lista del Ministerio de Educacion. A partir del reporte mensual de la plataforma y un registro de contactos institucionales, identifica los establecimientos con vacantes y lista de espera y genera, por cada uno, una comunicacion estandarizada lista para enviar, mas un resumen de respaldo. La ultima sesion formalizo el desarrollo: estructura canonica, arquitectura de dos raices (codigo en repositorio privado, datos en entorno institucional restringido), orquestador, validacion de schema, escaner, capa de gobernanza documental e integracion continua que bloquea archivos de datos e identificadores. El pipeline quedo verificado de punta a punta y funcionando.

Productos entregados: pipeline ejecutable, orquestador, escaner, repositorio con CI en verde y documentacion de gobernanza. Pendientes priorizados: verificacion visual de la tipografia del documento, ordenar residuos en la raiz de datos y agregar tests unitarios (hoy inexistentes). Sin bloqueantes. Deuda tecnica: ausencia de pruebas y un parametro de fecha de texto libre propenso a desactualizacion. Gobernanza: baja sensibilidad, no maneja datos de estudiantes; trabaja con antecedentes institucionales y contactos de referencia bajo normativa de datos personales. Sin dependencias con otros proyectos.

Procedencia: traspaso-cierre-v02 (2026-06-10); resena.
