# ==============================================================================
# 32_localizar_documentos.R
# ------------------------------------------------------------------------------
# Proposito : Resolver POR PATRON (nunca por nombre fijo) la ubicacion de la
#             documentacion curada de cada hermano: reseña, ULTIMO traspaso
#             (con dedup por correlativo entero), backlog, escaner, README,
#             CLAUDE y gobernanza. Solo lee documentacion (R2); excluye volcados
#             crudos y jamas toca datos ni OneDrive (seccion 6 del encargo).
# Insumos   : df_proyectos (de 31).
# Salidas   : lista_documentos (lista nombrada por slug) en el entorno global.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

# ---- Constantes de patron (numeros/cadenas magicas como constantes, C.10) -----

# Grafias coexistentes del traspaso vigente (seccion 6 del encargo):
#   traspaso_cierre_vNN.md | traspaso-cierre-vNN.md | CONTEXTO_VNN.md
PATRON_TRASPASO <- "(?i)^(traspaso[_-]cierre[_-]v\\d+|contexto_v\\d+)\\.md$"
# Correlativo entero embebido en el nombre (tolera ceros a la izquierda).
PATRON_CORRELATIVO <- "(?i)v0*(\\d+)"
# Reseña de portafolio.
PATRON_RESENA <- "(?i)^resena_.*\\.md$"
# Backlog acumulativo.
PATRON_BACKLOG <- "(?i)^backlog_.*\\.md$"
# Volcados crudos: EXCLUIDOS de lectura por R2 (dumps sin sanear).
PATRON_VOLCADO <- "(?i)volcado"
# ESTADO.md (Fase 2 PUSH): ficha destilada del hermano, ruta canonica fija.
SUBRUTA_ESTADO <- file.path("50_documentacion", "activa", "ESTADO.md")

# ---- Funciones de localizacion -----------------------------------------------

#' Lista archivos .md dentro de 50_documentacion/ que matcheen un patron, ya
#' filtrando volcados crudos (R2). Devuelve rutas absolutas.
listar_docs <- function(ruta_proyecto, patron) {
  dir_doc <- file.path(ruta_proyecto, "50_documentacion")
  if (!dir.exists(dir_doc)) return(character(0))
  hits <- list.files(dir_doc, pattern = patron, recursive = TRUE, full.names = TRUE)
  hits[!grepl(PATRON_VOLCADO, basename(hits))]
}

#' Clasifica la grafia de un archivo de traspaso por su nombre.
grafia_traspaso <- function(nombre) {
  n <- tolower(nombre)
  if (grepl("^traspaso_cierre_", n)) "traspaso_cierre"
  else if (grepl("^traspaso-cierre-", n)) "traspaso-cierre"
  else if (grepl("^contexto_v", n)) "contexto"
  else "otra"
}

#' Resuelve el traspaso vigente y el total de sesiones a partir de las grafias
#' coexistentes. Dedup POR ENTERO (no por archivo): el total de sesiones es la
#' cantidad de correlativos enteros distintos. El vigente es el maximo entero;
#' ante empate de grafias en ese maximo, prefiere traspaso_cierre_ y reporta la
#' colision (seccion 6 del encargo).
resolver_traspaso <- function(ruta_proyecto) {
  vacio <- list(ruta = NA_character_, correlativo = NA_integer_,
                total_sesiones = 0L, grafia = NA_character_,
                colision = FALSE, colision_detalle = NA_character_)
  cand <- listar_docs(ruta_proyecto, PATRON_TRASPASO)
  if (length(cand) == 0) return(vacio)

  nombres <- basename(cand)
  m <- regmatches(nombres, regexpr(PATRON_CORRELATIVO, nombres, perl = TRUE))
  enteros <- as.integer(sub(PATRON_CORRELATIVO, "\\1", m, perl = TRUE))
  ok <- !is.na(enteros)
  cand <- cand[ok]; nombres <- nombres[ok]; enteros <- enteros[ok]
  if (length(cand) == 0) return(vacio)

  total_sesiones <- length(unique(enteros))
  maxn <- max(enteros)
  idx_max <- which(enteros == maxn)
  grafias <- vapply(nombres[idx_max], grafia_traspaso, character(1))

  # Desempate: prioridad traspaso_cierre > traspaso-cierre > contexto > otra.
  prioridad <- c(traspaso_cierre = 1, `traspaso-cierre` = 2, contexto = 3, otra = 4)
  orden <- order(prioridad[grafias])
  elegido <- idx_max[orden[1]]

  colision <- length(unique(grafias)) > 1
  detalle <- if (colision) {
    sprintf("v%02d con grafias: %s (se prefiere %s)",
            maxn, paste(sort(unique(grafias)), collapse = ", "),
            grafia_traspaso(nombres[elegido]))
  } else NA_character_

  list(
    ruta = cand[elegido],
    correlativo = maxn,
    total_sesiones = total_sesiones,
    grafia = grafia_traspaso(nombres[elegido]),
    colision = colision,
    colision_detalle = detalle
  )
}

#' Elige el backlog acumulativo preferido: descarta volcados (ya filtrados),
#' prefiere consolidado/acumulativo sobre anexos (seccion 6).
resolver_backlog <- function(ruta_proyecto) {
  cand <- listar_docs(ruta_proyecto, PATRON_BACKLOG)
  if (length(cand) == 0) return(NA_character_)
  nb <- tolower(basename(cand))
  score <- rep(0L, length(cand))
  score <- score + ifelse(grepl("anexo", nb), 100L, 0L)            # peor
  score <- score - ifelse(grepl("consolidad|acumulativ|acumulad", nb), 10L, 0L)
  score <- score - ifelse(grepl("historic", nb), 5L, 0L)
  orden <- order(score, nchar(nb))
  cand[orden[1]]
}

#' Localiza un archivo unico por nombre exacto dentro de 50_documentacion/.
buscar_unico <- function(ruta_proyecto, nombre, subruta = NULL) {
  base <- file.path(ruta_proyecto, "50_documentacion")
  if (!is.null(subruta)) base <- file.path(base, subruta)
  ruta <- file.path(base, nombre)
  if (file.exists(ruta)) ruta else NA_character_
}

#' Localiza un archivo en la raiz del repo del hermano (README, CLAUDE).
buscar_raiz <- function(ruta_proyecto, nombre) {
  ruta <- file.path(ruta_proyecto, nombre)
  if (file.exists(ruta)) ruta else NA_character_
}

#' Detecta si el hermano maneja datos sensibles: presencia de gobernanza_datos.md
#' (seccion 6). Busca en 50_documentacion/ recursivo.
resolver_gobernanza <- function(ruta_proyecto) {
  hits <- listar_docs(ruta_proyecto, "(?i)^gobernanza_datos\\.md$")
  if (length(hits) == 0) NA_character_ else hits[order(nchar(hits))][1]
}

#' Texto de una seccion markdown "## <titulo>" (hasta el siguiente "## "); ""
#' si no esta. Colapsa a una linea (para campos cortos como "Proximo paso").
seccion_md <- function(cuerpo_lineas, titulo) {
  ini <- which(grepl(sprintf("^##\\s+%s\\s*$", titulo), cuerpo_lineas))
  if (length(ini) == 0) return("")
  resto <- cuerpo_lineas[(ini[1] + 1L):length(cuerpo_lineas)]
  sig <- which(grepl("^##\\s+", resto))
  sec <- if (length(sig) > 0) resto[seq_len(sig[1] - 1L)] else resto
  trimws(paste(sec[nzchar(trimws(sec))], collapse = " "))
}

#' Resuelve el ESTADO.md (Fase 2 PUSH) de un hermano y decide la fuente de
#' lectura del estado en esta corrida: PUSH (leer ESTADO.md directo) vs PULL
#' (recomputar desde traspaso/backlog, comportamiento Fase 1).
#'
#' Regla de desincronizacion (encargo Fase 2): si `ultima_actividad` del ESTADO
#' es ANTERIOR (por fecha) al mtime del traspaso vigente, el ESTADO se considera
#' stale -> se trata como si no existiera (PULL). Tambien cae a PULL si falta
#' ESTADO.md o su `ultima_actividad` es ilegible. La comparacion es por FECHA
#' (mismo dia = sincronizado); el mtime se lee en runtime y NO se persiste.
resolver_estado <- function(ruta_proyecto, ruta_traspaso) {
  ruta <- file.path(ruta_proyecto, SUBRUTA_ESTADO)
  vacio <- list(presente = FALSE, sincronizado = FALSE, fuente = "PULL",
                ruta = NA_character_, meta = list(), cuerpo = "",
                proximo = NA_character_, tipo_pendiente = NA_character_,
                motivo = "sin ESTADO.md")
  if (!file.exists(ruta)) return(vacio)

  L  <- readLines(ruta, warn = FALSE, encoding = "UTF-8")
  fm <- parsear_front_matter(L)
  meta <- fm$meta
  ua_raw <- if (is.null(meta$ultima_actividad)) NA_character_ else meta$ultima_actividad
  ua <- suppressWarnings(as.Date(ua_raw))
  # Fecha de calendario LOCAL del mtime, con la tz capturada al bootstrap
  # (TZ_ORQUESTADOR). Explicita para no depender del cache de tz de R, que bajo
  # locale C puede caer a UTC y correr la fecha +1 dia (archivos de noche).
  tz_loc <- if (exists("TZ_ORQUESTADOR")) TZ_ORQUESTADOR else ""
  mt <- if (!is.na(ruta_traspaso) && file.exists(ruta_traspaso))
          as.Date(format(file.mtime(ruta_traspaso), "%Y-%m-%d", tz = tz_loc)) else NA

  sincronizado <- TRUE; motivo <- "sincronizado"
  if (is.na(ua)) {
    sincronizado <- FALSE; motivo <- "ultima_actividad ausente o ilegible"
  } else if (!is.na(mt) && ua < mt) {
    sincronizado <- FALSE
    motivo <- sprintf("desync: ultima_actividad %s < mtime traspaso %s", ua, mt)
  }
  tp <- if (is.null(meta$tipo_pendiente) || !nzchar(meta$tipo_pendiente))
           NA_character_ else meta$tipo_pendiente
  prox <- seccion_md(fm$cuerpo, "Proximo paso")

  list(
    presente       = TRUE,
    sincronizado   = sincronizado,
    fuente         = if (sincronizado) "PUSH" else "PULL",
    ruta           = ruta,
    meta           = meta,
    cuerpo         = trimws(paste(fm$cuerpo, collapse = "\n")),
    proximo        = if (nzchar(prox)) prox else NA_character_,
    tipo_pendiente = tp,          # hecho de contenido (presente); 34 lo persiste
    motivo         = motivo
  )
}

# ---- Flujo principal ---------------------------------------------------------

if (!exists("df_proyectos")) {
  stop("32_localizar_documentos.R: falta df_proyectos. Ejecute via 00_run_all.R.")
}

log_msg("Localizando documentacion curada por patron...", "32_localizar")

lista_documentos <- stats::setNames(
  lapply(seq_len(nrow(df_proyectos)), function(i) {
    slug <- df_proyectos$slug[i]
    ruta <- df_proyectos$ruta[i]
    estructura <- df_proyectos$estructura[i]

    tr <- resolver_traspaso(ruta)

    list(
      slug             = slug,
      ruta_proyecto    = ruta,
      estructura       = estructura,
      categoria        = df_proyectos$categoria[i],
      ruta_resena      = { r <- buscar_resena(ruta); if (is.na(r)) NA_character_ else r },
      ruta_traspaso    = tr$ruta,
      correlativo      = tr$correlativo,
      total_sesiones   = tr$total_sesiones,
      grafia_traspaso  = tr$grafia,
      colision         = tr$colision,
      colision_detalle = tr$colision_detalle,
      ruta_backlog     = resolver_backlog(ruta),
      ruta_escaner     = buscar_unico(ruta, "estructura_actual.md", "estructura"),
      ruta_readme      = buscar_raiz(ruta, "README.md"),
      ruta_claude      = buscar_raiz(ruta, "CLAUDE.md"),
      ruta_gobernanza  = resolver_gobernanza(ruta),
      maneja_sensibles = !is.na(resolver_gobernanza(ruta)),
      estado           = resolver_estado(ruta, tr$ruta)   # Fase 2 PUSH (decide PUSH/PULL)
    )
  }),
  df_proyectos$slug
)

n_colisiones <- sum(vapply(lista_documentos, function(x) isTRUE(x$colision), logical(1)))
log_msg(sprintf("Documentacion localizada para %d proyectos (%d colisiones de grafia en traspaso).",
                length(lista_documentos), n_colisiones), "32_localizar")

# Auditoria de fuente de estado por proyecto (Fase 2 PUSH vs Fase 1 PULL).
n_push <- 0L; n_pull <- 0L
for (s in names(lista_documentos)) {
  e <- lista_documentos[[s]]$estado
  if (identical(e$fuente, "PUSH")) {
    n_push <- n_push + 1L
    log_msg(sprintf("estado[%s] = PUSH (ESTADO.md sincronizado).", s), "32_localizar")
  } else {
    n_pull <- n_pull + 1L
    log_msg(sprintf("estado[%s] = PULL (%s).", s, e$motivo), "32_localizar")
  }
}
log_msg(sprintf("Fuente de estado: %d PUSH, %d PULL.", n_push, n_pull), "32_localizar")
