---
slug: slep_categoria_desempeno
sello_ruta: slep_categoria_desempeno/50_documentacion/traspasos/traspaso_cierre_v25.md
sello_mtime: 2026-06-21
sello_hash: 5f4f7a12e7371f42b83935016b2a4b2a
semaforo: pausa
proximo_paso: versionar traspaso v25 y snapshot del escaner al reabrir
---
**Tipo de producto:** tablero/app.

El proyecto es un motor de comparacion interactivo (R + HTML autocontenido) de la Categoria de Desempeno que la Agencia de Calidad asigna a los establecimientos educacionales del pais. Integra varios anos de clasificaciones y permite recorrer su distribucion por comuna, Servicio Local, region y nivel nacional, separando educacion basica y media, y seguir la trayectoria de cada establecimiento. Productos entregados: pipeline en R (planilla -> parquet -> JSON embebido -> HTML), aplicacion web standalone publicada de forma abierta en una pagina estatica, suite de documentacion, capa de auditoria de cifras por doble calculo y backlog consolidado. La ultima sesion fue administrativa de cierre (consolidacion de backlog, versionado de traspaso, rotacion de snapshots), sin trabajo sustantivo de codigo.

Sin bloqueantes: el proyecto se declara estable, portable y sincronizado, sin trabajo forzoso pendiente. Pendientes priorizados, todos menores y opcionales: consolidacion administrativa de apertura, limpieza de residuos en disco y validacion empirica cross-OS. Deuda tecnica viva: ninguna; el unico patron a vigilar es de proceso (cierre completo de control de versiones). Dependencias con proyectos hermanos (matricula, idps) constan a nivel de insumos. Despliegue activo y reproducible. Gobernanza: no maneja datos sensibles; trabaja solo con datos publicos agregados por establecimiento, sin informacion personal de estudiantes ni funcionarios.

Procedencia: traspaso_cierre_v25 (2026-06-21); resena; backlog_consolidado.
