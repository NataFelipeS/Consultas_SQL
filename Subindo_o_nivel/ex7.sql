-- Liste os clientes com mais de 5 pedidos realizados, mostrando o total de pedidos e valor total.

SELECT 
    SOH.CUSTOMERID,
    COUNT(SOH.CUSTOMERID) AS QUANTIDADE_COMPRAS,
    SUM(SOH.TOTALDUE) AS COMPRAS
FROM SALES.SALESORDERHEADER SOH
GROUP BY SOH.CustomerID
HAVING COUNT(SOH.CustomerID) > 5