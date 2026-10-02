# Encargo para Claude Design: propuestas de mejora del Portafolio de Proyectos

> Texto para pegar en Claude Design (desde "Contexto" hacia abajo). Adjuntar todo el contenido de esta carpeta:
> `portafolio_preview.html`, `portafolio_preview_datos.json`, `colors_and_type.css`, `fuentes/` (4 archivos gobCL) y `capturas/` (12 imágenes).
> Copia fechada 2026-10-02 del prototipo (commit 398469c); el original se regenera con `30_procesamiento/39_portafolio_generar.R`.

---

## Contexto

El Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos del SLEP Costa Central (servicio público de educación, Chile) mantiene una cartera de alrededor de 25 proyectos de análisis de datos y desarrollo. Cada proyecto documenta su avance en archivos Markdown (README, ESTADO, TODO, BACKLOG, ROADMAP, CHANGELOG). Un proceso en R lee esa documentación y genera **Portafolio de Proyectos**: un único archivo HTML autocontenido que el equipo abre con doble clic para entender, en pocos segundos, el estado de toda la cartera.

Se adjunta el prototipo funcional (`portafolio_preview.html`), alimentado por una cartera demo de 12 proyectos ficticios, más capturas de cada vista. Todo lo que se ve funciona: búsqueda, filtros, orden, tema claro y oscuro, detalle de proyecto y mapa de relaciones.

**Usuarios:** el equipo del Área (análisis y gestión de datos). Lo usan en escritorio, a veces en laptop o tablet. La pregunta que debe responder la vista principal es: "¿cuál es el estado general de todo lo que estamos construyendo?". La pregunta del detalle es: "¿qué es este proyecto, en qué estado está, cuánto falta, qué lo bloquea, qué hay pendiente ahora, qué hay en el backlog y cuál es el siguiente paso?".

## Qué se pide

Una revisión crítica del producto **en su estado actual** y propuestas de mejora concretas, priorizadas, que el equipo pueda implementar. No se pide un rediseño desde cero ni un cambio de identidad.

Evaluar especialmente:

1. **Comprensión en cinco segundos.** ¿La cabecera (total, estados, ciclo de vida, actividad de 12 semanas, proyectos que requieren atención) cuenta la historia correcta? ¿Qué sobra y qué falta?
2. **Panorama frente a Proyectos.** Hay que decidir cuál vista es la principal. Panorama es una tabla densa (una fila por proyecto). Proyectos es una grilla de tarjetas con tres niveles de detalle. Recomendar una y justificar.
3. **Jerarquía y densidad.** Las filas y tarjetas ya se ampliaron para que respiren. ¿El equilibrio entre información visible y legibilidad es correcto con 25 proyectos o más?
4. **Representación del progreso.** Hay cuatro casos: avance declarado (anillo con porcentaje), avance por fases del roadmap (segmentos), solo fase conocida y sin dato. ¿Se distinguen bien? ¿Se entiende que no todos los proyectos tienen porcentaje?
5. **Ahora, Backlog y Roadmap.** En el detalle se representan distinto a propósito: lista de verificación, reserva agrupada por categoría y línea de fases. ¿Se percibe la diferencia? ¿El backlog transmite si está sano o si acumula trabajo sin priorizar?
6. **Señales.** Las alertas (posible abandono, bloqueos, backlog sin priorizar, hito vencido, documentación incompleta) son íconos pequeños. ¿Son suficientemente visibles sin volverse ruidosas?
7. **Procedencia del dato.** La interfaz distingue entre dato declarado, dato inferido (subrayado punteado) y dato ausente (cursiva gris). ¿Es comprensible para un usuario que no conoce esta convención?
8. **Mapa de relaciones.** Es experimental. ¿Aporta o conviene reemplazarlo por otra forma de mostrar dependencias?
9. **Accesibilidad.** Verde (activo) y naranja (bloqueado) son difíciles de distinguir con daltonismo; hoy se compensa con forma (círculo frente a rombo) y etiqueta escrita. Evaluar si basta.
10. **Responsive.** Prioridad: escritorio, luego laptop, luego tablet.

## Restricciones que no se pueden cambiar

- **Producto:** un solo HTML autocontenido, sin servidor, sin Internet, sin CDN. HTML, CSS y JavaScript sin frameworks.
- **Datos:** solo puede mostrarse lo que la documentación declara o lo que se calcula con una regla explícita. No se inventan porcentajes, fechas ni estados. Una propuesta que requiera un dato inexistente debe decir de qué archivo Markdown saldría.
- **Tipografía:** solo **gobCL** (Light 300, Regular 400, Bold 700, Heavy 900), también para cifras. No hay fuente monoespaciada. gobCL tiene altura de x baja (0,49 em).
- **Tamaños de letra:** máximo cinco, hoy 14, 15, 17, 24 y 44 px. El mínimo legible es 14 px.
- **Mayúsculas:** prohibido usar texto en mayúsculas sostenidas como estilo; solo siglas (MVP, API).
- **Paleta:** la de `colors_and_type.css` del SLEP.
  - Color principal: azul institucional `#0062A0`.
  - Fondo crema `#FFF6E0` y tarjetas blancas.
  - Estados: olive `#75924E` activo, naranja `#D2693A` bloqueado (texto `#9A4A22`), plum `#4A2746` en pausa, gris `#747474` terminado.
  - Amarillo `#FFC92E` para avisos.
  - El rojo `#EE2D49` queda reservado para situaciones graves.
- **Forma:** radios de 2 a 8 px, sin formas de píldora, sombras contenidas.
- **Idioma:** interfaz en español neutro, sin voseo.

## Formato de respuesta esperado

1. **Diagnóstico breve:** los cinco problemas más importantes del estado actual, en orden de impacto.
2. **Propuestas priorizadas:** tabla con columnas *problema · propuesta · vista o componente afectado · impacto (alto, medio, bajo) · esfuerzo (alto, medio, bajo)*.
3. **Maquetas** de las dos pantallas más importantes con las mejoras aplicadas: la vista principal y el detalle de proyecto. Respetar todas las restricciones.
4. **Recomendación explícita** sobre la vista principal (Panorama o Proyectos) y sobre el mapa de relaciones (mantener, rediseñar o retirar).
5. **Lo que no cambiaría:** qué funciona bien y conviene conservar.

Evitar propuestas que solo agreguen decoración. El criterio es: comprensión antes que cantidad de información, y cantidad de información antes que decoración.
