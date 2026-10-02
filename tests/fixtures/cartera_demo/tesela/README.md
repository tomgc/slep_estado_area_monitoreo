# Tesela

Experimento: mapas de calor del territorio agregados en teselas hexagonales (H3), renderizados en el navegador con deck.gl. La pregunta es si los hexágonos comunican mejor que los polígonos comunales cuando hay pocos datos por zona.

**Estado:** experimental. No hay compromiso de llegar a producción.
**Última actividad:** 2026-09-15

## Tecnologías

JavaScript, deck.gl, H3.

## Hallazgos hasta ahora

- Con resolución 7 los hexágonos ocultan establecimientos aislados.
- Con resolución 9 el mapa se vuelve ruido.
- La resolución 8 parece el punto medio, pero falta probar con datos reales.
