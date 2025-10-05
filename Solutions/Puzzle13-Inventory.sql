USE AdvancedSQLPuzzles
GO

/*

Puzzle 13: Inventory Tracking 

You work for a manufacturing company and need to track inventory adjustments from the warehouse. 

Some days the inventory increases, on other days the inventory decreases.
	

Write an SQL statement that will provide a running balance of the inventory. 


====================================
Date		| Quantity Adjustment
====================================
7/1/2018	| 100
7/2/2018	| 75
7/3/2018	| -150 
7/4/2018	| 50
7/5/2018	| -100


*/

-- Prepare Data

DROP TABLE IF EXISTS dbo.Inventory;

CREATE TABLE dbo.Inventory (
	[Date] DATE
	, [Quantity Adjustment] INTEGER
);

INSERT INTO dbo.Inventory VALUES 
	('7/1/2018', 100)
	, ('7/2/2018', 75)
	, ('7/3/2018', -150)
	, ('7/4/2018', 50)
	, ('7/5/2018', -100);

-- Check Data

SELECT * FROM dbo.Inventory;

-- Solution 

SELECT 
	[Date]
	, [Quantity Adjustment]
	, SUM([Quantity Adjustment]) OVER(PARTITION BY NULL ORDER BY [Date] ASC) AS [Inventory]
FROM dbo.Inventory