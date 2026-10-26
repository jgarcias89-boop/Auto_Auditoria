--Consulta por identificador de usuario
SELECT 
    b.fecha_hora,
    t.nombre_tabla,
    e.tipo_operacion,
    u.username,
    est.ip_origen,
    b.valor_antiguo,
    b.valor_nuevo
FROM bitacora_auditoria b
JOIN eventos_auditoria e ON b.id_evento = e.id_evento
JOIN columnas_auditadas c ON e.id_columna = c.id_columna
JOIN tablas_auditadas t ON c.id_tabla = t.id_tabla
JOIN usuarios_auditados u ON b.id_usuario = u.id_usuario
JOIN estaciones_trabajo est ON b.id_estacion = est.id_estacion
WHERE u.id_usuario = 1 
ORDER BY b.fecha_hora DESC;

--Consulta por columna específica

SELECT 
    b.fecha_hora,
    t.nombre_tabla,
    c.nombre_columna,
    e.tipo_operacion,
    u.username,
    b.valor_antiguo,
    b.valor_nuevo
FROM bitacora_auditoria b
JOIN eventos_auditoria e ON b.id_evento = e.id_evento
JOIN columnas_auditadas c ON e.id_columna = c.id_columna
JOIN tablas_auditadas t ON c.id_tabla = t.id_tabla
JOIN usuarios_auditados u ON b.id_usuario = u.id_usuario
WHERE t.nombre_tabla = 'nombre_de_la_tabla' /* Parámetro de tabla */
  AND c.nombre_columna = 'nombre_de_la_columna' /* Parámetro de columna */
ORDER BY b.fecha_hora DESC;

