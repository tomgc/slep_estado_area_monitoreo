# Censo de la cartera — estado documental, candado, traspasos y decisiones

**Diagnóstico de solo lectura.** No repara, no propone, no interpreta. Mide y reporta.

## 1. Encabezado

- **Corrida:** 2026-08-24, recolección en una sola pasada de unos dieciséis segundos, cerrada inmediatamente antes de las 09:51:03 -04 (marca de escritura de la salida B)
- **Hostname:** `MacBook-Pro-de-[nombre omitido por gobernanza].local`
- **Universo:** 25 directorios `slep_*` de la raíz de proyectos
- **Proyecto emisor:** `slep_estado_proyectos_monitoreo` (se censa igual que los demás; su árbol sucio es conocido y no es hallazgo nuevo)
- **Encargo:** `50_documentacion/andamios/20260824_encargo_censo_cartera.md`, sesión 12

### 1.1 Levantamiento de la regla D1 (registro literal)

> Universo: 25 directorios slep_*. El encargo declaraba [20,24] con premisa de 21
> hermanos + orquestador (traspaso_cierre_v11.md §12). La regla D1 se levanto por
> decision del titular el 2026-08-24. El universo crecio de 22 a 25 desde el cierre
> de la sesion 11.

Los tres directorios que exceden la premisa se identifican en la columna
`en_premisa_v11` de la Tabla B y se nombran en la sección 11.

### 1.2 Advertencias obligatorias

> **`adelante` y `detras` se midieron SIN `fetch`**, contra las referencias remotas
> presentes en disco. El invariante 1.1.2 del encargo prohíbe `fetch` porque movería
> las referencias a mitad de censo y destruiría la comparabilidad entre filas medidas
> antes y después. Las referencias en disco pueden estar desactualizadas y las dos
> columnas heredan esa desactualización.

> **Las columnas `I1` a `I9` son una aproximación externa y NO son la compuerta.** La
> compuerta real la ejecuta `plantillas/95_verificar_cierre.R` dentro del cierre de
> cada proyecto, y mide condiciones que este censo no puede ver. Un `PASA` aquí no
> autoriza a nadie a saltarse esa corrida.

## 2. Resumen ejecutivo (solo cifras)

- Repositorios censados: **25**. Con `ESTADO.md`: **21**. Sin `ESTADO.md`: **4**.
- Generación de esquema: `v33+` **3**, `v31` **2**, `parcial` **0**, `v5` **16**, `sin_estado` **4**, `n/d` **0**.
- `ventana_insumos` presente en el front matter: **4**. Con diagnóstico `declarada`: **4**. `vacia`: **0**. `entrada_invalida`: **0**. `ausente`: **21**.
- Con `traspasos_sin_versionar > 0`: **4**. Con `traspasos_a_la_vista > 1`: **14**. Con `traspasos_a_la_vista = 0`: **3**.
- Con árbol sucio (`sucio > 0`): **10**. Con stash (`stash > 0`): **2**.
- Con al menos una decisión: **18**. Total de decisiones de la cartera: **156**.
- Reparto de `invariantes_pasa`: `0/9`: **2**; `2/9`: **3**; `3/9`: **3**; `4/9`: **6**; `5/9`: **5**; `6/9`: **3**; `7/9`: **2**; `8/9`: **1**;

## 3. Tabla A — Estado y candado

| repo | tiene_estado | esquema | n_candado | sesion_actual | traspaso_max | desync | fecha_discrepante | sesion_abierta | commit_cierre | traspaso_vigente | traspaso_vigente_calza | cierre_incompleto | insumos_verificados | ventana_diagnostico |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `slep_alertas_ael` | si | v5 | 0 | v02 | v02 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_aprendizajes_ep` | si | v5 | 0 | v125 | v125 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_categoria_desempeno` | si | v5 | 0 | v28 | v28 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | declarada |
| `slep_costapresente` | si | v5 | 0 | v01 | v01 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_dashboard_personal_monitoreo` | si | v5 | 0 | v17 | v17 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_estado_proyectos_monitoreo` | si | v5 | 0 | v06 | v11 | si (delta 5) | si | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_estudio_oferta_demanda` | si | v5 | 0 | v09 | v09 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_georreferenciacion` | si | v33+ | 6 | v20 | v20 | no | no | false | da07a95 | traspaso_cierre_v20.md | si | no | 2026-08-23 | declarada |
| `slep_gestion_solicitudes_compras` | si | v31 | 6 | v16 | v16 | no | no | false | fe25b88 | traspaso_cierre_v16.md | si | no | 2026-08-21 | ausente |
| `slep_idps` | si | v5 | 0 | v26 | v28 | si (delta 2) | n/d | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_lectoescritura` | si | v5 | 0 | v08 | v08 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_minuta_asistencia` | si | v33+ | 6 | v76 | v76 | no | no | false | cb761a3 | traspaso_cierre_v76.md | si | no | 2026-08-22 | declarada |
| `slep_minuta_buenas_senales` | si | v5 | 0 | v11 | AUSENTE | n/d | n/d | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_minuta_desvinculacion` | no | sin_estado | 0 | AUSENTE | v37 | n/d | n/d | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_minuta_matricula` | no | sin_estado | 0 | AUSENTE | AUSENTE | n/d | n/d | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_monitoreo` | si | v5 | 0 | v18 | v17 | adelantado (delta 1) | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_observatorio_medios` | si | v31 | 6 | v04 | v04 | no | no | false | 3f8f04b | traspaso_cierre_v04.md | si | no | 2026-08-21 | ausente |
| `slep_paes` | si | v5 | 0 | v04 | v07 | si (delta 3) | si | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_rendimiento_historico` | no | sin_estado | 0 | AUSENTE | v05 | n/d | n/d | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_reporte_emergencia` | si | v5 | 0 | AUSENTE | v51 | n/d | n/d | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_reportes_modelo_resguardo_asistencia` | si | v33+ | 6 | v78 | v78 | no | no | false | 3f154bc | traspaso_cierre_v78.md | si | no | 2026-08-23 | declarada |
| `slep_resena_proyectos` | no | sin_estado | 0 | AUSENTE | AUSENTE | n/d | n/d | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_seguimiento_educacion_inicial` | si | v5 | 0 | v34 | v34 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_simce_adecuado` | si | v5 | 0 | v26 | v26 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |
| `slep_simce_estandares_aprendizaje` | si | v5 | 0 | v14 | v14 | no | no | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | AUSENTE | ausente |

## 4. Tabla B — Higiene e invariantes

| repo | en_premisa_v11 | remoto | alineado | rama | ref_usada | sucio | stash | adelante | detras | traspasos_a_la_vista | traspasos_archivados | traspasos_sin_versionar | huecos | I1 | I2 | I3 | I4 | I5 | I6 | I7 | I8 | I9 | invariantes_pasa |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `slep_alertas_ael` | si | slep_alertas_ael | si | main | origin/main | 6 | 0 | 0 | 9 | 2 | 0 | 1 | ninguno | FALLA | PASA | FALLA | PASA | FALLA | FALLA | PASA | PASA | FALLA | 4/9 |
| `slep_aprendizajes_ep` | si | slep_aprendizajes_ep | si | main | origin/main | 0 | 0 | 1 | 17 | 1 | 124 | 0 | ninguno | PASA | PASA | FALLA | PASA | PASA | FALLA | PASA | FALLA | FALLA | 5/9 |
| `slep_categoria_desempeno` | si | slep_categoria_desempeno | si | main | origin/main | 1 | 0 | 0 | 0 | 28 | 0 | 0 | ninguno | FALLA | PASA | PASA | PASA | FALLA | FALLA | PASA | FALLA | PASA | 5/9 |
| `slep_costapresente` | si | slep_costapresente | si | main | origin/main | 0 | 0 | 1 | 9 | 1 | 0 | 0 | ninguno | PASA | PASA | FALLA | PASA | PASA | FALLA | PASA | PASA | FALLA | 6/9 |
| `slep_dashboard_personal_monitoreo` | si | slep_dashboard_personal_monitoreo | si | main | origin/main | 0 | 0 | 0 | 0 | 15 | 0 | 0 | v03, v04 | PASA | PASA | PASA | PASA | FALLA | FALLA | n/d | PASA | FALLA | 5/9 |
| `slep_estado_proyectos_monitoreo` | si | slep_estado_area_monitoreo | no (aceptada) | main | origin/main | 24 | 1 | 0 | 10 | 11 | 0 | 2 | ninguno | FALLA | FALLA | FALLA | PASA | FALLA | FALLA | PASA | FALLA | FALLA | 2/9 |
| `slep_estudio_oferta_demanda` | si | slep_estudio_oferta_demanda | si | main | origin/main | 15 | 0 | 0 | 9 | 9 | 0 | 0 | ninguno | FALLA | PASA | FALLA | PASA | FALLA | FALLA | PASA | PASA | FALLA | 4/9 |
| `slep_georreferenciacion` | si | slep_territorio_costa_central | no (aceptada) | main | origin/main | 3 | 0 | 0 | 0 | 1 | 19 | 0 | ninguno | FALLA | PASA | PASA | PASA | PASA | PASA | PASA | FALLA | PASA | 7/9 |
| `slep_gestion_solicitudes_compras` | no | slep_gestion_solicitudes_compras | si | main | origin/main | 2 | 0 | 0 | 0 | 1 | 15 | 0 | ninguno | FALLA | PASA | PASA | PASA | PASA | PASA | PASA | FALLA | FALLA | 6/9 |
| `slep_idps` | si | slep_idps | si | main | origin/main | 10 | 0 | 0 | 10 | 28 | 0 | 0 | ninguno | FALLA | PASA | FALLA | PASA | FALLA | FALLA | PASA | FALLA | FALLA | 3/9 |
| `slep_lectoescritura` | si | slep_lectoescritura | si | main | origin/main | 0 | 0 | 1 | 10 | 8 | 0 | 0 | ninguno | PASA | PASA | FALLA | PASA | FALLA | FALLA | FALLA | PASA | FALLA | 4/9 |
| `slep_minuta_asistencia` | si | slep_minuta_asistencia | si | main | origin/main | 0 | 0 | 0 | 0 | 1 | 40 | 0 | ninguno | PASA | PASA | PASA | PASA | PASA | PASA | n/d | FALLA | PASA | 7/9 |
| `slep_minuta_buenas_senales` | si | slep_minuta_buenas_senales | si | main | origin/main | 0 | 0 | 1 | 10 | 0 | 0 | 0 | n/d | PASA | PASA | FALLA | PASA | FALLA | FALLA | n/d | FALLA | FALLA | 3/9 |
| `slep_minuta_desvinculacion` | si | slep_minuta_desvinculacion | si | main | origin/main | 0 | 3 | 1 | 9 | 31 | 0 | 0 | v29, v30, v31, v32, v33, v34 | PASA | FALLA | FALLA | PASA | FALLA | FALLA | FALLA | FALLA | FALLA | 2/9 |
| `slep_minuta_matricula` | si | n/d | n/d | n/d | AUSENTE | n/d | n/d | n/d | n/d | 0 | 0 | n/d | n/d | n/d | n/d | n/d | n/d | FALLA | FALLA | n/d | n/d | FALLA | 0/9 |
| `slep_monitoreo` | si | slep_monitoreo | si | main | origin/main | 0 | 0 | 0 | 0 | 1 | 16 | 0 | ninguno | PASA | PASA | PASA | PASA | PASA | FALLA | n/d | FALLA | FALLA | 5/9 |
| `slep_observatorio_medios` | no | slep_observatorio_medios | si | main | origin/main | 2 | 0 | 0 | 0 | 1 | 3 | 0 | ninguno | FALLA | PASA | PASA | PASA | PASA | PASA | PASA | FALLA | FALLA | 6/9 |
| `slep_paes` | si | slep_paes | si | main | origin/main | 0 | 0 | 1 | 10 | 7 | 0 | 0 | ninguno | PASA | PASA | FALLA | PASA | FALLA | FALLA | PASA | PASA | FALLA | 5/9 |
| `slep_rendimiento_historico` | si | slep_rendimiento_historico | si | gobernanza/v16 | origin/HEAD | 29 | 0 | 1 | 10 | 5 | 0 | 4 | ninguno | FALLA | PASA | FALLA | FALLA | FALLA | FALLA | PASA | FALLA | FALLA | 2/9 |
| `slep_reporte_emergencia` | no | slep_reporte_emergencia | si | main | origin/main | 0 | 0 | 1 | 10 | 4 | 47 | 0 | ninguno | PASA | PASA | FALLA | PASA | FALLA | FALLA | FALLA | FALLA | FALLA | 3/9 |
| `slep_reportes_modelo_resguardo_asistencia` | si | slep_reportes_modelo_resguardo_asistencia | si | main | origin/main | 0 | 0 | 0 | 0 | 1 | 77 | 0 | ninguno | PASA | PASA | PASA | PASA | PASA | PASA | PASA | FALLA | PASA | 8/9 |
| `slep_resena_proyectos` | si | n/d | n/d | n/d | AUSENTE | n/d | n/d | n/d | n/d | 0 | 0 | n/d | n/d | n/d | n/d | n/d | n/d | FALLA | FALLA | n/d | n/d | FALLA | 0/9 |
| `slep_seguimiento_educacion_inicial` | si | slep_seguimiento_educacion_inicial | si | main | origin/main | 0 | 0 | 1 | 9 | 26 | 0 | 0 | ninguno | PASA | PASA | FALLA | PASA | FALLA | FALLA | PASA | FALLA | FALLA | 4/9 |
| `slep_simce_adecuado` | si | slep_simce_adecuado | si | main | origin/main | 0 | 0 | 7 | 14 | 26 | 0 | 0 | ninguno | PASA | PASA | FALLA | PASA | FALLA | FALLA | PASA | FALLA | FALLA | 4/9 |
| `slep_simce_estandares_aprendizaje` | si | slep_simce_estandares_aprendizaje | si | main | origin/main | 8 | 0 | 0 | 9 | 14 | 0 | 1 | ninguno | FALLA | PASA | FALLA | PASA | FALLA | FALLA | PASA | PASA | FALLA | 4/9 |

> invariantes_pasa suma las nueve columnas, pero tres se midieron por aproximacion y
> su PASA es mas debil que el de las otras seis:
>  - I3: medido sin fetch (invariante 1.1.2 del encargo). Un PASA solo dice que el
>    repo esta al dia con la referencia remota presente en disco, que puede estar
>    desactualizada.
>  - I7: el PASA replica el alcance real del invariante segun SETTINGS v32 (sello del
>    dia e identidad sellado/alias). La columna retrato_obsoleto de la Tabla D mide
>    aparte la brecha que I7 no cubre, y NO entra en el conteo.
>  - I9: clasifica la declaracion de ventana_insumos, no su resolucion. No se
>    comprobaron variables de entorno ni existencia de directorios.
> Ningun PASA de esta tabla sustituye la corrida de 95_verificar_cierre.R.

`n/d` no cuenta como `PASA` en el numerador.

### 4.1 Complemento de traspasos

Campos medidos por el §4.3 del encargo que no tienen columna declarada en ninguna tabla.

| repo | tiene_carpeta_archivo | traspaso_max_ubicacion | grafia_no_canonica | traspasos_no_reconocidos |
|---|---|---|---|---|
| `slep_alertas_ael` | no | vista | 1 | 0 |
| `slep_aprendizajes_ep` | si | vista | 0 | 0 |
| `slep_categoria_desempeno` | no | vista | 0 | 0 |
| `slep_costapresente` | no | vista | 1 | 0 |
| `slep_dashboard_personal_monitoreo` | no | vista | 0 | 4 |
| `slep_estado_proyectos_monitoreo` | no | vista | 0 | 0 |
| `slep_estudio_oferta_demanda` | no | vista | 0 | 0 |
| `slep_georreferenciacion` | si | vista | 0 | 0 |
| `slep_gestion_solicitudes_compras` | si | vista | 0 | 0 |
| `slep_idps` | no | vista | 0 | 0 |
| `slep_lectoescritura` | no | vista | 0 | 0 |
| `slep_minuta_asistencia` | si | vista | 34 | 0 |
| `slep_minuta_buenas_senales` | no | AUSENTE | 0 | 11 |
| `slep_minuta_desvinculacion` | no | vista | 0 | 0 |
| `slep_minuta_matricula` | no | AUSENTE | 0 | 0 |
| `slep_monitoreo` | si | vista | 0 | 0 |
| `slep_observatorio_medios` | si | vista | 0 | 0 |
| `slep_paes` | no | vista | 0 | 0 |
| `slep_rendimiento_historico` | no | vista | 0 | 1 |
| `slep_reporte_emergencia` | si | vista | 0 | 1 |
| `slep_reportes_modelo_resguardo_asistencia` | si | vista | 0 | 0 |
| `slep_resena_proyectos` | no | AUSENTE | 0 | 0 |
| `slep_seguimiento_educacion_inicial` | no | vista | 0 | 0 |
| `slep_simce_adecuado` | no | vista | 0 | 0 |
| `slep_simce_estandares_aprendizaje` | no | vista | 0 | 0 |

Los archivos no reconocidos se nombran en la sección 11.

## 5. Tabla C — Gobernanza y marcadores

| repo | maneja_sensibles | tiene_gobernanza | coherencia_gobernanza | datos_versionados | ordenacion | locale_marcador | locale_guarda | backlog | activa_fuera_de_patron | version_politica_local | version_settings_local |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `slep_alertas_ael` | true | si | ok | 0 | no | si | 2 | no | 3 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_aprendizajes_ep` | true | si | ok | 3 | si | si | 2 | si | 0 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_categoria_desempeno` | true | si | ok | 13 | no | no | 1 | si | 4 | AUSENTE | AUSENTE |
| `slep_costapresente` | true | si | ok | 0 | no | si | 2 | no | 2 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_dashboard_personal_monitoreo` | true | si | ok | 0 | no | no | 1 | no | 1 | > **Versión 5.7 — vigente.** Documento maestro único de arquitectura y | > **Versión 31.** |
| `slep_estado_proyectos_monitoreo` | false | no | ok | 2 | no | si | 2 | si | 2 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_estudio_oferta_demanda` | true | si | ok | 0 | no | si | 2 | si | 1 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_georreferenciacion` | true | no | falta_documento | 6 | no | si | 3 | si | 7 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_gestion_solicitudes_compras` | true | si | ok | 2 | si | si | 3 | si | 0 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_idps` | false | no | ok | 72 | no | si | 2 | si | 3 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_lectoescritura` | true | si | ok | 0 | no | si | 2 | si | 0 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_minuta_asistencia` | true | si | ok | 1 | no | si | 3 | si | 9 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_minuta_buenas_senales` | false | no | ok | 1 | no | si | 2 | si | 4 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_minuta_desvinculacion` | AUSENTE | si | n/d | 3 | no | si | 2 | no | 4 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_minuta_matricula` | AUSENTE | no | n/d | n/d | no | no | 0 | no | 0 | AUSENTE | AUSENTE |
| `slep_monitoreo` | false | no | ok | 2 | no | no | 0 | si | 1 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_observatorio_medios` | false | no | ok | 8 | no | si | 3 | si | 6 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_paes` | false | si | documento_huerfano | 0 | no | si | 2 | si | 2 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_rendimiento_historico` | AUSENTE | si | n/d | 1 | no | no | 0 | no | 4 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_reporte_emergencia` | AUSENTE | si | n/d | 4 | no | si | 2 | si | 1 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_reportes_modelo_resguardo_asistencia` | true | si | ok | 4 | si | si | 3 | si | 0 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_resena_proyectos` | AUSENTE | no | n/d | n/d | no | no | 0 | no | 0 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_seguimiento_educacion_inicial` | true | si | ok | 1 | no | si | 2 | si | 1 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |
| `slep_simce_adecuado` | false | si | documento_huerfano | 26 | no | no | 0 | si | 6 | > **Versión 5.2 — vigente.** Documento maestro único de arquitectura y | AUSENTE |
| `slep_simce_estandares_aprendizaje` | true | si | ok | 0 | no | si | 2 | no | 1 | > **Versión 5.8 — vigente.** Documento maestro único de arquitectura y | > **Versión 34.** |

### 5.1 Archivos de datos versionados (detalle de I8)

- `slep_aprendizajes_ep` (3): 20_insumos/bcep/bcep_oa_2018.xlsx; 20_insumos/establecimientos/datos_jardines_gemelo.xlsx; 20_insumos/establecimientos/rbd_niveles_grupos_gemelo.xlsx
- `slep_categoria_desempeno` (13): 20_insumos/auxiliares/202602_Listado_SLEP_2026_vf.xlsx; 20_insumos/auxiliares/caracterizacion_establecimientos.xlsx; 20_insumos/auxiliares/diccionario_territorios.xlsx; 20_insumos/auxiliares/directorio_oficial_ee_publico.csv; 20_insumos/cdb_2016.xlsx (+8 mas)
- `slep_estado_proyectos_monitoreo` (2): 20_insumos/registro_proyectos.csv; 40_salidas/inventario_cartera.parquet
- `slep_georreferenciacion` (6): 20_insumos/auxiliares/codigo_tipo_y_macrogrupo.xlsx; 20_insumos/auxiliares/diccionario_territorios.xlsx; 20_insumos/auxiliares/listado_slep_2026.xlsx; 20_insumos/maestro_establecimientos.xlsx; 40_salidas/establecimientos_proyectados.rds (+1 mas)
- `slep_gestion_solicitudes_compras` (2): tests/baseline_rbds_v1.csv; tests/baseline_regresion_v1.csv
- `slep_idps` (72): 20_insumos/auxiliares/caracterizacion_establecimientos.xlsx; 20_insumos/auxiliares/diccionario_territorios.xlsx; 20_insumos/auxiliares/directorio_oficial_ee_publico.csv; 20_insumos/auxiliares/idps2m2023_GLOSAS_rbd_publico_final.xlsx; 20_insumos/auxiliares/idps2m2024_GLOSAS_web_final.xlsx (+67 mas)
- `slep_minuta_asistencia` (1): 40_salidas/publico/indicadores_positivos.parquet
- `slep_minuta_buenas_senales` (1): 20_insumos/categoria_rbd_contrato.parquet
- `slep_minuta_desvinculacion` (3): 20_insumos/auxiliares/diccionarios/diccionario_etnia.csv; 20_insumos/auxiliares/diccionarios/diccionario_nacionalidad_rc.csv; 20_insumos/auxiliares/diccionarios/diccionario_pais_nac.csv
- `slep_monitoreo` (2): 40_salidas/catalogo_fuentes.csv; 40_salidas/log_verificacion_fuentes.csv
- `slep_observatorio_medios` (8): 20_insumos/catalogos/equivalencia_medio_id.csv; 20_insumos/catalogos/medios_activos.csv; 20_insumos/catalogos/medios_universo.csv; 20_insumos/piloto/noticias_piloto.csv; 40_salidas/catalogos/revision_tildes.csv (+3 mas)
- `slep_rendimiento_historico` (1): 20_insumos/auxiliares/rbd_slep.csv
- `slep_reporte_emergencia` (4): tests/fixtures/fixture_cuadrillas.xlsx; tests/fixtures/fixture_maestro_establecimientos.xlsx; tests/fixtures/fixture_respuestas_forms.xlsx; tests/fixtures/fixture_universo_ee.csv
- `slep_reportes_modelo_resguardo_asistencia` (4): 20_insumos/auxiliares/calendario.xlsx; 20_insumos/auxiliares/tipos_ensenanza.xlsx; 50_documentacion/ejemplo/salidas/2026-05/90001/reporte_90001_2026-05.xlsx; 50_documentacion/ejemplo/salidas/2026-05/90002/reporte_90002_2026-05.xlsx
- `slep_seguimiento_educacion_inicial` (1): 50_documentacion/activa/auxiliares_verificacion/20260612_220713_auditoria_flujos_sankey.csv
- `slep_simce_adecuado` (26): 20_insumos/auxiliares/anexo_indicadores_simce.xlsx; 20_insumos/auxiliares/caracterizacion_establecimientos.xlsx; 20_insumos/auxiliares/diccionario_territorios.xlsx; 20_insumos/auxiliares/glosas_simce_consolidado_simce.xlsx; 20_insumos/auxiliares/glosas_simce_resumen_cambios_simce_rbd_2014_2025.csv (+21 mas)

### 5.2 Archivos de `activa/` fuera de patrón

- `slep_alertas_ael` (3): principios_desarrollo_v3.md; regla_estructura_proyectos.md; resena_slep_alertas_ael.md
- `slep_categoria_desempeno` (4): P-matricula-actual_alcance.md; P-matricula-grado_alcance.md; contrato_categoria_desempeno_v1.md; resena_slep_categoria_desempeno.md
- `slep_costapresente` (2): DOCUMENTACION_COSTAPRESENTE.md; resena_slep_costapresente.md
- `slep_dashboard_personal_monitoreo` (1): auditoria_seguridad.md
- `slep_estado_proyectos_monitoreo` (2): esbozo_fase2_estado_estandarizado.md; reporte_cobertura_documental.md
- `slep_estudio_oferta_demanda` (1): referencias_README.md
- `slep_georreferenciacion` (7): acta_compuertas_plan_v2.md; critica_panel_plan_oferta_demanda_v1.md; decision_cod_ense_lista_blanca.md; hallazgo_base_parvularia_consolidada.md; informe_bibliografico_oferta_demanda_v1.md; plan_oferta_demanda_v1.md; plan_oferta_demanda_v2.md
- `slep_idps` (3): censo_universo_idps.md; prompt_nuevo_proyecto_idps.md; resena_slep_idps.md
- `slep_minuta_asistencia` (9): auditoria_seguridad.md; contrato_indicadores_positivos_v1.md; contrato_indicadores_positivos_v2.md; diagnostico_migracion_typst_v1.md; encargo_cartograma_teselas_v72.md; encargo_diagnostico_typst_v1.md; encargo_diseno_mapa_tramos_v1.md; encargo_migracion_typst_v71.md; resena_slep_minuta_asistencia.md
- `slep_minuta_buenas_senales` (4): contrato_contexto_v1.md; contrato_indicadores_positivos_v1.md; contrato_indicadores_positivos_v2.md; idea_historia_del_dato_v1.md
- `slep_minuta_desvinculacion` (4): P34_clasificacion_referencias.md; contexto_proyecto.md; indicadores_por_seccion_minuta_v01.md; resena_slep_minuta_desvinculacion.md
- `slep_monitoreo` (1): encargo_diseno_portafolio.md
- `slep_observatorio_medios` (6): REFERENCIA_MAESTRA.md; codebook_v1.0.md; mapa_medios_v1.md; mapa_medios_v2.md; metodologia_analisis_medios_v1.md; prompt_clasificacion_v1.md
- `slep_paes` (2): contexto_paes.md; manifiesto_insumos.md
- `slep_rendimiento_historico` (4): principios_desarrollo_v3.md; prompt_claude_design_reporte.md; regla_estructura_proyectos.md; resena_slep_rendimiento_historico.md
- `slep_reporte_emergencia` (1): plan_robustecimiento_post_a2_v1.md
- `slep_seguimiento_educacion_inicial` (1): resena_slep_seguimiento_educacion_inicial.md
- `slep_simce_adecuado` (6): documentacion_proyecto_slep_simce_adecuado.md; informe_auditoria_prelanzamiento.md; manifiesto_insumos.md; publicacion_github_pages.md; referencia_glosas_simce.md; resena_slep_simce_adecuado.md
- `slep_simce_estandares_aprendizaje` (1): convenciones_proyecto.md

### 5.3 Extractos de `gobernanza_datos.md`

Hasta tres líneas por repositorio que contienen `categor`, `sensible`, `NNA` o `21.719`, recortadas a 120 caracteres. Sirven para cruzar contra `maneja_sensibles` sin abrir el documento entero.

- **`slep_alertas_ael`** (`maneja_sensibles: true`)
    - 11:## Categoría según Ley 21.719
- **`slep_aprendizajes_ep`** (`maneja_sensibles: true`)
    - 3:> Documento obligatorio para proyectos con datos sensibles (POLÍTICA 10).
    - 4:> Define qué datos maneja el proyecto, su categoría legal, quién accede, dónde se
    - 15:> Ley 21.719 (protección de datos, vigente desde diciembre 2026), Ley 19.223
- **`slep_categoria_desempeno`** (`maneja_sensibles: true`)
    - 1:# Gobernanza de datos — slep_categoria_desempeno
    - 4:> (Categoría de Desempeño por RBD y catálogos territoriales) es información
    - 16:- **Categoría de Desempeño por establecimiento (RBD)**, publicada por la
- **`slep_costapresente`** (`maneja_sensibles: true`)
    - 8:- **RUT y nombres** de estudiantes (NNA).
    - 15:## Categoría según la Ley 21.719
    - 18:- **Datos de NNA** (niños, niñas y adolescentes): categoría que exige especial
- **`slep_dashboard_personal_monitoreo`** (`maneja_sensibles: true`)
    - 22:| Minutas de asistencia mensual | Proyecto `minuta_asistencia` | RUT y nombre de estudiantes con asistencia bajo umbr
    - 23:| Planillas CEM trimestrales | Centro de Estudios del Mineduc / proyecto `minuta_desvinculacion` | RUT, nombre, EE, c
    - 24:| Bases SIMCE 2023–2025 | Agencia de Calidad de la Educación | RUT enmascarado, puntaje individual por estudiante, EE
- **`slep_estudio_oferta_demanda`** (`maneja_sensibles: true`)
    - 3:> Documento obligatorio para proyectos con datos sensibles (POLITICA 10).
    - 5:> maneja el proyecto, su categoría legal, quién accede, dónde se almacenan,
    - 10:> Ley 21.719 (protección de datos, vigente desde diciembre 2026),
- **`slep_gestion_solicitudes_compras`** (`maneja_sensibles: true`)
    - 4:> maneja el proyecto, su categoría legal, quién accede, dónde viven los
    - 31:no hay datos de niños, niñas y adolescentes (NNA), no hay asistencia ni
    - 63:## 2. Categoría según Ley 21.719
- **`slep_lectoescritura`** (`maneja_sensibles: true`)
    - 3:> Documento obligatorio para proyectos con datos sensibles (POLITICA 10).
    - 5:> maneja el proyecto, su categoría legal, quién accede, dónde se almacenan,
    - 10:> Ley 21.719 (protección de datos, vigente desde diciembre 2026),
- **`slep_minuta_asistencia`** (`maneja_sensibles: true`)
    - 26:### 1.3 Categorización según Ley 21.719
    - 29:  personales según el artículo 2° de la Ley 21.719.
    - 32:- Los datos de asistencia individual no califican como datos sensibles
- **`slep_minuta_desvinculacion`** (`maneja_sensibles: AUSENTE`)
    - 5:> maneja el proyecto, su categoría legal, quién accede, dónde se almacenan,
    - 9:> Marco normativo aplicable: Ley 19.628 (vida privada), Ley 21.719
    - 51:totales por categoría de desvinculación (1.1/1.2/1.3), distribuciones por
- **`slep_paes`** (`maneja_sensibles: false`)
    - 4:> 19.628 (vida privada), Ley 21.719 (protección de datos personales, vigente
    - 19:  **`MRUN_IPE`** (RUN enmascarado del estudiante = **NNA**) junto a la nota
    - 42:| `egresados_em/` (Notas y Egresados EM) | MINEDUC | **`MRUN`** | **Dato personal de NNA** (RUN enmascarado + nota in
- **`slep_rendimiento_historico`** (`maneja_sensibles: AUSENTE`)
    - 8:| Base rendimiento CEM (RUN) | RUN nominativo | 2024-2025 | Datos personales nominativos de menores (NNA). Máxima sens
    - 11:## Categoría normativa
    - 13:Datos personales y datos de NNA bajo Ley 19.628 y Ley 21.719 (vigente desde
- **`slep_reporte_emergencia`** (`maneja_sensibles: AUSENTE`)
    - 3:> Documento obligatorio para proyectos con datos sensibles (POLITICA 10).
    - 5:> maneja el proyecto, su categoría legal, quién accede, dónde se almacenan,
    - 10:> Ley 21.719 (protección de datos, vigente desde diciembre 2026),
- **`slep_reportes_modelo_resguardo_asistencia`** (`maneja_sensibles: true`)
    - 10:  con datos sensibles. Precondición de gobernanza de las tablas nominales D3
    - 12:  `20260615_decision_exposicion_nominal_nna.md` §4.6: este documento debe
    - 27:datos nominales de NNA** y ambos están cubiertos por este documento. Los datos
- **`slep_seguimiento_educacion_inicial`** (`maneja_sensibles: true`)
    - 3:> Documento obligatorio para proyectos con datos sensibles (POLITICA 10).
    - 5:> maneja el proyecto, su categoría legal, quién accede, dónde se almacenan,
    - 10:> Ley 21.719 (protección de datos, vigente desde diciembre 2026),
- **`slep_simce_adecuado`** (`maneja_sensibles: false`)
    - 3:> Conforme a POLITICA_PROYECTO.md §10. Marco normativo: Ley 21.719 (protección de
    - 36:## 2. Categoría según Ley 21.719
    - 44:- **Sensible:** ninguno. El proyecto no trata datos sensibles (salud, origen,
- **`slep_simce_estandares_aprendizaje`** (`maneja_sensibles: true`)
    - 24:## 2. Categoría de los datos (Ley 21.719)
    - 26:Los datos SIMCE son de **uso institucional restringido** (Leyes 19.628 y 21.719). El
    - 34:  estudiantes (NNA) o solo agregados por establecimiento. El blindaje del repositorio

## 6. Tabla D — Escáner, detalle de I7

| repo | sello_reciente | par_identico | snapshots_retenidos | retrato_obsoleto |
|---|---|---|---|---|
| `slep_alertas_ael` | 20260609_230657 | si | 1 | 9 |
| `slep_aprendizajes_ep` | 20260815_184917 | si | 2 | 44 |
| `slep_categoria_desempeno` | 20260702_000331 | si | 2 | 14 |
| `slep_costapresente` | 20260624_131619 | si | 3 | 0 |
| `slep_dashboard_personal_monitoreo` | AUSENTE | n/d | 0 | n/d |
| `slep_estado_proyectos_monitoreo` | 20260824_083051 | si | 2 | 0 |
| `slep_estudio_oferta_demanda` | 20260710_065945 | si | 2 | 13 |
| `slep_georreferenciacion` | 20260823_181917 | si | 2 | 1 |
| `slep_gestion_solicitudes_compras` | 20260821_072154 | si | 2 | 2 |
| `slep_idps` | 20260704_222011 | si | 2 | 9 |
| `slep_lectoescritura` | 20260712_121049 | no | 2 | 23 |
| `slep_minuta_asistencia` | AUSENTE | n/d | 0 | n/d |
| `slep_minuta_buenas_senales` | AUSENTE | n/d | 0 | n/d |
| `slep_minuta_desvinculacion` | 20260630_192105 | no | 4 | 0 |
| `slep_minuta_matricula` | AUSENTE | n/d | 0 | n/d |
| `slep_monitoreo` | AUSENTE | n/d | 0 | n/d |
| `slep_observatorio_medios` | 20260821_154719 | si | 2 | 5 |
| `slep_paes` | 20260704_163442 | si | 2 | 0 |
| `slep_rendimiento_historico` | 20260615_150945 | si | 2 | 2 |
| `slep_reporte_emergencia` | 20260727_091417 | no | 2 | 25 |
| `slep_reportes_modelo_resguardo_asistencia` | 20260823_213628 | si | 2 | 4 |
| `slep_resena_proyectos` | AUSENTE | n/d | 0 | n/d |
| `slep_seguimiento_educacion_inicial` | 20260624_152825 | si | 2 | 0 |
| `slep_simce_adecuado` | 20260701_114145 | si | 2 | 0 |
| `slep_simce_estandares_aprendizaje` | 20260527_233602 | si | 6 | 8 |

`retrato_obsoleto` cuenta archivos **trackeados** con `mtime` posterior al del snapshot sellado más reciente, excluidos `.git/` y los propios archivos de `50_documentacion/estructura/`. Mayor que cero es exactamente la condición que I7 no detecta y que SETTINGS v32 dejó declarada como brecha abierta. No entra en `invariantes_pasa`.

## 7. Tabla E — Decisiones, agregado

| repo | n_decisiones | decisiones_fuera_de_patron | decision_mas_reciente |
|---|---|---|---|
| `slep_alertas_ael` | 0 | 0 | AUSENTE |
| `slep_aprendizajes_ep` | 29 | 1 | 20260815 |
| `slep_categoria_desempeno` | 13 | 2 | 20260619 |
| `slep_costapresente` | 0 | 0 | AUSENTE |
| `slep_dashboard_personal_monitoreo` | 7 | 7 | AUSENTE |
| `slep_estado_proyectos_monitoreo` | 2 | 0 | 20260710 |
| `slep_estudio_oferta_demanda` | 2 | 0 | 20260708 |
| `slep_georreferenciacion` | 7 | 0 | 20260823 |
| `slep_gestion_solicitudes_compras` | 11 | 0 | 20260821 |
| `slep_idps` | 6 | 0 | 20260625 |
| `slep_lectoescritura` | 2 | 0 | 20260712 |
| `slep_minuta_asistencia` | 5 | 0 | 20260807 |
| `slep_minuta_buenas_senales` | 1 | 0 | 20260703 |
| `slep_minuta_desvinculacion` | 0 | 0 | AUSENTE |
| `slep_minuta_matricula` | 0 | 0 | AUSENTE |
| `slep_monitoreo` | 0 | 0 | AUSENTE |
| `slep_observatorio_medios` | 4 | 0 | 20260820 |
| `slep_paes` | 6 | 0 | 20260704 |
| `slep_rendimiento_historico` | 9 | 0 | 20260615 |
| `slep_reporte_emergencia` | 29 | 3 | 20260722 |
| `slep_reportes_modelo_resguardo_asistencia` | 15 | 3 | 20260823 |
| `slep_resena_proyectos` | 0 | 0 | AUSENTE |
| `slep_seguimiento_educacion_inicial` | 0 | 0 | AUSENTE |
| `slep_simce_adecuado` | 6 | 0 | 20260622 |
| `slep_simce_estandares_aprendizaje` | 2 | 2 | 20260523 |

## 8. Catálogo de decisiones

Ficha de siete campos por archivo. `alt`, `just` e `impl` son las cadenas `alternativa`, `justificac` e `implicanc` buscadas en todo el archivo sin distinguir mayúsculas. Son una medición de **forma**, no un juicio sobre la calidad de ninguna decisión.

### `slep_aprendizajes_ep` — 29 decisiones (20260531 a 20260815)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260531_decision_001_carpeta_modelo.md` | 20260531 | 001_carpeta_modelo | Decisión 001 — Nomenclatura de la carpeta del modelo Power BI | 38 | si | si | no | no |
| `20260601_decision_002_retiro_carpeta_modelo.md` | 20260601 | 002_retiro_carpeta_modelo | Decisión 002 — Retiro de la carpeta `30_modelo/` tras el pivote a R + HTML | 62 | si | si | no | no |
| `20260603_decision_003_privacidad_forma_b_dashboard.md` | 20260603 | 003_privacidad_forma_b_dashboard | Decisión 003 — Privacidad del dashboard: forma B reducida al jardín propio | 76 | si | si | si | no |
| `20260605_decision_004_central_forma_a_nna_local.md` | 20260605 | 004_central_forma_a_nna_local | Decisión 004 — El informe central embebe forma A (NNA) por diseño: artefacto sensible local-solo-OneDrive | 127 | si | si | si | no |
| `20260607_decision_006_rediseno_instrumento_evaluacion.md` | 20260607 | 006_rediseno_instrumento_evaluacion | Decisión 006 — Rediseño del instrumento de evaluación parvularia | 126 | no | no | no | no |
| `20260607_decision_007_contrato_salida_consolidador.md` | 20260607 | 007_contrato_salida_consolidador | Decisión 007 — Contrato de salida del consolidador (pieza 2) | 241 | no | no | no | no |
| `20260611_decision_008_oa_priorizados.md` | 20260611 | 008_oa_priorizados | Decisión 008 — OA priorizados por micro-nivel | 162 | si | no | si | no |
| `20260612_decision_009_fecha_evaluacion_sala_momento.md` | 20260612 | 009_fecha_evaluacion_sala_momento | Decisión 009 — Fecha de evaluación a grano sala×momento | 132 | si | no | si | no |
| `20260612_decision_010_escala_cinco_niveles_umbral_momento.md` | 20260612 | 010_escala_cinco_niveles_umbral_momento | Decisión 010 — Escala de 5 niveles de logro y umbral aspiracional por momento | 146 | si | no | no | no |
| `20260612_decision_011_priorizacion_descentralizada_jardin.md` | 20260612 | 011_priorizacion_descentralizada_jardin | Decisión 011 — Priorización descentralizada de OA por jardín | 114 | si | no | no | no |
| `20260615_decision_012_cobertura_oa_completa.md` | 20260615 | 012_cobertura_oa_completa | Decisión 012 — Cobertura OA completa (`cobertura.oa_completa`, Fase 3) | 132 | si | no | no | no |
| `20260617_decision_b2_opcion_b_conteo.md` | 20260617 | b2_opcion_b_conteo | Diseño B2 en zonas de conteo — opción B | 130 | no | si | no | no |
| `20260617_decision_regla_cromatica_ambito_vs_violeta.md` | 20260617 | regla_cromatica_ambito_vs_violeta | Regla cromática — color de ámbito vs violeta en barras de distribución | 75 | no | no | no | no |
| `20260618_decision_seccion_resultados_y_trayectoria.md` | 20260618 | seccion_resultados_y_trayectoria | Decisión de diseño — Reorganización de la ficha del párvulo en dos lecturas | 67 | si | no | no | no |
| `20260625_decision_013_priorizacion_por_momento.md` | 20260625 | 013_priorizacion_por_momento | Decisión 013 — Priorización de OA por momento evaluativo | 233 | no | no | si | no |
| `20260723_decision_014_paralelos_por_sala.md` | 20260723 | 014_paralelos_por_sala | D014 — Paralelos por sala (Frente A) | 168 | no | si | si | no |
| `20260724_decision_d016_nombrado_informes.md` | 20260724 | d016_nombrado_informes | D016 — Nombrado de informes HTML: un archivo por jardín por año | 182 | si | si | si | no |
| `20260726_decision_d022_sujeto_verificacion_sintetico.md` | 20260726 | d022_sujeto_verificacion_sintetico | D022 — Sujeto de verificación sintético en data root paralelo | 152 | si | si | si | no |
| `20260726_decision_d023_respaldo_inmutable_captura.md` | 20260726 | d023_respaldo_inmutable_captura | D023 — Respaldo inmutable de los artefactos de captura antes de toda escritura | 91 | no | no | si | no |
| `20260726_decision_d024_procedencia_insumos.md` | 20260726 | d024_procedencia_insumos | D024 — Procedencia verificable de los insumos | 72 | no | no | no | no |
| `20260727_decision_d025_micronivel_declarado.md` | 20260727 | d025_micronivel_declarado | D025 — Micro-nivel por párvulo y expansión de pseudo-niveles | 78 | si | no | si | no |
| `20260727_decision_d026_estructura_por_jardin.md` | 20260727 | d026_estructura_por_jardin | D026 — Estructura por jardín y captura de retornos | 82 | si | no | no | no |
| `20260727_decision_d027_fuente_consolidador_retornos.md` | 20260727 | d027_fuente_consolidador_retornos | D027 — El consolidador lee la capa de retornos, sin respaldo | 60 | si | no | si | no |
| `20260727_decision_d028_traspaso_vigente.md` | 20260727 | d028_traspaso_vigente | D028 — Regla del traspaso vigente | 70 | si | si | no | no |
| `20260727_decision_d029_runner_unico_ambito_ci.md` | 20260727 | d029_runner_unico_ambito_ci | D029 — Runner único con ámbito, y CI que ejecuta verificadores | 89 | si | no | si | no |
| `20260727_decision_d030_capacidad_salas_asistencia.md` | 20260727 | d030_capacidad_salas_asistencia | D030 — La capacidad del instrumento se comprueba sobre asistencia, por sala | 84 | si | no | si | no |
| `20260729_decision_d031_puerta_lanzamiento_en_dos.md` | 20260729 | d031_puerta_lanzamiento_en_dos | D031 — La puerta de lanzamiento se parte en dos | 139 | si | no | si | no |
| `20260815_decision_fuente_alcance_piloto.md` | 20260815 | fuente_alcance_piloto | Decisión de diseño — de qué fuente sale el alcance del piloto | 204 | no | no | no | no |
| `50_indice_decisiones.md` | AUSENTE | n/d | Índice de decisiones de diseño | 67 | no | no | no | no |

### `slep_categoria_desempeno` — 13 decisiones (20260611 a 20260619)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260611_decision_nombres_establecimientos.md` | 20260611 | nombres_establecimientos | Decisión: identificación de establecimientos en agregados públicos por RBD | 46 | si | si | si | no |
| `20260611_decision_sin_gse.md` | 20260611 | sin_gse | Decisión: ausencia de segmentación por GSE | 52 | si | si | si | no |
| `20260612_auditoria_migracion_github.md` | 20260612 | n/d | Diagnostico de migracion a GitHub — slep_categoria_desempeno | 53 | no | si | no | no |
| `20260612_decision_cobertura_temporal.md` | 20260612 | cobertura_temporal | Decisión: cobertura temporal y año vigente | 49 | si | si | si | no |
| `20260612_decision_licencia.md` | 20260612 | licencia | Decisión: licencia MIT con cláusula de datos | 44 | si | si | si | no |
| `20260612_decision_modelo_pages.md` | 20260612 | modelo_pages | Decisión: modelo de publicación en GitHub Pages | 44 | si | si | si | no |
| `20260612_decision_paleta_categorias.md` | 20260612 | paleta_categorias | Decisión: paleta fija de categorías | 50 | si | si | si | no |
| `20260612_decision_visibilidad_repo.md` | 20260612 | visibilidad_repo | Decisión: visibilidad pública del repositorio | 47 | si | si | si | no |
| `20260613_decision_cobertura_matricula_2025.md` | 20260613 | cobertura_matricula_2025 | Decisión: ampliación de la cobertura del insumo de matrícula a 2016-2025 | 77 | si | no | si | no |
| `20260613_decision_procedencia_insumo_matricula.md` | 20260613 | procedencia_insumo_matricula | Procedencia del insumo `matricula_rbd_ense.parquet` | 107 | no | no | no | no |
| `20260618_decision_plan_c3_eliminar_babel.md` | 20260618 | plan_c3_eliminar_babel | Plan C3 — Eliminar Babel del motor (sesión dedicada) | 180 | no | no | no | no |
| `20260619_decision_portabilidad_cross_os.md` | 20260619 | portabilidad_cross_os | Decisión: portabilidad cross-OS (normalización de fin de línea) | 82 | si | no | si | no |
| `20260619_reconstruccion_app_jsx.md` | 20260619 | n/d | Andamio — Reconstrucción de 33_app.jsx desde el motor transpilado (s23) | 38 | no | no | no | no |

### `slep_dashboard_personal_monitoreo` — 7 decisiones (AUSENTE a AUSENTE)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `01_arquitectura_inicial.md` | AUSENTE | n/d | Decisión 01 — Arquitectura inicial del proyecto | 95 | no | si | no | no |
| `02_helpers_tarjetas.md` | AUSENTE | n/d | Decisión 02 — Helpers de tarjetas con htmltools puro | 76 | si | si | no | no |
| `03_flujo_de_trabajo_git.md` | AUSENTE | n/d | Decisión 03 — Flujo de trabajo Git con PR autodisciplinado | 144 | no | si | no | no |
| `04_fuentes_por_dominio.md` | AUSENTE | n/d | Decisión 04 — Fuentes de datos por dominio | 168 | no | no | si | no |
| `05_contrato_de_consolidados.md` | AUSENTE | n/d | Decisión 05 — Contrato de consolidados entre proyectos hermanos | 206 | no | si | no | no |
| `06_decisiones_tecnicas_paso3.md` | AUSENTE | n/d | Decisión 06 — Decisiones técnicas del Paso 3 | 139 | si | no | si | no |
| `07_caller_mocks_declarativos.md` | AUSENTE | n/d | Decisión 07 — Estrategia del caller para dominios sin implementación real | 115 | si | no | no | no |

### `slep_estado_proyectos_monitoreo` — 2 decisiones (20260628 a 20260710)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260628_decision_arquitectura_orquestador.md` | 20260628 | arquitectura_orquestador | Decision - Arquitectura del orquestador de cartera (sesion 1) | 79 | si | si | si | no |
| `20260710_decision_desalineacion_nombres_repos.md` | 20260710 | desalineacion_nombres_repos | Decisión: desalineación entre nombre de directorio local y nombre de repo remoto | 97 | si | si | si | no |

### `slep_estudio_oferta_demanda` — 2 decisiones (20260704 a 20260708)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260704_decision_metodologia_5_ejes_completo.md` | 20260704 | metodologia_5_ejes_completo | Decisión: metodología completa — 5 ejes analíticos, 13 preguntas, métodos C1-C5 | 94 | no | no | no | no |
| `20260708_decision_relajacion_rbd_directorio_sae.md` | 20260708 | relajacion_rbd_directorio_sae | Decisión: relajación acotada del invariante "RBD→directorio nunca como filtro único" para SAE A/C/D | 60 | no | no | no | no |

### `slep_georreferenciacion` — 7 decisiones (20260625 a 20260823)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260625_decision_densidad_marcadores.md` | 20260625 | densidad_marcadores | Decision: tratamiento de marcadores por densidad | 40 | si | no | si | no |
| `20260626_decision_migracion_github.md` | 20260626 | migracion_github | Diagnostico de migracion a GitHub — slep_georreferenciacion | 44 | no | no | no | no |
| `20260712_decision_alcance_censo2024.md` | 20260712 | alcance_censo2024 | Decisión de alcance — Capa Censo 2024 en el mapa interactivo | 258 | si | si | si | no |
| `20260712_decision_exclusion_territorio_insular.md` | 20260712 | exclusion_territorio_insular | Decisión: exclusión del territorio insular del universo del mapa interactivo | 84 | si | si | si | no |
| `20260712_decision_indicador_asistencia_censo2024.md` | 20260712 | indicador_asistencia_censo2024 | Decisión — Indicador de asistencia de la capa zonal (Censo 2024) | 243 | no | no | si | no |
| `20260712_decision_recodificacion_slep_2026.md` | 20260712 | recodificacion_slep_2026 | Decisión: recodificación de la dependencia SLEP vigente a 2026 | 112 | si | si | si | no |
| `20260823_decision_productor_fronteras_rotulos.md` | 20260823 | productor_fronteras_rotulos | Decisión: productor de las dos fronteras y los rótulos comunales | 118 | si | no | no | no |

### `slep_gestion_solicitudes_compras` — 11 decisiones (20260722 a 20260821)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260722_decision_correccion_g8.md` | 20260722 | correccion_g8 | Decisión — Corrección quirúrgica de HISTORIA!G8 en planillas de establecimientos | 109 | si | no | no | no |
| `20260722_decision_publicacion_datos_sitio.md` | 20260722 | publicacion_datos_sitio | Decisión — Publicación de datos administrativos en el sitio del repositorio | 78 | si | no | no | no |
| `20260722_decision_template_origen_sano.md` | 20260722 | template_origen_sano | Decisión — El template de origen está sano; P5 se cierra sin intervención | 71 | no | no | si | no |
| `20260804_decision_publicador_transaccional.md` | 20260804 | publicador_transaccional | Decisión — Publicador transaccional: dos compuertas y commit del corte | 138 | si | no | no | no |
| `20260805_decision_locale_y_rama_publicable.md` | 20260805 | locale_y_rama_publicable | Decisión — Guarda de locale, rama publicable única y push del registro | 156 | si | no | no | no |
| `20260805_decision_merge_v14_main.md` | 20260805 | merge_v14_main | Decisión — Merge de `gobernanza/v14` a `main` y limpieza post-merge | 164 | si | no | no | no |
| `20260806_decision_campos_personales_sitio.md` | 20260806 | campos_personales_sitio | Decisión — Campos de contacto de personas en el panel publicado | 128 | si | no | no | no |
| `20260806_decision_variante_especial_template.md` | 20260806 | variante_especial_template | Decisión — Variante especial del template v2: una definición, dos geometrías | 177 | si | no | no | no |
| `20260820_decision_anclaje_raiz_bug1101.md` | 20260820 | anclaje_raiz_bug1101 | Decisión — Anclaje de raíz al archivo propio (cierre parcial de BUG-11-01) | 120 | si | no | no | no |
| `20260820_decision_version_por_hoja_y_exclusiones.md` | 20260820 | version_por_hoja_y_exclusiones | Decisión de arquitectura — Versión de catálogo por hoja y exclusiones explícitas | 73 | si | no | no | no |
| `20260821_decision_datos_versionados_sesion16.md` | 20260821 | datos_versionados_sesion16 | Decisión — Datos versionados autorizados: las dos clases de la sesión 16 | 193 | si | no | no | no |

### `slep_idps` — 6 decisiones (20260611 a 20260625)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260611_decision_gobernanza_insumos_publicos.md` | 20260611 | gobernanza_insumos_publicos | Decisión: naturaleza pública de los insumos IDPS y arquitectura Rama A | 70 | si | no | no | no |
| `20260612_decision_ponderacion_idps.md` | 20260612 | ponderacion_idps | Decisión — Ponderación territorial y alcance del motor IDPS | 140 | no | no | no | no |
| `20260622_decision_etiqueta_dependencia.md` | 20260622 | etiqueta_dependencia | Decisión: etiqueta Dependencia del motor IDPS (H-FID-2) | 82 | si | si | si | no |
| `20260622_decision_paleta_indicadores.md` | 20260622 | paleta_indicadores | Decisión — Paleta cromática de los 4 indicadores IDPS del motor | 79 | no | no | no | no |
| `20260624_decision_poligono_gse_radar.md` | 20260624 | poligono_gse_radar | Decisión: polígono GSE de referencia en el radar (reapertura de la ponderación IDPS) | 120 | si | si | si | no |
| `20260625_decision_cobertura_historico_idps.md` | 20260625 | cobertura_historico_idps | Decisión: cobertura histórica IDPS y razón de los huecos | 84 | no | no | si | no |

### `slep_lectoescritura` — 2 decisiones (20260708 a 20260712)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260708_decision_modelo_fuentes.md` | 20260708 | modelo_fuentes | Decisión — Modelo conceptual de fuentes de lectoescritura | 306 | si | no | si | si |
| `20260712_decision_instrumentos_censales.md` | 20260712 | instrumentos_censales | Decisión — Instrumentos censales externos fuera del modelo de cobertura | 227 | si | no | si | no |

### `slep_minuta_asistencia` — 5 decisiones (20260527 a 20260807)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260527_decision_portabilidad_cross_os.md` | 20260527 | portabilidad_cross_os | Decisión: Portabilidad cross-OS y resolución de rutas externas | 235 | si | no | no | no |
| `20260605_decision_rachas_inasistencia.md` | 20260605 | rachas_inasistencia | Decisión técnica: Cálculo de rachas de inasistencia consecutiva | 86 | no | no | si | no |
| `20260703_decision_integracion_contrato_indicadores_positivos.md` | 20260703 | integracion_contrato_indicadores_positivos | Decisión: integración del contrato `indicadores_positivos` en slep_minuta_asistencia | 59 | si | no | si | no |
| `20260806_decision_migracion_pdf_typst.md` | 20260806 | migracion_pdf_typst | Decisión — Migración de la minuta mensual a PDF/Typst (diseño) | 23 | si | si | si | no |
| `20260807_decision_deprecacion_docx.md` | 20260807 | deprecacion_docx | Decisión — Deprecación de la vía DOCX de la minuta mensual | 289 | si | si | no | no |

### `slep_minuta_buenas_senales` — 1 decisiones (20260703 a 20260703)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260703_decision_exposicion_indicadores_rama_b.md` | 20260703 | exposicion_indicadores_rama_b | Decisión — Exposición del parquet de indicadores desde productores rama B | 53 | no | si | no | no |

### `slep_observatorio_medios` — 4 decisiones (20260804 a 20260820)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260804_decision_pendientes_planificacion.md` | 20260804 | pendientes_planificacion | Decisiones del titular — Pendientes de planificación (P-1 a P-8) | 35 | si | no | no | no |
| `20260817_decision_p9_biblioteca_noticias.md` | 20260817 | p9_biblioteca_noticias | Decisión del titular — P-9: biblioteca propia de noticias (revisión de P-1) | 47 | si | no | no | no |
| `20260820_decision_p10_alta_periodicodelacosta.md` | 20260820 | p10_alta_periodicodelacosta | Decisión del titular — P-10: promoción de Periódico de la Costa, sin baja de CNN Chile | 89 | no | no | no | no |
| `20260820_decision_p11_catalogo_canonico.md` | 20260820 | p11_catalogo_canonico | Decisión del titular — P-11: jerarquía entre los dos catálogos de medios | 447 | no | no | no | no |

### `slep_paes` — 6 decisiones (20260630 a 20260704)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260630_decision_patron_comun_y_paleta.md` | 20260630 | patron_comun_y_paleta | Decisión — Patrón común de los hermanos y paleta propia de slep_paes | 205 | no | no | si | no |
| `20260701_decision_schema_31_leer_normalizar.md` | 20260701 | schema_31_leer_normalizar | Decisión de esquema — `31_leer_normalizar.R` (Fase A: diagnóstico) | 262 | si | si | si | no |
| `20260701_decision_territorializacion_d_matr.md` | 20260701 | territorializacion_d_matr | Decisión — Territorialización de ArchivoD (Postulación/Selección) y ArchivoMatr en `32_agregar_territorial.R` | 52 | si | no | si | no |
| `20260702_decision_camino_a_motor_33.md` | 20260702 | camino_a_motor_33 | Decisión: Camino A para el motor `33` (adaptar el diseño al agregado real) | 75 | si | si | si | no |
| `20260703_decision_f3_margen_interarchivo.md` | 20260703 | f3_margen_interarchivo | Decisión — F3: aceptar el margen inter-archivo de 1 persona (Santo Domingo) | 100 | si | si | si | no |
| `20260704_decision_conteo_invierno_regular.md` | 20260704 | conteo_invierno_regular | Decisión — Conteo invierno/regular en el embudo (Decisión 6): personas únicas | 113 | si | si | si | no |

### `slep_rendimiento_historico` — 9 decisiones (20260609 a 20260615)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260609_decision_data_root_opcion_a.md` | 20260609 | data_root_opcion_a | Decisión: mapeo de DATA_ROOT (opción A) | 32 | si | no | si | no |
| `20260609_decision_layout_interno_data_root.md` | 20260609 | layout_interno_data_root | Decisión: layout interno del DATA_ROOT (espejo 20_insumos / 40_salidas) | 43 | si | no | no | no |
| `20260609_decision_procedencia_rbd_slep.md` | 20260609 | procedencia_rbd_slep | Decisión: procedencia y esquema de rbd_slep.csv | 28 | no | no | no | no |
| `20260609_decision_transicion_2025.md` | 20260609 | transicion_2025 | Decisión: 2025 como año de transición (factor periodo_gestion) | 26 | si | no | si | no |
| `20260610_decision_mrun_ipe_inexistente.md` | 20260610 | mrun_ipe_inexistente | Decisión: MRUN_IPE no existe en la fuente (spine solo con mrun) | 38 | no | no | si | no |
| `20260610_decision_nombres_canonicos.md` | 20260610 | nombres_canonicos | Decisión: nombres canónicos de RBD y comuna desde la tabla RBD-SLEP | 51 | no | no | no | no |
| `20260610_decision_quiebre_2023_especial.md` | 20260610 | quiebre_2023_especial | Decisión: quiebre 2023 por inclusión de educación especial | 44 | no | no | si | no |
| `20260610_decision_sin_situacion_final.md` | 20260610 | sin_situacion_final | Decisión: "sin situación final" codificado como espacio (normalización trimws) | 39 | no | no | si | no |
| `20260615_decision_base_situacion_cem.md` | 20260615 | base_situacion_cem | Decisión: base de situación final CEM (P+R+Y) para las tasas del reporte | 65 | si | no | no | no |

### `slep_reporte_emergencia` — 29 decisiones (20260715 a 20260722)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260715_decision_publicacion_reporte_completo.md` | 20260715 | publicacion_reporte_completo | Decisión — Publicación del reporte COMPLETO: contactos y texto libre narrativo | 172 | si | no | si | no |
| `20260715_decision_publicacion_wrangler_data_root.md` | 20260715 | publicacion_wrangler_data_root | Decisión — Publicación vía wrangler directo desde el data root | 38 | si | no | si | no |
| `20260715_decision_rbd_huerfano_advertir_segregar.md` | 20260715 | rbd_huerfano_advertir_segregar | Decisión — RBD huérfano: advertir y segregar, no hard stop | 66 | si | si | si | no |
| `20260715_decision_retiro_conteo_dotacion_estudiantes.md` | 20260715 | retiro_conteo_dotacion_estudiantes | Decisión — Retiro del conteo derivado de dotación/estudiantes | 60 | si | si | si | no |
| `20260716_decision_contacto_incidentes_correo_personal.md` | 20260716 | contacto_incidentes_correo_personal | Decisión: contacto de incidentes vía correo personal nominado | 63 | no | no | no | no |
| `20260716_decision_rbd_aborto_no_reconocido.md` | 20260716 | rbd_aborto_no_reconocido | Decisión: aborto duro ante RBD no reconocido (revierte 2026-07-15) | 64 | si | no | no | no |
| `20260716_decision_reporte_externo_autoridad_regional.md` | 20260716 | reporte_externo_autoridad_regional | Decisión: reporte descargable para la autoridad educacional regional | 176 | no | no | no | no |
| `20260716_error_ejes_fraccionarios_graficos_cuadrillas.md` | 20260716 | n/d | Error: ejes X fraccionarios en gráficos de cuadrillas (g5, g6) | 20 | no | no | no | no |
| `20260717_addendum_decaimiento_vigencia_v1.md` | 20260717 | n/d | Addendum — Decaimiento de vigencia del veredicto por antigüedad | 103 | no | no | no | no |
| `20260717_decision_arquitectura_giro_establecimiento_centrico.md` | 20260717 | arquitectura_giro_establecimiento_centrico | Decisión de arquitectura — Giro a un modelo establecimiento-céntrico | 167 | no | no | no | no |
| `20260717_decision_continuidad_automatizacion.md` | 20260717 | continuidad_automatizacion | Decisión: continuidad operacional vía automatización (P0-3 → P4) | 62 | no | no | no | no |
| `20260717_decision_marcador_discrepancia_ejes.md` | 20260717 | marcador_discrepancia_ejes | Decisión: marcador de discrepancia entre ejes en portada (P0-1) | 50 | no | no | no | no |
| `20260717_decision_purga_logica_rut.md` | 20260717 | purga_logica_rut | Decisión — Purga de la lógica RUT del candado del sitio | 161 | no | no | no | no |
| `20260717_decision_purga_patron_rut_reporte.md` | 20260717 | purga_patron_rut_reporte | Decisión — Purga del chequeo de patrón RUT en el candado del reporte externo | 72 | si | no | no | no |
| `20260717_decision_reporte_externo_siempre.md` | 20260717 | reporte_externo_siempre | Decisión: el reporte externo se genera SIEMPRE y se publica junto al panel | 80 | no | no | no | no |
| `20260718_decision_manifiesto_de_corte.md` | 20260718 | manifiesto_de_corte | Decisión: manifiesto de corte como testigo explícito de la publicación | 87 | si | si | si | no |
| `20260718_decision_planilla_nombre_sellado.md` | 20260718 | planilla_nombre_sellado | Decisión: la planilla publicada conserva el sello del corte en su nombre (opción a) | 77 | si | si | si | no |
| `20260719_decision_delta_acredita_no_publica.md` | 20260719 | delta_acredita_no_publica | Decisión: el delta del veredicto (R-1 + R-2) se acredita y NO se publica en la misma sesión | 50 | si | no | si | no |
| `20260719_decision_incidente_seguridad_categoria_p11.md` | 20260719 | incidente_seguridad_categoria_p11 | Decisión: "Incidente de seguridad" es una categoría publicable de la P11 | 129 | no | no | si | no |
| `20260719_decision_item15_recoleccion_pura.md` | 20260719 | item15_recoleccion_pura | Decisión: el ítem 15 es recolección pura y no alimenta el veredicto | 144 | si | si | si | no |
| `20260719_decision_ocultar_estado_declarado_por_timeline.md` | 20260719 | ocultar_estado_declarado_por_timeline | Decisión: ocultar el bloque "Estado declarado" y poner un timeline de reportes | 81 | no | no | no | no |
| `20260719_decision_opcion_b_r1_r2_separados.md` | 20260719 | opcion_b_r1_r2_separados | Decisión: Opción B (mover "suspendidas" a "Sin información"), en dos cambios separados R-1 + R-2 | 79 | si | no | si | no |
| `20260719_decision_precedencia_estricta_no_condicionada.md` | 20260719 | precedencia_estricta_no_condicionada | Decisión: la precedencia observado > inferido es ESTRICTA, no condicionada por vigencia | 56 | si | no | si | no |
| `20260719_decision_publicar_7mo_mapa_p13_sin_modificar.md` | 20260719 | publicar_7mo_mapa_p13_sin_modificar | Decisión: publicar el 7mo reporte con el mapa de la P13 sin modificar | 62 | si | no | si | no |
| `20260719_decision_snapshots_dejan_de_versionarse.md` | 20260719 | snapshots_dejan_de_versionarse | Decisión: los snapshots de estructura con timestamp dejan de versionarse | 50 | si | no | si | no |
| `20260720_decision_ciclo_vida_nota_8vo_delta.md` | 20260720 | ciclo_vida_nota_8vo_delta | Decisión: ciclo de vida de la nota del 8vo (`NOTA_8VO_DELTA`) — se retira al cierre de la emergencia | 78 | si | no | no | no |
| `20260720_decision_opcion_a_eje_solo_item19.md` | 20260720 | opcion_a_eje_solo_item19 | Decisión: Opción A — el eje directivo se resuelve SOLO con el ítem 19 (sin fallback a P13) | 78 | si | no | no | no |
| `20260722_decision_riesgo_caida_arboles_categoria_p11.md` | 20260722 | riesgo_caida_arboles_categoria_p11 | Decisión: "Riesgo de caída de árboles" es una categoría publicable de la P11 | 77 | no | no | si | no |
| `spec_flujo_power_automate_captura_v1.md` | AUSENTE | n/d | Especificación del flujo Power Automate — captura desatendida | 264 | si | no | no | no |

### `slep_reportes_modelo_resguardo_asistencia` — 15 decisiones (20260606 a 20260823)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260606_decision_001_reuso_cache_y_salidas_sensibles.md` | 20260606 | 001_reuso_cache_y_salidas_sensibles | Decisión 001 — Reuso del caché de la minuta y gobernanza de salidas sensibles | 75 | si | no | no | no |
| `20260606_decision_002_stack_render.md` | 20260606 | 002_stack_render | Decisión 002 — Stack de render del reporte por establecimiento | 100 | si | no | no | no |
| `20260613_decision_grupo_ive_similar.md` | 20260613 | grupo_ive_similar | Decisión: grupo de comparación IVE por ventana de IVE similar | 97 | si | no | si | no |
| `20260613_decision_scatter_estudiantes.md` | 20260613 | scatter_estudiantes | Decisión — Scatter de asistencia por estudiante (página 2.1) | 144 | si | no | si | no |
| `20260615_decision_exposicion_nominal_nna.md` | 20260615 | exposicion_nominal_nna | Decisión — Exposición de datos nominales de NNA en las tablas de detalle (D3) | 162 | si | si | si | no |
| `20260615_decision_universo_asistencia.md` | 20260615 | universo_asistencia | Decisión 20260615 — Universo de medición de la asistencia y comparación de modalidades no regulares | 179 | no | no | no | no |
| `20260617_auditoria_mutua_especificacion.md` | 20260617 | n/d | Auditoría mutua minuta ↔ resguardo — Parte 2: especificación del script | 131 | no | no | no | no |
| `20260617_decision_capa_asistencia_propia.md` | 20260617 | capa_asistencia_propia | Decisión — Capa propia de preparación de asistencia (desacople del caché de la minuta) | 268 | si | no | no | no |
| `20260617_mapa_indicadores_minuta_resguardo.md` | 20260617 | n/d | Mapa de indicadores — minuta ↔ resguardo (Parte 1: inventario y clasificación) | 138 | no | no | no | no |
| `20260618_diagnostico_migracion_github.md` | 20260618 | n/d | Diagnóstico de migración a GitHub — auditoría de seguridad | 64 | no | no | no | no |
| `20260812_decision_modalidad_por_cod_ense2.md` | 20260812 | modalidad_por_cod_ense2 | Decisión: derivación de la modalidad por `cod_ense2`, no por el texto del macrogrupo | 227 | si | no | no | no |
| `20260819_decision_caducidad_respaldo_purga.md` | 20260819 | caducidad_respaldo_purga | Decisión — Caducidad del respaldo y del instrumental de `P-RUT-HISTORIAL` | 116 | no | no | no | no |
| `20260821_decision_ampliacion_poblaciones_nominales.md` | 20260821 | ampliacion_poblaciones_nominales | Decisión: ampliación de la enumeración de poblaciones nominales al tramo de asistencia acumulada | 215 | no | si | no | no |
| `20260823_decision_formato_hojas_acumuladas.md` | 20260823 | formato_hojas_acumuladas | Decisión · Formato de las hojas nominales de asistencia acumulada crítica y grave | 79 | no | no | si | no |
| `20260823_decision_identidad_cifra_columnas.md` | 20260823 | identidad_cifra_columnas | Decisión · Identidad ausente, cifra mostrada y juego de columnas de las hojas acumuladas | 79 | no | no | no | no |

### `slep_simce_adecuado` — 6 decisiones (20260611 a 20260622)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260611_decision_color_por_nivel.md` | 20260611 | color_por_nivel | Decisión: color fijo por nivel de logro (no por entidad) | 69 | si | si | si | no |
| `20260611_decision_licencia_apache.md` | 20260611 | licencia_apache | Decisión: licencia Apache 2.0 para el código (desviación de política §10) | 65 | si | si | si | no |
| `20260611_decision_nombres_establecimientos.md` | 20260611 | nombres_establecimientos | Decisión — Nombres de establecimiento en el motor público (B2) | 41 | si | no | si | no |
| `20260611_decision_repo_publico.md` | 20260611 | repo_publico | Decisión — Visibilidad pública del repositorio (B3) | 35 | no | si | no | no |
| `20260620_decision_celda_unico_establecimiento.md` | 20260620 | celda_unico_establecimiento | Decisión: celdas con un único establecimiento (`n_estab = 1`) no se suprimen | 84 | si | si | si | no |
| `20260622_decision_cumplimiento_ley_21719.md` | 20260622 | cumplimiento_ley_21719 | Decisión — Cumplimiento Ley 21.719: de-versionado del directorio crudo | 103 | si | si | no | no |

### `slep_simce_estandares_aprendizaje` — 2 decisiones (20260523 a 20260523)

| archivo | fecha | tema | titulo | lineas | alt | just | impl | enlazada_desde_estado |
|---|---|---|---|---|---|---|---|---|
| `20260523_ano_dinamico_minuta.md` | 20260523 | n/d | Decisión: año dinámico en deliverable de minuta | 39 | si | no | no | no |
| `20260523_estructura_plana_30_procesamiento.md` | 20260523 | n/d | Decisión: estructura plana en 30_procesamiento/ | 39 | si | no | no | no |

Sin ninguna decisión: `slep_alertas_ael`, `slep_costapresente`, `slep_minuta_desvinculacion`, `slep_minuta_matricula`, `slep_monitoreo`, `slep_resena_proyectos`, `slep_seguimiento_educacion_inicial`

## 9. Lista de trabajo de la migración a v34

- **Sin ningún campo de candado** (`n_candado = 0`): `slep_alertas_ael`, `slep_aprendizajes_ep`, `slep_categoria_desempeno`, `slep_costapresente`, `slep_dashboard_personal_monitoreo`, `slep_estado_proyectos_monitoreo`, `slep_estudio_oferta_demanda`, `slep_idps`, `slep_lectoescritura`, `slep_minuta_buenas_senales`, `slep_minuta_desvinculacion`, `slep_minuta_matricula`, `slep_monitoreo`, `slep_paes`, `slep_rendimiento_historico`, `slep_reporte_emergencia`, `slep_resena_proyectos`, `slep_seguimiento_educacion_inicial`, `slep_simce_adecuado`, `slep_simce_estandares_aprendizaje`
- **Candado parcial** (`n_candado` entre 1 y 5): ninguno
- **Candado completo** (`n_candado = 6`): `slep_georreferenciacion`, `slep_gestion_solicitudes_compras`, `slep_minuta_asistencia`, `slep_observatorio_medios`, `slep_reportes_modelo_resguardo_asistencia`
- **Ya declaran `ventana_insumos`** (llave presente, cualquiera sea su diagnóstico): `slep_categoria_desempeno`, `slep_georreferenciacion`, `slep_minuta_asistencia`, `slep_reportes_modelo_resguardo_asistencia`

## 10. Riesgo de pérdida

Repositorios con `traspasos_sin_versionar > 0` o `sucio > 0`, de mayor a menor por `traspasos_sin_versionar`. `traspasos_sin_versionar` mayor que cero es un cierre que existe en un solo disco.

- `slep_rendimiento_historico` — traspasos_sin_versionar: **4**, sucio: **29**, stash: 0, detras: 10
- `slep_estado_proyectos_monitoreo` — traspasos_sin_versionar: **2**, sucio: **24**, stash: 1, detras: 10
- `slep_simce_estandares_aprendizaje` — traspasos_sin_versionar: **1**, sucio: **8**, stash: 0, detras: 9
- `slep_alertas_ael` — traspasos_sin_versionar: **1**, sucio: **6**, stash: 0, detras: 9
- `slep_estudio_oferta_demanda` — traspasos_sin_versionar: **0**, sucio: **15**, stash: 0, detras: 9
- `slep_idps` — traspasos_sin_versionar: **0**, sucio: **10**, stash: 0, detras: 10
- `slep_georreferenciacion` — traspasos_sin_versionar: **0**, sucio: **3**, stash: 0, detras: 0
- `slep_observatorio_medios` — traspasos_sin_versionar: **0**, sucio: **2**, stash: 0, detras: 0
- `slep_gestion_solicitudes_compras` — traspasos_sin_versionar: **0**, sucio: **2**, stash: 0, detras: 0
- `slep_categoria_desempeno` — traspasos_sin_versionar: **0**, sucio: **1**, stash: 0, detras: 0

## 11. Anomalías

### 11.1 Los tres repositorios que exceden la premisa de la sesión 11

- `slep_gestion_solicitudes_compras` — remoto `slep_gestion_solicitudes_compras`, rama `main`, 1 traspasos a la vista, `ESTADO.md`: si. No estaba contemplado en la premisa de 21 hermanos + orquestador.
- `slep_observatorio_medios` — remoto `slep_observatorio_medios`, rama `main`, 1 traspasos a la vista, `ESTADO.md`: si. No estaba contemplado en la premisa de 21 hermanos + orquestador.
- `slep_reporte_emergencia` — remoto `slep_reporte_emergencia`, rama `main`, 4 traspasos a la vista, `ESTADO.md`: si. No estaba contemplado en la premisa de 21 hermanos + orquestador.

### 11.2 Celdas `n/d` y su causa

| repo | columna | causa |
|---|---|---|
| `slep_dashboard_personal_monitoreo` | `I7` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_dashboard_personal_monitoreo` | `par_identico` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_dashboard_personal_monitoreo` | `retrato_obsoleto` | sin snapshot sellado de referencia, o el directorio no es repositorio git |
| `slep_idps` | `fecha_discrepante` | falta la fecha del traspaso máximo o `ultima_actividad` en el `ESTADO.md` |
| `slep_minuta_asistencia` | `I7` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_minuta_asistencia` | `par_identico` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_minuta_asistencia` | `retrato_obsoleto` | sin snapshot sellado de referencia, o el directorio no es repositorio git |
| `slep_minuta_buenas_senales` | `desync` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_minuta_buenas_senales` | `fecha_discrepante` | falta la fecha del traspaso máximo o `ultima_actividad` en el `ESTADO.md` |
| `slep_minuta_buenas_senales` | `huecos` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_minuta_buenas_senales` | `I7` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_minuta_buenas_senales` | `par_identico` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_minuta_buenas_senales` | `retrato_obsoleto` | sin snapshot sellado de referencia, o el directorio no es repositorio git |
| `slep_minuta_desvinculacion` | `desync` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_minuta_desvinculacion` | `fecha_discrepante` | falta la fecha del traspaso máximo o `ultima_actividad` en el `ESTADO.md` |
| `slep_minuta_desvinculacion` | `coherencia_gobernanza` | falta `ESTADO.md`, o `maneja_sensibles` trae un valor no booleano |
| `slep_minuta_matricula` | `desync` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_minuta_matricula` | `fecha_discrepante` | falta la fecha del traspaso máximo o `ultima_actividad` en el `ESTADO.md` |
| `slep_minuta_matricula` | `remoto` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `alineado` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `rama` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `sucio` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `stash` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `adelante` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `detras` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `traspasos_sin_versionar` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `huecos` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_minuta_matricula` | `I1` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `I2` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `I3` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `I4` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `I7` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_minuta_matricula` | `I8` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `coherencia_gobernanza` | falta `ESTADO.md`, o `maneja_sensibles` trae un valor no booleano |
| `slep_minuta_matricula` | `datos_versionados` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_minuta_matricula` | `par_identico` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_minuta_matricula` | `retrato_obsoleto` | sin snapshot sellado de referencia, o el directorio no es repositorio git |
| `slep_monitoreo` | `I7` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_monitoreo` | `par_identico` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_monitoreo` | `retrato_obsoleto` | sin snapshot sellado de referencia, o el directorio no es repositorio git |
| `slep_rendimiento_historico` | `desync` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_rendimiento_historico` | `fecha_discrepante` | falta la fecha del traspaso máximo o `ultima_actividad` en el `ESTADO.md` |
| `slep_rendimiento_historico` | `coherencia_gobernanza` | falta `ESTADO.md`, o `maneja_sensibles` trae un valor no booleano |
| `slep_reporte_emergencia` | `desync` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_reporte_emergencia` | `fecha_discrepante` | falta la fecha del traspaso máximo o `ultima_actividad` en el `ESTADO.md` |
| `slep_reporte_emergencia` | `coherencia_gobernanza` | falta `ESTADO.md`, o `maneja_sensibles` trae un valor no booleano |
| `slep_resena_proyectos` | `desync` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_resena_proyectos` | `fecha_discrepante` | falta la fecha del traspaso máximo o `ultima_actividad` en el `ESTADO.md` |
| `slep_resena_proyectos` | `remoto` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `alineado` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `rama` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `sucio` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `stash` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `adelante` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `detras` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `traspasos_sin_versionar` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `huecos` | falta `traspaso_max` o `sesion_actual`: ninguno de los archivos de `traspasos/` calza la expresión canónica, o el `ESTADO.md` no declara la sesión |
| `slep_resena_proyectos` | `I1` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `I2` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `I3` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `I4` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `I7` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_resena_proyectos` | `I8` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `coherencia_gobernanza` | falta `ESTADO.md`, o `maneja_sensibles` trae un valor no booleano |
| `slep_resena_proyectos` | `datos_versionados` | el directorio no es repositorio git (sin `.git` propio); degradación blanda |
| `slep_resena_proyectos` | `par_identico` | sin snapshots sellados en `50_documentacion/estructura/`, o el par sellado/alias está incompleto |
| `slep_resena_proyectos` | `retrato_obsoleto` | sin snapshot sellado de referencia, o el directorio no es repositorio git |

### 11.3 Registro de anomalías de la recolección

- `slep_alertas_ael` — grafia no canonica (guion medio) en 1 traspaso(s): traspaso-cierre-v02.md 
- `slep_alertas_ael` — traspasos sin versionar (1): traspaso-cierre-v02.md 
- `slep_costapresente` — grafia no canonica (guion medio) en 1 traspaso(s): traspaso-cierre-v01.md 
- `slep_dashboard_personal_monitoreo` — archivo(s) en traspasos/ que NO calzan la expresion canonica traspaso[_-]cierre[_-]v[0-9]{2,3}\.md y por tanto no se contaron: input_sesion5_contrato_consolidados.md traspaso_cierre_fase2_gobernanza.md traspaso_cierre_paso3_fuentes_por_dominio.md traspaso_cierre_react_v01.md
- `slep_dashboard_personal_monitoreo` — huecos en la serie de traspasos [v01-v17]: v03 v04
- `slep_dashboard_personal_monitoreo` — sin 50_documentacion/estructura/: columnas de la Tabla D en n/d
- `slep_estado_proyectos_monitoreo` — traspasos sin versionar (2): traspaso_cierre_v10.md traspaso_cierre_v11.md 
- `slep_minuta_asistencia` — grafia no canonica (guion medio) en 34 traspaso(s): traspaso-cierre-v36.md traspaso-cierre-v37.md traspaso-cierre-v38.md traspaso-cierre-v39.md traspaso-cierre-v40.md traspaso-cierre-v41.md traspaso-cierre-v42.md traspaso-cierre-v43.md traspaso-cierre-v44.md traspaso-cierre-v45.md traspaso-cierre-v46.md traspaso-cierre-v47.md traspaso-cierre-v48.md traspaso-cierre-v49.md traspaso-cierre-v50.md traspaso-cierre-v51.md traspaso-cierre-v52.md traspaso-cierre-v53.md traspaso-cierre-v54.md traspaso-cierre-v55.md traspaso-cierre-v56.md traspaso-cierre-v57.md traspaso-cierre-v58.md traspaso-cierre-v59.md traspaso-cierre-v60.md traspaso-cierre-v61.md traspaso-cierre-v62.md traspaso-cierre-v63.md traspaso-cierre-v64.md traspaso-cierre-v65.md traspaso-cierre-v66.md traspaso-cierre-v67.md traspaso-cierre-v68.md traspaso-cierre-v69.md 
- `slep_minuta_asistencia` — sin snapshots sellados en 50_documentacion/estructura/: par_identico y retrato_obsoleto en n/d
- `slep_minuta_buenas_senales` — archivo(s) en traspasos/ que NO calzan la expresion canonica traspaso[_-]cierre[_-]v[0-9]{2,3}\.md y por tanto no se contaron: traspaso_cierre_v01_slep_minuta_buena_senal.md traspaso_cierre_v02_slep_minuta_buenas_senales.md traspaso_cierre_v03_slep_minuta_buenas_senales.md traspaso_cierre_v04_slep_minuta_buenas_senales.md traspaso_cierre_v05_slep_minuta_buenas_senales.md traspaso_cierre_v06_slep_minuta_buenas_senales.md traspaso_cierre_v07_slep_minuta_buenas_senales.md traspaso_cierre_v08_slep_minuta_buenas_senales.md traspaso_cierre_v09_slep_minuta_buenas_senales.md traspaso_cierre_v10_slep_minuta_buenas_senales.md traspaso_cierre_v11_slep_minuta_buenas_senales.md
- `slep_minuta_buenas_senales` — ningun archivo de traspaso reconocido en 50_documentacion/traspasos/ ni en su subcarpeta archivo/
- `slep_minuta_buenas_senales` — sin snapshots sellados en 50_documentacion/estructura/: par_identico y retrato_obsoleto en n/d
- `slep_minuta_desvinculacion` — sin 50_documentacion/activa/ESTADO.md
- `slep_minuta_desvinculacion` — huecos en la serie de traspasos [v01-v37]: v29 v30 v31 v32 v33 v34
- `slep_minuta_matricula` — no es repositorio git (sin .git propio); degradacion blanda: columnas de git en n/d
- `slep_minuta_matricula` — sin 50_documentacion/; degradacion blanda
- `slep_minuta_matricula` — sin 50_documentacion/activa/ESTADO.md
- `slep_minuta_matricula` — ningun archivo de traspaso reconocido en 50_documentacion/traspasos/ ni en su subcarpeta archivo/
- `slep_minuta_matricula` — sin 50_documentacion/estructura/: columnas de la Tabla D en n/d
- `slep_monitoreo` — sesion_actual (v18) adelantada respecto del traspaso maximo (v17): delta 1
- `slep_monitoreo` — sin snapshots sellados en 50_documentacion/estructura/: par_identico y retrato_obsoleto en n/d
- `slep_rendimiento_historico` — sin 50_documentacion/activa/ESTADO.md
- `slep_rendimiento_historico` — archivo(s) en traspasos/ que NO calzan la expresion canonica traspaso[_-]cierre[_-]v[0-9]{2,3}\.md y por tanto no se contaron: adenda_traspaso_v01.md
- `slep_rendimiento_historico` — traspasos sin versionar (4): traspaso_cierre_v02.md traspaso_cierre_v03.md traspaso_cierre_v04.md traspaso_cierre_v05.md 
- `slep_reporte_emergencia` — archivo(s) en traspasos/ que NO calzan la expresion canonica traspaso[_-]cierre[_-]v[0-9]{2,3}\.md y por tanto no se contaron: traspaso_consolidado_maestro.md
- `slep_reporte_emergencia` — maneja_sensibles con valor no booleano (AUSENTE): coherencia_gobernanza en n/d
- `slep_resena_proyectos` — no es repositorio git (sin .git propio); degradacion blanda: columnas de git en n/d
- `slep_resena_proyectos` — sin 50_documentacion/activa/ESTADO.md
- `slep_resena_proyectos` — ningun archivo de traspaso reconocido en 50_documentacion/traspasos/ ni en su subcarpeta archivo/
- `slep_resena_proyectos` — sin snapshots sellados en 50_documentacion/estructura/: par_identico y retrato_obsoleto en n/d
- `slep_simce_estandares_aprendizaje` — traspasos sin versionar (1): traspaso_cierre_v14.md 

### 11.4 Ajustes de comando y de criterio del ejecutor

- **Hostname saneado.** El §5.1 pide el hostname en el encabezado, pero el hostname
  de esta máquina contiene un nombre de persona, prohibido en las salidas por el
  invariante 1.1.9. Se aplica la sustitución que el propio invariante define para los
  títulos de decisión. La llave `maquina` del bloque de candado tiene el mismo
  contenido, pero no está entre las columnas declaradas de ninguna tabla ni del CSV,
  así que no llega a ninguna salida.
- **`GIT_OPTIONAL_LOCKS=0`** en toda la recolección. Sin esa variable, `git status`
  puede reescribir `.git/index` al refrescar su caché de `stat`, lo que sería
  escritura en veinticinco repositorios hermanos y violaría los invariantes 1.1.1 y
  1.1.4. Se verificó por huella `mtime`/tamaño de `.git/index` antes y después, en
  una muestra de cinco repositorios: sin cambios.
- **`LC_ALL=en_US.UTF-8`** en el extractor y el emisor, para que el recorte a 120 y a
  100 caracteres cuente caracteres y no bytes. Bajo el locale `C` de la máquina, un
  recorte a mitad de una secuencia UTF-8 produce mojibake. Las ordenaciones usan
  `LC_ALL=C` explícito para que sean deterministas.
- **`stat -f`** (forma de macOS), tal como el §4.6 lo indica. No hubo que ajustarlo.
- **Directorio temporal.** El §1.1.1 lo sitúa en `/tmp`. Se usó el directorio de
  trabajo temporal de la sesión, que reside bajo `/private/tmp` (que en macOS *es*
  `/tmp`) y fuera de todo repositorio. Se borra al terminar.
- **`SIN_FRONT_MATTER` en `ventana_insumos`.** El §4.8 no contempla el caso de un
  `ESTADO.md` sin front matter. Clasificarlo como `ausente` afirmaría que la llave
  no está, cuando lo que ocurre es que la medición no pudo hacerse. Se clasifica
  `n/d`, con su causa en 11.2, según el vocabulario cerrado del §1.1.8.
- **`esquema` sin caso declarado.** El §4.2 no cubre un `ESTADO.md` presente pero sin
  front matter ni llaves conocidas. Se clasifica `n/d` con anomalía obligatoria.
- **Medición añadida `traspasos_no_reconocidos`.** La degradación blanda del §1.2
  ordena registrar «una grafía de traspaso no reconocida», pero ninguna columna
  declarada la recoge. Se cuenta y se nombra en 11.3. Se excluyen los archivos
  ocultos (`.DS_Store`, `.gitkeep`, `.Rhistory`), que no son candidatos a traspaso.
  No entra en el CSV, cuyas columnas están fijadas.
- **Columnas añadidas por decisión del titular** el 2026-08-24, al resolver tres
  ambigüedades del encargo: `en_premisa_v11` (Tabla B), `traspaso_vigente_calza`
  (Tabla A y CSV), y `ventana_insumos` y `n_entradas` al final del CSV. El
  denominador de `invariantes_pasa` es 9 y no 8, por la misma decisión.

### 11.5 Mutación concurrente del universo durante la corrida

El §1.1.2 del encargo construye toda la corrida sobre una **foto estática**: prohíbe
`fetch` precisamente para que las referencias no se muevan a mitad de censo y las
filas medidas antes y después sigan siendo comparables. Esa premisa **no se cumplió**,
y no por `fetch`: un proceso ajeno a este censo escribió en los repositorios del
universo mientras la corrida estaba en marcha.

Trece de los veinticinco repositorios registran escrituras de git con fecha de hoy en
`.git/logs/HEAD`, en tres tandas. Se transcribe solo el **tipo** de operación del
último registro de cada reflog: los mensajes completos contienen el nombre de la
máquina, y con él un nombre de persona, prohibido por el invariante 1.1.9.

| repo | mtime de `.git/logs/HEAD` | última operación |
|---|---|---|
| `slep_monitoreo` | 2026-08-24 09:29:46 | `merge origin/main` |
| `slep_aprendizajes_ep` | 2026-08-24 09:46:39 | `rebase (abort)` |
| `slep_costapresente` | 2026-08-24 09:46:40 | `rebase (abort)` |
| `slep_lectoescritura` | 2026-08-24 09:46:41 | `rebase (abort)` |
| `slep_minuta_buenas_senales` | 2026-08-24 09:46:43 | `rebase (abort)` |
| `slep_minuta_desvinculacion` | 2026-08-24 09:46:44 | `rebase (abort)` |
| `slep_paes` | 2026-08-24 09:46:45 | `rebase (abort)` |
| `slep_reporte_emergencia` | 2026-08-24 09:46:46 | `rebase (abort)` |
| `slep_seguimiento_educacion_inicial` | 2026-08-24 09:46:48 | `rebase (abort)` |
| `slep_categoria_desempeno` | 2026-08-24 09:48:01 | `merge origin/main` |
| `slep_dashboard_personal_monitoreo` | 2026-08-24 09:48:03 | `merge origin/main` |
| `slep_simce_adecuado` | 2026-08-24 09:48:05 | `checkout` |
| `slep_reportes_modelo_resguardo_asistencia` | 2026-08-24 09:54:47 | `commit` |

Hechos medidos, sin interpretación:

- La recolección de este informe corrió en **una sola pasada**. Las veinticinco filas provienen de esa pasada: ninguna se midió en una corrida distinta de otra.
- La última escritura observada en el universo (`09:54:47`) es **posterior** a esa recolección. La fila de `slep_reportes_modelo_resguardo_asistencia` describe el estado previo a esa escritura.
- Una recolección de control, corrida a las `09:54:20` y comparada registro a registro contra la que sostiene este informe, no arrojó ninguna diferencia salvo el `sucio` del propio emisor (ver 11.6). Entre esas dos marcas el resto del universo estuvo quieto.
- Corridas anteriores de esta misma sesión, previas a las tandas de las `09:46` y las `09:48`, midieron diez repositorios con `traspasos_sin_versionar > 0` y tres con `ventana_insumos` declarada. Este informe mide cuatro y cuatro. La diferencia es obra de las escrituras de la tabla anterior, no del instrumento.
- La marca de la pasada se acota por la escritura de la salida B, `09:51:03`: se cerró inmediatamente antes. El segundo exacto de inicio no es recuperable, porque los registros intermedios se copiaron para el control de estabilidad y la copia reescribió sus `mtime`.


### 11.6 Autorreferencia del emisor

La fila de `slep_estado_proyectos_monitoreo` declara `sucio: 24`, medido en el paso
7.1 **antes** de escribir nada, como el encargo ordena. Al terminar la corrida el
mismo comando devuelve `26`: las dos unidades de diferencia son exactamente los dos
archivos de este censo. No es un error de medición ni una discrepancia: es lo que la
verificación 9.3 comprueba.

## 12. Reproducción

### 12.1 Comando

```bash
# desde la raiz del emisor; <TMP> es el directorio temporal del paso 8
bash <TMP>/autotest.sh \
  && bash <TMP>/censo_recolectar.sh \
  && bash <TMP>/censo_invariantes.sh \
  && bash <TMP>/censo_emitir_csv.sh \
  && bash <TMP>/censo_emitir_md.sh
```

Los cinco scripts se generan desde los §3 y §4 del encargo y viven en el directorio
temporal, que el §1.1.1 obliga a borrar al terminar: el encargo es la fuente
reproducible, no los scripts. La corrida es determinista salvo por la hora del
encabezado y por lo que haya cambiado en el disco entre corridas, que es exactamente
lo que el `diff` del CSV debe mostrar.

### 12.2 Autotest del paso 8

Fixtures sintéticos en el directorio temporal, fuera de todo repositorio. Un solo `FALLA` activa D2 y no se escribe informe.

| caso | resultado | qué comprueba | esperado | obtenido |
|---|---|---|---|---|
| C1 | **PASA** | 16 llaves, valores no vacios | `v33+\|6\|declarada` | `v33+\|6\|declarada` |
| C2 | **PASA** | solo las ocho llaves heredadas | `v5\|0\|ausente` | `v5\|0\|ausente` |
| C3 | **PASA** | tres campos de candado, ventana vacia | `parcial\|3\|vacia` | `parcial\|3\|vacia` |
| C4 | **PASA** | primera linea distinta de --- (16/16 llaves) | `si` | `si` |
| C5 | **PASA** | sesion_actual v04 contra traspaso v07 | `si\|3` | `si\|3` |
| C6 | **PASA** | entrada con .. en la ventana | `entrada_invalida\|2` | `entrada_invalida\|2` |
| C7 | **PASA** | llave en el CUERPO no debe leerse (control de alcance) | `AUSENTE\|AUSENTE\|v09` | `AUSENTE\|AUSENTE\|v09` |
| C8 | **PASA** | sesion_actual v11 con traspaso v11 (especificidad) | `no\|0` | `no\|0` |

C7 y C8 son los controles negativos. C7 prueba que el extractor NO lee una llave que aparece en el cuerpo en prosa: si la leyera, todas las cifras de candado del censo serían sospechosas. C8 prueba que el detector de desincronización discrimina, en vez de marcar desync en todo.

**Defecto que el autotest atrapó en esta corrida.** En su primera ejecución, C6 dio `entrada_invalida|1` en vez de `entrada_invalida|2`: el clasificador de la ventana perdía la última entrada porque la alimentaba con un `printf` sin salto de línea final y `read` descartaba la línea sin terminar. Corregido y revalidado antes de tocar el universo real. Un defecto de la misma familia apareció después en el cálculo de `huecos` y se corrigió igual.

### 12.3 Verificaciones del paso 9

Las cinco se ejecutan **después** de escribir los dos archivos, por el orden que fija
el §7 del encargo. Por eso este informe lista los comandos y sus valores esperados, y
no puede contener sus resultados sin volverse circular: una cifra de `wc -l` escrita
dentro del propio archivo cambia el `wc -l` de ese archivo. Los resultados literales
van en el mensaje de cierre de la sesión y se reproducen ejecutando estos comandos.

| # | comando | valor esperado |
|---|---|---|
| 9.1 | `wc -l 50_documentacion/andamios/20260824_censo_cartera.md 50_documentacion/andamios/20260824_censo_cartera.csv` | dos cifras, sin valor esperado fijo |
| 9.2 | filas de datos de la Tabla A, de la Tabla B y del CSV | 25, 25 y 25; cualquier discrepancia activa D3 |
| 9.3 | `git status --porcelain \| wc -l` en la raíz del emisor | `sucio_inicial + 2` = 26; el CSV no está ignorado (`git check-ignore` salió con código 1) |
| 9.4 | `grep -c "/Users/$(whoami)" <archivo>` en ambos archivos (la cadena literal no se transcribe aquí: la prohíbe el invariante 1.1.7 del propio encargo) | `0` y `0` |
| 9.5 | `git stash list \| wc -l` en la raíz del emisor | idéntico a `stash_inicial` = 1 |

Contadores medidos antes de escribir nada: `sucio_inicial = 24`, `stash_inicial = 1`.
