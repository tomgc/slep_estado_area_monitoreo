# Pendientes consolidados y mapa de encargos autónomos

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Fecha:** 2026-08-24
- **Sesión de origen:** 12
- **Alcance:** todo lo abierto al cierre de la sesión 12, propio y de cartera,
  organizado en encargos ejecutables por Claude Code sin intervención conversacional.

---

## 1. Cómo leer este documento

Un **encargo autónomo** es una unidad que Claude Code puede ejecutar de principio a
fin leyendo un solo archivo, sin volver a consultar, con su propia compuerta de
verificación. Tres cosas lo hacen autónomo y las tres se declaran por encargo:

1. **Precondición verificable:** el estado que el encargo espera encontrar, con regla
   de detención si no calza.
2. **Criterio de éxito medible:** artefactos que se pueden leer y contrastar, no un
   juicio del ejecutor.
3. **Alcance de escritura cerrado:** qué rutas puede tocar y qué hace si encuentra
   algo fuera de esa lista.

Lo que **no** puede ser autónomo va aparte, en el §3: decisiones que definen
gobernanza o que autorizan escritura en un repo ajeno. Delegarlas sería que el
ejecutor decida por el titular.

---

## 2. Inventario de pendientes

### 2.1 Del orquestador

| Id | Pendiente | Origen | Tipo | Bloquea a |
|---|---|---|---|---|
| O-01 | Cerrar tramo B: verificar merge, reponer normativos ignorados, push de `main` | Sesión 12, en ejecución | rescate | todo |
| O-02 | Reconstruir backlog, entradas 55 a 67 | Backlog llega a 54; traspasos declaran 67 | deuda documental | cierre limpio |
| O-03 | Ordenación del repositorio: 11 traspasos a la vista, sin `archivo/` | POLITICA 1.3.1; gatillo 4bis encendido | deuda estructural | I5 |
| O-04 | Migrar el propio `ESTADO.md` al esquema v34 (seis campos de candado más `ventana_insumos`) | SETTINGS §2.1bis | deuda normativa | I6, I9 |
| O-05 | `data.js` no disponible: `tipo`, `objetivo`, `sintesis` nulos en los 24 | Log `run_all` 11:06 | bug | E1 |
| O-06 | `estado_proyecto` vacío en los 24 sin excepción | Log `run_all` 11:06 | bug | E1 |
| O-07 | Desync por `mtime` en vez de `vNN`: 4 falsos `PULL` | Log `run_all` 11:04 | bug | E1 |
| O-08 | Leer el esquema v34 en los pasos 32, 33 y 35 | Delta normativo §3.2 | funcionalidad | E2 |
| O-09 | `registro_proyectos.csv` versionado y escrito por el paso 1: choca con I8 y POLITICA 1.3 | Delta normativo §3.3 | decisión | E3 |
| O-10 | Reponer `CLAUDE.md` desde la knowledge base tras el merge | Tramo B | manual | — |
| O-11 | Guarda de locale instalada pero nunca vista fallar | POLITICA §5.6 pregunta 9 | verificación | cierre |
| O-12 | Migrar publicación a Cloudflare + Access | Encargo del titular, sesión 12 | funcionalidad | E4 |
| O-13 | Dos archivos de `activa/` sin prefijo `50_` y fuera de las seis excepciones | POLITICA §2 | deuda estructural | O-03 |

### 2.2 De la cartera, detectados por el censo

| Id | Pendiente | Cifras | Requiere |
|---|---|---|---|
| C-01 | `slep_rendimiento_historico`: rescate | 4 traspasos sin versionar, 29 sucio, sin `ESTADO.md`, rama `gobernanza/v16`, 10 detrás | autorización por repo |
| C-02 | `slep_simce_estandares_aprendizaje`: rescate menor | 1 traspaso sin versionar, 8 sucio, 9 detrás | autorización por repo |
| C-03 | `slep_alertas_ael`: rescate menor | 1 traspaso sin versionar, 6 sucio, 9 detrás | autorización por repo |
| C-04 | Migración de candado a v34 | 20 de 25 sin ningún campo, 0 parciales | autorización por repo |
| C-05 | I5 en cartera: 14 repos con más de un traspaso a la vista | 14 de 25 | autorización por repo |
| C-06 | `slep_paes`: `ESTADO.md` contra `gobernanza_datos.md` | inconsistencia declarada | decisión de gobernanza |
| C-07 | Tres hermanos con `tipo_pendiente` fuera del enum | `funcionalidad`, `no_bloqueante`, `verificacion_y_decision_titular` | autorización por repo |
| C-08 | Cuatro repos sin `ESTADO.md`, dos sin `.git` | `minuta_desvinculacion`, `minuta_matricula`, `resena_proyectos`, más uno | decisión: son proyectos o no |

### 2.3 De la ruta del comando único

`E0` a `E6`, especificados en `20260824_ruta_comando_unico.md`. No se repiten aquí:
ese documento es su fuente.

---

## 3. Decisiones que no se delegan

Ninguno de los encargos que dependen de estas puede escribirse antes de que estén
tomadas. Son cinco y son cortas:

| Id | Decisión | Bloquea |
|---|---|---|
| D-01 | Qué se hace con `registro_proyectos.csv`: excepción declarada por escrito, moverlo a `40_salidas/`, o dejar de versionarlo | E3, A-07 |
| D-02 | Autorización de escritura en `slep_rendimiento_historico` | A-08 |
| D-03 | Autorización de escritura en `slep_simce_estandares_aprendizaje` y `slep_alertas_ael` | A-09 |
| D-04 | `slep_paes`: cuál de las dos fuentes manda sobre la categoría de datos | C-06 |
| D-05 | `minuta_matricula` y `resena_proyectos` sin `.git`: son proyectos de la cartera o quedan fuera del universo | descubrimiento del paso 1 |

---

## 4. Mapa de encargos autónomos

### A-01 — Cierre del tramo B y verificación del árbol
- **Cubre:** O-01, O-10.
- **Estado:** en ejecución. El encargo ya existe
  (`20260824_encargo_rescate_tramo_b.md`).
- **Autonomía:** total, con D1 a D4 ya escritas.
- **Éxito:** `rev-list --left-right --count` con `0` a la izquierda; los dos normativos
  ignorados y presentes en disco; `ls-remote` de `main` igual a `HEAD`.
- **Complejidad:** Media. **Riesgo:** Medio.

### A-02 — Reconstrucción del backlog 55 a 67
- **Cubre:** O-02.
- **Insumos:** `traspasos/traspaso_cierre_v07.md` a `v11.md`, ya versionados por el
  tramo A.
- **Alcance:** extraer de cada traspaso su §5 (entradas nuevas) y volcarlas a
  `backlog_acumulativo.md` respetando numeración correlativa, clasificación temática y
  la fila del resumen por sesión. Escribe **un solo archivo**.
- **Autonomía:** total. Es determinista: las entradas ya están escritas, se trasladan.
- **Control negativo:** si alguna entrada del rango 55-67 no aparece en ningún
  traspaso, el encargo para y la nombra. Un hueco silencioso es peor que un hueco
  declarado.
- **Éxito:** última entrada 67, sin huecos en 55-67, resumen con filas 7 a 11, y
  `git diff` que toque exactamente un archivo.
- **Complejidad:** Media. **Riesgo:** Bajo.

### A-03 — Ordenación del repositorio
- **Cubre:** O-03, O-13.
- **Alcance:** los cuatro bloques de SETTINGS §4.7, en rama `ordenacion/AAAAMMDD`,
  terminando en PR. Incluye `git mv` de los diez traspasos no vigentes a
  `traspasos/archivo/`, el grep obligatorio antes de renombrar los dos archivos de
  `activa/` sin prefijo, y el depósito de `50_ordenacion_repositorio.md`.
- **Autonomía:** total. La regla es normativa y no admite criterio.
- **Precondición:** árbol limpio. Si no, para: mezclar ordenación con rescate hace
  indistinguible qué movimiento fue cuál.
- **Éxito:** `ls 50_documentacion/traspasos/*.md` devuelve una línea; existe el
  marcador; el gatillo 4bis queda apagado; cero referencias rotas a los archivos
  movidos (verificado por grep en todo el repo).
- **Complejidad:** Media. **Riesgo:** Medio, por los renombres.

### A-04 — Migración del `ESTADO.md` propio a v34
- **Cubre:** O-04.
- **Alcance:** un archivo. Añade los seis campos de candado más `ventana_insumos`, y
  corrige `sesion_actual` y `ultima_actividad`, hoy en `v06` y `2026-07-01` contra un
  traspaso vigente v11.
- **Autonomía:** total, salvo el valor de `ventana_insumos`, que se deriva de la
  configuración del proyecto y se declara en el encargo.
- **Éxito:** los siete campos presentes; `commit_cierre` ancestro del `HEAD` de
  `origin`; el verificador de cierre sube I6 e I9 de `FALLA` a `PASA`.
- **Complejidad:** Baja. **Riesgo:** Bajo.

### A-05 — Diagnóstico de `data.js` y de `estado_proyecto`
- **Cubre:** O-05, O-06.
- **Alcance:** **solo lectura**. Localiza dónde busca el paso 6 el `data.js`, si existe
  en esa ruta y si cambió de formato; y en qué paso (32, 33 o 35) se pierde
  `estado_proyecto`. Entrega un informe, **no una corrección**.
- **Por qué separado de la corrección:** que fallen los 24 sin excepción apunta a la
  extracción y no a los hermanos, pero eso es hipótesis hasta medirlo. Corregir sin
  diagnosticar es cambiar rutas a ciegas.
- **Éxito:** el informe nombra el archivo y la línea donde se pierde cada campo, con
  la evidencia que lo demuestra.
- **Complejidad:** Media. **Riesgo:** Nulo.

### A-06 — Verificación adversaria de la guarda de locale
- **Cubre:** O-11.
- **Alcance:** forzar el entorno a una locale no UTF-8 en una sesión de R desechable y
  comprobar que `asegurar_locale_utf8()` **falla y detiene**. Restaurar el entorno.
- **Por qué importa:** POLITICA §5.6 pregunta 9 exige haberla visto fallar. Una guarda
  que nunca falló es una guarda no verificada, y su `PASA` produce confianza sin
  respaldo.
- **Éxito:** la salida del fallo, transcrita literal, y la confirmación de que el
  entorno volvió a su estado previo.
- **Complejidad:** Baja. **Riesgo:** Bajo.

### A-07 — Resolución de `registro_proyectos.csv`
- **Cubre:** O-09. **Bloqueado por:** D-01.
- **Alcance:** ejecutar la salida que el titular elija, incluida la actualización de
  los scripts que lo escriben o lo leen si la opción es moverlo.
- **Éxito:** I8 pasa, o existe la excepción declarada por escrito en `activa/` con
  prefijo `50_`.
- **Complejidad:** Media. **Riesgo:** Medio: el paso 1 lo escribe y el 32 lo lee.

### A-08 — Rescate de `slep_rendimiento_historico`
- **Cubre:** C-01. **Bloqueado por:** D-02.
- **Alcance:** el patrón de los tramos A y B, aplicado a ese repo: rama de respaldo,
  commits selectivos, publicación, y recién después integración. Más la creación de su
  `ESTADO.md`, que no existe.
- **Por qué sesión propia:** es el mayor riesgo de pérdida de la cartera y está en una
  rama que no es `main`. Mezclarlo con otro trabajo repite el error de alcance que ya
  costó un aborto en la sesión 11.
- **Éxito:** los 4 traspasos alcanzables desde `origin`; `ESTADO.md` presente; árbol
  limpio; rama publicable.
- **Complejidad:** Alta. **Riesgo:** Alto.

### A-09 — Rescates menores
- **Cubre:** C-02, C-03. **Bloqueado por:** D-03.
- **Alcance:** un traspaso sin versionar en cada repo. Mismo patrón que A-08, sin la
  parte de rama ni de `ESTADO.md`.
- **Precaución heredada (A23):** verificar el working tree **completo** antes de
  commitear, no solo el archivo objetivo.
- **Éxito:** `traspasos_sin_versionar` en cero en ambos.
- **Complejidad:** Media. **Riesgo:** Medio.

### A-10 a A-16 — Ruta del comando único
- **Cubre:** E0 a E6, más O-07, O-08 y O-12.
- **Fuente:** `20260824_ruta_comando_unico.md`, que ya trae por encargo su objetivo,
  alcance, control negativo y criterio evaluable.
- **Nota de dependencia:** A-14 (E3, paso 7 de git) está bloqueado por D-01 y por
  A-07.

---

## 5. Secuencia propuesta, por sesión

| Sesión | Encargos | Por qué juntos | Tipo |
|---|---|---|---|
| 13 | A-01 (si no cerró), A-02, A-04 | Los tres cierran deuda documental del propio repo y dejan el verificador de cierre en verde. Ninguno toca código | CONTINUATION |
| 14 | A-03, A-06 | Ordenación y verificación de guarda: los dos son normativos, deterministas, y A-03 exige árbol limpio, que la sesión 13 deja | CONTINUATION |
| 15 | A-05, luego A-10 (E0) | Diagnóstico primero, arnés de log después. El arnés se instrumenta sobre un pipeline cuyos defectos ya están localizados | CONTINUATION |
| 16 | A-11 (E1), A-12 (E2) | Las dos correcciones de lectura, medidas contra la línea base que dejó E0 | CONTINUATION |
| 17 | A-08 | Rescate de `slep_rendimiento_historico`, solo | CONTINUATION dedicada |
| 18 | A-07, A-13 (E3) | Resolver el CSV y recién entonces el paso 7 de git, que es su consumidor | CONTINUATION |
| 19 | A-14 (E4), A-15 (E5) | Publicación y unificación del comando | CONTINUATION |
| 20 | A-16 (E6) | Prueba de aceptación de extremo a extremo | CONTINUATION |
| suelta | A-09 | Dos rescates menores, caben en cualquier sesión con autorización | oportunista |

Las decisiones D-01 a D-05 se pueden despachar en cualquier momento y no requieren
sesión propia: son cinco respuestas cortas que desbloquean cuatro encargos.

---

## 6. Qué queda fuera y por qué

- **C-04 y C-05** (migración de candado y ordenación en los 25 hermanos): no son
  encargos de este proyecto. El orquestador puede **hacerlos visibles** (eso es E2),
  pero ejecutarlos es trabajo de cada repo en su propia sesión, con su propia
  autorización. Un encargo que escriba en 20 repos ajenos concentra un riesgo que
  ninguna compuerta de este proyecto puede cubrir.
- **C-06** (`slep_paes`): la inconsistencia es de gobernanza de datos y se resuelve en
  ese repo, tras D-04.
- **C-07** (`tipo_pendiente` fuera de enum): el parche de la sesión 12 ya impide que
  tumbe el pipeline. La traducción en origen es de cada hermano; E2 la registra como
  evento y la hace visible.
- **C-08** (repos sin `.git` o sin `ESTADO.md`): depende de D-05, que es una pregunta
  sobre el universo, no sobre el código.
- **O-10** (reponer `CLAUDE.md`): tarea mecánica manual del titular. No se escribe un
  encargo para arrastrar un archivo.
