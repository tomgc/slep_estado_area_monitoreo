# Traspaso de cierre v06 — slep_estado_proyectos_monitoreo

## 1. Identificacion

- **Proyecto:** slep_estado_proyectos_monitoreo (orquestador de estado de la cartera).
- **Version:** v06. **Fecha:** 2026-07-01. **Sesion:** 6 (CONTINUATION).
- **Foco:** curacion de `slep_paes` (P-PAES-REGISTRAR); incorporacion al backlog
  acumulativo de las 6 entradas de sesion 5 que habian quedado pendientes;
  P-DESYNC-MARGEN (margen de tolerancia de 1 dia en la regla de desincronizacion
  de ESTADO.md); P-FASE2-PIEZA-C (agenda priorizada: reordenamiento del
  acordeon por `tipo_pendiente`, criterio tipo_pendiente -> estado_proyecto ->
  fecha).
- **Entorno:** Claude (conversacional) + Positron (ejecucion directa por el
  titular, sin Claude Code esta sesion). R, macOS.
- **Archivos principales modificados:**
  - `20_insumos/registro_proyectos.csv`: fila `slep_paes` curada (nombre_real,
    alias_corto, categoria, datos_sensibles); `estado_proyecto` corregido a NA
    tras error del asistente (ver seccion 15).
  - `50_documentacion/activa/backlog_acumulativo.md`: entradas 48-54
    incorporadas (numeracion correlativa 1-54, sin renumerar entradas previas).
  - `10_utils/10_configuracion.R`: nueva constante `MARGEN_DESYNC_DIAS`.
  - `30_procesamiento/32_localizar_documentos.R`: `resolver_estado()` aplica el
    margen de tolerancia a la regla de desincronizacion.
  - `30_procesamiento/36_generar_panorama_visual.R`: nueva constante
    `RANGO_TIPO_PENDIENTE`; `construir_objeto()` agrega campo `tipo_pendiente`;
    orden de cards por tipo_pendiente -> estado_proyecto -> fecha; JS/CSS/HTML
    y `.md` muestran `tipo_pendiente` por proyecto y su conteo en el footer.

## 2. Resumen ejecutivo

Sesion breve y enfocada, sin Claude Code (todo ejecutado por el titular en
Positron a partir de archivos completos entregados por el asistente de
analisis). Se cerraron los dos pendientes mecanicos heredados del traspaso v05
(curacion de `slep_paes`, incorporacion de 6 entradas al backlog) y las dos
prioridades de codigo aprobadas al abrir la sesion: P-DESYNC-MARGEN (mejora la
cobertura PUSH real de 8/17 a 13/17, verificado en el log de `run_all()`) y
P-FASE2-PIEZA-C (agenda priorizada, el objetivo original que disparo todo el
trabajo de Fase 2 en la sesion 5, hoy verificado con 1 caso bug/bloqueante
mostrado en cabeza sobre 13 proyectos con ESTADO.md sincronizado). Un error del
asistente ocurrio y se corrigio en el camino: se curo `estado_proyecto=activo`
para `slep_paes` en el registro sin verificar contra el enum real que consume
`36_generar_panorama_visual.R` (`RANGO_ESTADO`, taxonomia de estado del
proyecto en el sentido editorial, no la del registro), lo que rompio la
primera corrida del pipeline (`subscript out of bounds`); diagnosticado con el
codigo real, corregido a NA (consistente con las 16 filas hermanas), y
registrado como entrada nueva en la tabla de errores del asistente. Estado
general: sano, pipeline corre limpio end-to-end, ambos pendientes de codigo
verificados con evidencia de log real (no solo reporte).

## 3. Estado al cierre

**Que funciona (ultima ejecucion exitosa 2026-07-01 14:59:12):**
- `run_all()` corre de cero sobre 17 hermanos sin intervencion manual (0
  errores, 6 pasos completados en 0.39 s).
- Fuente de estado en el paso 2: 13 PUSH / 4 PULL (mejora desde 8 PUSH / 9 PULL
  antes de esta sesion; los 4 casos de falso-desync conocidos del traspaso v05
  -- `dashboard_personal_monitoreo`, `georreferenciacion`,
  `seguimiento_educacion_inicial`, `alertas_ael` -- pasaron a PUSH).
- El acordeon del panorama visual ordena por `tipo_pendiente` (bug/bloqueante
  primero) -> `estado_proyecto` -> `fecha_actualizacion` (desc); verificado en
  el log de cierre del paso 6: "17 proyectos, 7 con backlog, 17 sin
  estado_proyecto, 4 sin tipo_pendiente, 1 bug/bloqueante en cabeza."
- `slep_paes` (17mo hermano) tiene fila curada en `registro_proyectos.csv`
  (nombre_real, alias_corto, categoria=activo, datos_sensibles=FALSE);
  `estado_proyecto` en NA (sin curacion editorial, consistente con el resto).
- Backlog acumulativo en 54 entradas correlativas (verificado por conteo:
  secuencia 1-54 sin huecos, entradas 46-54 nuevas respecto a lo commiteado en
  v04, sin renumeraciones de entradas previas).

**Que no funciona / queda pendiente:**
- 4 hermanos siguen en PULL: `slep_costapresente`, `slep_minuta_asistencia`,
  `slep_resena_proyectos` (sin traspaso, no pueden adoptar Fase 2 aun) y
  `slep_paes` (sin ESTADO.md, hermano nuevo).
- `slep_paes` no tiene traspaso ni `ESTADO.md`; su ficha en el panorama sigue
  saliendo generica (`tipo_pendiente` = NA, cae al final del orden del
  acordeon).
- 2 entradas del backlog (52, 54, eventos de mantenimiento de cartera) quedan
  sin categoria tematica asignada; nota explicita en el propio archivo sobre
  revisar si conviene una categoria nueva cuando haya mas casos.
- `RANGO_TIPO_PENDIENTE` y su etiquetado en JS/MD no fueron ejercitados
  visualmente por el asistente (sin acceso a navegador en esta sesion); la
  verificacion fue por log (conteos) y por lectura del codigo, no por
  inspeccion visual del HTML renderizado. Pendiente que el titular confirme
  visualmente que la etiqueta de `tipo_pendiente` se ve bien en la card.

**Delta respecto a v05:** +2 pendientes mecanicos cerrados (slep_paes,
backlog), +1 mejora de cobertura (P-DESYNC-MARGEN, 8->13 PUSH), +1
funcionalidad nueva completa (P-FASE2-PIEZA-C, agenda priorizada verificada),
+1 error del asistente detectado y corregido en la misma sesion (enum
equivocado en estado_proyecto de slep_paes).

## 4. Registro detallado de cambios

**Cambio 1 — Curacion de `slep_paes` en el registro.** Archivo
`20_insumos/registro_proyectos.csv`. Fila completada con datos provistos
explicitamente por el titular (nombre_real: "Motor de comparacion interactivo
de los resultados de la PAES"; alias_corto: "PAES", por patron del resto de
filas; categoria: "activo", unica categoria analitica de la cartera;
datos_sensibles: FALSE). Resuelve P-PAES-REGISTRAR (traspaso v05, seccion 11).
Corregido en dos pasadas: la primera curacion incluyo `estado_proyecto=activo`
por error del asistente (ver seccion 15); corregido a NA tras diagnosticar la
causa raiz con el codigo real de `36_generar_panorama_visual.R`.

**Cambio 2 — Incorporacion de 6 entradas al backlog acumulativo.** Archivo
`50_documentacion/activa/backlog_acumulativo.md`. Entradas 48-53 (rediseno
acordeon, diseno Fase 2, propagacion batch, lector de ESTADO.md, descubrimiento
de slep_paes, parche de registro de errores) copiadas desde
`traspaso_cierre_v05.md` seccion 4, mas entrada 54 (esta sesion: curacion de
slep_paes + esta misma incorporacion). Clasificacion tematica actualizada: 2
categorias nuevas ("Arquitectura Fase 2 (ESTADO.md)", "Gobernanza de proceso
(asistente)"); 2 entradas (52, 54) sin categoria por ahora, declarado
explicitamente en el propio archivo (bajo el umbral de creacion de categoria
de SETTINGS SS2.2.5). Resumen estadistico por sesion actualizado (sesion 5:
8 cambios totales, no 2; sesion 6: 1 en curso). Resuelve el pendiente mecanico
declarado en `traspaso_cierre_v05.md` seccion 5.

**Cambio 3 — P-DESYNC-MARGEN.** Archivos `10_utils/10_configuracion.R` y
`30_procesamiento/32_localizar_documentos.R`. Nueva constante nombrada
`MARGEN_DESYNC_DIAS <- 1L` (C.10, no numero magico embebido) junto a
`DIAS_OBSOLETO`. En `resolver_estado()`, la condicion de desincronizacion
cambia de `ua < mt` a `ua < (mt - margen)`, con fallback `margen <- 0L` si la
constante no existe (no rompe si el script corre suelto sin cargar
`10_configuracion.R` primero). Decision del titular: margen fijo de 1 dia
(no comparacion de solo-fecha, que podria ocultar un desync real de hasta 23
horas el mismo dia calendario). Verificado con log real de `run_all()`: los 4
casos conocidos de falso-desync (`dashboard_personal_monitoreo`,
`georreferenciacion`, `seguimiento_educacion_inicial`, `alertas_ael`) pasaron
de PULL a PUSH; fuente de estado global 8 PUSH / 9 PULL -> 13 PUSH / 4 PULL.
Sin push a git (el titular ejecuto localmente en Positron; el commit queda
pendiente de su parte).

**Cambio 4 — P-FASE2-PIEZA-C (agenda priorizada).** Archivo
`30_procesamiento/36_generar_panorama_visual.R`. Nueva constante
`RANGO_TIPO_PENDIENTE` (enum SETTINGS SS1.2.4: bug=0, bloqueante=1,
deuda_heredada=2, deuda_tecnica=3, nuevo=4, cosmetica=5, ninguno=6).
`construir_objeto()` agrega el campo `tipo_pendiente` leido del inventario
(`p$estado$tipo_pendiente`, ya tipado desde el paso 34 desde la sesion 5,
cambio 8 del traspaso v05); no se traduce ni se amplia el enum, solo se
consume. La Fase 2 de ordenamiento de `36` (`order()`) pasa de 2 claves
(estado_proyecto, fecha) a 3 claves (tipo_pendiente primero, estado_proyecto
segundo, fecha_actualizacion desc tercero), decision explicita del titular
sobre el orden de claves secundarias. JS: nueva `ETIQUETA_TP`, etiqueta de
`tipo_pendiente` visible en la cabecera de cada fila del acordeon (clase
`.der .tp`), conteo por `tipo_pendiente` agregado al footer (`#conteos-tp`,
junto al conteo por estado existente). HTML: nuevo `<div id="conteos-tp">` en
el footer. `.md`: nueva funcion `et_tp()`, linea "tipo de pendiente" agregada a
cada ficha de proyecto. Log de cierre del script ampliado con `n_sin_tp` y
`n_prioritarios` (conteo de bug/bloqueante en cabeza), verificables sin abrir
el HTML. Verificado con log real: "17 proyectos, 7 con backlog, 17 sin
estado_proyecto, 4 sin tipo_pendiente, 1 bug/bloqueante en cabeza." Los 4 sin
tipo_pendiente corresponden exactamente a los 4 proyectos en PULL (sin
ESTADO.md), consistente con el diseno. Verificacion visual del HTML
renderizado NO realizada por el asistente (sin navegador en esta sesion);
pendiente confirmacion del titular (ver seccion 3).

## 5. Backlog acumulativo

Ver `50_documentacion/activa/backlog_acumulativo.md`. 54 entradas al cierre de
esta sesion (48-54 incorporadas en el cambio 2; la propia entrada 54 documenta
el trabajo de esta sesion de forma resumida). No reproducir el contenido aqui
(regla vigente desde v05).

## 6. Bugs de la sesion

Sin bugs de codigo nuevos en esta sesion. El error del asistente de la seccion
15 (enum equivocado en `estado_proyecto` de `slep_paes`) no es un bug de
codigo: el codigo de `36_generar_panorama_visual.R` funciono correctamente
segun su contrato (`RANGO_ESTADO[[estado]]` con clave inexistente lanza error
por diseno de R, no por un defecto del script); el dato de entrada estaba mal
curado. Se documenta exclusivamente en la seccion 15 (errores del asistente),
no aqui, siguiendo la separacion de SETTINGS SS2.2.15.

## 7. Aprendizajes y restricciones (nuevos en s6)

- **La columna `estado_proyecto` del registro (`registro_proyectos.csv`) y el
  enum `RANGO_ESTADO` de `36_generar_panorama_visual.R` son cosas distintas
  con el mismo nombre.** El primero es un campo de curacion manual del
  registro (hoy NA en las 17 filas, sin uso activo verificado); el segundo es
  la taxonomia editorial que consume el ordenamiento del panorama visual
  (`inicial|en_desarrollo|con_productos|en_pausa|concluido`). Antes de curar
  o preguntar por "estado_proyecto" a secas, verificar contra que consumidor
  se esta hablando; nombrar el campo con su ruta completa
  (`registro_proyectos.csv$estado_proyecto` vs
  `36...R::RANGO_ESTADO`) evita el error de la seccion 15.
- **`resolver_estado()` y su regla de desincronizacion ahora usan un margen
  configurable, no una igualdad estricta de fecha.** Cualquier cambio futuro a
  `MARGEN_DESYNC_DIAS` debe declarar explicitamente el riesgo de ocultar
  desyncs reales (precaucion ya viva en el traspaso v05, section 11,
  trasladada aqui como restriccion vigente).
- **El orden del acordeon ahora tiene 3 claves, no 2.** Cualquier cambio futuro
  al layout o al ordenamiento de `36_generar_panorama_visual.R` debe preservar
  o declarar explicitamente el cambio de precedencia
  `tipo_pendiente -> estado_proyecto -> fecha`; es una decision de diseno del
  titular (D7 en seccion 8), no un detalle incidental.

## 8. Decisiones de diseno

**D7 — Margen de tolerancia para P-DESYNC-MARGEN: 1 dia fijo, no comparacion
de solo-fecha.** Alternativas: margen fijo (`ua < mt - N`) vs comparar solo la
fecha local del mtime ignorando la hora. Decision del titular (siguiendo la
recomendacion del asistente): margen fijo de 1 dia, como constante nombrada
`MARGEN_DESYNC_DIAS`. Justificacion: la comparacion de solo-fecha podria
ocultar un desync real de hasta 23 horas entre traspasos guardados el mismo
dia calendario; el margen fijo acota exactamente el patron de "medianoche"
documentado en el traspaso v05 sin ampliar la tolerancia mas alla de eso.

**D8 — Orden de claves secundarias en P-FASE2-PIEZA-C:
tipo_pendiente -> estado_proyecto -> fecha_actualizacion (desc).** Alternativa
descartada: tipo_pendiente -> fecha -> estado_proyecto. Decision explicita del
titular. Implicancia: dentro de un mismo grupo de `tipo_pendiente`, dos
proyectos se desempatan primero por su estado editorial y solo despues por
antiguedad de traspaso.

**D9 — `estado_proyecto` de `slep_paes` corregido a NA, no a un valor del enum
de `36`.** Tras el error de la seccion 15, alternativas evaluadas: (a) fijar
`estado_proyecto=en_desarrollo` en el registro para que el proyecto muestre
algo en el panorama, o (b) dejarlo en NA como las 16 filas hermanas. Decision
del asistente (autonomia POLITICA 0.3, sin gate porque no es estrategica):
opcion (b), porque la columna del registro no tiene evidencia de ser el campo
consumido por `RANGO_ESTADO` (que en la practica se alimenta de
`registro$estado_proyecto` via `construir_objeto()`, pero el valor real
esperado ahi es el enum editorial, no un enum de curacion generica); inventar
un valor del enum editorial sin fuente (data.js, traspaso) violaria B.1.

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `MARGEN_DESYNC_DIAS` | `1L` | 10_configuracion.R | Nueva (P-DESYNC-MARGEN) |
| `RANGO_TIPO_PENDIENTE` | 7 entradas, enum SETTINGS SS1.2.4 | 36 | Nueva (P-FASE2-PIEZA-C) |
| `RANGO_ESTADO` | 5 entradas (inicial..concluido) | 36 | Sin cambios; ver aprendizaje seccion 7 |
| `TZ_ORQUESTADOR` | zona local capturada al bootstrap | 10_configuracion.R | Sin cambios (s5) |
| Enum `tipo_pendiente` | `bug\|bloqueante\|deuda_heredada\|deuda_tecnica\|nuevo\|cosmetica\|ninguno` | SETTINGS SS2.1bis | Sin cambios; ahora tambien consumido por 36 |

## 10. Arquitectura de archivos

Sin cambios estructurales respecto a la politica. Escaner re-ejecutado y
vigente al cierre (`estructura_actual.md`, 2026-07-01 14:59:42, posterior a
todos los cambios de esta sesion). Sin archivos nuevos de estructura (los
cambios fueron ediciones de archivos existentes, mas la curacion del CSV).

## 11. Pendientes y ruta sugerida

**P-PAES-DOCUMENTAR** — descripcion: `slep_paes` sigue sin traspaso ni
`ESTADO.md`; su ficha en el panorama queda generica (sin sintesis, sin
tipo_pendiente, ordenada al final del acordeon). Tipo: nuevo. Impacto: bajo
para el orquestador (funciona con gracia), alto para la utilidad real de la
ficha. Complejidad: depende de `slep_paes` (fuera del control de este
proyecto). Dependencias: primer cierre formal de `slep_paes` con su propio
traspaso. Criterio de exito: `slep_paes` aparece en PUSH con `tipo_pendiente`
real tras su primer cierre.

**P-VERIFICACION-VISUAL-TP** — descripcion: la etiqueta de `tipo_pendiente` en
el acordeon (JS, clase `.der .tp`) y el conteo en el footer no fueron
verificados visualmente por el asistente en esta sesion (sin navegador
disponible). Tipo: deuda tecnica (verificacion, no funcionalidad). Impacto:
bajo (el log confirma los conteos correctos; el riesgo es puramente de CSS/
legibilidad, no de logica). Complejidad: baja (abrir el HTML, mirar). Criterio
de exito: el titular confirma que la etiqueta se ve legible y no rompe el
layout de la fila.

**P-ESTADO-3-SIN-TRASPASO** — sin cambios respecto al traspaso v05 (seccion
11): `slep_costapresente`, `slep_minuta_asistencia`, `slep_resena_proyectos`
siguen sin traspaso, no pueden adoptar Fase 2. Se agrega `slep_paes` a este
mismo bloqueante (ver P-PAES-DOCUMENTAR arriba, tratado por separado porque es
un proyecto nuevo, no uno con deuda de traspaso).

**Auditoria de cierre (politica 5.6, preguntas "Cierre"):**
- ¿Cada transformacion critica tiene check de validacion? Si (verificacion por
  log real en cada cambio de codigo, no solo confianza en el reporte).
- ¿Outputs reproducibles e idempotentes? Si, mismo patron de la sesion 5
  (no se corrieron 2+ corridas explicitas esta sesion para confirmar
  idempotencia end-to-end tras los cambios de 36; pendiente menor, no
  bloqueante).
- ¿Decisiones metodologicas como constantes nombradas? Si (`MARGEN_DESYNC_DIAS`,
  `RANGO_TIPO_PENDIENTE`, ver seccion 9).
- ¿Nombres de archivos sin tildes/ñ/espacios? Si, sin desviaciones nuevas.

**Ruta sugerida para sesion 7:** Prioridad 1: P-VERIFICACION-VISUAL-TP
(mecanica, del titular, revisar el HTML). Prioridad 2: decidir si vale la pena
correr 2 corridas seguidas de `run_all()` para confirmar idempotencia
byte-estable tras los cambios de 36 (deuda menor de esta sesion). Prioridad 3
(si el titular quiere seguir con cartera): evaluar si conviene push a git de
los cambios de esta sesion (quedaron solo locales en Positron).

## 12. Instrucciones especificas para la sesion 7

- ⚠️ Antes de curar cualquier campo de `registro_proyectos.csv` que tenga
  nombre igual a una constante de enum en `36_generar_panorama_visual.R`
  (`estado_proyecto` es el caso conocido), verificar contra el codigo real
  cual es el enum esperado, no asumir por el nombre del campo.
- ⚠️ No implementar cambios adicionales a `36_generar_panorama_visual.R` sin
  releer el archivo completo primero (crecio a 3 ediciones acumuladas en 2
  sesiones; alto riesgo de editar sobre una version mental desactualizada).
- ✅ ANTES de dar por cerrada cualquier tarea que modifique codigo, correr
  `run_all()` y pedir el log completo (no solo confiar en que "deberia
  funcionar"); regla aplicada consistentemente en s5 y s6.
- 🔒 Nunca escribir fuera del propio repo sin autorizacion explicita por
  repo/operacion (sin cambios respecto a v05; no aplico en esta sesion, no
  hubo escritura a hermanos).

## 13. Fragmentos de referencia

```r
# Patron correcto para margen de tolerancia con fallback (P-DESYNC-MARGEN)
margen <- if (exists("MARGEN_DESYNC_DIAS")) MARGEN_DESYNC_DIAS else 0L
if (ua < (mt - margen)) { /* desincronizado */ }
```

```r
# Patron correcto para orden multi-clave con enum + fallback (P-FASE2-PIEZA-C)
rango_tp_de <- function(tp) {
  if (is.na(tp)) return(length(RANGO_TIPO_PENDIENTE))
  r <- RANGO_TIPO_PENDIENTE[[tp]]
  if (is.null(r)) length(RANGO_TIPO_PENDIENTE) else r
}
```

## 14. Reapertura

**Nombre del chat:** `slep_estado_proyectos_monitoreo, sesion 7 (Sonnet 5)`

**Mensaje de apertura pre-armado:**
> Continuemos con slep_estado_proyectos_monitoreo. Tipo CONTINUATION. El
> protocolo (POLITICA_PROYECTO.md v5.2 + SETTINGS_Y_PROMPTS_OPERACIONALES.md
> v7) vive en la knowledge base del Project y se lee desde ahi. Adjunto el
> traspaso v06 y el escaner mas reciente.

**Documentos para la proxima sesion:**

1. *Protocolo en knowledge base* (verificar que esten al dia, NO adjuntar):
   `POLITICA_PROYECTO.md` (v5.2), `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (v7).
2. *Opcionales segun el foco real de la sesion 7*: ninguno identificado hoy;
   si se retoma `slep_paes` como proyecto propio, ese es otro Project.
3. *Especificos de la sesion (SI se adjuntan):* `traspaso_cierre_v06.md` (este
   archivo); escaner actualizado (re-ejecutar `00_escanear_proyecto.R` si
   pasaron cambios entre el cierre de esta sesion y la apertura de la
   proxima); `backlog_acumulativo.md` (ya en 54 entradas, sin pendiente de
   incorporacion esta vez).

**Nota final obligatoria:** ninguna advertencia de desactualizacion de
insumos: el escaner disponible al cierre de esta sesion es del mismo dia y
posterior a todos los cambios (`estructura_actual.md`, 2026-07-01 14:59:42).

## 15. Errores del asistente

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron |
|---|---|---|---|---|---|---|
| Curacion inicial de `slep_paes` en `registro_proyectos.csv` (Prioridad 1) | usuario no lo señalo directamente; el error se manifesto como fallo de ejecucion (`subscript out of bounds` en el paso 6 de `run_all()`) y el asistente lo diagnostico y corrigio antes de que el usuario tuviera que nombrarlo | El asistente pregunto al usuario por `estado_proyecto` usando el enum `activo\|pausa\|bloqueado\|cerrado` (visualmente razonable para una pregunta generica de "estado del proyecto") sin haber verificado antes contra el codigo real de `36_generar_panorama_visual.R` que ese mismo nombre de campo alimenta un enum completamente distinto (`RANGO_ESTADO`, taxonomia editorial `inicial\|en_desarrollo\|...`); el valor curado (`activo`) rompio el pipeline en la primera corrida real | POLITICA SS0.2 (si el asistente no sabe donde estan los archivos o como esta organizado el proyecto, debe escanear/leer antes de continuar, no deducir); B.1 (pensar antes de codificar, supuestos explicitos) | El asistente asumio que el nombre de un campo del CSV ("estado_proyecto") era suficiente para inferir su dominio de valores validos, sin verificar contra el consumidor real del dato (`36_generar_panorama_visual.R`, que no habia sido leido en el momento de la pregunta al usuario); la regla estaba disponible (el proyecto opera bajo POLITICA SS0.2 desde la sesion 1) pero no se aplico porque la tarea parecia "solo curacion de CSV", una tarea aparentemente de bajo riesgo que no disparo la cautela de leer codigo antes de preguntar | POLITICA SS0.2; principio B.1 (documento madre, aplicado transversalmente) | nuevo (primera ocurrencia de este patron especifico: inferir el dominio de un campo por su nombre en vez de verificar contra el codigo consumidor real, en una tarea percibida como "solo datos") |

**Nota del asistente:** a diferencia de los dos errores registrados en la
sesion 5 (ambos sobre "quien produce/mueve que"), este error es de una familia
distinta: asumir semantica de un campo de datos por su nombre sin verificar el
codigo que lo consume. Comparten un rasgo estructural (ambos ocurren en tareas
que el asistente clasifico internamente como "de bajo riesgo" antes de
verificar), lo que podria ser relevante para el analisis cruzado entre los 16
proyectos de la cartera si aparece un patron similar en otras sesiones (SETTINGS
SS2.2.15). El error se detecto y corrigio dentro de la misma sesion, sin
intervencion correctiva del usuario mas alla de pegar el log de error real;
esto es una señal positiva del mecanismo de verificacion por log real (regla
de la seccion 12 de este mismo traspaso), no una atenuante de la causa raiz.
