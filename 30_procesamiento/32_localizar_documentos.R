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
# El sufijo tras el correlativo es OPCIONAL y debe abrir con "_" o "-": la
# cartera usa traspaso_cierre_vNN_<slug>.md en al menos un hermano, y el ancla
# "$" pegada al correlativo lo dejaba fuera sin aviso (B-14-01). El sufijo no
# puede empezar por letra o digito, para no capturar nombres tematicos como
# traspaso_cierre_react_v01.md ni contexto_proyecto.md.
PATRON_TRASPASO <- "(?i)^(traspaso[_-]cierre[_-]v\\d+|contexto_v\\d+)([_-].*)?\\.md$"
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

#' Busca un encabezado que PAREZCA la seccion pedida pero no calce la forma
#' canonica de seccion_md() (`## <Titulo>` exacto, nivel 2, sin sufijo). Devuelve
#' la linea literal hallada, o NA si no hay ninguna.
#'
#' Existe porque seccion_md() es estricto y devuelve "" tanto cuando la seccion
#' NO ESTA como cuando esta escrita de otra forma. Los dos casos son distintos y
#' el segundo es un fallo silencioso: el hermano declaro su proximo paso y el
#' panorama lo perdio sin decir nada. D-24-H. (SETTINGS no se toca: la deteccion
#' vive aqui, en el consumidor.)
forma_no_canonica_seccion <- function(cuerpo_lineas, titulo) {
  laxo <- sprintf("(?i)^#{1,6}[[:space:]]+.*%s", gsub(" ", "[[:space:]]+", titulo))
  cand <- cuerpo_lineas[grepl(laxo, cuerpo_lineas, perl = TRUE)]
  if (!length(cand)) return(NA_character_)
  exacto <- sprintf("^##\\s+%s\\s*$", titulo)
  fuera <- cand[!grepl(exacto, cand)]
  if (!length(fuera)) return(NA_character_)
  trimws(fuera[1])
}

#' Advierte una sola vez por repo sobre una seccion escrita fuera de la forma
#' canonica. Mismo registro que advertir_esquema(): un aviso por repo y corrida.
.avisos_seccion <- new.env(parent = emptyenv())
advertir_seccion_no_canonica <- function(repo, titulo, forma) {
  if (is.na(forma)) return(invisible(NULL))
  clave <- paste(repo, titulo, sep = "::")
  if (!is.null(.avisos_seccion[[clave]])) return(invisible(NULL))
  .avisos_seccion[[clave]] <- TRUE
  log_msg(sprintf(paste0(
    "ESTADO.md de [%s]: la seccion '%s' existe pero NO en la forma canonica ",
    "'## %s'; se hallo [%s]. El campo queda vacio: el lector es estricto a ",
    "proposito y solo avisa, no adivina."),
    repo, titulo, titulo, forma), "32_localizar", "WARN")
  invisible(NULL)
}

# ---- Tolerancia a esquemas no canonicos (B-14-02, D-14-E) --------------------
# Un hermano de la cartera escribe su ESTADO.md con otras claves: `sesion:` en vez
# de `sesion_actual:`, `fecha:` en vez de `ultima_actividad:`, `sensibilidad:` en
# vez de `maneja_sensibles:`. Tolerar en SILENCIO convertiria la deriva de esquema
# en invisible, que es el defecto que se corrige, no una variante de el. Por eso el
# lector ACEPTA el alias y ADVIERTE nombrando el repo y las claves.
# La correccion del ESTADO.md vive en el hermano y exige autorizacion nominal
# propia (D-14-E se resolvio como *no* en esta sesion): aqui no se toca.
ALIAS_FRONT_MATTER <- list(
  sesion_actual    = "sesion",
  ultima_actividad = "fecha",
  maneja_sensibles = "sensibilidad"
)

#' Lee una clave del front matter aceptando su alias no canonico conocido.
#' Devuelve el valor y el alias efectivamente usado (NA si se uso la canonica),
#' para que el llamador pueda advertir sin volver a inspeccionar el archivo.
leer_clave_tolerante <- function(meta, canonica) {
  v <- meta[[canonica]]
  if (!is.null(v) && nzchar(v)) return(list(valor = v, alias = NA_character_))
  ali <- ALIAS_FRONT_MATTER[[canonica]]
  if (!is.null(ali)) {
    w <- meta[[ali]]
    if (!is.null(w) && nzchar(w)) return(list(valor = w, alias = ali))
  }
  list(valor = NULL, alias = NA_character_)
}

#' Advierte una sola vez por repo y por corrida sobre las claves no canonicas
#' halladas. El registro de lo ya advertido vive en un entorno propio para no
#' ensuciar el global ni depender del orden de las llamadas.
.avisos_esquema <- new.env(parent = emptyenv())
advertir_esquema <- function(repo, alias_usados) {
  alias_usados <- alias_usados[!is.na(alias_usados)]
  if (!length(alias_usados)) return(invisible(NULL))
  if (!is.null(.avisos_esquema[[repo]])) return(invisible(NULL))
  .avisos_esquema[[repo]] <- TRUE
  pares <- vapply(alias_usados, function(a) {
    can <- names(ALIAS_FRONT_MATTER)[vapply(ALIAS_FRONT_MATTER, identical, logical(1), a)]
    sprintf("'%s' (canonica: '%s')", a, if (length(can)) can[1] else "?")
  }, character(1))
  log_msg(sprintf(
    "ESTADO.md de [%s] usa claves NO canonicas: %s. Se aceptan por tolerancia; " ,
    repo, paste(pares, collapse = ", ")), "32_localizar", "WARN")
  log_msg(sprintf(
    "  la correccion vive en el repo hermano [%s] y exige autorizacion nominal propia.",
    repo), "32_localizar", "WARN")
  invisible(NULL)
}

#' Extrae el correlativo entero de una etiqueta de sesion del front matter
#' ("v13", "V07", "13"). Devuelve NA_integer_ si no hay entero legible.
#' No compone el identificador desde el nombre del archivo: el vNN del traspaso
#' sale de resolver_traspaso(), y este helper solo lee lo que el ESTADO declara.
correlativo_de_sesion <- function(x) {
  if (is.null(x) || length(x) != 1L || is.na(x) || !nzchar(x)) return(NA_integer_)
  m <- regmatches(x, regexpr("[0-9]+", x))
  if (!length(m)) return(NA_integer_)
  suppressWarnings(as.integer(m))
}

#' Resuelve el ESTADO.md (Fase 2 PUSH) de un hermano y decide la fuente de
#' lectura del estado en esta corrida: PUSH (leer ESTADO.md directo) vs PULL
#' (recomputar desde traspaso/backlog, comportamiento Fase 1).
#'
#' Devuelve un `veredicto` de TRES estados, no un logico de dos:
#'   "sincronizado"   : se pudo comparar y la comparacion pasa.
#'   "desincronizado" : se pudo comparar y la comparacion falla.
#'   "indeterminado"  : NO se pudo comparar (falta el traspaso, el ESTADO.md o
#'                       su `sesion_actual`).
#'
#' El tercer estado existe por B-14-01: cuando `resolver_traspaso()` devolvia NA,
#' la rama de comparacion no se evaluaba y `sincronizado` quedaba TRUE por
#' defecto, es decir, un dato ausente se leia como afirmacion positiva. Esa
#' conversion silenciosa, y no el regex, era la causa raiz.
#'
#' REGLA DE SINCRONIA (O-38 / P6): se compara `sesion_actual` del front matter
#' contra el correlativo del traspaso vigente que resuelve resolver_traspaso().
#' Un ESTADO cuya sesion declarada va DETRAS del ultimo traspaso escrito esta
#' desincronizado; si va igual o delante, esta sincronizado.
#'
#' Por que NO se usa el mtime del traspaso (regla anterior). El mtime es la fecha
#' en que el archivo se toco en ESTE disco, no la fecha del trabajo: un traspaso
#' guardado pasada la medianoche de su fecha de cierre declarada, un `git clone`
#' o un `git checkout` reescriben el mtime de golpe y producian desincronizados
#' falsos. El margen de tolerancia en dias que existia solo para amortiguar
#' ruido; con la comparacion por correlativo no hay ruido que amortiguar, asi
#' que se retiro de 10_configuracion.R (D-24-E).
#'
#' `sincronizado` se conserva como logico DERIVADO y ESTRICTO
#' (`veredicto == "sincronizado"`) para los consumidores que ya lo leen: un
#' indeterminado NO afirma sincronia. La decision de APAGAR un campo, en cambio,
#' exige la afirmacion negativa explicita (`veredicto == "desincronizado"`).
#'
#' @param traspaso lista devuelta por resolver_traspaso() (se usa `$correlativo`).
resolver_estado <- function(ruta_proyecto, traspaso) {
  ruta <- file.path(ruta_proyecto, SUBRUTA_ESTADO)
  vacio <- list(presente = FALSE, sincronizado = FALSE, veredicto = "indeterminado",
                fuente = "PULL", ruta = NA_character_, meta = list(), cuerpo = "",
                proximo = NA_character_, tipo_pendiente = NA_character_,
                motivo = "sin ESTADO.md")
  if (!file.exists(ruta)) return(vacio)

  L  <- readLines(ruta, warn = FALSE, encoding = "UTF-8")
  fm <- parsear_front_matter(L)
  meta <- fm$meta

  # Tolerancia con aviso: si el correlativo del traspaso no llega envuelto en la
  # lista de resolver_traspaso(), se acepta el entero desnudo. No se adivina.
  vnn <- if (is.list(traspaso)) traspaso$correlativo else traspaso
  vnn <- if (is.null(vnn)) NA_integer_ else suppressWarnings(as.integer(vnn))
  lec_ses <- leer_clave_tolerante(meta, "sesion_actual")
  lec_ua  <- leer_clave_tolerante(meta, "ultima_actividad")
  lec_ms  <- leer_clave_tolerante(meta, "maneja_sensibles")
  advertir_esquema(basename(ruta_proyecto), c(lec_ses$alias, lec_ua$alias, lec_ms$alias))
  ses <- correlativo_de_sesion(lec_ses$valor)

  if (is.na(ses)) {
    veredicto <- "indeterminado"
    motivo <- "sin sesion_actual legible en el front matter: la sincronia no se puede medir"
  } else if (is.na(vnn)) {
    veredicto <- "indeterminado"
    motivo <- "sin traspaso legible: la sincronia no se puede medir"
  } else if (ses < vnn) {
    veredicto <- "desincronizado"
    motivo <- sprintf("desync: sesion_actual v%02d < traspaso vigente v%02d", ses, vnn)
  } else {
    veredicto <- "sincronizado"
    motivo <- sprintf("sincronizado: sesion_actual v%02d >= traspaso vigente v%02d", ses, vnn)
  }

  tp <- if (is.null(meta$tipo_pendiente) || !nzchar(meta$tipo_pendiente))
           NA_character_ else meta$tipo_pendiente
  prox <- seccion_md(fm$cuerpo, "Proximo paso")
  if (!nzchar(prox)) {
    advertir_seccion_no_canonica(basename(ruta_proyecto), "Proximo paso",
                                 forma_no_canonica_seccion(fm$cuerpo, "Proximo paso"))
  }

  list(
    presente       = TRUE,
    sincronizado   = identical(veredicto, "sincronizado"),
    veredicto      = veredicto,
    fuente         = if (identical(veredicto, "desincronizado")) "PULL" else "PUSH",
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
      estado           = resolver_estado(ruta, tr)   # Fase 2 PUSH (decide PUSH/PULL)
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
