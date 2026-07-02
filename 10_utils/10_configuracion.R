# ==============================================================================
# 10_configuracion.R
# ------------------------------------------------------------------------------
# Proposito : Resolver rutas y constantes del orquestador. Ancla el repo con
#             rprojroot, resuelve RAIZ_PROYECTOS (universo de hermanos) de forma
#             portable (Mac/Windows) y valida precondiciones (POLITICA 4 y 8.2).
# Insumos   : variable de entorno opcional RAIZ_PROYECTOS.
# Salidas   : define en el entorno global RAIZ_ORQUESTADOR, RAIZ_PROYECTOS, las
#             rutas de insumos/salidas y las constantes de operacion.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# Nota      : Sin library(); solo paquete::funcion() (bootstrapping, POLITICA 1.4).
# ==============================================================================

# ---- Anclaje del repo del orquestador ----------------------------------------

# Criterios multiples para que resuelva igual desde RStudio, Rscript o source().
.criterios_raiz <- rprojroot::has_file("slep_estado_proyectos_monitoreo.Rproj") |
  rprojroot::is_rstudio_project |
  rprojroot::has_file(".here") |
  rprojroot::is_git_root

RAIZ_ORQUESTADOR <- rprojroot::find_root(.criterios_raiz)

# ---- Resolucion de la raiz del universo de hermanos --------------------------

# Estrategia portable, sin rutas absolutas en codigo:
# (1) si existe la variable de entorno RAIZ_PROYECTOS, se usa;
# (2) si no, cae a dirname(RAIZ_ORQUESTADOR) (tipicamente ~/Projects).
.env_raiz <- Sys.getenv("RAIZ_PROYECTOS", unset = NA)
RAIZ_PROYECTOS <- if (!is.na(.env_raiz) && nzchar(.env_raiz)) {
  normalizePath(.env_raiz, winslash = "/", mustWork = FALSE)
} else {
  normalizePath(dirname(RAIZ_ORQUESTADOR), winslash = "/", mustWork = FALSE)
}

# ---- Constantes de operacion -------------------------------------------------

# Slug del propio orquestador: se excluye SIEMPRE del universo (seccion 7).
SLUG_ORQUESTADOR <- "slep_estado_proyectos_monitoreo"

# Prefijo del universo de proyectos hermanos (descubrimiento por patron).
PREFIJO_UNIVERSO <- "slep_"

# Patrones de EXCLUSION del universo: entradas que matchean el prefijo pero no
# son proyectos (p. ej. respaldos bare de git slep_repo_backup_YYYYMMDD.git, o
# directorios de respaldo ad-hoc tipo slep_<slug>_BACKUP_PRE_FILTER_REPO creados
# antes de una purga de historial con git filter-repo/BFG). "_backup" se trata
# como marcador de infijo/sufijo (delimitado por "_" o fin de cadena), NO como
# sufijo literal estricto, porque el caso real observado es
# "_BACKUP_PRE_FILTER_REPO" (con texto despues). Es un filtro por patron, no
# una lista hardcodeada de proyectos.
PATRON_EXCLUIR_UNIVERSO <- "(?i)\\.git$|_backup(_|$)"

# Auxiliares conocidos (no son pipelines analiticos; seccion 7). El registro
# curado a mano puede ampliar esta clasificacion; aqui va la semilla.
AUXILIARES_SEMILLA <- c("slep_monitoreo", "slep_resena_proyectos")

# Umbral de frescura: traspaso mas viejo que esto = alerta de obsolescencia
# (seccion 9). No es error, es senal en el panorama.
DIAS_OBSOLETO <- 21L

# Margen de tolerancia para la regla de desincronizacion de ESTADO.md (Fase 2,
# paso 32, resolver_estado()). Cubre el patron de "falso-desync" cuando un
# traspaso se guarda pasada la medianoche de su fecha de cierre declarada:
# ultima_actividad queda 1 dia detras del mtime real sin ser un desync de
# contenido. Acota exactamente ese patron (no mas): un ESTADO.md solo se
# considera desincronizado si ultima_actividad esta a MAS de este margen del
# mtime del traspaso. P-DESYNC-MARGEN (traspaso v05, seccion 11).
MARGEN_DESYNC_DIAS <- 1L

# Lectura de metadatos git del hermano (fecha del ultimo commit). Apagado por
# defecto para no invocar git en 16+ repos en cada arranque de jornada
# (seccion 8). Solo lectura de metadatos; nunca operaciones que escriban.
LEER_GIT <- FALSE

# Zona horaria local de la maquina, capturada AL BOOTSTRAP (antes de que cualquier
# library de los pasos corrompa el cache de tz de R bajo locale C). Se pasa
# explicita a format() al fechar mtimes (paso 32, desync de ESTADO.md): sin esto,
# format(POSIXct) puede caer a UTC y correr la fecha +1 dia para archivos
# guardados de noche. Fallback a "" (tz local del sistema) si no se resuelve.
TZ_ORQUESTADOR <- tryCatch({
  z <- Sys.timezone()
  if (is.na(z) || !nzchar(z)) "" else z
}, error = function(e) "")

# ---- Rutas del orquestador (todas bajo RAIZ_ORQUESTADOR) ----------------------

RUTA_INSUMOS    <- file.path(RAIZ_ORQUESTADOR, "20_insumos")
RUTA_REGISTRO   <- file.path(RUTA_INSUMOS, "registro_proyectos.csv")

RUTA_SALIDAS         <- file.path(RAIZ_ORQUESTADOR, "40_salidas")
RUTA_CACHE           <- file.path(RUTA_SALIDAS, "cache")
RUTA_INVENTARIO_JSON <- file.path(RUTA_SALIDAS, "inventario_cartera.json")
RUTA_INVENTARIO_PARQ <- file.path(RUTA_SALIDAS, "inventario_cartera.parquet")
RUTA_PANORAMA        <- file.path(RUTA_SALIDAS, "panorama.md")

RUTA_DOC_ACTIVA <- file.path(RAIZ_ORQUESTADOR, "50_documentacion", "activa")

# ---- Descubrimiento del universo (fuente unica para 31 y la validacion) ------

#' Descubre por patron los proyectos hermanos slep_* bajo RAIZ_PROYECTOS,
#' excluyendo el propio orquestador y las entradas que matchean
#' PATRON_EXCLUIR_UNIVERSO (respaldos .git). Devuelve los slugs ordenados.
descubrir_hermanos <- function() {
  candidatos <- list.dirs(RAIZ_PROYECTOS, full.names = FALSE, recursive = FALSE)
  hermanos <- candidatos[
    startsWith(candidatos, PREFIJO_UNIVERSO) &
      candidatos != SLUG_ORQUESTADOR &
      !grepl(PATRON_EXCLUIR_UNIVERSO, candidatos)
  ]
  sort(hermanos)
}

# ---- Validacion de precondiciones (falla temprano, POLITICA 4) ---------------

#' Valida que RAIZ_PROYECTOS contenga al menos dos hermanos slep_* ajenos al
#' orquestador. El fallback dirname() falla en silencio si el repo no esta
#' exactamente en ~/Projects/ o esta anidado; este stop() lo convierte en error
#' claro y accionable.
validar_configuracion <- function() {
  if (!dir.exists(RAIZ_PROYECTOS)) {
    stop(sprintf(
      "RAIZ_PROYECTOS no existe: %s\nDefina la variable de entorno RAIZ_PROYECTOS apuntando a la carpeta que contiene los proyectos slep_*.",
      RAIZ_PROYECTOS
    ))
  }
  hermanos <- descubrir_hermanos()
  if (length(hermanos) < 2) {
    stop(sprintf(
      paste0(
        "RAIZ_PROYECTOS resolvio a '%s' pero alli no hay >= 2 proyectos hermanos slep_*.\n",
        "Probable causa: el orquestador no esta en ~/Projects/ o esta anidado, y el fallback dirname() apunto mal.\n",
        "Solucion: defina la variable de entorno RAIZ_PROYECTOS con la ruta correcta."
      ),
      RAIZ_PROYECTOS
    ))
  }
  invisible(hermanos)
}
