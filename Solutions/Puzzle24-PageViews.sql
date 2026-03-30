USE AdvancedSQLPuzzles 
GO 

/*
	Puzzle 24: Page View
	Retrieve records 5 to 10 ordered by the Order ID column
*/


-- Create Table

CREATE TABLE dbo.PageViews (
	[Order ID] int
	, [Customer ID] int
	, [Order Date] date
	, [Amount] money
	, [State] nvarchar(2)
); 


-- Populate Table

INSERT INTO dbo.PageViews VALUES
	(1,	1001, '2018/1/1', 100, 'TX')
	, (2,	3003, '2018/1/1', 100, 'IA')
	, (3,	1001, '2018/3/1', 100, 'TX')
	, (4,	2002, '2018/2/1', 150, 'TX')
	, (5,	1001, '2018/2/1', 100, 'TX')
	, (6,	4004, '2018/5/1', 50, 'IA')
	, (7,	1001, '2018/1/1', 150, 'TX')
	, (8,	3003, '2018/3/1', 100, 'IA')
	, (9,	4004, '2018/4/1', 100, 'IA')
	, (10,	1001, '2018/1/1', 75, 'TX')
	, (11,	2002, '2018/2/1', 75, 'TX')
	, (12,	3003, '2018/2/1', 100, 'IA')
	, (13,	4004, '2018/5/1', 100, 'IA')

-- Check Data

SELECT TOP(10) * FROM dbo.PageViews

-- Solution 1: 

SELECT
	[Order ID]
	, [Customer ID]
	, [Order Date]
	, [Amount]
	, [State]
FROM dbo.PageViews
WHERE [Order ID] BETWEEN 5 and 9
ORDER BY [Order ID] ASC



-- Solution 2: 
-- Note: Offset clause is used to skip a specified number of rows before starting to return rows
SELECT
	[Order ID]
	, [Customer ID]
	, [Order Date]
	, [Amount]
	, [State]
FROM dbo.PageViews
ORDER BY [Order ID] ASC
OFFSET 4 ROWS FETCH NEXT 5 ROWS ONLY

