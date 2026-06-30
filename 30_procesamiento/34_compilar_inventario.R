# ==============================================================================
# 34_compilar_inventario.R
# ------------------------------------------------------------------------------
# Proposito : Consolidar df_proyectos + lista_documentos + df_metadatos en el
#             inventario determinista de la cartera (inventario_cartera.json y
#             .parquet). Cero interpretacion: solo hechos verificables. Salida
#             byte-estable si los hermanos no cambian (criterio de aceptacion):
#             sin timestamps de corrida y rutas SANEADAS relativas a
#             RAIZ_PROYECTOS (R3: jamas /Users/<nombre>/ en una salida).
# Insumos   : df_proyectos (31), lista_documentos (32), df_metadatos (33).
# Salidas   : 40_salidas/inventario_cartera.json y .parquet (escritura atomica
#             confinada por escribir_seguro).
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

library(jsonlite)
library(arrow)

ESQUEMA_INVENTARIO <- "1"  # version del esquema del inventario.

# ---- Funciones ---------------------------------------------------------------

#' Saneamiento de rutas (R3): convierte una ruta absoluta de un hermano en una
#' ruta relativa a RAIZ_PROYECTOS. Devuelve NA si la entrada es NA.
relativizar <- function(p) {
  if (length(p) == 0 || is.na(p)) return(NA_character_)
  p <- normalizePath(p, winslash = "/", mustWork = FALSE)
  pref <- paste0(RAIZ_PROYECTOS, "/")
  if (startsWith(p, pref)) substring(p, nchar(pref) + 1L) else basename(p)
}

# ---- Flujo principal ---------------------------------------------------------

for (req in c("df_proyectos", "lista_documentos", "df_metadatos")) {
  if (!exists(req)) {
    stop(sprintf("34_compilar_inventario.R: falta %s. Ejecute via 00_run_all.R.", req))
  }
}

log_msg("Compilando inventario determinista de la cartera...", "34_compilar")

# Registro (para nombre_real, alias_corto, notas finales).
registro <- as.data.frame(
  readr::read_csv(RUTA_REGISTRO, col_types = readr::cols(.default = readr::col_character())),
  stringsAsFactors = FALSE
)

slugs <- sort(df_proyectos$slug)

# Tabla plana (una fila por proyecto) -> base de .parquet y de la lista JSON.
inv <- do.call(rbind, lapply(slugs, function(s) {
  d  <- lista_documentos[[s]]
  m  <- df_metadatos[df_metadatos$slug == s, , drop = FALSE]
  rg <- registro[registro$slug == s, , drop = FALSE]

  data.frame(
    slug             = s,
    nombre_real      = if (nrow(rg)) rg$nombre_real else "",
    alias_corto      = if (nrow(rg)) rg$alias_corto else "",
    categoria        = if (nrow(rg)) rg$categoria else d$categoria,
    notas            = if (nrow(rg)) rg$notas else "",
    estructura       = d$estructura,
    maneja_sensibles = d$maneja_sensibles,
    correlativo      = d$correlativo,
    total_sesiones   = d$total_sesiones,
    grafia_traspaso  = d$grafia_traspaso,
    colision         = d$colision,
    colision_detalle = d$colision_detalle,
    fecha_traspaso   = m$fecha_traspaso,
    fecha_escaner    = m$fecha_escaner,
    fecha_actividad  = m$fecha_actividad,
    fecha_commit     = m$fecha_commit,
    md5_traspaso     = m$md5_traspaso,
    md5_resena       = m$md5_resena,
    md5_backlog      = m$md5_backlog,
    doc_resena       = relativizar(d$ruta_resena),
    doc_traspaso     = relativizar(d$ruta_traspaso),
    doc_backlog      = relativizar(d$ruta_backlog),
    doc_escaner      = relativizar(d$ruta_escaner),
    doc_readme       = relativizar(d$ruta_readme),
    doc_claude       = relativizar(d$ruta_claude),
    doc_gobernanza   = relativizar(d$ruta_gobernanza),
    tiene_resena     = !is.na(d$ruta_resena),
    tiene_traspaso   = !is.na(d$ruta_traspaso),
    tiene_backlog    = !is.na(d$ruta_backlog),
    tiene_escaner    = !is.na(d$ruta_escaner),
    # Fase 2 PUSH: presencia de ESTADO.md y su tipo_pendiente (hechos de
    # contenido -> byte-estables; la decision PUSH/PULL por frescura NO se
    # persiste aqui, vive en el log de 32 y en panorama.md).
    estado_presente  = isTRUE(d$estado$presente),
    tipo_pendiente   = d$estado$tipo_pendiente,
    stringsAsFactors = FALSE
  )
}))
rownames(inv) <- NULL

# ---- Escritura .parquet (atomica, confinada) ---------------------------------

escribir_atomico(RUTA_INVENTARIO_PARQ, function(tmp) {
  arrow::write_parquet(arrow::as_arrow_table(inv), tmp)
})

# ---- Escritura .json (atomica, confinada, claves en orden fijo) --------------

# Construimos lista anidada en orden de campo estable para byte-estabilidad.
proyectos <- lapply(seq_len(nrow(inv)), function(i) {
  r <- inv[i, ]
  list(
    slug             = r$slug,
    nombre_real      = r$nombre_real,
    alias_corto      = r$alias_corto,
    categoria        = r$categoria,
    estructura       = r$estructura,
    maneja_sensibles = r$maneja_sensibles,
    traspaso = list(
      correlativo      = r$correlativo,
      total_sesiones   = r$total_sesiones,
      grafia           = r$grafia_traspaso,
      colision         = r$colision,
      colision_detalle = r$colision_detalle
    ),
    fechas = list(
      traspaso  = r$fecha_traspaso,
      escaner   = r$fecha_escaner,
      actividad = r$fecha_actividad,
      commit    = r$fecha_commit
    ),
    sellos = list(
      md5_traspaso = r$md5_traspaso,
      md5_resena   = r$md5_resena,
      md5_backlog  = r$md5_backlog
    ),
    documentos = list(
      resena     = r$doc_resena,
      traspaso   = r$doc_traspaso,
      backlog    = r$doc_backlog,
      escaner    = r$doc_escaner,
      readme     = r$doc_readme,
      claude     = r$doc_claude,
      gobernanza = r$doc_gobernanza
    ),
    cobertura = list(
      resena   = r$tiene_resena,
      traspaso = r$tiene_traspaso,
      backlog  = r$tiene_backlog,
      escaner  = r$tiene_escaner
    ),
    # Fase 2 PUSH: ficha destilada del hermano. tipo_pendiente (enum SETTINGS
    # §1.2.4) queda disponible y tipado aqui para la futura pieza C (agenda
    # priorizada); null si el hermano aun no tiene ESTADO.md.
    estado = list(
      presente       = r$estado_presente,
      tipo_pendiente = r$tipo_pendiente
    ),
    notas = r$notas
  )
})

inventario <- list(
  esquema     = ESQUEMA_INVENTARIO,
  n_proyectos = nrow(inv),
  proyectos   = proyectos
)

escribir_atomico(RUTA_INVENTARIO_JSON, function(tmp) {
  jsonlite::write_json(
    inventario, tmp,
    pretty = TRUE, auto_unbox = TRUE, null = "null", na = "null"
  )
})

log_msg(sprintf("Inventario compilado: %d proyectos -> inventario_cartera.json/.parquet",
                nrow(inv)), "34_compilar")

# Disponible para 35 (panorama) en la misma corrida.
inventario_cartera <- inv
