CREATE DATABASE	RegistroCompras
GO

USE RegistroCompras
GO


CREATE TABLE Proveedores (
	IdProveedor INT PRIMARY KEY,
	RUC VARCHAR (11)UNIQUE,
	Razon_Social NVARCHAR(100),
	Dias_Credito INT DEFAULT 0);


CREATE TABLE Productos (
	IdProducto INT PRIMARY KEY,
	Descripcion NVARCHAR (100),
	Stock INT);


CREATE TABLE ComprobanteDePago (
    IdComprobante INT IDENTITY(1,1)PRIMARY KEY,
    IdProveedor INT,
	TipoComprobante VARCHAR(50),
    FechaEmision DATE,
    FechaVencimiento DATE,
	Serie VARCHAR(4),
    Numero VARCHAR (8),
	Subtotal DECIMAL(10,2),
	Impuesto DECIMAL(10,2),
	MontoTotal as (Subtotal+Impuesto),
	Condicion NVARCHAR(30),
	Moneda VARCHAR(3),
    SaldoPendiente DECIMAL(10,2),
	FOREIGN KEY (IdProveedor) REFERENCES Proveedores (IdProveedor));


CREATE TABLE DetalleCompras (
	IdDetalleCom INT IDENTITY (1,1)PRIMARY KEY,
	IdComprobante INT,
	IdProducto INT,
	Cantidad INT,
	Precio_Unitario DECIMAL (10,2)
	FOREIGN KEY (IdComprobante) REFERENCES ComprobanteDePago (IdComprobante),
	FOREIGN KEY (IdProducto) REFERENCES Productos (IdProducto));


CREATE TABLE DetallePago (
    IdPago INT IDENTITY(1,1) PRIMARY KEY,
    IdComprobante INT,
	FechaPago DATE,
    MetodoPago VARCHAR(50),
    MontoTotal DECIMAL(10,2)
	FOREIGN KEY (IdComprobante) REFERENCES ComprobanteDePago (IdComprobante));


---INSERTAR DATOS TABLA PROOVEDORES
INSERT INTO Proveedores VALUES
(1, '20554879631', 'LLANTAS Y RECAUCHUTES DEL NORTE S.A.C.', 30),
(2, '20112345678', 'COMBUSTIBLES EL CAMIONERO S.A.', 0),
(3, '20445566771', 'CORPORACION PRIMAX DEL PERU', 0),
(4, '20887766554', 'REPUESTOS DIESEL EXPRESS E.I.R.L.', 15),
(5, '20443322110', 'SERVICIOS MECANICOS TRUJILLO S.A.C.', 45),
(6, '20601122334', 'TEXTILES SEGURIDAD INDUMENTARIA S.A.', 0),
(7, '20334455661', 'FRENOS Y EMBRAGUES PACIFICO S.A.', 15),
(8, '20778899112', 'BATERIAS Y ENERGIA AUTOMOTRIZ S.A.C.', 30),
(9, '20123456789', 'DISTRIBUIDORA DE LUBRICANTES TOTALES', 0),
(10, '20987654321', 'MANGUERAS Y CONEXIONES HIDRAULICAS', 7),
(11, '20451278931', 'RECTIFICACIONES DE MOTORES TRUJILLO', 60),
(12, '20663322114', 'PERNOS Y HERRAMIENTAS INDUSTRIALES', 0),
(13, '20881144225', 'SERVICIOS DE ALINEAMIENTO BALAREZO', 0),
(14, '20115599883', 'CRISTALES Y PARABRISAS DE LA COSTA', 15),
(15, '20337744119', 'CHASIS Y SUSPENSIONES TRUJILLO S.A.', 30),
(16, '20559911442', 'IMPORTACIONES REY DEL REPUESTO S.A.', 15),
(17, '20556622117', 'ELECTRICOS DIESEL SAC', 15),
(18, '20991188223', 'SOLUCIONES DE REFRIGERACION MOVIL', 45),
(19, '20448855221', 'EQUIPOS DE SEGURIDAD VIAL EIRL', 0),
(20, '20772266114', 'PINTURAS Y ACABADOS AUTOMOTRICES', 30),
(21, '20226699113', 'MAQUINARIAS Y REMOLQUES DEL NORTE', 60),
(22, '20661155992', 'OXIGENO Y SOLDADURAS UNIVERSAL', 15),
(23, '20100123456', 'ESTACION DE SERVICIO EL NORTE SAC', 15),  
(24, '20509876543', 'GRIFOS Y SERVICIOS SAN JOS� EIRL', 0),   
(25, '20405566778', 'COMERCIALIZADORA DE COMBUSTIBLES TRUJILLO', 30);

---INSERTAR DATOS TABLA PRODUCTOS
INSERT INTO Productos VALUES
(1,'Llanta Radial para Camion 295/80 R22.5', 24),
(2,'Aceite para Motor Diesel 15W-40 (Galon)', 40),
(3,'Filtro de Aire Primario Kenworth', 12),
(4,'Pastillas de Freno Delanteras (Kit)', 8),
(5,'Bateria Capstone 12V 150AH', 6),
(6,'Uniforme Overol de Trabajo Termico', 15),
(7,'Liquido de Frenos Heavy Duty (Litro)', 50),
(8,'Refrigerante de Motor de Larga Duracion', 30),
(9,'Filtro de Combustible Separador de Agua', 18),
(10,'Disco de Embrague para Camion Volvo', 3),
(11,'Abrazadera de Presion de 3 Pulgadas', 100),
(12,'Alternador Diesel de 24V', 4),
(13,'Kit de Pernos de Alta Resistencia (Caja)', 10),
(14,'Manguera Hidraulica de Alta Presion', 25),
(15,'Parabrisas Delantero Camion Scania', 2),
(16,'Amortiguador Delantero Reforzado', 14),
(17,'Perno de Rueda Delantera de Camion', 80),
(18,'Faro LED Posterior 24V', 20),
(19,'Extintor PQS de 9KG con Certificado', 8),
(20,'Faja de Alternador/Ventilador', 15),
(21,'Zapatas de Freno Posterior (Juego)', 6),
(22,'Bomba de Agua para Motor Diesel', 3),
(23, 'Combustible Diesel B5 S-50 (Galon)', 500);

---INSERTAR COMPROBANTES DE PAGO
INSERT INTO ComprobanteDePago (IdProveedor, TipoComprobante, FechaEmision, FechaVencimiento, Serie, Numero, Condicion, Subtotal, Impuesto, Moneda, SaldoPendiente) VALUES
(1, 'Factura', '2026-05-01', '2026-05-31', 'F001', '0001024', 'Credito', 1000.00, 180.00, 'USD', 1180.00), 
(2, 'Factura', '2026-05-02', '2026-05-02', 'E001', '0054125', 'Contado', 1500.00, 270.00, 'PEN', 0.00),   
(4, 'Factura', '2026-05-03', '2026-05-18', 'F002', '0000741', 'Credito', 1850.00, 333.00, 'PEN', 2183.00), 
(5, 'Factura', '2026-05-04', '2026-06-18', 'F004', '0008512', 'Credito', 2400.00, 432.00, 'PEN', 2832.00), 
(6, 'Factura', '2026-05-05', '2026-05-05', 'F015', '0002145', 'Contado', 650.00, 117.00, 'PEN', 0.00),    
(2, 'Factura', '2026-05-09', '2026-05-09', 'E001', '0054390', 'Contado', 1600.00, 288.00, 'PEN', 0.00),  
(3, 'Factura', '2026-05-10', '2026-05-10', 'F008', '0012451', 'Contado', 1250.00, 225.00, 'PEN', 0.00),   
(7, 'Factura', '2026-05-10', '2026-05-25', 'F001', '0000963', 'Credito', 1600.00, 288.00, 'PEN', 1888.00), 
(8, 'Factura', '2026-05-11', '2026-06-10', 'F003', '0001548', 'Credito', 600.00, 108.00, 'USD', 708.00),   
(9, 'Factura', '2026-05-12', '2026-05-12', 'F002', '0004587', 'Contado', 1200.00, 216.00, 'PEN', 0.00),   
(15, 'Factura', '2026-05-15', '2026-06-14', 'F002', '0005231', 'Credito', 1040.00, 187.20, 'USD', 1227.20),
(4, 'Factura', '2026-05-16', '2026-05-31', 'F002', '0000899', 'Credito', 780.00, 140.40, 'PEN', 920.40),   
(10, 'Factura', '2026-05-17', '2026-05-24', 'F001', '0003214', 'Credito', 500.00, 90.00, 'PEN', 590.00),   
(11, 'Factura', '2026-05-18', '2026-07-17', 'F005', '0000142', 'Credito', 1200.00, 216.00, 'USD', 1416.00),
(12, 'Factura', '2026-05-19', '2026-05-19', 'F002', '0010254', 'Contado', 350.00, 63.00, 'PEN', 0.00),    
(16, 'Factura', '2026-05-20', '2026-06-04', 'F001', '0006541', 'Credito', 1350.00, 243.00, 'PEN', 1593.00),
(13, 'Factura', '2026-05-22', '2026-05-22', 'F001', '0000852', 'Contado', 800.00, 144.00, 'PEN', 0.00),   
(2, 'Factura', '2026-05-23', '2026-05-23', 'E001', '0054810', 'Contado', 1450.00, 261.00, 'PEN', 0.00),   
(14, 'Factura', '2026-05-24', '2026-06-08', 'F004', '0001478', 'Credito', 300.00, 54.00, 'USD', 354.00),   
(17, 'Factura', '2026-05-25', '2026-06-09', 'F001', '0000369', 'Credito', 250.00, 45.00, 'USD', 295.00),   
(18, 'Factura', '2026-05-26', '2026-07-10', 'F003', '0002541', 'Credito', 1350.00, 243.00, 'PEN', 1593.00),
(19, 'Factura', '2026-05-27', '2026-05-27', 'F001', '0004128', 'Contado', 720.00, 129.60, 'PEN', 0.00),   
(20, 'Factura', '2026-05-28', '2026-06-27', 'F002', '0003698', 'Credito', 580.00, 104.40, 'PEN', 684.40),  
(21, 'Factura', '2026-05-29', '2026-07-28', 'F006', '0000215', 'Credito', 7000.00, 1260.00, 'PEN', 8260.00),
(22, 'Factura', '2026-05-30', '2026-06-14', 'F001', '0007412', 'Credito', 480.00, 86.40, 'PEN', 566.40),	
(1, 'Factura', '2026-05-31', '2026-06-30', 'F001', '0001150', 'Credito', 1020.00, 183.60, 'USD', 1203.60), 
(23, 'Factura', '2026-05-02', '2026-05-17', 'F001', '0005420', 'Credito', 4500.00, 810.00, 'PEN', 5310.00), 
(23, 'Factura', '2026-05-09', '2026-05-24', 'F001', '0005515', 'Credito', 5200.00, 936.00, 'PEN', 6136.00), 
(23, 'Factura', '2026-05-16', '2026-05-31', 'F001', '0005602', 'Credito', 4800.00, 864.00, 'PEN', 5664.00),
(24, 'Factura', '2026-05-05', '2026-05-05', 'F005', '0012450', 'Contado', 1200.00, 216.00, 'PEN', 0.00),   
(24, 'Factura', '2026-05-12', '2026-05-12', 'F005', '0012589', 'Contado', 1500.00, 270.00, 'PEN', 0.00),   
(25, 'Factura', '2026-05-01', '2026-05-31', 'F002', '0000890', 'Credito', 12000.00, 2160.00, 'PEN', 14160.00),
(25, 'Factura', '2026-05-15', '2026-06-14', 'F002', '0000945', 'Credito', 11500.00, 2070.00, 'PEN', 13570.00);

---INSERTAR DETALLE DE COMPRAS
INSERT INTO DetalleCompras (IdComprobante, IdProducto, Cantidad, Precio_Unitario) VALUES
(1, 1, 4, 250.00),    
(2, 2, 10, 120.00),   
(2, 8, 10, 30.00),    
(3, 3, 3, 250.00),    
(3, 4, 2, 550.00),    
(4, 16, 4, 350.00),   
(4, 21, 2, 500.00),   
(5, 6, 5, 130.00),    
(6, 2, 10, 115.00),   
(6, 8, 15, 30.00),    
(7, 2, 10, 125.00),   
(8, 2, 10, 160.00),   
(9, 4, 1, 600.00),    
(10, 5, 12, 100.00),  
(11, 2, 8, 130.00),   
(12, 2, 4, 120.00),   
(12, 9, 6, 50.00),    
(13, 1, 2, 250.00),   
(14, 3, 3, 400.00),   
(15, 14, 5, 70.00),   
(16, 22, 1, 550.00),  
(16, 10, 2, 400.00),  
(17, 13, 10, 80.00),  
(18, 3, 2, 225.00),   
(18, 2, 5, 200.00),   
(19, 16, 1, 300.00),  
(20, 2, 2, 125.00),   
(21, 8, 45, 30.00),   
(22, 15, 2, 360.00),  
(23, 12, 2, 290.00),  
(24, 18, 10, 700.00), 
(25, 18, 8, 60.00),   
(26, 1, 4, 255.00),   
(27, 23, 300, 15.00), 
(28, 23, 325, 16.00), 
(29, 23, 320, 15.00), 
(30, 23, 80, 15.00),  
(31, 23, 100, 15.00), 
(32, 23, 800, 15.00), 
(33, 23, 575, 20.00);

---INSERTAR DETALLE DE PAGOS
INSERT INTO DetallePago (IdComprobante, FechaPago, MetodoPago, MontoTotal) VALUES
(1, '2026-05-31', 'Transferencia', 1180.00), 
(3, '2026-05-18', 'Cheque', 2183.00), 
(8, '2026-05-25', 'Transferencia', 1888.00), 
(12, '2026-05-31', 'Transferencia', 920.40),      
(13, '2026-05-24', 'Transferencia', 590.00),     
(27, '2026-05-17', 'Transferencia', 5310.00),
(28, '2026-05-24', 'Transferencia', 6136.00),
(29, '2026-05-31', 'Transferencia', 5664.00),
(4, '2026-05-20', 'Cheque', 1000.00), 
(11, '2026-05-28', 'Transferencia', 500.00),  
(14, '2026-05-30', 'Transferencia', 416.00),  
(16, '2026-05-25', 'Transferencia', 593.00),
(21, '2026-05-29', 'Transferencia', 593.00),  
(32, '2026-05-26', 'Transferencia', 4160.00), 
(33, '2026-06-02', 'Transferencia', 3570.00);
