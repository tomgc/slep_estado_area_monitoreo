# ==============================================================================
# tests/test_orquestador.R
# ------------------------------------------------------------------------------
# Proposito : Pruebas autocontenidas (sin testthat) de los invariantes criticos
#             del orquestador: (1) confinamiento de escritura por codigo (R1);
#             (2) dedup por correlativo entero del traspaso vigente y reporte de
#             colision; (3) preferencia de backlog y exclusion de volcados (R2).
# Uso       : Rscript tests/test_orquestador.R   (devuelve codigo != 0 si falla)
# Autor     : Area de Monitoreo y Seguimiento de Procesos y Resultados Educativos
# Fecha     : 2026-06-28
# ==============================================================================

.raiz <- rprojroot::find_root(
  rprojroot::has_file("slep_estado_proyectos_monitoreo.Rproj") |
    rprojroot::is_git_root
)
source(file.path(.raiz, "10_utils", "10_utils.R"), chdir = TRUE)
source(file.path(.raiz, "10_utils", "10_configuracion.R"), chdir = TRUE)

# Cargar las funciones de 32 sin disparar su flujo principal: definimos un
# df_proyectos vacio (el flujo itera 0 filas y deja la lista vacia).
df_proyectos <- data.frame(
  slug = character(0), ruta = character(0), estructura = character(0),
  categoria = character(0), stringsAsFactors = FALSE
)
suppressMessages(source(file.path(.raiz, "30_procesamiento", "32_localizar_documentos.R"), chdir = TRUE))

# ---- Mini framework ----------------------------------------------------------
.n_ok <- 0L; .n_fail <- 0L
verificar <- function(cond, msg) {
  if (isTRUE(cond)) { .n_ok <<- .n_ok + 1L; cat("  OK  ", msg, "\n") }
  else { .n_fail <<- .n_fail + 1L; cat("  FAIL", msg, "\n") }
}

cat("== Test 1: confinamiento de escritura (escribir_seguro) ==\n")

# 1a. Escritura DENTRO del repo: debe funcionar.
ruta_ok <- file.path(RUTA_SALIDAS, "cache", "_test_confinamiento.tmp")
res_ok <- tryCatch({
  escribir_seguro(ruta_ok, function(r) writeLines("ok", r)); TRUE
}, error = function(e) FALSE)
verificar(res_ok && file.exists(ruta_ok), "escribe dentro del repo")
if (file.exists(ruta_ok)) unlink(ruta_ok)

# 1b. Escritura FUERA del repo: debe abortar con stop().
ruta_fuera <- file.path(tempdir(), "intruso_orquestador.txt")
res_fuera <- tryCatch({
  escribir_seguro(ruta_fuera, function(r) writeLines("intruso", r)); "sin_error"
}, error = function(e) "abortado")
verificar(identical(res_fuera, "abortado"), "aborta fuera del repo (cierre de R1)")
verificar(!file.exists(ruta_fuera), "no deja rastro fuera del repo")

cat("== Test 2: dedup por correlativo entero del traspaso ==\n")

tmp <- file.path(tempdir(), paste0("proj_", as.integer(runif(1, 1, 1e6))))
dir.create(file.path(tmp, "50_documentacion", "traspasos"), recursive = TRUE, showWarnings = FALSE)
w <- function(nombre) writeLines("x", file.path(tmp, "50_documentacion", "traspasos", nombre))
# v07 en dos grafias (misma sesion) + v06 + grafia con guion medio.
w("traspaso_cierre_v06.md"); w("traspaso_cierre_v07.md"); w("CONTEXTO_V07.md")
tr <- resolver_traspaso(tmp)
verificar(identical(tr$correlativo, 7L), "vigente = maximo entero (v07)")
verificar(identical(tr$total_sesiones, 2L), "total sesiones = enteros distintos (6,7) = 2")
verificar(isTRUE(tr$colision), "detecta colision de grafia en el maximo")
verificar(identical(tr$grafia, "traspaso_cierre"), "desempata a favor de traspaso_cierre")

# Caso slep_minuta_asistencia: solo CONTEXTO_VNN.md vigente.
tmp2 <- file.path(tempdir(), paste0("proj2_", as.integer(runif(1, 1, 1e6))))
dir.create(file.path(tmp2, "50_documentacion"), recursive = TRUE, showWarnings = FALSE)
writeLines("x", file.path(tmp2, "50_documentacion", "CONTEXTO_V12.md"))
tr2 <- resolver_traspaso(tmp2)
verificar(identical(tr2$correlativo, 12L) && identical(tr2$grafia, "contexto"),
          "resuelve CONTEXTO_VNN como traspaso vigente")

cat("== Test 3: backlog (preferencia y exclusion de volcados) ==\n")

tmp3 <- file.path(tempdir(), paste0("proj3_", as.integer(runif(1, 1, 1e6))))
dir.create(file.path(tmp3, "50_documentacion"), recursive = TRUE, showWarnings = FALSE)
wd <- function(n) writeLines("x", file.path(tmp3, "50_documentacion", n))
wd("backlog_consolidado.md"); wd("backlog_consolidado_anexo_1.md"); wd("backlog_volcado_crudo.md")
bk <- resolver_backlog(tmp3)
verificar(basename(bk) == "backlog_consolidado.md", "prefiere consolidado sobre anexo")
verificar(!grepl("volcado", bk), "excluye el volcado crudo (R2)")

# ---- Resumen -----------------------------------------------------------------
cat(sprintf("\nResultado: %d OK, %d FAIL\n", .n_ok, .n_fail))
if (.n_fail > 0) quit(status = 1, save = "no")
