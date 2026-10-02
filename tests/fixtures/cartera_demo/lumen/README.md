# Lumen

Generador de informes PDF parametrizados. A partir de una plantilla Quarto y una tabla de parámetros, produce un informe por unidad (por ejemplo, uno por establecimiento) con tipografía y gráficos consistentes.

**Estado:** terminado. Se usa en producción desde marzo de 2026 y no tiene trabajo previsto.

## Tecnologías

R, Quarto, Typst para el motor PDF.

## Uso

```r
lumen::renderizar_lote(plantilla = "informe.qmd", parametros = "unidades.csv")
```
