USE AdvancedSQLPuzzles
GO
/*

Puzzle 21: Average Monthly Sales

Write an SQL statements that returns a list of states where customers have an average monthly sales
value that is consistently greater than $100


=====================================================================
Order ID	|	Customer ID		| Order Date	|	Amount	| State
=====================================================================
1			| 1001				| 1/1/2018      |  100		|  TX
2			| 1001				| 1/1/2018      |  150		|  TX
3			| 1001				| 1/1/2018      |  75		|  TX
4			| 1001				| 2/1/2018      |  100		|  TX
5			| 1001				| 3/1/2018      |  100		|  TX
6			| 2002				| 2/1/2018      |  75		|  TX
7			| 2002				| 2/1/2018      |  150		|  TX
8			| 3003				| 1/1/2018      |  100		|  TX
9			| 3003				| 2/1/2018      |  100		|  TX
10			| 3003				| 3/1/2018      |  100		|  TX
11			| 4004				| 4/1/2018      |  100		|  TX
12			| 4004				| 5/1/2018      |  50		|  TX
13			| 4004				| 5/1/2018      |  100		|  TX
=====================================================================


Here is the expected output:
========
State
========
TX
========
*/


-- Prepare Data

DROP TABLE IF EXISTS dbo.AveMonthlySales


CREATE TABLE dbo.AveMonthlySales (
	OrderID INT
	, CustomerID INT
	, OrderDate DATE
	, Amount SMALLMONEY	
	, [State] NVARCHAR(3)
)

INSERT INTO dbo.AveMonthlySales VALUES
	(1, 1001, '1/1/2018', 100, 'TX')
	, (2, 1001, '1/1/2018', 150, 'TX')
	, (3, 1001, '1/1/2018', 75, 'TX')
	, (4, 1001, '2/1/2018', 100, 'TX')
	, (5, 1001, '3/1/2018', 100, 'TX')
	, (6, 2002, '2/1/2018', 75, 'TX')
	, (7, 2002, '2/1/2018', 150, 'TX')
	, (8, 3003, '1/1/2018', 100, 'IA')
	, (8, 3003, '2/1/2018', 100, 'IA')
	, (10, 3003, '3/1/2018', 100, 'IA')
	, (11, 4004, '4/1/2018', 100, 'IA')
	, (12, 4004, '5/1/2018', 50, 'IA')
	, (13, 4004, '5/1/2018', 100, 'IA')


-- Check Data

SELECT * FROM dbo.AveMonthlySales;

-- Solution

WITH MonthlySalesCTE AS(

SELECT
	CustomerID
	, CONCAT(MONTH(OrderDate),'-', YEAR(OrderDate)) AS MonthYear
	, AVG(Amount) AS AveMonthlySales
	, [State]
	, (CASE 
		WHEN AVG(Amount) < 100 THEN 1 ELSE 0 
	  END) AS Flag
FROM dbo.AveMonthlySales
GROUP BY CustomerID, CONCAT(MONTH(OrderDate),'-', YEAR(OrderDate)), [State]
),

GoodSalesIndicatorCTE AS (
	SELECT
		[State]
		, SUM(Flag) AS GoodSalesIndicator
	FROM MonthlySalesCTE
	GROUP BY [State]
)

SELECT 
	[State]
FROM GoodSalesIndicatorCTE
WHERE GoodSalesIndicator <> 1