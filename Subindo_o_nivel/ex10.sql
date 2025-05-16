-- Mostre a média de dias entre a data do pedido e a data de envio, por método de envio.

SELECT
    PS.NAME AS METODO_ENVIO,
    AVG(DATEDIFF(DAY, ORDERDATE, SHIPDATE)) AS MEDIA
FROM SALES.SalesOrderHeader
    RIGHT JOIN PURCHASING.SHIPMETHOD PS ON PS.ShipMethodid = SALES.SALESORDERHEADER.SHIPMETHODID
GROUP BY 
    PS.NAME;