# 20260826_censo_backlogs_motor.R -- andamio congelado, sesion 13, cierra O-29.
# Mide, por repo de ~/Projects/slep_* y en solo lectura: convencion de numeracion del
# backlog, maximo, huecos internos, y contraste con lo declarado en su traspaso vigente.
# Escrito para 50_documentacion/andamios/20260826_encargo_censo_backlogs.md, cuya tabla
# de patrones tenia cinco premisas falsas que esta version ya corrige. No reintroducirlas:
# P1 la convencion C-NNN no la veia ningun patron -> se agrego id_alfanum.
# P2 un backlog mezcla "20." con "**25." -> lista_num acepta negrita (si no, hueco falso).
# P3 el rango leia hashes ("9a633" en df9a633) -> exige espacios alrededor de la "a".
# P4 el patron laxo "backlog...N" mide lineas y versiones -> no clasifica por si solo.
# P5 un correlativo denso trae atipicos ("0304334. [codigo]") -> podar_atipicos().

PATRONES <- list(
  h3_num       = "^### +([0-9]+)",
  h3_num_punto = "^### +([0-9]+)\\.",
  h2_num       = "^## +([0-9]+)",
  tabla        = "^\\| *([0-9]+) *\\|",
  lista_num    = "^ *\\*{0,2}([0-9]+)\\.[* ]",
  id_prefijo   = "^[-*] *\\*?\\*?([0-9]+)\\*?\\*?[.):]",
  id_alfanum   = "^[-* ]*\\*{0,2}`?(?:[A-Z]{1,3})[-_]([0-9]+)`?"
)
ORDEN_PATRONES <- names(PATRONES)

extraer_numeros <- function(lineas, patron) {
  hit <- grepl(patron, lineas, perl = TRUE)
  if (!any(hit)) return(integer(0))
  crudo <- sub(paste0(patron, ".*$"), "\\1", lineas[hit], perl = TRUE)
  n <- suppressWarnings(as.integer(crudo))
  n[!is.na(n)]
}

# ---- Correccion 1: poda de atipicos -----------------------------------------
# Un correlativo de backlog es denso. Un valor que supera al siguiente en mas
# del doble Y por mas de 20 no es una entrada: es una referencia de codigo o un
# hash que el patron capturo (caso real: "0304334. [codigo]").
podar_atipicos <- function(nums) {
  u <- sort(unique(nums)); fuera <- integer(0)
  while (length(u) >= 2) {
    mayor <- u[length(u)]; sig <- u[length(u) - 1L]
    if (mayor > 2 * sig && (mayor - sig) > 20) {
      fuera <- c(fuera, mayor); u <- u[-length(u)]
    } else break
  }
  list(numeros = u, descartados = fuera)
}

# ---- Correccion 3: huecos como rangos ---------------------------------------
comprimir_rangos <- function(x) {
  if (!length(x)) return("")
  x <- sort(unique(x))
  g <- cumsum(c(1, diff(x) != 1))
  partes <- tapply(x, g, function(v)
    if (length(v) == 1) as.character(v) else paste0(min(v), "-", max(v)))
  paste(partes, collapse = " ")
}

detectar_convencion <- function(lineas) {
  conteos <- vapply(ORDEN_PATRONES,
                    function(k) length(extraer_numeros(lineas, PATRONES[[k]])),
                    integer(1))
  mejor_n <- max(conteos)
  empatados <- ORDEN_PATRONES[conteos == mejor_n & mejor_n > 0]
  elegido <- if (length(empatados)) empatados[1] else NA_character_
  n_lineas <- length(lineas)
  detectada <- mejor_n > 0 && !(mejor_n <= 3 && n_lineas > 50)

  crudos <- if (detectada) extraer_numeros(lineas, PATRONES[[elegido]]) else integer(0)
  pod <- podar_atipicos(crudos)

  list(convencion   = if (detectada) elegido else "convencion_no_detectada",
       n            = mejor_n,
       numeros      = pod$numeros,
       descartados  = pod$descartados,
       n_duplicados = length(crudos) - length(unique(crudos)),
       detectada    = detectada,
       empate       = length(empatados) > 1,
       empatados    = empatados,
       conteos      = conteos)
}

# ---- Localizacion de artefactos ---------------------------------------------

localizar_backlog <- function(repo) {
  pref <- file.path(repo, "50_documentacion", "activa", "backlog_acumulativo.md")
  if (file.exists(pref)) return(list(ruta = pref, n_candidatos = 1L))
  cand <- list.files(repo, pattern = "^backlog.*\\.md$", recursive = TRUE,
                     full.names = TRUE, ignore.case = TRUE)
  cand <- cand[!grepl("/andamios/|/archivo/", cand)]
  if (!length(cand)) return(list(ruta = NA_character_, n_candidatos = 0L))
  list(ruta = sort(cand)[1], n_candidatos = length(cand))
}

PATRON_TRASPASO <- "^traspaso[_-]cierre[_-]v([0-9]+)\\.md$"

localizar_traspasos <- function(repo) {
  todos <- list.files(repo, pattern = PATRON_TRASPASO, recursive = TRUE, full.names = TRUE)
  a_la_vista <- todos[!grepl("/archivo/", todos)]
  if (!length(a_la_vista)) {
    return(list(vigente = NA_character_, n_a_la_vista = 0L, n_archivados = length(todos)))
  }
  nn <- as.integer(sub(PATRON_TRASPASO, "\\1", basename(a_la_vista)))
  list(vigente      = a_la_vista[which.max(nn)],
       n_a_la_vista = length(a_la_vista),
       n_archivados = length(todos) - length(a_la_vista))
}

# ---- Correccion 2: numero declarado, patrones especificos primero -----------
# El patron laxo "backlog...N" captura versiones y ordinales de cualquier frase
# que mencione backlog. Solo se usa si ninguno de los tres especificos matcheo.
ESPECIFICOS <- c(entradas = "entradas? +([0-9]+)",
                 hasta_la = "hasta la ([0-9]+)",
                 rango    = "([0-9]+) +a +[^ ]{0,3}([0-9]+)")
LAXO        <- c(backlog  = "backlog[^0-9]{0,40}([0-9]+)")

plausible <- function(n) !is.na(n) & n > 0 & n <= 2000 & !(n >= 1900 & n <= 2100)

buscar_declarado <- function(lineas_rel, patrones) {
  mejor <- NA_integer_; mejor_linea <- NA_character_; mejor_pat <- NA_character_
  for (ln in lineas_rel) {
    for (nm in names(patrones)) {
      trozos <- regmatches(ln, gregexpr(patrones[[nm]], ln, perl = TRUE, ignore.case = TRUE))[[1]]
      if (!length(trozos)) next
      for (t in trozos) {
        nums <- suppressWarnings(as.integer(regmatches(t, gregexpr("[0-9]+", t))[[1]]))
        nums <- nums[plausible(nums)]
        if (!length(nums)) next
        v <- max(nums)
        if (is.na(mejor) || v > mejor) { mejor <- v; mejor_linea <- ln; mejor_pat <- nm }
      }
    }
  }
  list(valor = mejor,
       linea = if (is.na(mejor_linea)) NA_character_ else substr(trimws(mejor_linea), 1, 120),
       patron = mejor_pat)
}

declarado_en_traspaso <- function(ruta) {
  vacio <- list(valor = NA_integer_, linea = NA_character_, patron = NA_character_)
  if (is.na(ruta) || !file.exists(ruta)) return(vacio)
  lineas <- readLines(ruta, warn = FALSE, encoding = "UTF-8")
  rel <- lineas[grepl("backlog|entrada", lineas, ignore.case = TRUE, perl = TRUE)]
  if (!length(rel)) return(vacio)
  r <- buscar_declarado(rel, ESPECIFICOS)
  if (!is.na(r$valor)) return(r)
  buscar_declarado(rel, LAXO)
}

# ---- Estado git del hermano (solo consultas que no mutan) --------------------

git_local <- function(repo, args) {
  out <- tryCatch(
    suppressWarnings(system2("git", c("-C", repo, args), stdout = TRUE, stderr = FALSE)),
    error = function(e) character(0))
  if (is.null(out)) character(0) else out
}

# ---- Medicion de un repositorio ---------------------------------------------

medir_repo <- function(repo) {
  nombre   <- basename(repo)
  instante <- format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
  es_git   <- dir.exists(file.path(repo, ".git"))

  rama  <- if (es_git) { r <- git_local(repo, "branch --show-current"); if (length(r)) r[1] else NA_character_ } else NA_character_
  sucio <- if (es_git) length(git_local(repo, c("status", "--porcelain"))) else NA_integer_

  bl  <- localizar_backlog(repo)
  tr  <- localizar_traspasos(repo)
  dec <- declarado_en_traspaso(tr$vigente)

  conv <- "sin_backlog"; n_coinc <- NA_integer_; maxb <- NA_integer_
  huecos <- ""; n_huecos <- 0L; empate <- FALSE; conteos <- NULL
  descartados <- integer(0); n_dup <- 0L; n_unicos <- NA_integer_; minb <- NA_integer_
  if (!is.na(bl$ruta)) {
    lineas <- readLines(bl$ruta, warn = FALSE, encoding = "UTF-8")
    d <- detectar_convencion(lineas)
    conv <- d$convencion; n_coinc <- d$n; empate <- d$empate; conteos <- d$conteos
    descartados <- d$descartados; n_dup <- d$n_duplicados
    if (d$detectada && length(d$numeros)) {
      maxb <- max(d$numeros); minb <- min(d$numeros); n_unicos <- length(d$numeros)
      faltan <- setdiff(seq(minb, maxb), d$numeros)
      n_huecos <- length(faltan)
      huecos <- comprimir_rangos(faltan)
    }
  }

  delta <- if (!is.na(dec$valor) && !is.na(maxb)) dec$valor - maxb else NA_integer_

  clase <- if (!es_git) "sin_git"
    else if (is.na(bl$ruta)) "sin_backlog"
    else if (conv == "convencion_no_detectada") "convencion_no_detectada"
    else if (is.na(tr$vigente)) "sin_traspaso"
    else if (!is.na(delta) && delta > 0 && !identical(dec$patron, "backlog")) "perdida_declarada"
    else if (n_huecos > 0) "hueco_interno"
    else "calza"

  s <- function(x) if (length(x) == 0 || is.na(x)) "" else as.character(x)
  list(
    repo                   = nombre,
    ruta_backlog           = if (is.na(bl$ruta)) "" else sub(paste0("^", repo, "/"), "", bl$ruta),
    convencion             = conv,
    n_coincidencias        = s(n_coinc),
    max_backlog            = s(maxb),
    huecos_internos        = huecos,
    traspaso_vigente       = if (is.na(tr$vigente)) "" else basename(tr$vigente),
    n_traspasos_a_la_vista = as.character(tr$n_a_la_vista),
    declarado_en_traspaso  = s(dec$valor),
    linea_origen           = s(dec$linea),
    delta                  = s(delta),
    clase                  = clase,
    sucio                  = s(sucio),
    rama                   = s(rama),
    instante_medicion      = instante,
    .empate                = empate,
    .empatados             = if (empate) paste(d$empatados, collapse = "|") else "",
    .conteos               = conteos,
    .n_candidatos_backlog  = bl$n_candidatos,
    .n_archivados          = tr$n_archivados,
    .descartados           = paste(descartados, collapse = " "),
    .n_duplicados          = n_dup,
    .n_entradas_unicas     = s(n_unicos),
    .min_backlog           = s(minb),
    .n_huecos              = n_huecos,
    .patron_declarado      = s(dec$patron)
  )
}

# ---- Correccion 4 (declarada en el reporte) ----------------------------------
# El patron laxo "backlog...N" del encargo 5.4 captura conteos de lineas, hashes
# y versiones. Su valor se registra con su linea de origen para auditoria, pero
# NO puede por si solo sostener la clase "perdida_declarada": una acusacion de
# perdida no descansa en el patron mas debil de los cuatro.
