# Delta normativo de la knowledge base — revisión de la sesión 12

- **Proyecto:** `slep_estado_proyectos_monitoreo` (remoto: `tomgc/slep_estado_area_monitoreo`)
- **Fecha:** 2026-08-24
- **Alcance:** lectura íntegra de los dos documentos normativos de la knowledge base
  del Project, contra las versiones que el traspaso v11 cita (POLITICA v5.3,
  SETTINGS v8).
- **Versiones leídas, transcritas de su línea de encabezado** (SETTINGS §2.1, regla
  de cita de versión):
  - `> **Versión 5.8 — vigente.** Documento maestro único de arquitectura y`
  - `> **Versión 34.**`
- **Estado:** este archivo es un andamio de diagnóstico. No modifica ninguna regla.

---

## 0. Resumen en cinco líneas

1. La knowledge base **no está atrasada**: está 5 versiones (POLITICA) y 26
   versiones (SETTINGS) por delante de lo que el traspaso v11 asumía.
2. El cambio de mayor impacto es el **candado de cierre** (SETTINGS v31): el
   traspaso deja de ser un documento y pasa a ser una compuerta ejecutable de
   nueve invariantes.
3. Este proyecto **falla hoy** I1, I2, I3, I5, I6 e I9 de esos nueve.
4. Aparecen tres artefactos nuevos que este repo no tiene: `traspasos/archivo/`,
   `50_ordenacion_repositorio.md` y la línea `ventana_insumos` en `ESTADO.md`.
5. El `ESTADO.md` de la cartera **cambió de esquema**: siete campos nuevos que el
   pipeline de este proyecto (pasos 32-35) todavía no lee. Es la deuda que más
   directamente toca el producto de este repo.

---

## 1. POLITICA_PROYECTO.md — de v5.3 a v5.8

| Versión | Qué agrega | Toca este proyecto |
|---|---|---|
| v5.4 | Regla **0.6**, marcador de fuente en línea. Cuatro tipos de afirmación (archivo no leído, estado de repo, cifra, premisa de encargo) llevan `(fuente: ...)` o `(hipótesis, verificar con: ...)` en la misma línea | Sí, de forma transversal a toda sesión |
| v5.5 | (a) Regla **1.3.1**: `traspasos/` contiene exactamente un archivo, el vigente; el resto va a `traspasos/archivo/` con `git mv`. (b) §2 fija el prefijo `50_` en `activa/` con excepciones declaradas. (c) §7.2 excluye `node_modules/`, `packrat/`, `venv/` del escáner | **Sí, incumplida en tres frentes** |
| v5.6 | §**5.2bis**: invariante de locale UTF-8 por guarda `asegurar_locale_utf8()` en la primera línea ejecutable de `10_configuracion.R`. Entra al checklist de inicio §8.4 | Ya instalada en este repo (commits `8c1ef63`, `9dc9038`, `f49abec`) |
| v5.7 | §5.6 gana la **pregunta 9**: la guarda se verifica en apertura *y* en cierre, y exige haberla visto fallar | Sí; el "visto fallar" no consta |
| v5.8 | §2 declara `documentacion_tecnica_vN.md` como sexta excepción al prefijo `50_`; poda del encabezado | Menor |

### 1.1 Incumplimientos concretos de la regla 1.3.1 y de §2

Evidencia del turno de apertura (`ls 50_documentacion/traspasos/*.md | wc -l` = 11;
escáner del 2026-08-24 08:30):

- `50_documentacion/traspasos/` tiene **11** archivos donde el invariante exige 1.
- No existe `50_documentacion/traspasos/archivo/`.
- En `50_documentacion/activa/`, dos archivos sin prefijo `50_` que **no** están en
  la tabla de excepciones de §2: `esbozo_fase2_estado_estandarizado.md` y
  `reporte_cobertura_documental.md`. Antes de renombrarlos rige el grep obligatorio
  de §2 ("criterio general aplicable a casos futuros") y de SETTINGS §4.7.2 bloque 3.
- Sí están correctamente exceptuados y no se tocan: `ESTADO.md`,
  `backlog_acumulativo.md`, `POLITICA_PROYECTO.md`,
  `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.

### 1.2 Lo que NO cambió y conviene no re-discutir

`00_run_all.R` (§4), estructura canónica de decenas (§1.1), gobernanza de dos
raíces (§6), escáner con poda de retención 2 (§7.4) y documentación mínima (§10)
están igual que en v5.3. La arquitectura de este proyecto sigue conforme.

---

## 2. SETTINGS_Y_PROMPTS_OPERACIONALES.md — de v8 a v34

Veintiséis versiones. Se agrupan por lo que efectivamente cambia el trabajo.

### 2.1 Ola de apertura y cierre (v10-v13)

- **v10** consolida: absorbe los prompts sueltos de apertura, cierre, orquestador
  y migración. Los protocolos de sesión viven aquí; la arquitectura, en POLITICA.
- **v11** suma a §1.2.6 tres reglas permanentes: *fuente primaria de una estructura
  es su inspección* (no su descripción), *brevedad por forma* (topes de líneas por
  tipo de respuesta, con lista de construcciones prohibidas) y el corolario
  **GR-06b**: pegar contenido en el chat y pedir al titular que arme el archivo es
  violación, no atajo.
- **v12** (ola canónica del 2026-07-25) instala el **marcador de fuente S-01** y
  amplía la tabla de errores a diez campos, con `PAT-01` a `PAT-12`.
- **v13** hace del **archivado del traspaso anterior** un paso obligatorio del
  cierre, con su comprobación `vigentes=1`, y admite tres dígitos desde v100.

### 2.2 Gatillos de apertura (v14, v16)

- **v14** crea §**4.7 Ordenación del repositorio** (cuatro bloques, rama propia,
  termina en PR) y el paso **4bis** de §1.2.2: el gatillo se enciende mientras no
  exista `50_documentacion/activa/50_ordenacion_repositorio.md`.
- **v16** crea el paso **4ter**, gatillo del invariante de locale, apagado por
  `50_documentacion/activa/50_locale_utf8.md`.

Estado en este repo: **4bis encendido** (el marcador no existe), **4ter apagado**
(el marcador existe, 2.06K, escáner del 2026-08-24).

### 2.3 Cierre delegado a Claude Code (v17-v28)

El cierre deja de ser una cadena de pasos manuales y pasa a un canal único:

1. El asistente entrega **un solo archivo descargable**, `paquete_cierre_vNN.md`,
   con front matter y tres bloques (TRASPASO, BACKLOG_DELTA, ESTADO).
2. El titular lo guarda en `50_documentacion/andamios/` y escribe `/cierre` en
   Claude Code, abierto en la raíz del repo.
3. Claude Code ejecuta el instrumento
   `herramientas_dev/prompts/cierre_sesion_autonomo_cc_v10.md`.

Los pasos manuales del titular son exactamente cuatro: instruir, guardar la
descarga, escribir `/cierre`, copiar la reapertura. Quedan **derogados** el payload
pegado en chat (v1) y el gatillo por sesión.

**Regla de oro del payload:** el paquete lleva solo lo que únicamente un humano
puede decidir. El asistente no escribe cifras que un script puede contar, ni pares
buscar→reemplazar, ni rótulos stale: declara magnitudes en el front matter y el
ejecutor las verifica contra disco. `push_autorizado` es `si` por defecto desde v28.

### 2.4 Compuertas de cierre (v26, v29, v31-v34) — el cambio de mayor peso

**Compuerta de dudas** (v26, obligatoria y previa al paquete): inventario de lo que
se dio por bueno sin medirlo, con filtro de tres campos (`supuesto`, `predicado`,
`medicion`). Una duda que no admite los tres campos se descarta, no se registra. Su
vacío se declara explícitamente. Desde v29 el paquete lleva `compuerta_dudas` y
`settings_version` en el front matter, y el ejecutor detiene el cierre si no calzan.

**Compuerta de repositorio** (v31, bloqueante y **primera** de las dos). Se ejecuta:

```bash
Rscript "$HERRAMIENTAS_DEV_PATH/plantillas/95_verificar_cierre.R" <ruta_del_proyecto>
```

Nueve invariantes, con el estado medido de este repo al abrir la sesión 12:

| Id | Invariante | Estado aquí |
|---|---|---|
| I1 | Árbol de trabajo limpio | **FALLA** (8 modificados, 4 borrados, 8 sin seguimiento) |
| I2 | Sin stash pendiente | **FALLA** (`stash@{0}`) |
| I3 | `0 detrás, 0 adelante` contra `origin` | **FALLA** (10 commits detrás) |
| I4 | Rama publicable | Pasa (`main`) |
| I5 | Un solo traspaso vigente, versionado | **FALLA** (11 archivos; v10 y v11 sin versionar) |
| I6 | `ESTADO.md` con los campos de candado | **FALLA** (esquema pre-candado) |
| I7 | Escáner corrido en este cierre, sellado idéntico al alias | Por verificar al cerrar |
| I8 | Ningún archivo de datos versionado | Por verificar (`registro_proyectos.csv` es insumo versionado; ver §3.3) |
| I9 | `ventana_insumos` resuelve por al menos una entrada | **FALLA** (llave ausente) |

**Salida única declarada:** si algo impide cumplir un invariante, el cierre procede
declarándolo en `ESTADO.md`, campo `cierre_incompleto: <razón en una frase>`, y
repitiéndolo en el traspaso. La apertura siguiente lo trata como bloqueante.

**Enmiendas posteriores, que importan porque evitan repetir errores ajenos:**

- **v32**: `commit_cierre` pasa de igualdad a **ascendencia** respecto del `HEAD` de
  `origin`. La igualdad era irrealizable por construcción (el campo viaja dentro del
  commit que describiría) y costó al menos una apertura de emergencia. También
  corrige el enunciado de I7: mide el sello y la identidad sellado/alias, **no** que
  el retrato describa el árbol vivo. La brecha queda declarada, con medida
  compensatoria de orden (el escáner es el último acto que toca el árbol).
- **v33**: I9 deja de suponer dónde viven los insumos. Cada proyecto declara
  `ventana_insumos` en `ESTADO.md`, con entradas `TOKEN[/subruta]` donde `TOKEN` es
  `.` o el **nombre** de una variable de entorno. El valor nunca se imprime.
- **v34**: varias entradas de `ventana_insumos` son una **precedencia, no una
  conjunción**: basta que una resuelva con contenido. Los defectos de la declaración
  (llave ausente, entrada con `..`, primer token inválido) son falla siempre; los
  del estado de la máquina, solo si le ocurren a todas.

Principio que la v32 y la v33 repiten palabra por palabra, y que conviene tener a
mano al diseñar cualquier chequeo de este orquestador:

> Un invariante que pasa mientras la condición que dice proteger está ausente es
> peor que un invariante ausente, porque produce confianza.

### 2.5 `ESTADO.md`: el esquema cambió (§2.1bis)

Es el punto donde el delta normativo deja de ser gobernanza y pasa a ser
**requisito de producto** de este repo, porque `ESTADO.md` es su insumo de lectura.

Campos del front matter en v34, con los **siete nuevos** marcados:

| Campo | Nuevo | Nota |
|---|---|---|
| `slug`, `nombre_real`, `categoria`, `semaforo` | | Sin cambios |
| `sesion_actual`, `ultima_actividad` | | Sin cambios |
| `maneja_sensibles`, `tipo_pendiente` | | Sin cambios |
| `sesion_abierta` | ● | Candado. `true` al abrir, en commit propio pusheado de inmediato |
| `maquina` | ● | Candado. Hostname de la estación |
| `commit_cierre` | ● | Candado. Debe ser **ancestro** del `HEAD` de `origin` |
| `traspaso_vigente` | ● | Candado. `traspaso_cierre_vNN.md` |
| `cierre_incompleto` | ● | Candado. `no` o la razón en una frase |
| `insumos_verificados` | ● | Candado. `AAAA-MM-DD` |
| `ventana_insumos` | ● | **No** es campo de candado, pero I9 falla sin él |

El `ESTADO.md` de este proyecto declara nueve campos y le faltan los siete. Además
está desincronizado por contenido: `sesion_actual: v06` y
`ultima_actividad: 2026-07-01` frente al traspaso vigente v11 del 2026-07-10.

### 2.6 Tabla de errores del asistente (§2.2.15)

De siete campos a **diez**: se suman `gatillo_observable` (con vocabulario
controlado de doce etiquetas), `intentos_previos` y `costo` (en unidad observable,
nunca adjetivos). El catálogo de patrones está **incrustado** en el documento
(`PAT-01` a `PAT-13`): ya no hay que pedirlo adjunto. Los registros anteriores con
siete campos siguen válidos y no se re-registran.

Nueva §**2.2.17**, registro de fricciones: una línea, formato
`friccion: <qué molestó> → <qué se ajustó>`, sin tabla y sin análisis.

Nueva §**2.2.16**: antes de reformular una regla reincidente hay que clasificar el
tipo de falla (disciplina / forma del output / omisión / condición ambigua), porque
endurecer una prohibición solo corrige la primera.

### 2.7 Apertura (§1.2.2): dos pasos nuevos antes de leer

- **Punto 0bis**, verificación del candado con `git fetch` previo: `sesion_abierta`
  en `false`, `cierre_incompleto` en `no`, `commit_cierre` ancestro del `HEAD` de
  `origin`, árbol limpio. Alguna falla y se va a §1.2.8.
- **§1.2.8, apertura de emergencia**: no tocar el árbol, fotografiar, reconstruir
  qué quedó a medias, declarar en el acuse, cerrar el hueco y recién entonces
  abrir. Nunca con `push --force` ni descartando commits ajenos.

Es exactamente el camino que tomó esta sesión.

### 2.8 Cambio en qué se adjunta al abrir (§2.2.14)

Desde la v20 rige **apertura liviana**: el backlog **no** se adjunta (su último
número viaja en el traspaso y el cierre lo verificó contra disco) y el escáner no se
adjunta por defecto. Si la apertura necesita un dato de cualquiera de los dos, se
pide **ese dato puntual**, no el archivo.

---

## 3. Obligaciones concretas que este delta impone al proyecto

### 3.1 Como repositorio de la cartera (lo que debe cumplir)

| # | Obligación | Norma | Estado |
|---|---|---|---|
| O1 | Árbol limpio, sin stash, sincronizado con `origin` | §2.1, I1-I3 | Pendiente (P1 de la ruta) |
| O2 | Un solo traspaso a la vista, con `traspasos/archivo/` | POLITICA 1.3.1; §2.1, I5 | Pendiente |
| O3 | Siete campos de candado en su propio `ESTADO.md` | §2.1bis; §2.1, I6 | Pendiente |
| O4 | Línea `ventana_insumos` en su `ESTADO.md` | §2.1, I9 | Pendiente |
| O5 | `50_ordenacion_repositorio.md` depositado | §1.2.2 4bis; §4.7.3 punto 7 | Pendiente (gatillo encendido) |
| O6 | Prefijo `50_` en los dos archivos de `activa/` fuera de patrón | POLITICA §2 | Pendiente, con grep previo obligatorio |
| O7 | Guarda de locale "vista fallar" | POLITICA §5.6 pregunta 9 | Instalada; verificación adversaria no consta |
| O8 | Cierre por paquete descargable + `/cierre` | §2.1 | Aplica al cierre de **esta** sesión |

### 3.2 Como orquestador de la cartera (lo que debe leer de los demás)

Esta es la parte que ninguna otra sesión de la cartera puede hacer, y es la razón
de existir de este repo.

- **O9.** Los pasos `33_extraer_metadatos.R` y `35_compilar_panorama.R` fueron
  escritos contra el `ESTADO.md` de SETTINGS v5. Hay siete campos nuevos que hoy no
  se leen. *(Hipótesis sobre el contenido de esos scripts, verificar con: lectura de
  `30_procesamiento/33_extraer_metadatos.R` y `35_compilar_panorama.R`.)*
- **O10.** El propio SETTINGS v34 declara, en su encabezado, que los campos de
  candado **siguen sin propagarse a la cartera** y que por eso I6 queda rojo en todo
  proyecto. Es una deuda declarada de la v33 que este orquestador está en posición
  privilegiada de hacer visible: un panorama que muestre, por hermano, si su
  `ESTADO.md` tiene candado y ventana convierte una deuda invisible en una lista de
  trabajo.
- **O11.** El invariante I5 (un solo traspaso vigente) es medible desde aquí para
  los 21 hermanos con un `ls | wc -l` por repo, sin abrir ninguna sesión.

### 3.3 Punto a resolver, no a asumir

`20_insumos/registro_proyectos.csv` está versionado y el pipeline lo **escribe**
(paso 31). Choca de frente con dos reglas: POLITICA §1.3 punto 5 (`20_insumos/` es
read-only) e I8 (ningún archivo de datos versionado). No es un hallazgo nuevo de
esta ola y no se resuelve de paso: se declara aquí para que la próxima auditoría no
lo re-descubra como si fuera novedad. Las tres salidas posibles son declararlo
excepción por escrito, moverlo a `40_salidas/` (arrastra cambios en 31 y en el
lector), o dejar de versionarlo (pierde la curaduría manual de `nombre_real`).

---

## 4. Riesgo de integración detectado en el remoto

Entre los diez commits que este repo tiene sin integrar hay uno que contradice el
estado local: `e24bceb fix(gobernanza): los normativos no se versionan en repo
publico` (fuente: `git log HEAD..origin/main --oneline` del 2026-08-24). Al mismo
tiempo, la copia local de `50_documentacion/activa/POLITICA_PROYECTO.md` y de
`SETTINGS_Y_PROMPTS_OPERACIONALES.md` tiene 947 inserciones sin commitear (fuente:
`git diff --stat` del mismo turno), que corresponden a la actualización a v5.8 y
v34.

Las dos cosas no pueden ser ciertas a la vez. Antes de integrar hay que leer qué
hizo `e24bceb`: si eliminó los normativos del árbol, el `git pull` intentará
borrarlos y las 947 inserciones locales quedan en conflicto. La resolución correcta
depende de si la decisión de la cartera fue **no versionarlos** (viven solo en la
knowledge base) o **versionarlos solo en repos privados**. No se decide aquí.

---

## 5. Qué NO se hizo en esta revisión

- No se leyó `herramientas_dev/prompts/cierre_sesion_autonomo_cc_v10.md` ni
  `plantillas/95_verificar_cierre.R`: viven fuera de la knowledge base y SETTINGS
  §2.1 declara explícitamente que el instrumento **no es insumo del redactor**.
- No se leyó §4.6 (`suitedoc`) en detalle: no aplica al foco de esta sesión.
- No se verificó ninguna afirmación sobre el contenido de los scripts del pipeline:
  las que aparecen aquí van marcadas como hipótesis con su comando de verificación.
