--Consulta para listar todas las tablas de usuario 
SELECT
    n.nspname AS nombre_esquema,
    c.relname AS nombre_tabla
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r' 
  AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
ORDER BY n.nspname, c.relname;

--Consulta para listar las columnas de una tabla específica
SELECT
    a.attname AS nombre_columna,
    t.typname AS tipo_dato
FROM pg_attribute a
JOIN pg_class c ON a.attrelid = c.oid
JOIN pg_type t ON a.atttypid = t.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE c.relname = 'bitacora_auditoria' 
  AND n.nspname = 'public' 
  AND a.attnum > 0 
  AND NOT a.attisdropped
ORDER BY a.attnum;