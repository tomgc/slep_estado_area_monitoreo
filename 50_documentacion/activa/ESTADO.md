---
slug: slep_estado_proyectos_monitoreo
nombre_real: Orquestador de estado de la cartera (Area de Monitoreo)
categoria: activo
semaforo: activo
sesion_actual: v13
ultima_actividad: 2026-08-27
maneja_sensibles: false
tipo_pendiente: bug
sesion_abierta: true
maquina: MacBook-Pro-de-Tomas
commit_cierre: 88394ad
traspaso_vigente: traspaso_cierre_v13.md
cierre_incompleto: no
insumos_verificados: 2026-08-27
ventana_insumos: ./40_salidas
---
## En que vamos
Sesion de desbloqueo y correccion. El candado abrio recien tras ejecutar D-01, que saco
registro_proyectos.csv del control de versiones y lo movio a 40_salidas. Restaurado renv,
el pipeline volvio a operacion. El censo de los 26 directorios de la cartera resolvio la
duda heredada: la perdida de las entradas 55-61 fue un accidente aislado y no un patron.
El diagnostico de data.js encontro tres defectos apilados, no uno, y los tres se
corrigieron: once fichas del panorama recuperaron tipo, objetivo y sintesis.

## Proximo paso
Diagnosticar por que semaforo llega nulo a todas las fichas del panorama publicado,
midiendo primero en los ESTADO.md de los hermanos antes de suponer una cadena de
extraccion. Es el campo por el que se lee la cartera de un vistazo y ninguna de las trece
sesiones lo habia visto.

## Bloqueantes
El PR #4 sin mergear deja la ordenacion fuera de main. _archivo/ esta en .gitignore, asi
que cualquier archivo nuevo depositado ahi queda sin versionar sin aviso. El paso 1 no es
idempotente sobre campos curados vacios y corrompe el registro en la segunda corrida.
