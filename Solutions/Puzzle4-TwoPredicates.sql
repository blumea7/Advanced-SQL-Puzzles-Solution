/*

Puzzle #4 - Two Predicates

Write an SQL statement given the following requirements.
For every customer that had a delivery to California, provide a result set of the customer orders that
were delivered to Texas.


Order ID	| Customer ID | Delivery State | Amount
--------------------------------------------------------
1			| 1001		  | CA			   | $340
2			| 1001		  | TX			   | $950
3			| 1001		  | TX			   | $670
4			| 1001		  | TX			   | $860
5			| 2002		  | WA			   | $320
6			| 3003        | CA			   | $650
7			| 3003        | CA			   | $830
8			| 4004        | TX			   | $120



Here is the expected output.

Customer ID | OrderID | Delivery State | Amount
-------------------------------------------------------
1001		| 2		  | TX			   | $950
1001		| 3       | TX			   | $670
1001		| 4	      | TX			   | $860


. Customer ID 1001 would be in the expected output as this customer had deliveries to both
California and Texas.
. Customer ID 3003 would not appear in the result set as they did not have a delivery to Texas.
. Customer ID 4004 would not appear in the result set as they did not have a delivery to California.

*/


-- Prepare Data

USE AdvancedSQLPuzzles 
GO

DROP TABLE IF EXISTS dbo.Sales

CREATE TABLE dbo.Sales (
	OrderID int PRIMARY KEY
	, CustomerID int
	, DeliveryState nchar(2)
	, Amount Money
)

INSERT INTO dbo.Sales (OrderID, CustomerID, DeliveryState, Amount)
VALUES 
	(1, 1001, 'CA', 340)
	, (2, 1001, 'TX', 950)
	, (3, 1001, 'TX', 670)
	, (4, 1001, 'TX', 860)
	, (5, 2002, 'WA', 320)
	, (6, 3003, 'CA', 650)
	, (7, 3003, 'CA', 830)
	, (8, 4004, 'TX', 120)

-- get the distinct list of ids of customer who had orders in ca
-- use the list as a filter for the sales table containing orders from texas only. 

-- Solution 1 : INNER JOIN
;WITH cte AS (
	SELECT 
		CustomerID
	FROM dbo.Sales
	WHERE DeliveryState = 'CA'
)

SELECT 
	s.CustomerID 
	, s.OrderID
	, s.DeliveryState
	, s.Amount
FROM dbo.Sales s
INNER JOIN cte ON cte.CustomerID = s.CustomerID
WHERE s.DeliveryState = 'TX'


-- Solution 2 : Filter via WHERE Clause

;WITH cte AS (
	SELECT 
		CustomerID
	FROM dbo.Sales
	WHERE DeliveryState = 'CA'
)

SELECT 
	s.CustomerID 
	, s.OrderID
	, s.DeliveryState
	, s.Amount
FROM dbo.Sales s
WHERE 
	s.DeliveryState = 'TX'
	AND s.CustomerID IN (SELECT cte.CustomerID FROM cte)
