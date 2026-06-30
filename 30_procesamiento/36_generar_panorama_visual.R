# ==============================================================================
# 36_generar_panorama_visual.R
# ------------------------------------------------------------------------------
# Proposito : Generar un informe visual HTML autocontenido (panorama_visual.html)
#             y su gemelo en texto (panorama_visual.md) a partir del inventario
#             determinista (paso 34), el registro curado y la documentacion
#             curada de cada hermano (traspaso vigente + backlog_acumulativo.md).
#             Reusa la localizacion del paso 32 leyendo el inventario; no la
#             reescribe. Lectura de hermanos confinada a 50_documentacion/ (R2).
# Insumos   : 40_salidas/inventario_cartera.json (34); 20_insumos/registro_proyectos.csv;
#             por hermano: su traspaso vigente y backlog_acumulativo.md (si existe).
# Salidas   : 40_salidas/panorama_visual.html y panorama_visual.md (escritura
#             confinada por escribir_seguro).
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-29
# ==============================================================================

library(jsonlite)
library(readr)
library(stringr)

# ---- Constantes --------------------------------------------------------------

# Ruta al data.js del portafolio (slep_monitoreo) para sintesis/objetivo/tipo
# editoriales. NO vive en este repo: se lee in situ desde su ruta externa (R2),
# igual que los traspasos/backlogs de los hermanos; nunca se copia ni versiona.
# Si el archivo no existe (o esto vuelve a NA), se degrada con gracia: los campos
# quedan null y se reporta como advertencia.
RUTA_DATA_JS_PORTAFOLIO <- file.path(RAIZ_PROYECTOS, "slep_monitoreo", "data.js")

RUTA_PANORAMA_VISUAL_HTML <- file.path(RUTA_SALIDAS, "panorama_visual.html")
RUTA_PANORAMA_VISUAL_MD   <- file.path(RUTA_SALIDAS, "panorama_visual.md")

# Orden de estados (null/inicial primero -> concluido al final).
RANGO_ESTADO <- c(inicial = 0L, en_desarrollo = 1L, con_productos = 2L,
                  en_pausa = 3L, concluido = 4L)
MAX_RESENA <- 600L      # tope de caracteres de resena_itinerario.
MAX_PROXIMOS <- 3L      # tope de entradas de proximos_pasos.
N_PARRAFOS_SINTESIS_CARD <- 1L   # parrafos de sintesis[] que muestra la card (resto: "+N parrafos mas").

# Nombre canonico EXACTO del backlog (no se aceptan variantes).
SUBRUTA_BACKLOG_CANONICO <- file.path("50_documentacion", "activa", "backlog_acumulativo.md")

# Mapeo orden (entero estable de data.js) -> slug del hermano. Aprobado por el
# titular (sesion de cierre). Se clava por `orden` y NO por texto de titulo: si
# data.js reordena el array, el desfase orden<->slug es detectable a simple vista
# por el comentario inline (titulo literal de data.js al momento de aprobar).
MAPEO_ORDEN_SLUG <- c(
  `1`  = "slep_minuta_asistencia",                     # "Minuta de asistencia mensual"
  `2`  = "slep_reportes_modelo_resguardo_asistencia",  # "Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio"
  `3`  = "slep_simce_adecuado",                        # "Motor de comparacion interactivo de los resultados de los estandares de aprendizaje medidos por las pruebas Simce"
  `4`  = "slep_idps",                                  # "Motor de comparacion interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS)"
  `5`  = "slep_categoria_desempeno",                   # "Motor de comparacion interactivo de la Categoria de Desempeno de los establecimientos educacionales del pais"
  `6`  = "slep_aprendizajes_ep",                       # "Monitoreo de aprendizajes en la educacion parvularia"
  `7`  = "slep_seguimiento_educacion_inicial",         # "Analisis longitudinal de preferencias de matricula de egresados de jardines infantiles"
  `8`  = "slep_costapresente",                         # "CostaPresente"
  `9`  = "slep_alertas_ael",                           # "Sistema de alertas de Anotate en la Lista"
  `10` = "slep_minuta_desvinculacion",                 # "Analisis de trayectorias educativas interrumpidas"
  `11` = "slep_rendimiento_historico"                  # "Diagnostico historico del rendimiento escolar"
)

# ---- Helpers de lectura/parsing (tolerantes) ---------------------------------

leer_lineas <- function(ruta_abs) {
  if (is.na(ruta_abs) || !file.exists(ruta_abs)) return(character(0))
  readLines(ruta_abs, warn = FALSE, encoding = "UTF-8")
}

#' Nivel de un encabezado markdown (# = 1, ## = 2, ...). 0 si no es encabezado.
nivel_encabezado <- function(linea) {
  m <- str_match(linea, "^(#{1,6})\\s+")[, 2]
  if (is.na(m)) 0L else nchar(m)
}

#' Fecha declarada en la seccion de identificacion del traspaso (NO el mtime).
#' Busca una linea con "fecha" y un patron AAAA-MM-DD en las primeras lineas;
#' si no, la primera fecha ISO de esas lineas. Devuelve NA si no hay.
extraer_fecha_traspaso <- function(ruta_abs) {
  L <- leer_lineas(ruta_abs)
  if (length(L) == 0) return(NA_character_)
  cab <- head(L, 40)
  con_fecha <- cab[str_detect(cab, regex("fecha", ignore_case = TRUE)) &
                     str_detect(cab, "\\d{4}-\\d{2}-\\d{2}")]
  if (length(con_fecha) > 0) {
    return(str_match(con_fecha[1], "(\\d{4}-\\d{2}-\\d{2})")[, 2])
  }
  cualquiera <- str_match(cab, "(\\d{4}-\\d{2}-\\d{2})")[, 2]
  cualquiera <- cualquiera[!is.na(cualquiera)]
  if (length(cualquiera) > 0) cualquiera[1] else NA_character_
}

#' Devuelve el bloque de lineas de una seccion: desde el encabezado cuyo texto
#' matchea `patron` (case-insensitive) hasta el siguiente encabezado de nivel
#' igual o mayor (numero de # igual o menor). character(0) si no se encuentra.
bloque_seccion <- function(L, patron) {
  if (length(L) == 0) return(character(0))
  idx_cab <- which(vapply(L, nivel_encabezado, integer(1)) > 0)
  inicio <- NA_integer_
  for (i in idx_cab) {
    if (str_detect(L[i], regex(patron, ignore_case = TRUE))) { inicio <- i; break }
  }
  if (is.na(inicio)) return(character(0))
  nivel <- nivel_encabezado(L[inicio])
  fin <- length(L)
  siguientes <- idx_cab[idx_cab > inicio]
  for (j in siguientes) {
    if (nivel_encabezado(L[j]) <= nivel) { fin <- j - 1L; break }
  }
  if (inicio + 1L > fin) return(character(0))
  L[(inicio + 1L):fin]
}

#' Limpia marcadores markdown de una linea de entrada (vinetas, numeros, **).
limpiar_entrada <- function(linea) {
  x <- str_replace(linea, "^\\s*#{1,6}\\s+", "")        # subencabezado
  x <- str_replace(x, "^\\s*[-*+]\\s+", "")              # vineta
  x <- str_replace(x, "^\\s*\\d+[.)]\\s+", "")           # numerada
  x <- str_replace_all(x, "\\*\\*", "")                  # negritas
  x <- str_replace_all(x, "`", "")
  str_squish(x)
}

#' Primeras MAX_PROXIMOS entradas de la seccion de pendientes/ruta sugerida del
#' traspaso, como vector de strings cortos. NULL si no hay seccion/entradas.
extraer_proximos_pasos <- function(ruta_abs) {
  L <- leer_lineas(ruta_abs)
  if (length(L) == 0) return(NULL)
  blk <- bloque_seccion(L, "pendiente|ruta sugerida|pr.ximos pasos")
  if (length(blk) == 0) return(NULL)
  # Entradas candidatas: subencabezados (###/####) o vinetas.
  es_entrada <- str_detect(blk, "^\\s*#{3,6}\\s+") | str_detect(blk, "^\\s*[-*+]\\s+")
  cand <- blk[es_entrada]
  cand <- vapply(cand, limpiar_entrada, character(1))
  cand <- cand[nchar(cand) > 0]
  cand <- str_trunc(cand, 140, ellipsis = "…")
  if (length(cand) == 0) return(NULL)
  unname(head(cand, MAX_PROXIMOS))
}

#' Contenido de la seccion "Objetivo del proyecto" del backlog canonico, como
#' string corto (<= MAX_RESENA chars). NULL si no hay seccion/archivo.
extraer_objetivo_backlog <- function(ruta_abs) {
  L <- leer_lineas(ruta_abs)
  if (length(L) == 0) return(NULL)
  blk <- bloque_seccion(L, "objetivo del proyecto")
  blk <- blk[nchar(str_squish(blk)) > 0]
  if (length(blk) == 0) return(NULL)
  txt <- str_squish(paste(blk, collapse = " "))
  txt <- str_replace_all(txt, "\\*\\*", "")
  if (nchar(txt) == 0) return(NULL)
  str_trunc(txt, MAX_RESENA, ellipsis = "…")
}

#' "" o NA -> NA (para que el JSON lo serialice como null).
o_null <- function(x) {
  if (length(x) == 0) return(NA_character_)
  if (is.na(x) || !nzchar(trimws(x))) NA_character_ else x
}

#' Parsea el arreglo PROYECTOS de un data.js del portafolio. Enfoque (B.2): el
#' formato es JS plano y estable (claves sin comillas, valores con comillas
#' dobles consistentes, sin trailing commas, sin funciones, comentarios fuera de
#' los objetos), de uso interno. Por eso saneamos las 7 claves conocidas a
#' comillas y delegamos en jsonlite -mas robusto para el array multilinea
#' sintesis[] que una regex por campo-. tryCatch POR OBJETO: una entrada
#' malformada se omite con advertencia sin abortar el resto (patron tolerante).
#' Devuelve lista nombrada por `orden` (string), o NULL si el archivo no existe /
#' no hay arreglo / ninguna entrada parsea (degradacion con gracia).
parsear_data_js <- function(ruta_abs) {
  if (is.null(ruta_abs) || is.na(ruta_abs) || !file.exists(ruta_abs)) return(NULL)
  txt <- tryCatch(readr::read_file(ruta_abs), error = function(e) NA_character_)
  if (is.na(txt)) return(NULL)
  arr <- str_match(txt, "(?s)PROYECTOS\\s*=\\s*\\[(.*?)\\]\\s*;")[, 2]
  if (is.na(arr)) {
    log_msg("data.js: no se hallo el arreglo PROYECTOS; se omiten campos editoriales.",
            "36_visual", "WARN")
    return(NULL)
  }
  # Objetos top-level: { ... } sin llaves anidadas (formato plano observado).
  objs <- str_match_all(arr, "(?s)\\{[^{}]*\\}")[[1]][, 1]
  if (length(objs) == 0) return(NULL)
  res <- list()
  for (o in objs) {
    obj <- tryCatch({
      # Quotear SOLO las 7 claves conocidas, ancladas a inicio de linea (los
      # valores string viven en su propia linea iniciada por comilla -> no matchean).
      o2 <- str_replace_all(
        o, "(?m)^(\\s*)(orden|tipo|titulo|objetivo|sintesis|estado|imgs)\\s*:", '\\1"\\2":')
      jsonlite::fromJSON(o2, simplifyVector = FALSE)
    }, error = function(e) {
      log_msg(sprintf("data.js: entrada no parseable, se omite (%s).", conditionMessage(e)),
              "36_visual", "WARN")
      NULL
    })
    if (!is.null(obj) && !is.null(obj$orden)) {
      res[[as.character(as.integer(obj$orden))]] <- obj
    }
  }
  if (length(res) == 0) NULL else res
}

# ---- FASE 1: construir el objeto por proyecto --------------------------------

if (!file.exists(RUTA_INVENTARIO_JSON)) {
  stop("36: falta inventario_cartera.json. Ejecute primero los pasos 31-34.")
}
log_msg("Construyendo objetos de cartera para el panorama visual...", "36_visual")

inv <- jsonlite::read_json(RUTA_INVENTARIO_JSON, simplifyVector = FALSE)
registro <- as.data.frame(
  readr::read_csv(RUTA_REGISTRO, col_types = readr::cols(.default = readr::col_character())),
  stringsAsFactors = FALSE
)

# data.js del portafolio (in situ, R2): provee tipo/objetivo/sintesis editoriales.
# Si no esta disponible, se degrada con gracia (campos null + advertencia).
advertencias <- character(0)
datos_data_js <- parsear_data_js(RUTA_DATA_JS_PORTAFOLIO)
if (is.null(datos_data_js)) {
  advertencias <- c(advertencias,
    "data.js no disponible o sin entradas parseables: tipo/objetivo/sintesis quedan null para todos los proyectos.")
}
# Reindexado orden -> slug segun el mapeo aprobado (clave por orden estable).
datos_por_slug <- list()
if (!is.null(datos_data_js)) {
  for (ord in names(datos_data_js)) {
    if (ord %in% names(MAPEO_ORDEN_SLUG)) {
      datos_por_slug[[ MAPEO_ORDEN_SLUG[[ord]] ]] <- datos_data_js[[ord]]
    } else {
      advertencias <- c(advertencias,
        sprintf("data.js: orden %s sin slug en MAPEO_ORDEN_SLUG; entrada ignorada.", ord))
    }
  }
}

abs_de <- function(rel) {
  if (is.null(rel) || length(rel) == 0) return(NA_character_)
  r <- unlist(rel)
  if (is.na(r)) NA_character_ else file.path(RAIZ_PROYECTOS, r)
}

construir_objeto <- function(p) {
  slug <- p$slug
  rg <- registro[registro$slug == slug, , drop = FALSE]
  tiene_rg <- nrow(rg) == 1

  ruta_traspaso <- abs_de(p$documentos$traspaso)
  ruta_backlog_canon <- file.path(RAIZ_PROYECTOS, slug, SUBRUTA_BACKLOG_CANONICO)
  tiene_backlog <- file.exists(ruta_backlog_canon)

  fecha <- extraer_fecha_traspaso(ruta_traspaso)
  proximos <- extraer_proximos_pasos(ruta_traspaso)
  resena <- if (tiene_backlog) extraer_objetivo_backlog(ruta_backlog_canon) else NULL

  # Editoriales de data.js (NULL si este slug no tiene entrada mapeada).
  dj <- datos_por_slug[[slug]]
  parrafos <- if (!is.null(dj)) unlist(dj$sintesis) else character(0)
  # Card: primer(os) N_PARRAFOS_SINTESIS_CARD parrafo(s) completos, SIN truncar
  # (MAX_RESENA es exclusivo de resena_itinerario del backlog).
  sintesis_card <- if (length(parrafos) >= 1)
    paste(head(parrafos, N_PARRAFOS_SINTESIS_CARD), collapse = "\n\n") else NA_character_
  parrafos_extra <- max(0L, length(parrafos) - N_PARRAFOS_SINTESIS_CARD)

  list(
    slug             = slug,
    nombre_real      = if (tiene_rg) o_null(rg$nombre_real) else NA_character_,
    alias_corto      = if (tiene_rg) o_null(rg$alias_corto) else NA_character_,
    categoria        = if (tiene_rg) o_null(rg$categoria) else o_null(p$categoria),
    datos_sensibles  = if (tiene_rg) o_null(rg$datos_sensibles) else NA_character_,
    estado_proyecto  = if (tiene_rg) o_null(rg$estado_proyecto) else NA_character_,
    sintesis         = sintesis_card,                          # primer parrafo de data.js (o null)
    sintesis_parrafos_extra = parrafos_extra,                  # parrafos restantes no mostrados en la card
    objetivo         = if (!is.null(dj)) o_null(dj$objetivo) else NA_character_,
    tipo             = if (!is.null(dj)) o_null(dj$tipo) else NA_character_,
    fecha_actualizacion = if (is.null(fecha) || is.na(fecha)) NA_character_ else fecha,
    proximos_pasos   = if (is.null(proximos)) NA else as.list(proximos),
    tiene_backlog    = tiene_backlog,
    resena_itinerario = if (is.null(resena)) NA_character_ else resena
  )
}

objetos <- lapply(inv$proyectos, construir_objeto)

# ---- FASE 2: ordenar las cards -----------------------------------------------

rango_de <- function(estado) {
  if (is.na(estado)) return(0L)                 # null -> primero (como inicial)
  r <- RANGO_ESTADO[[estado]]
  if (is.null(r)) 0L else r
}
clave_fecha <- function(f) if (is.na(f)) "0000-00-00" else f  # NA al final del grupo

ord <- order(
  vapply(objetos, function(o) rango_de(o$estado_proyecto), integer(1)),
  vapply(objetos, function(o) clave_fecha(o$fecha_actualizacion), character(1)),
  decreasing = c(FALSE, TRUE),
  method = "radix"
)
objetos <- objetos[ord]

# ---- JSON para embeber -------------------------------------------------------

json_cartera <- jsonlite::toJSON(
  objetos, auto_unbox = TRUE, na = "null", null = "null", pretty = TRUE
)
# Blindaje para embeber en <script>: evitar cierre prematuro.
json_embebido <- str_replace_all(as.character(json_cartera), "</", "<\\\\/")

fecha_generacion <- format(Sys.Date(), "%Y-%m-%d")
n_total <- length(objetos)

# ---- FASE 3: panorama_visual.html (autocontenido) ----------------------------

# Bajo locale C, los literales no-ASCII de este script se parsean como
# Encoding "unknown" con bytes UTF-8 validos. Al concatenarlos (paste0/sprintf)
# con strings ya marcados UTF-8 (JSON embebido, datos de readLines), R recodifica
# desde el locale nativo (C) hacia UTF-8 y, como C no representa esos bytes altos,
# los escapa como texto literal "<c3><81>" (mojibake; misma familia que el em-dash
# de la sesion 1, backlog #17). u8() declara el literal como UTF-8 ANTES de
# mezclar: solo reetiqueta el Encoding, no altera los bytes, evitando el viaje
# de ida y vuelta por el locale nativo.
u8 <- function(x) { Encoding(x) <- "UTF-8"; x }

# Paleta: tokens nombrados del portafolio, sincronizados con los valores reales
# de la marca SLEP Costa Central (colors_and_type.css del portafolio).
css <- '
:root{
  --plum:#4A2746; --cream:#FFF6E0; --ocean:#0062A0; --olive:#75924E;
  --coral:#E88663; --slate:#747474; --sand:#BCA493; --ink:#1C1212;
  --ink-2:#2E2230;
  --line:#e3dccf; --muted:#6f6a63; --card:#ffffff;
}
*{box-sizing:border-box}
body{margin:0;background:var(--cream);color:var(--ink);
  font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif;line-height:1.5}
.wrap{max-width:1200px;margin:0 auto;padding:24px 20px 60px}
header.top{border-bottom:3px solid var(--plum);padding-bottom:14px;margin-bottom:22px}
header.top h1{margin:0;font-size:1.5rem;color:var(--plum)}
header.top .meta{color:var(--muted);font-size:.9rem;margin-top:4px}
.grid{display:grid;grid-template-columns:1fr;gap:18px}
@media(min-width:900px){.grid{grid-template-columns:repeat(2,1fr)}}
@media(min-width:1300px){.grid{grid-template-columns:repeat(3,1fr)}}
.card{background:var(--card);border:1px solid var(--line);border-radius:12px;
  padding:16px 18px;box-shadow:0 1px 3px rgba(0,0,0,.05);display:flex;flex-direction:column;gap:8px}
.card h2{margin:0;font-size:1.1rem;color:var(--plum)}
.card .slug{font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-size:.74rem;color:var(--muted)}
.badges{display:flex;flex-wrap:wrap;gap:6px;margin:2px 0}
.badge{font-size:.72rem;font-weight:600;padding:2px 9px;border-radius:999px;color:#fff;white-space:nowrap}
.b-con_productos{background:var(--olive)} .b-en_desarrollo{background:var(--sand);color:var(--ink)}
.b-inicial{background:var(--ocean)} .b-en_pausa{background:var(--slate)}
.b-concluido{background:var(--plum)} .b-sinclasif{background:#9a948c}
.b-sensible{background:var(--coral)} .b-publico{background:#b9c2a6;color:var(--ink)}
.fecha{font-size:.82rem;color:var(--muted)}
.tipo{font-size:.72rem;font-weight:600;color:var(--ocean);text-transform:uppercase;letter-spacing:.03em}
.sint{font-size:.92rem}
.mas{font-size:.78rem;color:var(--muted);font-style:italic}
.blk{font-size:.85rem;background:var(--cream);border-left:3px solid var(--line);padding:8px 10px;border-radius:6px}
.blk .lbl{display:block;font-weight:700;font-size:.7rem;text-transform:uppercase;letter-spacing:.04em;color:var(--muted);margin-bottom:3px}
.blk ul{margin:4px 0 0;padding-left:18px} .blk li{margin:2px 0}
footer.bot{margin-top:30px;border-top:1px solid var(--line);padding-top:14px;color:var(--muted);font-size:.85rem}
footer.bot .conteos{display:flex;flex-wrap:wrap;gap:14px;margin-top:6px}
'

js <- u8('
const RAW = document.getElementById("datos-cartera").textContent;
const CARTERA = JSON.parse(RAW);
const ETIQUETA_ESTADO = {inicial:"inicial",en_desarrollo:"en desarrollo",
  con_productos:"con productos",en_pausa:"en pausa",concluido:"concluido"};
const MES = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto",
  "septiembre","octubre","noviembre","diciembre"];
function fechaEs(s){
  if(!s) return "sin traspaso";
  const m = /^(\\d{4})-(\\d{2})-(\\d{2})$/.exec(s);
  if(!m) return s;
  return parseInt(m[3],10)+" de "+MES[parseInt(m[2],10)-1]+" de "+m[1];
}
function el(tag,cls,txt){const e=document.createElement(tag);if(cls)e.className=cls;
  if(txt!=null)e.textContent=txt;return e;}
function badgeEstado(estado){
  const cls = estado ? ("b-"+estado) : "b-sinclasif";
  const txt = estado ? (ETIQUETA_ESTADO[estado]||estado) : "sin clasificar";
  return el("span","badge "+cls,txt);
}
function render(){
  const grid=document.getElementById("grid");
  CARTERA.forEach(p=>{
    const c=el("div","card");
    c.appendChild(el("h2",null,p.nombre_real||p.slug));
    c.appendChild(el("div","slug",p.slug));
    if(p.tipo) c.appendChild(el("div","tipo",p.tipo));
    const b=el("div","badges");
    b.appendChild(badgeEstado(p.estado_proyecto));
    if(p.datos_sensibles==="si")b.appendChild(el("span","badge b-sensible","datos sensibles"));
    else if(p.datos_sensibles==="no")b.appendChild(el("span","badge b-publico","datos públicos"));
    c.appendChild(b);
    const sint = p.sintesis || (p.objetivo? String(p.objetivo).split(/(?<=\\.)\\s/)[0] : null);
    if(sint){
      c.appendChild(el("p","sint",sint));
      if(p.sintesis_parrafos_extra>0)
        c.appendChild(el("div","mas","+"+p.sintesis_parrafos_extra+" párrafos más"));
    }
    c.appendChild(el("div","fecha","Última actualización: "+fechaEs(p.fecha_actualizacion)));
    if(p.tiene_backlog && p.resena_itinerario){
      const blk=el("div","blk"); blk.appendChild(el("span","lbl","Reseña del itinerario"));
      blk.appendChild(el("div",null,p.resena_itinerario)); c.appendChild(blk);
    }
    if(p.proximos_pasos && p.proximos_pasos.length){
      const blk=el("div","blk"); blk.appendChild(el("span","lbl","Próximos pasos"));
      const ul=el("ul"); p.proximos_pasos.forEach(x=>ul.appendChild(el("li",null,x)));
      blk.appendChild(ul); c.appendChild(blk);
    }
    grid.appendChild(c);
  });
  // Conteos por estado en el footer.
  const cont={};
  CARTERA.forEach(p=>{const k=p.estado_proyecto||"sin clasificar";cont[k]=(cont[k]||0)+1;});
  const cdiv=document.getElementById("conteos");
  Object.keys(cont).forEach(k=>{cdiv.appendChild(el("span",null,(ETIQUETA_ESTADO[k]||k)+": "+cont[k]));});
}
render();
')

html <- paste0(
  "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n<meta charset=\"utf-8\">\n",
  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n",
  u8("<title>Panorama de la cartera — Área de Monitoreo</title>\n"),
  "<style>", css, "</style>\n</head>\n<body>\n<div class=\"wrap\">\n",
  u8("<header class=\"top\">\n<h1>Panorama de la cartera — Área de Monitoreo</h1>\n"),
  "<div class=\"meta\">Generado: ", fecha_generacion, u8(" · "), n_total, " proyectos</div>\n</header>\n",
  "<main id=\"grid\" class=\"grid\"></main>\n",
  "<footer class=\"bot\">Total de proyectos: ", n_total,
  "<div class=\"conteos\" id=\"conteos\"></div></footer>\n",
  "</div>\n",
  "<script type=\"application/json\" id=\"datos-cartera\">\n", json_embebido, "\n</script>\n",
  "<script>\n", js, "\n</script>\n</body>\n</html>\n"
)

escribir_seguro(RUTA_PANORAMA_VISUAL_HTML, function(r) writeLines(html, r, useBytes = TRUE))

# ---- FASE 4: panorama_visual.md ----------------------------------------------

et_estado <- function(e) {
  if (is.na(e)) return("sin clasificar")
  c(inicial="inicial", en_desarrollo="en desarrollo", con_productos="con productos",
    en_pausa="en pausa", concluido="concluido")[e] |> (\(x) if (is.na(x)) e else x)()
}
m_lin <- character(0)
ap <- function(...) m_lin <<- c(m_lin, ...)
ap(sprintf(u8("# Panorama visual de la cartera — Área de Monitoreo")), "",
   sprintf(u8("Generado: %s · %d proyectos"), fecha_generacion, n_total), "",
   u8("> Versión texto del panorama visual (mismo orden y campos que las cards)."), "")
for (o in objetos) {
  ap(sprintf("## %s", if (is.na(o$nombre_real)) o$slug else o$nombre_real))
  ap(sprintf("- **slug:** `%s`", o$slug))
  if (!is.na(o$tipo)) ap(sprintf("- **tipo:** %s", o$tipo))
  ap(sprintf("- **estado:** %s", et_estado(o$estado_proyecto)))
  ds <- if (is.na(o$datos_sensibles)) "sin clasificar" else o$datos_sensibles
  ap(sprintf("- **datos sensibles:** %s", ds))
  ap(sprintf(u8("- **última actualización:** %s"),
             if (is.na(o$fecha_actualizacion)) "sin traspaso" else o$fecha_actualizacion))
  sint <- if (!is.na(o$sintesis)) o$sintesis else if (!is.na(o$objetivo)) o$objetivo else NA
  if (!is.na(sint)) {
    mas <- if (o$sintesis_parrafos_extra > 0)
      sprintf(u8(" (+%d párrafos más)"), o$sintesis_parrafos_extra) else ""
    ap(sprintf(u8("- **síntesis:** %s%s"), sint, mas))
  }
  if (isTRUE(o$tiene_backlog) && !is.na(o$resena_itinerario))
    ap(sprintf(u8("- **reseña del itinerario:** %s"), o$resena_itinerario))
  if (!identical(o$proximos_pasos, NA) && length(o$proximos_pasos) > 0) {
    ap(u8("- **próximos pasos:**"))
    for (x in o$proximos_pasos) ap(sprintf("  - %s", x))
  }
  ap("")
}
escribir_seguro(RUTA_PANORAMA_VISUAL_MD, function(r) writeLines(m_lin, r, useBytes = TRUE))

# ---- Cierre ------------------------------------------------------------------

n_backlog <- sum(vapply(objetos, function(o) isTRUE(o$tiene_backlog), logical(1)))
n_sin_estado <- sum(vapply(objetos, function(o) is.na(o$estado_proyecto), logical(1)))
for (a in advertencias) log_msg(a, "36_visual", "WARN")
log_msg(sprintf("panorama_visual.html/.md generados: %d proyectos, %d con backlog, %d sin estado_proyecto.",
                n_total, n_backlog, n_sin_estado), "36_visual")
