# ==============================================================================
# 00_escanear_proyecto.R
# ------------------------------------------------------------------------------
# Proposito : Escaner de estructura de ESTE repo (el orquestador), NO de los
#             hermanos (POLITICA 7). Emite un snapshot sellado .txt/.md y los
#             aliases estructura_actual.*, con poda atomica de retencion = 2.
# Insumos   : la raiz del orquestador (here/fs).
# Salidas   : 50_documentacion/estructura/ (snapshots + aliases), via
#             escribir_seguro.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

.raiz <- rprojroot::find_root(
  rprojroot::has_file("slep_estado_proyectos_monitoreo.Rproj") |
    rprojroot::is_rstudio_project |
    rprojroot::has_file(".here") |
    rprojroot::is_git_root
)
source(file.path(.raiz, "10_utils", "10_utils.R"), chdir = TRUE)
source(file.path(.raiz, "10_utils", "10_configuracion.R"), chdir = TRUE)

library(fs)

# ---- Parametros --------------------------------------------------------------

EXCLUIR_DIRS <- c(".git", ".Rproj.user", "renv", ".quarto")
INCLUIR_ARCHIVO <- FALSE  # _archivo/ fuera del snapshot por defecto (POLITICA 7.2).
DIR_ESTRUCTURA <- file.path(RAIZ_ORQUESTADOR, "50_documentacion", "estructura")
PATRON_SNAPSHOT <- "^\\d{8}_\\d{6}_estructura\\.(txt|md)$"

# ---- Funciones ---------------------------------------------------------------

#' TRUE si la ruta relativa cae dentro de un directorio excluido.
es_excluida <- function(rel) {
  comps <- strsplit(rel, "/", fixed = TRUE)[[1]]
  excl <- any(comps %in% EXCLUIR_DIRS)
  if (!INCLUIR_ARCHIVO) excl <- excl || ("_archivo" %in% comps)
  excl
}

#' Construye el cuerpo del snapshot (header, arbol con tamanos, conteo por ext).
construir_snapshot <- function(raiz) {
  info <- fs::dir_info(raiz, recurse = TRUE, all = FALSE, type = "any")
  rel  <- fs::path_rel(info$path, raiz)
  keep <- !vapply(rel, es_excluida, logical(1))
  info <- info[keep, ]; rel <- rel[keep]
  ord  <- order(rel)
  info <- info[ord, ]; rel <- rel[ord]

  n_dirs  <- sum(info$type == "directory")
  n_files <- sum(info$type == "file")
  tam_total <- sum(info$size[info$type == "file"], na.rm = TRUE)

  arbol <- vapply(seq_along(rel), function(i) {
    prof <- length(strsplit(rel[i], "/", fixed = TRUE)[[1]]) - 1L
    sangria <- strrep("  ", prof)
    base <- basename(rel[i])
    if (info$type[i] == "directory") {
      sprintf("%s%s/", sangria, base)
    } else {
      sprintf("%s%s  (%s)", sangria, base, format(info$size[i]))
    }
  }, character(1))

  exts <- tools::file_ext(rel[info$type == "file"])
  exts[exts == ""] <- "(sin extension)"
  tab <- sort(table(exts), decreasing = TRUE)
  conteo_ext <- sprintf("  %-18s %d", names(tab), as.integer(tab))

  c(
    "# Estructura del proyecto (escaner)",
    "",
    sprintf("- Raiz       : %s", basename(raiz)),
    sprintf("- Fecha      : %s", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
    sprintf("- Directorios: %d", n_dirs),
    sprintf("- Archivos   : %d", n_files),
    sprintf("- Tamano     : %s", format(tam_total)),
    "",
    "## Arbol",
    "",
    "```",
    paste0(basename(raiz), "/"),
    arbol,
    "```",
    "",
    "## Conteo por extension",
    "",
    "```",
    conteo_ext,
    "```"
  )
}

# ---- Flujo principal ---------------------------------------------------------

log_msg("Escaneando la estructura del orquestador...", "escaner")

cuerpo <- construir_snapshot(RAIZ_ORQUESTADOR)
sello  <- format(Sys.time(), "%Y%m%d_%H%M%S")

# 1) Escribir el snapshot nuevo (par .txt/.md).
ruta_txt <- file.path(DIR_ESTRUCTURA, sprintf("%s_estructura.txt", sello))
ruta_md  <- file.path(DIR_ESTRUCTURA, sprintf("%s_estructura.md", sello))
escribir_seguro(ruta_txt, function(r) writeLines(cuerpo, r, useBytes = TRUE))
escribir_seguro(ruta_md,  function(r) writeLines(cuerpo, r, useBytes = TRUE))

# 2) Actualizar aliases estaticos.
escribir_seguro(file.path(DIR_ESTRUCTURA, "estructura_actual.txt"),
                function(r) writeLines(cuerpo, r, useBytes = TRUE))
escribir_seguro(file.path(DIR_ESTRUCTURA, "estructura_actual.md"),
                function(r) writeLines(cuerpo, r, useBytes = TRUE))

# 3) Poda atomica (retencion = 2) SOLO si 1 y 2 no fallaron.
snaps <- list.files(DIR_ESTRUCTURA, pattern = PATRON_SNAPSHOT)
sellos <- unique(sub("_estructura\\.(txt|md)$", "", snaps))
sellos <- sort(sellos, decreasing = TRUE)
if (length(sellos) > 2) {
  a_borrar <- sellos[-(1:2)]
  for (s in a_borrar) {
    unlink(file.path(DIR_ESTRUCTURA, paste0(s, "_estructura.txt")))
    unlink(file.path(DIR_ESTRUCTURA, paste0(s, "_estructura.md")))
  }
  log_msg(sprintf("Poda: conservados 2 sellos, eliminados %d.", length(a_borrar)), "escaner")
}

log_msg(sprintf("Escaner completado. Snapshot %s + aliases actualizados.", sello), "escaner")
