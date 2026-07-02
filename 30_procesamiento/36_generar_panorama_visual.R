# ==============================================================================
# 36_generar_panorama_visual.R
# ------------------------------------------------------------------------------
# Proposito : Generar un informe visual HTML autocontenido (panorama_visual.html)
#             y su gemelo en texto (panorama_visual.md) a partir del inventario
#             determinista (paso 34), el registro curado y la documentacion
#             curada de cada hermano (traspaso vigente + backlog_acumulativo.md).
#             Reusa la localizacion del paso 32 leyendo el inventario; no la
#             reescribe. Lectura de hermanos confinada a 50_documentacion/ (R2).
#             Fase 2 PUSH: consume `semaforo` (+ "Proximo paso") de ESTADO.md de
#             cada hermano, con fallback a PULL. Reusa en sesion la decision de
#             sincronizacion YA computada por resolver_estado() (32, con margen
#             P-DESYNC-MARGEN) via `lista_documentos`; si corre standalone
#             (run_all(only=6), sin ese objeto en sesion) cae a una relectura
#             autocontenida que reusa el MISMO parser/formula (ver
#             leer_estado_hermano()). Deteccion de desync/tipo_pendiente NO se
#             reimplementa de forma independiente (evita divergencia).
# Insumos   : 40_salidas/inventario_cartera.json (34); 20_insumos/registro_proyectos.csv;
#             por hermano: su traspaso vigente, backlog_acumulativo.md y
#             ESTADO.md (si existen).
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
# Orden de prioridad de tipo_pendiente (Fase 2 PUSH, enum SETTINGS SS1.2.4):
# bug/bloqueante primero, cosmetica/ninguno al final. Criterio de priorizacion
# de la apertura de sesion (SETTINGS SS1.2.4), aplicado aqui al ordenamiento del
# acordeon (P-FASE2-PIEZA-C, traspaso v05 SS11). Sin dato (NA, hermano sin
# ESTADO.md o sin tipo_pendiente declarado) va al final, junto a "ninguno".
RANGO_TIPO_PENDIENTE <- c(bug = 0L, bloqueante = 1L, deuda_heredada = 2L,
                          deuda_tecnica = 3L, nuevo = 4L, cosmetica = 5L,
                          ninguno = 6L)
MAX_RESENA <- 600L      # tope de caracteres de resena_itinerario.
MAX_PROXIMOS <- 3L      # tope de entradas de proximos_pasos.

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

#' Fase 1+2 (PUSH de ESTADO.md, con fallback a PULL): resuelve semaforo,
#' tipo_pendiente crudo y "Proximo paso" de un hermano.
#'
#' Camino primario: si `lista_documentos` existe EN SESION (36 corrio como
#' parte de un run_all() completo, tras el paso 32), reusa integramente la
#' decision de sincronizacion ya computada por resolver_estado() -incluido el
#' margen de tolerancia P-DESYNC-MARGEN- sin releer ni reinterpretar nada.
#' Evita una segunda implementacion de la regla de desync que podria divergir
#' de la de 32 (p. ej. una version sin margen reintroduciria el falso-desync
#' de medianoche ya corregido).
#'
#' Camino de respaldo (standalone, ej. run_all(only=6) sin haber corrido el
#' paso 32 en esta sesion): relectura autocontenida que reusa el MISMO parser
#' (parsear_front_matter, 10_utils.R) y la MISMA formula/constantes de margen
#' (MARGEN_DESYNC_DIAS, TZ_ORQUESTADOR, 10_configuracion.R) para no divergir.
#'
#' Degradacion con gracia (mismo idioma que parsear_data_js): sin ESTADO.md,
#' front matter no reconocible, o hermano desincronizado -> semaforo=NA y
#' proximo_paso=NA (se trata como si no existiera, Fase 1 PULL). tipo_pendiente
#' crudo se devuelve SIEMPRE que exista el campo (no gateado por sync: el
#' inventario/34 ya lo trata asi "como hoy"; se usa solo para el chequeo
#' cruzado de auditoria, no para decidir nada operativo aqui).
#'
#' @return list(semaforo, proximo_paso, tipo_pendiente_raw, sincronizado, presente)
leer_estado_hermano <- function(slug, ruta_traspaso) {
  vacio <- list(semaforo = NA_character_, proximo_paso = NA_character_,
                tipo_pendiente_raw = NA_character_, sincronizado = FALSE,
                presente = FALSE)

  ld <- if (exists("lista_documentos", inherits = TRUE)) {
    get("lista_documentos", inherits = TRUE)[[slug]]
  } else NULL

  if (!is.null(ld) && !is.null(ld$estado)) {
    est <- ld$estado
    sem <- est$meta$semaforo
    tp  <- est$tipo_pendiente
    return(list(
      semaforo = if (isTRUE(est$sincronizado) && !is.null(sem) && nzchar(sem)) sem else NA_character_,
      proximo_paso = if (isTRUE(est$sincronizado) && !is.null(est$proximo) && !is.na(est$proximo)) est$proximo else NA_character_,
      tipo_pendiente_raw = if (is.null(tp) || is.na(tp) || !nzchar(tp)) NA_character_ else tp,
      sincronizado = isTRUE(est$sincronizado),
      presente = isTRUE(est$presente)
    ))
  }

  # ---- Fallback standalone (sin lista_documentos en sesion) ------------------
  ruta <- file.path(RAIZ_PROYECTOS, slug, "50_documentacion", "activa", "ESTADO.md")
  if (!file.exists(ruta)) return(vacio)

  L  <- readLines(ruta, warn = FALSE, encoding = "UTF-8")
  fm <- parsear_front_matter(L)
  meta <- fm$meta

  ua <- suppressWarnings(as.Date(if (is.null(meta$ultima_actividad)) NA_character_ else meta$ultima_actividad))
  tz_loc <- if (exists("TZ_ORQUESTADOR")) TZ_ORQUESTADOR else ""
  mt <- if (!is.na(ruta_traspaso) && file.exists(ruta_traspaso))
          as.Date(format(file.mtime(ruta_traspaso), "%Y-%m-%d", tz = tz_loc)) else NA
  margen <- if (exists("MARGEN_DESYNC_DIAS")) MARGEN_DESYNC_DIAS else 0L
  sinc <- !is.na(ua) && (is.na(mt) || !(ua < (mt - margen)))

  prox_raw <- bloque_seccion(fm$cuerpo, "Proximo paso")
  prox <- if (length(prox_raw) == 0) "" else
    trimws(paste(prox_raw[nzchar(trimws(prox_raw))], collapse = " "))

  sem <- meta$semaforo
  tp  <- meta$tipo_pendiente
  list(
    semaforo = if (sinc && !is.null(sem) && nzchar(sem)) sem else NA_character_,
    proximo_paso = if (sinc && nzchar(prox)) prox else NA_character_,
    tipo_pendiente_raw = if (is.null(tp) || !nzchar(tp)) NA_character_ else tp,
    sincronizado = sinc,
    presente = TRUE
  )
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

# Fase 2 PUSH: estado (semaforo/proximo_paso/tipo_pendiente crudo) por slug,
# precomputado una vez (mismo patron que datos_por_slug para data.js).
estados_hno <- stats::setNames(
  lapply(inv$proyectos, function(p) leer_estado_hermano(p$slug, abs_de(p$documentos$traspaso))),
  vapply(inv$proyectos, function(p) p$slug, character(1))
)

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
  # Acordeon: la fila expandida muestra TODOS los parrafos de sintesis[] (sin
  # truncar; MAX_RESENA es exclusivo de resena_itinerario del backlog).
  parrafos <- if (!is.null(dj)) unlist(dj$sintesis) else character(0)

  # Fase 2 PUSH: semaforo + "Proximo paso" de ESTADO.md (NA si desincronizado,
  # ausente, o front matter no reconocible -> se trata como PULL, con gracia).
  eh <- estados_hno[[slug]]
  semaforo_hno <- if (is.null(eh)) NA_character_ else o_null(eh$semaforo)

  # proximo_paso de ESTADO.md se ANTEPONE a proximos_pasos (traspaso), no lo
  # reemplaza; sin duplicar si ya coincide textualmente con el primer elemento.
  proximos_base <- if (is.null(proximos)) character(0) else proximos
  prox_hno <- if (is.null(eh)) NA_character_ else o_null(eh$proximo_paso)
  if (!is.na(prox_hno)) {
    ya_primero <- length(proximos_base) >= 1 &&
      identical(trimws(proximos_base[1]), trimws(prox_hno))
    if (!ya_primero) proximos_base <- head(c(prox_hno, proximos_base), MAX_PROXIMOS)
  }

  list(
    slug             = slug,
    nombre_real      = if (tiene_rg) o_null(rg$nombre_real) else NA_character_,
    alias_corto      = if (tiene_rg) o_null(rg$alias_corto) else NA_character_,
    categoria        = if (tiene_rg) o_null(rg$categoria) else o_null(p$categoria),
    datos_sensibles  = if (tiene_rg) o_null(rg$datos_sensibles) else NA_character_,
    estado_proyecto  = if (tiene_rg) o_null(rg$estado_proyecto) else NA_character_,
    # Fase 2 PUSH: tipo_pendiente ya viene tipado desde 34 (inv$proyectos[[i]]$estado$tipo_pendiente).
    # Enum SETTINGS SS1.2.4 (bug|bloqueante|deuda_heredada|deuda_tecnica|nuevo|cosmetica|ninguno);
    # NA si el hermano no tiene ESTADO.md o no declaro el campo. Usado para el
    # ordenamiento de la Fase 2 (P-FASE2-PIEZA-C), no se traduce ni se amplia aqui.
    # Puede ser reconciliado (override + advertencia) por el chequeo cruzado de
    # abajo si difiere del ESTADO.md sincronizado (Fase 3, ver mas abajo).
    tipo_pendiente   = o_null(unlist(p$estado$tipo_pendiente)),
    # Fase 2 PUSH (Fase 5 UI): semaforo activo|pausa|bloqueado|cerrado, NA si el
    # hermano no tiene ESTADO.md sincronizado (fallback visual neutro en UI).
    semaforo         = semaforo_hno,
    sintesis         = if (length(parrafos) >= 1) as.list(parrafos) else NA,  # todos los parrafos (o null)
    objetivo         = if (!is.null(dj)) o_null(dj$objetivo) else NA_character_,
    tipo             = if (!is.null(dj)) o_null(dj$tipo) else NA_character_,
    fecha_actualizacion = if (is.null(fecha) || is.na(fecha)) NA_character_ else fecha,
    proximos_pasos   = if (length(proximos_base) == 0) NA else as.list(proximos_base),
    tiene_backlog    = tiene_backlog,
    resena_itinerario = if (is.null(resena)) NA_character_ else resena
  )
}

objetos <- lapply(inv$proyectos, construir_objeto)

# ---- Fase 3 (reconciliacion) + mandato de auto-auditoria ---------------------
#
# Chequeo cruzado de precedencia: por cada hermano con ESTADO.md, imprime en
# consola (evidencia de trabajo, NO en el reporte final) semaforo_estado_md vs
# tipo_pendiente_inventario vs tipo_pendiente_final, para confirmar
# EMPIRICAMENTE (no por diseno asumido) que "ESTADO.md manda" se aplica en
# cada caso. Por construccion (tipo_pendiente del inventario YA proviene de
# ESTADO.md via 32/34), normalmente no hay divergencia; si el chequeo la
# encuentra (p. ej. inventario_cartera.json desactualizado respecto a un
# ESTADO.md leido en esta misma corrida), ESTADO.md GANA (override + WARN),
# tal como pide la Fase 3 del encargo.
cat("\n=== Chequeo cruzado de precedencia (Fase 2 PUSH, auditoria) ===\n")
for (i in seq_along(inv$proyectos)) {
  p_i <- inv$proyectos[[i]]
  eh_i <- estados_hno[[p_i$slug]]
  if (is.null(eh_i) || !isTRUE(eh_i$presente)) next  # sin ESTADO.md: nada que auditar

  sem_md <- eh_i$semaforo
  tp_inventario <- objetos[[i]]$tipo_pendiente
  tp_estado_md  <- eh_i$tipo_pendiente_raw

  diverge <- isTRUE(eh_i$sincronizado) && !is.na(tp_estado_md) && !is.na(tp_inventario) &&
    !identical(tp_estado_md, tp_inventario)
  if (diverge) {
    objetos[[i]]$tipo_pendiente <- tp_estado_md
    advertencias <- c(advertencias, sprintf(
      "Reconciliacion tipo_pendiente [%s]: ESTADO.md (%s) difiere del inventario (%s); ESTADO.md manda.",
      p_i$slug, tp_estado_md, tp_inventario))
  }
  tp_final <- objetos[[i]]$tipo_pendiente

  cat(sprintf(
    "%-46s semaforo_estado_md=%-11s tipo_pendiente_inventario=%-16s tipo_pendiente_final=%-16s sincronizado=%-5s %s\n",
    p_i$slug,
    if (is.na(sem_md)) "NA" else sem_md,
    if (is.na(tp_inventario)) "NA" else tp_inventario,
    if (is.na(tp_final)) "NA" else tp_final,
    isTRUE(eh_i$sincronizado),
    if (diverge) "*** DIVERGE (reconciliado) ***" else "OK"
  ))
}

# ---- FASE 2: ordenar las cards -----------------------------------------------

# P-FASE2-PIEZA-C (agenda priorizada): orden por tipo_pendiente (prioridad de
# sesion, SETTINGS SS1.2.4) primero, estado_proyecto segundo, fecha (desc)
# tercero. Decision del titular (sesion 6): tipo_pendiente -> estado_proyecto
# -> fecha_actualizacion.
rango_tp_de <- function(tp) {
  if (is.na(tp)) return(length(RANGO_TIPO_PENDIENTE))  # sin dato -> ultimo, junto a "ninguno"
  r <- RANGO_TIPO_PENDIENTE[[tp]]
  if (is.null(r)) length(RANGO_TIPO_PENDIENTE) else r
}
rango_de <- function(estado) {
  if (is.na(estado)) return(0L)                 # null -> primero (como inicial)
  r <- RANGO_ESTADO[[estado]]
  if (is.null(r)) 0L else r
}
clave_fecha <- function(f) if (is.na(f)) "0000-00-00" else f  # NA al final del grupo

ord <- order(
  vapply(objetos, function(o) rango_tp_de(o$tipo_pendiente), integer(1)),
  vapply(objetos, function(o) rango_de(o$estado_proyecto), integer(1)),
  vapply(objetos, function(o) clave_fecha(o$fecha_actualizacion), character(1)),
  decreasing = c(FALSE, FALSE, TRUE),
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
  /* Semaforo (Fase 2 PUSH): activo/cerrado reusan tokens existentes; pausa y
     bloqueado son nuevos, tomados 1:1 del handoff de diseno (colors_and_type.css
     del handoff: --mark-red #EE2D49; pausa #C0871B "ambar derivado", sin token
     propio en el handoff). Referencia visual, no fuente de datos. */
  --amber:#C0871B; --danger:#EE2D49;
}
*{box-sizing:border-box}
body{margin:0;background:var(--cream);color:var(--ink);
  font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif;line-height:1.5}
.wrap{max-width:1200px;margin:0 auto;padding:24px 20px 60px}
header.top{border-bottom:3px solid var(--plum);padding-bottom:14px;margin-bottom:22px}
header.top h1{margin:0;font-size:1.5rem;color:var(--plum)}
header.top .meta{color:var(--muted);font-size:.9rem;margin-top:4px}
/* Lista acordeon de ancho completo: un solo contenedor con borde y divisores
   horizontales entre filas (no cada fila con su propia caja/sombra). */
.lista{border:1px solid var(--line);border-radius:12px;background:var(--card);overflow:hidden}
.fila{border-top:1px solid var(--line)}
.fila:first-child{border-top:none}
.cab{display:flex;align-items:center;gap:12px;width:100%;padding:13px 16px;
  background:none;border:0;margin:0;font:inherit;color:inherit;text-align:left;cursor:pointer}
.cab:hover{background:var(--cream)}
.cab:focus-visible{outline:2px solid var(--ocean);outline-offset:-2px}
.chev{flex:0 0 auto;width:12px;color:var(--muted);font-size:.7rem;line-height:1;transition:transform .15s ease}
.fila.abierta .chev{transform:rotate(90deg)}
.izq{flex:1 1 auto;min-width:0;display:flex;flex-direction:column;gap:1px}
.nombre{font-weight:600;color:var(--plum);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.cat{font-size:.7rem;color:var(--muted);text-transform:uppercase;letter-spacing:.03em}
.der{flex:0 1 auto;max-width:42%;display:flex;flex-direction:column;align-items:flex-end;gap:1px}
.der .slug{font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-size:.7rem;color:var(--muted);
  white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:100%}
.der .tp{font-size:.68rem;font-weight:600;color:var(--ocean);text-transform:uppercase;letter-spacing:.03em;white-space:nowrap}
.der .fecha{font-size:.76rem;color:var(--muted);white-space:nowrap}
/* Indicador de semaforo (Fase 2 PUSH): punto de color puro CSS (sin glifo
   Unicode, para no introducir literales no-ASCII fuera del bloque u8()). */
.der .sem{font-size:.68rem;font-weight:600;color:var(--muted);white-space:nowrap;
  display:inline-flex;align-items:center;gap:5px}
.punto{display:inline-block;width:7px;height:7px;border-radius:999px;flex:0 0 auto}
.punto.sem-activo{background:var(--olive)}
.punto.sem-pausa{background:var(--amber)}
.punto.sem-bloqueado{background:var(--danger)}
.punto.sem-cerrado{background:var(--slate)}
.punto.sem-na{background:var(--line)}
.cuerpo{display:none;padding:2px 16px 16px 40px}
.fila.abierta .cuerpo{display:block}
.cuerpo .tipo{font-size:.72rem;font-weight:600;color:var(--ocean);text-transform:uppercase;letter-spacing:.03em;margin-bottom:6px}
.cuerpo .sint{font-size:.92rem;margin:.5em 0}
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
const ETIQUETA_TP = {bug:"bug",bloqueante:"bloqueante",deuda_heredada:"deuda heredada",
  deuda_tecnica:"deuda tecnica",nuevo:"nuevo",cosmetica:"cosmetica",ninguno:"ninguno"};
const ETIQUETA_SEMAFORO = {activo:"activo",pausa:"pausa",bloqueado:"bloqueado",cerrado:"cerrado"};
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
// Construye una fila del acordeon: cabecera colapsada (clic -> toggle) + cuerpo.
function fila(p){
  const f=el("div","fila");
  const cab=el("button","cab"); cab.type="button";
  cab.appendChild(el("span","chev","▸"));
  const izq=el("div","izq");
  izq.appendChild(el("div","nombre",p.nombre_real||p.slug));
  if(p.categoria) izq.appendChild(el("div","cat",p.categoria));  // categoria como texto sutil; sin placeholder si falta
  cab.appendChild(izq);
  const der=el("div","der");
  der.appendChild(el("div","slug",p.slug));
  // Semaforo (Fase 2 PUSH): punto de color + etiqueta; fallback visual neutro si NA.
  const semDiv=el("div","sem");
  const semCls = p.semaforo ? ("sem-"+p.semaforo) : "sem-na";
  semDiv.appendChild(el("span","punto "+semCls,null));
  semDiv.appendChild(el("span",null, p.semaforo ? (ETIQUETA_SEMAFORO[p.semaforo]||p.semaforo) : "sin dato"));
  der.appendChild(semDiv);
  if(p.tipo_pendiente) der.appendChild(el("div","tp",ETIQUETA_TP[p.tipo_pendiente]||p.tipo_pendiente));
  der.appendChild(el("div","fecha",fechaEs(p.fecha_actualizacion)));
  cab.appendChild(der);
  cab.addEventListener("click",()=>f.classList.toggle("abierta"));
  cab.setAttribute("aria-expanded","false");
  cab.addEventListener("click",()=>cab.setAttribute("aria-expanded",f.classList.contains("abierta")));
  f.appendChild(cab);
  const cuerpo=el("div","cuerpo");
  if(p.tipo) cuerpo.appendChild(el("div","tipo",p.tipo));
  // Sintesis completa: TODOS los parrafos (el acordeon tiene ancho para mostrarlos).
  const parrafos = Array.isArray(p.sintesis)? p.sintesis : (p.objetivo? [String(p.objetivo)] : []);
  parrafos.forEach(t=>cuerpo.appendChild(el("p","sint",t)));
  if(p.proximos_pasos && p.proximos_pasos.length){
    const blk=el("div","blk"); blk.appendChild(el("span","lbl","Próximos pasos"));
    const ul=el("ul"); p.proximos_pasos.forEach(x=>ul.appendChild(el("li",null,x)));
    blk.appendChild(ul); cuerpo.appendChild(blk);
  }
  if(p.tiene_backlog && p.resena_itinerario){
    const blk=el("div","blk"); blk.appendChild(el("span","lbl","Reseña del itinerario"));
    blk.appendChild(el("div",null,p.resena_itinerario)); cuerpo.appendChild(blk);
  }
  f.appendChild(cuerpo);
  return f;
}
function render(){
  const lista=document.getElementById("lista");
  CARTERA.forEach(p=>lista.appendChild(fila(p)));
  // Conteos por estado en el footer.
  const cont={};
  CARTERA.forEach(p=>{const k=p.estado_proyecto||"sin clasificar";cont[k]=(cont[k]||0)+1;});
  const cdiv=document.getElementById("conteos");
  Object.keys(cont).forEach(k=>{cdiv.appendChild(el("span",null,(ETIQUETA_ESTADO[k]||k)+": "+cont[k]));});
  // Conteos por tipo_pendiente (agenda priorizada, P-FASE2-PIEZA-C).
  const contTp={};
  CARTERA.forEach(p=>{const k=p.tipo_pendiente||"sin dato";contTp[k]=(contTp[k]||0)+1;});
  const tpdiv=document.getElementById("conteos-tp");
  Object.keys(contTp).forEach(k=>{tpdiv.appendChild(el("span",null,(ETIQUETA_TP[k]||k)+": "+contTp[k]));});
}
render();
')

html <- paste0(
  "<!DOCTYPE html>\n<html lang=\"es\">\n<head>\n<meta charset=\"utf-8\">\n",
  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n",
  u8("<title>Cartera de proyectos Área de Monitoreo</title>\n"),
  "<style>", css, "</style>\n</head>\n<body>\n<div class=\"wrap\">\n",
  u8("<header class=\"top\">\n<h1>Cartera de proyectos Área de Monitoreo</h1>\n"),
  "<div class=\"meta\">Generado: ", fecha_generacion, u8(" · "), n_total, " proyectos</div>\n</header>\n",
  "<main id=\"lista\" class=\"lista\"></main>\n",
  "<footer class=\"bot\">Total de proyectos: ", n_total,
  "<div class=\"conteos\" id=\"conteos\"></div>",
  u8("<div class=\"conteos\" id=\"conteos-tp\"></div></footer>\n"),
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
et_tp <- function(tp) {
  if (is.na(tp)) return("sin dato")
  c(bug="bug", bloqueante="bloqueante", deuda_heredada="deuda heredada",
    deuda_tecnica="deuda tecnica", nuevo="nuevo", cosmetica="cosmetica",
    ninguno="ninguno")[tp] |> (\(x) if (is.na(x)) tp else x)()
}
# Fase 2 PUSH: semaforo activo|pausa|bloqueado|cerrado; "sin dato" si NA
# (hermano sin ESTADO.md sincronizado). Valores ya son etiquetas legibles.
et_semaforo <- function(s) if (is.na(s)) "sin dato" else s
m_lin <- character(0)
ap <- function(...) m_lin <<- c(m_lin, ...)
ap(sprintf(u8("# Cartera de proyectos Área de Monitoreo")), "",
   sprintf(u8("Generado: %s · %d proyectos"), fecha_generacion, n_total), "",
   u8("> Versión texto del panorama visual (mismo orden y campos que las filas; orden por tipo_pendiente, estado y fecha)."), "")
for (o in objetos) {
  ap(sprintf("## %s", if (is.na(o$nombre_real)) o$slug else o$nombre_real))
  ap(sprintf("- **slug:** `%s`", o$slug))
  if (!is.na(o$tipo)) ap(sprintf("- **tipo:** %s", o$tipo))
  ap(sprintf("- **tipo de pendiente:** %s", et_tp(o$tipo_pendiente)))
  ap(sprintf("- **semaforo:** %s", et_semaforo(o$semaforo)))
  ap(sprintf("- **estado:** %s", et_estado(o$estado_proyecto)))
  ds <- if (is.na(o$datos_sensibles)) "sin clasificar" else o$datos_sensibles
  ap(sprintf("- **datos sensibles:** %s", ds))
  ap(sprintf(u8("- **última actualización:** %s"),
             if (is.na(o$fecha_actualizacion)) "sin traspaso" else o$fecha_actualizacion))
  # .md no interactivo: muestra TODOS los parrafos de sintesis[] como texto corrido
  # (sin toggle ni indicador "+N"; el acordeon del .html cubre la interaccion).
  parrafos_md <- if (is.list(o$sintesis)) unlist(o$sintesis)
                 else if (!is.na(o$objetivo)) o$objetivo else character(0)
  if (length(parrafos_md) > 0)
    ap(sprintf(u8("- **síntesis:** %s"), paste(parrafos_md, collapse = " ")))
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
n_sin_tp <- sum(vapply(objetos, function(o) is.na(o$tipo_pendiente), logical(1)))
n_prioritarios <- sum(vapply(objetos, function(o) {
  !is.na(o$tipo_pendiente) && o$tipo_pendiente %in% c("bug", "bloqueante")
}, logical(1)))
n_con_semaforo <- sum(vapply(objetos, function(o) !is.na(o$semaforo), logical(1)))
for (a in advertencias) log_msg(a, "36_visual", "WARN")
log_msg(sprintf(paste(
  "panorama_visual.html/.md generados: %d proyectos, %d con backlog,",
  "%d sin estado_proyecto, %d sin tipo_pendiente, %d bug/bloqueante en cabeza,",
  "%d con semaforo (Fase 2 PUSH)."),
                n_total, n_backlog, n_sin_estado, n_sin_tp, n_prioritarios,
                n_con_semaforo), "36_visual")
