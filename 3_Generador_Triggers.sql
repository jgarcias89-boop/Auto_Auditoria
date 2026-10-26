CREATE OR REPLACE FUNCTION generar_trigger_auditoria(p_nombre_tabla VARCHAR)
RETURNS VOID AS $$
DECLARE
    v_sql_funcion TEXT;
    v_sql_trigger TEXT;
BEGIN
    -- 1. Construir la función del trigger específica para la tabla origen[cite: 4, 5]
    v_sql_funcion := 'CREATE OR REPLACE FUNCTION trg_audit_' || p_nombre_tabla || '() RETURNS TRIGGER AS $BODY$
    DECLARE
        v_id_usuario INT := 1; -- A sustituir por variable de sesión del aplicativo
        v_id_estacion INT := 1; -- A sustituir por captura de IP real
    BEGIN
        -- Captura de operación INSERT[cite: 3]
        IF TG_OP = ''INSERT'' THEN
            INSERT INTO bitacora_auditoria(id_evento, id_usuario, id_estacion, valor_nuevo)
            VALUES (1, v_id_usuario, v_id_estacion, row_to_json(NEW)::text);
            RETURN NEW;
            
        -- Captura de operación UPDATE con valor antiguo y nuevo[cite: 3, 4]
        ELSIF TG_OP = ''UPDATE'' THEN
            INSERT INTO bitacora_auditoria(id_evento, id_usuario, id_estacion, valor_antiguo, valor_nuevo)
            VALUES (2, v_id_usuario, v_id_estacion, row_to_json(OLD)::text, row_to_json(NEW)::text);
            RETURN NEW;
            
        -- Captura de operación DELETE preservando datos originales[cite: 3, 5]
        ELSIF TG_OP = ''DELETE'' THEN
            INSERT INTO bitacora_auditoria(id_evento, id_usuario, id_estacion, valor_antiguo)
            VALUES (3, v_id_usuario, v_id_estacion, row_to_json(OLD)::text);
            RETURN OLD;
        END IF;
        RETURN NULL;
    END;
    $BODY$ LANGUAGE plpgsql;';

    -- Ejecutar la creación dinámica de la función en el servidor[cite: 4]
    EXECUTE v_sql_funcion;

    -- 2. Crear el trigger AFTER asociado a la tabla[cite: 4]
    v_sql_trigger := 'DROP TRIGGER IF EXISTS trg_after_' || p_nombre_tabla || ' ON ' || p_nombre_tabla || ';
                      CREATE TRIGGER trg_after_' || p_nombre_tabla || '
                      AFTER INSERT OR UPDATE OR DELETE ON ' || p_nombre_tabla || '
                      FOR EACH ROW EXECUTE FUNCTION trg_audit_' || p_nombre_tabla || '();';
    
    -- Ejecutar la creación del trigger en la base de datos[cite: 4]
    EXECUTE v_sql_trigger;
END;
$$ LANGUAGE plpgsql;