
-- Creacion de la Base de Datos

CREATE DATABASE FastFoodDB 

ON
(	NAME = 'FastFoodDB_Data',
	FILENAME = 'C:\SQL_DB\FastFoodDB_Data.mdf',
	SIZE = 50MB,
	MAXSIZE = 1GB,
	FILEGROWTH = 5MB )
LOG ON 
(	NAME = 'Carrera_BD_Log',
	FILENAME = 'C:\SQL_DB\FastFoodDB_Log.ldf',
	SIZE = 25MB,
	MAXSIZE = 256MB,
	FILEGROWTH = 5MB 
);
--Usar Base de Datos

USE FastFoodDB;

--Comprobamos creacion de Base de Datos

SELECT name, database_id, create_date
FROM sys.databases
WHERE name = 'FastFoodDB';

--Creacion de Tablas por Categorias (Respondiendo a las consignas del PI)

--CATEGORIAS
	CREATE TABLE  Categorias (
	CategoriaID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (100) NOT NULL
);
	SELECT * FROM Categorias

--PRODUCTOS
	CREATE TABLE Productos (
	ProductoID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (100) NOT NULL,
	CategoriaID INT,
	Precio DECIMAL(10,2)NOT NULL
	FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);
	SELECT * FROM Productos

--SUCURSALES 
	CREATE TABLE Sucursales (
	SucursalID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR (260) NOT NULL,
	Direccion VARCHAR (260)
);
	SELECT * FROM Sucursales

--EMPLEADOS
	CREATE TABLE Empleados (
	EmpleadosID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(260) NOT NULL,
	Posicion VARCHAR(260),
	Departamento VARCHAR(260),
	SucursalID INT,
	Rol VARCHAR(50),
	FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID)
); 
	SELECT * FROM Empleados 

--Clientes 
	CREATE TABLE Clientes (
	ClienteID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(150) NOT NULL,
	Direccion VARCHAR(150) NOT NULL
);
	SELECT * FROM Clientes

--Origen Orden
	CREATE TABLE OrigenesOrden (
	OrigenID INT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR(260) NOT NULL
);
	SELECT * FROM OrigenesOrden

--Tipos Pago
	CREATE TABLE TiposPago (
	TipoPagoID INT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR(250) NOT NULL
);
	SELECT * FROM TiposPago

--Mensajeros
	CREATE TABLE Mensajeros (
	MensajeroID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(100) NOT NULL,
	EsExterno BIT NOT NULL
);
	SELECT * FROM Mensajeros

--Ordenes
	CREATE TABLE Ordenes (
	OrdenID INT PRIMARY KEY IDENTITY,
	ClienteID INT,
	EmpleadosID INT,
	SucursalID INT,
	MensajeroID INT, --Interno o Externo
	TipoPagoID INT,
	OrigenID INT, --Modo en que se ejecuto la venta
	HorarioVenta VARCHAR(50), --Turno en el que se ejecuto la venta 
	TotalCompra DECIMAL(10,2) NOT NULL,
	KilometrosRecorrer DECIMAL(10,2),
	FechaDespacho DATETIME NOT NULL, --Solo en domicilios (Salida de sucursal)
	FechaEntrega DATETIME NOT NULL, --Solo en domicilios (Entrega a cliente)
	FechaOrdenTomada DATETIME NOT NULL, --Entrada de Orden
	FechaOrdenLista DATETIME NOT NULL, --Salida de Orden
		FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
		FOREIGN KEY (EmpleadosID) REFERENCES Empleados(EmpleadosID),
		FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID),
		FOREIGN KEY (MensajeroID) REFERENCES Mensajeros(MensajeroID),
		FOREIGN KEY (TipoPagoID) REFERENCES TiposPago(TipoPagoID),
		FOREIGN KEY (OrigenID) REFERENCES OrigenesOrden(OrigenID)
);
	SELECT * FROM Ordenes

--DetallesOrdenes
	CREATE TABLE DetallesOrdenes (
	OrdenID INT,
	ProductoID INT,
	Cantidad INT,
	Precio DECIMAL(10,2),
	PRIMARY KEY (OrdenID,ProductoID),
	FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID),
	FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
	SELECT * FROM DetallesOrdenes
	--DA_Freitez_Gerardo_Avance1PI
------------------------------------------------------
USE FastFoodDB;
--En esta fase del PI insertaremos datos y ejecutaremos consultas

--Insertar datos en Categorias
	INSERT INTO Categorias (Nombre) VALUES
('Comida Rápida'), ('Postres'), ('Bebidas'), ('Ensaladas'), ('Desayunos'),
('Cafetería'), ('Helados'), ('Comida Vegana'), ('Carnes'), ('Pizzas');

	SELECT * FROM Categorias

--Insertar datos en Productos
	INSERT INTO Productos (Nombre, CategoriaID, Precio) VALUES
('Hamburguesa Deluxe', 1, 9.99), ('Cheeseburger', 1, 7.99), ('Pizza Margarita', 10, 11.99), ('Pizza Pepperoni', 10, 12.99), ('Helado de Chocolate', 7, 2.99),
('Helado de Vainilla', 7, 2.99), ('Ensalada César', 4, 5.99), ('Ensalada Griega', 4, 6.99), ('Pastel de Zanahoria', 2, 3.99), ('Brownie', 2, 2.99);

	SELECT * FROM Productos

--Insertar datos en Sucursales
	INSERT INTO Sucursales (Nombre, Direccion) VALUES
('Sucursal Central', '1234 Main St'), ('Sucursal Norte', '5678 North St'), ('Sucursal Este', '9101 East St'), ('Sucursal Oeste', '1121 West St'), ('Sucursal Sur', '3141 South St'),
('Sucursal Playa', '1516 Beach St'), ('Sucursal Montaña', '1718 Mountain St'), ('Sucursal Valle', '1920 Valley St'), ('Sucursal Lago', '2122 Lake St'), ('Sucursal Bosque', '2324 Forest St');

	SELECT * FROM Sucursales

--Insertar datos en Empleados
	INSERT INTO Empleados (Nombre, Posicion, Departamento, SucursalID, Rol) VALUES
('John Doe', 'Gerente', 'Administración', 1, 'Vendedor'), ('Jane Smith', 'Subgerente', 'Ventas', 1, 'Vendedor'), ('Bill Jones', 'Cajero', 'Ventas', 1, 'Vendedor'), ('Alice Johnson', 'Cocinero', 'Cocina', 1, 'Vendedor'), ('Tom Brown', 'Barista', 'Cafetería', 1, 'Vendedor'),
('Emma Davis', 'Repartidor', 'Logística', 1, 'Mensajero'), ('Lucas Miller', 'Atención al Cliente', 'Servicio', 1, 'Vendedor'), ('Olivia García', 'Encargado de Turno', 'Administración', 1, 'Vendedor'), ('Ethan Martinez', 'Mesero', 'Restaurante', 1, 'Vendedor'), ('Sophia Rodriguez', 'Auxiliar de Limpieza', 'Mantenimiento', 1, 'Vendedor');

	SELECT * FROM Empleados

--Insertar datos en Clientes
	INSERT INTO Clientes (Nombre, Direccion) VALUES
('Cliente Uno', '1000 A Street'), ('Cliente Dos', '1001 B Street'), ('Cliente Tres', '1002 C Street'), ('Cliente Cuatro', '1003 D Street'), ('Cliente Cinco', '1004 E Street'),
('Cliente Seis', '1005 F Street'), ('Cliente Siete', '1006 G Street'), ('Cliente Ocho', '1007 H Street'), ('Cliente Nueve', '1008 I Street'), ('Cliente Diez', '1009 J Street');

	SELECT * FROM Clientes
	
--Insertar datos en OrigenesOrden
	INSERT INTO OrigenesOrden (Descripcion) VALUES
('En línea'), ('Presencial'), ('Teléfono'), ('Drive Thru'), ('App Móvil'),
('Redes Sociales'), ('Correo Electrónico'), ('Publicidad'), ('Recomendación'), ('Evento');

	SELECT * FROM OrigenesOrden

--Insertar datos en TiposPago
	INSERT INTO TiposPago (Descripcion) VALUES
('Efectivo'), ('Tarjeta de Crédito'), ('Tarjeta de Débito'), ('PayPal'), ('Transferencia Bancaria'),
('Criptomonedas'), ('Cheque'), ('Vale de Comida'), ('Cupón de Descuento'), ('Pago Móvil');

	SELECT * FROM TiposPago

--Insertar datos en Mensajeros
	INSERT INTO Mensajeros (Nombre, EsExterno) VALUES
('Mensajero Uno', 0), ('Mensajero Dos', 1), ('Mensajero Tres', 0), ('Mensajero Cuatro', 1), ('Mensajero Cinco', 0),
('Mensajero Seis', 1), ('Mensajero Siete', 0), ('Mensajero Ocho', 1), ('Mensajero Nueve', 0), ('Mensajero Diez', 1);

	SELECT * FROM Mensajeros

--Insertar datos en Ordenes
	INSERT INTO Ordenes (ClienteID, EmpleadosID, SucursalID, MensajeroID, TipoPagoID, OrigenID, HorarioVenta, TotalCompra, KilometrosRecorrer, FechaDespacho, FechaEntrega, FechaOrdenTomada, FechaOrdenLista) VALUES
	(1, 1, 1, 1, 1, 1, 'Mañana', 50.00, 5.5, '2023-10-01 08:30:00', '2023-10-01 09:00:00', '2023-10-01 08:00:00', '2023-10-01 08:15:00'),
	(2, 2, 2, 2, 2, 2, 'Tarde', 75.00, 10.0, '2023-15-02 14:30:00', '2023-15-02 15:00:00', '2023-15-02 13:30:00', '2023-15-02 14:00:00'),
	(3, 3, 3, 3, 3, 3, 'Noche', 20.00, 2.0, '2023-20-03 19:30:00', '2023-20-03 20:00:00', '2023-20-03 19:00:00', '2023-20-03 19:15:00'),
	(4, 4, 4, 4, 4, 4, 'Mañana', 30.00, 0.5, '2023-25-04 09:30:00', '2023-25-04 10:00:00', '2023-25-04 09:00:00', '2023-25-04 09:15:00'),
	(5, 5, 5, 5, 5, 5, 'Tarde', 55.00, 8.0, '2023-30-05 15:30:00', '2023-30-05 16:00:00', '2023-30-05 15:00:00', '2023-30-05 15:15:00'),
	(6, 6, 6, 6, 6, 1, 'Noche', 45.00, 12.5, '2023-05-06 20:30:00', '2023-05-06 21:00:00', '2023-05-06 20:00:00', '2023-05-06 20:15:00'),
	(7, 7, 7, 7, 7, 2, 'Mañana', 65.00, 7.5, '2023-10-07 08:30:00', '2023-10-07 09:00:00', '2023-10-07 08:00:00', '2023-10-07 08:15:00'),
	(8, 8, 8, 8, 8, 3, 'Tarde', 85.00, 9.5, '2023-15-08 14:30:00', '2023-15-08 15:00:00', '2023-15-08 14:00:00', '2023-15-08 14:15:00'),
	(9, 9, 9, 9, 9, 4, 'Noche', 95.00, 3.0, '2023-20-09 19:30:00', '2023-20-09 20:00:00', '2023-20-09 19:00:00', '2023-20-09 19:15:00'),
	(10, 10, 10, 10, 10, 5, 'Mañana', 100.00, 15.0, '2023-25-10 09:30:00', '2023-25-10 10:00:00', '2023-25-10 09:00:00', '2023-25-10 09:15:00');
	
	/*En la carga de insertar los datos para Ordenes tuve un rechazo en la carga por el formato de la fecha 
	por ello que tuve modificar cada fecha en el formato que si me tomaba el cual fue YYYY-DD-MM */

	SELECT * FROM Ordenes


-- Insertar datos en DetalleOrdenes
INSERT INTO DetallesOrdenes (OrdenID, ProductoID, Cantidad, Precio) VALUES
(1, 1, 3, 23.44),
(1, 2, 5, 45.14),
(1, 3, 4, 46.37),
(1, 4, 4, 42.34),
(1, 5, 1, 18.25),
(1, 6, 4, 20.08),
(1, 7, 2, 13.31),
(1, 8, 2, 20.96),
(1, 9, 4, 30.13),
(1, 10, 3, 38.34);

	SELECT * FROM DetallesOrdenes
-------------------------------------------------------------------
	--ACTUALIZACIONES (USANDO UPDATE - DELETE)

	--SE SUMA 1 EN EL PRECIO DE LOS PRODUCTOS DE CATEGORIAID 1
	UPDATE Productos 
	SET Precio = Precio + 1 
	WHERE CategoriaID = 1;

	SELECT * FROM Productos

	--SE MODIFICA LA POSICION DEL EMPLEADO A CHEF DE QUIENES ESTEN EN EL DEP COCINA
	UPDATE Empleados 
	SET Posicion = 'Chef' 
	WHERE Departamento = 'Cocina';

	SELECT * FROM Empleados

	--CAMBIOS DIRECCION DE UNA SURCURSAL 
	UPDATE Sucursales 
	SET Direccion = '1234 New Address St' 
	WHERE SucursalID = 1;

	SELECT * FROM Sucursales

	--ELIMINAMOS UNA ORDEN
	DELETE FROM DetallesOrdenes 
	WHERE OrdenID = 10;

	DELETE FROM Ordenes 
	WHERE OrdenID = 10;

	SELECT * FROM Ordenes

	--ELIMINAMOS PRODUCTOS
		
	DELETE FROM Productos 
	WHERE CategoriaID = 2;

	SELECT * FROM Productos
	
	ALTER TABLE DetallesOrdenes
	NOCHECK CONSTRAINT FK__DetallesO__Produ__6383C8BA;

	ALTER TABLE DetallesOrdenes
	CHECK CONSTRAINT FK__DetallesO__Produ__6383C8BA;
    --SE DESACTIVO UNA FK PARA PODER CUMPLIR CON EL DELETE EXITOSAMENTE

	--ELIMINAMOS EMPLEADOS DE UNA SUCURSAL (SOLO HAY UNA SUCURSAL)
		
	DELETE FROM Empleados 
	WHERE SucursalID = 10;
	
		SELECT * FROM Empleados+

	--CONSULTAS EXTRAS

--Cuantos productos diferentes hay en la orden 1
	SELECT COUNT (DISTINCT ProductoID) AS CONTEO
	FROM DetallesOrdenes
	WHERE OrdenID = 1
	GROUP BY OrdenID;

--CONSULTAS POR CONSIGNAS

--CANTIDAD TOTAL DE REGISTROS UNICOS EN LA TABLA DE ORDENES 
	SELECT COUNT (OrdenID) AS RegistrosUnicos
	FROM Ordenes;

--CUANTOS EMPLEADOS EXISTEN POR CADA DEPARTAMENTO
	SELECT Departamento, 
	COUNT (EmpleadosID) Cantidad 
	FROM Empleados
	GROUP BY Departamento
	ORDER BY Cantidad DESC;

--CUANTOS PRODUCTOS HAY POR CATEGORIA 
	SELECT CategoriaID,
	COUNT (ProductoID) AS Cantidad
	FROM Productos
	GROUP BY CategoriaID;

--CUANTOS CLIENTES SE HAN IMPORTADO A LA TABLA DE CLIENTES
	SELECT 
	COUNT (*) Conteo
	FROM Clientes;

/* CUALES SON LAS SUCURSALES CON UN PROMEDIO DE VENTAS POR ORDEN SUPERIOR
A UN VALOR ESPECIFICO (40), ORDENADAS POR EL PROMEDIO DE KILOMETROS RECORRIDOS
PARA LAS ENTREGAS DE MAYOR A MENOS*/

	SELECT MIN (TotalCompra) MinimaCompra, MAX (TotalCompra) MaximaCompra
	FROM Ordenes;

	SELECT SucursalID,
	CAST(AVG (TotalCompra) AS DECIMAL (10,2)) PromedioVenta, 
	FORMAT (AVG (KilometrosRecorrer), ',00') PromedioKm
	FROM Ordenes
	GROUP BY SucursalID
	HAVING AVG (TotalCompra) > 30
	ORDER BY AVG (KilometrosRecorrer) DESC;
	
	--DA_Freitez_Gerardo_Avance2PI
-------------------------------------------------------------------

USE FastFoodDB;

--Total de Ventas (TotalCompra) a nivel global

	SELECT SUM(TotalCompra) AS VentasNivelGlobal
	FROM Ordenes;

--Precio Promedio de los productos dentro de cada categoría

	SELECT CategoriaID, 
	CAST(AVG (Precio) AS DECIMAL(10,2)) PrecioProm
	FROM Productos
	GROUP BY CategoriaID
	ORDER BY PrecioProm DESC;

--Valor de la orden mínima y máxima por cada sucursal

	SELECT SucursalID,
	MIN(TotalCompra) Minimo,
	MAX(TotalCompra) Maximo
	FROM Ordenes
	GROUP BY SucursalID
	ORDER BY Maximo DESC;

--Mayor número de kilómetros recorridos para una entrega

	SELECT MAX(KilometrosRecorrer) AS Maximo
	FROM Ordenes;

--Cantidad promedio de productos por orden

	SELECT AVG(Cantidad) AS PromProductos
	FROM DetallesOrdenes;

--Total de ventas por cada tipo de pago

	SELECT TipoPagoID,
	SUM(TotalCompra) TotalVenta
	FROM Ordenes
	GROUP BY TipoPagoID
	ORDER BY TotalVenta DESC;

--Cuál sucursal tiene la venta promedio más alta?

	SELECT TOP 1 SucursalID,
	CAST(AVG(TotalCompra) AS DECIMAL (10,2)) PromVenta
	FROM Ordenes
	GROUP BY SucursalID
	ORDER BY PromVenta DESC;

--Sucursales que han generado ventas por orden por encima de $50, y cómo se comparan en términos del total de ventas?

	SELECT SucursalID,
	SUM(TotalCompra) TotalVentas
	FROM Ordenes
	GROUP BY SucursalID
	HAVING SUM(TotalCompra) > 50
	ORDER BY TotalVentas DESC;

	--Se genera otra consulta mas especifica

	SELECT SucursalID,
	SUM(TotalCompra) TotalVentas,
	COUNT(OrdenID) AS NumeroOrdenes,
		CONVERT (VARCHAR(20), (CAST (SUM(TotalCompra) / (SELECT SUM(TotalCompra) FROM Ordenes) 
		AS DECIMAL(10,2)) )*100) + '%' AS Proporcion
	FROM Ordenes
	GROUP BY SucursalID
	HAVING SUM(TotalCompra) > 50
	ORDER BY TotalVentas DESC;


--Cómo se comparan las ventas promedio antes y después del 1 de julio de 2023?

(	SELECT  'Antes de 1 Jul 2023' AS periodo,
	CAST(AVG(TotalCompra) AS DECIMAL(10,2)) TotalVenta
	FROM Ordenes
	WHERE FechaOrdenTomada < '2023-01-07')

UNION

(	SELECT  'Despues de 1 Jul 2023' AS periodo,
	CAST(AVG(TotalCompra) AS DECIMAL(10,2)) TotalVenta
	FROM Ordenes
	WHERE FechaOrdenTomada > '2023-01-07')

--Durante qué horario del día (mañana, tarde, noche) se registra la mayor cantidad de ventas, 
--cuál es el valor promedio de estas ventas, y cuál ha sido la venta máxima alcanzada?

	SELECT  HorarioVenta,
	COUNT(*) AS CantidadVenta,
	CAST(AVG(TotalCompra) AS DECIMAL (10,2)) PromVenta,
	MAX(TotalCompra) VentaMaxima
	FROM Ordenes
	GROUP BY HorarioVenta
	ORDER BY CantidadVenta DESC;

19/04/2024(actualizacion 24/04/24
	--DA_Freitez_Gerardo_Avance3PI
-----------------------------------------------------------------
USE FastFoodDB;
--¿Cómo puedo obtener una lista de todos los productos junto con sus categorías?

	SELECT P.Nombre Producto, C.Nombre Categoria 
	FROM Productos P
	inner join Categorias C ON (P.CategoriaID = C.CategoriaID)

--¿Cómo puedo saber a qué sucursal está asignado cada empleado?

	SELECT E.Nombre Empleado, S.Nombre Sucursal
	FROM Empleados E
	left join Sucursales S ON (E.SucursalID = S.SucursalID);

--¿Existen productos que no tienen una categoría asignada?

	SELECT P.Nombre, C.CategoriaID
	FROM Productos P
	left join Categorias C ON (P.CategoriaID = C.CategoriaID)
	WHERE C.CategoriaID is null;

--¿Cómo puedo obtener un detalle completo de las órdenes, incluyendo cliente, empleado que tomó la orden, y el mensajero que la entregó?

	SELECT O.OrdenID, C.Nombre Cliente, E.Nombre Empleado, M.Nombre Mensajero
	FROM Ordenes O
	left join Clientes C ON (O.ClienteID = C.ClienteID)
	left join Empleados E ON (O.EmpleadosID = E.EmpleadosID)
	left join Mensajeros M ON (O.MensajeroID = M.MensajeroID)

--¿Cuántos productos de cada tipo se han vendido en cada sucursal?

	SELECT	S.Nombre Sucursal, P.Nombre Producto, SUM(DO.Cantidad) ProductosVendidos
	FROM Ordenes O
	inner join DetallesOrdenes DO ON (O.OrdenID = DO.OrdenID)
	inner join Productos P ON (DO.ProductoID = P.ProductoID)
	inner join Sucursales S ON (O.SucursalID = S.SucursalID)
	GROUP BY S.Nombre, P.Nombre
	ORDER BY ProductosVendidos DESC;

-----------------------------------------------------------------------
