# ==============================================================================
# tests/test_atalaya.R
# ------------------------------------------------------------------------------
# Proposito : Pruebas del pipeline de Atalaya sobre la cartera demo:
#             (1) ningun dato declarado sin fuente; (2) cada caso demo produce
#             la senal que ejemplifica; (3) TODO, BACKLOG e historial no se
#             mezclan; (4) el HTML generado no contiene referencias de red.
# Uso       : Rscript tests/test_atalaya.R
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-10-02
# ==============================================================================

source(here::here("10_utils", "10_locale.R"))
asegurar_locale_utf8("test_atalaya")
source(here::here("30_procesamiento", "37_atalaya_extraer.R"), encoding = "UTF-8")
source(here::here("30_procesamiento", "38_atalaya_derivar.R"), encoding = "UTF-8")

fallas <- 0L
afirmar <- function(cond, msg) {
  if (isTRUE(cond)) cat("  ok   ", msg, "\n") else { cat("  FALLA", msg, "\n"); fallas <<- fallas + 1L }
}

ds <- construir_dataset(here::here("tests", "fixtures", "cartera_demo"), fecha_ref = as.Date("2026-10-02"))
P <- stats::setNames(ds$proyectos, vapply(ds$proyectos, `[[`, "", "id"))
senales <- function(id) vapply(P[[id]]$senales, `[[`, "", "id")

cat("Procedencia\n")
campos <- c("nombre", "descripcion", "categoria", "prioridad", "pulso", "fase", "ultima_actividad", "resumen", "proximo_paso")
sin_fuente <- unlist(lapply(P, function(p) {
  campos[vapply(campos, function(k) identical(p[[k]]$origen, "declarado") && is.null(p[[k]]$fuente), logical(1))]
}))
afirmar(length(sin_fuente) == 0, "ningún campo declarado carece de fuente")
afirmar(all(vapply(P, function(p) p$avance$tipo != "declarado" || !is.null(p$avance$fuente), logical(1))),
        "todo avance declarado tiene fuente")
afirmar(is.null(P[["proto-x"]]$pulso$valor) && P[["proto-x"]]$avance$tipo == "ninguno",
        "proto-x: sin documentación no se inventa estado ni avance")

cat("Senales por caso demo\n")
afirmar("bloqueos" %in% senales("faro-api"), "faro-api: bloqueos declarados")
afirmar("abandono" %in% senales("mareas"), "mareas: posible abandono")
afirmar("pausa_prolongada" %in% senales("cosecha") && !("abandono" %in% senales("cosecha")), "cosecha: pausa prolongada, no abandono")
afirmar(all(c("backlog_grande", "backlog_sin_prioridad") %in% senales("catalogo")), "catalogo: backlog extenso sin priorizar")
afirmar("hito_vencido" %in% senales("bitacora"), "bitacora: hito vencido")
afirmar("contradiccion_fase" %in% senales("relevo"), "relevo: README contradice ESTADO")
afirmar(!("contradiccion_fase" %in% senales("lumen")), "lumen: 'terminado... en producción' no es contradicción")
afirmar(length(senales("pulso-cli")) == 0, "pulso-cli: proyecto sano sin señales")

cat("Horizontes\n")
hz <- function(id, h) sum(vapply(P[[id]]$items, function(i) i$horizonte == h, logical(1)))
afirmar(hz("bitacora", "inmediato") == 8 && hz("bitacora", "futuro") == 15, "bitacora: 8 ítems inmediatos y 15 de backlog")
afirmar(hz("lumen", "inmediato") + hz("lumen", "futuro") == 0, "lumen: el CHANGELOG no se cuenta como trabajo pendiente")
afirmar(P[["vitrina"]]$pulso$valor == "activo" && P[["vitrina"]]$avance$valor == 0.8, "vitrina: STATUS.md en inglés se interpreta")
afirmar(P[["pulso-cli"]]$metricas$futuro_prioridad$alta == 2, "pulso-cli: prioridades leídas desde tabla")

cat("HTML autocontenido\n")
html_ruta <- here::here("40_salidas", "atalaya_preview.html")
if (file.exists(html_ruta)) {
  html <- paste(readLines(html_ruta, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  afirmar(!grepl("https?://|jsdelivr|unpkg|googleapis|gstatic|cdnjs", html, perl = TRUE), "sin URLs externas ni CDN")
  afirmar(grepl("default-src 'none'", html, fixed = TRUE), "CSP bloquea toda conexión de red")
  afirmar(grepl("data:font/woff2;base64", html, fixed = TRUE), "fuentes embebidas")
} else {
  afirmar(FALSE, "existe 40_salidas/atalaya_preview.html (correr 39 primero)")
}

cat(sprintf("\n%d falla(s)\n", fallas))
if (fallas > 0) quit(status = 1)
