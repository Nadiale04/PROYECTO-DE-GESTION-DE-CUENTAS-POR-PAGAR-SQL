---CONSULTAS REALIZADAS---

---1.TOP 3 productos mas comprados
SELECT TOP 3
	P.Descripcion,
	SUM(Dc.Cantidad) AS TotalComprado
FROM Productos P
JOIN DetalleCompras Dc ON P.IdProducto=Dc.IdProducto
GROUP BY P.Descripcion
ORDER BY TotalComprado DESC;


---2. Facturas por pagar por dia
SELECT 
    P.Razon_Social Proveedor,
    Cp.Serie + '-' + Cp.Numero  Documento,
    Cp.SaldoPendiente  Monto_A_Pagar,
    Cp.Moneda
FROM ComprobanteDePago Cp
JOIN Proveedores P ON Cp.IdProveedor = P.IdProveedor
WHERE Cp.FechaVencimiento='2026-05-31' AND SaldoPendiente > 0 


---3. Reporte de pagos realizados
SELECT 
    P.Razon_Social Proveedor,
    Cp.Serie + '-' + Cp.Numero ComprobanteDePago,
    Dp.MontoTotal  MontoPagado,
    Cp.Moneda,
	Dp.MetodoPago,
	Dp.FechaPago
FROM ComprobanteDePago Cp
JOIN DetallePago Dp ON Dp.IdComprobante=Cp.IdComprobante
JOIN Proveedores P ON P.IdProveedor=Cp.IdProveedor
ORDER BY FechaPago DESC


---4.Gasto total de combustible
SELECT 
	P.RUC, P.Razon_Social, 
	SUM (Dc.Cantidad) AS GalonesAbastecidos, 
	AVG(Dc.Precio_Unitario)*1.18 AS PrecioPorGalon, 
	SUM(Dc.Cantidad * Dc.Precio_Unitario)*1.18 AS GastoTotal
FROM ComprobanteDePago Cp
JOIN Proveedores P ON	Cp.IdProveedor=P.IdProveedor
JOIN DetalleCompras Dc ON Cp.IdComprobante=Dc.IdComprobante
WHERE Dc.IdProducto=23
GROUP BY P.Razon_Social, P.RUC, Cp.Moneda
ORDER BY PrecioPorGalon ASC


---5. Reporte de cantidad de compras por proveedor
SELECT
    P.Razon_Social AS Proveedor,
    COUNT(Cp.IdComprobante) AS Numero_compras,
	SUM(Cp.MontoTotal) AS TotalInvertido
FROM Proveedores P
JOIN ComprobanteDePago Cp
    ON P.IdProveedor = Cp.IdProveedor
GROUP BY P.Razon_Social
ORDER BY Numero_compras DESC


---6. Informe de transacciones por metodo de pago
SELECT 
    MetodoPago,
    COUNT(IdPago) AS NumeroTransacciones,
    SUM(MontoTotal) AS TotalPagado
FROM DetallePago
GROUP BY MetodoPago
ORDER BY TotalPagado DESC;


--7. Reporte de facturas vencidas
SELECT 
    P.Razon_Social AS Proveedor,
    Cp.Serie +'-'+Cp.Numero AS Factura,
    Cp.Moneda,
    Cp.Subtotal + Cp.Impuesto AS MontoNoPagado,
    Cp.FechaVencimiento
FROM ComprobanteDePago Cp
JOIN Proveedores P ON Cp.IdProveedor = P.IdProveedor
LEFT JOIN DetallePago Dp ON Cp.IdComprobante = Dp.IdComprobante
WHERE Dp.IdPago IS NULL 
AND Cp.FechaVencimiento < GETDATE()
ORDER BY Cp.FechaVencimiento ASC;


-- 8. Productos con poco stock
SELECT 
    IdProducto,
    Descripcion AS Producto,
    Stock AS StockActual
FROM Productos
WHERE Stock < 5
ORDER BY Stock ASC; 


---9.Procedimiento para consultar el precio de un producto por proveedor 
CREATE PROCEDURE sp_PrecioPromedioPorProveedor
@IdProducto INT
AS
BEGIN
	SELECT 
		Pr.Razon_Social AS Proveedor,
		AVG(Precio_Unitario)*1.18 AS PrecioPromedio
	FROM Productos P
	JOIN DetalleCompras Dc ON P.IdProducto=Dc.IdProducto
	JOIN ComprobanteDePago Cp ON Dc.IdComprobante=Cp.IdComprobante
	JOIN Proveedores Pr ON Pr.IdProveedor=Cp.IdProveedor
	WHERE P.IdProducto=@IdProducto
	GROUP BY Pr.Razon_Social
	ORDER BY PrecioPromedio ASC
	
	END;

--Ejecutar:
EXEC sp_PrecioPromedioPorProveedor 2;


-- 10.Stored Procedure - Reporte semanal de pendientes de pago
CREATE PROCEDURE sp_ConsultarFacturaPorPagar
@FechaVencimiento1 DATE,
@FechaVencimiento2 DATE
AS
BEGIN

	SELECT Cp.FechaEmision,  Cp.FechaVencimiento, Cp.Serie, Cp.Numero, P.RUC, P.Razon_Social, Cp.SaldoPendiente, Cp.Moneda
	FROM ComprobanteDePago Cp
	JOIN Proveedores P
	ON	Cp.IdProveedor=P.IdProveedor
	WHERE Cp.FechaVencimiento BETWEEN @FechaVencimiento1 AND @FechaVencimiento2
	AND Cp.SaldoPendiente>0;

	END;

-- Ejecutar:
EXEC sp_ConsultarFacturaPorPagar '2026-06-08','2026-06-14';


-- 11. Resumen gerencial de saldo pendiente de pago
SELECT 
    COUNT(DISTINCT IdProveedor) AS TotalProveedoresPorPagar, 
    COUNT(IdComprobante) AS NumeroFacturasPendientes,     
    SUM(SaldoPendiente) AS TotalPendiente,       
	Moneda
FROM ComprobanteDePago
WHERE SaldoPendiente > 0
GROUP BY Moneda;









