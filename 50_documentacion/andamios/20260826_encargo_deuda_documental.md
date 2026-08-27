# Encargo A-18 — Cierre de deuda documental del repositorio propio

- **Proyecto:** `slep_estado_proyectos_monitoreo`
- **Raíz:** `~/Projects/slep_estado_proyectos_monitoreo`
- **Sesión:** 13 (CONTINUATION)
- **Cubre:** O-29 (motor del censo no versionado), O-17 (clasificación temática del
  backlog), O-21 (descripciones obsoletas del registro), O-22 (`ventana_insumos`).
- **Naturaleza:** documentación y datos del repositorio propio. **Ningún archivo de
  `30_procesamiento/` ni de `10_utils/` se toca en este encargo.** Todo lo que sea código
  espera al diagnóstico A-05.

---

## 1. Precondición verificable

```bash
cd ~/Projects/slep_estado_proyectos_monitoreo && \
  git status --porcelain && echo "--- fin status ---" && \
  git rev-parse --abbrev-ref HEAD && \
  git rev-list --left-right --count HEAD...origin/main
```

Rama `main`, conteo `0	0`. Si `status` devuelve líneas, nómbralas y detente, salvo que
sean el motor del censo en el scratchpad, que es precisamente lo que el bloque 1 viene a
versionar.

---

## 2. Alcance de escritura cerrado

- `50_documentacion/andamios/` (motor del censo)
- `50_documentacion/activa/backlog_acumulativo.md`
- `50_documentacion/activa/ESTADO.md`, **solo** el campo `ventana_insumos`
- `README.md`
- `CLAUDE.md` (está en `.gitignore`: se edita en disco y no se commitea)

Cualquier otra ruta: detente y nómbrala.

---

## 3. Bloque 1 — Versionar el motor del censo (O-29)

Mover el script del censo desde el scratchpad a
`50_documentacion/andamios/20260826_censo_backlogs_motor.R` y commitearlo junto a una
cabecera de comentario de diez líneas como máximo que declare: qué mide, contra qué
encargo se escribió (`20260826_encargo_censo_backlogs.md`), y **las cinco premisas falsas
que la ejecución corrigió**, cada una en una línea. Sin esa lista, quien lo vuelva a
correr en seis meses reintroduce los cinco falsos positivos.

Va a `andamios/` y no a `30_procesamiento/` porque no es parte del pipeline: es
instrumento de medición puntual. Que esté congelado es correcto; que no exista, no.

**Criterio:** el archivo existe, está versionado, y `Rscript` sobre él con el autotest del
§6 del encargo vuelve a dar 6 de 6. Si el motor no es re-ejecutable tal como quedó (por
rutas absolutas del scratchpad, por ejemplo), corrígelas para que lo sea y dilo.

---

## 4. Bloque 2 — Clasificación temática del backlog (O-17)

`## Clasificacion tematica` de `backlog_acumulativo.md` cubre hasta la entrada 54 y su
columna `N` no cuadra con el total declarado en `## Resumen estadistico por sesion`.

1. Calcula, programáticamente, la suma actual de la columna `N` y el total declarado.
   Transcribe las dos cifras y su diferencia. **No hagas aritmética a mano.**
2. Clasifica las entradas posteriores a la 54 que **sí existen en el archivo**, usando las
   categorías ya presentes. Si una entrada no cae en ninguna, crea una categoría nueva y
   dilo; no la fuerces dentro de una existente.
3. Añade una fila explícita, con este texto exacto en la descripción:
   `| Perdidas (55-61) | 7 | Nunca llegaron a git en las sesiones 8 a 10. Irrecuperables. No se reconstruyen. |`
4. La suma de la columna `N`, incluida esa fila, tiene que igualar el total declarado en
   el resumen por sesión.

**Prohibición literal, heredada del traspaso v12:** no reconstruyas las entradas 55 a 61
desde los temas que v09 y v10 enumeran. Su hueco es permanente y declararlo es la
conducta correcta. Si la cuadratura solo cierra inventando contenido, **no cierra**:
reporta el descuadre con sus dos cifras y deja el archivo como está.

**Criterio:** suma de `N` igual al total declarado, la fila de pérdidas presente, y
`git diff --stat` tocando exactamente un archivo.

---

## 5. Bloque 3 — Descripciones obsoletas del registro (O-21, O-22)

D-01 movió `registro_proyectos.csv` a `40_salidas/` y lo sacó del control de versiones.
Tres textos siguen describiendo el mundo anterior:

1. `README.md:53`: lo llama único insumo curado a mano en `20_insumos/`. Reescribir esa
   entrada para que diga lo que ahora es cierto: lo escribe el paso 1 en cada corrida, es
   destino y no fuente (A21), no se versiona, y los campos curados (`nombre_real`,
   `alias_corto`, `notas`) los completa el titular sobre el archivo generado.
2. `CLAUDE.md`: misma corrección, mismo criterio. Editar en disco; está ignorado, así que
   **no** aparece en el commit.
3. `ESTADO.md`, campo `ventana_insumos: ./20_insumos`: apunta a un directorio que quedó
   vacío. Cambiar a `./40_salidas`. Ningún otro campo de `ESTADO.md` se toca.

**Criterio:** `grep -rn "insumo curado a mano" README.md CLAUDE.md` vacío;
`grep "^ventana_insumos:" 50_documentacion/activa/ESTADO.md` devuelve `./40_salidas`.

---

## 6. Commits

Tres, separados, en este orden:

```
docs(andamios): versiona el motor del censo de backlogs

Cierra O-29. Incluye las cinco premisas falsas que la ejecucion corrigio.
```
```
docs(backlog): cuadra la clasificacion tematica y declara las entradas perdidas

Cierra O-17. Las entradas 55-61 quedan como fila explicita, no se reconstruyen.
```
```
docs(registro): corrige las descripciones del registro tras D-01

Cierra O-21 y O-22. README y ventana_insumos apuntaban al mundo anterior a la mudanza.
```

Push al final, y verificación de publicación por `ls-remote` contra `rev-parse HEAD`
(A29). No declares publicado nada cuyos dos hashes no hayas visto coincidir.

---

## 7. Qué reportar

1. Las dos cifras del §4.1 y su diferencia, antes y después.
2. El resultado del autotest del motor re-ejecutado desde su nueva ruta.
3. Los tres hashes, de 40 hex, y la confirmación de publicación.
4. `git status --porcelain` final y el conteo contra `origin/main`.
5. Cualquier premisa falsa de este encargo, corregida en la ejecución y nombrada. Ya van
   seis en la sesión: la costumbre está establecida.
