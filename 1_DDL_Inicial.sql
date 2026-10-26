-- 1. Tabla de Usuarios Auditados
CREATE TABLE usuarios_auditados (
    id_usuario SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    descripcion VARCHAR(100)
);

-- 2. Tabla de Estaciones de Trabajo
CREATE TABLE estaciones_trabajo (
    id_estacion SERIAL PRIMARY KEY,
    ip_origen VARCHAR(45) UNIQUE NOT NULL, -- Soporta IPv4 e IPv6
    nombre_host VARCHAR(100)
);

-- 3. Tabla de Tablas Auditadas
CREATE TABLE tablas_auditadas (
    id_tabla SERIAL PRIMARY KEY,
    nombre_esquema VARCHAR(50) DEFAULT 'public',
    nombre_tabla VARCHAR(100) NOT NULL,
    auditoria_activa BOOLEAN DEFAULT TRUE,
    UNIQUE (nombre_esquema, nombre_tabla)
);

-- 4. Tabla de Columnas Auditadas
CREATE TABLE columnas_auditadas (
    id_columna SERIAL PRIMARY KEY,
    id_tabla INT NOT NULL REFERENCES tablas_auditadas(id_tabla) ON DELETE CASCADE,
    nombre_columna VARCHAR(100) NOT NULL,
    auditoria_activa BOOLEAN DEFAULT TRUE,
    UNIQUE (id_tabla, nombre_columna)
);

-- 5. Tabla de Eventos de Auditoría (Configuración por tabla/columna)
CREATE TABLE eventos_auditoria (
    id_evento SERIAL PRIMARY KEY,
    id_columna INT NOT NULL REFERENCES columnas_auditadas(id_columna) ON DELETE CASCADE,
    tipo_operacion VARCHAR(10) NOT NULL CHECK (tipo_operacion IN ('INSERT', 'UPDATE', 'DELETE')),
    activo BOOLEAN DEFAULT TRUE,
    UNIQUE (id_columna, tipo_operacion)
);

-- 6. Tabla Centralizada de Bitácora
-- Centraliza el registro y relaciona la configuración, usuario responsable y estación (IP).
CREATE TABLE bitacora_auditoria (
    id_bitacora BIGSERIAL PRIMARY KEY,
    id_evento INT NOT NULL REFERENCES eventos_auditoria(id_evento),
    id_usuario INT NOT NULL REFERENCES usuarios_auditados(id_usuario),
    id_estacion INT NOT NULL REFERENCES estaciones_trabajo(id_estacion),
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_antiguo TEXT, 
    valor_nuevo TEXT
);

-- Revocar permisos de escritura directa en la bitácora para cumplir con la restricción de seguridad
REVOKE INSERT, UPDATE, DELETE ON bitacora_auditoria FROM PUBLIC;
