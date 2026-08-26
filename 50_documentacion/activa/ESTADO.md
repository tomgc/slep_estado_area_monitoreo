---
slug: slep_estado_proyectos_monitoreo
nombre_real: Orquestador de estado de la cartera (Area de Monitoreo)
categoria: activo
semaforo: activo
sesion_actual: v12
ultima_actividad: 2026-08-26
maneja_sensibles: false
tipo_pendiente: bloqueante
sesion_abierta: true
maquina: macbook-titular
commit_cierre: acdc6ff
traspaso_vigente: traspaso_cierre_v12.md
cierre_incompleto: no
insumos_verificados: 2026-08-26
ventana_insumos: ./20_insumos
---
## En que vamos
Sesion de rescate. El repositorio estuvo 44 dias sin integrar y con dos traspasos
existiendo solo en disco; los dos tramos del rescate los publicaron y dejaron main
sincronizado en 0 0. Se reviso la knowledge base completa (POLITICA v5.8, SETTINGS v34)
y se censaron los 25 directorios de la cartera: 20 de 25 hermanos no tienen ningun campo
de candado y 14 incumplen el invariante I5. Se corrigio un bug que tumbaba el paso 6
ante cualquier tipo_pendiente fuera del enum. El intento de reconstruir el backlog
destapo que las entradas 55 a 61 nunca llegaron a git y son irrecuperables.

## Proximo paso
Ejecutar renv::restore() para devolver el pipeline a operacion, comprobar si hay mas
backlogs de la cartera con entradas perdidas, y despachar las cinco decisiones del
inventario de pendientes, que desbloquean cuatro encargos. Antes de tocar codigo, el
diagnostico de data.js y de estado_proyecto.

## Bloqueantes
El pipeline no corre hasta que se restauren los 38 paquetes que declara renv.lock. La
decision sobre registro_proyectos.csv bloquea el paso de cierre de arbol del comando
unico. El rescate de slep_rendimiento_historico requiere autorizacion de escritura y
sesion propia.

