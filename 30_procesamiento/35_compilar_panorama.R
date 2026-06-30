# ==============================================================================
# 35_compilar_panorama.R
# ------------------------------------------------------------------------------
# Proposito : Ensamblar panorama.md de forma DETERMINISTA a partir del inventario
#             (hechos) y de los cache/<slug>.md (prosa de sintesis que redacta el
#             AGENTE, seccion 9). El codigo arma la tabla L1, concatena las
#             fichas L2 desde el cache y calcula alertas de frescura; la prosa no
#             la genera este script. Si un cache falta o su sello no coincide con
#             el md5 del traspaso vigente, lo marca como pendiente de sintesis
#             (asi run_all produce panorama.md aun en frio, sin intervencion).
# Insumos   : inventario_cartera (de 34); cache/<slug>.md; proyectos_nuevos /
#             proyectos_baja (de 31); constantes (10_configuracion.R).
# Salidas   : 40_salidas/panorama.md (escritura confinada por escribir_seguro).
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

# ---- Funciones ---------------------------------------------------------------

#' Lee un cache/<slug>.md y separa front matter (sello + sintesis) del cuerpo
#' (ficha L2 en prosa). Devuelve NULL si no existe.
leer_cache <- function(slug) {
  ruta <- file.path(RUTA_CACHE, paste0(slug, ".md"))
  if (!file.exists(ruta)) return(NULL)
  L <- readLines(ruta, warn = FALSE, encoding = "UTF-8")
  fm <- parsear_front_matter(L)   # mecanismo unico (10_utils.R)
  list(meta = fm$meta, cuerpo = trimws(paste(fm$cuerpo, collapse = "\n")))
}

#' "hace N dias" a partir de una fecha YYYY-MM-DD; "" si NA.
hace_dias <- function(fecha) {
  if (is.na(fecha) || !nzchar(fecha)) return(NA_integer_)
  as.integer(Sys.Date() - as.Date(fecha))
}

#' Estado de la sintesis del cache frente al inventario (frescura, seccion 9).
estado_sintesis <- function(cache, md5_traspaso) {
  if (is.null(cache)) return("ausente")
  sello <- cache$meta$sello_hash
  if (is.null(sello) || is.na(md5_traspaso)) return("vigente")
  if (identical(sello, md5_traspaso)) "vigente" else "desactualizada"
}

#' Nombre a mostrar: nombre_real si existe, si no el slug.
nombre_mostrar <- function(nombre_real, slug) {
  if (!is.na(nombre_real) && nzchar(nombre_real)) nombre_real else slug
}

# ---- Flujo principal ---------------------------------------------------------

if (!exists("inventario_cartera")) {
  stop("35_compilar_panorama.R: falta inventario_cartera. Ejecute via 00_run_all.R.")
}
if (!exists("proyectos_nuevos")) proyectos_nuevos <- character(0)
if (!exists("proyectos_baja"))   proyectos_baja   <- character(0)

log_msg("Ensamblando panorama.md (tabla L1 + fichas L2 desde cache)...", "35_panorama")

inv <- inventario_cartera
inv <- inv[order(inv$slug), , drop = FALSE]

activos    <- inv[inv$categoria == "activo", , drop = FALSE]
auxiliares <- inv[inv$categoria == "auxiliar", , drop = FALSE]

# Caches (Fase 1 PULL) y estado destilado (Fase 2 PUSH) por proyecto activo.
caches <- lapply(activos$slug, leer_cache)
names(caches) <- activos$slug

# Decision de fuente por proyecto: PUSH si el hermano tiene ESTADO.md
# sincronizado (resuelto en 32, lista_documentos[[slug]]$estado); si no, PULL
# (comportamiento Fase 1: sintesis recomputada desde cache/traspaso).
tiene_ld  <- exists("lista_documentos")
estado_de <- function(slug) if (tiene_ld) lista_documentos[[slug]]$estado else NULL
usa_push  <- vapply(activos$slug, function(s) {
  e <- estado_de(s); isTRUE(e$presente) && isTRUE(e$sincronizado)
}, logical(1))
activos$fuente <- ifelse(usa_push, "PUSH", "PULL")

# Cuerpo de la ficha L2: ESTADO.md (PUSH) o cache (PULL).
cuerpos <- lapply(seq_len(nrow(activos)), function(i) {
  if (usa_push[i]) estado_de(activos$slug[i])$cuerpo else caches[[i]]$cuerpo
})

activos$dias     <- vapply(activos$fecha_actividad, hace_dias, integer(1))
activos$obsoleto <- !is.na(activos$dias) & activos$dias > DIAS_OBSOLETO
# Frescura de la sintesis: PUSH es vigente por definicion (paso el chequeo de
# desync en 32); PULL conserva el sello md5 del cache frente al traspaso.
activos$sintesis <- vapply(seq_len(nrow(activos)), function(i) {
  if (usa_push[i]) "vigente" else estado_sintesis(caches[[i]], activos$md5_traspaso[i])
}, character(1))
activos$semaforo <- vapply(seq_len(nrow(activos)), function(i) {
  m <- if (usa_push[i]) estado_de(activos$slug[i])$meta$semaforo else caches[[i]]$meta$semaforo
  if (is.null(m) || !nzchar(m)) "(pendiente)" else m
}, character(1))
activos$proximo <- vapply(seq_len(nrow(activos)), function(i) {
  m <- if (usa_push[i]) estado_de(activos$slug[i])$proximo else caches[[i]]$meta$proximo_paso
  if (is.null(m) || is.na(m) || !nzchar(m)) "(pendiente de sintesis)" else m
}, character(1))

# ---- Alertas -----------------------------------------------------------------

bloqueados <- activos$slug[tolower(activos$semaforo) == "bloqueado"]
obsoletos  <- activos$slug[activos$obsoleto]
sin_sint   <- activos$slug[activos$sintesis != "vigente"]
no_canonicos <- inv$slug[inv$estructura == "no_canonica"]

# Documentacion incompleta: por proyecto activo, que documento curado falta
# (resena / traspaso / backlog). Se anota el hueco especifico para no leerlo
# como "proyecto roto": la falta de backlog separado es comun y legitima en
# proyectos nuevos (correlativo bajo) que aun no consolidan uno.
faltantes <- vapply(seq_len(nrow(activos)), function(i) {
  m <- c(
    if (!activos$tiene_resena[i])   "resena"   else NULL,
    if (!activos$tiene_traspaso[i]) "traspaso" else NULL,
    if (!activos$tiene_backlog[i])  "backlog"  else NULL
  )
  paste(m, collapse = ", ")
}, character(1))
incompletos_idx <- which(nzchar(faltantes))

# ---- Construccion del markdown -----------------------------------------------

fmt_fecha_rel <- function(fecha, dias) {
  if (is.na(fecha) || !nzchar(fecha)) return("sin actividad registrada")
  if (is.na(dias)) return(fecha)
  sprintf("%s (hace %d dias)", fecha, dias)
}

L <- c()
ap <- function(...) L <<- c(L, ...)

ap("# Panorama de la cartera - Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos",
   "",
   sprintf("> Generado: %s · Proyectos activos: %d · Auxiliares: %d",
           format(Sys.Date(), "%Y-%m-%d"), nrow(activos), nrow(auxiliares)),
   "")

# Alertas
ap("## Alertas", "")
alerta_linea <- function(etiqueta, slugs) {
  if (length(slugs) == 0) sprintf("- **%s:** ninguno.", etiqueta)
  else sprintf("- **%s:** %s.", etiqueta, paste(slugs, collapse = ", "))
}
ap(alerta_linea("Bloqueados", bloqueados))
ap(alerta_linea("Nuevos detectados", proyectos_nuevos))
ap(alerta_linea("Dados de baja", proyectos_baja))
ap(alerta_linea(sprintf("Documentacion obsoleta (>%d dias)", DIAS_OBSOLETO), obsoletos))
ap(alerta_linea("Pendientes de sintesis", sin_sint))
ap("")

# Tabla L1
ap("## L1 - Tabla semaforo", "",
   "| Codigo | Nombre | Semaforo | Ultima actividad | Proximo paso |",
   "|---|---|---|---|---|")
for (i in seq_len(nrow(activos))) {
  ap(sprintf("| %s | %s | %s | %s | %s |",
             activos$slug[i],
             nombre_mostrar(activos$nombre_real[i], activos$slug[i]),
             activos$semaforo[i],
             fmt_fecha_rel(activos$fecha_actividad[i], activos$dias[i]),
             activos$proximo[i]))
}
ap("")

# Fichas L2
ap("## L2 - Fichas ejecutivas por proyecto activo", "")
for (i in seq_len(nrow(activos))) {
  s <- activos$slug[i]
  ap(sprintf("### %s - %s _(fuente: %s)_", s, nombre_mostrar(activos$nombre_real[i], s),
             activos$fuente[i]))
  cuerpo <- cuerpos[[i]]
  if (is.null(cuerpo) || !nzchar(cuerpo)) {
    ap(sprintf("_Ficha pendiente de sintesis (%s sin ESTADO.md sincronizado ni cache vigente)._", s))
  } else {
    ap(cuerpo)
  }
  ap("")
}

# Anexos
ap("## Anexos", "")
ap("### Proyectos auxiliares")
if (nrow(auxiliares) == 0) ap("- ninguno.") else
  for (i in seq_len(nrow(auxiliares)))
    ap(sprintf("- **%s** - %s.", auxiliares$slug[i],
               nombre_mostrar(auxiliares$nombre_real[i], auxiliares$slug[i])))
ap("")
ap("### Proyectos nuevos detectados")
ap(if (length(proyectos_nuevos) == 0) "- ninguno." else
   paste0("- ", proyectos_nuevos, collapse = "\n"))
ap("")
ap("### Proyectos dados de baja")
ap(if (length(proyectos_baja) == 0) "- ninguno." else
   paste0("- ", proyectos_baja, collapse = "\n"))
ap("")
ap("### Estructura no canonica (paquete / escaparate; no es documentacion incompleta)")
ap(if (length(no_canonicos) == 0) "- ninguno." else
   paste0("- ", no_canonicos, collapse = "\n"))
ap("")
ap("### Documentacion incompleta (falta reseña, traspaso o backlog)")
if (length(incompletos_idx) == 0) {
  ap("- ninguno.")
} else {
  for (i in incompletos_idx) ap(sprintf("- %s (sin %s)", activos$slug[i], faltantes[i]))
}
ap("")

escribir_seguro(RUTA_PANORAMA, function(ruta) {
  writeLines(L, ruta, useBytes = TRUE)
})

log_msg(sprintf("panorama.md ensamblado: %d activos, %d pendientes de sintesis. Fuente: %d PUSH, %d PULL.",
                nrow(activos), length(sin_sint),
                sum(activos$fuente == "PUSH"), sum(activos$fuente == "PULL")), "35_panorama")
