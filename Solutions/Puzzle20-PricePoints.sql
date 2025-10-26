USE AdvancedSQLPuzzles
GO
/*

Puzzle 20: Price Points

Write an SQL statement to determine the current price point for each product. 

==============================================
Product ID	|	Effective Date	| Unit Price
==============================================
1001		|	1/1/2018		| $1.99
1001		|	4/15/2018		| $2.99
1001		|	6/8/2018		| $3.99
2002		|	4/17/2018		| $1.99
2002		|	5/19/2018		| $2.99
==============================================

Expected output:

==============================================
Product ID	|	Effective Date	| Unit Price
==============================================
1001		|	6/8/2018		| $3.99
2002		|	5/19/2018		| $2.99


*/

-- Prepare Data

DROP TABLE IF EXISTS dbo.PricePoints

CREATE TABLE dbo.PricePoints(
	ProductID INT
	, EffectiveDate DATE
	, UnitPrice SMALLMONEY
)

INSERT INTO dbo.PricePoints VALUES 
	(1001, '1/1/2018', 1.99)	
	, (1001, '4/15/2018', 2.99)	
	, (1001, '6/8/2018', 3.99)	
	, (2002, '4/17/2018', 1.99)	
	, (2002, '5/19/2018', 2.99);


-- Solution 1: CTE and Join

WITH MaxDatesCTE AS (
	SELECT 
		ProductID
		, MAX(EffectiveDate) AS EffectiveDate
	FROM dbo.PricePoints
	GROUP BY ProductID
)

SELECT 
	a.ProductID
	, b.EffectiveDate
	, UnitPrice
FROM dbo.PricePoints a INNER JOIN MaxDatesCTE b ON (a.ProductID = b.ProductID AND a.EffectiveDate = b.EffectiveDate)
ORDER BY ProductID


-- Solution 2: Window Function

WITH MaxDateCTE AS(
	SELECT 
		ProductID
		, EffectiveDate
		, UnitPrice
		, MAX(EffectiveDate) OVER(PARTITION BY ProductID) AS MaxEffectiveDate
	FROM dbo.PricePoints
)

SELECT 
	ProductID
	, EffectiveDate
	, UnitPrice
FROM MaxDateCTE
	WHERE EffectiveDate = MaxEffectiveDate
	ORDER BY ProductID