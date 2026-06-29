# Reporte de cobertura documental de la cartera

> Generado por el orquestador `slep_estado_proyectos_monitoreo`. Actualizado el
> 2026-06-29 (sesion 2; primera version 2026-06-28, sesion 1). Fuente:
> `40_salidas/inventario_cartera.json`. Lectura confinada a documentacion curada
> (R1-R4): no se abrieron datos, OneDrive ni volcados crudos. El orquestador lee
> el **working tree** de cada hermano (la rama que cada repo tenga checked out).

## 1. Resumen

- Universo descubierto por patron: **16 proyectos hermanos** `slep_*` (14
  activos, 2 auxiliares). El propio orquestador y los respaldos `*.git` se
  excluyen por patron.
- Estructura canonica (`50_documentacion/`): 15 de 16. La excepcion
  (`slep_resena_proyectos`) es `no_canonica` por diseno, no por defecto.
- Cobertura de traspaso vigente: **15 de 16**. Reseña: 11 de 16. Backlog
  separado: 8 de 16. Escaner: 14 de 16. `gobernanza_datos.md`: **11 de 16**
  (eran 8 en la sesion 1; +3 por el cierre parcial de H4).

## 2. Matriz de cobertura (al cierre de la sesion 2)

| Proyecto | Cat. | Estructura | Reseña | Traspaso (grafia) | Backlog | Escaner | gobernanza_datos.md |
|---|---|---|---|---|---|---|---|
| slep_alertas_ael | activo | canonica | si | v02 (traspaso-cierre) | - | si | si |
| slep_aprendizajes_ep | activo | canonica | si | v83 (traspaso_cierre) | si | si | **si (nuevo)** |
| slep_categoria_desempeno | activo | canonica | si | v25 (traspaso_cierre) | si | si | si |
| slep_costapresente | activo | canonica | si | v01 (traspaso-cierre) | - | si | si |
| slep_dashboard_personal_monitoreo | activo | canonica | **no** | v17 (traspaso_cierre) | - | **no** | si |
| slep_georreferenciacion | activo | canonica | **no** | v05 (traspaso_cierre) | - | si | no (publico) |
| slep_idps | activo | canonica | si | v25 (traspaso_cierre) | si | si | no (publico) |
| slep_minuta_asistencia | activo | canonica | si | v64 (traspaso-cierre) | - | si | si |
| slep_minuta_desvinculacion | activo | canonica | si | v29 (traspaso_cierre) | - | si | **si (nuevo)** |
| slep_monitoreo | auxiliar | canonica | **no** | v06 (traspaso_cierre) | si | si | no (auxiliar) |
| slep_rendimiento_historico | activo | canonica | si | v05 (traspaso_cierre) | - | si | si |
| slep_reportes_modelo_resguardo_asistencia | activo | canonica | si | v38 (traspaso_cierre) | si | si | si |
| slep_resena_proyectos | auxiliar | **no_canonica** | - | - | - | - | - |
| slep_seguimiento_educacion_inicial | activo | canonica | si | v34 (traspaso_cierre) | si | si | **si (rama docs/suitedoc)** |
| slep_simce_adecuado | activo | canonica | si | v24 (traspaso_cierre) | si | si | si |
| slep_simce_estandares_aprendizaje | activo | canonica | **no** | v14 (traspaso_cierre) | - | si | **no (H4 abierto)** |

Cambios de version desde la sesion 1: `slep_georreferenciacion` v03->v05,
`slep_minuta_desvinculacion` v28->v29, `slep_simce_adecuado` v23->v24 (sus
fichas L2 se re-sintetizaron; el resto se reutilizo literal por sello intacto).

## 3. Casos esperados (no son anomalias)

- **C1 - Auxiliares.** `slep_monitoreo` (escaparate web del portafolio) y
  `slep_resena_proyectos` (insumo del portafolio) se clasifican `auxiliar`.
  `slep_resena_proyectos` ademas es `no_canonica`: categoria DISTINTA de
  "documentacion incompleta".
- **C2 - Grafia migrada en `slep_minuta_asistencia`.** `CONTEXTO_VNN` cubrio las
  sesiones 10-35 y `traspaso-cierre-vNN` rige desde la 36. Por maximo correlativo
  entero el vigente es `traspaso-cierre-v64` (la grafia CONTEXTO es historica).
  `total_sesiones = 52` cuenta enteros distintos (con huecos). Sin colision.
- **C3 - Volcado crudo excluido en `slep_idps`.** `backlog_volcado_crudo.md`
  EXCLUIDO de lectura por R2; el backlog efectivo es `backlog_historico.md`.

## 4. Hallazgos

- **H1 - Reseña ausente (4):** `slep_dashboard_personal_monitoreo`,
  `slep_georreferenciacion`, `slep_simce_estandares_aprendizaje` (activos) y
  `slep_monitoreo` (auxiliar). Sus fichas se derivan solo del ultimo traspaso y
  lo declaran. Sin cambios respecto a la sesion 1.
- **H2 - Escaner ausente (1):** `slep_dashboard_personal_monitoreo`. Sin cambios.
- **H3 - Backlog separado ausente (varios activos):** legitimo en varios
  (correlativo bajo o backlog embebido en el traspaso). Senal de cobertura, no de
  salud. Sin cambios.
- **H4 - `gobernanza_datos.md` y datos sensibles: CIERRE PARCIAL en sesion 2.**
  En la sesion 1 faltaba en tres proyectos que manejan datos de NNA; se crearon
  los tres (POLITICA 10) via encargos autonomos a Claude Code en cada repo:
  - `slep_aprendizajes_ep`: creado y COMMITEADO en `main` (consolido un previo
    `50_gobernanza_datos.md` de nombre no canonico bajo el nombre de POLITICA 10).
  - `slep_minuta_desvinculacion`: creado y COMMITEADO en `main`.
  - `slep_seguimiento_educacion_inicial`: creado en la rama `docs/suitedoc`, NO en
    `main`. El orquestador lo ve PRESENTE porque ese repo tiene esa rama checked
    out; **pero queda pendiente de merge a main**. Si se cambiara a `main`, el
    archivo desapareceria del working tree y `maneja_sensibles` volveria a `FALSE`.
    Ver pendiente P-H4-MERGE en el traspaso v02.

  Delta de `maneja_sensibles` (deteccion por presencia del archivo): los tres
  viraron **FALSE -> TRUE** respecto a la sesion 1.

  **H4 NO esta totalmente cerrado:** `slep_simce_estandares_aprendizaje` maneja
  datos sensibles segun su ficha y AUN carece de `gobernanza_datos.md` (caso
  subreportado en la sesion 1). Recomendacion: crear el archivo en ese repo
  (esta ademas obsoleto >21 dias y en pausa).
- **H5 - `slep_georreferenciacion` (cerrado en sesion 2).** En la sesion 1 estaba
  bajo edicion en vivo (cache "pendiente de sintesis"). Ya se estabilizo en v05;
  su ficha se re-sintetizo y el cache esta vigente. Semaforo `pausa` (a la espera
  de validacion del director). Sin datos sensibles (cartografia de identificadores
  publicos).

## 5. Obsolescencia (frescura > 21 dias)

- `slep_dashboard_personal_monitoreo` y `slep_simce_estandares_aprendizaje`.
  Alerta de frescura, no error.

## 6. Idempotencia y confinamiento verificados (sesion 2)

- **Determinista:** dos corridas sin cambios produjeron `inventario_cartera.json`
  y `.parquet` con md5 identico.
- **Sintesis:** 0 caches pendientes; se re-sintetizaron solo los 3 con sello
  nuevo (georreferenciacion, minuta_desvinculacion, simce_adecuado); los otros 11
  se reutilizaron literal.
- **Confinamiento (R1):** testigos de mtime en `slep_idps`,
  `slep_aprendizajes_ep` y `slep_minuta_asistencia` inalterados antes/despues de
  la corrida. Cero fugas (`/Users/`, RUT) en panorama y reporte.
