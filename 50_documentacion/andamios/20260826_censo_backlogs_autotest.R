# 20260826_censo_backlogs_autotest.R -- arnes del motor del censo, cierra O-30.
# Ejecuta la seccion 6 del encargo 20260826_encargo_censo_backlogs.md: seis casos
# sinteticos, dos de ellos controles negativos (C5 "no supe leerlo" no es "esta vacio";
# C6 no tomar el traspaso equivocado). Autocontenido: fabrica sus propios insumos en
# tempdir() y no depende de nada fuera de este directorio. Uso:
#   Rscript 50_documentacion/andamios/20260826_censo_backlogs_autotest.R
# Sale con codigo 1 si algun caso falla, para poder encadenarlo en una compuerta.

ruta_motor <- local({
  a <- commandArgs(trailingOnly = FALSE)
  f <- sub("^--file=", "", a[grepl("^--file=", a)])
  if (length(f)) file.path(dirname(normalizePath(f[1])), "20260826_censo_backlogs_motor.R")
  else "50_documentacion/andamios/20260826_censo_backlogs_motor.R"
})
if (!file.exists(ruta_motor)) stop("No encuentro el motor en: ", ruta_motor)
source(ruta_motor)

# ---- Fabricacion de los insumos sinteticos -----------------------------------
# El .git es un directorio vacio a proposito: medir_repo() solo comprueba su
# existencia para no clasificar sin_git, y ninguna asercion mira rama ni sucio.
BASE <- file.path(tempdir(), "censo_autotest")
unlink(BASE, recursive = TRUE)

crear_caso <- function(caso, backlog, traspasos) {
  d <- file.path(BASE, caso)
  dir.create(file.path(d, "50_documentacion", "activa"), recursive = TRUE)
  dir.create(file.path(d, "50_documentacion", "traspasos"), recursive = TRUE)
  dir.create(file.path(d, ".git"), recursive = TRUE)
  writeLines(backlog, file.path(d, "50_documentacion", "activa", "backlog_acumulativo.md"))
  for (nm in names(traspasos)) {
    writeLines(traspasos[[nm]], file.path(d, "50_documentacion", "traspasos", nm))
  }
  invisible(d)
}
entradas_h3 <- function(nums) c("# Backlog",
  unlist(lapply(nums, function(i) c(paste0("### ", i), paste0("Entrada ", i, " del backlog sintetico.")))))
declara <- function(n) paste0("El backlog acumulativo llega hasta la entrada ", n, ".")

crear_caso("C1", entradas_h3(1:10), list(traspaso_cierre_v01.md = declara(10)))
crear_caso("C2", entradas_h3(c(1:5, 8:10)), list(traspaso_cierre_v01.md = declara(10)))
crear_caso("C3", entradas_h3(1:40), list(traspaso_cierre_v01.md = declara(54)))
crear_caso("C4", c("# Backlog", "| N | Descripcion |", "|---|---|",
                   paste0("| ", 1:12, " | Entrada sintetica |")),
           list(traspaso_cierre_v01.md = declara(12)))
crear_caso("C5", c("# Backlog en prosa",
                   rep("Parrafo de prosa sin numeracion de entrada, redactado en linea suelta.", 199)),
           list(traspaso_cierre_v01.md = declara(10)))
crear_caso("C6", entradas_h3(1:20),
           list(traspaso_cierre_v03.md = declara(99), traspaso_cierre_v11.md = declara(20)))

# ---- Los seis casos ----------------------------------------------------------
esperado <- list(
  C1 = list(desc = "### 1..10, traspaso declara 10",
            chk = function(r) r$clase == "calza" && r$max_backlog == "10" && r$convencion == "h3_num",
            dice = "calza, maximo 10"),
  C2 = list(desc = "### 1..5 y 8..10, traspaso declara 10",
            chk = function(r) r$clase == "hueco_interno" && r$huecos_internos %in% c("6 7", "6-7"),
            dice = "hueco_interno, faltantes 6 y 7"),
  C3 = list(desc = "### 1..40, traspaso declara 54",
            chk = function(r) r$clase == "perdida_declarada" && r$delta == "14",
            dice = "perdida_declarada, delta 14"),
  C4 = list(desc = "tabla | 12 | hasta 12",
            chk = function(r) r$convencion == "tabla" && r$max_backlog == "12" && r$max_backlog != "0",
            dice = "detecta tabla, maximo 12, no cero"),
  C5 = list(desc = "CONTROL NEGATIVO: 200 lineas sin numero de entrada",
            chk = function(r) r$convencion == "convencion_no_detectada" &&
                              r$clase == "convencion_no_detectada" &&
                              r$max_backlog == "" && r$clase != "calza",
            dice = "convencion_no_detectada, nunca calza ni maximo 0"),
  C6 = list(desc = "CONTROL NEGATIVO: dos traspasos, v03 declara 99",
            chk = function(r) r$traspaso_vigente == "traspaso_cierre_v11.md" &&
                              r$n_traspasos_a_la_vista == "2" &&
                              r$declarado_en_traspaso != "99" &&
                              r$declarado_en_traspaso == "20",
            dice = "elige v11, I5 incumplido (2 a la vista), no toma el 99")
)

cat("================= AUTOTEST (encargo A-17, seccion 6) =================\n")
todo_ok <- TRUE
for (k in names(esperado)) {
  r <- medir_repo(file.path(BASE, k))
  ok <- isTRUE(esperado[[k]]$chk(r))
  todo_ok <- todo_ok && ok
  cat(sprintf("\n--- %s: %s\n", k, esperado[[k]]$desc))
  cat(sprintf("    esperado : %s\n", esperado[[k]]$dice))
  cat(sprintf("    medido   : clase=%s | convencion=%s | n_coincidencias=%s | max_backlog=%s\n",
              r$clase, r$convencion, r$n_coincidencias, r$max_backlog))
  cat(sprintf("               huecos=[%s] | traspaso=%s | a_la_vista=%s | declarado=%s | delta=%s\n",
              r$huecos_internos, r$traspaso_vigente, r$n_traspasos_a_la_vista,
              r$declarado_en_traspaso, r$delta))
  cat(sprintf("               linea_origen=%s\n", r$linea_origen))
  cat(sprintf("    RESULTADO: %s\n", if (ok) "PASA" else "FALLA"))
}
cat(sprintf("\n=================== AUTOTEST GLOBAL: %s ===================\n",
            if (todo_ok) "6/6 PASAN" else "HAY FALLAS -- el censo NO se ejecuta"))
unlink(BASE, recursive = TRUE)
quit(status = if (todo_ok) 0L else 1L)
