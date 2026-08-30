# Estructura del proyecto (escaner)

- Raiz       : slep_estado_proyectos_monitoreo
- Fecha      : 2026-08-30 01:05:32
- Directorios: 19
- Archivos   : 132
- Tamano     : 2.56M

## Arbol

```
slep_estado_proyectos_monitoreo/
.DS_Store  (10K)
.github/
  workflows/
    pages.yml  (704)
.gitignore  (1.09K)
.Renviron.example  (1.93K)
.Rhistory  (76)
.Rprofile  (26)
00_escanear_proyecto.R  (5.63K)
00_run_all.R  (4.66K)
10_utils/
  10_configuracion.R  (6.32K)
  10_locale.R  (8.91K)
  10_utils.R  (6.15K)
  10_validar_portabilidad.R  (16.4K)
20_insumos/
30_procesamiento/
  31_descubrir_proyectos.R  (8.75K)
  32_localizar_documentos.R  (18K)
  33_extraer_metadatos.R  (3.73K)
  34_compilar_inventario.R  (6.99K)
  35_compilar_panorama.R  (8.98K)
  36_generar_panorama_visual.R  (70.8K)
40_salidas/
  .Rhistory  (0)
  cache/
    slep_alertas_ael.md  (1.75K)
    slep_aprendizajes_ep.md  (1.87K)
    slep_categoria_desempeno.md  (1.81K)
    slep_costapresente.md  (1.67K)
    slep_dashboard_personal_monitoreo.md  (1.99K)
    slep_georreferenciacion.md  (2.02K)
    slep_idps.md  (1.78K)
    slep_minuta_asistencia.md  (1.69K)
    slep_minuta_desvinculacion.md  (1.82K)
    slep_rendimiento_historico.md  (1.97K)
    slep_reportes_modelo_resguardo_asistencia.md  (1.83K)
    slep_seguimiento_educacion_inicial.md  (2.01K)
    slep_simce_adecuado.md  (1.78K)
    slep_simce_estandares_aprendizaje.md  (1.92K)
  inventario_cartera.json  (38.6K)
  inventario_cartera.parquet  (21.2K)
  panorama_visual.html  (63.5K)
  panorama_visual.md  (33.6K)
  panorama.md  (34.6K)
  registro_proyectos.csv  (3.16K)
50_documentacion/
  .DS_Store  (14K)
  activa/
    .DS_Store  (6K)
    50_locale_utf8.md  (2.06K)
    50_ordenacion_repositorio.md  (4.08K)
    backlog_acumulativo.md  (28.1K)
    decisiones/
      20260628_decision_arquitectura_orquestador.md  (4.21K)
      20260710_decision_desalineacion_nombres_repos.md  (5.38K)
    ESTADO.md  (1.51K)
    POLITICA_PROYECTO.md  (42.8K)
    SETTINGS_Y_PROMPTS_OPERACIONALES.md  (137K)
  andamios/
    .DS_Store  (6K)
    20260710_inventario_repos_y_nuevos.md  (10.6K)
    20260824_censo_cartera.csv  (13.5K)
    20260824_censo_cartera.md  (91.1K)
    20260824_delta_normativo_kb.md  (16.4K)
    20260824_encargo_censo_cartera.md  (28K)
    20260824_encargo_rescate_tramo_a.md  (11.1K)
    20260824_encargo_rescate_tramo_b.md  (10.7K)
    20260824_pendientes_y_encargos.md  (12.9K)
    20260824_ruta_comando_unico.md  (17.4K)
    20260826_censo_backlogs_autotest.R  (5.43K)
    20260826_censo_backlogs_cartera.csv  (5.5K)
    20260826_censo_backlogs_cartera.md  (15.4K)
    20260826_censo_backlogs_motor.R  (9.94K)
    20260826_diagnostico_campos_perdidos.md  (11.4K)
    20260826_encargo_apertura_s13.md  (10.1K)
    20260826_encargo_backlog_55_67.md  (9.61K)
    20260826_encargo_censo_backlogs.md  (8.49K)
    20260826_encargo_correccion_frente_a.md  (6.41K)
    20260826_encargo_deuda_documental.md  (5.75K)
    20260826_encargo_diagnostico_a05.md  (6.93K)
    20260826_encargo_ordenacion_a03.md  (8.51K)
    20260826_encargo_rescate_tramo_b_v2.md  (12.2K)
    20260826_pendientes_ruta_e_itinerario.md  (12.2K)
    20260826_registro_proyectos_linea_base.csv  (3.14K)
    20260826_verificacion_frente_a.md  (21.2K)
    20260827_censo_backlogs_driver.R  (6.72K)
    20260827_encargo_apertura_v14.md  (20.6K)
    20260827_encargo_ruta_v14.md  (27.4K)
    20260827_encargo_ruta_v14b.md  (23.8K)
    20260827_encargo_universo_v14c.md  (21.4K)
    auditoria_backlogs_20260629.md  (11.9K)
    design_handoff_monitoreo_cartera/
      assets/
        colors_and_type.css  (8.31K)
        fonts/
          gobCL_Heavy.otf  (43.7K)
          gobCL_Light.otf  (37.1K)
          gobCL_Regular.otf  (35.7K)
          MuseoSans_500.otf  (61K)
          MuseoSans_700.otf  (62.1K)
          MuseoSans-300.otf  (61.5K)
        logo-color-stacked.png  (126K)
        logo-mark-cc.png  (118K)
        logo-white-stacked.png  (143K)
      Panorama de cartera.dc.html  (34.4K)
      README.md  (7.72K)
      registro_proyectos.csv  (2.84K)
      support.js  (58.7K)
    logs/
      20260629_panorama_visual_log.md  (6.49K)
      20260701_panorama_semaforo_log.md  (17.1K)
      20260702_panorama_rediseno_log.md  (12.4K)
      20260702_patron_visual_handoff_log.md  (16.8K)
      20260827_apertura_v14_log.md  (26.9K)
      20260827_ruta_v14_log.md  (33K)
      20260827_ruta_v14b_log.md  (41.5K)
      20260827_universo_v14c_log.md  (41.7K)
      cierres_log.md  (15K)
    paquete_cierre_v14.md  (48K)
  estructura/
    20260827_090022_estructura.md  (5.18K)
    20260827_090022_estructura.txt  (5.18K)
    20260827_090029_estructura.md  (5.18K)
    20260827_090029_estructura.txt  (5.18K)
    20260827_095403_estructura.md  (5.37K)
    20260827_095403_estructura.txt  (5.37K)
    estructura_actual.md  (5.37K)
    estructura_actual.txt  (5.37K)
  traspasos/
    .DS_Store  (8K)
    archivo/
      traspaso_cierre_v01.md  (13.1K)
      traspaso_cierre_v02.md  (15.2K)
      traspaso_cierre_v03.md  (16.6K)
      traspaso_cierre_v04.md  (39K)
      traspaso_cierre_v05.md  (28.4K)
      traspaso_cierre_v06.md  (22.4K)
      traspaso_cierre_v07.md  (15.2K)
      traspaso_cierre_v08.md  (17.2K)
      traspaso_cierre_v09.md  (22.3K)
      traspaso_cierre_v10.md  (26.6K)
      traspaso_cierre_v11.md  (24.5K)
      traspaso_cierre_v12.md  (29.1K)
    traspaso_cierre_v13.md  (26.8K)
CLAUDE.md  (15K)
README.md  (6.9K)
renv.lock  (65.7K)
slep_estado_proyectos_monitoreo.Rproj  (248)
tests/
  test_orquestador.R  (4.54K)
```

## Conteo por extension

```
  md                 79
  R                  16
  otf                6
  (sin extension)    5
  csv                5
  txt                4
  png                3
  html               2
  Rhistory           2
  css                1
  example            1
  gitignore          1
  js                 1
  json               1
  lock               1
  parquet            1
  Rprofile           1
  Rproj              1
  yml                1
```
