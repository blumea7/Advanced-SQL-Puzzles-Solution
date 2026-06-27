USE AdvancedSQLPuzzles
GO

/*
	Puzzle 26: Previous Year's Sales
	Write an SQL statement that shows the current year's sales, along
	with previous year's sales, and sales from two years ago

	Expected Output: 

	------------------------------
	2018	 |  2017	| 2016
	------------------------------
	$352,645 | $420,219	| $411,217
*/


-- Create table structure

DROP TABLE IF EXISTS dbo.PrevYearSales

CREATE TABLE dbo.PrevYearSales (
	[Year] int
	, [Amount] money
); 


-- Populate table

INSERT INTO dbo.PrevYearSales VALUES 
	(2018, 352645)
	, (2017, 165565)
	, (2017, 254654)
	, (2016, 159521)
	, (2016, 251696)
	, (2016, 111894);


-- Check Data

SELECT TOP(10) * FROM dbo.PrevYearSales


-- Solution 1: Pivot

SELECT
	[2018]
	, [2017]
	, [2016]
FROM dbo.PrevYearSales
PIVOT (
	SUM(Amount)
	FOR [Year] IN ([2018], [2017], [2016])
) AS SalesPivot