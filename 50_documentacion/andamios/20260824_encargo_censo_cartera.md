# Encargo — Censo de solo lectura de la cartera

**Estado documental, candado de cierre, integridad de traspasos y decisiones**

- **Proyecto emisor:** `slep_estado_proyectos_monitoreo`
- **Raíz del emisor:** `/Users/tomgc/Projects/slep_estado_proyectos_monitoreo`
- **Universo observado:** los directorios `slep_*` de `/Users/tomgc/Projects/`
- **Fecha de emisión:** 2026-08-24
- **Sesión:** 12
- **Naturaleza:** diagnóstico de **solo lectura**. No repara, no propone, no
  interpreta. Mide y reporta.

---

## 0. Para qué existe este encargo

Tres decisiones dependen de sus cifras y ninguna puede tomarse sin ellas:

1. **Migración de la cartera al esquema de `ESTADO.md` de SETTINGS v34.** El
   encabezado de la propia v34 declara que los campos de candado siguen sin
   propagarse y que por eso el invariante I6 queda rojo en toda la cartera. Nadie
   ha medido cuántos hermanos están en qué punto.
2. **Detección temprana de la patología de cierre cortado.** En la sesión 11 se
   descubrió que `slep_reportes_modelo_resguardo_asistencia` tiene dos traspasos
   sin versionar y una sesión cortada a mitad de cierre, con riesgo de pérdida
   irreversible. Se descubrió por casualidad, mirando un repo. Este censo hace la
   misma pregunta a los veintidós de una sola vez.
3. **Diseño de la exposición de los documentos de decisión** en el panorama de
   cartera. Hoy no se sabe cuántos hermanos tienen `decisiones/`, con qué
   nomenclatura ni con qué estructura interna.

Un cuarto objetivo, transversal: obtener una **línea base reproducible**. La salida
en CSV existe para que una corrida futura se compare con esta por `diff` y no por
lectura.

---

## 1. Contrato de ejecución

### 1.1 Invariantes candados (violarlos invalida la corrida)

1. **Dos escrituras, y solo dos.** Los únicos archivos que este encargo crea son:
   - `50_documentacion/andamios/20260824_censo_cartera.md`
   - `50_documentacion/andamios/20260824_censo_cartera.csv`

   ambos bajo la raíz del emisor, más el directorio temporal del autotest, que vive
   en `/tmp` y se borra al terminar. Ningún otro byte del disco cambia.

2. **Cero git mutante.** Prohibidos `add`, `commit`, `push`, `pull`, `fetch`,
   `checkout`, `switch`, `stash`, `restore`, `reset`, `revert`, `merge`, `rebase`,
   `mv`, `rm`, `clean`, `gc`, `prune`, y todo comando de `gh` que escriba.

   *Por qué se prohíbe incluso `fetch`:* el repo emisor está en apertura de
   emergencia con diez commits sin integrar. Un `fetch` no rompe nada por sí mismo,
   pero mueve las referencias remotas y con eso cambia el resultado de las columnas
   `adelante` y `detras` a mitad de censo, destruyendo la comparabilidad entre filas
   medidas antes y después. La corrida se hace contra una foto estática y su
   desactualización se **declara** en el encabezado del informe.

3. **Cero R y cero pipeline.** No ejecutar `run_all()`, ni `source()` de ningún
   script del proyecto, ni `Rscript`. `run_all(only = 1)` reescribe
   `20_insumos/registro_proyectos.csv` como efecto colateral, y un diagnóstico que
   muta su objeto de estudio no es un diagnóstico.

4. **Cero escritura en repos hermanos.** La autorización para escribir en un repo
   hermano es explícita del titular, por repo y por operación, y aquí no existe para
   ninguno.

5. **La raíz de datos no se toca.** Este censo mira `/Users/tomgc/Projects/` y nada
   más. Nunca OneDrive, nunca el data root de ningún proyecto.

6. **Nunca imprimir valores de variables de entorno.** Si un `ventana_insumos`
   nombra una variable, se transcribe el **nombre declarado**, jamás su valor
   resuelto (POLITICA §7.2).

7. **Nunca rutas absolutas del titular en el cuerpo de las salidas.** Ninguna cadena
   `/Users/tomgc` puede aparecer en los dos archivos. Las rutas se escriben
   relativas al directorio de cada repo.

8. **Nunca inventar una celda.** Vocabulario cerrado para lo que no se pudo medir:

   | Valor | Significado |
   |---|---|
   | `AUSENTE` | la llave o el archivo no existe |
   | `VACIO` | la llave existe y su valor está en blanco |
   | `SIN_FRONT_MATTER` | el archivo existe pero no abre con `---` en la línea 1 |
   | `n/d` | la medición falló; la causa va obligatoriamente a anomalías |

   Un valor no se infiere jamás por analogía con otro repo ni por lo que "debería"
   ser.

9. **Sin datos personales.** Ningún RUT, nombre de persona, correo ni nombre de
   establecimiento educacional en las salidas. Si un título de decisión contiene
   uno, se reporta el nombre del archivo y el título se sustituye por
   `[titulo omitido por gobernanza]`.

### 1.2 Reglas de detención

**Detención dura.** No se escribe ninguna salida y se reporta el motivo:

- **D1.** El paso 2 encuentra un número de directorios `slep_*` fuera del rango
  `[20, 24]`. El universo declarado es 21 hermanos más el orquestador (fuente:
  `traspaso_cierre_v11.md` §12, instrucción 🔒). Fuera de ese rango la premisa del
  encargo dejó de ser válida, y quien decide es el titular.
- **D2.** Cualquiera de los ocho casos del autotest del paso 8 falla. Un extractor
  que no demuestra que detecta lo que dice detectar entrega OK sin haber medido
  nada.
- **D3.** Las verificaciones del paso 9 detectan más archivos tocados que los dos
  declarados.

**Degradación blanda.** Se continúa, se marca la celda y se registra la anomalía: un
repo sin `.git`, sin `50_documentacion/`, con `ESTADO.md` ilegible, con permisos
denegados, o con una grafía de traspaso no reconocida. El censo de veintidós repos
no se aborta por uno.

---

## 2. Universo

```bash
cd /Users/tomgc/Projects
ls -d slep_*/ 2>/dev/null | sed 's:/$::' | sort
```

Guarda la lista y su cardinalidad. Aplica D1. Esta lista es el universo para todo el
resto del encargo: ningún paso posterior lo amplía ni lo reduce.

Marca cuál es el **emisor** (`slep_estado_proyectos_monitoreo`). Se censa igual que
los demás, pero se identifica como tal en el informe: su árbol sucio es conocido y
no es un hallazgo nuevo.

---

## 3. Extractor de front matter (especificación única)

Todas las lecturas de `ESTADO.md` usan **este** extractor. No se usa `grep` suelto
sobre el archivo completo: una llave que aparezca en el cuerpo en prosa produciría
una lectura falsa, y el front matter es lo único que este censo mide.

```bash
fm_get() {
  # $1 = ruta del archivo, $2 = nombre de la llave
  # Imprime el valor, o nada si la llave no esta en el front matter.
  # Sale con codigo 2 si el archivo no abre con --- en la linea 1.
  awk -v k="$2" '
    NR==1 { if ($0 != "---") { exit 2 } ; next }
    $0 == "---" { exit 0 }
    {
      i = index($0, ":")
      if (i == 0) next
      key = substr($0, 1, i-1)
      gsub(/^[ \t]+|[ \t]+$/, "", key)
      if (key != k) next
      val = substr($0, i+1)
      sub(/[ \t]+#.*$/, "", val)
      gsub(/^[ \t]+|[ \t]+$/, "", val)
      gsub(/^"|"$/, "", val)
      print val
      exit 0
    }
  ' "$1"
}
```

Interpretación del resultado, sin excepciones:

| Situación | Celda |
|---|---|
| `awk` sale con código 2 | `SIN_FRONT_MATTER` |
| El archivo no existe | `AUSENTE` |
| Sin salida y el archivo tiene front matter | `AUSENTE` |
| Salida vacía | `VACIO` |
| Salida con contenido | el valor, recortado a 120 caracteres |

El delimitador de cierre es la **primera** línea exactamente igual a `---` después
de la línea 1. Todo lo posterior es cuerpo y no se lee.

---

## 4. Recolección por repositorio

Para cada `<repo>` del universo, con el directorio de trabajo en
`/Users/tomgc/Projects/<repo>`.

### 4.1 Identidad y estado del repositorio

| Campo | Medición |
|---|---|
| `repo` | nombre del directorio local |
| `remoto` | `git remote get-url origin`, quedándote con el último segmento sin `.git`; `sin-remoto` si no hay; `n/d` si no es repo git |
| `alineado` | `si` si `remoto` es idéntico a `repo`; `no` si difiere |
| `rama` | `git rev-parse --abbrev-ref HEAD` |
| `sucio` | `git status --porcelain \| wc -l` |
| `stash` | `git stash list \| wc -l` |
| `ref_usada` | ver nota de upstream |
| `adelante` | `git rev-list --count <ref_usada>..HEAD` |
| `detras` | `git rev-list --count HEAD..<ref_usada>` |

**Desalineaciones ya resueltas por decisión formal.** Tres casos son deuda aceptada
y **no** son hallazgo: `slep_georreferenciacion` (proyecto cerrado), el emisor
(ancla del sistema, remoto `slep_estado_area_monitoreo`) y `slep_lectoescritura`
(alineado por `gh repo rename` en la sesión 11). Los tres se marcan
`no (aceptada)`. Cualquier **cuarta** desalineación sí es hallazgo y va a anomalías.

**Nota de upstream.** Resolver en este orden y declarar cuál se usó en `ref_usada`:
(1) el upstream configurado de la rama actual, `@{u}`; (2) `origin/HEAD`; (3)
`origin/main`; (4) si ninguno resuelve, `adelante` y `detras` van `n/d` y
`ref_usada` va `AUSENTE`. Sin `fetch` previo, por el invariante 1.1.2.

### 4.2 `ESTADO.md` — dieciséis llaves

Ruta: `50_documentacion/activa/ESTADO.md`.

- **Bloque heredado** (esquema de SETTINGS v5): `slug`, `nombre_real`, `categoria`,
  `semaforo`, `sesion_actual`, `ultima_actividad`, `maneja_sensibles`,
  `tipo_pendiente`.
- **Bloque de candado** (SETTINGS v31): `sesion_abierta`, `maquina`,
  `commit_cierre`, `traspaso_vigente`, `cierre_incompleto`, `insumos_verificados`.
- **Bloque de ventana** (SETTINGS v33/v34): `ventana_insumos`.
- **Extra:** `rama_publicable`, opcional; si existe, sustituye a `origin/HEAD` como
  referencia publicable del proyecto y por tanto cambia la evaluación de I4.

**Generación de esquema inferida** (columna `esquema`), por presencia de llaves y no
por lo que el proyecto declare de sí mismo:

| Valor | Condición |
|---|---|
| `v33+` | los seis de candado presentes **y** `ventana_insumos` presente |
| `v31` | los seis de candado presentes, `ventana_insumos` ausente |
| `parcial` | entre uno y cinco campos de candado presentes |
| `v5` | ningún campo de candado, pero el bloque heredado existe |
| `sin_estado` | no hay `ESTADO.md` |

Más `n_candado`: entero de 0 a 6.

### 4.3 Traspasos e integridad del historial de cierres

Ambas grafías son legales y ambas se buscan siempre. Expresión canónica de
reconocimiento:

```
traspaso[_-]cierre[_-]v([0-9]{2,3})\.md
```

Nunca un glob que cubra solo una de las dos formas.

| Campo | Medición |
|---|---|
| `traspasos_a_la_vista` | los que calzan en `50_documentacion/traspasos/`, sin descender a `archivo/` |
| `traspasos_archivados` | los que calzan en `50_documentacion/traspasos/archivo/` |
| `tiene_carpeta_archivo` | `si`/`no` |
| `traspaso_max` | el `vNN` numéricamente mayor entre las dos carpetas |
| `traspaso_max_ubicacion` | `vista` o `archivo` |
| `grafia_no_canonica` | cuántos usan guión medio; la canónica es guión bajo |
| `traspasos_sin_versionar` | `git status --porcelain 50_documentacion/traspasos/ \| grep -c '^??'` |
| `huecos` | números faltantes en el rango `[min, max]` de los `vNN` hallados; `ninguno` si la serie es continua |
| `i5` | `PASA` si `traspasos_a_la_vista` es exactamente 1; `FALLA` en cualquier otro caso |

`traspasos_sin_versionar` mayor que cero es el **indicador de riesgo de pérdida
irreversible** de este censo: un cierre que existe en un solo disco. Es la señal que
en la sesión 11 apareció en un repo y por casualidad.

`huecos` distinto de `ninguno` merece atención distinta: puede ser un traspaso
perdido, o una numeración que arrancó en un punto arbitrario. No lo interpretes;
repórtalo.

### 4.4 Desincronización de `ESTADO.md`

Criterio robusto (aprendizaje A22 del traspaso v11): la comparación es entre
`sesion_actual` y la `vNN` del último traspaso. **Nunca** contra el `mtime` del
archivo, que se altera por operaciones de filesystem sin que haya habido cierre.

| `desync` | Condición |
|---|---|
| `no` | `sesion_actual` normalizada igual a `traspaso_max` |
| `si` | `sesion_actual` menor que `traspaso_max`; reporta el delta |
| `adelantado` | `sesion_actual` mayor que `traspaso_max`; va también a anomalías |
| `n/d` | falta cualquiera de los dos |

Normalización: `sesion_actual` puede venir como `v06`, `6`, `v6` o `s26`. Extrae el
primer grupo de dígitos y compara como entero. Sin dígitos, `n/d`.

Complemento: `ultima_actividad` frente a la fecha declarada **dentro** del traspaso
vigente (`grep -m1 -iE '^\- \*\*Fecha' ` o la primera fecha `AAAA-MM-DD` de sus
primeras cuarenta líneas). Si difieren, columna `fecha_discrepante` en `si`. Es
información, no veredicto.

### 4.5 Invariantes de cierre medibles desde fuera

Ocho de los nueve invariantes de SETTINGS §2.1 son observables sin abrir sesión.
Repórtalos como `PASA` / `FALLA` / `n/d`, sin juicio y sin recomendación.

| Id | Enunciado abreviado | Medición externa |
|---|---|---|
| I1 | Árbol limpio | `sucio` igual a 0 |
| I2 | Sin stash | `stash` igual a 0 |
| I3 | Cero adelante, cero detrás | ambas en 0 |
| I4 | Rama publicable | `rama` igual a `main`, o a `rama_publicable` si el `ESTADO.md` la declara |
| I5 | Un solo traspaso vigente | ver 4.3 |
| I6 | Campos de candado | `n_candado` igual a 6 |
| I7 | Escáner del cierre, sellado idéntico al alias | ver 4.6 |
| I8 | Ningún archivo de datos versionado | ver 4.7 |
| I9 | Ventana de insumos declarada | ver 4.8 |

Columna resumen `invariantes_pasa`, de la forma `N/8`.

**Advertencia obligatoria, literal, en el encabezado de la tabla:** estas columnas
son una **aproximación externa** y no la compuerta. La compuerta real la ejecuta
`plantillas/95_verificar_cierre.R` dentro del cierre de cada proyecto, y mide
condiciones que este censo no puede ver. Un `PASA` aquí no autoriza a nadie a
saltarse esa corrida.

### 4.6 I7, con el alcance que la norma le reconoce

SETTINGS v32 corrigió el enunciado de I7: mide que el sello del snapshot sea del
cierre y que el par sellado/alias sea idéntico, **no** que el retrato describa el
árbol vivo. La v32 nombra además la comprobación manual que sí cierra esa brecha, y
este censo la ejecuta porque puede hacerlo sin escribir nada.

En `50_documentacion/estructura/`:

| Campo | Medición |
|---|---|
| `sello_reciente` | el mayor `YYYYMMDD_HHMMSS` entre los archivos que calzan `^[0-9]{8}_[0-9]{6}_estructura\.(txt\|md)$` |
| `par_identico` | `cmp -s` del sellado `.md` más reciente contra `estructura_actual.md`, y lo mismo para `.txt`; `si` solo si ambos coinciden |
| `snapshots_retenidos` | cuántos timestamps distintos hay; la política §7.4 fija retención 2, y más de 2 es deuda de poda |
| `retrato_obsoleto` | número de archivos **trackeados** con `mtime` posterior al `mtime` del snapshot sellado más reciente, excluyendo `.git/` y los propios archivos de `50_documentacion/estructura/` |

`retrato_obsoleto` mayor que cero es exactamente la condición que I7 **no** detecta
y que la v32 dejó declarada como brecha abierta. Medirla aquí es el aporte propio de
este censo a un invariante que la cartera entera da por bueno.

Medición sugerida para el último punto, sin recorrer árboles ajenos:

```bash
git ls-files -z | xargs -0 stat -f '%m %N' 2>/dev/null
```

comparando contra el `mtime` del snapshot. En macOS `stat` usa `-f`; si el entorno
de ejecución difiere, ajusta y **declara el ajuste** en anomalías.

### 4.7 I8 y gobernanza de datos

| Campo | Medición |
|---|---|
| `datos_versionados` | `git ls-files \| grep -Eic '\.(csv\|xlsx\|xls\|parquet\|rds\|sav\|dta\|sqlite\|db\|feather)$'` |
| `datos_versionados_lista` | hasta cinco rutas relativas de ejemplo, más el excedente si lo hay |
| `tiene_gobernanza` | existe `50_documentacion/activa/gobernanza_datos.md` |
| `coherencia_gobernanza` | ver tabla |

| `coherencia_gobernanza` | Condición |
|---|---|
| `ok` | `maneja_sensibles: true` con el documento presente, o `false` sin él |
| `falta_documento` | `maneja_sensibles: true` y no existe `gobernanza_datos.md`; POLITICA §10 lo declara obligatorio |
| `documento_huerfano` | `maneja_sensibles: false` y sí existe el documento |
| `n/d` | falta `ESTADO.md` |

Cuando exista `gobernanza_datos.md`, extrae las **tres primeras** líneas que
contengan, sin distinguir mayúsculas ni tildes, alguna de las cadenas `categor`,
`sensible`, `NNA` o `21.719`, recortadas a 120 caracteres. Sirven para cruzar contra
`maneja_sensibles` sin abrir el documento entero. Si alguna contiene un nombre
propio de persona o de establecimiento, se omite por el invariante 1.1.9.

**Caso conocido, que se mide igual y no se resuelve aquí:** `slep_paes` tiene una
inconsistencia declarada entre su `ESTADO.md` y su `gobernanza_datos.md` sobre la
categoría de datos, y es la que bloquea la re-destilación de su estado. Repórtala
como una fila más.

### 4.8 Ventana de insumos, con las dos familias de falla separadas

SETTINGS v34 distingue defectos **de la declaración** (falla siempre) de defectos
**del estado de la máquina** (falla solo si le ocurre a todas las entradas), y la
distinción importa porque piden acciones distintas. Este censo **no** resuelve
variables de entorno ni comprueba existencia de directorios: eso es del verificador,
y hacerlo aquí implicaría leer fuera del universo autorizado. Solo clasifica la
**declaración**.

| `ventana_diagnostico` | Condición |
|---|---|
| `ausente` | la llave no está; falla siempre; la migración es de una línea |
| `vacia` | la llave está sin valor; falla siempre |
| `entrada_invalida` | alguna entrada contiene `..`, o su primer token no es `.` ni calza `^[A-Z_][A-Z0-9_]*$` |
| `declarada` | todas las entradas están bien formadas |

Más `n_entradas`, contando por comas.

### 4.9 Marcadores de gatillo y nomenclatura de `activa/`

| Campo | Medición |
|---|---|
| `ordenacion` | existe `50_documentacion/activa/50_ordenacion_repositorio.md`; apaga el gatillo 4bis |
| `locale_marcador` | existe `50_documentacion/activa/50_locale_utf8.md`; apaga el gatillo 4ter |
| `locale_guarda` | `grep -rl asegurar_locale_utf8 10_utils 2>/dev/null \| wc -l` |
| `backlog` | existe `50_documentacion/activa/backlog_acumulativo.md` |
| `activa_fuera_de_patron` | cuántos `.md` de `activa/` no empiezan con `50_`, no empiezan con ocho dígitos, y no están en la lista de excepciones |
| `activa_fuera_de_patron_lista` | sus nombres |
| `version_politica_local` | `grep -m1 -i 'versi'` de la copia local de `POLITICA_PROYECTO.md`, recortado a 100 caracteres; `AUSENTE` si no hay copia |
| `version_settings_local` | ídem para `SETTINGS_Y_PROMPTS_OPERACIONALES.md` |

`locale_marcador` y `locale_guarda` se reportan por separado a propósito: el marcador
es un proxy y la guarda es el riesgo. SETTINGS §1.2.2 4ter exige la segunda como
evidencia, precisamente porque medir el proxy es el patrón PAT-13.

Lista de excepciones declaradas por POLITICA §2, cerrada en seis: `ESTADO.md`,
`gobernanza_datos.md`, `backlog_acumulativo.md`, `POLITICA_PROYECTO.md`,
`SETTINGS_Y_PROMPTS_OPERACIONALES.md`, y cualquier `documentacion_tecnica_v*.md`.

### 4.10 Decisiones

Directorio: `50_documentacion/activa/decisiones/`.

Agregados por repo:

| Campo | Medición |
|---|---|
| `n_decisiones` | archivos `.md`; `0` si el directorio no existe |
| `decisiones_fuera_de_patron` | cuántas no calzan `^[0-9]{8}_decision_.+\.md$` |
| `decision_mas_antigua` / `decision_mas_reciente` | por el prefijo de fecha, cuando lo tengan |

Ficha por **cada** archivo de decisión:

1. `archivo` — nombre, sin ruta.
2. `fecha` — del prefijo `YYYYMMDD`, o `AUSENTE`.
3. `tema` — el resto del nombre tras `_decision_`, sin extensión, o `n/d`.
4. `titulo` — el primer encabezado (`grep -m1 '^#'`), sin almohadillas, recortado a
   120 caracteres.
5. `lineas` — `wc -l`.
6. `tiene_alternativas`, `tiene_justificacion`, `tiene_implicancia` — `si`/`no`,
   buscando en todo el archivo, sin distinguir mayúsculas ni tildes, las cadenas
   `alternativa`, `justificac` e `implicanc`.
7. `enlazada_desde_estado` — `si` si el nombre del archivo aparece citado en el
   `ESTADO.md` del mismo repo.

**No resumas el contenido de ninguna decisión.** El objetivo es el catálogo, no la
síntesis: leer el cuerpo más allá de los grep declarados está fuera de alcance.

Los tres `si`/`no` del punto 6 miden la estructura que POLITICA §10 pide ("una
decisión por archivo, autocontenida, con alternativas y justificación") y que
SETTINGS §2.2 punto 8 amplía con la implicancia. Son una medición de **forma**: no
emitas juicio sobre la calidad de ninguna decisión.

---

## 5. Salida A — informe legible

`50_documentacion/andamios/20260824_censo_cartera.md`

Secciones, en este orden:

1. **Encabezado.** Fecha y hora de la corrida, hostname, cardinalidad del universo, y
   las **dos advertencias obligatorias**: que `adelante` y `detras` se midieron sin
   `fetch`, contra las refs presentes en disco; y que las columnas `I1`-`I9` son una
   aproximación externa que no sustituye la corrida de `95_verificar_cierre.R`.
2. **Resumen ejecutivo, solo cifras.** Sin adjetivos y sin recomendaciones: cuántos
   repos, con `ESTADO.md`, por generación de esquema, con `ventana_insumos`, con
   traspasos sin versionar, con más de un traspaso a la vista, con árbol sucio, con
   stash, con decisiones, y el reparto de `invariantes_pasa`.
3. **Tabla A — Estado y candado.** `repo`, `tiene_estado`, `esquema`, `n_candado`,
   `sesion_actual`, `traspaso_max`, `desync`, `fecha_discrepante`, `sesion_abierta`,
   `commit_cierre`, `traspaso_vigente`, `cierre_incompleto`, `insumos_verificados`,
   `ventana_diagnostico`.
4. **Tabla B — Higiene e invariantes.** `repo`, `remoto`, `alineado`, `rama`,
   `ref_usada`, `sucio`, `stash`, `adelante`, `detras`, `traspasos_a_la_vista`,
   `traspasos_archivados`, `traspasos_sin_versionar`, `huecos`, `I1` a `I9`,
   `invariantes_pasa`.
5. **Tabla C — Gobernanza y marcadores.** `repo`, `maneja_sensibles`,
   `tiene_gobernanza`, `coherencia_gobernanza`, `datos_versionados`, `ordenacion`,
   `locale_marcador`, `locale_guarda`, `backlog`, `activa_fuera_de_patron`,
   `version_politica_local`, `version_settings_local`.
6. **Tabla D — Escáner, detalle de I7.** `repo`, `sello_reciente`, `par_identico`,
   `snapshots_retenidos`, `retrato_obsoleto`.
7. **Tabla E — Decisiones, agregado.** `repo`, `n_decisiones`,
   `decisiones_fuera_de_patron`, `decision_mas_reciente`.
8. **Catálogo de decisiones.** Una subsección por repo con `n_decisiones > 0`, con la
   ficha de siete campos por archivo. Los repos con cero se agrupan en una línea
   final.
9. **Lista de trabajo de la migración a v34.** Tres listas de nombres de repo, sin
   comentario: sin ningún campo de candado; con candado parcial; con candado
   completo. Y aparte, los que ya declaran `ventana_insumos`.
10. **Riesgo de pérdida.** Los repos con `traspasos_sin_versionar > 0` o `sucio > 0`,
    ordenados de mayor a menor por `traspasos_sin_versionar`. Una línea por repo con
    sus cifras. Sin recomendaciones.
11. **Anomalías.** Todo `n/d` con su causa, todo repo degradado por la regla blanda,
    toda grafía no canónica, todo `desync: adelantado`, toda cuarta desalineación de
    nombre, y todo ajuste de comando que el ejecutor haya tenido que hacer por
    diferencias de sistema.
12. **Reproducción.** El comando exacto para volver a correr el censo, los ocho casos
    del autotest con su resultado, y las cinco verificaciones del paso 9.

Formato: tablas markdown, celdas largas recortadas con el criterio ya declarado.
**Ninguna sección de conclusiones, propuestas ni próximos pasos:** la interpretación
es del titular y de la sesión conversacional, no de este encargo.

## 6. Salida B — dataset

`50_documentacion/andamios/20260824_censo_cartera.csv`

- Una fila por repo, más el encabezado.
- Separador coma, UTF-8, salto de línea `\n`.
- **Todos** los campos entre comillas dobles, con las comillas internas duplicadas.
  `ventana_insumos` contiene comas por diseño y sin comillas rompería el archivo.
- Columnas: la unión de las tablas A, B, C y D, en ese orden, con los mismos nombres
  usados en este encargo, más los tres agregados de la tabla E. La ficha de
  decisiones no entra: es una relación uno a muchos y no cabe en una fila por repo.
- Sin totales, sin filas de resumen, sin celdas combinadas. Es un dataset, no un
  reporte.

**Comprobación previa obligatoria:** corre

```bash
git check-ignore -v 50_documentacion/andamios/20260824_censo_cartera.csv
```

en la raíz del emisor. Si el `.gitignore` del proyecto ignora `*.csv`, el archivo se
escribe igual, pero la verificación 9.3 debe esperar **una** línea sin seguimiento y
no dos, y esto se declara en anomalías. **No modifiques el `.gitignore`.**

---

## 7. Orden de ejecución

1. Medir y guardar, en la raíz del emisor: `git status --porcelain | wc -l` como
   `sucio_inicial`, y `git stash list | wc -l` como `stash_inicial`.
2. Autotest del paso 8. Si falla, D2.
3. Universo (paso 2). Si falla, D1.
4. Recolección repo por repo (paso 4), sin escribir todavía.
5. Escribir la salida B y después la salida A.
6. Verificaciones del paso 9.
7. Borrar el directorio temporal del autotest.
8. Mensaje final (paso 10).

Escribir al final y no incrementalmente: una corrida interrumpida a mitad no debe
dejar un informe parcial que parezca completo.

---

## 8. Autotest con control negativo (obligatorio, previo a todo)

Un extractor que nunca se vio fallar no es un extractor verificado. Antes de tocar el
universo real, construye en `/tmp/censo_selftest_$$/` los fixtures sintéticos y
comprueba que el extractor y los clasificadores producen el resultado esperado.
Ninguno de estos archivos vive dentro de ningún repo.

| Caso | Fixture | Resultado esperado |
|---|---|---|
| C1 | `ESTADO.md` con las dieciséis llaves, valores no vacíos | `esquema = v33+`, `n_candado = 6`, `ventana_diagnostico = declarada` |
| C2 | Solo las ocho llaves heredadas | `esquema = v5`, `n_candado = 0`, `ventana_diagnostico = ausente` |
| C3 | Tres campos de candado y `ventana_insumos:` vacío | `esquema = parcial`, `n_candado = 3`, `ventana_diagnostico = vacia` |
| C4 | Primera línea distinta de `---` | `SIN_FRONT_MATTER` en toda llave |
| C5 | `sesion_actual: v04` con traspaso `v07` en el árbol simulado | `desync = si`, delta 3 |
| C6 | `ventana_insumos: ../fuera, SLEP_X_DATA_ROOT/20_insumos` | `ventana_diagnostico = entrada_invalida` |

Y los dos controles negativos propiamente tales, que son la razón de ser de este
paso:

- **C7 — control de alcance del extractor.** Un fixture donde la cadena
  `commit_cierre:` aparece en el **cuerpo**, en prosa, después del cierre del front
  matter, y **no** dentro del front matter. El extractor debe devolver `AUSENTE`. Si
  devuelve un valor, está leyendo el archivo entero con `grep` y todas las cifras de
  candado del censo son sospechosas: **D2**.
- **C8 — control de especificidad del detector de desync.** Un fixture con
  `sesion_actual: v11` y traspaso máximo `v11`. Debe dar `desync = no`. Un detector
  que marca desync en todo no discrimina nada, y pasaría inadvertido en una cartera
  donde la mayoría sí está desincronizada.

Reporta los ocho casos con su `PASA`/`FALLA` en la sección de reproducción del
informe y en el mensaje final. Un solo `FALLA` activa D2 y no se escribe informe.

---

## 9. Verificaciones finales

Ejecuta las cinco y reporta el resultado literal de cada una:

1. `wc -l` de cada archivo de salida.
2. Las filas de datos de la Tabla A, de la Tabla B y del CSV son **iguales entre sí**
   e iguales a la cardinalidad del universo del paso 2. Cualquier discrepancia activa
   D3.
3. `git status --porcelain | wc -l` en la raíz del emisor es exactamente
   `sucio_inicial + 2`, o `+ 1` si el CSV resultó ignorado según el §6. Cualquier otro
   valor significa que se tocó algo no declarado: D3, y reporta el `git status`
   completo.
4. `grep -c '/Users/tomgc'` devuelve `0` en ambos archivos de salida.
5. `git stash list | wc -l` en la raíz del emisor es idéntico a `stash_inicial`.

---

## 10. Mensaje final

Máximo quince líneas. Contenido, sin prosa de relleno:

- Cardinalidad del universo y cuántos repos se degradaron por la regla blanda.
- Los ocho casos del autotest, en una línea.
- Cuántos con `ESTADO.md` y el reparto por `esquema`.
- Cuántos declaran `ventana_insumos`.
- Cuántos con `traspasos_sin_versionar > 0`, nombrándolos.
- Cuántos con `traspasos_a_la_vista > 1`.
- Cuántos con al menos una decisión, y el total de decisiones de la cartera.
- Las cinco verificaciones del paso 9 con su resultado.

Nada más. Sin conclusiones, sin recomendaciones, sin próximos pasos: el informe está
en el archivo y la interpretación es de la sesión.
