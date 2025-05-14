-- Liste os produtos cujo preço de venda (ListPrice) seja maior que R$ 1000, em ordem decrescente de preço.

SELECT
    PRODUCTID,
    NAME,
    PRODUCTNUMBER,
    LISTPRICE
FROM Production.Product
WHERE ListPrice >= 1000
ORDER BY ListPrice DESC;