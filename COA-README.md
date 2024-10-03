
# COA - Alejandro Silva

## Pre-requisites

Para poner en marcha el proyecto se utilizan contendores docker, revisar la seccion run with docker del [README.md](README.md) para correr el proyecto.

La primera vez que se corre el proyecto para crear nuevos usuarios es necesario crear un "edificio" a través del modelo building.rb y crear las adscripciones de la dependencia utilizando el modelo adscription.rb  (puede ser desde consola o se pueden agregar al seed.rb)

## Endpoint: Servicio web students

Este endpoint permite crear un nuevo registro de estudiante en el sistema. Se debe enviar una solicitud `POST` con los datos del estudiante en formato JSON.

### URL

http://127.0.0.1:3000/api/students

### Autenticación

Se requiere que la ip se encuentre en la "whitelist" de momento desactivado para este ejercicio

### Headers

- `Authorization`: Token para autenticación. / No se utiliza para este ejemplo, pero en production es recomendable activarlo junto con un whitelist de ips para mayor seguridad.
- `Content-Type`: `application/json`

### Parámetros

Los siguientes parámetros son necesarios en el cuerpo de la solicitud:

| Campo                | Tipo     | Descripción                                   |
|----------------------|----------|-----------------------------------------------|
| `institution_name`   | String   | Nombre de la institución                      |
| `activity_id`        | Integer  | ID de la actividad relacionada (2 Becario, 3 Estudiante Asociado, 1 Servicio Social)               |
| `faculty`            | String   | Facultad a la que pertenece el estudiante      |
| `institutiontype_id` | Integer  | ID del tipo de institución (1 Pública, 2 Privada, 3 Otra, 4 ONG)                    |
| `indivadvicetarget_id` | Integer  | Tipo persona asesorada (3 Estudiante)                    |
| `name`               | String   | Nombre completo del estudiante                 |
| `startyear`          | Integer  | Año de inicio de la actividad                     |
| `startmonth`         | Integer  | Mes de inicio de la actividad                     |
| `hours`              | Integer  | Número total de horas                         |
| `endmonth`           | Integer  | Mes de finalización de actividad               |
| `endyear`            | Integer  | Año de finalización de actividad               |
| `registered_by_id`   | Integer  | ID del usuario que registra                   |
| `user_id`            | Integer  | ID del usuario/academico asociado                       |
| `degree_id`          | Integer  | ID del grado académico (1 Bachillerato, 2 Técnico, 3 Licenciatura, 4 Especializacion, 5 Maestria, 6 Doctorado)                        |
| `degree_name`        | String   | Nombre de la carrera que cursa, ej. Licenciatura en Informática                    |
| `country_id`         | Integer  | ID del país (484 México)                                 |
| `tutor_id`           | Integer  | ID del académico tutor asociado                         |

### Ejemplo de solicitud con curl

Este es ejemplo de como enviar una solicitud `POST` al endpoint para crear un nuevo estudiante utilizando `curl`.

```bash
curl -X POST http://127.0.0.1:3000/api/students \
-H "Content-Type: application/json" \
-d '{
  "students": {
    "institution_name": "Universidad Nacional Autónoma de México",
    "activity_id": 3,
    "faculty": "Facultad de Ciencias",
    "institutiontype_id": 1,
    "indivadvicetarget_id": 3,
    "name": "Alejandro Silva",
    "startyear": 2024,
    "startmonth": 3,
    "hours": 480,
    "endmonth": 12,
    "endyear": 2025,
    "registered_by_id": 2,
    "user_id": 2,
    "degree_id": 3,
    "degree_name": "Licenciatura en Matemáticas",
    "country_id": 484,
    "tutor_id": 2,
    "status_id": 2
  }
}'
```
### Respuesta

La respuesta a esta solicitud será un objeto JSON que contiene los detalles del estudiante creado, así como el código de estado HTTP. Un código de estado `201 Created` indica que el estudiante se creó correctamente.

## Módulo para aceptar estudiantes:
Cuando un estudiante es enviado por el API aparecerá en el listado de estudiantes del académico junto con un botón para aceptarlo, cuando se presiona el botón se actualiza el estatus del estudiante. El código de esta acción se encuentra en:

app/views/student_advices/_record.html.haml

para que este módulo funcione correctamente es necesario correr la migración add_field_status_to_individadvice.rb de la carpeta migrates


## Reporte estudiantes activos:

### Integración de Active Admin

En salva se usa **Active Admin** por lo que para este reporte se agregó un nuevo sub menú para gestionar y mostrar los estudiantes activos.

### Menú "Docencia"

Se ha agregado un nuevo elemento dentro del menú  **Docencia**, con el nombre **Estudiantes activos** el cual obtiene el listado de estudiantes activos.

Para esto se creó un nuevo scope en el modelo Indivadvice que se nombro "active_students"


