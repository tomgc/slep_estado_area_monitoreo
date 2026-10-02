# Propuesta de diseño: visualizador panorámico de la cartera

> **Nota (2026-10-02):** el equipo eligió el nombre **Portafolio de Proyectos** (subtítulo: Área de Monitoreo). "Atalaya" aparece en este documento solo como el nombre propuesto originalmente; archivos y código usan `portafolio`.

- **Naturaleza:** documento de análisis y diseño (fases 1 a 3 de la especificación, más el plan del MVP). No contiene código.
- **Fecha:** 2026-10-02.
- **Estado:** propuesta; requiere las decisiones de la sección 3 antes de implementar.
- **Base leída en esta sesión:** `README.md`, `30_procesamiento/36_generar_panorama_visual.R` (L1-80, L406-612), `50_documentacion/activa/ESTADO.md` (front matter y secciones), `50_documentacion/activa/backlog_acumulativo.md` (L1-60), `50_documentacion/andamios/20260826_censo_backlogs_cartera.md`, `40_salidas/panorama_visual.html` (renderizado), `.github/workflows/pages.yml`, `renv.lock`.

---

## 1. Hallazgo previo: esto no parte de cero

La especificación describe, casi punto por punto, lo que este repositorio ya hace en su forma básica:

| Pieza pedida | Lo que ya existe | Fuente |
|---|---|---|
| "Alternativa D" (generador que lee carpetas y produce HTML autocontenido) | Pipeline R 31→36: descubre `slep_*`, localiza documentos, extrae metadatos, compila inventario y genera `panorama_visual.html` | (fuente: `README.md`, `36_generar_panorama_visual.R` L1-25) |
| Dataset separado de la presentación | `inventario_cartera.json` + objeto por proyecto embebido como JSON en el HTML | (fuente: `36_generar_panorama_visual.R` L545-612, L792) |
| Estados | Enum `semaforo` (activo, pausa, bloqueado, cerrado, amarillo) y `tipo_pendiente` | (fuente: `36_generar_panorama_visual.R` L48-65) |
| Publicación | GitHub Pages despliega `panorama_visual.html` en cada push a `main` | (fuente: `.github/workflows/pages.yml`) |
| Funcionamiento offline | El HTML actual no referencia URLs externas | (fuente: `grep -o 'https\?://' 40_salidas/panorama_visual.html`, sin resultados) |

Lo que falta es justamente lo que pide la especificación: la capa de **interpretación** (ítems, horizontes, avance, señales, procedencia del dato) y la capa de **presentación** (la UI actual es un acordeón con KPIs en tarjetas grandes, que es lo que la especificación quiere evitar) (fuente: captura de `40_salidas/panorama_visual.html` en esta sesión).

**Consecuencia de diseño:** Atalaya se propone como la **versión 2 del paso 36**, reutilizando 31-34 como ingesta y conviviendo con `panorama_visual.html` hasta alcanzar paridad, no como un producto paralelo.

---

## 2. Análisis crítico de la especificación (fase 1)

### 2.1 Contradicciones

1. **Lenguaje.** La especificación pide JavaScript vanilla; la regla de la cuenta exige R en todo entregable que persista o se mantenga. Resolución propuesta: **toda la lógica de interpretación vive en R** (parser, normalización, métricas, señales, render de Markdown); el JavaScript del HTML queda reducido a **presentación pura** (render, filtro, orden, búsqueda, preferencias). Es la misma frontera que ya acepta el paso 36, que embebe JS en el HTML que genera. Esto descarta como arquitectura principal la alternativa B, que obligaría a reescribir el parser en JS.
2. **"No inventar" frente a "detectar abandonados", "progreso" y "contradicciones".** Las tres cosas son inferencias. Se resuelve tipando la procedencia de cada dato (declarado, inferido, ausente; sección 4.2) y expresando toda inferencia como **señal** con su evidencia, nunca como estado.
3. **La taxonomía de estados mezcla dos ejes.** "Active", "Paused" y "Archived" describen el pulso de trabajo; "Experimental", "In development" y "Completed" describen la fase del ciclo de vida. Un proyecto puede estar "en desarrollo" y "pausado" a la vez. Se propone separar ambos ejes (sección 6.4).
4. **BACKLOG con "especial importancia" frente a la cartera real.** En la cartera, `backlog_acumulativo.md` es un **registro histórico de cambios realizados**, no trabajo pendiente: "Registro historico vivo: en cada cierre se copia integro y se agregan los cambios nuevos al final" y "Un 'cambio' es una solicitud distinguible del titular" (fuente: `50_documentacion/activa/backlog_acumulativo.md` L3-6, L44-46). Interpretado por nombre de archivo, inflaría el "backlog" de cada proyecto con trabajo ya hecho. Es la prueba concreta de que la clasificación debe hacerse **por contenido de sección**, no por nombre de archivo (sección 5).
5. **Nombres de archivo supuestos frente a convenciones reales.** La cartera documenta con `ESTADO.md` (front matter YAML: `semaforo`, `tipo_pendiente`, `ultima_actividad`, `sesion_actual`), `traspaso_cierre_vNN.md` y `backlog_acumulativo.md` (fuente: `50_documentacion/activa/ESTADO.md`; censo de backlogs). Que existan `TODO.md`, `ROADMAP.md` o `CHANGELOG.md` en los hermanos es (hipotesis, verificar con: `find ~/Projects/slep_* -maxdepth 3 \( -iname 'TODO*.md' -o -iname 'ROADMAP*.md' -o -iname 'CHANGELOG*.md' \) | wc -l`).
6. **HTML autocontenido frente a ver "contenido documental completo".** El HTML se publica en GitHub Pages desde un repositorio público (fuente: `.github/workflows/pages.yml`; `README.md` "Rama A (publico)"). Embeber el texto íntegro de la documentación de los hermanos choca con la regla R3 de salida saneada (fuente: `README.md`, "Gobernanza de lectura"). Se propone separar perfiles de compilación (sección 4.5).

### 2.2 Ambigüedades

- **Alcance:** ¿la cartera `slep_*` del Área, o cualquier carpeta de proyectos? (decisión D1).
- **"Proyecto abandonado":** no es un dato que alguien declare; solo puede ser una señal por inactividad con umbral configurable.
- **"Actividad":** `mtime` no es confiable (un clon nuevo reinicia fechas). Hay mejores fuentes: fecha declarada en `ESTADO.md`, fechas de cierre de sesión (traspasos), fecha del último commit (el paso 33 ya la lee como opcional) (fuente: `33_extraer_metadatos.R` L32-38).
- **"Expansión de cards" y "drawer de detalle":** son dos patrones para lo mismo; se propone solo el drawer.
- **Idioma de la interfaz:** la especificación lista estados en inglés; el equipo trabaja en español. Se propone UI en español.

### 2.3 Riesgos técnicos

| Riesgo | Mitigación |
|---|---|
| `fetch()` de un JSON local falla bajo `file://` en Chromium | Dataset embebido en `<script type="application/json">`; importación vía `<input type=file>` y drag & drop, que sí funcionan bajo `file://` |
| Ruptura del `<script>` por texto documental que contenga `</script>` | El generador R escapa `</` como `<\/` al embeber |
| Inyección de HTML desde Markdown de terceros | Markdown se renderiza en R con HTML crudo deshabilitado; en JS todo texto pasa por una función de escape única |
| `localStorage` compartido entre todos los `file://` en Chromium y ausente en modo privado | Claves con prefijo `atalaya:`; todo acceso en `try/catch`; la app funciona sin persistencia |
| File System Access API: solo Chromium, exige gesto en cada sesión, obliga a un parser en JS | Descartada como vía principal (sección 4.1) |
| Peso del HTML con documentación completa | Perfil público sin texto completo; extractos acotados |
| Dependencias R nuevas | `renv.lock` no incluye `commonmark` ni `yaml` (fuente: `renv.lock`); agregarlas vía `renv::install()` y `renv::snapshot()` |
| Divergencia entre `panorama_visual.html` y Atalaya | Paso 36 congelado durante la transición; retiro al alcanzar paridad |

---

## 3. Decisiones que el equipo debe tomar

| ID | Decisión | Opciones | Recomendación |
|---|---|---|---|
| D1 | Alcance | (a) solo cartera `slep_*`; (b) motor genérico con cartera como configuración por defecto | **(b)**: el costo marginal es bajo (registro de adaptadores) y la demo exige patrones genéricos de todos modos |
| D2 | Relación con el paso 36 | (a) reemplazo tras paridad; (b) producto paralelo permanente | **(a)**: dos HTML de estado divergen; ya ocurrió con el universo heredado (D-24-I) |
| D3 | Publicación | (a) un solo HTML; (b) perfiles `local` (completo, no versionado) y `publico` (saneado, en Pages) | **(b)**: es la única forma de ofrecer documentos completos sin violar R3 |
| D4 | Convenciones en hermanos | (a) exigir campos nuevos en `ESTADO.md`; (b) parser tolerante, campos opcionales (`fase`, `avance`) | **(b)**: no se toca la documentación de 26 repos para que el visualizador funcione |
| D5 | Vista por defecto | (a) grilla de tarjetas (preferencia inicial); (b) "Panorama" en filas densas | **(b)**: toda la cartera cabe en una pantalla; la grilla queda como segunda vista |
| D6 | Nombre | sección 10 | **Atalaya** |

---

## 4. Arquitectura técnica (fase 2)

### 4.1 Evaluación de alternativas de ingesta

| Alternativa | Autocontenido | Sin instalar nada para consumir | Lógica en R | Documentos privados | Veredicto |
|---|---|---|---|---|---|
| A. Dataset generado aparte | Parcial (HTML + JSON separados; `file://` no permite `fetch`) | Sí | Sí | Controlable | Insuficiente sola |
| B. Importación desde el navegador (FS Access API) | Sí | Sí, solo Chromium | **No** (parser en JS) | Expuestos en el navegador | Descartada como principal |
| C. Dataset embebido | Sí | Sí | Depende de quién lo genere | Controlable | Es el formato de salida |
| **D. Híbrida: R genera dataset y lo embebe** | **Sí** | **Sí** | **Sí** | **Controlable por perfil** | **Elegida** |

La elección es D, con C como formato de transporte y una vía secundaria de **importar/exportar JSON** (que no requiere parser en el navegador: importa un dataset ya normalizado por R).

### 4.2 Flujo

```
Carpetas de proyectos (solo documentación curada, R2)
        │
31 descubrir ─ 32 localizar ─ 33 metadatos ─ 34 inventario      (existentes)
        │
37_extraer_documentos.R   secciones + ítems + rol de cada sección   (nuevo)
        │
38_derivar_dataset.R      normalización, procedencia, métricas,      (nuevo)
        │                 señales → 40_salidas/atalaya_datos.json
        │
39_generar_atalaya.R      plantilla + dataset + fuentes + íconos     (nuevo)
        │                 → 40_salidas/atalaya.html (perfil público)
        │                 → 40_salidas/local/atalaya.html (perfil local, .gitignore)
        ▼
Navegador (doble clic, offline)
```

`run_all()` incorpora los pasos 37-39; `run_all(only = 37:39)` regenera solo Atalaya. La plantilla vive como archivo `.html` editable (con un marcador `<!--ATALAYA_DATOS-->`), no como cadenas dentro de un script R, a diferencia del paso 36. Ubicación propuesta: `30_procesamiento/plantillas/atalaya.html` (sujeta a la estructura de `POLITICA_PROYECTO.md`, no leído en esta sesión).

### 4.3 Registro de adaptadores (extensibilidad)

Una tabla en R, no código ramificado. Agregar un tipo de documento es agregar una fila:

| patron | rol_por_defecto | lector | notas |
|---|---|---|---|
| `README*.md` | identidad | secciones_md | nombre (H1), descripción (primer párrafo), tecnologías |
| `ESTADO.md`, `estado.md`, `STATUS.md` | estado | front_matter + secciones_md | campos declarados del front matter |
| `TODO*.md` | inmediato | secciones_md + checkboxes | |
| `BACKLOG*.md` | futuro | secciones_md + checkboxes + tablas | |
| `backlog_acumulativo.md` | historial | lista_num, tabla, id_alfanum | convenciones medidas en el censo |
| `ROADMAP*.md` | plan | secciones_md | hitos, fases, fechas |
| `CHANGELOG*.md` | historial | versiones (`## [x.y.z] - fecha`) | eventos fechados |
| `traspaso_cierre_v*.md` | historial + inmediato | secciones_md | fecha de cierre = evento; "próximos pasos" = inmediato |
| `*.md` restantes en raíz o `docs/` | otro | secciones_md | solo se clasifican sus secciones |

El **rol del archivo es solo un valor por defecto**: cada sección se reclasifica por su encabezado (sección 5).

### 4.4 Arquitectura del HTML

- **Un solo archivo**, sin build, sin frameworks. Web Components descartados: el shadow DOM complica los tokens de tema y no hay reutilización que lo justifique.
- **Módulos como objetos dentro de un IIFE:** `Datos` (carga y valida el esquema), `Estado` (estado de UI, suscriptores, persistencia), `Consulta` (funciones puras de filtro, orden y búsqueda), `Vistas` (panorama, tarjetas, fases, actividad), `Detalle` (drawer), `Ui` (escape, fechas con `Intl` es-CL, íconos), `Atajos`.
- **Render:** template literals + delegación de eventos; con decenas de proyectos no se necesita DOM virtual.
- **Enrutamiento por hash:** `#/panorama?pulso=activo&q=sig`, `#/p/<id>`. Permite volver atrás y enlazar a un proyecto.
- **Datos:** `<script type="application/json" id="atalaya-datos">`; al importar un JSON se reemplaza en memoria (no en `localStorage`) y aparece una banda "Dataset importado: <nombre>, <fecha>" con opción de volver al embebido.
- **Persistencia (`localStorage`, prefijo `atalaya:`):** tema, vista, filtros, orden, favoritos, fijados, últimos abiertos. Nunca datos de proyecto.
- **CSS:** variables (tokens) por tema, Grid para layout, `prefers-reduced-motion` y `prefers-color-scheme` respetados.

### 4.5 Perfiles de compilación

| Perfil | Contenido documental | Destino | Versionado |
|---|---|---|---|
| `publico` | Campos derivados, extractos acotados y saneados (R3) | `40_salidas/atalaya.html` → Pages | Sí |
| `local` | Además, documentos completos renderizados | `40_salidas/local/atalaya.html` | No (`.gitignore`) |
| `demo` | Fixtures sintéticos | `40_salidas/atalaya_demo.html` | Sí |

El perfil se declara en el propio dataset (`"perfil"`) y la UI lo muestra en el encabezado, para que nunca se confunda una demo con datos reales.

---

## 5. Ingesta de Markdown y distinción TODO / BACKLOG / ROADMAP

### 5.1 Principio: la unidad es la sección, no el archivo

Un `README.md` puede tener "## Próximos pasos"; un `estado.md` puede tener "## Ideas a futuro". El parser divide cada documento en secciones (por encabezado) y asigna a cada una un **rol**, con esta precedencia:

1. **Encabezado de la sección** (diccionario bilingüe, sin tildes, insensible a mayúsculas).
2. **Rol por defecto del archivo** (tabla 4.3).
3. **Forma de los ítems** (checkboxes, listas numeradas con fecha, tablas con columna de prioridad).

Diccionario inicial de encabezados:

| Rol | Patrones |
|---|---|
| inmediato | próximo paso, próximos pasos, pendientes, por hacer, en curso, esta semana, todo, next, doing |
| futuro | backlog, ideas, a futuro, mejoras, deseable, wishlist, icebox, someday, deuda técnica |
| plan | roadmap, hoja de ruta, hitos, fases, milestones, plan |
| historial | changelog, cambios, historial, hecho, completado, done, versiones |
| bloqueos | bloqueantes, bloqueos, blockers, impedimentos, riesgos |
| estado | estado, en qué vamos, status, situación actual |
| identidad | descripción, propósito, objetivo, acerca de, about |

Toda sección no reconocida queda con rol `otro` y se reporta en un **informe de cobertura** por proyecto (qué roles se detectaron y qué secciones quedaron sin clasificar), que es el insumo para ampliar el diccionario sin adivinar.

### 5.2 Ítems

Dentro de las secciones con rol de trabajo, cada viñeta, checkbox o fila de tabla se convierte en un **ítem** con estado (`- [ ]` pendiente, `- [x]` hecho, `~~texto~~` descartado, marcas como "(bloqueado)" o "WIP"), prioridad (`P0`-`P3`, alta/media/baja, high/low, 🔴🟠🟢, columna "Prioridad") y categoría (prefijos `bug:`, `feat:`, `deuda:` o subencabezados). Si nada de eso está escrito, el atributo queda `null`, no se deduce.

### 5.3 TODO, BACKLOG y ROADMAP como vistas sobre un mismo modelo

No se modelan como tres listas, sino como **ítems con un horizonte**. La distinción descansa en tres criterios, aplicados al contenido:

| Criterio | Inmediato (TODO) | Futuro (BACKLOG) | Plan (ROADMAP) |
|---|---|---|---|
| Horizonte | días a semanas, explícito o implícito | indefinido | fechado o secuenciado por fases |
| Granularidad | tarea ejecutable | funcionalidad, idea, mejora, deuda | fase u objetivo que agrupa trabajo |
| Compromiso | comprometido | candidato, no priorizado o priorizado sin fecha | objetivo declarado |

Reglas de resolución:

- Si solo existe `BACKLOG.md` y sus secciones se llaman "En curso" y "Próximo", esas secciones son **inmediato**; el resto es **futuro**. El nombre del archivo pierde frente al encabezado.
- Si solo existe `TODO.md` con secciones "Ahora" y "Algún día", se reparte igual.
- Un ítem presente en dos fuentes (texto normalizado idéntico) se deduplica, conserva el horizonte más inmediato y registra ambas fuentes.
- Los ítems de un roadmap son **hitos**: con fecha pasada y sin marca de hecho producen la señal "hito posiblemente vencido".
- `backlog_acumulativo.md` es **historial**: alimenta actividad y categorías temáticas, nunca el conteo de pendientes.

---

## 6. Modelo de datos

### 6.1 Contenedor

```json
{
  "esquema": "atalaya/1",
  "generado": "2026-10-02T09:00:00-03:00",
  "perfil": "publico",
  "fuente": { "generador": "39_generar_atalaya.R", "commit": "abc1234", "raiz": "relativa" },
  "taxonomias": { "pulso": [], "fase": [], "horizonte": [], "severidad": [] },
  "reglas_senales": [ { "id": "S01", "titulo": "...", "umbral": 90 } ],
  "proyectos": [],
  "relaciones": [],
  "advertencias_generacion": []
}
```

Las taxonomías viajan en el dataset (no en el JS), con etiqueta, orden y token de color: es la generalización de la "fuente única" que el paso 36 ya aplica al enum de semáforo (fuente: `36_generar_panorama_visual.R` L52-61).

### 6.2 Campo con procedencia

Todo dato **interpretativo** (nombre, descripción, pulso, fase, avance, última actividad, próximo paso, categoría) se envuelve así:

```json
{
  "valor": "activo",
  "origen": "declarado",
  "fuente": { "doc": "ESTADO.md", "seccion": "front matter", "linea": 4 },
  "regla": null,
  "motivo": null
}
```

- `origen`: `declarado` (escrito literalmente), `inferido` (calculado por una regla con id), `ausente`.
- `motivo` (solo si `ausente`): `documento_ausente`, `no_documentado`, `no_interpretable`, `contradictorio`.

La UI dibuja los tres orígenes de forma distinta (sección 7.5). Así "no inventar" deja de ser una intención y pasa a ser una propiedad verificable del dataset (test: ningún campo con `origen = declarado` puede carecer de `fuente`).

### 6.3 Proyecto

```json
{
  "id": "bitacora-campo",
  "ruta": "bitacora-campo",
  "nombre": Campo,
  "descripcion": Campo,
  "categoria": Campo,
  "tags": [ "offline", "móvil" ],
  "tecnologias": [ { "nombre": "R", "fuente": { "doc": "README.md" } } ],

  "pulso": Campo,
  "fase": Campo,
  "avance": { "tipo": "declarado | hitos | fase | ninguno", "valor": 0.45,
              "hechos": null, "total": null, "fuente": {} },
  "ultima_actividad": Campo,
  "proximo_paso": Campo,
  "bloqueos": { "estado": "declarados | ninguno_declarado | no_documentado", "items": [] },

  "items": [ Item ],
  "hitos": [ Hito ],
  "eventos": [ { "fecha": "2026-08-27", "tipo": "cierre_sesion | commit | version | cambio_estado",
                 "texto": "...", "fuente": {} } ],
  "documentos": [ Documento ],
  "cobertura": { "identidad": true, "estado": true, "inmediato": true,
                 "futuro": false, "plan": false, "historial": true },
  "metricas": {},
  "senales": [ Senal ]
}
```

- `id` = nombre de carpeta (estable); `ruta` siempre relativa (R3).
- `bloqueos.estado` distingue "ninguno" escrito (`ESTADO.md` de este repo declara `ninguno`) de la ausencia de la sección (fuente: `50_documentacion/activa/ESTADO.md`, sección "Bloqueantes").

```json
Item = { "id": "bitacora-campo#todo-12", "texto": "...",
         "horizonte": "inmediato | futuro | historial",
         "estado": "pendiente | en_curso | hecho | bloqueado | descartado | desconocido",
         "prioridad": { "original": "P1", "nivel": "alta | media | baja | null" },
         "categoria": "bug | funcionalidad | mejora | deuda_tecnica | documentacion | null",
         "fecha": null, "fuentes": [ { "doc": "TODO.md", "seccion": "Ahora", "linea": 14 } ] }

Hito = { "titulo": "MVP", "fecha": "2026-09-30", "estado": "pendiente | hecho | desconocido",
         "fase": "mvp | null", "fuente": {} }

Documento = { "ruta": "docs/arquitectura.md", "tipo": "readme | estado | ... | otro",
              "fecha": Campo, "secciones": [ { "titulo": "...", "nivel": 2, "rol": "plan" } ],
              "extracto_html": "...", "html": null }

Senal = { "regla": "S04", "severidad": "atencion | aviso | info",
          "titulo": "No se encontró un siguiente paso documentado",
          "evidencia": "ESTADO.md sin sección de próximo paso; TODO.md ausente" }
```

`documento.html` solo se llena en el perfil `local`.

### 6.4 Taxonomía de estado en dos ejes

**Pulso** (¿se está trabajando?). Lleva el color, porque es lo primero que el ojo debe leer.

| Valor | Significado | Origen típico | Mapeo desde la cartera |
|---|---|---|---|
| activo | trabajo en curso | declarado | `semaforo: activo` |
| en pausa | detenido a propósito | declarado | `semaforo: pausa` |
| bloqueado | detenido por una dependencia | declarado | `semaforo: bloqueado` |
| cerrado | sin trabajo previsto | declarado | `semaforo: cerrado` |
| desconocido | sin declaración interpretable | ausente | sin `ESTADO.md` o valor fuera del enum |

"Latente" o "posiblemente abandonado" **no es un valor de pulso**: es la señal S01. El valor `amarillo` del enum actual no tiene significado documentado en lo leído (fuente: `36_generar_panorama_visual.R` L52-65); se mapea a `desconocido` con advertencia hasta que el equipo defina qué representa.

**Fase** (¿en qué punto del ciclo de vida?). Se dibuja como posición, no como color.

`idea → exploración → prototipo → MVP → desarrollo → producción → concluido`, más `archivado` fuera de la secuencia y `desconocida`. El mapeo desde `estado_proyecto` de la cartera (`inicial`, `en_desarrollo`, `con_productos`, `concluido`) es directo, salvo `en_pausa`, que pertenece al eje de pulso (fuente: `36_generar_panorama_visual.R` L41-42).

### 6.5 Avance sin inventar

Jerarquía estricta; se usa el primer nivel disponible y se dice cuál se usó:

1. **Declarado:** `avance: 45` en front matter o "Avance: 45 %" en la sección de estado → anillo con el número y el rótulo "declarado".
2. **Por hitos:** al menos tres hitos con estado legible → barra segmentada "3 de 5 hitos", sin porcentaje.
3. **Por fase:** solo la posición en la secuencia de fases.
4. **Ninguno:** "Avance no documentado".

Nunca se calcula avance a partir del conteo de ítems de backlog: el backlog crece sin límite y un proyecto sano puede tener más pendientes cada mes. La proporción de tareas hechas se muestra como métrica propia ("tareas inmediatas: 4 de 9 hechas"), no como avance del proyecto.

### 6.6 Métricas (cada una `null` si no es calculable)

`pendientes_inmediatos`, `pendientes_futuros`, `futuros_con_prioridad`, `bloqueados`, `hechos_90d`, `dias_desde_actividad`, `hitos_vencidos`, y `cobertura` (seis roles documentales como glifo de seis puntos, en vez de un porcentaje de "completitud documental" que no tendría escala real).

### 6.7 Catálogo inicial de señales (calculadas en R, testeables)

| Id | Severidad | Señal | Regla (umbral configurable) |
|---|---|---|---|
| S01 | aviso / atención | Sin actividad documentada reciente; posible abandono | días desde última actividad ≥ 60 / ≥ 120 |
| S02 | info | Estado no especificado | sin rol `estado` |
| S03 | aviso | Estado posiblemente desincronizado | `sesion_actual` de `ESTADO.md` distinta del último traspaso (reusa la regla vigente del paso 36) |
| S04 | aviso | No se encontró un siguiente paso documentado | sin ítems inmediatos pendientes ni `proximo_paso` |
| S05 | atención | Pendiente crítico declarado | `tipo_pendiente` ∈ {bug, bloqueante} |
| S06 | atención | Bloqueos declarados | `bloqueos.estado = declarados` |
| S07 | aviso | Lista inmediata extensa | pendientes inmediatos > 15 |
| S08 | aviso | Backlog extenso sin priorización documentada | futuros > 20 y `futuros_con_prioridad = 0` |
| S09 | aviso | Hito posiblemente vencido | hito con fecha pasada sin marca de hecho |
| S10 | info | README posiblemente desactualizado | README sin cambios en 180 días con actividad en el último mes |
| S11 | info | Estado posiblemente contradictorio | README declara fase o pulso distinto de `ESTADO.md` (solo términos explícitos) |
| S12 | info | Varios traspasos a la vista | más de un `traspaso_cierre_v*` fuera de `archivo/` (regla I5 de la cartera) |

Toda señal lleva evidencia textual ("ESTADO.md: `ultima_actividad: 2026-03-02`; 214 días") y se redacta con "posiblemente" o "no se encontró", nunca como afirmación.

### 6.8 Relaciones

Se calculan en R a partir de: referencias explícitas entre documentos (un README que nombra la carpeta de otro proyecto), dependencias declaradas y tags compartidos. Las tecnologías compartidas **no** generan aristas: en la cartera casi todo es R y el grafo sería una maraña sin información. El "Mapa de proyectos" queda fuera del MVP y solo se construye si el informe de cobertura muestra suficientes referencias explícitas.

---

## 7. Arquitectura visual (fase 3)

### 7.1 Layout de escritorio

```
┌───────────────────────────────────────────────────────────────────────────────┐
│ ◭ Atalaya · Cartera Área de Monitoreo     [ Buscar…           / ]   ◐  ⇩  ⇧   │
│ NN proyectos · NN activos · NN requieren atención · datos al 27 ago 2026     │
│ ▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▯▯▯▯▯▯   barra de pulso: un segmento por proyecto        │
├─────────────┬─────────────────────────────────────────────────────────────────┤
│ Pulso       │ Panorama · Tarjetas · Fases · Actividad          Orden: actividad│
│ ● activo  N │ FIJADOS                                                          │
│ ● pausa   N │ ★ ● Bitácora de campo   ▪▪▪▪▫▫▫ desarrollo  ▁▃▅▂▆  3 · 12   ⚠ 2  │
│ ● bloq.   N │ REQUIEREN ATENCIÓN                                               │
│ Fase        │   ● Faro API            ▪▪▪▫▫▫▫ MVP         ▁▁▃▁▁  5 · 30   ⛔ 1  │
│ Señales     │ RESTO (por última actividad)                                     │
│ Categoría   │   ● Lumen               ▪▪▪▪▪▪▪ concluido   ▁▁▁▁▁  0 · 2         │
│ Tecnología  │                                                                  │
└─────────────┴─────────────────────────────────────────────────────────────────┘
                                              drawer de detalle a la derecha →
```

Las cifras del encabezado son una **frase**, no tarjetas. La barra de pulso reemplaza a los KPIs: en un vistazo muestra la proporción de cada pulso y, al pasar el cursor, el proyecto de cada segmento.

### 7.2 Vistas

| Vista | Para qué pregunta | MVP |
|---|---|---|
| **Panorama** (filas densas, por defecto) | "¿Cómo está todo?" Toda la cartera en una pantalla | Sí |
| **Tarjetas** (grilla compacta) | "¿De qué trata cada proyecto?" Más descripción, menos densidad | Sí |
| **Fases** (columnas por fase, solo lectura) | "¿Cuántos están en cada etapa?" | Fase 5 |
| **Actividad** (heatmap proyectos × semanas) | "¿Dónde se ha trabajado?" Celdas sin fuente temporal con trama, distintas de cero | Fase 5 |
| Mapa de relaciones | "¿Qué depende de qué?" | Condicional (6.8) |

**Anatomía de la fila:** favorito · punto de pulso · nombre (con id en monoespaciada pequeña) · escalera de fase · glifo de avance · mini-serie de actividad (12 semanas) · próximo paso en una línea · conteos inmediato/futuro · íconos de señal · última actividad relativa ("hace 5 d").

**Anatomía de la tarjeta:** pulso + fase arriba; nombre; descripción (dos líneas); glifo de avance según su tipo (anillo si declarado, barra segmentada si por hitos, escalera si por fase, texto si ninguno); próximo paso; pie con hasta tres tecnologías, conteos, señales y fecha.

### 7.3 Detalle (drawer derecho)

Un solo desplazamiento con índice fijo, en este orden (que responde la pregunta del criterio de éxito en el orden en que se formula):

1. **Identidad:** nombre, descripción, pulso, fase, avance, tags, tecnologías.
2. **Ahora:** próximo paso, bloqueos, última actividad, resumen de estado.
3. **Señales detectadas**, con evidencia.
4. **Recorrido:** escalera de fases e hitos (vencidos marcados).
5. **Inmediato:** ítems agrupados por estado; prioridad como etiqueta.
6. **Futuro:** conteos por prioridad y categoría (barras horizontales pequeñas, solo si hay datos), y la lista filtrable.
7. **Historial:** eventos fechados.
8. **Documentos:** lista con roles detectados; extracto en perfil público, documento completo en perfil local.

`Esc` cierra; las flechas cambian de proyecto sin cerrar el drawer.

### 7.4 Sistema de color

Una regla: **el color significa pulso o severidad, nunca decoración**. El azul de interacción se reserva para foco, selección y enlaces.

| Token | Oscuro | Claro | Uso |
|---|---|---|---|
| `--fondo` | `#0B1020` | `#F6F7F9` | página |
| `--superficie` | `#121A2B` | `#FFFFFF` | paneles, drawer |
| `--linea` | `#22304A` | `#E2E6EE` | separadores |
| `--texto` | `#E6EAF2` | `#0F172A` | principal |
| `--texto-tenue` | `#8E9AB0` | `#5A6478` | secundario |
| `--interaccion` | `#4C8DFF` | `#2563EB` | foco, selección, enlaces |
| `--pulso-activo` | `#3DDC97` | `#0E9F6E` | menta |
| `--pulso-pausa` | `#A78BFA` | `#7C3AED` | violeta |
| `--pulso-bloqueado` | `#FF6B6B` | `#DC2626` | coral |
| `--pulso-cerrado` | `#94A3B8` | `#64748B` | pizarra, con ícono de check |
| `--pulso-desconocido` | contorno punteado `--texto-tenue` | ídem | sin relleno |
| `--aviso` | `#F5B544` | `#B45309` | ámbar, solo señales |
| `--atencion` | `#FF6B6B` | `#DC2626` | igual que bloqueado: "algo detenido que exige acción" |

Los contrastes se validan contra WCAG AA en la fase 5 con una medición, no por inspección. El color nunca es el único portador de información: cada pulso tiene además forma o ícono.

### 7.5 Procedencia visible

| Origen | Tratamiento |
|---|---|
| declarado | texto normal; al pasar el cursor o enfocar, chip "ESTADO.md · front matter" |
| inferido | subrayado punteado; tooltip con la regla ("S01: 214 días sin actividad documentada") |
| ausente | "no documentado" en `--texto-tenue` itálica, nunca un guion ni un cero |

### 7.6 Tipografía e iconografía

- **IBM Plex Sans** (interfaz) e **IBM Plex Mono** (ids, cifras, fechas, rutas): una superfamilia, licencia OFL (permite embeber), cifras tabulares nativas y un tono técnico menos genérico que Inter. Se embeben como `woff2` en base64, subconjunto latino, dos pesos de Sans y uno de Mono; con `system-ui` como respaldo. Peso aproximado del conjunto (hipotesis, verificar con: `wc -c` sobre los `woff2` subconjuntados).
- **Lucide** (licencia ISC), solo los íconos usados, como sprite `<symbol>` inline. Una sola familia.

### 7.7 Interacción y movimiento

- Transiciones de 120 a 200 ms en hover, apertura del drawer (desplazamiento + opacidad) y reordenamiento por filtro (FLIP). Aparición escalonada solo en la primera carga.
- Con `prefers-reduced-motion: reduce` todas las duraciones pasan a 0.
- Atajos: `/` busca, `Esc` cierra, flechas recorren filas, `Enter` abre, `f` marca favorito, `t` alterna tema.
- Búsqueda instantánea sobre un índice normalizado (sin tildes, minúsculas) construido al cargar: nombre, descripción, tags, tecnologías, etiquetas de pulso y fase, ítems y, en perfil local, texto documental. Cada resultado indica dónde coincidió ("coincide en: Futuro · 'exportar a xlsx'").
- Orden: los valores sin dato van **siempre al final**, en cualquier dirección, rotulados "sin dato (N)".
- Foco y modo foco: favoritos y fijados persistentes; "modo foco" muestra solo fijados más proyectos con señales de atención.

### 7.8 Responsive y accesibilidad

- ≥ 1280 px: barra de filtros lateral + contenido + drawer superpuesto. 768 a 1279 px: filtros plegables arriba; la fila Panorama oculta la mini-serie y el próximo paso. < 768 px: Tarjetas en una columna; el drawer ocupa la pantalla.
- HTML semántico (`header`, `nav`, `main`, `aside`, `dialog` para el drawer), foco atrapado en el drawer y devuelto al cerrar, `aria-live` para el conteo de resultados, etiquetas en todo control, foco visible con `--interaccion`.

---

## 8. Datos de demostración

Los datos demo **no se escriben como JSON a mano**: se escriben como carpetas de Markdown sintéticas en `tests/fixtures/cartera_demo/` y pasan por el pipeline real (37-39). Así la demo prueba el parser y no es una funcionalidad falsa. Sin nombres reales (R3).

| Carpeta | Caso que ejercita |
|---|---|
| `lumen` | Concluido; `CHANGELOG.md` con versiones; sin TODO |
| `bitacora-campo` | Activo; TODO mediano; BACKLOG con P1-P3; ROADMAP con un hito vencido |
| `faro-api` | En desarrollo; `estado.md` con "Avance: 45 %"; bloqueo declarado |
| `tesela` | Experimental; solo README con ideas |
| `cosecha` | Pausa declarada; última actividad hace cinco meses |
| `mareas` | `estado.md` dice "activo" pero sin actividad en diez meses (S01 + S11) |
| `proto-x` | Solo `notas.md`, sin README: información insuficiente |
| `indexador` | TODO extenso con checkboxes mayoritariamente pendientes (S07) |
| `catalogo-datos` | BACKLOG extenso sin prioridades y en inglés ("Icebox", "Wishlist") (S08) |
| `pulso-cli` | BACKLOG bien priorizado con categorías bug, mejora y deuda |
| `relevo` | README antiguo y `estado.md` reciente con otra fase (S10, S11) |
| `vitrina` | Producción; roadmap completo; archivos en inglés (`STATUS.md`, `NOTES.md`) |
| `orquesta-demo` | Convenciones de la cartera: `ESTADO.md` con front matter, traspasos y `backlog_acumulativo.md` como historial |

Las fechas de los fixtures son fijas y el generador recibe la fecha de referencia como parámetro, para que la salida demo sea byte-estable (mismo criterio que el inventario del paso 34).

---

## 9. MVP (fase 4) por incrementos

| Inc. | Contenido | Criterio de aceptación |
|---|---|---|
| I1 | Esquema `atalaya/1`, fixtures demo, `37_extraer_documentos.R`, registro de adaptadores, informe de cobertura | Tests R: cada fixture produce los roles e ítems esperados; secciones no reconocidas listadas |
| I2 | `38_derivar_dataset.R`: procedencia, pulso, fase, avance, métricas, señales S01-S09 | Tests R: ningún campo `declarado` sin `fuente`; cada señal se dispara en su fixture y no en los demás |
| I3 | Plantilla + `39_generar_atalaya.R`: encabezado con barra de pulso, Panorama, Tarjetas, búsqueda, filtros, orden, drawer, tema claro/oscuro, persistencia, favoritos y fijados, importar/exportar JSON, rutas por hash | Abre con doble clic; **cero solicitudes de red** medidas con Chromium headless; reemplazar el JSON embebido no exige tocar la plantilla |
| I4 | Corrida contra la cartera real en perfil `local` e informe de cobertura | El equipo revisa el informe y aprueba ajustes al diccionario |

Fuera del MVP: vistas Fases y Actividad, señales S10-S12, perfil público en Pages, mapa de relaciones, retiro del paso 36 (fase 5 y 6).

---

## 10. Nombre

| Opción | Lectura |
|---|---|
| Project Atlas | Correcto pero genérico y en inglés |
| Mirador | Vista amplia, pero pasiva |
| Cartógrafo | Sugiere que el producto dibuja el mapa, cuando lo dibuja la documentación |
| **Atalaya** | Torre desde la que se vigila el territorio: vista panorámica, monitoreo y detección temprana de señales, en español |

Recomendación: **Atalaya** (nombra exactamente la función: mirar todo el territorio desde arriba y avisar a tiempo).

Archivo producido: `atalaya.html` en lugar de `project-visualizer.html`.
