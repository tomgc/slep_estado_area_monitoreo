# Pulso CLI

Herramienta de línea de comandos que revisa la salud de un repositorio del equipo: estructura de carpetas, archivos de gobernanza presentes, `renv.lock` sincronizado y ausencia de credenciales. Pensada para correr antes de cada commit.

## Tecnologías

Go, Cobra.

## Uso

```
pulso revisar .
pulso revisar --formato json .
```
