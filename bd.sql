CREATE TABLE Marcas (
	    id_marca SERIAL PRIMARY KEY,
	    nombre VARCHAR(255) NOT NULL
	);
	
	-- Tabla Relojes
	CREATE TABLE Relojes (
	    id_reloj SERIAL PRIMARY KEY,
	    id_marca INT REFERENCES Marcas(id_marca) ON DELETE CASCADE,
	    modelo VARCHAR(255) NOT NULL,
	    precio DECIMAL(10, 2) NOT NULL
	);
	
	-- Tabla Proveedores
	CREATE TABLE Proveedores (
	    id_proveedor SERIAL PRIMARY KEY,
	    nombre VARCHAR(255) NOT NULL,
	    direccion VARCHAR(255),
	    pais VARCHAR(100),
	    telefono VARCHAR(15)
	);
	
	-- Tabla Clientes
	CREATE TABLE Clientes (
	    id_cliente SERIAL PRIMARY KEY,
	    nombre VARCHAR(255) NOT NULL,
	    apellido VARCHAR(255) NOT NULL,
	    cedula VARCHAR(20) UNIQUE NOT NULL,
	    direccion VARCHAR(255),
	    telefono VARCHAR(15)
	);
	
	-- Tabla Compras
	CREATE TABLE Compras (
	    id_compra SERIAL PRIMARY KEY,
	    id_reloj INT REFERENCES Relojes(id_reloj) ON DELETE CASCADE,
	    id_cliente INT REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
	    fecha_compra DATE NOT NULL,
	    cantidad INT NOT NULL,
	    total DECIMAL(10, 2) NOT NULL
	);
	
	-- Tabla login_empleados
	CREATE TABLE login_empleados (
	    id_login SERIAL PRIMARY KEY,
	    username VARCHAR(255) UNIQUE NOT NULL,
	    password_hash VARCHAR(255) NOT NULL
	);
	
	-- Tabla empleados
	CREATE TABLE empleados (
	    id_empleado SERIAL PRIMARY KEY,
	    nombre VARCHAR(255) NOT NULL,
	    apellido VARCHAR(255) NOT NULL,
	    cedula VARCHAR(20) UNIQUE NOT NULL,
	    telefono VARCHAR(15),
	    id_login INT REFERENCES login_empleados(id_login)
	);

	CREATE OR REPLACE FUNCTION crear_login_empleado(
	    p_username VARCHAR, 
	    p_password_hash VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    INSERT INTO login_empleados (username, password_hash)
	    VALUES (p_username, p_password_hash);
	END;
	$$ LANGUAGE plpgsql;

	CREATE OR REPLACE FUNCTION obtener_login_empleado(
	    p_username VARCHAR
	) RETURNS TABLE (
	    id_login INTEGER, 
	    username VARCHAR, 
	    password_hash VARCHAR
	) AS $$
	BEGIN
	    RETURN QUERY SELECT id_login, username, password_hash 
	    FROM login_empleados 
	    WHERE username = p_username;
	END;
	$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION actualizar_login_empleado(
	    p_id_login INTEGER, 
	    p_username VARCHAR, 
	    p_password_hash VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    UPDATE login_empleados 
	    SET username = p_username, 
	        password_hash = p_password_hash 
	    WHERE id_login = p_id_login;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Eliminar login_empleado
	CREATE OR REPLACE FUNCTION eliminar_login_empleado(
	    p_id_login INTEGER
	) RETURNS VOID AS $$
	BEGIN
	    DELETE FROM login_empleados WHERE id_login = p_id_login;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Procedimientos CRUD para empleados
	
	-- Crear empleado
	CREATE OR REPLACE FUNCTION crear_empleado(
	    p_id_login INTEGER, 
	    p_nombre VARCHAR, 
	    p_apellido VARCHAR, 
	    p_cedula VARCHAR, 
	    p_telefono VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    INSERT INTO empleados (id_login, nombre, apellido, cedula, telefono)
	    VALUES (p_id_login, p_nombre, p_apellido, p_cedula, p_telefono);
	END;
	$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION obtener_empleado(
	    p_id_empleado INTEGER
	) RETURNS TABLE (
	    id_empleado INTEGER, 
	    nombre VARCHAR, 
	    apellido VARCHAR, 
	    cedula VARCHAR, 
	    telefono VARCHAR, 
	    id_login INTEGER
	) AS $$
	BEGIN
	    RETURN QUERY SELECT id_empleado, nombre, apellido, cedula, telefono, id_login 
	    FROM empleados 
	    WHERE id_empleado = p_id_empleado;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Actualizar empleado
	CREATE OR REPLACE FUNCTION actualizar_empleado(
	    p_id_empleado INTEGER, 
	    p_nombre VARCHAR, 
	    p_apellido VARCHAR, 
	    p_cedula VARCHAR, 
	    p_telefono VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    UPDATE empleados 
	    SET nombre = p_nombre, 
	        apellido = p_apellido, 
	        cedula = p_cedula, 
	        telefono = p_telefono 
	    WHERE id_empleado = p_id_empleado;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Eliminar empleado
	CREATE OR REPLACE FUNCTION eliminar_empleado(
	    p_id_empleado INTEGER
	) RETURNS VOID AS $$
	BEGIN
	    DELETE FROM empleados WHERE id_empleado = p_id_empleado;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Procedimientos CRUD para clientes
	
	-- Crear cliente
	CREATE OR REPLACE FUNCTION crear_cliente(
	    p_nombre VARCHAR, 
	    p_apellido VARCHAR, 
	    p_cedula VARCHAR, 
	    p_direccion VARCHAR, 
	    p_telefono VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    INSERT INTO clientes (nombre, apellido, cedula, direccion, telefono)
	    VALUES (p_nombre, p_apellido, p_cedula, p_direccion, p_telefono);
	END;
	$$ LANGUAGE plpgsql;




	CREATE OR REPLACE FUNCTION obtener_cliente(
	    p_id_cliente INTEGER
	) RETURNS TABLE (
	    id_cliente INTEGER, 
	    nombre VARCHAR, 
	    apellido VARCHAR, 
	    cedula VARCHAR, 
	    direccion VARCHAR, 
	    telefono VARCHAR
	) AS $$
	BEGIN
	    RETURN QUERY SELECT id_cliente, nombre, apellido, cedula, direccion, telefono 
	    FROM clientes 
	    WHERE id_cliente = p_id_cliente;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Actualizar cliente
	CREATE OR REPLACE FUNCTION actualizar_cliente(
	    p_id_cliente INTEGER, 
	    p_nombre VARCHAR, 
	    p_apellido VARCHAR, 
	    p_cedula VARCHAR, 
	    p_direccion VARCHAR, 
	    p_telefono VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    UPDATE clientes 
	    SET nombre = p_nombre, 
	        apellido = p_apellido, 
	        cedula = p_cedula, 
	        direccion = p_direccion, 
	        telefono = p_telefono 
	    WHERE id_cliente = p_id_cliente;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Eliminar cliente
	CREATE OR REPLACE FUNCTION eliminar_cliente(
	    p_id_cliente INTEGER
	) RETURNS VOID AS $$
	BEGIN
	    DELETE FROM clientes WHERE id_cliente = p_id_cliente;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Procedimientos CRUD para Relojes
	
	-- Crear Reloj
	CREATE OR REPLACE FUNCTION crear_reloj(
	    p_id_marca INTEGER, 
	    p_modelo VARCHAR, 
	    p_precio DECIMAL(10, 2)
	) RETURNS VOID AS $$
	BEGIN
	    INSERT INTO relojes (id_marca, modelo, precio)
	    VALUES (p_id_marca, p_modelo, p_precio);
	END;
	$$ LANGUAGE plpgsql;
	
	-- Obtener Reloj
	CREATE OR REPLACE FUNCTION obtener_reloj(
	    p_id_reloj INTEGER
	) RETURNS TABLE (
	    id_reloj INTEGER, 
	    id_marca INTEGER, 
	    modelo VARCHAR, 
	    precio DECIMAL(10, 2)
	) AS $$
	BEGIN
	    RETURN QUERY SELECT id_reloj, id_marca, modelo, precio 
	    FROM relojes 
	    WHERE id_reloj = p_id_reloj;
	END;
	$$ LANGUAGE plpgsql;










	CREATE OR REPLACE FUNCTION actualizar_reloj(
	    p_id_reloj INTEGER, 
	    p_id_marca INTEGER, 
	    p_modelo VARCHAR, 
	    p_precio DECIMAL(10, 2)
	) RETURNS VOID AS $$
	BEGIN
	    UPDATE relojes 
	    SET id_marca = p_id_marca, 
	        modelo = p_modelo, 
	        precio = p_precio 
	    WHERE id_reloj = p_id_reloj;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Eliminar Reloj
	CREATE OR REPLACE FUNCTION eliminar_reloj(
	    p_id_reloj INTEGER
	) RETURNS VOID AS $$
	BEGIN
	    DELETE FROM relojes WHERE id_reloj = p_id_reloj;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Procedimientos CRUD para Proveedores
	
	-- Crear Proveedor
	CREATE OR REPLACE FUNCTION crear_proveedor(
	    p_nombre VARCHAR, 
	    p_direccion VARCHAR, 
	    p_pais VARCHAR, 
	    p_telefono VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    INSERT INTO proveedores (nombre, direccion, pais, telefono)
	    VALUES (p_nombre, p_direccion, p_pais, p_telefono);
	END;
	$$ LANGUAGE plpgsql;
	
	-- Obtener Proveedor
	CREATE OR REPLACE FUNCTION obtener_proveedor(
	    p_id_proveedor INTEGER
	) RETURNS TABLE (
	    id_proveedor INTEGER, 
	    nombre VARCHAR, 
	    direccion VARCHAR, 
	    pais VARCHAR, 
	    telefono VARCHAR
	) AS $$
	BEGIN
	    RETURN QUERY SELECT id_proveedor, nombre, direccion, pais, telefono 
	    FROM proveedores 
	    WHERE id_proveedor = p_id_proveedor;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Actualizar Proveedor
	CREATE OR REPLACE FUNCTION actualizar_proveedor(
	    p_id_proveedor INTEGER, 
	    p_nombre VARCHAR, 
	    p_direccion VARCHAR, 
	    p_pais VARCHAR, 
	    p_telefono VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    UPDATE proveedores 
	    SET nombre = p_nombre, 
	        direccion = p_direccion, 
	        pais = p_pais, 
	        telefono = p_telefono 
	    WHERE id_proveedor = p_id_proveedor;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Eliminar Proveedor
	CREATE OR REPLACE FUNCTION eliminar_proveedor(
	    p_id_proveedor INTEGER
	) RETURNS VOID AS $$
	BEGIN
	    DELETE FROM proveedores WHERE id_proveedor = p_id_proveedor;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Procedimientos CRUD para Compras
	
	-- Crear Compra
	CREATE OR REPLACE FUNCTION crear_compra(
	    p_id_reloj INTEGER, 
	    p_id_cliente INTEGER, 
	    p_fecha_compra DATE, 
	    p_cantidad INTEGER, 
	    p_total DECIMAL(10, 2)
	) RETURNS VOID AS $$
	BEGIN
	    INSERT INTO compras (id_reloj, id_cliente, fecha_compra, cantidad, total)
	    VALUES (p_id_reloj, p_id_cliente, p_fecha_compra, p_cantidad, p_total);
	END;
	$$ LANGUAGE plpgsql;
	
	-- Obtener Compra
	CREATE OR REPLACE FUNCTION obtener_compra(
	    p_id_compra INTEGER
	) RETURNS TABLE (
	    id_compra INTEGER, 
	    id_reloj INTEGER, 
	    id_cliente INTEGER, 
	    fecha_compra DATE, 
	    cantidad INTEGER, 
	    total DECIMAL(10, 2)
	) AS $$
	BEGIN
	    RETURN QUERY SELECT id_compra, id_reloj, id_cliente, fecha_compra, cantidad, total 
	    FROM compras 
	    WHERE id_compra = p_id_compra;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Actualizar Compra
	CREATE OR REPLACE FUNCTION actualizar_compra(
	    p_id_compra INTEGER, 
	    p_id_reloj INTEGER, 
	    p_id_cliente INTEGER, 
	    p_fecha_compra DATE, 
	    p_cantidad INTEGER, 
	    p_total DECIMAL(10, 2)
	) RETURNS VOID AS $$
	BEGIN
	    UPDATE compras 
	    SET id_reloj = p_id_reloj, 
	        id_cliente = p_id_cliente, 
	        fecha_compra = p_fecha_compra, 
	        cantidad = p_cantidad, 
	        total = p_total 
	    WHERE id_compra = p_id_compra;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Eliminar Compra
	CREATE OR REPLACE FUNCTION eliminar_compra(
	    p_id_compra INTEGER
	) RETURNS VOID AS $$
	BEGIN
	    DELETE FROM compras WHERE id_compra = p_id_compra;
	END;
	$$ LANGUAGE plpgsql;







	--crear la función que será utilizada por el trigger para modificar el campo id_login:
	CREATE OR REPLACE FUNCTION actualizar_id_login_empleado() RETURNS TRIGGER AS $$
	BEGIN
	    -- Actualizar el id_login del empleado insertado con el último id_login disponible
	    NEW.id_login := (SELECT id_login FROM login_empleados ORDER BY id_login DESC LIMIT 1);
	    
	    -- En caso de que no haya ningún login disponible, levantamos una excepción
	    IF NEW.id_login IS NULL THEN
	        RAISE EXCEPTION 'No hay registros en la tabla login_empleados';
	    END IF;
	
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	
	CREATE TRIGGER trigger_actualizar_id_login_empleado
	BEFORE INSERT ON empleados
	FOR EACH ROW
	EXECUTE FUNCTION actualizar_id_login_empleado();
















	CREATE OR REPLACE FUNCTION login_usuario(p_username VARCHAR, p_password VARCHAR)
	RETURNS BOOLEAN AS $$
	DECLARE
	    v_password_hash VARCHAR;
	BEGIN
	    SELECT password_hash INTO v_password_hash FROM login_empleados WHERE username = p_username;
	
	    IF v_password_hash IS NOT NULL AND crypt(p_password, v_password_hash) = v_password_hash THEN
	        RETURN TRUE;
	    ELSE
	        RETURN FALSE;
	    END IF;
	END;
	$$ LANGUAGE plpgsql;
	
	CREATE OR REPLACE FUNCTION registro_usuario(p_username VARCHAR, p_password_hash VARCHAR)
	RETURNS INTEGER AS $$
	DECLARE
	    v_id_login INTEGER;
	BEGIN
	    INSERT INTO login_empleados (username, password_hash) 
	    VALUES (p_username, p_password_hash) RETURNING id_login INTO v_id_login;
	
	    RETURN v_id_login;
	END;
	$$ LANGUAGE plpgsql;
	
	CREATE OR REPLACE PROCEDURE registrar_empleado(p_id_login INTEGER, p_nombre VARCHAR, p_apellido VARCHAR, p_cedula VARCHAR, p_telefono VARCHAR)
	LANGUAGE plpgsql
	AS $$
	BEGIN
	    INSERT INTO empleados (id_login, nombre, apellido, cedula, telefono)
	    VALUES (p_id_login, p_nombre, p_apellido, p_cedula, p_telefono);
	END;
	$$;
	
	-- Crear un nuevo empleado
	CREATE OR REPLACE FUNCTION crear_empleado(
	    p_id_login INTEGER, 
	    p_nombre VARCHAR, 
	    p_apellido VARCHAR, 
	    p_cedula VARCHAR, 
	    p_telefono VARCHAR
	) RETURNS VOID AS $$
	BEGIN
	    INSERT INTO empleados (id_login, nombre, apellido, cedula, telefono)
	    VALUES (p_id_login, p_nombre, p_apellido, p_cedula, p_telefono);
	END;
	$$ LANGUAGE plpgsql;




REATE OR REPLACE FUNCTION actualizar_id_login_empleado() RETURNS TRIGGER AS $$
		BEGIN
		    -- Actualizar el id_login del empleado insertado con el último id_login disponible
		    NEW.id_login := (SELECT id_login FROM login_empleados ORDER BY id_login DESC LIMIT 1);
		    
		    -- En caso de que no haya ningún login disponible, levantamos una excepción
		    IF NEW.id_login IS NULL THEN
		        RAISE EXCEPTION 'No hay registros en la tabla login_empleados';
		    END IF;
		
		    RETURN NEW;
		END;
		$$ LANGUAGE plpgsql;
		
		
		CREATE TRIGGER trigger_actualizar_id_login_empleado
		BEFORE INSERT ON empleados
		FOR EACH ROW
		EXECUTE FUNCTION actualizar_id_login_empleado();
	insert into empleados 
	
	INSERT INTO empleados (nombre, apellido, cedula, telefono)
	VALUES ('Santiago', 'Restrepo', '1234567890', '5551234');
	
	
	TRUNCATE TABLE login_empleados RESTART IDENTITY;
	TRUNCATE TABLE empleados RESTART IDENTITY;
	
	-- Insert initial row with ID 0
	INSERT INTO login_empleados (id_login, ...) VALUES (0, ...);
	INSERT INTO empleados (id_empleado, ...) VALUES (0, ...);
	
	-- Adjust sequences to start from 1 after the 0 row
	ALTER SEQUENCE login_empleados_id_login_seq RESTART WITH 1;
	ALTER SEQUENCE empleados_id_empleado_seq RESTART WITH 1;


	
	

	





