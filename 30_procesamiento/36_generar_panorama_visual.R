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
#             sincronizacion YA computada por resolver_estado() (32, que compara
#             sesion_actual contra el vNN del traspaso) via `lista_documentos`;
#             (run_all(only=6), sin ese objeto en sesion) cae a una relectura
#             autocontenida que reusa el MISMO parser/formula (ver
#             leer_estado_hermano()). Deteccion de desync/tipo_pendiente NO se
#             reimplementa de forma independiente (evita divergencia).
# Insumos   : 40_salidas/inventario_cartera.json (34); 40_salidas/registro_proyectos.csv;
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
# El sitio del hermano se sirve desde docs/ desde su commit 00a1af3 ("chore(pages):
# mueve el sitio a docs/ y deja de servir la raiz"); antes colgaba de la raiz.
RUTA_DATA_JS_PORTAFOLIO <- file.path(RAIZ_PROYECTOS, "slep_monitoreo", "docs", "data.js")

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

# Mapeo id (llave estable de data.js) -> slug del hermano. Se clava por `id` y NO
# por `orden`: el propio origen declara `id` como "llave estable y unica... NO se
# cambia una vez publicado" y `orden` como numero que "se renumera al insertar
# proyectos". Y ya se renumero: el origen inserto un proyecto en la posicion 3 y
# corrio en +1 todo lo posterior, de modo que el mapeo por orden asignaba a cada
# ficha el contenido editorial de su vecino (salida verde y equivocada, A25).
# Los 11 pares heredados del mapeo por orden (aprobados por el titular) se
# conservan intactos: cada uno se reclavo por el titulo literal con que fue
# aprobado, que es el comentario inline de su linea.
# NA = entrada editorial del sitio sin hermano en la cartera. Es una declaracion
# explicita, no una omision: un `id` que NO figure en esta tabla aborta el paso.
MAPEO_ID_SLUG <- c(
  asistencia    = "slep_minuta_asistencia",                     # "Minuta de asistencia mensual"
  resguardo     = "slep_reportes_modelo_resguardo_asistencia",  # "Reportes del Modelo de Resguardo de la Asistencia Educativa del Territorio"
  simce         = NA_character_,                                # "Minutas de resultados Simce 2025 del territorio" (proyecto nuevo del sitio, sin repo hermano; pendiente de curacion del titular)
  estandares    = "slep_simce_adecuado",                        # "Motor de comparacion interactivo de los resultados de los estandares de aprendizaje medidos por las pruebas Simce"
  idps          = "slep_idps",                                  # "Motor de comparacion interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS)"
  categorias    = "slep_categoria_desempeno",                   # "Motor de comparacion interactivo de la Categoria de Desempeno de los establecimientos educacionales del pais"
  parvularia    = "slep_aprendizajes_ep",                       # "Monitoreo de aprendizajes en la educacion parvularia"
  inicial       = "slep_seguimiento_educacion_inicial",         # "Analisis longitudinal de preferencias de matricula de egresados de jardines infantiles"
  costapresente = "slep_costapresente",                         # "CostaPresente"
  ael           = "slep_alertas_ael",                           # "Sistema de alertas de Anotate en la Lista"
  trayectorias  = "slep_minuta_desvinculacion",                 # "Analisis de trayectorias educativas interrumpidas"
  rendimiento   = "slep_rendimiento_historico"                  # "Diagnostico historico del rendimiento escolar"
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

#' Copia de `txt` con el INTERIOR de cada string literal reemplazado por un
#' caracter neutro, conservando la longitud (y por lo tanto todas las
#' posiciones). Es lo que permite buscar llaves y claves sin que el contenido de
#' los strings confunda la busqueda: los parrafos de `sintesis` ya traen dos
#' puntos en la prosa, y nada impide que traigan una llave o una comilla
#' escapada.
enmascarar_strings <- function(txt) {
  m <- gregexpr('"(?:[^"\\\\]|\\\\.)*"', txt, perl = TRUE)[[1]]
  if (m[1] == -1L) return(txt)
  ch <- strsplit(txt, "", fixed = TRUE)[[1]]
  largos <- attr(m, "match.length")
  for (k in seq_along(m)) {
    if (largos[k] > 2L) ch[(m[k] + 1L):(m[k] + largos[k] - 2L)] <- "\a"
  }
  paste(ch, collapse = "")
}

#' Quotea las claves de UN objeto. Recibe el objeto y su version enmascarada:
#' busca sobre la enmascarada (donde no hay contenido de strings que confundir)
#' y reescribe sobre la original, de atras hacia adelante para no correr las
#' posiciones que quedan por procesar. A diferencia del quoteo por linea que
#' reemplaza, no exige que la clave abra la linea: `{ icono: "x" }` tambien cae.
sanear_claves <- function(obj, obj_mask) {
  m <- gregexpr("(?<![A-Za-z0-9_])[A-Za-z_][A-Za-z0-9_]*(?=\\s*:)", obj_mask, perl = TRUE)[[1]]
  if (m[1] == -1L) return(obj)
  largos <- attr(m, "match.length")
  for (k in rev(seq_along(m))) {
    obj <- paste0(substr(obj, 1L, m[k] - 1L),
                  '"', substr(obj, m[k], m[k] + largos[k] - 1L), '"',
                  substr(obj, m[k] + largos[k], nchar(obj)))
  }
  obj
}

#' Objetos top-level del arreglo, con sus claves ya entre comillas. Cuenta
#' profundidad de llaves sobre el texto enmascarado, de modo que tolera objetos
#' anidados -`valor: [{icono, texto}]`, que el catalogo del origen ya propone- y
#' llaves dentro de strings. Reemplaza al split por `\{[^{}]*\}`, que asumia
#' objetos planos y partia la entrada en pedazos en cuanto habia uno anidado.
#' character(0) si las llaves no cierran: donde termina un objeto no se adivina.
objetos_saneados <- function(arr) {
  mask <- enmascarar_strings(arr)
  pos <- gregexpr("[{}]", mask)[[1]]
  if (pos[1] == -1L) return(character(0))
  prof <- 0L
  ini <- NA_integer_
  res <- character(0)
  for (p in pos) {
    if (substr(mask, p, p) == "{") {
      if (prof == 0L) ini <- p
      prof <- prof + 1L
    } else {
      prof <- prof - 1L
      if (prof < 0L) return(character(0))
      if (prof == 0L) res <- c(res, sanear_claves(substr(arr, ini, p), substr(mask, ini, p)))
    }
  }
  if (prof != 0L) character(0) else res
}

#' Parsea el arreglo PROYECTOS de un data.js del portafolio. El formato es JS de
#' uso interno (claves sin comillas, valores con comillas dobles consistentes,
#' sin trailing commas, sin funciones, comentarios fuera de los objetos): se
#' sanean las claves y se delega en jsonlite, mas robusto para el array
#' multilinea sintesis[] que una regex por campo. tryCatch POR OBJETO: una
#' entrada malformada se omite con advertencia sin abortar el resto (patron
#' tolerante).
#' Devuelve lista nombrada por `id` (la llave estable que declara el origen), o
#' NULL si el archivo no existe / no hay arreglo / ninguna entrada parsea
#' (degradacion con gracia). Aborta si una entrada parsea pero no trae `id`:
#' sin llave no hay forma de asignarla a un hermano que no sea adivinar.
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
  objs <- objetos_saneados(arr)
  if (length(objs) == 0) {
    log_msg("data.js: el arreglo PROYECTOS no arrojo objetos top-level (llaves sin cerrar); se omiten campos editoriales.",
            "36_visual", "WARN")
    return(NULL)
  }
  res <- list()
  for (o in objs) {
    obj <- tryCatch(jsonlite::fromJSON(o, simplifyVector = FALSE), error = function(e) {
      log_msg(sprintf("data.js: entrada no parseable, se omite (%s).", conditionMessage(e)),
              "36_visual", "WARN")
      NULL
    })
    if (!is.null(obj)) {
      if (is.null(obj$id)) {
        stop(sprintf(paste0(
          "36: data.js trae una entrada sin campo `id` (titulo: \"%s\"). `id` es ",
          "la llave del mapeo id->slug: sin ella la entrada solo podria asignarse ",
          "adivinando por posicion, que es justo lo que este mapeo evita."),
          o_null(unlist(obj$titulo))))
      }
      res[[as.character(obj$id)]] <- obj
    }
  }
  if (length(res) == 0) NULL else res
}

#' Fase 1+2 (PUSH de ESTADO.md, con fallback a PULL): resuelve semaforo,
#' tipo_pendiente crudo y "Proximo paso" de un hermano.
#'
#' Camino primario: si `lista_documentos` existe EN SESION (36 corrio como
#' parte de un run_all() completo, tras el paso 32), reusa integramente la
#' decision de sincronizacion ya computada por resolver_estado() -incluido su
#' veredicto de tres estados- sin releer ni reinterpretar nada.
#' Evita una segunda implementacion de la regla de desync que podria divergir
#' de la de 32 (la duplicacion previa, B-14-03, divergia en tres puntos que
#' nadie media: ver cargar_reglas_sincronia()).
#'
# ---- Fuente unica del veredicto de sincronia (B-14-03) -----------------------
# La deteccion de desync vive SOLO en 32_localizar_documentos.R. Este paso la
# CARGA y la LLAMA; no la reimplementa. Antes habia aqui una segunda copia de la
# formula. El booleano era identico (verificado por barrido exhaustivo sobre
# ua x mt x margen: 0 divergencias), pero el payload adjunto divergia en tres
# puntos que nadie media:
#   1. extraia "Proximo paso" con bloque_seccion() (laxo: cualquier nivel,
#      insensible a mayusculas, por subcadena) en vez de seccion_md() (estricto:
#      "## Proximo paso" exacto). Divergencia LATENTE: los 23 ESTADO.md de la
#      cartera usan hoy la forma exacta, asi que ninguna regresion la habria visto.
#   2. tomaba el mtime del traspaso desde inventario_cartera.json (foto en disco)
#      en vez de resolver el traspaso EN VIVO: con el inventario atrasado, los dos
#      caminos podian dar veredictos opuestos para el mismo ESTADO.md.
#   3. rehardcodeaba la ruta de ESTADO.md en vez de usar SUBRUTA_ESTADO.
# Unificar cierra las tres. Se conserva la semantica de 32, la mas estricta.
cargar_reglas_sincronia <- function() {
  if (exists("resolver_estado", inherits = TRUE) &&
      exists("resolver_traspaso", inherits = TRUE)) return(invisible(FALSE))
  ruta32 <- file.path(RAIZ_ORQUESTADOR, "30_procesamiento", "32_localizar_documentos.R")
  L32 <- readLines(ruta32, warn = FALSE, encoding = "UTF-8")
  corte <- grep("^# ---- Flujo principal", L32)
  if (length(corte) != 1L) {
    stop("36: no se pudo aislar el bloque de funciones de 32 (centinela ",
         "'# ---- Flujo principal' ausente o repetido).")
  }
  eval(parse(text = paste(L32[seq_len(corte - 1L)], collapse = "\n")), envir = globalenv())
  invisible(TRUE)
}
cargar_reglas_sincronia()

#' Camino de respaldo (standalone, ej. run_all(only=6) sin haber corrido el
#' paso 32 en esta sesion): LLAMA a resolver_traspaso() + resolver_estado() de
#' 32_localizar_documentos.R, cargadas por cargar_reglas_sincronia(). No hay
#' segunda formula: hay una sola regla y dos formas de llegar a ella.
#'
#' Degradacion con gracia (mismo idioma que parsear_data_js): sin ESTADO.md o
#' front matter no reconocible -> semaforo=NA y proximo_paso=NA. Solo un
#' veredicto "desincronizado" APAGA los campos; "indeterminado" los conserva
#' (B-14-01). tipo_pendiente crudo se devuelve SIEMPRE que exista el campo (no
#' gateado por sync: el inventario/34 ya lo trata asi; se usa solo para el
#' chequeo cruzado de auditoria, no para decidir nada operativo aqui).
#'
#' @return list(semaforo, proximo_paso, tipo_pendiente_raw, sincronizado, presente)
leer_estado_hermano <- function(slug) {
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
    # B-14-01: APAGAR un campo exige la afirmacion negativa explicita, no la
    # ausencia de la afirmacion positiva. Un veredicto "indeterminado" (no se
    # pudo medir la sincronia) conserva los campos; solo "desincronizado" los
    # apaga. Antes se gateaba por isTRUE(sincronizado), que trataba el dato
    # ausente como dato negativo.
    apaga <- identical(est$veredicto, "desincronizado")
    return(list(
      semaforo = if (!apaga && !is.null(sem) && nzchar(sem)) sem else NA_character_,
      proximo_paso = if (!apaga && !is.null(est$proximo) && !is.na(est$proximo)) est$proximo else NA_character_,
      tipo_pendiente_raw = if (is.null(tp) || is.na(tp) || !nzchar(tp)) NA_character_ else tp,
      sincronizado = isTRUE(est$sincronizado),
      presente = isTRUE(est$presente)
    ))
  }

  # ---- Fallback standalone: la MISMA regla, resuelta en vivo -----------------
  dir_hno <- file.path(RAIZ_PROYECTOS, slug)
  tr  <- resolver_traspaso(dir_hno)
  est <- resolver_estado(dir_hno, tr)
  if (!isTRUE(est$presente)) return(vacio)

  sem <- est$meta$semaforo
  tp  <- est$tipo_pendiente
  apaga <- identical(est$veredicto, "desincronizado")
  list(
    semaforo = if (!apaga && !is.null(sem) && nzchar(sem)) sem else NA_character_,
    proximo_paso = if (!apaga && !is.null(est$proximo) && !is.na(est$proximo)) est$proximo else NA_character_,
    tipo_pendiente_raw = if (is.null(tp) || is.na(tp) || !nzchar(tp)) NA_character_ else tp,
    sincronizado = isTRUE(est$sincronizado),
    presente = TRUE
  )
}

# ---- FASE 1: construir el objeto por proyecto --------------------------------

if (!file.exists(RUTA_INVENTARIO_JSON)) {
  stop("36: falta inventario_cartera.json. Ejecute primero los pasos 31-34.")
}
log_msg("Construyendo objetos de cartera para el panorama visual...", "36_visual")

inv <- jsonlite::read_json(RUTA_INVENTARIO_JSON, simplifyVector = FALSE)
if (!file.exists(RUTA_REGISTRO)) {
  stop("36: falta 40_salidas/registro_proyectos.csv. Lo escribe el paso 1: ejecute run_all(only = 1) y reintente.")
}
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
# Reindexado id -> slug segun el mapeo declarado (llave estable de data.js).
# Guarda dura: un `id` que no figure en MAPEO_ID_SLUG, o un slug reclamado por
# dos entradas, ABORTA nombrando la entrada. Degradar a silencio es exactamente
# como se produce el cruce editorial (la sintesis de un proyecto en la ficha de
# otro), que es peor que un campo nulo porque no se ve.
datos_por_slug <- list()
if (!is.null(datos_data_js)) {
  for (id_dj in names(datos_data_js)) {
    if (!(id_dj %in% names(MAPEO_ID_SLUG))) {
      stop(sprintf(paste0(
        "36: data.js trae la entrada id='%s' (\"%s\") que no figura en MAPEO_ID_SLUG. ",
        "Declare su pareja en 30_procesamiento/36_generar_panorama_visual.R (slug del ",
        "hermano, o NA si el sitio publica un proyecto sin repo en la cartera) y reintente."),
        id_dj, o_null(unlist(datos_data_js[[id_dj]]$titulo))))
    }
    slug_dj <- MAPEO_ID_SLUG[[id_dj]]
    if (is.na(slug_dj)) {
      advertencias <- c(advertencias, sprintf(
        "data.js: la entrada id='%s' esta declarada sin hermano en la cartera; sus campos editoriales no se usan.",
        id_dj))
      next
    }
    if (!is.null(datos_por_slug[[slug_dj]])) {
      stop(sprintf(paste0(
        "36: el slug '%s' es reclamado por dos entradas de data.js (la segunda es id='%s'). ",
        "MAPEO_ID_SLUG tiene que ser inyectivo: dos entradas en la misma ficha se pisan."),
        slug_dj, id_dj))
    }
    datos_por_slug[[slug_dj]] <- datos_data_js[[id_dj]]
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
  lapply(inv$proyectos, function(p) leer_estado_hermano(p$slug)),
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
    # T2: el campo se llama `maneja_sensibles` en origen (front matter de los
    # ESTADO.md y campo del inventario, 34:73). El nombre viejo `datos_sensibles`
    # solo existia como columna del registro curado, poblada en 1 de 25 filas.
    # Se corrige el NOMBRE y el ORIGEN; el contenido no se cura (invariante).
    maneja_sensibles = o_null(p$maneja_sensibles),
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

# ---- Guarda de asimetria entre el panorama y la cartera en disco -------------
# Hasta ahora las dos asimetrias eran MUDAS: una ficha sin repositorio y un
# repositorio sin ficha se veian igual que todo lo demas. Ahora cada una emite un
# error NOMBRADO que dice el slug y el lado que falta.
#
# Advierte y NO aborta, con el mismo criterio de la guarda del mapeo de data.js
# (arriba): esa distingue "no lo encontre" de "declare que no existe", y aborta
# solo en el segundo caso. `simce` existe en el sitio y no en la cartera, y
# abortar por el dejaria el paso inejecutable por un dato verdadero. Aqui vale lo
# mismo: una asimetria es un hecho del mundo, no una contradiccion del codigo,
# SALVO que el slug este declarado en MAPEO_ID_SLUG, donde si contradice una
# declaracion explicita del propio repositorio.
verificar_asimetria_cartera <- function(slugs_ficha) {
  dirs <- basename(Sys.glob(file.path(RAIZ_PROYECTOS, paste0(PREFIJO_UNIVERSO, "*"))))
  dirs <- dirs[!grepl(PATRON_EXCLUIR_UNIVERSO, dirs, perl = TRUE)]
  dirs <- setdiff(dirs, SLUG_ORQUESTADOR)

  sin_directorio <- setdiff(slugs_ficha, dirs)
  sin_ficha      <- setdiff(dirs, slugs_ficha)
  declarados     <- if (exists("MAPEO_ID_SLUG")) unname(MAPEO_ID_SLUG) else character(0)

  for (s in sort(sin_directorio)) {
    log_msg(sprintf(
      "asimetria: la ficha '%s' no tiene directorio en la cartera (falta el lado del repositorio).",
      s), "36_visual", "WARN")
    if (s %in% declarados) {
      stop(sprintf(paste0(
        "36: el slug '%s' esta declarado en MAPEO_ID_SLUG pero no existe como ",
        "directorio en la cartera. Una declaracion explicita que no se cumple no ",
        "es un dato del mundo: es una contradiccion del repositorio."), s))
    }
  }
  for (s in sort(sin_ficha)) {
    tiene_estado <- file.exists(file.path(RAIZ_PROYECTOS, s, SUBRUTA_ESTADO))
    log_msg(sprintf(
      "asimetria: el directorio '%s'%s no tiene ficha en el panorama (falta el lado de data.js/registro).",
      s, if (tiene_estado) " (CON ESTADO.md)" else " (sin ESTADO.md)"),
      "36_visual", "WARN")
  }
  n <- length(sin_directorio) + length(sin_ficha)
  log_msg(sprintf(
    "asimetrias cartera<->panorama: %d (%d fichas sin directorio, %d directorios sin ficha); %d slugs calzan en ambos lados.",
    n, length(sin_directorio), length(sin_ficha), length(intersect(slugs_ficha, dirs))),
    "36_visual", if (n > 0L) "WARN" else "INFO")
  invisible(list(sin_directorio = sin_directorio, sin_ficha = sin_ficha,
                 calzan = intersect(slugs_ficha, dirs)))
}
asimetrias <- verificar_asimetria_cartera(vapply(objetos, function(o) o$slug, character(1)))

# ---- Contradiccion entre el registro curado y el origen real ----------------
# Al corregir el NOMBRE del campo cambio tambien su ORIGEN: antes venia de la
# columna `datos_sensibles` del registro curado a mano (poblada en 1 de 25
# filas), ahora de `maneja_sensibles` del inventario (34:73), derivado de la
# presencia de gobernanza_datos.md en el hermano. Donde ambas fuentes existen y
# discrepan, el panorama muestra el origen real y lo ADVIERTE con nombre: curar
# cual de las dos tiene razon es decision del titular, no de este paso (invariante).
advertir_contradiccion_sensibles <- function(objetos, registro) {
  n <- 0L
  for (o in objetos) {
    fila <- registro[registro$slug == o$slug, , drop = FALSE]
    if (nrow(fila) != 1L) next
    curado <- o_null(fila$datos_sensibles)
    if (is.na(curado) || !nzchar(as.character(curado))) next
    real <- o$maneja_sensibles
    if (is.null(real) || is.na(real)) next
    if (!identical(toupper(as.character(curado)), toupper(as.character(real)))) {
      n <- n + 1L
      log_msg(sprintf(paste0(
        "sensibilidad [%s]: el registro curado dice datos_sensibles=%s y el origen ",
        "real dice maneja_sensibles=%s (derivado de gobernanza_datos.md). Se muestra ",
        "el origen real; la curacion del registro es decision del titular."),
        o$slug, curado, real), "36_visual", "WARN")
    }
  }
  log_msg(sprintf("contradicciones registro<->origen en sensibilidad: %d.", n),
          "36_visual", if (n > 0L) "WARN" else "INFO")
  invisible(n)
}
invisible(advertir_contradiccion_sensibles(objetos, registro))

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
# Acceso por [ ] y no por [[ ]]: sobre un vector atomico con nombres, `[[` con
# un nombre inexistente ABORTA ("subscript out of bounds"); solo `[` devuelve NA.
# El fallback escrito con is.null() era inalcanzable y un hermano que declarara
# un tipo_pendiente fuera del enum de SETTINGS SS1.2.4 tumbaba el paso 6 entero.
rango_tp_de <- function(tp) {
  if (is.na(tp)) return(length(RANGO_TIPO_PENDIENTE))  # sin dato -> ultimo, junto a "ninguno"
  r <- unname(RANGO_TIPO_PENDIENTE[as.character(tp)])
  if (is.na(r)) length(RANGO_TIPO_PENDIENTE) else r    # fuera del enum -> ultimo
}
rango_de <- function(estado) {
  if (is.na(estado)) return(0L)                 # null -> primero (como inicial)
  r <- unname(RANGO_ESTADO[as.character(estado)])
  if (is.na(r)) 0L else r                       # fuera del enum -> primero
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

# Fecha del sello con zona explicita, por el mismo motivo que hora_generacion:
# Sys.Date() usa la zona del proceso, que bajo locale C puede no ser la del
# titular. D-24-D.
fecha_generacion <- format(Sys.time(), "%Y-%m-%d",
                           tz = if (exists("TZ_ORQUESTADOR")) TZ_ORQUESTADOR else "")
# Hora de generacion (resto del patron del handoff, s10: "Sintesis generada a
# las {hora}"). Reusa TZ_ORQUESTADOR (10_configuracion.R, ya establecido para
# evitar el bug de zona horaria de sesiones previas) en vez de una formula
# de hora nueva sin tz explicita.
hora_generacion <- format(Sys.time(), "%H:%M",
                          tz = if (exists("TZ_ORQUESTADOR")) TZ_ORQUESTADOR else "")
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
  /* P-DESIGN-PANORAMA-ADOPCION (resto del patron, s10): 3 tokens nuevos,
     tomados 1:1 de assets/colors_and_type.css del handoff (valores reales, no
     inventados): --line-strong (borde de la card contenedora), --shadow-3
     (sombra de la card), --ocean-20 (fondo del tag de categoria en la fila
     expandida). Referencia visual, no fuente de datos. */
  --line-strong:#C8BDA0; --shadow-3:0 8px 24px rgba(74,39,70,.12); --ocean-20:#D4E4F1;
}
*{box-sizing:border-box}
body{margin:0;background:var(--cream);color:var(--ink);
  font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif;line-height:1.5}
.wrap{max-width:1200px;margin:0 auto;padding:24px 20px 60px}
/* Card contenedora (resto del patron del handoff, s10): todo el contenido
   (header + kpis + atencion + filtros + lista + footer) vive dentro de una
   sola card con borde/sombra/radio, y el header pasa a banda de color ocean
   (jerarquia: titulo, "Area de Monitoreo - fecha", hora de generacion). */
.card{background:var(--card);border:1px solid var(--line-strong);border-radius:12px;
  overflow:hidden;box-shadow:var(--shadow-3)}
.card-header{background:var(--ocean);color:var(--cream);padding:16px 24px}
.card-header h1{margin:0;font-size:1.06rem;font-weight:700;color:var(--cream)}
.card-header .meta{font-size:.78rem;color:rgba(255,246,224,.75);margin-top:3px}
.card-header .meta-hora{font-size:.7rem;color:rgba(255,246,224,.55);margin-top:2px}
.card-body{padding:22px 24px 28px}
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
.der .fecha{font-size:.76rem;color:var(--muted);
  white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:100%}
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
/* P-DESIGN-PANORAMA-ADOPCION: KPIs, banda de atencion y filtros. Reusan
   integramente los tokens de :root ya existentes (--plum/--olive/--amber/
   --danger/--slate/--ocean/--line/--cream/--card/--muted/--ink-2); no se
   introduce ningun hex nuevo ni color derivado (color-mix/rgba), porque
   ninguno de estos bloques necesita un tono que no exista ya. */
.kpis{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;margin-bottom:18px}
@media(max-width:640px){.kpis{grid-template-columns:repeat(3,1fr)}}
@media(max-width:420px){.kpis{grid-template-columns:repeat(1,1fr)}}
.kpi{background:var(--card);border:1px solid var(--line);border-radius:10px;
  padding:12px 10px;text-align:center}
/* Tipografia (resto del patron, s10, Fase 2): --font-display/--font-body del
   handoff son binarios custom (gobCL/Museo Sans, .otf en assets/fonts/) NO
   versionados en este pipeline de datos; importarlos violaria autocontencion
   (invariante 4). Se mantiene la pila de sistema para texto/cuerpo (ya
   equivalente al propio fallback no-custom de --font-body). Unica excepcion:
   el numero KPI, unico elemento del widget real que usa --font-display
   (font:900 34px var(--font-display) en el handoff) -> se aproxima con el
   PRIMER fallback no-custom declarado ahi mismo ("Arial Black"), sin
   descargar ni versionar ningun binario. */
.kpi-num{font-family:"Arial Black",system-ui,-apple-system,sans-serif;
  font-size:1.6rem;font-weight:900;color:var(--plum);line-height:1}
.kpi-lbl{font-size:.72rem;color:var(--muted);text-transform:uppercase;
  letter-spacing:.03em;margin-top:4px}
.kpi-activo .kpi-num{color:var(--olive)}
.kpi-pausa .kpi-num{color:var(--amber)}
.kpi-bloqueado .kpi-num{color:var(--danger)}
.kpi-cerrado .kpi-num{color:var(--slate)}
.kpi-na .kpi-num{color:var(--muted)}

.atencion{margin-bottom:18px}
.atn-eyebrow{font-size:.78rem;font-weight:700;text-transform:uppercase;
  letter-spacing:.04em;color:var(--muted);margin-bottom:8px}
.atn-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:10px}
/* Borde de acento = color del semaforo PROPIO de cada item (no un rojo fijo);
   sigue el patron del handoff de referencia, reutilizando tokens existentes. */
.atn-card{display:block;background:var(--card);border:1px solid var(--line);
  border-left:4px solid var(--line);border-radius:8px;padding:10px 12px;
  text-decoration:none;color:inherit}
.atn-card.sem-activo{border-left-color:var(--olive)}
.atn-card.sem-pausa{border-left-color:var(--amber)}
.atn-card.sem-bloqueado{border-left-color:var(--danger)}
.atn-card.sem-cerrado{border-left-color:var(--slate)}
.atn-card:hover{background:var(--cream)}
.atn-card:focus-visible{outline:2px solid var(--ocean);outline-offset:-2px}
.atn-nombre{font-weight:600;color:var(--plum);font-size:.9rem;white-space:nowrap;
  overflow:hidden;text-overflow:ellipsis}
.atn-meta{display:flex;align-items:center;gap:6px;margin-top:4px;font-size:.74rem;color:var(--muted)}

.filtros{margin-bottom:14px;display:flex;flex-direction:column;gap:10px}
.filtro-grupo{display:flex;flex-wrap:wrap;align-items:center;gap:8px}
@media(max-width:420px){.filtro-grupo{flex-direction:column;align-items:flex-start}}
.filtro-titulo{font-size:.72rem;font-weight:700;text-transform:uppercase;
  letter-spacing:.03em;color:var(--muted);flex:0 0 auto;min-width:80px}
.filtro-chips{display:flex;flex-wrap:wrap;gap:6px}
.chip{font:inherit;font-size:.78rem;padding:5px 12px;border-radius:999px;
  border:1px solid var(--line);background:var(--card);color:var(--ink-2);
  cursor:pointer;min-height:30px}
.chip:hover{background:var(--cream)}
.chip:focus-visible{outline:2px solid var(--ocean);outline-offset:-2px}
.chip.chip-activo{background:var(--ocean);color:#fff;border-color:var(--ocean)}
/* Resto del patron, s10, Fase 3: menu desplegable en movil. Reusa el MISMO
   .filtro-chips ya creado por JS (sin duplicar la logica de construccion de
   chips): en <=640px (breakpoint YA existente, usado por .kpis) el titulo en
   linea se oculta, aparece un boton de 2 lineas por grupo, y .filtro-chips se
   convierte en un panel desplegable que solo se muestra si el grupo tiene la
   clase .menu-abierto (toggle por JS al pulsar el boton). En >640px, sin
   cambios de comportamiento (los chips siguen siempre visibles en linea). */
.filtro-boton-movil{display:none}
@media(max-width:640px){
  .filtro-grupo{position:relative}
  .filtro-titulo{display:none}
  .filtro-boton-movil{display:flex;flex-direction:column;align-items:center;
    justify-content:center;text-align:center;width:100%;min-height:52px;
    border-radius:8px;border:1px solid var(--line);background:var(--card);
    color:var(--ink-2);cursor:pointer;padding:6px 8px;font:inherit}
  .filtro-boton-movil .linea1{font-size:.68rem;font-weight:600;text-transform:uppercase;
    letter-spacing:.03em;line-height:1.3}
  .filtro-boton-movil .linea2{font-size:.82rem;font-weight:700;line-height:1.3}
  .filtro-boton-movil.boton-activo{background:var(--ocean);border-color:var(--ocean);color:#fff}
  .filtro-chips{display:none;position:absolute;top:calc(100% + 6px);left:0;right:0;
    z-index:30;flex-direction:column;gap:0;background:var(--card);
    border:1px solid var(--line-strong);border-radius:8px;box-shadow:var(--shadow-3);
    padding:4px;max-height:60vh;overflow-y:auto}
  .filtro-grupo.menu-abierto .filtro-chips{display:flex}
  .filtro-chips .chip{width:100%;text-align:center;border-radius:6px;border:0;
    border-bottom:1px solid var(--line);min-height:44px}
  .filtro-chips .chip:last-child{border-bottom:0}
}
.fila.oculta{display:none}
.cuerpo{display:none;padding:2px 16px 16px 40px}
.fila.abierta .cuerpo{display:block}
/* Resto del patron, s10, Fase 4: tag de categoria (categoriaLabel del
   handoff), 1:1 su misma clasificacion binaria (activo -> pipeline
   analitico; auxiliar -> insumo del portafolio). --ocean-20 tomado del
   handoff (ver :root). */
.tag-categoria{display:inline-block;font-size:.66rem;font-weight:600;
  color:var(--ocean);background:var(--ocean-20);padding:2px 8px;
  border-radius:4px;margin-bottom:8px}
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
// Resto del patron, s10, Fase 4: categoriaLabel del handoff (mapeo binario
// activo/auxiliar, 1:1; nuestro campo "categoria" solo toma esos 2 valores).
const CATEGORIA_LABEL = {activo:"Pipeline analítico", auxiliar:"Auxiliar · insumo del portafolio"};
const SEMAFOROS = ["activo","pausa","bloqueado","cerrado"];
const TIPOS_PENDIENTE = ["bug","bloqueante","deuda_heredada","deuda_tecnica","nuevo","cosmetica","ninguno"];
// slug -> elemento .fila (llenado en render()); evita re-consultar el DOM al
// filtrar/hacer scroll desde la banda de atencion (P-DESIGN-PANORAMA-ADOPCION).
const FILAS_POR_SLUG = {};
// Estado de filtro (Fase 3): sets vacios = ese grupo no filtra (muestra todos).
// No persiste entre cargas (HTML estatico via GitHub Pages, sin sesion que
// valga la pena recordar).
const FILTRO = { semaforo: new Set(), tp: new Set() };
function bucketSemaforo(p){ return (p.semaforo && SEMAFOROS.includes(p.semaforo)) ? p.semaforo : "na"; }
function bucketTp(p){ return (p.tipo_pendiente && TIPOS_PENDIENTE.includes(p.tipo_pendiente)) ? p.tipo_pendiente : "na"; }
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
  f.id="fila-"+p.slug;  // ancla para el scroll+expand desde la banda de atencion
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
  if(p.categoria) cuerpo.appendChild(el("span","tag-categoria",CATEGORIA_LABEL[p.categoria]||p.categoria));
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
// ---- Fase 2: KPIs por semaforo (fijos, resumen de TODA la cartera) --------
function renderKPIs(cartera){
  const div=document.getElementById("kpis");
  if(!div) return;
  const ETQ={activo:"activo",pausa:"pausa",bloqueado:"bloqueado",cerrado:"cerrado",na:"sin dato"};
  const cont={activo:0,pausa:0,bloqueado:0,cerrado:0,na:0};
  cartera.forEach(p=>{ cont[bucketSemaforo(p)]++; });
  ["activo","pausa","bloqueado","cerrado","na"].forEach(k=>{
    const item=el("div","kpi kpi-"+k);
    item.appendChild(el("div","kpi-num",String(cont[k])));
    item.appendChild(el("div","kpi-lbl",ETQ[k]));
    div.appendChild(item);
  });
}

// ---- Fase 1: banda "Requieren atencion hoy" -------------------------------
// Criterio (dato, no UX): tipo_pendiente en {bug, bloqueante}. Omite el
// bloque COMPLETO si no hay ninguno (nunca banda vacia). Fija: no se filtra.
function renderAtencion(cartera){
  const div=document.getElementById("atencion");
  if(!div) return;
  const items=cartera.filter(p=>p.tipo_pendiente==="bug"||p.tipo_pendiente==="bloqueante");
  if(items.length===0) return;
  div.appendChild(el("div","atn-eyebrow","Requieren atención hoy ("+items.length+")"));
  const grid=el("div","atn-grid");
  items.forEach(p=>{
    const card=el("a","atn-card sem-"+bucketSemaforo(p));
    card.href="#fila-"+p.slug;
    card.addEventListener("click",e=>{
      e.preventDefault();
      const f=FILAS_POR_SLUG[p.slug];
      if(f){ f.classList.add("abierta"); f.scrollIntoView({behavior:"smooth",block:"center"}); }
    });
    card.appendChild(el("div","atn-nombre",p.nombre_real||p.slug));
    const meta=el("div","atn-meta");
    meta.appendChild(el("span","punto sem-"+bucketSemaforo(p),null));
    meta.appendChild(el("span",null,(ETIQUETA_TP[p.tipo_pendiente]||p.tipo_pendiente)));
    card.appendChild(meta);
    grid.appendChild(card);
  });
  div.appendChild(grid);
}

// ---- Fase 3: filtros (client-side, AND entre grupos) ----------------------
function renderFiltros(cartera){
  const div=document.getElementById("filtros");
  if(!div) return;
  const ETQ_SEM={activo:"activo",pausa:"pausa",bloqueado:"bloqueado",cerrado:"cerrado",na:"sin dato"};
  const ETQ_TP={bug:"bug",bloqueante:"bloqueante",deuda_heredada:"deuda heredada",
    deuda_tecnica:"deuda tecnica",nuevo:"nuevo",cosmetica:"cosmetica",ninguno:"ninguno",na:"sin dato"};

  // Resto del patron, s10, Fase 3: boton movil por grupo (<=640px) que
  // despliega el MISMO .filtro-chips como panel (ver CSS .menu-abierto). A
  // diferencia del handoff (single-select, el menu se auto-cierra al elegir),
  // nuestros filtros son multi-select (Sets, AND entre grupos, ya establecido
  // en s9) -> el menu NO se auto-cierra al tocar una opcion (permite marcar
  // varias); solo el boton abre/cierra. Decision de diseno no cubierta
  // explicitamente en el encargo, documentada aqui y en el log (Fase 3).
  function grupo(titulo,valores,etiquetas,filtroSet){
    const g=el("div","filtro-grupo");
    g.appendChild(el("div","filtro-titulo",titulo));

    const boton=el("button","filtro-boton-movil"); boton.type="button";
    const linea1=el("span","linea1",titulo);
    const linea2=el("span","linea2","Todos");
    boton.appendChild(linea1); boton.appendChild(linea2);
    function actualizarBoton(){
      const n=filtroSet.size;
      linea2.textContent = n===0 ? "Todos" : n===1 ? (etiquetas[[...filtroSet][0]]||[...filtroSet][0]) : (n+" seleccionados");
      boton.classList.toggle("boton-activo", n>0);
    }
    boton.addEventListener("click",()=>g.classList.toggle("menu-abierto"));
    g.appendChild(boton);

    const chips=el("div","filtro-chips");
    valores.forEach(v=>{
      const chip=el("button","chip"); chip.type="button";
      chip.textContent=etiquetas[v]||v;
      chip.addEventListener("click",()=>{
        if(filtroSet.has(v)) filtroSet.delete(v); else filtroSet.add(v);
        chip.classList.toggle("chip-activo",filtroSet.has(v));
        actualizarBoton();
        aplicarFiltros(cartera);
      });
      chips.appendChild(chip);
    });
    g.appendChild(chips);
    actualizarBoton();
    return g;
  }

  div.appendChild(grupo("Semáforo",["activo","pausa","bloqueado","cerrado","na"],ETQ_SEM,FILTRO.semaforo));
  div.appendChild(grupo("Pendiente",[...TIPOS_PENDIENTE,"na"],ETQ_TP,FILTRO.tp));
}

// Aplica FILTRO.semaforo x FILTRO.tp (AND) sobre la LISTA unicamente; los KPIs
// (Fase 2) y la banda (Fase 1) NO se recalculan aqui: son resumen fijo de toda
// la cartera, no del subconjunto filtrado.
function aplicarFiltros(cartera){
  cartera.forEach(p=>{
    const f=FILAS_POR_SLUG[p.slug];
    if(!f) return;
    const pasaSem=FILTRO.semaforo.size===0||FILTRO.semaforo.has(bucketSemaforo(p));
    const pasaTp=FILTRO.tp.size===0||FILTRO.tp.has(bucketTp(p));
    f.classList.toggle("oculta",!(pasaSem&&pasaTp));
  });
}

function render(){
  const lista=document.getElementById("lista");
  CARTERA.forEach(p=>{ const f=fila(p); FILAS_POR_SLUG[p.slug]=f; lista.appendChild(f); });
  renderKPIs(CARTERA);
  renderAtencion(CARTERA);
  renderFiltros(CARTERA);
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
  "<style>", css, "</style>\n</head>\n<body>\n<div class=\"wrap\">\n<div class=\"card\">\n",
  u8("<header class=\"card-header\">\n<h1>Cartera de proyectos Área de Monitoreo</h1>\n"),
  u8("<div class=\"meta\">Área de Monitoreo · "), fecha_generacion, u8("</div>\n"),
  "<div class=\"meta-hora\">Generado: ", hora_generacion, "</div>\n</header>\n",
  "<div class=\"card-body\">\n",
  "<section id=\"kpis\" class=\"kpis\" aria-label=\"Resumen por semaforo\"></section>\n",
  "<section id=\"atencion\" class=\"atencion\" aria-label=\"Requieren atencion hoy\"></section>\n",
  "<section id=\"filtros\" class=\"filtros\" aria-label=\"Filtros\"></section>\n",
  "<main id=\"lista\" class=\"lista\"></main>\n",
  "<footer class=\"bot\">Total de proyectos: ", n_total,
  "<div class=\"conteos\" id=\"conteos\"></div>",
  u8("<div class=\"conteos\" id=\"conteos-tp\"></div></footer>\n"),
  "</div>\n</div>\n</div>\n",
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
  ds <- if (is.na(o$maneja_sensibles)) "sin clasificar" else o$maneja_sensibles
  ap(sprintf("- **maneja sensibles:** %s", ds))
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
