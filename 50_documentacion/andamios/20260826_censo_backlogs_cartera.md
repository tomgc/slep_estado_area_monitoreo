# Censo de backlogs de la cartera contra sus traspasos vigentes

- **Encargo:** A-17, sesion 13. **Naturaleza:** solo lectura sobre los hermanos.
- **Universo:** 26 directorios `~/Projects/slep_*`, incluido el orquestador.
- **Medicion:** 2026-08-26T20:27:40-0400 (ISO 8601, por repositorio en el CSV).
- **Origen:** duda 6 de la compuerta de cierre de la sesion 12.

## 1. Veredicto de la duda 6

**Accidente aislado, no patron de cartera.** De 26 directorios medidos, exactamente **1** presenta un hueco interno en su backlog: `slep_estado_proyectos_monitoreo`, el propio orquestador, al que le faltan las entradas **55 a 61**. Es la misma perdida que la sesion 12 ya habia descubierto por otra via, y ningun otro repositorio de la cartera la repite. Cero repositorios quedan en clase `perdida_declarada`.

Que el censo reprodujera de forma independiente el hueco 55-61, hallado antes por un camino distinto, es lo que da credito al cero del resto: el instrumento demostro que sabe ver una perdida real antes de afirmar que no hay mas. La prioridad de la ruta del comando unico **no** se reordena por este motivo. Lo que si aparece como debilidad de cartera es otra cosa: **6 de 26** repositorios no tienen archivo de backlog, y **13** incumplen I5 con mas de un traspaso a la vista.

## 2. Recuento por clase

| Clase | N |
|---|---|
| `calza` | 16 |
| `sin_backlog` | 6 |
| `sin_git` | 2 |
| `hueco_interno` | 1 |
| `sin_traspaso` | 1 |
| **Total** | **26** |

## 3. Tabla completa, una fila por repositorio

### 3.1 Medicion del backlog

| Repositorio | Clase | Convencion | Coincid. | Max | Huecos internos | Ruta del backlog |
|---|---|---|---|---|---|---|
| `slep_alertas_ael` | sin_backlog | `sin_backlog` | -- | -- | -- | -- |
| `slep_aprendizajes_ep` | calza | `lista_num` | 866 | 854 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_categoria_desempeno` | calza | `lista_num` | 90 | 90 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_costapresente` | sin_backlog | `sin_backlog` | -- | -- | -- | -- |
| `slep_dashboard_personal_monitoreo` | sin_backlog | `sin_backlog` | -- | -- | -- | -- |
| `slep_estado_proyectos_monitoreo` | hueco_interno | `lista_num` | 71 | 77 | 55-61 | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_estudio_oferta_demanda` | calza | `lista_num` | 45 | 45 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_georreferenciacion` | calza | `lista_num` | 187 | 184 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_gestion_solicitudes_compras` | calza | `lista_num` | 122 | 118 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_idps` | calza | `tabla` | 25 | 25 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_lectoescritura` | calza | `lista_num` | 34 | 32 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_minuta_asistencia` | calza | `id_alfanum` | 42 | 37 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_minuta_buenas_senales` | sin_traspaso | `lista_num` | 19 | 19 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_minuta_desvinculacion` | sin_backlog | `sin_backlog` | -- | -- | -- | -- |
| `slep_minuta_matricula` | sin_git | `sin_backlog` | -- | -- | -- | -- |
| `slep_monitoreo` | calza | `lista_num` | 134 | 134 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_normativa_convivencia` | calza | `lista_num` | 17 | 17 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_observatorio_medios` | calza | `lista_num` | 33 | 33 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_paes` | calza | `lista_num` | 52 | 52 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_rendimiento_historico` | sin_backlog | `sin_backlog` | -- | -- | -- | -- |
| `slep_reporte_emergencia` | calza | `lista_num` | 255 | 252 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_reportes_modelo_resguardo_asistencia` | calza | `lista_num` | 491 | 491 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_resena_proyectos` | sin_git | `sin_backlog` | -- | -- | -- | -- |
| `slep_seguimiento_educacion_inicial` | calza | `tabla` | 35 | 34 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_simce_adecuado` | calza | `lista_num` | 138 | 138 | -- | 50_documentacion/activa/backlog_acumulativo.md |
| `slep_simce_estandares_aprendizaje` | sin_backlog | `sin_backlog` | -- | -- | -- | -- |

### 3.2 Contraste con el traspaso vigente

| Repositorio | Traspaso vigente | A la vista (I5) | Declarado | Delta | Rama | Sucio |
|---|---|---|---|---|---|---|
| `slep_alertas_ael` | traspaso-cierre-v02.md | 2 | -- | -- | main | 3 |
| `slep_aprendizajes_ep` | traspaso_cierre_v126.md | 1 | -- | -- | main | 0 |
| `slep_categoria_desempeno` | traspaso_cierre_v28.md | 28 | 90 | 0 | main | 1 |
| `slep_costapresente` | traspaso-cierre-v01.md | 1 | 4 | -- | main | 0 |
| `slep_dashboard_personal_monitoreo` | traspaso_cierre_v17.md | 15 | 50 *(laxo)* | -- | main | 0 |
| `slep_estado_proyectos_monitoreo` | traspaso_cierre_v12.md | 1 | 77 | 0 | main | 0 |
| `slep_estudio_oferta_demanda` | traspaso_cierre_v09.md | 9 | 5 *(laxo)* | -40 | main | 6 |
| `slep_georreferenciacion` | traspaso_cierre_v29.md | 1 | 184 | 0 | main | 0 |
| `slep_gestion_solicitudes_compras` | traspaso_cierre_v16.md | 1 | 118 | 0 | main | 0 |
| `slep_idps` | traspaso_cierre_v28.md | 28 | -- | -- | main | 3 |
| `slep_lectoescritura` | traspaso_cierre_v08.md | 8 | -- | -- | main | 0 |
| `slep_minuta_asistencia` | traspaso_cierre_v76.md | 1 | 37 | 0 | main | 6 |
| `slep_minuta_buenas_senales` | -- | 0 | -- | -- | main | 0 |
| `slep_minuta_desvinculacion` | traspaso_cierre_v37.md | 31 | -- | -- | main | 0 |
| `slep_minuta_matricula` | -- | 0 | -- | -- | -- | -- |
| `slep_monitoreo` | traspaso_cierre_v17.md | 1 | 50 *(laxo)* | -84 | main | 0 |
| `slep_normativa_convivencia` | traspaso_cierre_v01.md | 1 | 1 *(laxo)* | -16 | main | 0 |
| `slep_observatorio_medios` | traspaso_cierre_v04.md | 1 | 4 *(laxo)* | -29 | main | 0 |
| `slep_paes` | traspaso_cierre_v07.md | 7 | 52 *(laxo)* | 0 | main | 0 |
| `slep_rendimiento_historico` | traspaso_cierre_v05.md | 5 | 10 *(laxo)* | -- | main | 22 |
| `slep_reporte_emergencia` | traspaso_cierre_v51.md | 4 | 252 | 0 | main | 0 |
| `slep_reportes_modelo_resguardo_asistencia` | traspaso_cierre_v85.md | 1 | 476 *(laxo)* | -15 | main | 11 |
| `slep_resena_proyectos` | -- | 0 | -- | -- | -- | -- |
| `slep_seguimiento_educacion_inicial` | traspaso_cierre_v34.md | 26 | 197 *(laxo)* | 163 | main | 0 |
| `slep_simce_adecuado` | traspaso_cierre_v27.md | 27 | 27 *(laxo)* | -111 | main | 0 |
| `slep_simce_estandares_aprendizaje` | traspaso_cierre_v14.md | 22 | 1 *(laxo)* | -- | main | 3 |

Las cifras marcadas *(laxo)* provienen del patron mas debil del encargo 5.4 y no sostienen ninguna clasificacion (ver correccion 4).

## 4. Lineas literales de origen de lo declarado

| Repositorio | Declarado | Linea del traspaso (120 car.) |
|---|---|---|
| `slep_categoria_desempeno` | 90 | `backlog_acumulativo.md` (pendiente #1 de v27) y se agregó la entrada 90 |
| `slep_costapresente` | 4 | Cada ítem del backlog representa una solicitud distinguible del usuario, no las acciones técnicas para implementarla. Lo |
| `slep_dashboard_personal_monitoreo` | 50 | Este traspaso se redacta en **formato híbrido**: respeta la estructura usada en los traspasos v01–v16 del proyecto (cont |
| `slep_estado_proyectos_monitoreo` | 77 | Entradas nuevas 68 a 77, en el bloque BACKLOG_ENTRADAS de este paquete. El archivo llega |
| `slep_estudio_oferta_demanda` | 5 | - ⚠️ NO commitear el traspaso v09 sin antes fusionar el backlog íntegro (§5) — |
| `slep_georreferenciacion` | 184 | 11 entradas nuevas, tramo 174 a 184. Detalle en |
| `slep_gestion_solicitudes_compras` | 118 | Nueve entradas nuevas, 110 a 118. El archivo canónico es `50_documentacion/activa/backlog_acumulativo.md` y su detalle n |
| `slep_minuta_asistencia` | 37 | - **Qué:** retrato regenerado, dieciséis entradas nuevas de backlog (C-022 a C-037) |
| `slep_monitoreo` | 50 | > `backlog_acumulativo.md`, `50_fundamento_seccion_formacion.md`, |
| `slep_normativa_convivencia` | 1 | en `50_documentacion/activa/backlog_acumulativo.md` (tramo 1→17). Ver ese |
| `slep_observatorio_medios` | 4 | / E-40 / Primera emisión del paquete de cierre v04 / F0 del instrumento detuvo el cierre / Omití el bloque `BACKLOG_NARR |
| `slep_paes` | 52 | 5. **Discrepancia de conteo del backlog (52 vs. 59 declarado en v06).** Ver |
| `slep_rendimiento_historico` | 10 | **Delta del backlog:** +10 entradas (C52-C61). Categorías de la sesión: |
| `slep_reporte_emergencia` | 252 | / 3 / `test_sitio.R:2868` asigna string a la columna lógica `verifico_terreno` / v50, entrada 252 / Mitigado en el helpe |
| `slep_reportes_modelo_resguardo_asistencia` | 476 | La sesión abrió por emergencia: el candado 0bis falló en dos de sus cuatro condiciones porque el cierre de la 84 dejó cu |
| `slep_seguimiento_educacion_inicial` | 197 | - **Archivo:** `50_documentacion/activa/backlog_consolidado.md` (nuevo, 197 líneas). **Categoría:** Documentación. |
| `slep_simce_adecuado` | 27 | **Delta del backlog s27:** no aplicado. Total acumulado sigue en 133 (v26) hasta que se registre esta sesión. |
| `slep_simce_estandares_aprendizaje` | 1 | Backlog acumulado desde sesión 1. Los números son correlativos globales y no se reinician. |

## 5. Correcciones a premisas del encargo

El encargo 8 pide nombrar y corregir, no obedecer, las premisas que resulten falsas. Cinco lo fueron. Las cinco se corrigieron en la ejecucion y el autotest se volvio a pasar despues de cada una.

1. **La tabla de patrones del 4 no cubre la cartera.** `slep_minuta_asistencia` numera `C-001`..`C-037`. Ninguno de los seis patrones lo ve, y el ganador por conteo era `h2_num` midiendo encabezados de seccion: max 6 y clase `perdida_declarada` con delta 16, todo falso. Se agrego el patron `id_alfanum`; el repo pasa a max 37, que es la cifra que el propio archivo declara. El encargo dice *al menos* estos patrones, asi que agregar estaba permitido.
2. **Un backlog mezcla estilos de numeracion.** `slep_georreferenciacion` escribe unas entradas como `20.` y otras como `**25.`; `lista_num` solo veia las primeras y reportaba un hueco 25-30 que no existe. Se amplio `lista_num` a `^ *\*{0,2}([0-9]+)\.[* ]`. **Prueba decisiva aplicada:** tras el cambio el hueco falso desaparece y el hueco real del orquestador (55-61) sobrevive. Sin esa prueba, la correccion podria haber tapado la perdida que el censo existe para encontrar.
3. **El patron de rango del 5.4 lee hashes de git.** `([0-9]+) *a *([0-9]+)` encuentra `9a633` dentro del hash `df9a633` y devuelve 633. Se exigieron espacios y se admitio un prefijo corto: `([0-9]+) +a +[^ ]{0,3}([0-9]+)`, que sigue leyendo `C-022 a C-037` y `tramo 174 a 184`, y ya no lee hashes.
4. **El patron laxo `backlog...N` mide cualquier cosa.** Capturaba conteos de lineas (`backlog_consolidado.md` (nuevo, 197 lineas) -> 197), versiones y ordinales. Se ordenaron los patrones: los tres especificos primero y el laxo solo como ultimo recurso, y su valor **no puede sostener por si solo** la clase `perdida_declarada`. Sin esta correccion el censo habria acusado a `slep_seguimiento_educacion_inicial` de perder 163 entradas que nunca existieron.
5. **Un correlativo denso admite atipicos.** El backlog del orquestador contiene la linea `0304334. [codigo]`, una referencia que `lista_num` lee como entrada 304334. Se poda todo valor que supere al siguiente en mas del doble y por mas de 20, y se declara lo podado.

## 6. Autotest del encargo 6 (6/6)

```
================= AUTOTEST (encargo A-17, seccion 6) =================

--- C1: ### 1..10, traspaso declara 10
    esperado : calza, maximo 10
    medido   : clase=calza | convencion=h3_num | n_coincidencias=10 | max_backlog=10
               huecos=[] | traspaso=traspaso_cierre_v01.md | a_la_vista=1 | declarado=10 | delta=0
               linea_origen=El backlog acumulativo llega hasta la entrada 10.
    RESULTADO: PASA

--- C2: ### 1..5 y 8..10, traspaso declara 10
    esperado : hueco_interno, faltantes 6 y 7
    medido   : clase=hueco_interno | convencion=h3_num | n_coincidencias=8 | max_backlog=10
               huecos=[6-7] | traspaso=traspaso_cierre_v01.md | a_la_vista=1 | declarado=10 | delta=0
               linea_origen=El backlog acumulativo llega hasta la entrada 10.
    RESULTADO: PASA

--- C3: ### 1..40, traspaso declara 54
    esperado : perdida_declarada, delta 14
    medido   : clase=perdida_declarada | convencion=h3_num | n_coincidencias=40 | max_backlog=40
               huecos=[] | traspaso=traspaso_cierre_v01.md | a_la_vista=1 | declarado=54 | delta=14
               linea_origen=El backlog acumulativo llega hasta la entrada 54.
    RESULTADO: PASA

--- C4: tabla | 12 | hasta 12
    esperado : detecta tabla, maximo 12, no cero
    medido   : clase=calza | convencion=tabla | n_coincidencias=12 | max_backlog=12
               huecos=[] | traspaso=traspaso_cierre_v01.md | a_la_vista=1 | declarado=12 | delta=0
               linea_origen=El backlog acumulativo llega hasta la entrada 12.
    RESULTADO: PASA

--- C5: CONTROL NEGATIVO: 200 lineas sin numero de entrada
    esperado : convencion_no_detectada, nunca calza ni maximo 0
    medido   : clase=convencion_no_detectada | convencion=convencion_no_detectada | n_coincidencias=0 | max_backlog=
               huecos=[] | traspaso=traspaso_cierre_v01.md | a_la_vista=1 | declarado=10 | delta=
               linea_origen=El backlog acumulativo llega hasta la entrada 10.
    RESULTADO: PASA

--- C6: CONTROL NEGATIVO: dos traspasos, v03 declara 99
    esperado : elige v11, I5 incumplido (2 a la vista), no toma el 99
    medido   : clase=calza | convencion=h3_num | n_coincidencias=20 | max_backlog=20
               huecos=[] | traspaso=traspaso_cierre_v11.md | a_la_vista=2 | declarado=20 | delta=0
               linea_origen=El backlog acumulativo llega hasta la entrada 20.
    RESULTADO: PASA

=================== AUTOTEST GLOBAL: 6/6 PASAN ===================
```

La expectativa de C2 se reformulo para aceptar `6-7` ademas de `6 7`: la correccion 3 comprime los faltantes a rangos. Es un cambio de notacion, no de resultado; el caso sigue midiendo los mismos dos faltantes.

## 7. Observaciones que el censo dejo a la vista

- **Sin archivo de backlog (6):** `slep_alertas_ael`, `slep_costapresente`, `slep_dashboard_personal_monitoreo`, `slep_minuta_desvinculacion`, `slep_rendimiento_historico`, `slep_simce_estandares_aprendizaje`. Se comprobo con `find -iname '*backlog*'` que no es un fallo del localizador: no existe el archivo. Cuatro de los seis igual declaran numeros de backlog en su traspaso (`slep_rendimiento_historico` habla de `C52-C61`), lo que significa que su memoria vive dentro del traspaso y no en un archivo propio.
- **Sin repositorio git (2):** `slep_minuta_matricula` y `slep_resena_proyectos`.
- **Sin traspaso vigente (1):** `slep_minuta_buenas_senales`, con backlog de 19 entradas.
- **I5 incumplido:** 13 repositorios tienen mas de un traspaso a la vista; el maximo es 31 (`slep_minuta_desvinculacion`).
- **Arboles sucios al medir (A24):** 8 repositorios; el mayor es `slep_rendimiento_historico` con 22 archivos. Se marcan, no se descartan.

## 8. Precedencia de clasificacion aplicada

Un repo recibe una sola clase. El orden es: `sin_git` > `sin_backlog` > `convencion_no_detectada` > `sin_traspaso` > `perdida_declarada` > `hueco_interno` > `calza`. Cuando el traspaso no declara ningun numero comparable, la fila se clasifica por huecos y no por delta. Ninguna fila quedo en `convencion_no_detectada` en esta corrida.

