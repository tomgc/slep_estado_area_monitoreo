# ==============================================================================
# 39_portafolio_generar.R
# ------------------------------------------------------------------------------
# Proposito : Genera portafolio_preview.html: un unico HTML autocontenido (CSS, JS,
#             fuentes, iconos y dataset embebidos) que se abre con doble clic,
#             sin servidor, sin Internet, sin R ni Node una vez generado.
#             Flujo: Markdown -> 37 (extraer) -> 38 (derivar) -> dataset JSON
#             -> plantilla -> HTML. Al final verifica que el HTML no contenga
#             ninguna referencia de red y aborta si la encuentra.
# Insumos   : tests/fixtures/cartera_demo/<proyecto>/*.md (cartera demo)
#             30_procesamiento/plantillas/portafolio/plantilla.html
#             30_procesamiento/plantillas/portafolio/fuentes/gobCL_*.otf
#             30_procesamiento/plantillas/portafolio/iconos/*.svg (Lucide, ISC)
# Salidas   : 40_salidas/portafolio_preview.html
#             40_salidas/portafolio_preview_datos.json (mismo dataset, legible)
# Uso       : Rscript 30_procesamiento/39_portafolio_generar.R
#             (si renv no puede iniciar por red: RENV_ACTIVATE_PROJECT=FALSE)
#             o en Positron: source(here::here("30_procesamiento", "39_portafolio_generar.R"))
# Dependen. : jsonlite, here (ambos en renv.lock) y R base.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-10-02
# ==============================================================================

source(here::here("10_utils", "10_locale.R"))
asegurar_locale_utf8("39_portafolio_generar")

source(here::here("30_procesamiento", "37_portafolio_extraer.R"), encoding = "UTF-8")
source(here::here("30_procesamiento", "38_portafolio_derivar.R"), encoding = "UTF-8")

# ---- Configuracion -----------------------------------------------------------

PORTAFOLIO_RAIZ_DEMO  <- here::here("tests", "fixtures", "cartera_demo")
# Fecha de referencia fija para la demo: la salida es byte-estable.
PORTAFOLIO_FECHA_DEMO <- as.Date("2026-10-02")
PORTAFOLIO_PLANTILLA  <- here::here("30_procesamiento", "plantillas", "portafolio", "plantilla.html")
PORTAFOLIO_FUENTES    <- here::here("30_procesamiento", "plantillas", "portafolio", "fuentes")
PORTAFOLIO_ICONOS     <- here::here("30_procesamiento", "plantillas", "portafolio", "iconos")
PORTAFOLIO_SALIDA     <- here::here("40_salidas", "portafolio_preview.html")
PORTAFOLIO_SALIDA_JSON <- here::here("40_salidas", "portafolio_preview_datos.json")

# ---- Ensamblado --------------------------------------------------------------

leer_texto <- function(ruta) paste(readLines(ruta, encoding = "UTF-8", warn = FALSE), collapse = "\n")

#' Reemplaza un marcador literal una sola vez (sin interpretar la cadena nueva).
reemplazar_marcador <- function(txt, marcador, valor) {
  pos <- regexpr(marcador, txt, fixed = TRUE)
  if (pos < 0) stop(sprintf("39: la plantilla no contiene el marcador %s.", marcador))
  paste0(substr(txt, 1L, pos - 1L), valor, substr(txt, pos + attr(pos, "match.length"), nchar(txt)))
}

# Unica familia permitida: gobCL (tipografia institucional del Gobierno de Chile).
css_fuentes <- function() {
  def <- list(
    list(peso = 300L, archivo = "gobCL_Light.otf"),
    list(peso = 400L, archivo = "gobCL_Regular.otf"),
    list(peso = 700L, archivo = "gobCL_Bold.otf"),
    list(peso = 900L, archivo = "gobCL_Heavy.otf")
  )
  reglas <- vapply(def, function(f) {
    ruta <- file.path(PORTAFOLIO_FUENTES, f$archivo)
    if (!file.exists(ruta)) stop(sprintf("39: falta la fuente %s.", ruta))
    b64 <- jsonlite::base64_enc(readBin(ruta, "raw", file.info(ruta)$size))
    sprintf("@font-face{font-family:'gobCL';font-style:normal;font-weight:%d;font-display:swap;src:url(data:font/otf;base64,%s) format('opentype');}",
            f$peso, gsub("\n", "", b64))
  }, "")
  paste(reglas, collapse = "\n")
}

sprite_iconos <- function() {
  archivos <- sort(list.files(PORTAFOLIO_ICONOS, pattern = "\\.svg$", full.names = TRUE))
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

generar_portafolio_preview <- function(raiz = PORTAFOLIO_RAIZ_DEMO, fecha_ref = PORTAFOLIO_FECHA_DEMO,
                                    salida = PORTAFOLIO_SALIDA, salida_json = PORTAFOLIO_SALIDA_JSON) {
  ds <- construir_dataset(raiz, fecha_ref = fecha_ref, perfil = "demo",
                          raiz_rotulo = "tests/fixtures/cartera_demo")
  json <- jsonlite::toJSON(ds, auto_unbox = TRUE, null = "null", na = "null", digits = 4)
  # Un "</" dentro de <script> cerraria la etiqueta: se escapa como "<\/".
  json_embebido <- gsub("</", "<\\/", json, fixed = TRUE)

  html <- leer_texto(PORTAFOLIO_PLANTILLA)
  html <- reemplazar_marcador(html, "/*@@FUENTES@@*/", css_fuentes())
  html <- reemplazar_marcador(html, "<!--@@ICONOS@@-->", sprite_iconos())
  html <- reemplazar_marcador(html, "@@DATOS@@", json_embebido)
  verificar_sin_red(html)

  dir.create(dirname(salida), showWarnings = FALSE, recursive = TRUE)
  con <- file(salida, open = "wb"); writeBin(charToRaw(enc2utf8(html)), con); close(con)
  writeLines(enc2utf8(jsonlite::prettify(json, indent = 2)), salida_json, useBytes = TRUE)

  n <- length(ds$proyectos)
  message(sprintf("[39_portafolio] %d proyectos, %d relaciones -> %s (%.0f KB)",
                  n, length(ds$relaciones), salida, file.info(salida)$size / 1024))
  invisible(salida)
}

generar_portafolio_preview()
