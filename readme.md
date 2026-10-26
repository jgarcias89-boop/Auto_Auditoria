# AutoAudit - Sistema de Auditoría Automatizado

## Descripción General
AutoAudit es un sistema de auditoría configurable diseñado para rastrear y registrar cambios de datos en bases de datos relacionales. El sistema permite a los administradores seleccionar tablas y columnas específicas mediante consultas al diccionario de datos, y generar dinámicamente triggers en PL/pgSQL para capturar cualquier modificación (INSERT, UPDATE, DELETE). Toda la información se almacena de forma centralizada en una bitácora histórica, preservando el contexto de la operación (usuario, IP de origen, fecha, valores antiguos y nuevos).

## Requisitos Técnicos
* Motor de Base de Datos: PostgreSQL 18
* Sistema Operativo: Ubuntu 26.04 LTS
* Lenguaje: PL/pgSQL para la generación de triggers

## Estructura del Repositorio
Este repositorio contiene los scripts necesarios para la instalación, configuración y prueba del sistema:

* `1_DDL_Inicial.sql`: Scripts de creación de las tablas de configuración, diccionario de datos y bitácora del sistema.
* `2_Consultas_Diccionario.sql`: Instrucciones para extraer información dinámica del catálogo interno de PostgreSQL (`pg_class`, `pg_attribute`).
* `3_Generador_Triggers.sql`: Procedimiento almacenado en PL/pgSQL que automatiza la creación de los triggers `AFTER` según la configuración almacenada.
* `4_Consultas_Historicas.sql`: Sentencias parametrizadas para generar reportes del historial de cambios por usuario o por columna específica.
* `5_Casos_Prueba.sql`: Ejemplos funcionales de inserción, actualización y eliminación de registros para validar la captura en la bitácora.

## Instrucciones de Instalación y Despliegue

1. **Clonar el repositorio:**
   Descarga este repositorio en tu entorno local.
2. **Conexión a la Base de Datos:**
   Abre tu gestor de base de datos preferido (DBeaver o pgAdmin 4) y conéctate a una instancia activa de PostgreSQL 18.
3. **Ejecución de Scripts DDL:**
   Abre una ventana de consulta y ejecuta el contenido del archivo `1_DDL_Inicial.sql` para crear la estructura relacional.
4. **Despliegue del Motor Generador:**
   Ejecuta el archivo `3_Generador_Triggers.sql` para compilar la función principal en la base de datos.
5. **Configuración y Validación:**
   Sigue las instrucciones del archivo `5_Casos_Prueba.sql` para simular la configuración de una tabla de prueba, activar su auditoría y generar eventos transaccionales.