# 20260827_censo_backlogs_driver.R -- driver versionado del censo de backlogs (D-14-F).
#
# Por que existe. El motor (20260826_censo_backlogs_motor.R) y el arnes
# (20260826_censo_backlogs_autotest.R) quedaron versionados en la sesion 13, pero el
# bucle que los orquesta sobre la cartera NO: el censo de esa sesion quedo como una
# foto (20260826_censo_backlogs_cartera.csv) que nadie podia re-derivar sin reescribir
# el recorrido a mano. Este archivo es ese recorrido.
#
# Invariantes que respeta:
#   - SOLO LECTURA sobre los hermanos. Nunca escribe fuera de este repo.
#   - El motor esta CONGELADO: se sourcea, jamas se edita. Este driver no redefine
#     ninguna de sus funciones ni de sus constantes.
#   - Autocontenido: sin dependencias de paquetes (igual que el motor y el arnes) y
#     ejecutable desde cualquier directorio de trabajo.
#
# Uso:
#   Rscript 50_documentacion/andamios/20260827_censo_backlogs_driver.R
#       Mide la cartera, imprime la tabla y la contrasta contra la linea base.
#   Rscript .../20260827_censo_backlogs_driver.R --escribir
#       Ademas emite <hoy>_censo_backlogs_cartera.csv junto a este archivo.
#   Rscript .../20260827_censo_backlogs_driver.R --base <ruta.csv>
#       Usa otro CSV como linea base de contraste.
#   RAIZ_PROYECTOS=/otra/ruta Rscript .../20260827_censo_backlogs_driver.R
#       Apunta a otro universo de hermanos (util para probar sobre copias en /tmp).
#
# Sale con codigo 1 si el contraste contra la linea base falla en algun repo comun.

# ---- Localizacion propia (mismo criterio que el arnes) -----------------------
DIR_ANDAMIOS <- local({
  a <- commandArgs(trailingOnly = FALSE)
  f <- sub("^--file=", "", a[grepl("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1])) else file.path(getwd(), "50_documentacion", "andamios")
})
RUTA_MOTOR <- file.path(DIR_ANDAMIOS, "20260826_censo_backlogs_motor.R")
if (!file.exists(RUTA_MOTOR)) stop("No encuentro el motor en: ", RUTA_MOTOR)
source(RUTA_MOTOR)

# ---- Universo de hermanos ----------------------------------------------------
# <andamios> -> <50_documentacion> -> <RAIZ del orquestador> -> padre = ~/Projects.
RAIZ_ORQ <- dirname(dirname(DIR_ANDAMIOS))
.env <- Sys.getenv("RAIZ_PROYECTOS", unset = NA_character_)
RAIZ_PROYECTOS <- if (!is.na(.env) && nzchar(.env)) normalizePath(.env, mustWork = FALSE) else dirname(RAIZ_ORQ)

# Mismo filtro de universo que 10_configuracion.R: prefijo slep_, sin respaldos
# bare (.git) ni copias _backup. Se replica aqui, y no se importa, porque el
# andamio debe correr sin cargar el pipeline.
PREFIJO <- "slep_"
PATRON_EXCLUIR <- "(?i)\\.git$|_backup(_|$)"

descubrir <- function(raiz) {
  d <- list.dirs(raiz, recursive = FALSE, full.names = TRUE)
  d <- d[startsWith(basename(d), PREFIJO)]
  d <- d[!grepl(PATRON_EXCLUIR, basename(d), perl = TRUE)]
  sort(d)
}

# ---- Argumentos --------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
ESCRIBIR <- "--escribir" %in% args
RUTA_BASE <- local({
  i <- match("--base", args)
  if (!is.na(i) && length(args) >= i + 1L) args[i + 1L]
  else file.path(DIR_ANDAMIOS, "20260826_censo_backlogs_cartera.csv")
})

# ---- Recorrido ---------------------------------------------------------------
repos <- descubrir(RAIZ_PROYECTOS)
cat(sprintf("Universo: %d repos bajo %s\n\n", length(repos), RAIZ_PROYECTOS))

# Columnas publicas del motor, en el orden del censo de la sesion 13.
COLS <- c("repo", "ruta_backlog", "convencion", "n_coincidencias", "max_backlog",
          "huecos_internos", "traspaso_vigente", "n_traspasos_a_la_vista",
          "declarado_en_traspaso", "linea_origen", "delta", "clase", "sucio",
          "rama", "instante_medicion")

filas <- lapply(repos, function(r) {
  m <- medir_repo(r)
  as.data.frame(m[COLS], stringsAsFactors = FALSE)
})
censo <- do.call(rbind, filas)

anchos <- c(repo = 45, clase = 24, max_backlog = 12, huecos_internos = 18)
cat(sprintf("%-45s %-24s %12s %-18s\n", "repo", "clase", "max_backlog", "huecos_internos"))
cat(strrep("-", 102), "\n", sep = "")
for (i in seq_len(nrow(censo))) {
  cat(sprintf("%-45s %-24s %12s %-18s\n", censo$repo[i], censo$clase[i],
              censo$max_backlog[i], censo$huecos_internos[i]))
}
cat("\nresumen por clase:\n")
print(table(censo$clase))

# ---- Contraste contra la linea base -----------------------------------------
# Criterio: los repos COMUNES a ambos censos deben coincidir en clase, max_backlog
# y huecos_internos. Un repo que solo esta en uno de los dos no es una discrepancia
# del instrumento sino un cambio del universo, y se reporta aparte.
codigo_salida <- 0L
if (file.exists(RUTA_BASE)) {
  base <- utils::read.csv(RUTA_BASE, stringsAsFactors = FALSE, colClasses = "character")
  cat(sprintf("\n=== CONTRASTE contra %s (%d filas) ===\n", basename(RUTA_BASE), nrow(base)))
  comunes <- intersect(censo$repo, base$repo)
  solo_hoy  <- setdiff(censo$repo, base$repo)
  solo_base <- setdiff(base$repo, censo$repo)
  cat("repos comunes:", length(comunes), "| solo hoy:", length(solo_hoy),
      "| solo en la base:", length(solo_base), "\n")
  if (length(solo_hoy))  cat("  solo hoy      :", paste(solo_hoy, collapse = ", "), "\n")
  if (length(solo_base)) cat("  solo en la base:", paste(solo_base, collapse = ", "), "\n")

  norm <- function(x) { x[is.na(x)] <- ""; trimws(as.character(x)) }
  difs <- 0L
  cat("\n", sprintf("%-45s %-16s %-16s %s", "repo", "clase_base", "clase_hoy", "veredicto"), "\n", sep = "")
  for (r in sort(comunes)) {
    a <- base[base$repo == r, ]; b <- censo[censo$repo == r, ]
    ok <- identical(norm(a$clase), norm(b$clase)) &&
          identical(norm(a$max_backlog), norm(b$max_backlog)) &&
          identical(norm(a$huecos_internos), norm(b$huecos_internos))
    if (!ok) difs <- difs + 1L
    cat(sprintf("%-45s %-16s %-16s %s\n", r, norm(a$clase), norm(b$clase),
                if (ok) "REPRODUCE" else "DIFIERE"))
    if (!ok) {
      cat(sprintf("      max: base=%s hoy=%s | huecos: base=[%s] hoy=[%s]\n",
                  norm(a$max_backlog), norm(b$max_backlog),
                  norm(a$huecos_internos), norm(b$huecos_internos)))
    }
  }
  cat(sprintf("\nrepos que reproducen: %d de %d | discrepancias: %d\n",
              length(comunes) - difs, length(comunes), difs))
  if (difs > 0L) {
    cat("El driver NO ajusta su salida a la linea base: la discrepancia se reporta y se decide.\n")
    codigo_salida <- 1L
  }
} else {
  cat("\n(sin linea base en", RUTA_BASE, "-- se omite el contraste)\n")
}

# ---- Emision opcional --------------------------------------------------------
if (ESCRIBIR) {
  hoy <- format(Sys.Date(), "%Y%m%d")
  destino <- file.path(DIR_ANDAMIOS, paste0(hoy, "_censo_backlogs_cartera.csv"))
  utils::write.csv(censo, destino, row.names = FALSE, fileEncoding = "UTF-8")
  cat("\nescrito:", destino, "\n")
}

quit(status = codigo_salida)
