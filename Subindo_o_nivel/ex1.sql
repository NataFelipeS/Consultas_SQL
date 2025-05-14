-- Liste os nomes dos 100 primeiros produtos, com o nome da subcategoria e da categoria correspondente.

SELECT 
TOP 100 * 
FROM PRODUCTION.PRODUCT PD
INNER JOIN Production.ProductSubcategory PS ON PS.ProductSubcategoryID = PD.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC ON PC.ProductCategoryID = PS.ProductCategoryID