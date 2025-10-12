USE AdvancedSQLPuzzles
GO

/*

Puzzle 17: De-Grouping

Write an SQL Statement to de-group the ff. data:


=========================
Product		|	Quantity
=========================
Pencil		|	3
Eraser		|	4
Notebook	|	2
==========================

Expected Output:


=========================
Product		|	Quantity
=========================
Pencil		|	1
Pencil		|	1
Pencil		|	1
Eraser		|	1
Eraser		|	1
Eraser		|	1
Eraser		|	1
Notebook	|	1
Notebook	|	1
=========================
*/



-- Prepare Data
DROP TABLE IF EXISTS dbo.DeGrouping;

CREATE TABLE dbo.DeGrouping (
	Product VARCHAR(10)
	, Quantity INTEGER
);

INSERT INTO dbo.Degrouping VALUES
	('Pencil', 3)
	, ('Eraser', 4)
	, ('Notebook', 2);



-- Check Data
SELECT * FROM dbo.DeGrouping;


-- Solution 1: Recursive Query


WITH degrouping_CTE AS (
	SELECT	-- Base and Non-recursive Query
		Product
		, Quantity
	FROM dbo.DeGrouping
	
	UNION ALL

	SELECT 
		Product
		, Quantity = Quantity - 1
	FROM degrouping_CTE
	WHERE Quantity > 1 
)


SELECT 
	Product
	, Quantity = 1
FROM DeGrouping_CTE
ORDER BY Product ASC
