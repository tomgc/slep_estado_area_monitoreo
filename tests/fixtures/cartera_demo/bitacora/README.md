# Bitácora de Campo

Aplicación web instalable (PWA) para registrar visitas en terreno sin conexión: formularios, fotos y geolocalización se guardan en el dispositivo y se sincronizan con Faro API cuando vuelve la señal.

## Propósito

Reemplazar las planillas en papel que hoy se digitan a mano al volver de cada visita, con trazabilidad de quién registró qué y cuándo.

## Funcionalidades

- Formularios configurables por tipo de visita.
- Captura de fotos con compresión en el dispositivo.
- Cola de sincronización con reintentos.
- Modo lectura de visitas anteriores del mismo lugar.

## Tecnologías

React 18, TypeScript, IndexedDB (vía Dexie), Workbox para el service worker. El backend de sincronización es `faro-api`.

## Cómo correr

```
npm install
npm run dev
```
