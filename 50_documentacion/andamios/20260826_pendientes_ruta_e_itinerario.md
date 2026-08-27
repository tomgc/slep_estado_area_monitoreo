# Pendientes, ruta recomendada e itinerario de encargos

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Fecha:** 2026-08-26
- **Sesión de origen:** 13
- **Sustituye a:** `20260824_pendientes_y_encargos.md` (sesión 12), que queda como
  andamio histórico y no se reescribe.
- **Alcance:** el orquestador. Los pendientes de cartera se listan al final porque
  condicionan lo que el orquestador mide, pero ejecutarlos es trabajo de cada repo.

> **Sobre las cifras de este documento.** Los estados de la tabla §2 provienen de los
> reportes de cierre de cada encargo de la sesión 13, citados por su hash. Los conteos
> agregados no se declaran: cada fila trae su propio origen y quien quiera un total lo
> deriva de la tabla, que es verificable.

---

## 1. Cerrado en la sesión 13

| Id | Qué era | Commit |
|---|---|---|
| O-09 | `registro_proyectos.csv` versionado y escrito por el paso 1 (D-01) | `3245400` |
| O-14 | `renv` sin restaurar: pipeline inoperante | `4d3c046` |
| I7 | Retrato de estructura anterior al cierre de la s12 | `4d3c046` |
| O-17 | Clasificación temática del backlog descuadrada (59 contra 77) | `d527fd6` |
| O-21 | `README.md` y `CLAUDE.md` describían el registro como insumo curado a mano | `fee9c63` |
| O-22 | `ventana_insumos` apuntaba a un directorio vacío | `fee9c63` |
| O-29 | El motor del censo vivía en el scratchpad | `e6e6a2c` |
| O-30 | El arnés del autotest vivía en el scratchpad | `b89d2f9` |
| O-31 | `CLAUDE.md` describía dos raíces en OneDrive, que no aplican a Rama A | en disco (ignorado) |
| O-05 | `data.js`: tres defectos apilados (ruta, saneador, mapeo por posición) | `7726627` |
| O-34 | El parser rompía ante objetos anidados que el catálogo del origen ya propone | `d449ffb` |
| A-05 | Diagnóstico de los dos campos perdidos | `95a77c6` |
| A-17 | Censo de backlogs de la cartera (duda 6) | `3c32b5b` |
| D-01 a D-05 | Las cinco decisiones que bloqueaban cuatro encargos | despachadas |

**O-06 no se cerró: se reclasificó.** El diagnóstico probó que `estado_proyecto` no se
pierde en la extracción, sino que sale de una columna del registro que nunca se curó
(0 de 25). No hay código que corregir. Pasa a O-06bis, curación de dato, y depende de
D-06.

---

## 2. Pendientes abiertos del orquestador

### 2.1 Deuda estructural y normativa

| Id | Pendiente | Origen | Bloquea |
|---|---|---|---|
| O-03 | Ordenación del repositorio: 12 traspasos a la vista, sin `traspasos/archivo/`, gatillo 4bis encendido | POLITICA 1.3.1 | I5 |
| O-13 | Dos archivos en `activa/` sin prefijo `50_` y fuera de las seis excepciones | POLITICA §2 | O-03 |
| O-19 | `andamios/design_handoff_monitoreo_cartera/Panorama de cartera.dc.html`: nombre con espacios | POLITICA §2, pregunta 8 | — |
| O-24 | `ESTADO.md` declara 38 paquetes; `renv.lock` tiene 34 entradas (33 más `renv`) | Reporte de A-00 | — |
| O-11 | Guarda de locale instalada y nunca vista fallar | POLITICA §5.6 pregunta 9 | cierre |
| O-15 | Declarado en el traspaso v12 §11; **no verificado en esta sesión** (hipotesis, verificar con: lectura del §11 de `traspaso_cierre_v12.md`) | — | — |
| O-16 | El instrumento de cierre pide en F10 un `commit_cierre` inalcanzable por su orden de fases | Cierre de la s12 | próximo cierre |
| O-18 | El catálogo aplicable de F3 quedó vacío: la regla 7.3 no puede detener sobre este backlog | Cierre de la s12 | próximo cierre |

**O-16 y O-18 quedan explícitamente fuera de la ruta.** El instrumento de cierre es
transversal a los 25 hermanos: modificarlo obliga a repropagarlo. Es decisión del
titular con sesión propia, no efecto lateral de una sesión del orquestador. Mientras
tanto, el cierre corre con el instrumento vigente y los dos defectos degradan la
detección, no el cierre.

### 2.2 Código, todo desbloqueado por A-05

| Id | Pendiente | Archivo | Riesgo |
|---|---|---|---|
| O-20 | El paso 1 no es idempotente: convierte campos curados vacíos en el texto literal `NA` | `31_descubrir_proyectos.R:131-137`, `:178-179` | Bajo |
| O-26 | 33 celdas con `NA` literal preexistente en `datos_sensibles` y `estado_proyecto` | `40_salidas/registro_proyectos.csv` | Bajo, se resuelve con O-20 |
| O-23 | `RUTA_INSUMOS` huérfana tras D-01; `20_insumos/` vacío en disco | `10_utils/10_configuracion.R:94` | Bajo |
| O-32 | `.Renviron.example` y `10_validar_portabilidad.R` describen el contrato de dos raíces, que no aplica | dos archivos | Bajo |
| O-07 | Desync detectado por `mtime` en vez de `vNN`: 4 falsos `PULL` | paso 32 | Medio |
| O-08 | Los pasos 32, 33 y 35 no leen el esquema v34 | tres pasos | Medio |

### 2.3 Datos y cobertura

| Id | Pendiente | Cifra | Requiere |
|---|---|---|---|
| O-06bis | `estado_proyecto` nunca curada | 0 de 25 filas | D-06 |
| O-25 | `slep_normativa_convivencia`: hermano nuevo sin metadatos curados | 1 fila | curación |
| O-33 | `slep_georreferenciacion` en el inventario, sin directorio bajo `~/Projects` | 1 fila | decisión menor |
| O-35 | Fichas sin entrada editorial: `data.js` cubre 12 proyectos y la cartera tiene 25 | 13 de 24 | fuera de control del orquestador |

### 2.4 Funcionalidad

| Id | Pendiente | Origen |
|---|---|---|
| O-12 | Migrar publicación a Cloudflare + Access | Encargo del titular, s12 |
| E0 a E6 | Ruta hacia `run_all()` como comando único | `20260824_ruta_comando_unico.md` |

### 2.5 Decisión abierta

| Id | Decisión | Bloquea |
|---|---|---|
| D-06 | `estado_proyecto`: columna curada a mano o derivada del `estado` de `data.js` | O-06bis |

---

## 3. Pendientes de cartera (contexto, no ruta)

| Id | Pendiente | Estado tras la s13 |
|---|---|---|
| C-01 | `slep_rendimiento_historico`: rescate mayor | Autorizado (D-02), sesión propia |
| C-02, C-03 | Rescates menores (`simce_estandares_aprendizaje`, `alertas_ael`) | Autorizados (D-03), oportunistas |
| O-27 | 6 de 26 repos sin archivo de backlog | Medido por el censo |
| O-28 | 12 de 26 incumplen I5, uno con 31 traspasos a la vista | Medido por el censo |
| O-36 | `slep_reportes_modelo_resguardo_asistencia` cerró sesión (v86) durante la s13 | Cambia su perfil de riesgo: ya no está abandonado |
| C-04 a C-08 | Candado v34, I5, `slep_paes`, enum, repos sin `.git` | Sin cambios; D-04 y D-05 despachadas |

La duda 6 quedó resuelta: **accidente aislado, no patrón**. El único hueco de backlog de
la cartera es el del propio orquestador. Eso significa que proteger la memoria de los
hermanos **no** desplaza a la ruta del comando único, que era la decisión que la duda
condicionaba.

---

## 4. Ruta recomendada

El principio de orden no cambia y sigue siendo el de la ruta del comando único:
**corrección antes que automatización**. Lo que cambia es que A-05 ya se ejecutó, así
que la cola de código está abierta y conviene vaciarla antes de instrumentar nada
encima.

| Orden | Encargo | Cubre | Por qué ahí |
|---|---|---|---|
| 1 | A-03 | O-03, O-13, O-19 | Exige árbol limpio, que existe hoy y puede no existir mañana. Es la última deuda estructural del repo propio |
| 2 | A-06 | O-11 | El más barato. Cierra la pregunta 9 de la auditoría, abierta sin verificar desde POLITICA v5.6 |
| 3 | A-20 | O-20, O-23, O-26, O-32, O-24 | Los cinco menores de código y prosa que se acumularon detrás de A-05. Juntos porque ninguno justifica un encargo propio y los cinco son de riesgo bajo |
| 4 | A-21 | D-06, O-06bis, O-25, O-33 | Curación de datos del registro. Va después de A-20 porque O-20 es su precondición: curar sobre un archivo que el paso 1 corrompe en la corrida siguiente es trabajo perdido |
| 5 | A-10 (E0) | arnés de log | Se instrumenta sobre un pipeline cuyos defectos ya están corregidos, no sobre uno que todavía miente |
| 6 | A-11 (E1) | O-07 | Lo que queda de las tres degradaciones: solo el desync, medido contra la línea base de E0 |
| 7 | A-12 (E2) | O-08 | Lectura del esquema v34 y traducción del enum |
| 8 | A-13 a A-16 | E3 a E6 | Cierre de árbol, publicación, comando único, prueba de aceptación |

**Fuera de la ruta, y por qué:** O-16 y O-18 (transversales, §2.1); O-35 (depende del
origen, no del orquestador); O-12 se absorbe en E4; C-01 a C-08 son de cada repo.

---

## 5. Itinerario de encargos

### A-03 — Ordenación del repositorio
- **Cubre:** O-03, O-13, O-19.
- **Precondición dura:** árbol limpio. Mezclar ordenación con cualquier otra cosa hace
  indistinguible qué movimiento fue cuál.
- **Alcance:** los cuatro bloques de SETTINGS §4.7, en rama `ordenacion/AAAAMMDD`,
  terminando en PR. `git mv` de los traspasos no vigentes a `traspasos/archivo/`, grep
  obligatorio antes de renombrar los dos archivos de `activa/` sin prefijo, y depósito de
  `50_ordenacion_repositorio.md`.
- **Control negativo:** grep en todo el repo por referencias a cada archivo movido,
  **antes** del `git mv` y **después**. Cero referencias rotas. Sin el grep previo no hay
  con qué comparar.
- **Éxito:** `ls 50_documentacion/traspasos/*.md` devuelve una línea; el marcador existe;
  el gatillo 4bis queda apagado.
- **Complejidad:** Media. **Riesgo:** Medio, por los renombres.

### A-06 — Verificación adversaria de la guarda de locale
- **Cubre:** O-11.
- **Alcance:** forzar el entorno a una locale no UTF-8 en una sesión de R desechable y
  comprobar que `asegurar_locale_utf8()` **falla y detiene**. Restaurar el entorno.
- **Por qué importa:** una guarda que nunca falló es una guarda no verificada, y su
  `PASA` produce confianza sin respaldo. La pregunta 9 lleva abierta desde v5.6.
- **Éxito:** la salida del fallo, transcrita literal, y la confirmación de que el entorno
  volvió a su estado previo.
- **Complejidad:** Baja. **Riesgo:** Bajo.

### A-20 — Cola de código menor
- **Cubre:** O-20, O-23, O-26, O-32, O-24.
- **Alcance:** cinco cambios pequeños, un commit por cada uno. El de O-20 es el único con
  lógica: `readr` parsea `""` como `NA`, `nzchar(NA)` devuelve `TRUE`, y por eso la rama
  que conserva el valor previo se queda con el `NA`.
- **Control negativo:** correr el paso 1 **dos veces seguidas** y comprobar que la segunda
  corrida no cambia ni un byte del registro. La idempotencia no se verifica corriendo una
  vez: ese es el defecto que O-20 registra.
- **Éxito:** segunda corrida con diff vacío; cero celdas con `NA` literal; `RUTA_INSUMOS`
  eliminada sin referencias huérfanas.
- **Complejidad:** Baja. **Riesgo:** Bajo.

### A-21 — Curación del registro
- **Cubre:** D-06, O-06bis, O-25, O-33.
- **Bloqueado por:** A-20 (O-20 es su precondición) y por D-06.
- **Alcance:** poblar `estado_proyecto` según lo que D-06 decida, curar los metadatos de
  `slep_normativa_convivencia`, y resolver `slep_georreferenciacion`.
- **Precaución heredada:** el dominio de valores se fija **contra `RANGO_ESTADO` del paso
  6 antes de poblar**. Curar con el enum equivocado ya tumbó ese paso en la sesión 6.
- **Éxito:** `estado_proyecto` con valor en las 25 filas, todos dentro del rango, y
  `run_all(only = 6)` completando.
- **Complejidad:** Baja. **Riesgo:** Medio: el enum equivocado tumba el paso 6.

### A-10 a A-16 — Ruta del comando único
- **Fuente:** `20260824_ruta_comando_unico.md`, que ya trae por encargo su objetivo,
  alcance, control negativo y criterio evaluable. No se reescriben aquí.
- **Cambio respecto a la s12:** E1 se reduce. De sus tres degradaciones, `data.js` quedó
  corregida en la s13 y `estado_proyecto` resultó no ser un defecto de código. Solo queda
  el desync por `mtime` (O-07).

---

## 6. Lección de método de esta sesión

Seis encargos consecutivos llevaron premisas falsas que la ejecución tuvo que corregir:
el paso 32 no leía el registro, la biblioteca de `renv` existía pero vacía, la tabla de
patrones del censo no cubría `C-NNN`, la clasificación del backlog contaba sub-items,
`estado_proyecto` no vivía en el front matter, y el mapeo de `data.js` fallaba en 9 de 12
y no en 12 de 12.

El patrón es del autor de los encargos, no del ejecutor: escribir precondiciones sobre
estados no verificados antes de escribirlas. La salvaguarda que funcionó es la que se
instaló por accidente en A-00 y se repitió después de forma explícita: **instruir al
ejecutor a corregir las premisas falsas en vez de obedecerlas, y a nombrarlas**. Sin esa
cláusula, seis encargos habrían ejecutado seis descripciones equivocadas del sistema.

Vale como cláusula fija de todo encargo futuro, junto al control negativo.
