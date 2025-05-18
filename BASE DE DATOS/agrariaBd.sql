-- Crear base de datos
CREATE DATABASE IF NOT EXISTS agrariaBd;
USE agrariaBd;

-- Tabla: roles
CREATE TABLE roles (
    rol_id TINYINT(2) PRIMARY KEY,
    rol_desc VARCHAR(45)
);

-- Tabla: usuarios
CREATE TABLE usuarios (
    usu_id INT UNSIGNED PRIMARY KEY,
    usu_usuario VARCHAR(45),
    usu_clave VARCHAR(255),
    usu_estado VARCHAR(45),
    usu_nombre VARCHAR(45),
    usu_apellido VARCHAR(45),
    usu_dni VARCHAR(45),
    usu_correo VARCHAR(254)NOT NULL CHECK (usu_correo LIKE '%@%.%'),
    usu_direccion VARCHAR(45),
    usu_telefono VARCHAR(45),
    rol_id TINYINT(2),
    FOREIGN KEY (rol_id) REFERENCES roles(rol_id)
);

-- Tabla: categorias
CREATE TABLE categorias (
    cat_id TINYINT(2) UNSIGNED PRIMARY KEY,
    cat_desc VARCHAR(45),
    cat_estado VARCHAR(45)
);

-- Tabla: areas
CREATE TABLE areas (
    area_id TINYINT(4) UNSIGNED PRIMARY KEY,
    area_desc VARCHAR(40),
    area_estado VARCHAR(45)
);

-- Tabla: subareas
CREATE TABLE subareas (
    subarea_id TINYINT(4) UNSIGNED PRIMARY KEY,
    subarea_desc VARCHAR(45),
    subarea_estado VARCHAR(45),
    area_id TINYINT(4) UNSIGNED,
    FOREIGN KEY (area_id) REFERENCES areas(area_id)
);


-- Tabla: productos
CREATE TABLE productos (
    prod_id INT(11) UNSIGNED PRIMARY KEY,
    prod_nombre VARCHAR(40),
    prod_desc VARCHAR(45),
    prod_foto VARCHAR(100),
    prod_estado VARCHAR(45),
    prod_stock_min INT(11),
    prod_stock_max INT(11),
    prod_stock_actual INT(11),
    cat_id TINYINT(2) UNSIGNED,
    subarea_id TINYINT(4) UNSIGNED,
    FOREIGN KEY (cat_id) REFERENCES categorias(cat_id),
    FOREIGN KEY (subarea_id) REFERENCES subareas(subarea_id)
);

-- Tabla: lotes
CREATE TABLE lotes (
    lote_id INT UNSIGNED PRIMARY KEY,
    lote_nombre VARCHAR(45),
    lote_fec_produccion DATE,
    lote_fec_vencimiento DATE,
    lote_estado VARCHAR(45),
    lote_fec_fin DATE,
    lote_stock_inicial INT,
    lote_stock_actual INT,
	prod_id INT(11) UNSIGNED,
	FOREIGN KEY (prod_id) REFERENCES productos(prod_id)
);

-- Tabla: movimientos
CREATE TABLE movimientos (
    mov_id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mov_tipo ENUM('ingreso', 'salida', 'ajuste', 'venta', 'donacion') NOT NULL,
    prod_id INT(11) UNSIGNED,
    mov_cantidad DECIMAL(10,3) NOT NULL,
    mov_fecha DATE,
    mov_observacion VARCHAR(255),
    usu_id INT  UNSIGNED ,
    FOREIGN KEY (prod_id) REFERENCES productos(prod_id),
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id)
);

-- Tabla: clientes
CREATE TABLE clientes (
    cli_id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cli_nombre VARCHAR(49),
    cli_apellido VARCHAR(40),
    cli_tipo VARCHAR(20),
    cli_dni VARCHAR(8) NOT NULL UNIQUE CHECK (cli_dni REGEXP '^[0-9]{8}$'),
    cli_cuit_cuil VARCHAR(20) NOT NULL UNIQUE CHECK (cli_cuit_cuil REGEXP '^[0-9]{11}$'),
    cli_estado VARCHAR(45),
    cli_telefono VARCHAR(45),
    cli_direccion VARCHAR(45),
    cli_correo VARCHAR(254)NOT NULL CHECK (cli_correo LIKE '%@%.%')
);

-- Tabla: ventas
CREATE TABLE ventas (
    venta_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cli_id INT UNSIGNED,
    venta_fecha DATE,
	venta_punto INT ZEROFILL,
    venta_total DECIMAL(10,2) ,
    forma_pago VARCHAR(45),
    venta_Nremito VARCHAR(13),
	venta_estado ENUM('pendiente', 'completada', 'anulada') DEFAULT 'pendiente',
    venta_observacion VARCHAR(45),
	venta_ptovta VARCHAR(13),
    FOREIGN KEY (cli_id) REFERENCES clientes(cli_id)
);

-- Tabla: detalle_ventas
CREATE TABLE detalle_ventas (
    det_id INT(11) PRIMARY KEY,
    venta_id INT UNSIGNED,
    prod_id INT(11) UNSIGNED,
    det_cantidad INT NOT NULL CHECK ( det_cantidad > 0),
    det_peso_kg DECIMAL(6,3),
    det_precio DECIMAL(8,2) NOT NULL,
    det_subtotal DECIMAL(10,2),
	det_total DECIMAL(10,2),
    det_observacion VARCHAR(45),
	det_iva VARCHAR(45),
    FOREIGN KEY (venta_id) REFERENCES ventas(venta_id),
    FOREIGN KEY (prod_id) REFERENCES productos(prod_id)
);
