# ==============================================================================
# 38_portafolio_derivar.R
# ------------------------------------------------------------------------------
# Proposito : Normalizacion del Portafolio. Toma lo extraido por 37 y construye el
#             dataset `portafolio/1`: un objeto por proyecto con pulso, fase,
#             avance, actividad, proximo paso, bloqueos, items por horizonte,
#             hitos, metricas y senales; mas las relaciones entre proyectos.
#             Regla rectora: ningun dato se inventa. Cada campo interpretativo
#             lleva su procedencia (declarado / inferido / ausente) y su fuente.
# Insumos   : salida de extraer_proyecto() (37_portafolio_extraer.R).
# Salidas   : lista R serializable a JSON (consumida por 39).
# Dependen. : solo R base.
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-10-02
# ==============================================================================

ESQUEMA_PORTAFOLIO <- "portafolio/1"

# ---- Taxonomias (fuente unica: viajan en el dataset, la UI no las redefine) --

TAX_PULSO <- list(
  list(id = "activo",      etiqueta = "Activo",      token = "mint"),
  list(id = "bloqueado",   etiqueta = "Bloqueado",   token = "coral"),
  list(id = "pausa",       etiqueta = "En pausa",    token = "violet"),
  list(id = "cerrado",     etiqueta = "Terminado",   token = "slate"),
  list(id = "desconocido", etiqueta = "Sin estado",  token = "unknown")
)
TAX_FASE <- list(
  list(id = "idea",        etiqueta = "Idea"),
  list(id = "exploracion", etiqueta = "Exploración"),
  list(id = "prototipo",   etiqueta = "Prototipo"),
  list(id = "mvp",         etiqueta = "MVP"),
  list(id = "desarrollo",  etiqueta = "Desarrollo"),
  list(id = "produccion",  etiqueta = "Producción"),
  list(id = "concluido",   etiqueta = "Concluido")
)
TAX_PRIORIDAD <- list(
  list(id = "alta",  etiqueta = "Alta"),
  list(id = "media", etiqueta = "Media"),
  list(id = "baja",  etiqueta = "Baja")
)
TAX_CATEGORIA_ITEM <- list(
  list(id = "funcionalidad", etiqueta = "Funcionalidades"),
  list(id = "mejora",        etiqueta = "Mejoras"),
  list(id = "bug",           etiqueta = "Errores"),
  list(id = "deuda_tecnica", etiqueta = "Deuda técnica"),
  list(id = "idea",          etiqueta = "Ideas"),
  list(id = "documentacion", etiqueta = "Documentación")
)

# Vocabulario de valores declarados -> taxonomia (texto normalizado).
MAPA_PULSO <- list(
  activo    = "^(activo|active|en curso|vigente)",
  bloqueado = "^(bloquead|blocked)",
  pausa     = "^(pausa|pausad|paused|on hold|detenid)",
  cerrado   = "^(cerrad|terminad|concluid|completad|completed|done|finished|archivad|archived)"
)
MAPA_FASE <- list(
  idea        = "\\b(idea|inicio|recien iniciado)\\b",
  exploracion = "\\b(experimental|exploracion|exploration|experimento|spike)\\b",
  prototipo   = "\\b(prototipo|prototype|poc)\\b",
  mvp         = "\\bmvp\\b",
  desarrollo  = "\\b(desarrollo|development|en construccion)\\b",
  produccion  = "\\b(produccion|production|en uso)\\b",
  concluido   = "\\b(concluido|terminado|completado|completed|finished)\\b"
)

# ---- Umbrales de senales (configurables) -------------------------------------

UMBRAL_SIN_ACTIVIDAD_AVISO   <- 60L
UMBRAL_SIN_ACTIVIDAD_ABANDONO <- 150L
UMBRAL_TODO_EXTENSO          <- 12L
UMBRAL_BACKLOG_GRANDE        <- 30L
UMBRAL_BACKLOG_SIN_PRIORIDAD <- 15L
SEMANAS_ACTIVIDAD            <- 26L

# ---- Helpers -----------------------------------------------------------------

#' Campo con procedencia.
campo <- function(valor = NULL, origen = c("declarado", "inferido", "ausente"),
                  doc = NULL, seccion = NULL, linea = NULL, regla = NULL, motivo = NULL) {
  origen <- match.arg(origen)
  list(valor = valor, origen = origen,
       fuente = if (is.null(doc)) NULL else list(doc = doc, seccion = seccion, linea = linea),
       regla = regla, motivo = motivo)
}
ausente <- function(motivo = "no_documentado") campo(NULL, "ausente", motivo = motivo)

mapear <- function(valor, mapa) {
  if (is.null(valor) || is.na(valor)) return(NA_character_)
  v <- normalizar(valor)
  # Gana el termino que aparece primero en el texto ("terminado. Se usa en
  # produccion" es concluido, no produccion).
  pos <- vapply(mapa, function(p) as.integer(regexpr(p, v, perl = TRUE)), integer(1))
  pos[pos < 0] <- NA_integer_
  if (all(is.na(pos))) NA_character_ else names(mapa)[which.min(pos)]
}

separar_lista <- function(x) {
  if (is.null(x) || is.na(x)) return(character(0))
  v <- trimws(strsplit(gsub("\\.$", "", x), ",")[[1]])
  v[nzchar(v)]
}

como_fecha <- function(x) {
  if (is.null(x) || length(x) == 0 || is.na(x)) return(as.Date(NA))
  as.Date(extraer_fecha(x))
}

secciones_de <- function(docs, rol = NULL, tipos = NULL) {
  out <- list()
  for (d in docs) {
    if (!is.null(tipos) && !(d$tipo %in% tipos)) next
    for (s in d$secciones) {
      if (!is.null(rol) && !(s$rol %in% rol)) next
      s$doc <- d$archivo; s$tipo_doc <- d$tipo
      out[[length(out) + 1]] <- s
    }
  }
  out
}

# ---- Campos declarados -------------------------------------------------------

#' Busca un campo declarado: front matter del doc de estado, luego "Clave: valor"
#' del doc de estado, luego del README. Devuelve el primero con su fuente.
buscar_declarado <- function(docs, clave) {
  orden <- c(Filter(function(d) d$tipo == "estado", docs), Filter(function(d) d$tipo == "readme", docs))
  for (d in orden) {
    if (!is.null(d$front_matter[[clave]])) {
      return(list(valor = d$front_matter[[clave]]$valor, doc = d$archivo, seccion = "front matter",
                  linea = d$front_matter[[clave]]$linea))
    }
    if (!is.null(d$inline[[clave]])) {
      return(list(valor = d$inline[[clave]]$valor, doc = d$archivo, seccion = "encabezado",
                  linea = d$inline[[clave]]$linea))
    }
  }
  NULL
}

# ---- Roadmap: fases ----------------------------------------------------------

derivar_hitos <- function(docs, fecha_ref) {
  fases <- list()
  for (s in secciones_de(docs, tipos = "roadmap")) {
    if (is.na(s$titulo) || s$nivel < 2) next
    t <- s$titulo
    parentesis <- regmatches(t, regexpr("\\(([^)]*)\\)", t))
    marca <- if (length(parentesis)) normalizar(parentesis) else ""
    nombre <- trimws(sub("\\s*\\([^)]*\\)\\s*$", "", sub("^(Fase|Phase|Etapa)\\s*[0-9]+\\s*:\\s*", "", t, ignore.case = TRUE)))
    estados <- vapply(s$items, `[[`, "", "estado")
    n_hecho <- sum(estados == "hecho")
    estado <- if (grepl("completad|done|hecho|terminad", marca)) "hecho"
              else if (grepl("en curso|in progress", marca)) "en_curso"
              else if (length(estados) && n_hecho == length(estados)) "hecho"
              else if (n_hecho > 0 || any(estados == "en_curso")) "en_curso"
              else "pendiente"
    objetivo <- extraer_fecha(t)
    fechas_items <- unlist(lapply(s$items, `[[`, "fecha"))
    fechas_items <- fechas_items[!is.na(fechas_items)]
    vencido <- !is.na(objetivo) && estado != "hecho" && as.Date(objetivo) < fecha_ref
    fases[[length(fases) + 1]] <- list(
      nombre = nombre,
      fase_tax = mapear(nombre, MAPA_FASE),
      estado = estado,
      objetivo = objetivo,
      cierre = if (estado == "hecho" && length(fechas_items)) max(fechas_items) else NA_character_,
      vencido = vencido,
      items = lapply(s$items, function(it) list(texto = it$texto, estado = it$estado, fecha = it$fecha)),
      fuente = list(doc = s$doc, seccion = s$titulo, linea = s$linea)
    )
  }
  fases
}

# ---- Eventos (actividad) -----------------------------------------------------

derivar_eventos <- function(docs) {
  ev <- list()
  agregar <- function(fecha, tipo, texto, doc) {
    if (is.na(fecha)) return(invisible())
    ev[[length(ev) + 1]] <<- list(fecha = fecha, tipo = tipo, texto = texto, doc = doc)
  }
  for (d in docs) for (s in d$secciones) {
    if (d$tipo == "changelog" && !is.na(s$titulo) && s$nivel >= 2) {
      version <- sub("^\\[?v?([0-9][^] ]*)\\]?.*$", "\\1", s$titulo)
      det <- if (length(s$items)) s$items[[1]]$texto else ""
      agregar(extraer_fecha(s$titulo), "version", paste0("v", version, if (nzchar(det)) paste0(" · ", det) else ""), d$archivo)
      next
    }
    for (it in s$items) {
      if (s$rol == "historial") agregar(it$fecha, "registro", it$texto, d$archivo)
      else if (it$estado == "hecho" && s$rol %in% c("inmediato", "plan", "futuro")) agregar(it$fecha, "tarea", it$texto, d$archivo)
    }
  }
  if (!length(ev)) return(list())
  clave <- paste(vapply(ev, `[[`, "", "fecha"), normalizar(vapply(ev, `[[`, "", "texto")))
  ev <- ev[!duplicated(clave)]
  ev[order(vapply(ev, `[[`, "", "fecha"), decreasing = TRUE)]
}

actividad_semanal <- function(eventos, fecha_ref) {
  conteo <- integer(SEMANAS_ACTIVIDAD)
  for (e in eventos) {
    dias <- as.integer(fecha_ref - as.Date(e$fecha))
    sem <- dias %/% 7L
    if (dias >= 0 && sem < SEMANAS_ACTIVIDAD) conteo[SEMANAS_ACTIVIDAD - sem] <- conteo[SEMANAS_ACTIVIDAD - sem] + 1L
  }
  as.list(conteo)
}

# ---- Proyecto ----------------------------------------------------------------

derivar_proyecto <- function(ext, fecha_ref) {
  docs <- ext$documentos
  readme <- Filter(function(d) d$tipo == "readme", docs)
  readme <- if (length(readme)) readme[[1]] else NULL
  doc_estado <- Filter(function(d) d$tipo == "estado", docs)
  doc_estado <- if (length(doc_estado)) doc_estado[[1]] else NULL

  # Identidad
  nombre <- if (!is.null(readme) && !is.na(readme$titulo)) campo(readme$titulo, "declarado", readme$archivo, "título", 1L)
            else campo(ext$id, "inferido", regla = "nombre de la carpeta")
  descripcion <- ausente(if (is.null(readme)) "documento_ausente" else "no_documentado")
  if (!is.null(readme)) {
    pre <- Filter(function(s) identical(s$nivel, 1L) || is.na(s$titulo), readme$secciones)
    pars <- unlist(lapply(pre, `[[`, "parrafos"))
    pars <- pars[!grepl("^\\s*\\*{0,2}[^:]{2,20}\\*{0,2}\\s*:", pars)]
    if (length(pars)) descripcion <- campo(pars[1], "declarado", readme$archivo, "primer párrafo")
  }

  # Campos declarados
  d_pulso <- buscar_declarado(docs, "estado")
  d_fase  <- buscar_declarado(docs, "fase")
  d_av    <- buscar_declarado(docs, "avance")
  d_act   <- buscar_declarado(docs, "ultima_actividad")
  d_pri   <- buscar_declarado(docs, "prioridad")
  d_cat   <- buscar_declarado(docs, "categoria")
  d_tec   <- buscar_declarado(docs, "tecnologias")
  d_tags  <- buscar_declarado(docs, "tags")

  pulso <- ausente(if (is.null(doc_estado)) "documento_ausente" else "no_documentado")
  if (!is.null(d_pulso)) {
    v <- mapear(d_pulso$valor, MAPA_PULSO)
    pulso <- if (!is.na(v)) campo(v, "declarado", d_pulso$doc, d_pulso$seccion, d_pulso$linea)
             else ausente("no_interpretable")
  }

  fase <- ausente()
  for (cand in list(d_fase, d_pulso)) {
    if (is.null(cand)) next
    v <- mapear(cand$valor, MAPA_FASE)
    if (!is.na(v)) { fase <- campo(v, "declarado", cand$doc, cand$seccion, cand$linea); break }
  }

  hitos <- derivar_hitos(docs, fecha_ref)
  if (fase$origen == "ausente" && length(hitos)) {
    actual <- Filter(function(h) h$estado != "hecho", hitos)
    ref <- if (length(actual)) actual[[1]] else hitos[[length(hitos)]]
    if (!is.na(ref$fase_tax)) fase <- campo(ref$fase_tax, "inferido", ref$fuente$doc, ref$fuente$seccion,
                                            regla = "fase en curso del roadmap")
  }

  # Avance: declarado > hitos > fase > ninguno. Nunca desde conteos de backlog.
  n_fases_hechas <- sum(vapply(hitos, function(h) h$estado == "hecho", logical(1)))
  avance <- list(tipo = "ninguno", valor = NULL, hechos = NULL, total = NULL, fuente = NULL)
  if (!is.null(d_av)) {
    num <- suppressWarnings(as.numeric(regmatches(d_av$valor, regexpr("[0-9]+([.,][0-9]+)?", d_av$valor))))
    if (length(num) && !is.na(num)) {
      avance <- list(tipo = "declarado", valor = min(max(num / 100, 0), 1), hechos = NULL, total = NULL,
                     fuente = list(doc = d_av$doc, seccion = d_av$seccion, linea = d_av$linea))
    }
  }
  if (avance$tipo == "ninguno" && length(hitos) >= 2) {
    avance <- list(tipo = "hitos", valor = n_fases_hechas / length(hitos), hechos = n_fases_hechas,
                   total = length(hitos), fuente = hitos[[1]]$fuente[c("doc")])
  }
  if (avance$tipo == "ninguno" && fase$origen != "ausente") avance$tipo <- "fase"

  # Eventos y actividad
  eventos <- derivar_eventos(docs)
  ultima <- ausente(if (length(eventos)) "no_documentado" else "sin_fuente_temporal")
  if (!is.null(d_act) && !is.na(extraer_fecha(d_act$valor))) {
    ultima <- campo(extraer_fecha(d_act$valor), "declarado", d_act$doc, d_act$seccion, d_act$linea)
  } else if (length(eventos)) {
    ultima <- campo(eventos[[1]]$fecha, "inferido", eventos[[1]]$doc, regla = "evento fechado más reciente")
  }
  dias_sin <- if (is.null(ultima$valor)) NULL else as.integer(fecha_ref - as.Date(ultima$valor))

  # Estado narrativo
  sec_estado <- secciones_de(if (is.null(doc_estado)) list() else list(doc_estado), rol = "estado")
  resumen <- ausente(if (is.null(doc_estado)) "documento_ausente" else "no_documentado")
  for (s in sec_estado) if (length(s$parrafos)) { resumen <- campo(s$parrafos[1], "declarado", s$doc, s$titulo, s$linea); break }
  textos_rol <- function(rol) {
    unlist(lapply(secciones_de(docs, rol = rol, tipos = "estado"), function(s) vapply(s$items, `[[`, "", "texto")))
  }
  funciona <- as.list(textos_rol("funciona"))
  falta <- as.list(textos_rol("falta"))

  # Items por horizonte
  items <- list()
  for (s in secciones_de(docs, rol = c("inmediato", "futuro"), tipos = c("estado", "todo", "backlog", "ideas", "otro"))) {
    for (k in seq_along(s$items)) {
      it <- s$items[[k]]
      items[[length(items) + 1]] <- list(
        id = sprintf("%s#%s-%d", ext$id, s$tipo_doc, length(items) + 1L),
        texto = it$texto, horizonte = s$rol, estado = it$estado,
        prioridad = it$prioridad, categoria = it$categoria, fecha = it$fecha,
        fuente = list(doc = s$doc, seccion = if (is.na(s$titulo)) NULL else s$titulo, linea = it$linea)
      )
    }
  }
  # Deduplicar por texto normalizado: gana el horizonte mas inmediato.
  if (length(items)) {
    ordh <- order(match(vapply(items, `[[`, "", "horizonte"), c("inmediato", "futuro")))
    items <- items[ordh]
    items <- items[!duplicated(normalizar(vapply(items, `[[`, "", "texto")))]
  }
  inm <- Filter(function(i) i$horizonte == "inmediato", items)
  fut <- Filter(function(i) i$horizonte == "futuro", items)
  abierto <- function(i) i$estado %in% c("pendiente", "en_curso", "bloqueado")
  inm_ab <- Filter(abierto, inm); fut_ab <- Filter(abierto, fut)
  nivel_de <- function(i) if (is.null(i$prioridad$nivel) || is.na(i$prioridad$nivel)) "sin" else i$prioridad$nivel

  # Proximo paso: declarado en seccion "proximo paso" > primer pendiente prioritario
  proximo <- ausente()
  for (s in secciones_de(docs, rol = "inmediato", tipos = "estado")) {
    if (length(s$parrafos)) { proximo <- campo(s$parrafos[1], "declarado", s$doc, s$titulo, s$linea); break }
  }
  if (proximo$origen == "ausente" && length(inm_ab)) {
    rango <- match(vapply(inm_ab, nivel_de, ""), c("alta", "media", "baja", "sin"))
    cand <- inm_ab[[order(rango)[1]]]
    proximo <- campo(cand$texto, "inferido", cand$fuente$doc, cand$fuente$seccion, cand$fuente$linea,
                     regla = "primer pendiente de mayor prioridad")
  }

  # Bloqueos
  sec_bloq <- secciones_de(docs, rol = "bloqueos", tipos = "estado")
  bloqueos <- list(estado = "no_documentado", items = list(), fuente = NULL)
  if (length(sec_bloq)) {
    s <- sec_bloq[[1]]
    txt_items <- vapply(s$items, `[[`, "", "texto")
    txt_par <- s$parrafos
    todo_txt <- c(txt_items, txt_par)
    if (!length(todo_txt) || all(grepl("^(ninguno|none|no hay|n/a|-)\\.?$", normalizar(todo_txt)))) {
      bloqueos <- list(estado = "ninguno_declarado", items = list(), fuente = list(doc = s$doc, seccion = s$titulo))
    } else {
      bloqueos <- list(estado = "declarados", items = as.list(todo_txt), fuente = list(doc = s$doc, seccion = s$titulo))
    }
  }

  # Tecnologias y tags
  tecnologias <- separar_lista(if (is.null(d_tec)) NULL else d_tec$valor)
  origen_tec <- if (length(tecnologias)) "declarado" else "ausente"
  if (!length(tecnologias) && !is.null(readme)) {
    s_tec <- Filter(function(s) !is.na(s$titulo) && grepl("^(tecnologias|stack|technologies)", normalizar(s$titulo)), readme$secciones)
    if (length(s_tec) && length(s_tec[[1]]$parrafos)) {
      tecnologias <- separar_lista(s_tec[[1]]$parrafos[1])
      tecnologias <- tecnologias[nchar(tecnologias) <= 24]
      if (length(tecnologias)) origen_tec <- "inferido"
    }
  }
  tags <- separar_lista(if (is.null(d_tags)) NULL else d_tags$valor)

  categoria <- if (is.null(d_cat)) ausente() else campo(d_cat$valor, "declarado", d_cat$doc, d_cat$seccion, d_cat$linea)
  prioridad <- ausente()
  if (!is.null(d_pri)) {
    v <- normalizar_prioridad(sub("[^A-Za-z0-9].*$", "", d_pri$valor))
    if (!is.na(v)) prioridad <- campo(v, "declarado", d_pri$doc, d_pri$seccion, d_pri$linea)
  }

  # Metricas
  cuenta_niveles <- function(lst) {
    niv <- vapply(lst, nivel_de, "")
    list(alta = sum(niv == "alta"), media = sum(niv == "media"), baja = sum(niv == "baja"), sin = sum(niv == "sin"))
  }
  cuenta_cat <- function(lst) {
    cats <- vapply(lst, function(i) if (is.null(i$categoria) || is.na(i$categoria)) "sin_categoria" else i$categoria, "")
    tb <- table(cats)
    stats::setNames(as.list(as.integer(tb)), names(tb))
  }
  metricas <- list(
    inmediato_abiertos = length(inm_ab),
    inmediato_en_curso = sum(vapply(inm, function(i) i$estado == "en_curso", logical(1))),
    inmediato_hechos = sum(vapply(inm, function(i) i$estado == "hecho", logical(1))),
    inmediato_total = length(inm),
    futuro_abiertos = length(fut_ab),
    futuro_prioridad = cuenta_niveles(fut_ab),
    futuro_categorias = cuenta_cat(fut_ab),
    inmediato_prioridad = cuenta_niveles(inm_ab),
    bloqueados = sum(vapply(items, function(i) i$estado == "bloqueado", logical(1))) + length(bloqueos$items),
    fases_hechas = n_fases_hechas,
    fases_total = length(hitos),
    hitos_vencidos = sum(vapply(hitos, `[[`, logical(1), "vencido")),
    dias_sin_actividad = dias_sin,
    eventos_90d = sum(vapply(eventos, function(e) as.integer(fecha_ref - as.Date(e$fecha)) <= 90L, logical(1)))
  )

  cobertura <- list(
    identidad = !is.null(readme),
    estado = !is.null(doc_estado),
    inmediato = length(inm) > 0 || proximo$origen == "declarado",
    futuro = length(fut) > 0,
    plan = length(hitos) > 0,
    historial = length(eventos) > 0
  )

  # Senales (evidencia textual; nunca afirmaciones absolutas)
  senales <- list()
  senal <- function(id, severidad, titulo, evidencia) {
    senales[[length(senales) + 1]] <<- list(id = id, severidad = severidad, titulo = titulo, evidencia = evidencia)
  }
  p_val <- if (is.null(pulso$valor)) "desconocido" else pulso$valor
  if (bloqueos$estado == "declarados") {
    senal("bloqueos", "atencion", "Bloqueos declarados",
          sprintf("%d bloqueo(s) en %s, sección «%s».", length(bloqueos$items), bloqueos$fuente$doc, bloqueos$fuente$seccion))
  }
  if (!is.null(dias_sin) && p_val != "cerrado") {
    if (p_val == "pausa" && dias_sin >= UMBRAL_SIN_ACTIVIDAD_AVISO) {
      senal("pausa_prolongada", "aviso", "Pausa prolongada",
            sprintf("En pausa hace %d días (última actividad: %s).", dias_sin, ultima$valor))
    } else if (dias_sin >= UMBRAL_SIN_ACTIVIDAD_ABANDONO) {
      senal("abandono", "atencion", "Posible abandono",
            sprintf("%d días sin actividad documentada (última: %s, %s).", dias_sin, ultima$valor, ultima$origen))
    } else if (dias_sin >= UMBRAL_SIN_ACTIVIDAD_AVISO) {
      senal("sin_actividad", "aviso", "Sin actividad reciente",
            sprintf("%d días desde la última actividad documentada (%s).", dias_sin, ultima$valor))
    }
  }
  if (p_val == "activo" && !is.null(dias_sin) && dias_sin >= UMBRAL_SIN_ACTIVIDAD_ABANDONO) {
    senal("contradiccion_pulso", "info", "Estado posiblemente desactualizado",
          sprintf("Se declara «activo» en %s, pero no hay actividad hace %d días.", pulso$fuente$doc, dias_sin))
  }
  if (pulso$origen == "ausente") {
    senal("sin_estado", "info", "Estado no especificado",
          if (is.null(doc_estado)) "No se encontró ESTADO.md ni STATUS.md." else "El documento de estado no declara un estado interpretable.")
  }
  if (p_val %in% c("activo", "bloqueado", "desconocido") && proximo$origen == "ausente") {
    senal("sin_proximo_paso", "aviso", "No se encontró un siguiente paso documentado",
          "Sin sección de próximo paso ni tareas inmediatas abiertas.")
  }
  if (length(inm_ab) >= UMBRAL_TODO_EXTENSO) {
    senal("todo_extenso", "aviso", "Lista inmediata extensa", sprintf("%d tareas inmediatas abiertas.", length(inm_ab)))
  }
  sin_pri <- metricas$futuro_prioridad$sin
  if (length(fut_ab) >= UMBRAL_BACKLOG_GRANDE) {
    senal("backlog_grande", "aviso", "Backlog acumulado extenso",
          sprintf("%d elementos abiertos en el backlog.", length(fut_ab)))
  }
  if (length(fut_ab) >= UMBRAL_BACKLOG_SIN_PRIORIDAD && sin_pri / length(fut_ab) > 0.75) {
    senal("backlog_sin_prioridad", "aviso", "Backlog extenso sin priorización documentada",
          sprintf("%d de %d elementos sin prioridad.", sin_pri, length(fut_ab)))
  }
  for (h in hitos) if (isTRUE(h$vencido)) {
    senal("hito_vencido", "aviso", "Hito posiblemente vencido",
          sprintf("«%s» tenía objetivo %s y no figura como completado.", h$nombre, h$objetivo))
  }
  # Contradiccion de fase entre README y documento de estado
  if (!is.null(readme) && !is.null(readme$inline$estado) && fase$origen == "declarado" && !identical(fase$fuente$doc, readme$archivo)) {
    f_readme <- mapear(readme$inline$estado$valor, MAPA_FASE)
    if (!is.na(f_readme) && f_readme != fase$valor) {
      senal("contradiccion_fase", "info", "README posiblemente desactualizado",
            sprintf("README dice «%s»; %s declara fase «%s».", f_readme, fase$fuente$doc, fase$valor))
    }
  }
  n_cob <- sum(unlist(cobertura))
  if (n_cob <= 2 || is.null(readme)) {
    faltan <- names(cobertura)[!unlist(cobertura)]
    senal("doc_incompleta", "info", "Documentación incompleta",
          sprintf("Sin información de: %s.", paste(faltan, collapse = ", ")))
  }

  documentos <- lapply(docs, function(d) {
    roles <- unique(vapply(d$secciones, `[[`, "", "rol"))
    list(archivo = d$archivo, tipo = d$tipo, roles = as.list(setdiff(roles, "otro")),
         lineas = d$lineas, html = d$html, texto = d$texto)
  })

  list(
    id = ext$id,
    ruta = ext$id,
    nombre = nombre,
    descripcion = descripcion,
    categoria = categoria,
    prioridad = prioridad,
    tags = as.list(tags),
    tecnologias = list(valores = as.list(tecnologias), origen = origen_tec),
    pulso = pulso,
    fase = fase,
    avance = avance,
    ultima_actividad = ultima,
    resumen = resumen,
    funciona = funciona,
    falta = falta,
    proximo_paso = proximo,
    bloqueos = bloqueos,
    items = items,
    hitos = hitos,
    eventos = eventos,
    actividad = actividad_semanal(eventos, fecha_ref),
    metricas = metricas,
    cobertura = cobertura,
    senales = senales,
    documentos = documentos
  )
}

# ---- Relaciones --------------------------------------------------------------

derivar_relaciones <- function(proyectos, extraidos) {
  rel <- list()
  ids <- vapply(proyectos, `[[`, "", "id")
  nombres <- vapply(proyectos, function(p) p$nombre$valor, "")
  for (i in seq_along(extraidos)) {
    for (d in extraidos[[i]]$documentos) {
      # Solo parrafos e items: los encabezados ("## Bitacora") no son referencias.
      txt <- normalizar(paste(c(unlist(lapply(d$secciones, `[[`, "parrafos")),
                                unlist(lapply(d$secciones, function(s) vapply(s$items, `[[`, "", "texto")))),
                              collapse = " "))
      for (j in seq_along(ids)) {
        if (i == j) next
        pat_id <- paste0("(^|[^a-z0-9_-])", gsub("-", "\\\\-", ids[j]), "($|[^a-z0-9_-])")
        pat_nom <- paste0("\\b", normalizar(nombres[j]), "\\b")
        hit_nom <- nchar(nombres[j]) >= 5 && nombres[j] != ids[j] && grepl(" ", nombres[j]) && grepl(pat_nom, txt, perl = TRUE)
        if (grepl(pat_id, txt, perl = TRUE) || hit_nom) {
          clave <- paste(ids[i], ids[j])
          if (is.null(rel[[clave]])) rel[[clave]] <- list(de = ids[i], a = ids[j], tipo = "referencia", evidencia = d$archivo)
        }
      }
    }
  }
  rel <- unname(rel)
  # Tecnologias compartidas (relacion debil, solo para el mapa).
  for (i in seq_along(proyectos)) for (j in seq_along(proyectos)) {
    if (j <= i) next
    ti <- tolower(unlist(proyectos[[i]]$tecnologias$valores)); tj <- tolower(unlist(proyectos[[j]]$tecnologias$valores))
    comun <- intersect(ti, tj)
    if (length(comun)) {
      rel[[length(rel) + 1]] <- list(de = ids[i], a = ids[j], tipo = "tecnologia",
                                     evidencia = paste(unlist(proyectos[[i]]$tecnologias$valores)[ti %in% comun], collapse = ", "))
    }
  }
  rel
}

# ---- Dataset -----------------------------------------------------------------

construir_dataset <- function(raiz, fecha_ref = Sys.Date(), perfil = "demo", raiz_rotulo = basename(raiz)) {
  dirs <- list.dirs(raiz, recursive = FALSE, full.names = TRUE)
  dirs <- sort(dirs[!grepl("^[._]", basename(dirs))])
  extraidos <- lapply(dirs, extraer_proyecto)
  extraidos <- Filter(function(e) length(e$documentos) > 0, extraidos)
  proyectos <- lapply(extraidos, derivar_proyecto, fecha_ref = fecha_ref)
  list(
    esquema = ESQUEMA_PORTAFOLIO,
    fecha_ref = format(fecha_ref),
    perfil = perfil,
    fuente = list(raiz = raiz_rotulo, generador = "30_procesamiento/39_portafolio_generar.R"),
    taxonomias = list(pulso = TAX_PULSO, fase = TAX_FASE, prioridad = TAX_PRIORIDAD,
                      categoria_item = TAX_CATEGORIA_ITEM),
    umbrales = list(sin_actividad_aviso = UMBRAL_SIN_ACTIVIDAD_AVISO,
                    sin_actividad_abandono = UMBRAL_SIN_ACTIVIDAD_ABANDONO,
                    backlog_grande = UMBRAL_BACKLOG_GRANDE),
    proyectos = proyectos,
    relaciones = derivar_relaciones(proyectos, extraidos)
  )
}
