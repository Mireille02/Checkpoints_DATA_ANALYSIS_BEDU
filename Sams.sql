CREATE DATABASE proyecto;

USE proyecto;

CREATE TABLE estado (
idEdo int,
nombre varchar(50),
PRIMARY KEY (idEdo)
);

CREATE TABLE club (
idclub INT,
nombre VARCHAR(45),
direccion VARCHAR(150),
tel VARCHAR(60),
idEdo INT,
PRIMARY KEY (idClub),
FOREIGN KEY (idEdo) REFERENCES estado (idEdo)
);

CREATE TABLE gerente (
idGerente int,
nombre varchar(50),
idClub int,
PRIMARY KEY (idGerente),
FOREIGN KEY (idClub) REFERENCES club (idClub) 
);

CREATE TABLE proveedor (
idProveedor int,
nombre varchar(45),
tel varchar(25),
PRIMARY KEY (idProveedor)
);

CREATE TABLE producto (
idProducto int,
nombre varchar(45),
idProveedor int,
precioUnitario double,
PRIMARY KEY (idProducto),
FOREIGN KEY (idProveedor) REFERENCES proveedor (idProveedor)
);

CREATE TABLE proveedorsams (
idClub int,
idProveedor int,
PRIMARY KEY (idClub, idProveedor),
FOREIGN KEY (idClub) REFERENCES club (idClub),
FOREIGN KEY (idProveedor) REFERENCES proveedor (idProveedor)
);

CREATE TABLE servicio (
idServicio int,
nombre varchar(30),
PRIMARY KEY (idServicio)
);

CREATE TABLE servicioclub (
idServicio int,
idClub int,
KEY idServicio (idServicio),
KEY idClub (idClub),
FOREIGN KEY (idServicio) REFERENCES servicio (idServicio),
FOREIGN KEY (idClub) REFERENCES club (idClub)
);

CREATE TABLE socio (
idSocio int,
nombre varchar(50),
direccion varchar(100),
tel varchar(15),
PRIMARY KEY (idSocio)
);

CREATE TABLE socioclub (
idSocio int,
idClub int,
PRIMARY KEY (idSocio, idClub),
FOREIGN KEY (idSocio) REFERENCES socio (idSocio),
FOREIGN KEY (idClub) REFERENCES club (idClub)
);

SHOW TABLES;

DESCRIBE estado;

UPDATE estado SET nombre ="Queretaro" WHERE nombre LIKE "%Quer‚taro%" AND idEdo > 0;
UPDATE estado SET nombre ="Chihuahua" WHERE nombre LIKE "%chihuahua%" AND idEdo > 0;

SELECT *
FROM estado;

DESCRIBE club;

SELECT *
FROM club;

DESCRIBE gerente;

SELECT *
FROM gerente;

DESCRIBE proveedor;

SELECT *
FROM proveedor;

DESCRIBE producto;

SELECT *
FROM producto;

DESCRIBE proveedorsams;

SELECT *
FROM proveedorsams;

DESCRIBE servicio;

SELECT *
FROM servicio;

UPDATE servicio SET nombre ="Joyeria" WHERE nombre LIKE "%Joyer¡a%" AND idServicio > 0;
UPDATE servicio SET nombre ="Optica" WHERE nombre LIKE "%¢ptica%" AND idServicio > 0;

DESCRIBE servicioclub;

SELECT *
FROM servicioclub;

DESCRIBE socio;

SELECT *
FROM socio;

DESCRIBE socioclub;

SELECT *
FROM socioclub;

-- Fundamentos de SQL; agrupaciones y subconsultas
-- 1) Obtén el nombre de los estados.
SELECT nombre
FROM estado;

-- 2) Obtén los datos de los primeros 10 socios.
SELECT *
FROM gerente
LIMIT 10;

-- 3) Obtén el id y nombre de los primeros 100 socios.
SELECT idSocio, nombre
FROM socio
LIMIT 100;

-- 4) Ordena los nombres de los gerentes de manera descendente.
SELECT nombre
FROM gerente
ORDER BY nombre DESC;

-- 5) Ordena los nombres de los gerentes de manera ascendente.
SELECT nombre
FROM gerente
ORDER BY nombre ASC;

-- 6) Productos que tienen su precio unitario sea mayor de $50.
SELECT *
FROM producto
WHERE precioUnitario > 50;

-- 7) Cuántos registros hay de los socios que viven en la Avenida Juárez?
SELECT direccion, count(*)
FROM socio
GROUP BY direccion;

-- 8) Cuál es el promedio del precio unitario de los productos?
SELECT avg(precioUnitario)
FROM producto;

-- 9) Cuál es el máximo y el mínimo del precio unitario?
SELECT min(precioUnitario), max(precioUnitario)
FROM producto;

-- 10) Nombre y id de los asociados que se apellidan Ramírez.
select nombre, idGerente from gerente
where (nombre like "Rami%")
order by nombre;

-- 11) Obtener los nombres de los socios que obtengan EZ.
SELECT idSocio, nombre
FROM socio
WHERE nombre LIKE '%EZ%';

-- 12) Nombre, dirección y teléfono de todos los clubes que empiecen con C.
SELECT nombre, direccion, tel
FROM club
WHERE nombre LIKE 'C%';

-- 13) Obtener dirección y teléfono de los clubes que se encuentran en Acapulco.
SELECT direccion, tel
FROM club
WHERE nombre LIKE '%Acapulco%';

-- 14) El estado con mayor número de clubs.
SELECT idEdo, nombre, min(estado_clubs), max(estado_clubs)
FROM
    (SELECT idEdo, nombre, count(*) estado_clubs
     FROM club
     GROUP BY idEdo) AS clubs
GROUP BY idEdo;

-- Joins
-- 15) Nombre del socio y el nombre del club.
SELECT c.nombre, o.nombre
FROM socioclub AS s
INNER JOIN club AS c
ON s.idClub = c.idClub
INNER JOIN socio AS o
ON s.idSocio = o.idSocio
ORDER BY c.nombre, o.nombre;

-- 16) Relación entre club y Servicio.
SELECT c.nombre, e.nombre
FROM servicioclub AS s
INNER JOIN club AS c
ON s.idClub = c.idClub
INNER JOIN servicio AS e
ON s.idServicio = e.idServicio
ORDER BY c.nombre, e.nombre;

-- 17) Nombre del gerente y el nombre del club.
SELECT g.nombre, c.nombre
FROM gerente AS g
RIGHT JOIN club AS c
ON g.idClub = c.idClub;

-- 18) El nombre del producto y sus proveedores.
SELECT p.nombre, pr.nombre
FROM proveedor AS p
LEFT JOIN producto AS pr
ON pr.idProveedor = p.idProveedor;
 
-- Vistas
-- 19)
CREATE VIEW club_socio_534 AS
(SELECT c.nombre AS nombreclub, o.nombre 
FROM socioclub AS s
INNER JOIN club AS c
ON s.idClub = c.idClub
INNER JOIN socio AS o
ON s.idSocio = o.idSocio
ORDER BY c.nombre, o.nombre);

SELECT *
FROM club_socio_534;

-- 20)
CREATE VIEW club_servicio_534 AS
(SELECT c.nombre, e.nombre AS nombreservicio
FROM servicioclub AS s
INNER JOIN club AS c
ON s.idClub = c.idClub
INNER JOIN servicio AS e
ON s.idServicio = e.idServicio
ORDER BY c.nombre, e.nombre);

SELECT *
FROM club_servicio_534;

-- 21)
CREATE VIEW club_gerente_534 AS
(SELECT g.nombre AS nombregerente, c.nombre
FROM gerente AS g
RIGHT JOIN club AS c
ON g.idClub = c.idClub);

SELECT *
FROM club_gerente_534;

-- 22)
CREATE VIEW proveedor_producto_534 AS
(SELECT p.nombre, pr.nombre AS nombreproveedor
FROM proveedor AS p
LEFT JOIN producto AS pr
ON pr.idProveedor = p.idProveedor);

SELECT *
FROM proveedor_producto_534;













