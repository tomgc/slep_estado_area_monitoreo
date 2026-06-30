# ==============================================================================
# 10_utils.R
# ------------------------------------------------------------------------------
# Proposito : Bootstrapping del orquestador. Funciones genericas sin dependencia
#             de paquetes cargados (se invoca paquete::funcion() para poder
#             cargar este archivo ANTES de cualquier library() ; POLITICA 1.4).
# Insumos   : ninguno.
# Salidas   : define instalar_si_falta(), log_msg(), escribir_seguro() y
#             helpers de escritura atomica / hash en el entorno global.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

# ---- Auto-instalacion de dependencias ----------------------------------------

#' Instala los paquetes que falten, sin recargar los ya presentes.
#' @param paquetes character vector con nombres de paquetes.
instalar_si_falta <- function(paquetes) {
  faltantes <- paquetes[!vapply(
    paquetes,
    function(p) requireNamespace(p, quietly = TRUE),
    logical(1)
  )]
  if (length(faltantes) > 0) {
    message("[10_utils] Instalando paquetes faltantes: ",
            paste(faltantes, collapse = ", "))
    install.packages(faltantes)
  }
  invisible(paquetes)
}

# ---- Logging -----------------------------------------------------------------

#' Emite un mensaje con sello temporal uniforme (POLITICA 4).
#' Formato: [YYYY-MM-DD HH:MM:SS] [origen] [NIVEL] mensaje
#' @param mensaje texto a registrar.
#' @param origen  etiqueta de la etapa que emite (p. ej. "31_descubrir").
#' @param nivel   "INFO" | "WARN" | "ERROR".
log_msg <- function(mensaje, origen = "orquestador", nivel = "INFO") {
  nivel <- match.arg(nivel, c("INFO", "WARN", "ERROR"))
  sello <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[%s] [%s] [%s] %s\n", sello, origen, nivel, mensaje))
  invisible(NULL)
}

# ---- Confinamiento de escritura (cierre por codigo de R1) --------------------

#' Ejecuta una escritura SOLO si la ruta destino cuelga de la raiz del
#' orquestador. Este es el mecanismo que cierra R1 por codigo: una escritura
#' accidental hacia un proyecto hermano la bloquea la funcion, no la disciplina
#' del agente.
#'
#' @param ruta     ruta destino (el archivo puede no existir todavia).
#' @param escritor funcion de un argumento que recibe la ruta YA VALIDADA y
#'                 normalizada, y realiza la escritura efectiva (writeLines,
#'                 arrow::write_parquet, jsonlite::write_json, etc.).
#' @param raiz     raiz del orquestador; por defecto toma RAIZ_ORQUESTADOR del
#'                 entorno global (definida en 10_configuracion.R).
#' @return invisible(ruta_validada).
escribir_seguro <- function(ruta, escritor, raiz = NULL) {
  if (is.null(raiz)) {
    if (!exists("RAIZ_ORQUESTADOR", inherits = TRUE)) {
      stop("escribir_seguro(): RAIZ_ORQUESTADOR no definido. ",
           "Cargue 10_utils/10_configuracion.R antes de escribir.")
    }
    raiz <- get("RAIZ_ORQUESTADOR", inherits = TRUE)
  }
  if (!is.function(escritor)) {
    stop("escribir_seguro(): 'escritor' debe ser una funcion de un argumento.")
  }

  dir_destino <- dirname(ruta)
  if (!dir.exists(dir_destino)) {
    dir.create(dir_destino, recursive = TRUE, showWarnings = FALSE)
  }

  # Normalizamos el DIRECTORIO (que ya existe), no el archivo, que puede no
  # existir aun; asi resolvemos symlinks de forma fiable en Mac y Windows.
  dir_norm  <- normalizePath(dir_destino, winslash = "/", mustWork = TRUE)
  raiz_norm <- normalizePath(raiz,        winslash = "/", mustWork = TRUE)

  dentro <- dir_norm == raiz_norm ||
    startsWith(paste0(dir_norm, "/"), paste0(raiz_norm, "/"))
  if (!dentro) {
    stop(sprintf(
      "escribir_seguro(): ABORTADO. Ruta fuera del repo del orquestador.\n  destino: %s\n  raiz   : %s",
      dir_norm, raiz_norm
    ))
  }

  ruta_final <- file.path(dir_norm, basename(ruta))
  escritor(ruta_final)
  invisible(ruta_final)
}

#' Escritura atomica write -> rename (POLITICA 5.2.4) confinada por
#' escribir_seguro. Escribe a un archivo temporal en el MISMO directorio y luego
#' renombra, para que ningun lector vea un archivo a medio escribir.
#'
#' @param ruta     ruta destino final.
#' @param escritor funcion de un argumento (ruta_tmp) que escribe el contenido.
escribir_atomico <- function(ruta, escritor) {
  escribir_seguro(ruta, function(ruta_validada) {
    tmp <- paste0(ruta_validada, ".tmp")
    on.exit(if (file.exists(tmp)) unlink(tmp), add = TRUE)
    escritor(tmp)
    if (!file.rename(tmp, ruta_validada)) {
      # file.rename puede fallar entre sistemas de archivos distintos; aqui
      # tmp y destino comparten directorio, asi que es defensivo.
      ok <- file.copy(tmp, ruta_validada, overwrite = TRUE)
      if (!ok) stop("escribir_atomico(): no se pudo renombrar ni copiar ", tmp)
    }
  })
}

# ---- Parseo de front matter (mecanismo unico, reutilizable) ------------------

#' Separa el front matter YAML-simple (bloque entre dos lineas '---' al inicio)
#' del cuerpo. Generico y sin dependencias: lo reutilizan 32 (ESTADO.md de los
#' hermanos) y 35 (cache/<slug>.md) en vez de duplicar el parseo (B.2).
#' @param L vector de lineas (p. ej. de readLines).
#' @return list(meta = lista nombrada clave->valor, cuerpo = vector de lineas).
parsear_front_matter <- function(L) {
  idx <- which(trimws(L) == "---")
  meta <- list(); cuerpo <- L
  if (length(idx) >= 2 && idx[1] == 1) {
    fm <- if (idx[2] > idx[1] + 1) L[(idx[1] + 1):(idx[2] - 1)] else character(0)
    cuerpo <- if (idx[2] < length(L)) L[(idx[2] + 1):length(L)] else character(0)
    for (ln in fm) {
      if (grepl(":", ln)) {
        k <- trimws(sub(":.*$", "", ln))
        v <- trimws(sub("^[^:]*:\\s*", "", ln))
        if (nzchar(k)) meta[[k]] <- v
      }
    }
  }
  list(meta = meta, cuerpo = cuerpo)
}

# ---- Hash de contenido -------------------------------------------------------

#' md5 del contenido de un archivo (sello de frescura del cache). Devuelve NA
#' si el archivo no existe.
#' @param ruta ruta a un archivo de texto.
hash_archivo <- function(ruta) {
  if (length(ruta) != 1 || is.na(ruta) || !file.exists(ruta)) return(NA_character_)
  unname(tools::md5sum(ruta))
}
