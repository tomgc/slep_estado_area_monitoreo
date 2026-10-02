# ==============================================================================
# 37_portafolio_extraer.R
# ------------------------------------------------------------------------------
# Proposito : Lector de documentacion Markdown del Portafolio. Convierte la carpeta
#             de un proyecto en una lista de documentos, cada uno dividido en
#             secciones con un ROL (identidad, estado, inmediato, futuro, plan,
#             historial, bloqueos...) y con sus ITEMS (viñetas, checkboxes,
#             filas de tabla). No interpreta el proyecto: eso es 38.
#             La unidad de clasificacion es la SECCION, no el archivo: el
#             nombre del archivo solo aporta el rol por defecto.
# Insumos   : carpeta de un proyecto (solo *.md).
# Salidas   : listas R consumidas por 38_portafolio_derivar.R.
# Dependen. : solo R base (sin commonmark ni yaml, ausentes de renv.lock).
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-10-02
# ==============================================================================

# ---- Diccionarios (extender aqui, no en el codigo) ---------------------------

# Rol por defecto segun el tipo de archivo (tipo detectado por nombre).
TIPOS_ARCHIVO <- list(
  readme    = list(patron = "^readme$",                         rol = "identidad"),
  estado    = list(patron = "^(estado|status)$",                rol = "estado"),
  todo      = list(patron = "^(todo|pendientes|tareas)$",       rol = "inmediato"),
  backlog   = list(patron = "^backlog",                         rol = "futuro"),
  ideas     = list(patron = "^ideas$",                          rol = "futuro"),
  roadmap   = list(patron = "^(roadmap|hoja_de_ruta)$",         rol = "plan"),
  changelog = list(patron = "^(changelog|cambios|historial)$",  rol = "historial")
)

# Rol por encabezado de seccion (texto normalizado: minusculas, sin tildes).
# El orden importa: gana la primera regla que calza.
REGLAS_ROL <- list(
  inmediato = "^(ahora|now|proximo paso|proximos pasos|siguiente paso|next steps?|pendientes|por hacer|to ?do|en curso|in progress|doing|esta semana|tareas)\\b",
  futuro    = "(backlog|^ideas|a futuro|wishlist|icebox|someday|algun dia|mas adelante|later)",
  plan      = "(roadmap|hoja de ruta|hitos|milestones)",
  historial = "(changelog|historial|bitacora|^log$|registro de cambios|versiones)",
  bloqueos  = "(bloque|blocker|impediment)",
  funciona  = "(que funciona|funcionando|working)",
  falta     = "(que falta|missing)",
  estado    = "(en que vamos|situacion|current situation|^estado$|^status$)"
)

# Encabezados que marcan items como hechos sin cambiar el rol del archivo.
PATRON_HECHO <- "^(hecho|hechas|completad|done|terminad|cerrad)"

# Categoria de item por encabezado de seccion o prefijo del item.
REGLAS_CATEGORIA <- list(
  bug            = "^(bugs?|errores|fix)\\b",
  funcionalidad  = "^(features?|feat|funcionalidad(es)?)\\b",
  mejora         = "^(mejoras?|improvements?)\\b",
  deuda_tecnica  = "^(deuda( tecnica)?|tech debt|deuda tecnica)\\b",
  idea           = "^(ideas?|wishlist|icebox|someday)\\b",
  documentacion  = "^(docs?|documentacion)\\b"
)

# Campos declarados (front matter o lineas "Clave: valor" al inicio).
SINONIMOS_CAMPO <- c(
  estado = "estado", status = "estado",
  fase = "fase", phase = "fase",
  avance = "avance", progreso = "avance", progress = "avance",
  ultima_actividad = "ultima_actividad", "ultima actividad" = "ultima_actividad",
  "last activity" = "ultima_actividad", updated = "ultima_actividad",
  prioridad = "prioridad", priority = "prioridad",
  categoria = "categoria", category = "categoria",
  tecnologias = "tecnologias", stack = "tecnologias", technologies = "tecnologias",
  tags = "tags", etiquetas = "tags"
)

# ---- Utilidades de texto -----------------------------------------------------

# Reemplazo byte a byte: no depende de la locale (chartr falla bajo locale C).
TILDES <- c("á" = "a", "é" = "e", "í" = "i", "ó" = "o", "ú" = "u", "ü" = "u", "ñ" = "n",
            "Á" = "a", "É" = "e", "Í" = "i", "Ó" = "o", "Ú" = "u", "Ü" = "u", "Ñ" = "n")

normalizar <- function(x) {
  x <- enc2utf8(as.character(x))
  for (k in names(TILDES)) x <- gsub(k, TILDES[[k]], x, fixed = TRUE, useBytes = TRUE)
  trimws(gsub("\\s+", " ", tolower(x)))
}

escapar_html <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  gsub("\"", "&quot;", x, fixed = TRUE)
}

extraer_fecha <- function(x) {
  m <- regmatches(x, regexpr("\\b20[0-9]{2}-[01][0-9]-[0-3][0-9]\\b", x, perl = TRUE))
  if (length(m)) m else NA_character_
}

leer_md <- function(ruta) {
  lin <- readLines(ruta, encoding = "UTF-8", warn = FALSE)
  enc2utf8(sub("\r$", "", lin))
}

# ---- Front matter y campos declarados ---------------------------------------

#' Separa el front matter YAML simple (clave: valor) del cuerpo.
separar_front_matter <- function(lin) {
  if (length(lin) >= 2 && trimws(lin[1]) == "---") {
    fin <- which(trimws(lin[-1]) == "---")[1] + 1
    if (!is.na(fin)) {
      return(list(campos = parsear_pares(lin[2:(fin - 1)], 2L),
                  cuerpo = lin[-(1:fin)], desfase = fin))
    }
  }
  list(campos = list(), cuerpo = lin, desfase = 0L)
}

#' Lee lineas "Clave: valor" (con o sin negritas) y devuelve campos conocidos,
#' cada uno con su valor crudo y su linea de origen.
parsear_pares <- function(lin, linea0 = 1L) {
  out <- list()
  for (i in seq_along(lin)) {
    l <- sub("\\s+#.*$", "", lin[i])
    m <- regmatches(l, regexec("^\\s*\\*{0,2}([^:*]{2,30}?)\\*{0,2}\\s*:\\s*\\*{0,2}\\s*(.+?)\\s*$", l))[[1]]
    if (length(m) != 3) next
    clave <- normalizar(gsub("_", " ", m[2]))
    clave <- if (clave %in% names(SINONIMOS_CAMPO)) clave else gsub(" ", "_", clave)
    if (!(clave %in% names(SINONIMOS_CAMPO))) next
    canon <- SINONIMOS_CAMPO[[clave]]
    if (is.null(out[[canon]])) out[[canon]] <- list(valor = m[3], linea = linea0 + i - 1L)
  }
  out
}

# ---- Secciones ---------------------------------------------------------------

#' Divide el cuerpo en secciones por encabezado (ignorando bloques de codigo).
separar_secciones <- function(lin, desfase = 0L) {
  en_codigo <- FALSE
  es_tit <- logical(length(lin))
  for (i in seq_along(lin)) {
    if (grepl("^\\s*```", lin[i])) en_codigo <- !en_codigo
    es_tit[i] <- !en_codigo && grepl("^#{1,6}\\s+", lin[i])
  }
  cortes <- c(which(es_tit), length(lin) + 1L)
  secciones <- list()
  if (cortes[1] > 1) {
    secciones[[1]] <- list(titulo = NA_character_, nivel = 0L,
                           lineas = lin[seq_len(cortes[1] - 1)],
                           linea = desfase + 1L)
  }
  for (k in seq_len(length(cortes) - 1)) {
    i <- cortes[k]
    cuerpo <- if (cortes[k + 1] - 1 > i) lin[(i + 1):(cortes[k + 1] - 1)] else character(0)
    secciones[[length(secciones) + 1]] <- list(
      titulo = trimws(sub("\\s*#*\\s*$", "", sub("^#{1,6}\\s+", "", lin[i]))),
      nivel  = nchar(sub("^(#+).*", "\\1", lin[i])),
      lineas = cuerpo,
      linea  = desfase + i
    )
  }
  secciones
}

clasificar_seccion <- function(titulo, rol_archivo, tipo, nivel = 2L) {
  if (is.na(titulo)) return(list(rol = rol_archivo, hecho = FALSE, categoria = NA_character_))
  # El H1 es el titulo del documento: hereda el rol del archivo.
  if (identical(nivel, 1L)) return(list(rol = rol_archivo, hecho = FALSE, categoria = NA_character_))
  t <- normalizar(titulo)
  t_sin_num <- sub("^(fase|phase)\\s*[0-9]+\\s*:\\s*", "", t)
  cat_sec <- NA_character_
  for (cn in names(REGLAS_CATEGORIA)) if (grepl(REGLAS_CATEGORIA[[cn]], t_sin_num, perl = TRUE)) { cat_sec <- cn; break }
  hecho <- grepl(PATRON_HECHO, t)
  # Dentro de un roadmap o changelog los encabezados son fases o versiones.
  if (tipo %in% c("roadmap", "changelog")) return(list(rol = rol_archivo, hecho = hecho, categoria = cat_sec))
  rol <- rol_archivo
  if (!hecho) {
    for (rn in names(REGLAS_ROL)) if (grepl(REGLAS_ROL[[rn]], t, perl = TRUE)) { rol <- rn; break }
  }
  # Una categoria "idea/wishlist/icebox" fuera de un archivo de trabajo es futuro.
  if (identical(cat_sec, "idea") && rol %in% c("inmediato", "identidad", "otro")) rol <- "futuro"
  list(rol = rol, hecho = hecho, categoria = cat_sec)
}

# ---- Items -------------------------------------------------------------------

NIVEL_PRIORIDAD <- c(p0 = "alta", p1 = "alta", p2 = "media", p3 = "baja",
                     alta = "alta", high = "alta", media = "media", medium = "media",
                     baja = "baja", low = "baja")

normalizar_prioridad <- function(x) {
  if (is.na(x) || !nzchar(x)) return(NA_character_)
  k <- normalizar(x)
  if (k %in% names(NIVEL_PRIORIDAD)) NIVEL_PRIORIDAD[[k]] else NA_character_
}

normalizar_categoria <- function(x) {
  if (is.na(x) || !nzchar(x)) return(NA_character_)
  t <- normalizar(x)
  for (cn in names(REGLAS_CATEGORIA)) if (grepl(REGLAS_CATEGORIA[[cn]], t, perl = TRUE)) return(cn)
  if (grepl("funcional", t)) return("funcionalidad")
  NA_character_
}

#' Interpreta el texto de una viñeta: estado, prioridad, categoria, fecha.
parsear_item <- function(txt, hecho_por_seccion, categoria_seccion) {
  estado <- "pendiente"
  m <- regmatches(txt, regexec("^\\[([ xX/~-])\\]\\s*(.*)$", txt))[[1]]
  tiene_check <- length(m) == 3
  if (tiene_check) {
    estado <- switch(m[2], " " = "pendiente", "x" = , "X" = "hecho", "/" = "en_curso", "descartado")
    txt <- m[3]
  }
  if (hecho_por_seccion && !tiene_check) estado <- "hecho"
  if (grepl("^~~.*~~$", txt)) { estado <- "descartado"; txt <- gsub("~~", "", txt) }

  prioridad_orig <- NA_character_
  mp <- regmatches(txt, regexpr("\\[?\\b[Pp][0-3]\\b\\]?|\\[(alta|media|baja|high|medium|low)\\]", txt, perl = TRUE))
  if (length(mp)) {
    prioridad_orig <- gsub("[][]", "", mp)
    txt <- trimws(sub(mp, "", txt, fixed = TRUE))
  }

  categoria <- categoria_seccion
  mc <- regmatches(txt, regexec("^([A-Za-zé ]{2,12}):\\s+(.*)$", txt))[[1]]
  if (length(mc) == 3) {
    c2 <- normalizar_categoria(mc[2])
    if (!is.na(c2)) { categoria <- c2; txt <- mc[3] }
  }

  if (grepl("\\((bloqueado|blocked)\\)", txt, ignore.case = TRUE)) {
    if (estado == "pendiente") estado <- "bloqueado"
    txt <- trimws(gsub("\\s*\\((bloqueado|blocked)\\)", "", txt, ignore.case = TRUE))
  }

  fecha <- extraer_fecha(txt)
  # Fecha como prefijo de bitacora ("2026-09-29: texto") o sufijo "(2026-09-29)".
  txt <- sub("^20[0-9]{2}-[0-9]{2}-[0-9]{2}\\s*:\\s*", "", txt)
  txt <- trimws(sub("\\s*\\(20[0-9]{2}-[0-9]{2}-[0-9]{2}\\)\\s*$", "", txt))

  list(texto = txt, estado = estado,
       prioridad = list(original = prioridad_orig, nivel = normalizar_prioridad(prioridad_orig)),
       categoria = categoria, fecha = fecha)
}

#' Items de una seccion: viñetas, listas numeradas y filas de tabla.
extraer_items <- function(sec, clasif) {
  items <- list()
  lin <- sec$lineas
  # Tablas
  es_tabla <- grepl("^\\s*\\|", lin)
  if (sum(es_tabla) >= 3) {
    filas <- lin[es_tabla]
    celdas <- lapply(filas, function(f) trimws(strsplit(gsub("^\\s*\\||\\|\\s*$", "", f), "|", fixed = TRUE)[[1]]))
    cab <- normalizar(celdas[[1]])
    col_txt <- which(grepl("^(item|ítem|tarea|descripcion|titulo|elemento)", cab))[1]
    if (is.na(col_txt)) col_txt <- 1L
    col_pri <- which(grepl("^(prioridad|priority)", cab))[1]
    col_cat <- which(grepl("^(categoria|tipo|category|type)", cab))[1]
    col_est <- which(grepl("^(estado|status)", cab))[1]
    for (k in seq_along(celdas)[-(1:2)]) {
      c <- celdas[[k]]
      it <- parsear_item(c[col_txt], clasif$hecho, clasif$categoria)
      if (!is.na(col_pri)) it$prioridad <- list(original = c[col_pri], nivel = normalizar_prioridad(c[col_pri]))
      if (!is.na(col_cat)) it$categoria <- normalizar_categoria(c[col_cat])
      if (!is.na(col_est) && grepl("hech|done", normalizar(c[col_est]))) it$estado <- "hecho"
      it$linea <- sec$linea + which(es_tabla)[k]
      items[[length(items) + 1]] <- it
    }
  }
  # Viñetas
  en_codigo <- FALSE
  for (i in seq_along(lin)) {
    if (grepl("^\\s*```", lin[i])) { en_codigo <- !en_codigo; next }
    if (en_codigo) next
    m <- regmatches(lin[i], regexec("^(\\s*)([-*+]|[0-9]+[.)])\\s+(.+)$", lin[i]))[[1]]
    if (length(m) != 4) next
    it <- parsear_item(trimws(m[4]), clasif$hecho, clasif$categoria)
    it$nivel <- nchar(m[2]) %/% 2L
    it$linea <- sec$linea + i
    items[[length(items) + 1]] <- it
  }
  items
}

#' Parrafos de texto (no listas, no tablas, no codigo) de una seccion.
parrafos_de <- function(lin) {
  out <- character(0); buf <- character(0); en_codigo <- FALSE
  for (l in c(lin, "")) {
    if (grepl("^\\s*```", l)) { en_codigo <- !en_codigo; next }
    if (en_codigo) next
    if (!nzchar(trimws(l)) || grepl("^\\s*([-*+|>]|[0-9]+[.)])\\s", l) || grepl("^\\s*\\|", l)) {
      if (length(buf)) out <- c(out, paste(buf, collapse = " "))
      buf <- character(0)
    } else {
      buf <- c(buf, trimws(l))
    }
  }
  out
}

limpiar_inline <- function(x) {
  x <- gsub("\\*\\*([^*]+)\\*\\*", "\\1", x)
  x <- gsub("`([^`]+)`", "\\1", x)
  x <- gsub("\\[([^]]+)\\]\\([^)]+\\)", "\\1", x)
  trimws(gsub("(^|\\s)[*_]([^*_]+)[*_]", "\\1\\2", x))
}

# ---- Markdown a HTML (subconjunto suficiente, escapado) ----------------------

md_inline <- function(x) {
  x <- escapar_html(x)
  x <- gsub("`([^`]+)`", "<code>\\1</code>", x)
  x <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", x)
  x <- gsub("~~([^~]+)~~", "<del>\\1</del>", x)
  x <- gsub("(^|[\\s(])\\*([^*]+)\\*", "\\1<em>\\2</em>", x, perl = TRUE)
  # Los enlaces se muestran como texto: el HTML no navega fuera de si mismo.
  gsub("\\[([^]]+)\\]\\(([^)]+)\\)", "<span class=\"md-a\" title=\"\\2\">\\1</span>", x)
}

md_a_html <- function(lin) {
  out <- character(0); i <- 1L; n <- length(lin)
  while (i <= n) {
    l <- lin[i]
    if (grepl("^\\s*```", l)) {
      j <- i + 1L
      while (j <= n && !grepl("^\\s*```", lin[j])) j <- j + 1L
      cod <- if (j > i + 1L) lin[(i + 1L):(j - 1L)] else character(0)
      out <- c(out, paste0("<pre><code>", paste(escapar_html(cod), collapse = "\n"), "</code></pre>"))
      i <- j + 1L; next
    }
    if (grepl("^#{1,6}\\s", l)) {
      nv <- min(nchar(sub("^(#+).*", "\\1", l)), 4L)
      out <- c(out, sprintf("<h%d>%s</h%d>", nv, md_inline(sub("^#+\\s+", "", l)), nv))
      i <- i + 1L; next
    }
    if (grepl("^\\s*(---|\\*\\*\\*)\\s*$", l)) { out <- c(out, "<hr>"); i <- i + 1L; next }
    if (grepl("^\\s*\\|", l)) {
      j <- i
      while (j <= n && grepl("^\\s*\\|", lin[j])) j <- j + 1L
      filas <- lin[i:(j - 1L)]
      filas <- filas[!grepl("^\\s*\\|[\\s:|-]+\\|?\\s*$", filas, perl = TRUE)]
      celdas <- lapply(filas, function(f) trimws(strsplit(gsub("^\\s*\\||\\|\\s*$", "", f), "|", fixed = TRUE)[[1]]))
      cab <- paste0("<tr>", paste0("<th>", vapply(celdas[[1]], md_inline, ""), "</th>", collapse = ""), "</tr>")
      cuerpo <- vapply(celdas[-1], function(c) paste0("<tr>", paste0("<td>", vapply(c, md_inline, ""), "</td>", collapse = ""), "</tr>"), "")
      out <- c(out, paste0("<table><thead>", cab, "</thead><tbody>", paste(cuerpo, collapse = ""), "</tbody></table>"))
      i <- j; next
    }
    if (grepl("^\\s*([-*+]|[0-9]+[.)])\\s+", l)) {
      ordenada <- grepl("^\\s*[0-9]", l)
      j <- i; lis <- character(0)
      while (j <= n && grepl("^\\s*([-*+]|[0-9]+[.)])\\s+", lin[j])) {
        sangria <- nchar(sub("^(\\s*).*", "\\1", lin[j])) %/% 2L
        t <- sub("^\\s*([-*+]|[0-9]+[.)])\\s+", "", lin[j])
        clase <- ""
        mc <- regmatches(t, regexec("^\\[([ xX/~-])\\]\\s*(.*)$", t))[[1]]
        if (length(mc) == 3) {
          clase <- switch(mc[2], " " = "ck", "x" = , "X" = "ck ok", "/" = "ck wip", "ck no")
          t <- mc[3]
        }
        lis <- c(lis, sprintf("<li class=\"%s n%d\">%s</li>", clase, sangria, md_inline(t)))
        j <- j + 1L
      }
      tag <- if (ordenada) "ol" else "ul"
      out <- c(out, sprintf("<%s>%s</%s>", tag, paste(lis, collapse = ""), tag))
      i <- j; next
    }
    if (grepl("^\\s*>", l)) {
      j <- i
      while (j <= n && grepl("^\\s*>", lin[j])) j <- j + 1L
      out <- c(out, paste0("<blockquote>", md_inline(paste(sub("^\\s*>\\s?", "", lin[i:(j - 1L)]), collapse = " ")), "</blockquote>"))
      i <- j; next
    }
    if (!nzchar(trimws(l))) { i <- i + 1L; next }
    j <- i
    while (j <= n && nzchar(trimws(lin[j])) && !grepl("^(#{1,6}\\s|\\s*([-*+]|[0-9]+[.)])\\s|\\s*\\||\\s*```|\\s*>)", lin[j])) j <- j + 1L
    out <- c(out, paste0("<p>", paste(vapply(lin[i:(j - 1L)], md_inline, ""), collapse = "<br>"), "</p>"))
    i <- j
  }
  paste(out, collapse = "\n")
}

# ---- Documento y proyecto ----------------------------------------------------

tipo_de_archivo <- function(nombre) {
  base <- normalizar(tools::file_path_sans_ext(nombre))
  for (tn in names(TIPOS_ARCHIVO)) if (grepl(TIPOS_ARCHIVO[[tn]]$patron, base)) return(tn)
  "otro"
}

#' Lee un archivo Markdown y devuelve el documento estructurado.
extraer_documento <- function(ruta, raiz_proyecto) {
  nombre <- basename(ruta)
  tipo <- tipo_de_archivo(nombre)
  rol_archivo <- if (tipo == "otro") "otro" else TIPOS_ARCHIVO[[tipo]]$rol
  lin <- leer_md(ruta)
  fm <- separar_front_matter(lin)
  secs <- separar_secciones(fm$cuerpo, fm$desfase)

  # Campos "Clave: valor" antes del primer H2 (README y STATUS sin front matter).
  pre <- unlist(lapply(secs, function(s) if (is.na(s$titulo) || s$nivel <= 1) s$lineas), use.names = FALSE)
  inline <- parsear_pares(pre)

  secciones <- lapply(secs, function(s) {
    cl <- clasificar_seccion(s$titulo, rol_archivo, tipo, s$nivel)
    list(titulo = s$titulo, nivel = s$nivel, linea = s$linea, rol = cl$rol,
         hecho = cl$hecho, categoria = cl$categoria,
         parrafos = limpiar_inline(parrafos_de(s$lineas)),
         items = extraer_items(s, cl))
  })

  h1 <- Filter(function(s) identical(s$nivel, 1L), secciones)
  list(
    archivo = substring(ruta, nchar(raiz_proyecto) + 2L),
    tipo = tipo,
    rol_archivo = rol_archivo,
    front_matter = fm$campos,
    inline = inline,
    titulo = if (length(h1)) h1[[1]]$titulo else NA_character_,
    secciones = secciones,
    html = md_a_html(fm$cuerpo),
    texto = limpiar_inline(paste(fm$cuerpo[nzchar(trimws(fm$cuerpo))], collapse = " ")),
    lineas = length(lin)
  )
}

ORDEN_TIPOS <- c("readme", "estado", "todo", "backlog", "ideas", "roadmap", "changelog", "otro")

#' Extrae todos los documentos Markdown de la carpeta de un proyecto.
extraer_proyecto <- function(dir) {
  archivos <- list.files(dir, pattern = "\\.md$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  docs <- lapply(archivos, extraer_documento, raiz_proyecto = dir)
  if (length(docs)) {
    ord <- order(match(vapply(docs, `[[`, "", "tipo"), ORDEN_TIPOS), vapply(docs, `[[`, "", "archivo"))
    docs <- docs[ord]
  }
  list(id = basename(dir), documentos = docs)
}
