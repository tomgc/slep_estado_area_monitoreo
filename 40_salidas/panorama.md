# Panorama de la cartera - Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos

> Generado: 2026-07-01 · Proyectos activos: 15 · Auxiliares: 2

## Alertas

- **Bloqueados:** ninguno.
- **Nuevos detectados:** ninguno.
- **Dados de baja:** ninguno.
- **Documentacion obsoleta (>21 dias):** slep_dashboard_personal_monitoreo, slep_simce_estandares_aprendizaje.
- **Pendientes de sintesis:** slep_minuta_asistencia, slep_paes.

## L1 - Tabla semaforo

| Codigo | Nombre | Semaforo | Ultima actividad | Proximo paso |
|---|---|---|---|---|
| slep_alertas_ael | Sistema de alertas de Anótate en la Lista | activo | 2026-06-10 (hace 21 dias) | Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos (no en la fuente por defecto), ya que se generó en macOS donde Aptos no viene preinstalada y officer degrada en silencio. |
| slep_aprendizajes_ep | Monitoreo de aprendizajes en la educación parvularia | activo | 2026-06-29 (hace 2 dias) | Versionar primero los 3 archivos de v83 y luego implementar la capa 2 de D013 (ETL `32_etl.R`) para que el ETL deje de caer a fallback. |
| slep_categoria_desempeno | Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país | (pendiente) | 2026-07-01 (hace 0 dias) | (pendiente de sintesis) |
| slep_costapresente | CostaPresente | pausa | 2026-06-24 (hace 7 dias) | validar pipeline cross-OS en maquina Windows |
| slep_dashboard_personal_monitoreo | Dashboard personal de monitoreo | activo | 2026-05-26 (hace 36 dias) | Ejecutar la migración estructural completa del repo a la convención canónica (`00_`, `10_utils/`, `20_insumos/`, `30_procesamiento/`, `40_salidas/`, `50_documentacion/`) siguiendo el protocolo de 7 pasos, como foco único de la sesión. |
| slep_georreferenciacion | Georreferenciación de establecimientos del territorio | pausa | 2026-06-29 (hace 2 dias) | Validación con el director, que revisará las dos variantes; el proyecto queda en espera de aprobación externa antes de publicar. |
| slep_idps | Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) | activo | 2026-06-25 (hace 6 dias) | Abordar la higiene de bajo riesgo no alcanzada en s25: resolver `# REVISAR (voz)` en `documentar.R` y subdividir la categoría "Rediseño UI" del backlog. |
| slep_minuta_asistencia | Minuta de asistencia mensual | activo | 2026-07-01 (hace 0 dias) | limpieza de estructura de documentacion, luego refactor del orquestador canonico |
| slep_minuta_desvinculacion | Análisis de trayectorias educativas interrumpidas | activo | 2026-06-30 (hace 1 dias) | Abordar el residuo de `flextable` en `00_run_all.R`: leer primero `41_minuta_desvinculacion_T2_2025.qmd` completo para confirmar si `flextable` aún se usa o es residuo, y si lo es, entregar `00_run_all.R` corregido. |
| slep_paes | Motor de comparación interactivo de los resultados de la PAES | (pendiente) | 2026-07-01 (hace 0 dias) | (pendiente de sintesis) |
| slep_rendimiento_historico | Diagnóstico histórico del rendimiento escolar | activo | 2026-06-15 (hace 16 dias) | Tomar P24: investigar el warning del Módulo B sobre 7.406 registros estudiante-año duplicados colapsados, para determinar si el colapso es benigno o enmascara un problema de la fuente. |
| slep_reportes_modelo_resguardo_asistencia | Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio | activo | 2026-06-21 (hace 10 dias) | Abordar un pendiente de fondo: la auditoría de portabilidad cross-OS Windows (que además destraba P-VAR-CANONICA fase 2, tipo deuda técnica) o la auditoría línea a línea del pipeline. |
| slep_seguimiento_educacion_inicial | Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles | activo | 2026-06-24 (hace 7 dias) | Validar visualmente el panel de detalle fijo (B1) en módulo privado y público, y commitear `35_app.R`. |
| slep_simce_adecuado | Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce | activo | 2026-07-01 (hace 0 dias) | No hay pendientes activos ni bugs. Candidatos de sesión futura: regenerar la suite standalone (evaluar si `documentar.R` referencia terminología "entidad" a actualizar), actualización anual de insumos Simce 2025/2026. |
| slep_simce_estandares_aprendizaje | Minuta de resultados Simce por estándares de aprendizaje | activo | 2026-05-28 (hace 34 dias) | No hay pendientes bloqueantes; la próxima sesión se orientará por necesidades sustantivas según surjan (incorporar datos Simce de un año nuevo, extender los gráficos G1–G6 o actualizar la minuta Word). |

## L2 - Fichas ejecutivas por proyecto activo

### slep_alertas_ael - Sistema de alertas de Anótate en la Lista _(fuente: PUSH)_
## En que vamos
El proyecto pasó de un script suelto a un desarrollo formal completo: estructura canónica de decenas, arquitectura de dos raíces (código en Git / datos en OneDrive vía `SLEP_ALERTAS_AEL_DATA_ROOT`), orquestador, validación de schema, escáner y capa de gobernanza documental. Quedó versionado en el repo privado `tomgc/slep_alertas_ael` con CI en verde y el pipeline verificado end-to-end (28 establecimientos en 1.5 s). Los cuatro pendientes del traspaso v01 quedaron cerrados; los restantes son menores.

## Proximo paso
Abrir el `.docx` generado y verificar visualmente que el texto se renderiza en la fuente Aptos (no en la fuente por defecto), ya que se generó en macOS donde Aptos no viene preinstalada y officer degrada en silencio.

## Bloqueantes
ninguno

### slep_aprendizajes_ep - Monitoreo de aprendizajes en la educación parvularia _(fuente: PUSH)_
## En que vamos
Se cerró el diseño de la Decisión 013 (priorización por momento) y se implementó su capa 1: el generador `36_generar_priorizacion.R` produce 72 libros por momento con una hoja por macro, más el contrato §2.ter reconciliado. Todo verificado visualmente en el gemelo, pero quedó en disco SIN versionar (la sesión no hizo operaciones git). El ETL sigue leyendo el formato viejo y cae a fallback, por lo que no debe correrse run_all ni el ETL hasta cerrar la capa 2.

## Proximo paso
Versionar primero los 3 archivos de v83 y luego implementar la capa 2 de D013 (ETL `32_etl.R`) para que el ETL deje de caer a fallback.

## Bloqueantes
ninguno

### slep_categoria_desempeno - Motor de comparación interactivo de la Categoría de Desempeño de los establecimientos educacionales del país _(fuente: PUSH)_
## Estado

Proyecto estable y publicado. Pipeline sin cambios desde v21; motor autocontenido (C3, sin Babel). La sesión 26 regeneró la suite de documentación en modo standalone offline (los 4 HTML embeben CSS, fuentes, logos e iconos; sin CDN ni dependencia del tema en disco), commit `eff95ef` pusheado a `origin/main`. La regeneración es mantenimiento de artefacto existente y no agrega entradas al backlog, que se mantiene en 89.

## Foco próxima sesión

CONTINUATION con foco único: incidente de gobernanza (PII en historial público). `directorio_oficial_ee.csv` crudo (con `RUT_SOSTENEDOR` y `MRUN`) está commiteado en el historial de este repo público; el de-versionado previo lo sacó del HEAD pero no del historial. Replicar el patrón de `slep_idps` (depurador → CSV público → `.gitignore` blindado → purga de historial con `git filter-repo`/BFG → `push --force` con gate explícito). Administrativo de apertura: versionar el traspaso v26 y el snapshot del escáner de s26.

## Notas

Delta observado no presenciado por s26 (a reconciliar en s27): renombre `backlog_consolidado.md`→`backlog_acumulativo.md`, aparición de `ESTADO.md` y reseña, crecimiento de POLITICA/SETTINGS. Interpretación provisional: infraestructura documental no contabilizable; verificar contra el backlog. El escáner lista disco, no el índice (A20): usar `git ls-files`.

### slep_costapresente - CostaPresente _(fuente: PULL)_
**Tipo de producto:** tablero/app.

Aplicacion local de seguimiento de trayectorias escolares para un servicio local de educacion que cubre cuatro comunas y del orden de varias decenas de establecimientos educacionales y unos veinte mil estudiantes. Reune registros mensuales de matricula y asistencia (fuente: Centro de Estudios del Ministerio de Educacion) en un pipeline de dos pasos: un ETL que normaliza planillas y produce archivos columnar, y una app que permite consultar la trayectoria individual de un estudiante (recorrido entre establecimientos, asistencia, retiros, alta movilidad) mas una vista agregada del territorio con deteccion de casos que desaparecen sin baja formal.

La ultima sesion cerro la estabilizacion de infraestructura post-migracion: centralizacion de gestion de paquetes, auto-ejecucion del orquestador, scanner de estructura y diagrama de arquitectura; el pipeline corre end-to-end en macOS. Pendiente priorizado y bloqueante para produccion: validacion cross-OS en Windows (los usuarios finales operan Windows); pendiente menor: actualizar diagrama del instructivo. Deuda tecnica: app monolitica y umbrales hardcodeados; instructivo binario fuera de control de versiones. Sin despliegue publico: opera local, sin versionar datos. Gobernanza: si maneja datos personales sensibles de ninos, ninas y adolescentes, con resguardo estricto fuera del repositorio.

Procedencia: traspaso-cierre-v01 (2026-06-24); resena.

### slep_dashboard_personal_monitoreo - Dashboard personal de monitoreo _(fuente: PUSH)_
## En que vamos
La sesión 16 cerró el housekeeping post-rename del repo (PR #29) e incorporó traspasos pendientes vía PR #28. El intento de validación numérica de SIMCE quedó bloqueado al descubrir que no existe canal formal por el cual los emisores depositen consolidados reales accesibles desde el dashboard; la sesión pivotó a diseñar y aprobar una plantilla unificada de contrato de consolidado para los 5 dominios. El repo arranca con identidad consolidada y working tree limpio, listo para la migración estructural.

## Proximo paso
Ejecutar la migración estructural completa del repo a la convención canónica (`00_`, `10_utils/`, `20_insumos/`, `30_procesamiento/`, `40_salidas/`, `50_documentacion/`) siguiendo el protocolo de 7 pasos, como foco único de la sesión.

## Bloqueantes
- No existe canal formal emisor → dashboard para depositar consolidados reales accesibles desde `DASHBOARD_DATA_ROOT` (tipo "Bloqueante / Arquitectura del ecosistema"): bloquea la validación SIMCE, la aplicación de contratos y la operación del dashboard contra data real.

### slep_georreferenciacion - Georreferenciación de establecimientos del territorio _(fuente: PUSH)_
## En que vamos
Se construyó, auditó y commiteó la variante de escala única continua del afiche A0 (97 establecimientos), corrigiendo una regresión donde la etiqueta de Viña del Mar tapaba el pin 56 mediante un offset calibrado por código y el switch REUSAR_PNG. El titular reposicionó a mano las 4 etiquetas de comuna al océano en Affinity Publisher y exportó el PDF plotter-ready (300 DPI, fuentes incrustadas). El producto original con inset permanece byte-idéntico; ambas variantes quedan listas para la validación con el director.

## Proximo paso
Validación con el director, que revisará las dos variantes; el proyecto queda en espera de aprobación externa antes de publicar.

## Bloqueantes
- Validación con el director: declarada "bloqueante para publicar"; el proyecto está en espera de aprobación externa hasta que el titular presente las dos variantes y el director apruebe.

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

### slep_paes - Motor de comparación interactivo de los resultados de la PAES _(fuente: PULL)_
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

### slep_seguimiento_educacion_inicial - Análisis longitudinal de preferencias de matrícula de egresados de jardines infantiles _(fuente: PUSH)_
## En que vamos
La sesión 34 saldó tres pendientes de bajo riesgo (escáner sin ruta absoluta, limpieza de raíz y consolidación del backlog histórico) y abrió P-SANKEY-TOOLTIP-FIJO con el enfoque B1: un panel de detalle fijo bajo el Sankey que captura clicks vía onRender. El cambio en `35_app.R` pasó parse() y los 191 tests, pero quedó SIN commitear y SIN validación visual. `main` está limpio; el `35_app.R` con B1 vive solo en el working tree.

## Proximo paso
Validar visualmente el panel de detalle fijo (B1) en módulo privado y público, y commitear `35_app.R`.

## Bloqueantes
ninguno

### slep_simce_adecuado - Motor de comparación interactivo de los resultados de los estándares de aprendizaje medidos por las pruebas Simce _(fuente: PUSH)_
## En que vamos
Sesión 25: renombrado UI "entidad"→"territorio" (33 líneas, identificadores de código intactos), regeneración y deploy del motor, y reparación de un truncamiento del backlog originado en s24 (con un intento fallido revertido). Sesión 26: auditoría de dos hallazgos heredados de gobernanza documental (A-s25-4: `POLITICA_PROYECTO.md` duplicado en raíz resultó ser v6 obsoleta de jun-12, eliminada; `ESTADO.md` confirmado legítimo). Cerrado A-s25-3: `backlog_historico.md` renombrado a `backlog_acumulativo.md` (nombre canónico) y referencia actualizada en README. Sidequest: script `34_historico_pct_adecuado_costa_central.R` (histórico ponderado de % Adecuado, todos los GSE combinados, Costa Central, 4 hojas 4b/2m × lect/mate) ejecutado, verificado y versionado. Proyecto estable y desplegado, working tree limpio.

## Proximo paso
No hay pendientes activos ni bugs. Candidatos de sesión futura: regenerar la suite standalone (evaluar si `documentar.R` referencia terminología "entidad" a actualizar), actualización anual de insumos Simce 2025/2026.

## Bloqueantes
ninguno

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
- ninguno.

### Proyectos dados de baja
- ninguno.

### Estructura no canonica (paquete / escaparate; no es documentacion incompleta)
- ninguno.

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

