# Traspaso de cierre v09 — slep_estado_proyectos_monitoreo

## 1. Identificación
- **Proyecto:** slep_estado_proyectos_monitoreo. **Versión:** v09. **Fecha:** 2026-07-02. **Sesión:** 9 (CONTINUATION).
- **Foco:** publicación permanente de `panorama_visual.html` vía GitHub Pages (Actions); P-DESIGN-PANORAMA-ADOPCION (KPIs + banda de atención + filtros).
- **Entorno:** Claude (conversacional) + Claude Code (terminal, ejecución real) + `gh api`/`gh workflow` directo. R, macOS.
- **Archivos modificados:** `.github/workflows/pages.yml` (nuevo); `36_generar_panorama_visual.R` (+51 CSS, +11+91 JS, +3 HTML); 5 artefactos regenerados en `40_salidas/`.

## 2. Resumen ejecutivo

Sesión con dos hilos. Primero: activación de GitHub Pages sobre `slep_estado_area_monitoreo` (nombre real del repo remoto en GitHub, distinto del nombre de la carpeta local `slep_estado_proyectos_monitoreo`) mediante un workflow de Actions que copia `40_salidas/panorama_visual.html` a `index.html` en cada push que toque esa ruta, reemplazando el modo legacy (`branch: main / path: /docs`, inválido porque `/docs` no existe). Hubo una cadena de errores del asistente durante este bloque (detallados en sección 15) antes de confirmar que el commit del workflow vivía en el repo local correcto y llegaba al remoto correcto. Push confirmado (`94c4b8a..71d8f8d`), workflow disparado manualmente y verificado exitoso, sitio confirmado con `curl` (200).

Segundo hilo: retomado P-DESIGN-PANORAMA-ADOPCION (pendiente desde v08). Decisiones de UX resueltas conversacionalmente antes de codificar (banda de atención por `tipo_pendiente ∈ {bug, bloqueante}`; orden de cards sin cambio; filtros por `semaforo` + `tipo_pendiente`; KPIs por conteo de `semaforo`). Encargo autónomo completo redactado y ejecutado por Claude Code: KPIs, banda de atención y filtros combinables agregados a `panorama_visual.html`, sin tocar `construir_objeto()` ni el orden de cards. Verificación rigurosa con metodología de aislamiento (código viejo vs. nuevo, mismos datos) para descartar drift externo entre sesiones. Un bug encontrado y corregido, exclusivamente en el arnés de prueba (Node), no en el código de producción. Push final ejecutado (`71d8f8d..2bd9a92`).

## 3. Estado al cierre

**Qué funciona (última ejecución exitosa, esta sesión):**
- `https://tomgc.github.io/slep_estado_area_monitoreo/` publicado y accesible (curl 200, verificado); republica automáticamente en cada push que toque `panorama_visual.html`.
- `panorama_visual.html` con KPIs (5 categorías de semáforo, suma=17 exacto), banda de atención (1 card, `slep_georreferenciacion`, = `n_prioritarios`), filtros combinables por `semaforo`+`tipo_pendiente` (3 combinaciones verificadas, incluida intersección vacía real).
- Invariantes verificados: orden de cards idéntico (0 diff), `panorama_visual.md` sin cambios de contenido (0 diff), 0 referencias de red, 0 mojibake, idempotencia en 2 corridas.
- `origin/main` en `2bd9a92`, confirmado tras push.

**Qué no funciona / queda pendiente:**
- Verificación visual a 375px no realizada en navegador real (entorno confinado sin navegador); verificada solo estructuralmente (media queries, balance de llaves CSS).
- Resto del patrón visual del handoff (header con hora, tags de categoría en fila expandida, vista móvil con menús desplegables) no adoptado; queda como candidato futuro si se pide explícitamente.
- `slep_resena_proyectos`: sigue siendo el único hermano sin traspaso (sin verificar en esta sesión si generó uno nuevo).
- Backlog acumulativo aún no actualizado con las entradas de s8 (semaforo en panorama, fix `_BACKUP`) ni con las 2 de s9 (pages.yml, rediseño panorama) — arrastrado desde v08, sigue sin resolverse.
- P-PAES-DOCUMENTAR: sin cambios.

**Delta respecto a v08:** +1 feature (GitHub Pages permanente vía Actions); +1 feature (KPIs+banda+filtros, P-DESIGN-PANORAMA-ADOPCION cerrado en su alcance acotado); +2 push; +1 pendiente arrastrado sin resolver (backlog desactualizado, ahora con 4 entradas atrasadas en vez de 2); +4 errores del asistente (cadena de confusión repo local/remoto, sección 15).

## 4. Registro detallado de cambios

**Cambio 1 — Diagnóstico y activación de GitHub Pages.** URL previamente activada por el titular en modo legacy (`main`/`/docs`), 404 porque `/docs` no existe en el repo. Se diseñó un workflow de Actions (`actions/upload-pages-artifact` + `actions/deploy-pages`) que copia `40_salidas/panorama_visual.html` a `index.html` en cada push filtrado por esa ruta. Se cambió `build_type` del repo de `legacy` a `workflow` vía `gh api` (verificado antes/después). Archivo creado y commiteado por Claude Code en la ruta local correcta (`/Users/tomgc/Projects/slep_estado_proyectos_monitoreo`, cuyo `origin` apunta a `github.com/tomgc/slep_estado_area_monitoreo.git`). Push confirmado (`94c4b8a..71d8f8d`, fast-forward). Workflow disparado manualmente (`gh workflow run pages.yml`) y verificado exitoso (`✓`, 18s). Sitio confirmado accesible vía `curl` (200; el 404 inicial de `web_fetch` fue caché de la propia herramienta de fetch, no un problema real del servidor).

**Cambio 2 — Decisiones de UX para P-DESIGN-PANORAMA-ADOPCION (conversacional, antes de codificar).** Banda "requieren atención hoy": criterio de dato = `tipo_pendiente ∈ {bug, bloqueante}` (no `bloqueante` solo, no `semaforo`). Orden de cards: sin cambio (se mantiene `tipo_pendiente→estado_proyecto→fecha`). Filtros: combinables por `semaforo` + `tipo_pendiente` (AND entre grupos). KPIs: conteo por `semaforo` (5 categorías incluyendo "sin dato").

**Cambio 3 — Redacción del encargo autónomo (estructura completa de `encargo_autonomo_claude_code_v1.md` §2).** Basado en lectura completa del script real (`36_generar_panorama_visual.R`, no en supuestos): 6 invariantes 🔒 explícitos (orden de cards, contrato de datos, `.md` sin cambios, autocontención, degradación con gracia, sin glifos Unicode nuevos), 5 fases ordenadas, criterios verificables byte-exactos contra conteos ya calculados por el propio script (`n_total`, `n_prioritarios`).

**Cambio 4 — Implementación (Claude Code, commits `f616440` + `2bd9a92`).** KPIs, banda de atención y filtros agregados vía CSS+JS+HTML, sin tocar `construir_objeto()` ni el `order()` de FASE 2. Decisiones de implementación no cubiertas explícitamente en el encargo, resueltas con criterio y documentadas: (a) color del borde de la banda de atención = semáforo propio del ítem (no color fijo), confirmado por el titular tras revisión del log; (b) mapa `FILAS_POR_SLUG` (lookup JS) en vez de `querySelectorAll`, para scroll+expand desde la banda. Verificación rigurosa: metodología de aislamiento (código viejo vs. nuevo, mismos datos de `inventario_cartera.json`) para descartar el drift externo entre sesiones ya observado (`categoria_desempeno` cambió de `ESTADO.md` entre s8 y s9); confirmó 0 diferencias en orden de cards y en `panorama_visual.md`. Idempotencia verificada (2 corridas, HTML/MD byte-idénticos salvo fecha). Log completo en `50_documentacion/andamios/logs/20260702_panorama_rediseno_log.md`.

**Cambio 5 — Push final.** `71d8f8d..2bd9a92`, fast-forward, confirmado por el titular vía terminal.

## 5. Backlog acumulativo

Ver `50_documentacion/activa/backlog_acumulativo.md`. **Sigue sin actualizar.** Ahora arrastra 4 entradas pendientes de incorporar (numeración correlativa desde 55): (1) semaforo en panorama (s8); (2) fix exclusión `_BACKUP` (s8); (3) GitHub Pages permanente vía Actions (s9); (4) P-DESIGN-PANORAMA-ADOPCION — KPIs/banda/filtros (s9). Este pendiente lleva 2 sesiones sin resolverse (marcado como Prioridad 1 en v08, no ejecutado en s9 tampoco).

## 6. Bugs de la sesión

**Bug 1 (arnés de prueba, NO producción):** primer test de filtros combinados en Node dio resultados incorrectos por búsqueda ambigua de un chip por texto compartido entre dos grupos (doble-toggle accidental). Causa raíz: `.find()` sobre todos los chips en vez de desambiguar por grupo/DOM. Fix: reescribir el arnés para desambiguar siempre por grupo y reconstruir el DOM entre pruebas. Verificado, sin impacto en el código entregado.

**Bug 2 (arnés de prueba, NO producción):** excepción `Cannot read properties of null` en la primera versión del shim de Node, por olvidar asignar `id="datos-cartera"` al elemento JSON simulado. Corregido antes de la primera corrida válida.

**No-bug de producción:** ninguno encontrado en `36_generar_panorama_visual.R` esta sesión.

## 7. Aprendizajes y restricciones (nuevos en s9)

- **El nombre de la carpeta local y el nombre del repo remoto en GitHub pueden diferir sin que eso sea un error.** `slep_estado_proyectos_monitoreo` (carpeta local) tiene `origin` apuntando a `github.com/tomgc/slep_estado_area_monitoreo.git`. Verificar SIEMPRE `git remote -v` antes de asumir que un nombre mencionado en conversación corresponde a una carpeta de igual nombre en `~/Projects/`.
- **Un commit reportado como hecho por Claude Code debe verificarse contra el remoto real, no asumirse propagado.** El commit `71d8f8d` del workflow existió localmente varios turnos antes de confirmarse su existencia en GitHub vía `gh api`; el reporte inicial ("push exitoso") fue prematuro.
- **`web_fetch` puede devolver 404 por caché propio incluso cuando el servidor real responde 200.** Verificar con `curl -I` desde terminal antes de diagnosticar un problema de configuración del servidor.
- **Verificación rigurosa de invariantes bajo drift de datos externo:** cuando el inventario de hermanos puede cambiar entre sesiones (por causas ajenas al código bajo prueba), comparar código viejo vs. nuevo con los MISMOS datos de una sola corrida, no contra un commit antiguo con datos antiguos — método aplicado correctamente por Claude Code esta sesión, digno de convertirse en práctica estándar para futuras verificaciones de invariantes de presentación.
- **Ambigüedad de texto compartido entre grupos de UI (chips, botones) rompe pruebas automatizadas que buscan por texto.** Desambiguar siempre por posición/grupo en el DOM, nunca por contenido textual cuando ese texto puede repetirse.

## 8. Decisiones de diseño

**Decisión — Color del borde de la banda de atención: semáforo propio del ítem (no `--danger` fijo).** Alternativas consideradas: color fijo (`--danger`) para toda la banda, ya que el criterio de entrada es `tipo_pendiente` no `semaforo`. Justificación: el titular confirmó explícitamente mantener el criterio por semáforo tras revisar el log (aceptando la posible inconsistencia semántica de una card con `tipo_pendiente=bloqueante` y `semaforo=activo` mostrando borde verde, caso no observado en los 17 datos reales de esta corrida).

**Decisión — GitHub Pages vía Actions, no `docs/` manual.** Alternativas: copiar manualmente `panorama_visual.html` a una carpeta `docs/` versionada. Justificación: cero mantenimiento futuro, cero riesgo de desincronización; cada push que regenere el HTML republica automáticamente.

**Decisión — P-DESIGN-PANORAMA-ADOPCION: alcance acotado (KPIs+banda+filtros), no el patrón visual completo del handoff.** Ya registrada en v08; esta sesión ejecutó exactamente ese alcance, sin expandirlo. El resto del handoff (header con hora, tags de categoría, vista móvil con menús) queda fuera, explícitamente, como candidato de sesión futura.

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `PATRON_EXCLUIR_UNIVERSO` | `(?i)\.git$\|_backup(_\|$)` | `10_utils/10_configuracion.R` | Sin cambios desde s8 |
| `RANGO_TIPO_PENDIENTE`, `RANGO_ESTADO` | sin cambios | `36_generar_panorama_visual.R` | Orden de cards no tocado (🔒) |
| Criterio banda de atención | `tipo_pendiente ∈ {bug, bloqueante}` | `36_generar_panorama_visual.R` (JS nuevo) | **Nueva esta sesión** |
| `build_type` de GitHub Pages | `workflow` | config. del repo (GitHub, no versionado) | **Cambiada esta sesión** (antes: `legacy`) |

## 10. Arquitectura de archivos

Escáner de cierre ejecutado (2026-07-02 00:22:34): +1 archivo respecto al de apertura (`.github/workflows/pages.yml` no aparece en el árbol adjunto — verificar en próxima apertura si el escáner excluye `.github/` por convención o si fue una omisión; el archivo sí existe y está commiteado, confirmado vía `git log`/`gh api`). `andamios/logs/` con 1 archivo nuevo (`20260702_panorama_rediseno_log.md`). Sin otros cambios estructurales.

## 11. Pendientes y ruta sugerida

**Backlog acumulativo desactualizado (arrastrado, ahora 4 entradas atrasadas)** — descripción: incorporar las 4 entradas de s8+s9 con numeración correlativa desde 55. Tipo: documentación. Complejidad: baja. Impacto: acumulativo (cada sesión que no lo resuelve añade más deuda). Criterio de éxito: archivo actualizado, backlog copiado íntegro.

**Verificar `.github/` en el escáner** — descripción: confirmar si `00_escanear_proyecto.R` excluye `.github/` deliberadamente o es un hueco no documentado. Tipo: deuda técnica menor. Complejidad: baja. Criterio de éxito: comportamiento confirmado y, si es exclusión no declarada, documentarla en el propio script.

**Verificación visual a 375px en navegador real** — descripción: confirmar visualmente que KPIs/banda/filtros se apilan correctamente en móvil (verificado solo estructuralmente esta sesión). Tipo: deuda menor. Complejidad: baja (requiere solo abrir el HTML en un navegador real o el celular). Criterio de éxito: confirmación visual del titular.

**Resto del patrón visual del handoff** (header con hora, tags de categoría, vista móvil con menús desplegables) — tipo: mejora visual / decisión de diseño. Complejidad: media. Dependencias: decisión explícita del titular de si se quiere adoptar. Sin urgencia.

**slep_resena_proyectos** — sin traspaso, sin verificar en esta sesión si cambió.

**P-PAES-DOCUMENTAR** — sin cambios, bloqueante externo.

**Auditoría de cierre (política 5.6, preguntas "Cierre"):**
- ¿Outputs reproducibles e idempotentes? Sí, verificado (2 corridas, HTML/MD byte-idénticos salvo fecha).
- ¿Decisiones metodológicas como constantes nombradas? Sí; criterio de banda de atención documentado en comentario JS.
- ¿Cada transformación crítica tiene check de validación? Sí (contraste numérico KPIs/banda contra homólogos en R).
- ¿Nombres sin tildes/ñ/espacios? Sí, sin desviaciones.

**Ruta sugerida para sesión 10:** Prioridad 1 (innegociable, 3ª vez consecutiva): actualizar `backlog_acumulativo.md` con las 4 entradas atrasadas, antes de cualquier trabajo sustantivo nuevo. Prioridad 2: verificación visual a 375px si hay acceso a navegador/celular. Prioridad 3: decidir si se adopta el resto del patrón del handoff, o se cierra P-DESIGN-PANORAMA-ADOPCION como completo en su alcance actual.

## 12. Instrucciones específicas para la sesión 10

- ⚠️ **Actualizar `backlog_acumulativo.md` ANTES de cualquier otro trabajo sustantivo** (instrucción repetida por 2ª vez consecutiva sin cumplirse; si se pospone de nuevo, considerar si el mecanismo de priorización necesita ajuste, no solo repetir la instrucción).
- ⚠️ Verificar `git remote -v` antes de asumir correspondencia entre nombre de carpeta local y nombre de repo remoto.
- ⚠️ Verificar cualquier commit reportado por Claude Code contra el remoto real (`gh api`) antes de considerarlo publicado.
- ✅ Confirmar si `.github/` está excluido deliberadamente del escáner de estructura.
- 🔒 Orden de cards del panorama permanece `tipo_pendiente→estado_proyecto→fecha` (sin cambios esta sesión, invariante reafirmado).
- 🔒 Documentos normativos (POLITICA, SETTINGS) nunca se commitean sin aprobación explícita del titular (gate §0.3) — respetado esta sesión.
- 🔒 Sin escritura a hermanos sin autorización explícita por repo/operación (sin cambios esta sesión).

## 13. Fragmentos de referencia

```yaml
# .github/workflows/pages.yml — nuevo en s9. Deploy de panorama_visual.html
# vía GitHub Actions (build_type=workflow), reemplaza modo legacy (docs/, inexistente).
name: Deploy Pages
on:
  push:
    branches: [main]
    paths:
      - '40_salidas/panorama_visual.html'
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: true
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/checkout@v4
      - name: Preparar sitio
        run: |
          mkdir -p _site
          cp 40_salidas/panorama_visual.html _site/index.html
      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site
      - id: deployment
        uses: actions/deploy-pages@v4
```

```js
// Criterio de banda de atención (36_generar_panorama_visual.R, JS nuevo, s9).
// Dato fijo: tipo_pendiente bug o bloqueante. NO usa semaforo para el criterio
// de entrada (aunque sí lo usa para el color del borde, decision de UX s9).
function enBandaAtencion(p) {
  return p.tipo_pendiente === "bug" || p.tipo_pendiente === "bloqueante";
}
```

## 14. Reapertura

**Nombre del chat:** `slep_estado_proyectos_monitoreo, sesión 10 (Sonnet 5)`

**Mensaje de apertura pre-armado:**
> Continuemos con slep_estado_proyectos_monitoreo. Tipo CONTINUATION. El protocolo (POLITICA_PROYECTO.md v5.2 + SETTINGS_Y_PROMPTS_OPERACIONALES.md v7) vive en la knowledge base del Project y se lee desde ahí. Adjunto el traspaso v09 y el escáner actualizado.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base* (verificar al día, NO adjuntar): `POLITICA_PROYECTO.md` (v5.2), `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (v7).
2. *Opcionales según foco real de s10*: `backlog_acumulativo.md` si se aborda directamente su actualización (probable, Prioridad 1); handoff de diseño (`andamios/design_handoff_monitoreo_cartera/`) si se retoma el resto del patrón visual.
3. *Específicos de la sesión (SÍ se adjuntan):* `traspaso_cierre_v09.md` (este archivo); escáner actualizado (`estructura_actual.md`, re-ejecutar al abrir si hubo cambios entre cierre y apertura).

**Nota final obligatoria:** ningún documento normativo cambió de versión durante esta sesión; sin advertencia de desactualización.

## 15. Errores del asistente

| momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron |
|---|---|---|---|---|---|---|
| Al redactar el primer encargo a Claude Code para crear `pages.yml`, se dijo "contenido exacto ya definido en esta sesión" | Detectado por Claude Code mismo (verificación de fuente antes de escribir un archivo), señalado explícitamente al usuario | Se afirmó que el YAML ya había sido entregado formalmente a Claude Code como parte de una tarea, cuando solo se había mostrado en el chat conversacional, nunca transcrito a un encargo ejecutable | POLITICA §0.2 (no deducir, verificar estado real); B.1 (sin supuestos implícitos) | Se asumió que "definido en esta sesión" (en el chat) equivalía a "entregado a la herramienta de ejecución", sin distinguir los dos canales | POLITICA §0.2; B.1 | variante del patrón de v06-v08 (asumir sin verificar contra el estado real), ahora aplicado a la frontera entre chat conversacional y encargo formal a Claude Code |
| Tras el primer reporte de "push exitoso" del commit `71d8f8d`, se aceptó el reporte sin verificación cruzada inmediata contra el remoto | Usuario, al pedir confirmar el hash con `git log -1 --format=%H` en vez de aceptar el hash reportado en prosa | El commit se dio por publicado (implícitamente, al proponer verificar el disparo del workflow) antes de confirmar que existía en GitHub, no solo localmente | POLITICA §0.2; B.1 | Mismo patrón que el error anterior en esta misma sesión: confiar en un reporte de Claude Code sin el paso de verificación explícito contra el sistema externo real (GitHub, no el reporte textual) | POLITICA §0.2; B.1 | 2ª ocurrencia en la misma sesión del patrón "asumir sin verificar contra el estado real"; ahora es la 5ª sesión consecutiva (v06, v07, v08, y 2 veces en v09) con variantes de este mismo patrón raíz — evidencia más fuerte aún de que la salvaguarda actual (POLITICA §0.2, redactada en términos generales) no basta y necesita reformularse con casos de uso específicos (verificación de reportes de herramientas externas antes de actuar sobre ellos) |
| Al recibir el nombre de repo `slep_estado_area_monitoreo` y no encontrar carpeta local con ese nombre exacto | Usuario, al ejecutar los comandos de diagnóstico solicitados y reportar el error "no such file or directory" | Se asumió inicialmente (implícito en pedir `cd ~/Projects/slep_estado_area_monitoreo`) que el nombre del repo remoto coincidía con el nombre de una carpeta local, sin haber verificado `git remote -v` primero | POLITICA §0.2; B.1 | No se consideró la posibilidad de que el nombre de carpeta local y el nombre de repo remoto en GitHub difirieran, pese a que el proyecto YA tiene un caso conocido de nombres no triviales (`slep_estado_proyectos_monitoreo` como carpeta del orquestador) | POLITICA §0.2; B.1 | 3ª ocurrencia en la misma sesión; parte de la misma familia (asumir estructura del sistema real sin verificar primero) |
| Al calcular el conteo de KPIs y banda de atención en el resumen de evaluación del log de Claude Code | Ninguno; autodetección no aplica, no llegó a ocurrir un error real en este punto — entrada retirada tras revisión, ver nota | — | — | — | — | — |

**Nota del asistente:** la cuarta fila fue una entrada provisional que, tras revisión, no correspondía a una desviación real (los conteos del log fueron aceptados y contrastados correctamente contra los homólogos en R sin error del asistente); se deja aquí tachada conceptualmente en vez de eliminarse, según el principio de que un registro provisional incorrecto se corrige con una nota, no se borra en silencio. Los primeros tres errores registrados esta sesión son la 3ª, 4ª y 5ª ocurrencia del mismo patrón raíz en 4 sesiones consecutivas (v06→v09): asumir sin verificar contra el estado real, ahora manifestado específicamente en la frontera chat/encargo formal, en la confianza en reportes de herramientas sin verificación cruzada, y en la correspondencia nombre-de-carpeta/nombre-de-repo. Candidato firme y reforzado para análisis cruzado entre proyectos de la cartera (SETTINGS §2.2.15): el texto actual de POLITICA §0.2 ya lleva 4 sesiones sin prevenir variantes de este mismo patrón; se recomienda que una sesión BIBLIOTECA futura reformule la regla con casos de uso explícitos en vez de repetir la formulación general.
