# ==============================================================================
# 00_run_all.R
# ------------------------------------------------------------------------------
# Proposito : Orquestador unico del pipeline determinista de la cartera
#             (POLITICA 4). Corre 31->35: descubre hermanos, localiza su
#             documentacion, extrae metadatos, compila el inventario y ensambla
#             panorama.md desde los cache/<slug>.md. Solo orquesta: cero logica
#             de negocio, sin cache automatico por timestamp.
# Insumos   : scripts de 30_procesamiento/ ; cache/<slug>.md (prosa del agente).
# Salidas   : inventario_cartera.json/.parquet y panorama.md en 40_salidas/.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ------------------------------------------------------------------------------
# Uso:
#   source("00_run_all.R"); run_all()
#   run_all(skip = c(5))      # omite el ensamblado del panorama
#   run_all(from = 3)         # desde 33_extraer_metadatos
#   run_all(only = 1)         # solo 31_descubrir_proyectos
# ==============================================================================

# ---- Anclaje y carga de utilidades (bootstrapping antes de library) ----------

.raiz <- rprojroot::find_root(
  rprojroot::has_file("slep_estado_proyectos_monitoreo.Rproj") |
    rprojroot::is_rstudio_project |
    rprojroot::has_file(".here") |
    rprojroot::is_git_root
)

source(file.path(.raiz, "10_utils", "10_utils.R"), chdir = TRUE)
source(file.path(.raiz, "10_utils", "10_configuracion.R"), chdir = TRUE)

# ---- Definicion de pasos -----------------------------------------------------

PASOS <- list(
  list(id = 1L, etiqueta = "Descubrir proyectos",   ruta = "30_procesamiento/31_descubrir_proyectos.R"),
  list(id = 2L, etiqueta = "Localizar documentos",  ruta = "30_procesamiento/32_localizar_documentos.R"),
  list(id = 3L, etiqueta = "Extraer metadatos",     ruta = "30_procesamiento/33_extraer_metadatos.R"),
  list(id = 4L, etiqueta = "Compilar inventario",   ruta = "30_procesamiento/34_compilar_inventario.R"),
  list(id = 5L, etiqueta = "Compilar panorama",     ruta = "30_procesamiento/35_compilar_panorama.R")
)

# ---- Orquestador -------------------------------------------------------------

#' Ejecuta el pipeline determinista de la cartera.
#' @param from,to   limitar el rango de pasos por id (inclusive).
#' @param only,skip vectores de ids a ejecutar exclusivamente / a omitir.
#' @param verbose   si TRUE, separadores por paso.
run_all <- function(from = NULL, to = NULL, only = NULL, skip = NULL, verbose = TRUE) {
  ids <- vapply(PASOS, function(p) p$id, integer(1))
  sel <- ids
  if (!is.null(from)) sel <- sel[sel >= from]
  if (!is.null(to))   sel <- sel[sel <= to]
  if (!is.null(only)) sel <- intersect(sel, only)
  if (!is.null(skip)) sel <- setdiff(sel, skip)

  # Validacion de precondiciones antes de empezar (POLITICA 4).
  validar_configuracion()
  for (p in PASOS) {
    ruta_abs <- file.path(RAIZ_ORQUESTADOR, p$ruta)
    if (!file.exists(ruta_abs)) {
      stop(sprintf("run_all(): no existe el script del paso %d: %s", p$id, p$ruta))
    }
  }

  log_msg(sprintf("Inicio del pipeline. Pasos a ejecutar: %s",
                  paste(sel, collapse = ", ")), "run_all")
  t_total <- Sys.time()
  ejecutados <- integer(0); saltados <- setdiff(ids, sel)

  for (p in PASOS) {
    if (!(p$id %in% sel)) next
    if (verbose) {
      cat("\n", strrep("=", 78), "\n", sep = "")
      cat(sprintf("[PASO %d] %s  ->  %s\n", p$id, p$etiqueta, p$ruta))
      cat(strrep("=", 78), "\n", sep = "")
    }
    t0 <- Sys.time()
    source(file.path(RAIZ_ORQUESTADOR, p$ruta), echo = FALSE, chdir = TRUE)
    dt <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 2)
    log_msg(sprintf("Paso %d (%s) completado en %s s.", p$id, p$etiqueta, dt), "run_all")
    ejecutados <- c(ejecutados, p$id)
  }

  dt_total <- round(as.numeric(difftime(Sys.time(), t_total, units = "secs")), 2)
  cat("\n", strrep("-", 78), "\n", sep = "")
  log_msg(sprintf("Pipeline terminado. Ejecutados: {%s}. Saltados: {%s}. Duracion: %s s.",
                  paste(ejecutados, collapse = ", "),
                  paste(saltados, collapse = ", "), dt_total), "run_all")
  invisible(list(ejecutados = ejecutados, saltados = saltados, duracion_s = dt_total))
}

# Ejecucion directa por Rscript (Rscript 00_run_all.R): sys.nframe()==0 a nivel
# tope solo bajo Rscript; al hacer source() desde consola la pila no esta vacia,
# de modo que source() define run_all() sin auto-ejecutarlo.
if (!interactive() && sys.nframe() == 0L) {
  run_all()
}
