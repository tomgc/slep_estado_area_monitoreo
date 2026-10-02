# ==============================================================================
# 39_atalaya_generar.R
# ------------------------------------------------------------------------------
# Proposito : Genera atalaya_preview.html: un unico HTML autocontenido (CSS, JS,
#             fuentes, iconos y dataset embebidos) que se abre con doble clic,
#             sin servidor, sin Internet, sin R ni Node una vez generado.
#             Flujo: Markdown -> 37 (extraer) -> 38 (derivar) -> dataset JSON
#             -> plantilla -> HTML. Al final verifica que el HTML no contenga
#             ninguna referencia de red y aborta si la encuentra.
# Insumos   : tests/fixtures/cartera_demo/<proyecto>/*.md (cartera demo)
#             30_procesamiento/plantillas/atalaya/plantilla.html
#             30_procesamiento/plantillas/atalaya/fuentes/*.woff2 (OFL)
#             30_procesamiento/plantillas/atalaya/iconos/*.svg (Lucide, ISC)
# Salidas   : 40_salidas/atalaya_preview.html
#             40_salidas/atalaya_preview_datos.json (mismo dataset, legible)
# Uso       : Rscript 30_procesamiento/39_atalaya_generar.R
#             (si renv no puede iniciar por red: RENV_ACTIVATE_PROJECT=FALSE)
#             o en Positron: source(here::here("30_procesamiento", "39_atalaya_generar.R"))
# Dependen. : jsonlite, here (ambos en renv.lock) y R base.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-10-02
# ==============================================================================

source(here::here("10_utils", "10_locale.R"))
asegurar_locale_utf8("39_atalaya_generar")

source(here::here("30_procesamiento", "37_atalaya_extraer.R"), encoding = "UTF-8")
source(here::here("30_procesamiento", "38_atalaya_derivar.R"), encoding = "UTF-8")

# ---- Configuracion -----------------------------------------------------------

ATALAYA_RAIZ_DEMO  <- here::here("tests", "fixtures", "cartera_demo")
# Fecha de referencia fija para la demo: la salida es byte-estable.
ATALAYA_FECHA_DEMO <- as.Date("2026-10-02")
ATALAYA_PLANTILLA  <- here::here("30_procesamiento", "plantillas", "atalaya", "plantilla.html")
ATALAYA_FUENTES    <- here::here("30_procesamiento", "plantillas", "atalaya", "fuentes")
ATALAYA_ICONOS     <- here::here("30_procesamiento", "plantillas", "atalaya", "iconos")
ATALAYA_SALIDA     <- here::here("40_salidas", "atalaya_preview.html")
ATALAYA_SALIDA_JSON <- here::here("40_salidas", "atalaya_preview_datos.json")

# ---- Ensamblado --------------------------------------------------------------

leer_texto <- function(ruta) paste(readLines(ruta, encoding = "UTF-8", warn = FALSE), collapse = "\n")

#' Reemplaza un marcador literal una sola vez (sin interpretar la cadena nueva).
reemplazar_marcador <- function(txt, marcador, valor) {
  pos <- regexpr(marcador, txt, fixed = TRUE)
  if (pos < 0) stop(sprintf("39: la plantilla no contiene el marcador %s.", marcador))
  paste0(substr(txt, 1L, pos - 1L), valor, substr(txt, pos + attr(pos, "match.length"), nchar(txt)))
}

css_fuentes <- function() {
  def <- list(
    list(familia = "Geist",      archivo = "geist-latin-wght-normal.woff2"),
    list(familia = "Geist Mono", archivo = "geist-mono-latin-wght-normal.woff2")
  )
  reglas <- vapply(def, function(f) {
    ruta <- file.path(ATALAYA_FUENTES, f$archivo)
    if (!file.exists(ruta)) stop(sprintf("39: falta la fuente %s.", ruta))
    b64 <- jsonlite::base64_enc(readBin(ruta, "raw", file.info(ruta)$size))
    sprintf("@font-face{font-family:'%s';font-style:normal;font-weight:100 900;font-display:swap;src:url(data:font/woff2;base64,%s) format('woff2');}",
            f$familia, gsub("\n", "", b64))
  }, "")
  paste(reglas, collapse = "\n")
}

sprite_iconos <- function() {
  archivos <- sort(list.files(ATALAYA_ICONOS, pattern = "\\.svg$", full.names = TRUE))
  simbolos <- vapply(archivos, function(a) {
    s <- leer_texto(a)
    s <- gsub("<!--.*?-->", "", s, perl = TRUE)
    interior <- sub("(?s)^.*?<svg[^>]*>(.*)</svg>.*$", "\\1", s, perl = TRUE)
    interior <- gsub("\\s*\n\\s*", "", interior)
    sprintf("<symbol id=\"i-%s\" viewBox=\"0 0 24 24\">%s</symbol>",
            tools::file_path_sans_ext(basename(a)), interior)
  }, "")
  paste0("<svg class=\"sprite\" aria-hidden=\"true\">", paste(simbolos, collapse = ""), "</svg>")
}

#' Prueba de independencia de red: ninguna URL, CDN ni recurso remoto.
verificar_sin_red <- function(html) {
  patrones <- c(
    url_absoluta = "https?://",
    protocolo_relativo = "[\"'(]//[A-Za-z0-9]",
    cdn = "jsdelivr|unpkg|cdnjs|googleapis|gstatic|fontawesome",
    import_css = "@import",
    url_no_data = "url\\((?!['\"]?(data:|#))",
    src_remoto = "\\ssrc=[\"'](?!data:|#)",
    href_remoto = "<link[^>]+href=",
    fetch = "\\bfetch\\(|XMLHttpRequest|WebSocket|EventSource|navigator\\.sendBeacon"
  )
  hallazgos <- patrones[vapply(patrones, function(p) grepl(p, html, perl = TRUE), logical(1))]
  if (length(hallazgos)) {
    stop(sprintf("39: el HTML contiene referencias de red (%s). No se escribe una salida que dependa de Internet.",
                 paste(names(hallazgos), collapse = ", ")))
  }
  invisible(TRUE)
}

generar_atalaya_preview <- function(raiz = ATALAYA_RAIZ_DEMO, fecha_ref = ATALAYA_FECHA_DEMO,
                                    salida = ATALAYA_SALIDA, salida_json = ATALAYA_SALIDA_JSON) {
  ds <- construir_dataset(raiz, fecha_ref = fecha_ref, perfil = "demo",
                          raiz_rotulo = "tests/fixtures/cartera_demo")
  json <- jsonlite::toJSON(ds, auto_unbox = TRUE, null = "null", na = "null", digits = 4)
  # Un "</" dentro de <script> cerraria la etiqueta: se escapa como "<\/".
  json_embebido <- gsub("</", "<\\/", json, fixed = TRUE)

  html <- leer_texto(ATALAYA_PLANTILLA)
  html <- reemplazar_marcador(html, "/*@@FUENTES@@*/", css_fuentes())
  html <- reemplazar_marcador(html, "<!--@@ICONOS@@-->", sprite_iconos())
  html <- reemplazar_marcador(html, "@@DATOS@@", json_embebido)
  verificar_sin_red(html)

  dir.create(dirname(salida), showWarnings = FALSE, recursive = TRUE)
  con <- file(salida, open = "wb"); writeBin(charToRaw(enc2utf8(html)), con); close(con)
  writeLines(enc2utf8(jsonlite::prettify(json, indent = 2)), salida_json, useBytes = TRUE)

  n <- length(ds$proyectos)
  message(sprintf("[39_atalaya] %d proyectos, %d relaciones -> %s (%.0f KB)",
                  n, length(ds$relaciones), salida, file.info(salida)$size / 1024))
  invisible(salida)
}

generar_atalaya_preview()
