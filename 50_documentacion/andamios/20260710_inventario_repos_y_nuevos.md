# Inventario de repos y proyectos nuevos de la cartera

- **Qué es:** andamio congelado (solo lectura, sin efecto sobre el pipeline) que cruza, en una pasada de solo-lectura, dos deudas del traspaso v10 §11: (A) desalineación entre el nombre del **directorio local** y el nombre del **repositorio remoto** (P3), y (B) descubrimiento de **proyectos nuevos** en disco aún no reflejados en `20_insumos/registro_proyectos.csv`.
- **Fecha:** 2026-07-10.
- **Alcance:** subdirectorios `slep_*` inmediatos de `~/Projects/`. Solo lectura: sin `fetch`, sin `push`, sin cambio de upstream, sin `run_all()`, sin edición del registro.
- **Totales:** 22 directorios `slep_*` (21 hermanos + 1 orquestador); 20 con `.git` (20 con remoto); **2 sin remoto**; **3 desalineaciones de nombre** (2 hermanos + el propio orquestador); **4 hermanos nuevos** fuera del registro.

## Cómo descubre el pipeline (PASO 0, lectura de `31_descubrir_proyectos.R` + `10_configuracion.R`)

1. **Descubrimiento por convención, no por allowlist.** `descubrir_hermanos()` lista los subdirectorios inmediatos de `RAIZ_PROYECTOS` (variable de entorno `RAIZ_PROYECTOS`, o el fallback `dirname(RAIZ_ORQUESTADOR)` ≈ `~/Projects`) y se queda con los que cumplen `startsWith("slep_")`, distintos de `SLUG_ORQUESTADOR` y que **no** matcheen `PATRON_EXCLUIR_UNIVERSO`. El comentario del código es explícito: "NUNCA lista hardcodeada". No exige `.git/` ni estructura canónica: cualquier carpeta `slep_*` entra y luego se clasifica `estructura = canonica|no_canonica` según exista `50_documentacion/`.
2. **Rol del CSV: metadatos + destino de sincronización, no fuente de verdad del universo.** `31_` regenera `registro_proyectos.csv` **desde** lo descubierto: preserva intactas las columnas curadas a mano (`nombre_real`, `alias_corto`, `notas`, y cualquier extra como `datos_sensibles`/`estado_proyecto`), respeta el override manual a `categoria="auxiliar"`, y conserva los proyectos desaparecidos como filas `categoria="baja"` (memoria de que existieron). Un proyecto ausente del CSV **no** está "no incorporado" en sentido de exclusión: será incorporado automáticamente en el próximo `run_all()` por convención.
3. **Patrón de exclusión exacto:** `PATRON_EXCLUIR_UNIVERSO = "(?i)\.git$|_backup(_|$)"` — descarta respaldos bare (`*.git`) y directorios de respaldo ad-hoc (`*_backup`, `*_BACKUP_PRE_FILTER_REPO`, etc.), tratando `_backup` como marcador delimitado por `_` o fin de cadena. En este escaneo **ningún** directorio matcheó la exclusión.

**Consecuencia (regla de detención aplicada):** como el descubrimiento es por convención pura y el CSV no es allowlist, `en_registro_csv` deja de ser el criterio de incorporación. En la Tabla B se agrega la columna **`descubierto_por_pipeline`** (TRUE si el directorio pasaría los filtros de `31_` tal como están escritos). Resulta TRUE para los 21 hermanos; `en_registro_csv` se conserva como señal de "ya sincronizado en una corrida previa" (que es lo que distingue un hermano ya registrado de uno nuevo pendiente de la próxima corrida).

## Tabla A — Desalineación nombre directorio-local vs. repo-remoto

| directorio_local | owner/repo_remoto | nombre_repo_remoto | coincide | nota |
|---|---|---|---|---|
| slep_georreferenciacion | tomgc/slep_territorio_costa_central | slep_territorio_costa_central | FALSE | Repo renombrado en GitHub; misma historia (merge-base común, verificado en sesión previa). Caso P3 conocido, confirmado. |
| slep_lectoescritura | tomgc/slep_desarrollo_lectoescritura | slep_desarrollo_lectoescritura | FALSE | Remoto con prefijo `desarrollo_`; directorio local abreviado. **P3 NUEVO**, no listado en los casos conocidos. |
| slep_minuta_matricula | — | — | s/r | Sin `.git`: directorio sin repositorio (no inicializado). No hay remoto que comparar. |
| slep_resena_proyectos | — | — | s/r | Auxiliar del portafolio; nunca versionado como repo propio (solo aloja `resenas_portafolio_traspaso.md`). |
| slep_alertas_ael | tomgc/slep_alertas_ael | slep_alertas_ael | TRUE | |
| slep_aprendizajes_ep | tomgc/slep_aprendizajes_ep | slep_aprendizajes_ep | TRUE | |
| slep_categoria_desempeno | tomgc/slep_categoria_desempeno | slep_categoria_desempeno | TRUE | |
| slep_costapresente | tomgc/slep_costapresente | slep_costapresente | TRUE | |
| slep_dashboard_personal_monitoreo | tomgc/slep_dashboard_personal_monitoreo | slep_dashboard_personal_monitoreo | TRUE | |
| slep_estudio_oferta_demanda | tomgc/slep_estudio_oferta_demanda | slep_estudio_oferta_demanda | TRUE | |
| slep_idps | tomgc/slep_idps | slep_idps | TRUE | |
| slep_minuta_asistencia | tomgc/slep_minuta_asistencia | slep_minuta_asistencia | TRUE | |
| slep_minuta_buenas_senales | tomgc/slep_minuta_buenas_senales | slep_minuta_buenas_senales | TRUE | |
| slep_minuta_desvinculacion | tomgc/slep_minuta_desvinculacion | slep_minuta_desvinculacion | TRUE | |
| slep_monitoreo | tomgc/slep_monitoreo | slep_monitoreo | TRUE | |
| slep_paes | tomgc/slep_paes | slep_paes | TRUE | |
| slep_rendimiento_historico | tomgc/slep_rendimiento_historico | slep_rendimiento_historico | TRUE | |
| slep_reportes_modelo_resguardo_asistencia | tomgc/slep_reportes_modelo_resguardo_asistencia | slep_reportes_modelo_resguardo_asistencia | TRUE | |
| slep_seguimiento_educacion_inicial | tomgc/slep_seguimiento_educacion_inicial | slep_seguimiento_educacion_inicial | TRUE | |
| slep_simce_adecuado | tomgc/slep_simce_adecuado | slep_simce_adecuado | TRUE | |
| slep_simce_estandares_aprendizaje | tomgc/slep_simce_estandares_aprendizaje | slep_simce_estandares_aprendizaje | TRUE | |
| slep_estado_proyectos_monitoreo | tomgc/slep_estado_area_monitoreo | slep_estado_area_monitoreo | FALSE | **ORQUESTADOR** (se autoexcluye del universo). Remoto con nombre distinto (`estado_area` vs `estado_proyectos`). Caso P3 conocido, confirmado. |

### Explicación de los casos FALSE / s/r de la Tabla A

- **slep_georreferenciacion → slep_territorio_costa_central (FALSE):** el repo remoto fue renombrado a un nombre temático (afiche territorial de Costa Central); el directorio local nunca se renombró. Historia compartida verificada por merge-base en una sesión previa. Caso P3 de la lista conocida.
- **slep_lectoescritura → slep_desarrollo_lectoescritura (FALSE):** hallazgo **nuevo**, no estaba en los casos P3 conocidos. El remoto lleva prefijo `desarrollo_`; el directorio local usa la forma corta. Además es uno de los 4 hermanos nuevos (Tabla B).
- **slep_estado_proyectos_monitoreo → slep_estado_area_monitoreo (FALSE):** el orquestador mismo; su remoto quedó con `estado_area_monitoreo`. Caso P3 conocido. Se lista al final por ser el orquestador (se autoexcluye del universo vía `SLUG_ORQUESTADOR`).
- **slep_minuta_matricula (s/r):** directorio sin `.git`, sin estructura canónica (`50_documentacion/` ausente), sin ESTADO ni traspaso. Proyecto naciente / placeholder: no hay repositorio ni remoto que alinear todavía.
- **slep_resena_proyectos (s/r):** insumo auxiliar del portafolio; existe en el registro como `categoria=auxiliar` pero nunca se versionó como repo propio (no tiene `.git`).

## Tabla B — Proyectos nuevos / estado de incorporación

Columna `en_registro_csv` sustituida en criterio por `descubierto_por_pipeline` (ver regla de detención arriba); ambas se muestran. `clasificacion` se decide por `en_registro_csv` (= ya sincronizado en una corrida previa), porque `descubierto_por_pipeline` es TRUE para todos. El orquestador se excluye de esta tabla (se autoexcluye del universo).

| directorio_local | descubierto_por_pipeline | en_registro_csv | tiene_estado_md | tiene_traspaso | clasificacion |
|---|---|---|---|---|---|
| slep_estudio_oferta_demanda | TRUE | FALSE | TRUE | TRUE (9) | nuevo_con_traspaso |
| slep_lectoescritura | TRUE | FALSE | TRUE | TRUE (3) | nuevo_con_traspaso |
| slep_minuta_buenas_senales | TRUE | FALSE | TRUE | TRUE (8) | nuevo_con_traspaso |
| slep_minuta_matricula | TRUE | FALSE | FALSE | FALSE | nuevo_sin_traspaso |
| slep_alertas_ael | TRUE | TRUE | TRUE | TRUE (2) | incorporado |
| slep_aprendizajes_ep | TRUE | TRUE | TRUE | TRUE (83) | incorporado |
| slep_categoria_desempeno | TRUE | TRUE | TRUE | TRUE (28) | incorporado |
| slep_costapresente | TRUE | TRUE | TRUE | TRUE (1) | incorporado |
| slep_dashboard_personal_monitoreo | TRUE | TRUE | TRUE | TRUE (15) | incorporado |
| slep_georreferenciacion | TRUE | TRUE | TRUE | TRUE (5) | incorporado |
| slep_idps | TRUE | TRUE | TRUE | TRUE (28) | incorporado |
| slep_minuta_asistencia | TRUE | TRUE | TRUE | TRUE (33) | incorporado |
| slep_minuta_desvinculacion | TRUE | TRUE | TRUE | TRUE (37) | incorporado |
| slep_monitoreo | TRUE | TRUE | TRUE | TRUE (6) | incorporado |
| slep_paes | TRUE | TRUE | TRUE | TRUE (7) | incorporado |
| slep_rendimiento_historico | TRUE | TRUE | TRUE | TRUE (5) | incorporado |
| slep_reportes_modelo_resguardo_asistencia | TRUE | TRUE | TRUE | TRUE (42) | incorporado |
| slep_resena_proyectos | TRUE | TRUE | FALSE | FALSE | incorporado |
| slep_seguimiento_educacion_inicial | TRUE | TRUE | TRUE | TRUE (26) | incorporado |
| slep_simce_adecuado | TRUE | TRUE | TRUE | TRUE (26) | incorporado |
| slep_simce_estandares_aprendizaje | TRUE | TRUE | TRUE | TRUE (14) | incorporado |

### Explicación de los casos nuevo_* de la Tabla B

- **slep_estudio_oferta_demanda (nuevo_con_traspaso):** repo git, estructura canónica, ESTADO.md + 9 traspasos. Proyecto Rama B maduro, ausente del registro solo porque `run_all()` no se ha corrido desde su creación. Se auto-incorporará como `categoria=activo` en la próxima corrida; falta curar sus metadatos.
- **slep_lectoescritura (nuevo_con_traspaso):** repo git, canónico, ESTADO.md + 3 traspasos. Rama B. Además arrastra desalineación de nombre local↔remoto (Tabla A: → `slep_desarrollo_lectoescritura`).
- **slep_minuta_buenas_senales (nuevo_con_traspaso):** repo git, canónico, ESTADO.md + 8 traspasos. Consumidor de contrato entre ramas. No incorporado al registro aún.
- **slep_minuta_matricula (nuevo_sin_traspaso):** directorio sin `.git`, sin `50_documentacion/`, sin ESTADO ni traspaso. Pasaría el filtro de nombre de `31_` (se listaría como `estructura=no_canonica`), pero no hay traspaso del cual destilar un ESTADO.md: queda en PULL / sin fuente hasta su primer cierre formal.

## Cierre

Andamio para revisión del titular. **No commiteado** (archivo untracked). Acciones sugeridas (fuera de este andamio, decisión del titular): (1) correr `run_all()` para sincronizar los 4 hermanos nuevos al registro y curar sus metadatos; (2) resolver las 3 desalineaciones de nombre P3 (renombrar directorio local, renombrar repo remoto, o registrar el mapeo aceptado), incluida la nueva de `slep_lectoescritura`; (3) decidir el destino de `slep_minuta_matricula` (inicializar como repo/estructura canónica, o dejar fuera).
