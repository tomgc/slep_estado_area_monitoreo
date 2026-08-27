# ==============================================================================
# 33_extraer_metadatos.R
# ------------------------------------------------------------------------------
# Proposito : Extraer metadatos DETERMINISTAS por proyecto (cero interpretacion):
#             fechas de actividad (mtime de traspaso/escaner), sellos md5 de los
#             documentos clave (para la frescura del cache, seccion 9) y, si
#             LEER_GIT, la fecha del ultimo commit del hermano (solo lectura de
#             metadatos git; jamas toca el indice del hermano, seccion 8).
# Insumos   : lista_documentos (de 32), constantes (10_configuracion.R).
# Salidas   : df_metadatos (data.frame por slug) en el entorno global.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

# ---- Funciones ---------------------------------------------------------------

#' Fecha (YYYY-MM-DD) del mtime de un archivo, o NA si no existe.
#'
#' La zona es EXPLICITA (TZ_ORQUESTADOR, capturada al bootstrap en
#' 10_configuracion.R). `as.Date()` sobre un POSIXct usa tz = "UTC" por defecto,
#' asi que un archivo guardado de noche en America/Santiago se fechaba un dia
#' MAS TARDE aqui que en la regla de sincronia del paso 32, que si declaraba la
#' zona. Mientras el desync toleraba un margen de 1 dia la discrepancia quedaba
#' absorbida; al migrar la regla a correlativos (v14b) ese amortiguador
#' desaparecio y la diferencia quedo a la vista. D-24-D.
fecha_mtime <- function(ruta) {
  if (is.na(ruta) || !file.exists(ruta)) return(NA_character_)
  tz_loc <- if (exists("TZ_ORQUESTADOR")) TZ_ORQUESTADOR else ""
  format(file.info(ruta)$mtime, "%Y-%m-%d", tz = tz_loc)
}

#' Fecha del ultimo commit del hermano (solo lectura de metadatos git). Devuelve
#' NA si LEER_GIT es FALSE, si no hay repo git, o si git no esta disponible.
fecha_ultimo_commit <- function(ruta_proyecto) {
  if (!isTRUE(LEER_GIT)) return(NA_character_)
  if (!dir.exists(file.path(ruta_proyecto, ".git"))) return(NA_character_)
  out <- tryCatch(
    system2("git", c("-C", shQuote(ruta_proyecto), "log", "-1",
                     "--format=%cd", "--date=short"),
            stdout = TRUE, stderr = FALSE),
    error = function(e) character(0), warning = function(w) character(0)
  )
  if (length(out) == 0 || !nzchar(out[1])) NA_character_ else out[1]
}

#' Maxima de un conjunto de fechas YYYY-MM-DD (character), ignorando NA.
fecha_max <- function(...) {
  fechas <- c(...)
  fechas <- fechas[!is.na(fechas)]
  if (length(fechas) == 0) return(NA_character_)
  max(fechas)  # orden lexicografico == cronologico en formato ISO
}

# ---- Flujo principal ---------------------------------------------------------

if (!exists("lista_documentos")) {
  stop("33_extraer_metadatos.R: falta lista_documentos. Ejecute via 00_run_all.R.")
}

log_msg("Extrayendo metadatos deterministas (fechas, sellos, git)...", "33_extraer")

df_metadatos <- do.call(rbind, lapply(lista_documentos, function(d) {
  fecha_traspaso <- fecha_mtime(d$ruta_traspaso)
  fecha_escaner  <- fecha_mtime(d$ruta_escaner)
  fecha_commit   <- fecha_ultimo_commit(d$ruta_proyecto)

  data.frame(
    slug           = d$slug,
    fecha_traspaso = fecha_traspaso,
    fecha_escaner  = fecha_escaner,
    fecha_actividad = fecha_max(fecha_traspaso, fecha_escaner),
    fecha_commit   = fecha_commit,
    md5_traspaso   = hash_archivo(d$ruta_traspaso),
    md5_resena     = hash_archivo(d$ruta_resena),
    md5_backlog    = hash_archivo(d$ruta_backlog),
    stringsAsFactors = FALSE
  )
}))
rownames(df_metadatos) <- NULL

log_msg(sprintf("Metadatos extraidos para %d proyectos (LEER_GIT = %s).",
                nrow(df_metadatos), LEER_GIT), "33_extraer")
