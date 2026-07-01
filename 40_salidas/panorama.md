# Panorama de la cartera - Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos

> Generado: 2026-07-01 · Proyectos activos: 15 · Auxiliares: 2

## Alertas

- **Bloqueados:** ninguno.
- **Nuevos detectados:** slep_paes.
- **Dados de baja:** ninguno.
- **Documentacion obsoleta (>21 dias):** slep_dashboard_personal_monitoreo, slep_simce_estandares_aprendizaje.
- **Pendientes de sintesis:** slep_minuta_asistencia, slep_paes, slep_simce_adecuado.

## L1 - Tabla semaforo

| Codigo | Nombre | Semaforo | Ultima actividad | Proximo paso |
|---|---|---|---|---|
| slep_alertas_ael | Sistema de alertas de Anótate en la Lista | pausa | 2026-06-10 (hace 21 dias) | verificar tipografia del documento, mover residuos, agregar tests unitarios |
| slep_aprendizajes_ep | Monitoreo de aprendizajes en la educación parvularia | activo | 2026-06-29 (hace 2 dias) | Versionar primero los 3 archivos de v83 y luego implementar la capa 2 de D013 (ETL `32_etl.R`) para que el ETL deje de caer a fallback. |
| slep_categoria_desempeno | Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país | activo | 2026-07-01 (hace 0 dias) | Consolidación administrativa de apertura (s26): versionar este traspaso v25 y el snapshot del escáner generado tras el último push de s25. |
| slep_costapresente | CostaPresente | pausa | 2026-06-24 (hace 7 dias) | validar pipeline cross-OS en maquina Windows |
| slep_dashboard_personal_monitoreo | Dashboard personal de monitoreo | pausa | 2026-05-26 (hace 36 dias) | ejecutar migracion estructural y materializar plantilla y contratos de consolidado |
| slep_georreferenciacion | Georreferenciación de establecimientos del territorio | pausa | 2026-06-29 (hace 2 dias) | esperar validacion del director sobre ambas variantes del afiche |
| slep_idps | Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) | activo | 2026-06-25 (hace 6 dias) | Abordar la higiene de bajo riesgo no alcanzada en s25: resolver `# REVISAR (voz)` en `documentar.R` y subdividir la categoría "Rediseño UI" del backlog. |
| slep_minuta_asistencia | Minuta de asistencia mensual | activo | 2026-07-01 (hace 0 dias) | limpieza de estructura de documentacion, luego refactor del orquestador canonico |
| slep_minuta_desvinculacion | Análisis de trayectorias educativas interrumpidas | activo | 2026-06-30 (hace 1 dias) | Abordar el residuo de `flextable` en `00_run_all.R`: leer primero `41_minuta_desvinculacion_T2_2025.qmd` completo para confirmar si `flextable` aún se usa o es residuo, y si lo es, entregar `00_run_all.R` corregido. |
| slep_paes | slep_paes | (pendiente) | 2026-07-01 (hace 0 dias) | (pendiente de sintesis) |
| slep_rendimiento_historico | Diagnóstico histórico del rendimiento escolar | activo | 2026-06-15 (hace 16 dias) | Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente. |
| slep_reportes_modelo_resguardo_asistencia | Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio | activo | 2026-06-21 (hace 10 dias) | Abordar un pendiente de fondo: la auditoría de portabilidad cross-OS Windows (que además destraba P-VAR-CANONICA fase 2, tipo deuda técnica) o la auditoría línea a línea del pipeline. |
| slep_seguimiento_educacion_inicial | Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles | activo | 2026-06-24 (hace 7 dias) | validar visualmente panel de detalle fijo del diagrama y commitear |
| slep_simce_adecuado | Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce | cerrado | 2026-07-01 (hace 0 dias) | mantenimiento documental concluido; estable y desplegado sin pendientes activos |
| slep_simce_estandares_aprendizaje | Minuta de resultados Simce por estándares de aprendizaje | activo | 2026-05-28 (hace 34 dias) | No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word). |

## L2 - Fichas ejecutivas por proyecto activo

### slep_alertas_ael - Sistema de alertas de Anótate en la Lista _(fuente: PULL)_
**Tipo de producto:** reporte.

El proyecto automatiza el aviso mensual a establecimientos educacionales del territorio que registran cupos sin asignar en el programa Anotate en la Lista del Ministerio de Educacion. A partir del reporte mensual de la plataforma y un registro de contactos institucionales, identifica los establecimientos con vacantes y lista de espera y genera, por cada uno, una comunicacion estandarizada lista para enviar, mas un resumen de respaldo. La ultima sesion formalizo el desarrollo: estructura canonica, arquitectura de dos raices (codigo en repositorio privado, datos en entorno institucional restringido), orquestador, validacion de schema, escaner, capa de gobernanza documental e integracion continua que bloquea archivos de datos e identificadores. El pipeline quedo verificado de punta a punta y funcionando.

Productos entregados: pipeline ejecutable, orquestador, escaner, repositorio con CI en verde y documentacion de gobernanza. Pendientes priorizados: verificacion visual de la tipografia del documento, ordenar residuos en la raiz de datos y agregar tests unitarios (hoy inexistentes). Sin bloqueantes. Deuda tecnica: ausencia de pruebas y un parametro de fecha de texto libre propenso a desactualizacion. Gobernanza: baja sensibilidad, no maneja datos de estudiantes; trabaja con antecedentes institucionales y contactos de referencia bajo normativa de datos personales. Sin dependencias con otros proyectos.

Procedencia: traspaso-cierre-v02 (2026-06-10); resena.

### slep_aprendizajes_ep - Monitoreo de aprendizajes en la educación parvularia _(fuente: PUSH)_
## En que vamos
Se cerró el diseño de la Decisión 013 (priorización por momento) y se implementó su capa 1: el generador `36_generar_priorizacion.R` produce 72 libros por momento con una hoja por macro, más el contrato §2.ter reconciliado. Todo verificado visualmente en el gemelo, pero quedó en disco SIN versionar (la sesión no hizo operaciones git). El ETL sigue leyendo el formato viejo y cae a fallback, por lo que no debe correrse run_all ni el ETL hasta cerrar la capa 2.

## Proximo paso
Versionar primero los 3 archivos de v83 y luego implementar la capa 2 de D013 (ETL `32_etl.R`) para que el ETL deje de caer a fallback.

## Bloqueantes
ninguno

### slep_categoria_desempeno - Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país _(fuente: PUSH)_
## En que vamos
El proyecto está estable, portable, documentado y sincronizado en origin/main; el pipeline está operativo sin cambios desde v21 y no hay trabajo forzoso pendiente. La sesión 25 fue puramente administrativa: consolidó la entrada 89 del backlog y versionó el traspaso v24, en tres commits atómicos con árbol limpio. No se identifican bugs ni deuda técnica viva.

## Proximo paso
Consolidación administrativa de apertura (s26): versionar este traspaso v25 y el snapshot del escáner generado tras el último push de s25.

## Bloqueantes
ninguno

### slep_costapresente - CostaPresente _(fuente: PULL)_
**Tipo de producto:** tablero/app.

Aplicacion local de seguimiento de trayectorias escolares para un servicio local de educacion que cubre cuatro comunas y del orden de varias decenas de establecimientos educacionales y unos veinte mil estudiantes. Reune registros mensuales de matricula y asistencia (fuente: Centro de Estudios del Ministerio de Educacion) en un pipeline de dos pasos: un ETL que normaliza planillas y produce archivos columnar, y una app que permite consultar la trayectoria individual de un estudiante (recorrido entre establecimientos, asistencia, retiros, alta movilidad) mas una vista agregada del territorio con deteccion de casos que desaparecen sin baja formal.

La ultima sesion cerro la estabilizacion de infraestructura post-migracion: centralizacion de gestion de paquetes, auto-ejecucion del orquestador, scanner de estructura y diagrama de arquitectura; el pipeline corre end-to-end en macOS. Pendiente priorizado y bloqueante para produccion: validacion cross-OS en Windows (los usuarios finales operan Windows); pendiente menor: actualizar diagrama del instructivo. Deuda tecnica: app monolitica y umbrales hardcodeados; instructivo binario fuera de control de versiones. Sin despliegue publico: opera local, sin versionar datos. Gobernanza: si maneja datos personales sensibles de ninos, ninas y adolescentes, con resguardo estricto fuera del repositorio.

Procedencia: traspaso-cierre-v01 (2026-06-24); resena.

### slep_dashboard_personal_monitoreo - Dashboard personal de monitoreo _(fuente: PULL)_
**Tipo de producto:** tablero/app.

Sin resena; estado derivado del ultimo traspaso. Objetivo (declarado en README/traspaso): herramienta personal interna de monitoreo y seguimiento que consolida indicadores esenciales en un dashboard HTML autocontenido, regenerado reproduciblemente desde datos crudos, cubriendo dominios de asistencia, desvinculacion, SIMCE, educacion inicial y contexto territorial mas una vista ejecutiva. La ultima sesion cerro un pendiente de incorporacion documental via PR, diagnostico que la validacion numerica esta bloqueada y pivoto a disenar contratos formales entre el dashboard y sus sistemas emisores. Productos a la fecha: estructura base y helpers de render operativos contra un fixture demo sanitizado; funciones de calculo para dos dominios maduros; plantilla de contrato de consolidado aprobada (aun no escrita al repo) y mapa de dominios/emisores.

Pendientes priorizados: migracion estructural del repo, materializacion de plantilla y cinco contratos, y validacion numerica. Bloqueante principal: no existe canal formal por el cual los emisores depositen consolidados accesibles; variable de ruta de datos apunta a ubicacion obsoleta. Dependencias: sistemas emisores hermanos de asistencia, desvinculacion, SIMCE y educacion inicial (solo dos maduros). Deuda/riesgo: asimetria estructural con la convencion del Area y nomenclatura de contrato bilateral pendiente. Publicacion: no desplegado; render solo local. Gobernanza: si maneja datos sensibles (el repositorio los excluye y consume desde ruta externa). Frescura: ultima actividad hace mas de tres semanas (señal de obsolescencia documental, no de error).

Procedencia: traspaso_cierre_v17 (2026-05-26); sin resena.

### slep_georreferenciacion - Georreferenciación de establecimientos del territorio _(fuente: PULL)_
**Tipo de producto:** cartografia.

Sin resena; estado derivado del ultimo traspaso. El objetivo declarado es un afiche cartografico A0 (imprimible en plotter) que georreferencia los establecimientos educacionales del SLEP Costa Central en cuatro comunas costeras, en dos variantes: una con inset y otra de escala unica continua. La sesion v05 (CONTINUATION) construyo y audito la variante de escala unica encargada en v04: verificacion del repo tras una purga de historial, ejecucion y auditoria de la Fase 1, correccion de una regresion de posicionamiento de una etiqueta de comuna (offset calibrado por codigo mas un switch de reuso de render) y pulido editorial manual de cuatro etiquetas en una herramienta externa, con exportacion del PDF apto para plotter.

Productos a la fecha: ambas variantes generadas, auditadas y commiteadas; la variante original permanece byte-identica. Pendientes priorizados: validacion externa con el director (bloqueante para publicar), validacion in situ de fuentes y posiciones de etiquetas en la herramienta editorial, y deudas menores (documentar locale UTF-8 y origen redescargable de los limites comunales, verificar constantes muertas, re-correr el escaner de estructura, decidir si cablear pasos opcionales al orquestador). Bloqueantes: aprobacion del director pendiente; el proyecto queda en espera. Dependencias: locale UTF-8 obligatorio, navegador para exportar PDF, herramienta editorial externa para el pulido no reproducible. Deuda tecnica/riesgos: el pulido editorial de etiquetas no es reproducible por diseno; escaner desactualizado. Publicacion: en espera de validacion. Gobernanza: identificadores institucionales publicos; sin datos personales ni de estudiantes.

Procedencia: traspaso_cierre_v05 (2026-06-29); sin resena.

### slep_idps - Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) _(fuente: PUSH)_
## En que vamos
La sesión 25 abrió con el pendiente de integrar el IDPS histórico 2014–2019 y descubrió, contrastando contra el código real, que ya estaba integrado (parquet 2014–2025, motor mostrando la serie); el trabajo se reorientó a documentar la cobertura y la razón de sus huecos. Sobre eso se hicieron cuatro mejoras de UI en la vista histórica: corrección de texto, reubicación de la leyenda de media móvil, exposición de su valor (cabecera + tooltip) con distancia vs GSE, y señalética de significancia por barra. Cierre con deploy, push de toda la sesión y working tree limpio.

## Proximo paso
Abordar la higiene de bajo riesgo no alcanzada en s25: resolver `# REVISAR (voz)` en `documentar.R` y subdividir la categoría "Rediseño UI" del backlog.

## Bloqueantes
ninguno

### slep_minuta_asistencia - Minuta de asistencia mensual _(fuente: PULL)_
**Tipo de producto:** reporte.

La Minuta Mensual de Asistencia del SLEP Costa Central es un pipeline reproducible en R/Quarto que consolida los registros diarios de asistencia provistos por el Ministerio de Educacion y produce un reporte ejecutivo (Word mas graficos) con tasas de asistencia por territorio, comuna, macrogrupo de ensenanza, nivel y establecimiento educacional, ademas de rachas de inasistencia y alertas por umbrales de gestion. Esta dirigido a la conduccion del Servicio para apoyar la priorizacion y el seguimiento de metas. La ultima sesion fue multifrente: normalizo la configuracion de entorno, genero y audito las minutas de marzo, abril y mayo de 2026 (aptas para distribucion), y cerro el diseno de un proyecto separado de reporte para directores.

Productos entregados: minutas mensuales operativas y auditadas hasta mayo 2026. Pendientes priorizados: limpieza de estructura documental, refactor a orquestador canonico, y la minuta recurrente de junio. Sin bloqueantes. Deuda tecnica: nomenclatura mixta de traspasos (grafia historica CONTEXTO_VNN para las sesiones 10-35, vigente traspaso-cierre-vNN desde la 36) y override de ruta inactivo. Despliegue interno; no publicado. Gobernanza: si maneja datos personales sensibles de NNA (asistencia individual), resguardados en entorno restringido fuera del repositorio; solo se difunden agregados.

Procedencia: traspaso-cierre-v64 (2026-06-23); resena.

### slep_minuta_desvinculacion - Análisis de trayectorias educativas interrumpidas _(fuente: PUSH)_
## En que vamos
La sesión S37 cerró la Prioridad 1 de higiene de repo destapada en S36: des-trackeó 10 archivos ya cubiertos por el `.gitignore` y renombró `.env.example` a `.Renviron.example`, corrigiendo de paso una exclusión funcional rota en el CI y actualizando tres deudas del README ya resueltas. Se hicieron dos commits atómicos limpios, ninguno pusheado (rama ahead 18 de origin). El pipeline no se tocó; sin regresiones esperadas y sin bugs de código en la sesión.

## Proximo paso
Abordar el residuo de `flextable` en `00_run_all.R`: leer primero `41_minuta_desvinculacion_T2_2025.qmd` completo para confirmar si `flextable` aún se usa o es residuo, y si lo es, entregar `00_run_all.R` corregido.

## Bloqueantes
ninguno

### slep_paes - slep_paes _(fuente: PULL)_
_Ficha pendiente de sintesis (slep_paes sin ESTADO.md sincronizado ni cache vigente)._

### slep_rendimiento_historico - Diagnóstico histórico del rendimiento escolar _(fuente: PUSH)_
## En que vamos
Se cerró el sistema visual del reporte (P16: fuentes de marca, chip de transición, portada editorial, facets del benchmark y salida docx), todo verificado end-to-end en HTML y docx. Además se corrigió en raíz una inconsistencia metodológica clave alineando las tasas de situación final del reporte a la base CEM (P+R+Y), y se re-especificó el sidequest de la planilla RBD a 3 categorías con auditoría limpia. El pipeline corre verde de cero y los outputs del Módulo A quedaron regenerados con la nueva base.

## Proximo paso
Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente.

## Bloqueantes
ninguno

### slep_reportes_modelo_resguardo_asistencia - Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio _(fuente: PUSH)_
## En que vamos
La sesión 38 fue 100% documental: registró el delta de las sesiones 36–37 en el backlog acumulativo (entradas 209–214, append-only), dejándolo al día como fuente viva con 214 entradas y cadena correlativa 1→214, reconciliación triple en verde. El proyecto está estable, sin bugs activos y sin deuda administrativa ni de aseo pendiente. El pipeline `run_all()` sigue sin cambios respecto a v37 (última corrida exitosa 73/73 PDF).

## Proximo paso
Abordar un pendiente de fondo: la auditoría de portabilidad cross-OS Windows (que además destraba P-VAR-CANONICA fase 2, tipo deuda técnica) o la auditoría línea a línea del pipeline.

## Bloqueantes
ninguno

### slep_seguimiento_educacion_inicial - Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles _(fuente: PULL)_
**Tipo de producto:** tablero/app.

El proyecto es un analisis longitudinal de las preferencias de matricula de los egresados de jardines infantiles del territorio del Servicio Local, que sigue cohorte a cohorte la transicion desde la educacion parvularia hacia la escolar a lo largo de tres periodos academicos, distinguiendo permanencia en el Servicio, migracion a otro sostenedor, continuidad en el mismo jardin y casos no localizados. El producto es una aplicacion interactiva con diagramas de flujo, tablas comparativas y exportacion, organizada en un modulo restringido y uno de alcance territorial sobre datos abiertos. La ultima sesion cerro tres pendientes de saneamiento (portabilidad del escaner sin rutas absolutas, limpieza de la raiz, consolidacion del backlog historico) y abrio una funcionalidad de panel de detalle persistente bajo el diagrama de flujo.

El foco inmediato es validar visualmente ese panel de detalle y comprometerlo; el cambio esta aplicado en disco pero sin commitear ni validar (suite de pruebas en verde). Pendientes priorizados: ajuste cosmetico de etiquetas, dashboard estatico para directivos y puesta en servidor (diferidos). Bloqueantes: destino por establecimiento en el modulo territorial esta bloqueado por una compuerta de gobernanza; varias validaciones de calidad de datos esperan un insumo externo. Sin dependencias con otros proyectos. Deuda tecnica destacada: el escaner muta archivos versionados en cada corrida. Sin despliegue productivo aun. Gobernanza: si maneja datos sensibles (trayectorias individuales de ninos y ninas; identificadores restringidos en el modulo privado y enmascarados en el territorial).

Procedencia: traspaso_cierre_v34 (2026-06-24); resena; backlog_consolidado.

### slep_simce_adecuado - Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce _(fuente: PULL)_
**Tipo de producto:** tablero/app.

Herramienta interactiva de comparacion de resultados de las pruebas Simce expresados segun los estandares de aprendizaje (Adecuado, Elemental, Insuficiente), con foco en el nivel Adecuado como indicador de logro, ponderada por numero de evaluados y segmentada por grupo socioeconomico. Permite navegar resultados por establecimiento educacional, comuna, Servicio Local, region y nivel nacional, para dos niveles escolares y dos pruebas, a lo largo de la serie disponible (mediados de la decada de 2010 hasta el ano en curso). Construida como aplicacion HTML standalone (React + D3, pipeline reproducible en R) y publicada como sitio estatico.

La sesion v24 fue integramente de mantenimiento documental: sin cambios al motor ni al pipeline. Se cerro el delta de backlog, se versiono la resena final, se retiraron marcas de revision en un script de documentacion y se normalizaron los tags del backlog a una taxonomia canonica de siete codigos. Productos a la fecha: motor desplegado, suite de documentacion standalone offline, backlog historico consolidado y resena final. Pendientes priorizados: sin pendientes activos; candidatos futuros son la actualizacion anual de insumos y la regeneracion de la suite si cambia su contenido. Sin bloqueantes. Deuda tecnica saldada. Gobernanza: maneja datos sensibles (cumplimiento Ley 21.719; identificador de persona natural retirado del insumo versionado going-forward).

Procedencia: traspaso_cierre_v24 (2026-06-29); resena; backlog_historico.

### slep_simce_estandares_aprendizaje - Minuta de resultados Simce por estándares de aprendizaje _(fuente: PUSH)_
## En que vamos
La sesión 14 completó las Fases 9 y 10 del protocolo de migración a GitHub, cerrando formalmente esa migración: se creó el workflow CI de validación (datos prohibidos, RUTs, tokens), el CLAUDE.md raíz y se reescribió el README con la arquitectura de dos raíces. El proyecto queda completamente operativo, con pipeline verificado de cero, repositorio endurecido con CI activo en verde y documentación completa. No quedan pendientes de la migración.

## Proximo paso
No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word).

## Bloqueantes
ninguno

## Anexos

### Proyectos auxiliares
- **slep_monitoreo** - Portafolio del Área (escaparate web).
- **slep_resena_proyectos** - Reseñas del portafolio.

### Proyectos nuevos detectados
- slep_paes

### Proyectos dados de baja
- ninguno.

### Estructura no canonica (paquete / escaparate; no es documentacion incompleta)
- slep_resena_proyectos

### Documentacion incompleta (falta reseña, traspaso o backlog)
- slep_alertas_ael (sin backlog)
- slep_costapresente (sin backlog)
- slep_dashboard_personal_monitoreo (sin resena, backlog)
- slep_georreferenciacion (sin resena, backlog)
- slep_minuta_asistencia (sin backlog)
- slep_minuta_desvinculacion (sin backlog)
- slep_paes (sin resena)
- slep_rendimiento_historico (sin backlog)
- slep_simce_estandares_aprendizaje (sin resena, backlog)

