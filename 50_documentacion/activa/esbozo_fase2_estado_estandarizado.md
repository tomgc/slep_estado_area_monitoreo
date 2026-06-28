# Esbozo de Fase 2 - Estado estandarizado por proyecto (PUSH)

> PENDIENTE para una sesion dedicada. Este documento solo ESBOZA la idea y deja
> una recomendacion; NO la ejecuta. En esta sesion (Fase 1) no se creo ni
> modifico ningun `ESTADO.md` ni ningun `SETTINGS` en proyectos hermanos
> (POLITICA 9: no mezclar cambios; la edicion de SETTINGS es sesion BIBLIOTECA
> aparte).

## 1. Problema que resuelve

En Fase 1 (PULL, ya implementada) el orquestador recomputa el estado de cada
proyecto leyendo bajo demanda su reseña + ultimo traspaso + backlog y
sintetizando la ficha. Es robusto pero tiene dos costos: (a) la sintesis
cualitativa la rehace el agente cada vez que el sello de frescura cambia, y (b)
la lectura depende de que cada proyecto documente de forma interpretable
(heterogeneidad resuelta por patron en `32_localizar_documentos.R`).

La Fase 2 (PUSH) invertiria la responsabilidad: cada proyecto mantendria, en su
propio cierre de sesion, un **resumen de estado corto y estandarizado**, que el
orquestador leeria casi literal en lugar de recomputarlo.

## 2. Esquema candidato de `ESTADO.md`

Un archivo por proyecto, ubicacion candidata `50_documentacion/activa/ESTADO.md`,
con front matter estructurado mas tres secciones breves:

```
---
slug: <slug>
nombre_real: <nombre>
categoria: activo
semaforo: activo|pausa|bloqueado|cerrado
sesion_actual: vNN
ultima_actividad: AAAA-MM-DD
maneja_sensibles: true|false
---
## En que vamos
<2-3 oraciones>
## Proximo paso
<1 oracion>
## Bloqueantes
<lista o "ninguno">
```

El front matter es lo que el orquestador parsea de forma determinista (hoy 35
ya parsea ese mismo formato desde `cache/<slug>.md`, asi que el motor de lectura
casi no cambia: solo cambia la fuente, de cache propio a `ESTADO.md` del
hermano). Las tres secciones en prosa alimentan directamente la ficha L2.

## 3. Cambio minimo en el protocolo de cierre (descrito, no redactado)

El protocolo de cierre vive en `SETTINGS_Y_PROMPTS_OPERACIONALES.md` seccion 2.
El cambio minimo consistiria en agregar, dentro de la generacion del traspaso
(2.1) o como paso inmediatamente posterior, una instruccion para que el cierre
**genere o actualice `ESTADO.md`** con: el semaforo y la sesion vigente; las 2-3
oraciones de "en que vamos" tomadas del resumen ejecutivo del traspaso (2.2.2);
el proximo paso tomado de la ruta sugerida (2.2.11); y los bloqueantes tomados
del inventario de pendientes marcados como bloqueante. Es decir, `ESTADO.md`
seria una **destilacion** de campos que el traspaso ya produce, no informacion
nueva: el costo marginal por cierre es bajo.

Esa edicion de SETTINGS implica subirlo a una v5 y propagarlo a los 16 proyectos
(migracion documental). Es trabajo de una sesion BIBLIOTECA dedicada; aqui solo
se describe que tendria que cambiar y donde, sin producir el texto de reemplazo.

## 4. Pros y contras frente a seguir solo con PULL

**A favor de Fase 2 (PUSH):**
- La sintesis la hace quien tiene el contexto fresco (el agente que cierra la
  sesion del proyecto), no el orquestador a posteriori.
- Lectura del orquestador mas barata y mas estable: parsea un formato fijo,
  reduce la dependencia de la heterogeneidad de grafias/ubicaciones.
- `maneja_sensibles` declarado por el propio proyecto cierra el hueco H4 del
  reporte de cobertura (hoy el flag depende de la presencia de
  `gobernanza_datos.md`).

**En contra / costos:**
- Requiere migrar SETTINGS a v5 y propagarlo a 16 repos: esfuerzo y disciplina
  de mantenimiento en cada cierre.
- Riesgo de `ESTADO.md` desactualizado si un cierre lo omite; el orquestador
  deberia cruzar `ultima_actividad` del `ESTADO.md` contra el mtime real del
  ultimo traspaso para detectar desincronizacion.
- Duplica informacion que ya esta en el traspaso (mitigado si se genera
  automaticamente como destilacion).

## 5. Recomendacion explicita

**Recomendacion:** adoptar un **modelo hibrido** - PUSH para el front matter
estructurado (`ESTADO.md` con semaforo, sesion, fecha, sensibilidad, proximo
paso, bloqueantes), y mantener el PULL del orquestador como **fallback** para los
proyectos que aun no tengan `ESTADO.md` o cuyo `ESTADO.md` este desincronizado
respecto del mtime del ultimo traspaso. Razon: captura el beneficio principal
(lectura barata y estable, sintesis con contexto fresco) sin romper la cobertura
de los proyectos que tarden en adoptar el estandar, y reaprovecha el parser de
front matter que 35 ya tiene. La decision final es del titular.
