# Ordenación del repositorio — marcador de estado

- **Fecha:** 2026-08-27. **Sesión:** 13. **Rama:** `ordenacion/20260826`.
- **Protocolo:** SETTINGS §4.7. **Encargo:** `andamios/20260826_encargo_ordenacion_a03.md`.
- **Cubre:** O-03, O-13, O-19.
- **Existencia de este archivo = gatillo 4bis apagado.** Mientras esté, la apertura de
  sesión no vuelve a proponer una ordenación completa: se propone solo si cambia algo
  que este marcador declare pendiente.

---

## Archivos movidos por bloque

| Bloque | Movidos | Detalle |
|---|---:|---|
| 1 — Traspasos | **0** | Ya estaba ordenado: `v12` a la vista, `v01`-`v11` en `traspasos/archivo/` |
| 2 — Obsoletos | **2** | A `_archivo/20260826/50_documentacion/activa/` |
| 3 — Nomenclatura | **0** | Los dos archivos sin prefijo eran exactamente los del bloque 2 |
| 4 — Escáner | **0** | Cambio de código, sin movimientos |

### Manifiesto del bloque 2

| `git hash-object` | Origen | Destino |
|---|---|---|
| `df0a4eae8fd4836a1adf19843adba8f5210b23f4` | `50_documentacion/activa/esbozo_fase2_estado_estandarizado.md` | `_archivo/20260826/50_documentacion/activa/esbozo_fase2_estado_estandarizado.md` |
| `b0447e9c298042ceb09db7b96ba6cbccaa9a5b8e` | `50_documentacion/activa/reporte_cobertura_documental.md` | `_archivo/20260826/50_documentacion/activa/reporte_cobertura_documental.md` |

El hash es idéntico en origen y destino: el contenido viajó byte a byte y git registró los
dos movimientos como `R` (rename), no como borrado más alta.

**Filas canceladas: ninguna.** El grep de referencias vivas
(`grep -rn --exclude-dir=_archivo --exclude-dir=.git --exclude-dir=andamios`) devolvió,
para los dos archivos, solo apariciones en `estructura/` (snapshots regenerables) y
`traspasos/` (histórico). Ninguna referencia en código, README, `CLAUDE.md`, `40_salidas/`
ni en los normativos.

---

## Excepciones declaradas

1. **O-19 — `andamios/design_handoff_monitoreo_cartera/Panorama de cartera.dc.html`.**
   Nombre con espacios. **No se renombra:** `andamios/` está congelado por POLITICA §1.2
   y §4.7.4 lo prohíbe explícitamente. Además el directorio está en `.gitignore` (activos
   pesados de referencia). O-19 se cierra como excepción, no como corrección.
2. **Normativos no versionados — `POLITICA_PROYECTO.md` y
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md` en `activa/`.** `git ls-files` devuelve vacío
   para los dos: `.gitignore` los excluye por decisión de gobernanza de la sesión 12
   (viven en la knowledge base del Project). El bloque 1 del protocolo manda actualizarlos
   desde la KB y commitearlos; **aquí no aplica**: se verificó en disco que son **v5.8** y
   **v34**, y no se commiteó ninguno.

---

## Nota sobre `_archivo/` y `.gitignore`

`.gitignore:17` ignora `_archivo/`, pero los dos archivos movidos **siguen versionados**
en su destino: `.gitignore` no gobierna rutas que ya están en el índice, y `git mv` mueve
la entrada del índice explícitamente. La asimetría a tener presente: un archivo **nuevo**
depositado en `_archivo/` no quedaría versionado; uno **movido con `git mv`** sí.

---

## Escáner

`EXCLUIR_DIRS` pasó de `c(".git", ".Rproj.user", "renv", ".quarto")` a incluir además
`node_modules`, `packrat` y `venv` (POLITICA §7.2).

| Corrida | Directorios | Archivos |
|---|---:|---:|
| Antes (lista vieja) | 19 | 116 |
| Después (lista nueva) | 19 | 116 |

**Idénticas.** El proyecto no tiene hoy ninguno de los tres directorios: la corrección es
**preventiva, no correctiva**, y los totales publicados antes de hoy no estaban inflados.
La retención de 2 sellos deja en `estructura/` el snapshot `20260827_090022` (lista vieja)
junto al `20260827_090029` (lista nueva); como las cifras coinciden, el primero no induce
a error.

---

## Lo que este marcador deja pendiente

- **`estado_proyecto`** sigue sin curar en `registro_proyectos.csv` (frente B del
  diagnóstico A-05). No es defecto de código y no lo toca este encargo.
- **`slep_georreferenciacion`** figura en `inventario_cartera.json` pero su directorio ya
  no existe bajo `~/Projects`: se retira con una corrida completa del pipeline, no con una
  ordenación.
