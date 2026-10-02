# Faro API

Backend REST que expone indicadores consolidados (asistencia, matrícula, resultados) a las aplicaciones del equipo. Es la fuente única de datos para `bitacora`, `vitrina` y `relevo`.

## Arquitectura

- R con plumber para los endpoints.
- PostgreSQL como almacén de indicadores precalculados.
- Contenedor Docker desplegado detrás de un proxy interno.
- Autenticación por token de servicio.

## Endpoints principales

| Método | Ruta | Descripción |
|---|---|---|
| GET | /indicadores | Lista de indicadores disponibles |
| GET | /indicadores/{id}/serie | Serie temporal de un indicador |
| POST | /visitas | Recibe visitas sincronizadas desde Bitácora |
