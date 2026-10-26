CREATE TABLE tabla_prueba (id SERIAL PRIMARY KEY, dato VARCHAR(50));
INSERT INTO tablas_auditadas (nombre_tabla) VALUES ('tabla_prueba');
SELECT generar_trigger_auditoria('tabla_prueba');

INSERT INTO tabla_prueba (dato) VALUES ('Registro Inicial');
-- Verifica la bitácora: debe registrar el valor_nuevo correctamente

UPDATE tabla_prueba SET dato = 'Registro Modificado' WHERE id = 4;
-- Verifica la bitácora: debe capturar tanto el valor_antiguo como el valor_nuevo

DELETE FROM tabla_prueba WHERE id = 5;
-- Verifica la bitácora: debe preservar los datos originales en el valor_antiguo, cumpliendo la restricción de que se mantengan aunque el registro fuente sea eliminad