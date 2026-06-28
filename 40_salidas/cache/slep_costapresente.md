---
slug: slep_costapresente
sello_ruta: slep_costapresente/50_documentacion/traspasos/traspaso-cierre-v01.md
sello_mtime: 2026-06-24
sello_hash: 5fd8b85bdb99268df79fd1781176ac4f
semaforo: pausa
proximo_paso: validar pipeline cross-OS en maquina Windows
---
**Tipo de producto:** tablero/app.

Aplicacion local de seguimiento de trayectorias escolares para un servicio local de educacion que cubre cuatro comunas y del orden de varias decenas de establecimientos educacionales y unos veinte mil estudiantes. Reune registros mensuales de matricula y asistencia (fuente: Centro de Estudios del Ministerio de Educacion) en un pipeline de dos pasos: un ETL que normaliza planillas y produce archivos columnar, y una app que permite consultar la trayectoria individual de un estudiante (recorrido entre establecimientos, asistencia, retiros, alta movilidad) mas una vista agregada del territorio con deteccion de casos que desaparecen sin baja formal.

La ultima sesion cerro la estabilizacion de infraestructura post-migracion: centralizacion de gestion de paquetes, auto-ejecucion del orquestador, scanner de estructura y diagrama de arquitectura; el pipeline corre end-to-end en macOS. Pendiente priorizado y bloqueante para produccion: validacion cross-OS en Windows (los usuarios finales operan Windows); pendiente menor: actualizar diagrama del instructivo. Deuda tecnica: app monolitica y umbrales hardcodeados; instructivo binario fuera de control de versiones. Sin despliegue publico: opera local, sin versionar datos. Gobernanza: si maneja datos personales sensibles de ninos, ninas y adolescentes, con resguardo estricto fuera del repositorio.

Procedencia: traspaso-cierre-v01 (2026-06-24); resena.
