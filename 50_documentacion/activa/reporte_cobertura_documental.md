# Reporte de cobertura documental de la cartera

> Generado por el orquestador `slep_estado_proyectos_monitoreo` el 2026-06-28
> (Fase 1, sesion 1). Fuente: `40_salidas/inventario_cartera.json`. Lectura
> confinada a documentacion curada (R1-R4): no se abrieron datos, OneDrive ni
> volcados crudos.

## 1. Resumen

- Universo descubierto por patron: **16 proyectos hermanos** `slep_*` (14
  activos, 2 auxiliares). El propio orquestador y los respaldos `*.git` se
  excluyen por patron.
- Estructura canonica (`50_documentacion/`): 15 de 16. La excepcion
  (`slep_resena_proyectos`) es `no_canonica` por diseno, no por defecto.
- Cobertura de traspaso vigente: **15 de 16** (todos menos
  `slep_resena_proyectos`, que no es pipeline). Reseña: 11 de 16. Backlog
  separado: 8 de 16. Escaner: 14 de 16.

## 2. Matriz de cobertura

| Proyecto | Cat. | Estructura | Reseña | Traspaso (grafia) | Backlog | Escaner | gobernanza_datos.md |
|---|---|---|---|---|---|---|---|
| slep_alertas_ael | activo | canonica | si | v02 (traspaso-cierre) | - | si | si |
| slep_aprendizajes_ep | activo | canonica | si | v83 (traspaso_cierre) | si | si | no* |
| slep_categoria_desempeno | activo | canonica | si | v25 (traspaso_cierre) | si | si | si |
| slep_costapresente | activo | canonica | si | v01 (traspaso-cierre) | - | si | si |
| slep_dashboard_personal_monitoreo | activo | canonica | **no** | v17 (traspaso_cierre) | - | **no** | si |
| slep_georreferenciacion | activo | canonica | **no** | v03 (traspaso_cierre) | - | si | no |
| slep_idps | activo | canonica | si | v25 (traspaso_cierre) | si | si | no |
| slep_minuta_asistencia | activo | canonica | si | v64 (traspaso-cierre) | - | si | si |
| slep_minuta_desvinculacion | activo | canonica | si | v28 (traspaso_cierre) | - | si | no* |
| slep_monitoreo | auxiliar | canonica | **no** | v06 (traspaso_cierre) | si | si | no |
| slep_rendimiento_historico | activo | canonica | si | v05 (traspaso_cierre) | - | si | si |
| slep_reportes_modelo_resguardo_asistencia | activo | canonica | si | v38 (traspaso_cierre) | si | si | si |
| slep_resena_proyectos | auxiliar | **no_canonica** | - | - | - | - | - |
| slep_seguimiento_educacion_inicial | activo | canonica | si | v34 (traspaso_cierre) | si | si | no* |
| slep_simce_adecuado | activo | canonica | si | v23 (traspaso_cierre) | si | si | si |
| slep_simce_estandares_aprendizaje | activo | canonica | **no** | v14 (traspaso_cierre) | - | si | no |

`*` = el proyecto SI maneja datos sensibles segun su traspaso, pero NO tiene
`gobernanza_datos.md`; el detector determinista (que se basa en la presencia de
ese archivo) lo subreporta. Ver hallazgo H4.

## 3. Casos esperados (no son anomalias)

- **C1 - Auxiliares.** `slep_monitoreo` (escaparate web del portafolio) y
  `slep_resena_proyectos` (insumo del portafolio) se clasifican `auxiliar`.
  `slep_resena_proyectos` ademas es `no_canonica` (solo aloja
  `resenas_portafolio_traspaso.md`, sin `50_documentacion/`): categoria DISTINTA
  de "documentacion incompleta".
- **C2 - Grafia migrada en `slep_minuta_asistencia`.** Coexisten dos grafias en
  secuencia, no en paralelo: `CONTEXTO_VNN` cubrio las sesiones 10-35 y
  `traspaso-cierre-vNN` rige desde la 36. Por la regla de maximo correlativo
  entero, el vigente es **`traspaso-cierre-v64`** (no un `CONTEXTO`); la grafia
  CONTEXTO es **historica**, no la vigente. `total_sesiones = 52` cuenta enteros
  distintos (hay huecos: faltan v01-v09, v12, v18, v21). Sin colision, porque
  ninguna grafia comparte correlativo con la otra. (Esto matiza la expectativa
  previa de que CONTEXTO fuera el vigente: la resolucion determinista la
  corrige con el dato real.)
- **C3 - Volcado crudo excluido en `slep_idps`.** Existe
  `backlog_volcado_crudo.md`; queda EXCLUIDO de lectura por R2. El backlog
  efectivo es `backlog_historico.md`.

## 4. Hallazgos (huecos de cobertura, no errores del orquestador)

- **H1 - Reseña ausente (4):** `slep_dashboard_personal_monitoreo`,
  `slep_georreferenciacion`, `slep_simce_estandares_aprendizaje` (activos) y
  `slep_monitoreo` (auxiliar). Sus fichas se derivan solo del ultimo traspaso y
  lo declaran ("Sin reseña; estado derivado del ultimo traspaso"). Recomendacion:
  agregar `resena_<slug>.md` cuando el proyecto vuelva a tener trabajo sostenido.
- **H2 - Escaner ausente (1):** `slep_dashboard_personal_monitoreo` no tiene
  `50_documentacion/estructura/estructura_actual.md`. Recomendacion: correr su
  `00_escanear_proyecto.R` en la proxima apertura.
- **H3 - Backlog separado ausente (varios activos):** `slep_alertas_ael`,
  `slep_costapresente`, `slep_dashboard_personal_monitoreo`,
  `slep_georreferenciacion`, `slep_minuta_asistencia`,
  `slep_minuta_desvinculacion`, `slep_rendimiento_historico`,
  `slep_simce_estandares_aprendizaje`. En varios es legitimo (correlativo bajo:
  v01, v02, v03) o el backlog vive embebido en el traspaso. No implica
  "proyecto roto"; es senal de cobertura, no de salud.
- **H4 - `gobernanza_datos.md` ausente en proyectos que SI manejan datos
  sensibles:** `slep_aprendizajes_ep`, `slep_minuta_desvinculacion` y
  `slep_seguimiento_educacion_inicial` tratan datos de NNA segun sus traspasos,
  pero carecen del archivo. El flag determinista `maneja_sensibles` (basado en la
  presencia del archivo) los marca `FALSE`; la lectura autoritativa de
  gobernanza queda en la ficha L2 sintetizada. Recomendacion (a cada proyecto,
  no a este orquestador): crear `gobernanza_datos.md` (POLITICA 10). Candidato
  natural para estandarizar en Fase 2.
- **H5 - `slep_georreferenciacion` bajo edicion en vivo durante la generacion:**
  el md5 de su traspaso cambio entre la lectura de sintesis y la compilacion del
  inventario. El mecanismo de frescura lo marca como "pendiente de sintesis" en
  el panorama (la ficha L2 igual se muestra desde cache, etiquetada). No es
  defecto: es el sello de frescura funcionando. Se revalida solo en la proxima
  corrida cuando el archivo se estabilice.

## 5. Obsolescencia (frescura > 21 dias)

- `slep_dashboard_personal_monitoreo` (33 dias) y
  `slep_simce_estandares_aprendizaje` (31 dias). Alerta de frescura, no error.

## 6. Idempotencia verificada

- **Determinista:** dos corridas sin cambios en los hermanos produjeron
  `inventario_cartera.json` y `.parquet` con md5 identico.
- **Confinamiento (R1):** testigos de mtime en `slep_idps`,
  `slep_aprendizajes_ep` y `slep_minuta_asistencia` inalterados antes/despues de
  la corrida; `escribir_seguro()` probado y aborta ante rutas fuera del repo.
