-- 1.	List all unique product names and their product numbers.

SELECT DISTINCT EnglishProductName, ProductAlternateKey FROM [dbo].[DimProduct]

-- 2.	Count how many orders each customer has placed.

WITH Total_Sales as
(SELECT CONCAT(C.FirstName,' ',C.LastName) AS "Customer Name",COUNT(FS.SalesOrderNumber) AS OrderCount 
FROM [dbo].[FactInternetSales] FS
JOIN [dbo].[DimCustomer] C
ON C.CustomerKey = FS.CustomerKey
GROUP BY C.CustomerKey,CONCAT(C.FirstName,' ',C.LastName))

SELECT * FROM Total_Sales


-- 3.	Retrieve the first name, last name, and hire date of all employees who were hired in 2008.

SELECT CONCAT(FirstName,' ',LastName) AS "Employee Name" FROM [dbo].[DimEmployee]
WHERE YEAR(HireDate) = '2008'

-- 4. List the subcategories and their associated categories.

SELECT PC.EnglishProductCategoryName,PS.EnglishProductSubcategoryName FROM [dbo].[DimProductCategory] PC
JOIN [dbo].[DimProductSubcategory] PS
ON PC.ProductCategoryKey = PS.ProductCategoryKey

-- 5. Find the total sales amount for each product.

SELECT FS.ProductKey,P.EnglishProductName, SUM(FS.SalesAmount) AS TotalSales FROM [dbo].[FactInternetSales] FS
JOIN [dbo].[DimProduct] P
ON FS.ProductKey = P.ProductKey
GROUP BY FS.ProductKey,P.EnglishProductName

-- 6. Retrieve all employees whose title is 'Sales Representative'.

SELECT CONCAT(FirstName,' ',LastName) AS "Employee Name" FROM [dbo].[DimEmployee]
WHERE Title = 'Sales Representative'

-- 7. List the different types of promotions

SELECT EnglishPromotionType AS PromotionType FROM [dbo].[DimPromotion]

-- 8. List all customers located in 'United Kingdom'.

SELECT CONCAT(C.FirstName,' ',C.LastName) AS "Customer Name" FROM [dbo].[DimCustomer] C
JOIN [dbo].[DimGeography] G
ON G.GeographyKey = C.GeographyKey
WHERE G.EnglishCountryRegionName = 'United Kingdom'
GROUP BY C.GeographyKey, CONCAT(C.FirstName,' ',C.LastName)

SELECT CONCAT(C.FirstName, ' ', C.LastName)
FROM [dbo].[DimCustomer] C
JOIN [dbo].[DimGeography] G ON G.GeographyKey = C.GeographyKey
WHERE G.EnglishCountryRegionName = 'United Kingdom';

-- 9. Find the top 5 products with the highest total sales amount.

SELECT TOP(5) P.EnglishProductName,SUM(FS.SalesAmount) AS TotalSales FROM [dbo].[FactInternetSales] FS
JOIN [dbo].[DimProduct] P
ON FS.ProductKey = P.ProductKey
GROUP BY FS.ProductKey,P.EnglishProductName
ORDER BY SUM(FS.SalesAmount) DESC

SELECT P.EnglishProductName,SUM(FS.SalesAmount) AS TotalSales FROM [dbo].[FactInternetSales] FS
JOIN [dbo].[DimProduct] P
ON FS.ProductKey = P.ProductKey
GROUP BY FS.ProductKey,P.EnglishProductName
ORDER BY SUM(FS.SalesAmount) DESC OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY

-- 10. Retrieve the names of customers who have placed more than 5 orders, along with the total number of orders they have placed

--using having 
SELECT CONCAT(C.FirstName,' ',C.LastName) As FullName,COUNT(FS.SalesOrderNumber) As TotalSales FROM [dbo].[DimCustomer] C
JOIN [dbo].[FactInternetSales] FS
ON C.CustomerKey = FS.CustomerKey
GROUP BY FS.CustomerKey,CONCAT(C.FirstName,' ',C.LastName)
HAVING COUNT(FS.SalesOrderNumber) > 5

--using sub query
SELECT CONCAT(C.FirstName,' ',C.LastName) As FullName,COUNT(FS.SalesOrderNumber) As TotalSales FROM [dbo].[DimCustomer] C
JOIN [dbo].[FactInternetSales] FS
ON C.CustomerKey = FS.CustomerKey
WHERE (SELECT COUNT(FS.SalesOrderNumber)
       FROM [dbo].[FactInternetSales] FS
       WHERE FS.CustomerKey = C.CustomerKey) > 5
GROUP BY FS.CustomerKey,CONCAT(C.FirstName,' ',C.LastName)

-- 11. List the products that have never been sold

SELECT P.EnglishProductName FROM [dbo].[DimProduct] P
WHERE P.ProductKey NOT IN (SELECT ProductKey FROM [dbo].[FactInternetSales])

-- 12. List the top 3 countries with the highest number of customers

SELECT G.EnglishCountryRegionName ,COUNT(C.CustomerKey) AS TotalCustomer FROM [dbo].[DimCustomer] C
JOIN [dbo].[DimGeography] G
ON C.GeographyKey = G.GeographyKey
GROUP BY G.EnglishCountryRegionName 
ORDER BY TotalCustomer DESC OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY

