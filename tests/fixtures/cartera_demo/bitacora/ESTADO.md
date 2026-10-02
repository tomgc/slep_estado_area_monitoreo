---
estado: activo
fase: desarrollo
avance: 62
ultima_actividad: 2026-09-29
prioridad: alta
categoria: Producto
tecnologias: React, TypeScript, IndexedDB, Workbox
tags: offline, terreno, pwa, frontend
---

## En qué vamos

La captura offline ya es estable en Android. El foco de las últimas semanas es la cola de sincronización: los reintentos funcionan, pero los conflictos cuando dos personas editan la misma visita todavía se resuelven a mano.

## Qué funciona

- Formularios dinámicos con validación.
- Fotos comprimidas a menos de 400 KB.
- Instalación como app en Android y escritorio.

## Qué falta

- Resolución de conflictos de sincronización.
- Pruebas en iOS (Safari limita el almacenamiento).

## Próximo paso

Implementar la estrategia de conflictos "última escritura gana con registro de versiones" y probarla con dos dispositivos.

## Bloqueantes

ninguno

## Bitácora

- 2026-09-29: cola de sincronización con reintentos exponenciales.
- 2026-09-22: compresión de fotos en un web worker.
- 2026-09-10: formularios dinámicos desde JSON de configuración.
- 2026-08-28: primera instalación como PWA en terreno.
- 2026-08-14: piloto con tres personas del equipo.
