# ==============================================================================
# 31_descubrir_proyectos.R
# ------------------------------------------------------------------------------
# Proposito : Descubrir en tiempo de ejecucion el universo de proyectos hermanos
#             slep_* bajo RAIZ_PROYECTOS, clasificarlos (estructura canonica vs
#             no_canonica; categoria activo/auxiliar/baja), detectar altas y
#             bajas y sincronizar 20_insumos/registro_proyectos.csv SIN pisar lo
#             que el titular escribio a mano (secciones 6 y 7 del encargo).
# Insumos   : RAIZ_PROYECTOS y constantes (10_configuracion.R); el registro
#             previo si existe; reseñas de cada hermano (solo para sugerir
#             nombre_real). Lectura SOLO de documentacion (R2).
# Salidas   : data.frame df_proyectos en el entorno global; vectores
#             proyectos_nuevos / proyectos_baja; registro_proyectos.csv
#             actualizado (escritura confinada por escribir_seguro).
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

library(fs)
library(readr)  # E/S de CSV en UTF-8 robusto frente al locale (mac suele ser C).

# ---- Funciones ---------------------------------------------------------------

#' Localiza la reseña de portafolio de un proyecto (solo para sugerir
#' nombre_real). Busca resena_*.md exclusivamente dentro de 50_documentacion/
#' (R2: jamas fuera de la documentacion curada). Devuelve la ruta del candidato
#' de nombre mas corto (la reseña principal antes que anexos) o NA.
buscar_resena <- function(ruta_proyecto) {
  dir_doc <- file.path(ruta_proyecto, "50_documentacion")
  if (!dir.exists(dir_doc)) return(NA_character_)
  candidatos <- list.files(
    dir_doc, pattern = "(?i)^resena_.*\\.md$",
    recursive = TRUE, full.names = TRUE
  )
  if (length(candidatos) == 0) return(NA_character_)
  candidatos[order(nchar(basename(candidatos)))][1]
}

#' Extrae el primer titulo H1 (linea que empieza con "# ") de un .md, como
#' sugerencia de nombre_real. Devuelve NA si no hay reseña o no hay H1.
titulo_desde_resena <- function(ruta_resena) {
  if (is.na(ruta_resena) || !file.exists(ruta_resena)) return(NA_character_)
  lineas <- readLines(ruta_resena, warn = FALSE, encoding = "UTF-8")
  h1 <- lineas[grepl("^#\\s+", lineas)]
  if (length(h1) == 0) return(NA_character_)
  titulo <- sub("^#\\s+", "", h1[1])
  titulo <- trimws(titulo)
  if (nchar(titulo) == 0) NA_character_ else titulo
}

#' Lee el registro previo si existe; devuelve data.frame de columnas character
#' con el esquema canonico, o un data.frame vacio con ese esquema.
leer_registro_previo <- function(ruta) {
  cols <- c("slug", "nombre_real", "alias_corto", "categoria", "notas")
  vacio <- stats::setNames(
    data.frame(matrix("", nrow = 0, ncol = length(cols)), stringsAsFactors = FALSE),
    cols
  )
  if (!file.exists(ruta)) return(vacio)
  prev <- as.data.frame(
    readr::read_csv(ruta, col_types = readr::cols(.default = readr::col_character())),
    stringsAsFactors = FALSE
  )
  for (c in cols) if (is.null(prev[[c]])) prev[[c]] <- ""
  prev[, cols, drop = FALSE]
}

# ---- Flujo principal ---------------------------------------------------------

log_msg("Validando configuracion y universo de hermanos...", "31_descubrir")
validar_configuracion()

# Descubrimiento por patron (NUNCA lista hardcodeada; fuente unica en config).
slugs <- descubrir_hermanos()
log_msg(sprintf("Hermanos slep_* detectados: %d", length(slugs)), "31_descubrir")

df_proyectos <- data.frame(
  slug = slugs,
  ruta = file.path(RAIZ_PROYECTOS, slugs),
  stringsAsFactors = FALSE
)

# Estructura: canonica si existe 50_documentacion/ ; no_canonica en caso
# contrario (paquetes R, escaparate web). Es una categoria DISTINTA de
# "documentacion incompleta" (seccion 6).
df_proyectos$estructura <- ifelse(
  dir.exists(file.path(df_proyectos$ruta, "50_documentacion")),
  "canonica", "no_canonica"
)

# Categoria detectada: auxiliar para la semilla conocida; activo el resto.
df_proyectos$categoria_detectada <- ifelse(
  df_proyectos$slug %in% AUXILIARES_SEMILLA, "auxiliar", "activo"
)

# Sugerencia de nombre_real desde el titulo de la reseña (si existe).
df_proyectos$nombre_real_sugerido <- vapply(
  df_proyectos$ruta,
  function(r) {
    t <- titulo_desde_resena(buscar_resena(r))
    if (is.na(t)) "" else t
  },
  character(1)
)

# ---- Sincronizacion del registro (preserva campos manuales) ------------------

prev <- leer_registro_previo(RUTA_REGISTRO)

# Universo actual + bajas (slugs que estaban en el registro y desaparecieron).
slugs_previos <- prev$slug
proyectos_nuevos <- setdiff(df_proyectos$slug, slugs_previos)
proyectos_baja   <- setdiff(slugs_previos, df_proyectos$slug)

construir_fila <- function(slug) {
  fila_prev <- prev[prev$slug == slug, , drop = FALSE]
  tiene_prev <- nrow(fila_prev) == 1
  det <- df_proyectos[df_proyectos$slug == slug, , drop = FALSE]

  # nombre_real, alias_corto, notas: campos del titular -> jamas se pisan.
  nombre_real <- if (tiene_prev && nzchar(fila_prev$nombre_real)) {
    fila_prev$nombre_real
  } else {
    det$nombre_real_sugerido
  }
  alias_corto <- if (tiene_prev) fila_prev$alias_corto else ""
  notas       <- if (tiene_prev) fila_prev$notas else ""

  # categoria: la gestiona 31 (asi marca bajas). Respeta override manual a
  # "auxiliar"; el resto sigue la deteccion.
  categoria <- if (tiene_prev && identical(fila_prev$categoria, "auxiliar")) {
    "auxiliar"
  } else {
    det$categoria_detectada
  }

  data.frame(
    slug = slug, nombre_real = nombre_real, alias_corto = alias_corto,
    categoria = categoria, notas = notas, stringsAsFactors = FALSE
  )
}

filas_activas <- if (length(df_proyectos$slug)) {
  do.call(rbind, lapply(df_proyectos$slug, construir_fila))
} else {
  prev[0, ]
}

# Bajas: se conservan en el registro con categoria = "baja", preservando los
# campos del titular (memoria de que el proyecto existio).
filas_baja <- if (length(proyectos_baja)) {
  b <- prev[prev$slug %in% proyectos_baja, , drop = FALSE]
  b$categoria <- "baja"
  b
} else {
  prev[0, ]
}

registro <- rbind(filas_activas, filas_baja)
registro <- registro[order(registro$slug), , drop = FALSE]
rownames(registro) <- NULL

escribir_seguro(RUTA_REGISTRO, function(ruta) {
  readr::write_csv(registro, ruta)  # UTF-8 garantizado, sin escapes <U+XXXX>.
})

log_msg(sprintf("Registro sincronizado: %d filas (%d nuevos, %d bajas).",
                nrow(registro), length(proyectos_nuevos), length(proyectos_baja)),
        "31_descubrir")
if (length(proyectos_nuevos)) {
  log_msg(paste("Nuevos detectados:", paste(proyectos_nuevos, collapse = ", ")),
          "31_descubrir")
}
if (length(proyectos_baja)) {
  log_msg(paste("Dados de baja:", paste(proyectos_baja, collapse = ", ")),
          "31_descubrir", "WARN")
}

# Adjuntamos al df la categoria final (puede diferir de la detectada por
# override manual) para que la consuman las etapas siguientes.
df_proyectos <- merge(
  df_proyectos,
  registro[, c("slug", "categoria", "nombre_real")],
  by = "slug", all.x = TRUE, sort = TRUE
)
