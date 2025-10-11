USE AdvancedSQLPuzzles
GO

/*

Puzzle 15: Group Concatenation

Write an SQL statement that can group concatenate the ff. values:

===========================
Sequence	|	Syntax
===========================
1			| SELECT
2			| Product,
3			| UnitPrice,
4			| EffectiveDate
5			| FROM
6			| Products
7			| WHERE
8			| UnitPrice
9			| >100
===========================


Expected Output: 

==============================================================================
Syntax
==============================================================================
SELECT Product, UnitPrice, EffectiveDate FROM Products WHERE UnitPrice > 100 
==============================================================================

*/


-- Prepare Data

DROP TABLE IF EXISTS dbo.GroupConcatenation

CREATE TABLE dbo.GroupConcatenation (
	[Sequence]	INTEGER
	, Syntax	VARCHAR(20)
)


INSERT INTO dbo.GroupConcatenation VALUES
	(1, 'SELECT')
	, (2, 'Product,')
	, (3, 'UnitPrice,')
	, (4, 'EffectiveDate')
	, (5, 'FROM')
	, (6, 'Products')
	, (7, 'WHERE')
	, (8, 'UnitPrice')
	, (9, '>100')


-- Check Data

SELECT * FROM dbo.GroupConcatenation;


-- Solution 1: Recursive Query

WITH recursive_cte AS (
	SELECT  -- BASE QUERY, NON-RECURSIVE
		[Sequence]
		, CAST(Syntax AS VARCHAR(MAX)) AS [Syntax]
	FROM dbo.GroupConcatenation 
		WHERE [Sequence] = 1


	UNION ALL 

	SELECT
		b.[Sequence]
		, CAST(CONCAT(a.[Syntax], ' ',  b.[Syntax]) AS VARCHAR(MAX)) AS [Syntax] 
	FROM recursive_cte a INNER JOIN dbo.GroupConcatenation b ON a.[Sequence] + 1 = b.[Sequence]
)

SELECT 
	[Syntax]
FROM recursive_cte
WHERE [Sequence] = (SELECT MAX([Sequence]) FROM dbo.GroupConcatenation)


-- Solution 2: STRINGAGG function

SELECT 
	STRING_AGG(Syntax, ' ') AS Syntax
FROM dbo.GroupConcatenation