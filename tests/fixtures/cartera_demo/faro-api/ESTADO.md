---
estado: bloqueado
fase: mvp
avance: 45
ultima_actividad: 2026-09-24
prioridad: alta
categoria: Infraestructura
tecnologias: R, plumber, PostgreSQL, Docker
tags: backend, api, datos
---

## En qué vamos

Los endpoints de lectura están listos y probados contra una base local. El despliegue al servidor institucional está detenido: falta la credencial de la base de producción y la apertura del puerto en el firewall.

## Qué funciona

- GET de indicadores y series con paginación.
- Pruebas automáticas de los endpoints de lectura.

## Qué falta

- POST de visitas (lo necesita Bitácora).
- Despliegue en el servidor institucional.

## Próximo paso

Pedir por escrito a Infraestructura la credencial de solo lectura de producción y la apertura del puerto 8443, con fecha comprometida.

## Bloqueantes

- Credencial de la base de producción solicitada el 2026-09-02, sin respuesta.
- Puerto 8443 cerrado en el firewall del servidor institucional.

## Bitácora

- 2026-09-24: pruebas de carga de los endpoints de series.
- 2026-09-12: paginación por cursor.
- 2026-09-02: solicitud de credenciales a Infraestructura.
- 2026-08-20: esquema de indicadores precalculados.
