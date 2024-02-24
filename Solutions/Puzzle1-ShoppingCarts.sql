/*
Puzzle #1 - Shopping Carts

You are tasked with providing an audit of two shopping carts.
Write an SQL statement to transform the following tables into the expected output.

Item    | Item
--------------------
Sugar   | Sugar
Bread   | Bread
Juice   | Butter
Soda    | Cheese
Flour   | Fruit

Here is the expected output.

Item Cart 1 | Item Cart 2
Sugar       | Sugar
Bread       | Bread
Juice       |
Soda        |
Flour       |
            | Butter
            | Cheese
            | Fruit

*/


-- Prepare Data
USE AdvancedSQLPuzzles
GO

DROP TABLE IF EXISTS dbo.Cart1

CREATE TABLE dbo.Cart1 (
	Item nvarchar(50)
)

INSERT INTO dbo.Cart1 
VALUES ('Sugar'), ('Bread'), ('Juice'), ('Soda'), ('Flour')

DROP TABLE IF EXISTS dbo.Cart2

CREATE TABLE dbo.Cart2 (
	Item nvarchar(50)
)

INSERT INTO dbo.Cart2
VALUES ('Sugar'), ('Bread'), ('Butter'), ('Cheese'), ('Fruit')
-- End of data preparation


-- Solution 1: FULL OUTER JOIN
SELECT 
	*
FROM dbo.Cart1 c1 
FULL OUTER JOIN dbo.Cart2 c2 ON c1.Item = c2.Item


-- Solution 2: LEFT JOIN - UNION - RIGHT JOIN
SELECT 
	*
FROM dbo.Cart1 c1
LEFT JOIN dbo.Cart2 c2 ON c1.Item = c2.Item

UNION ALL

SELECT 
	*
FROM dbo.Cart1 c1
RIGHT JOIN dbo.Cart2 c2 ON c1.Item = c2.Item
WHERE c1.Item IS NULL


-- Solution 3: INNER JOIN - UNION - LEFT JOIN - UNION - RIGHT JOIN
SELECT 
	*
FROM dbo.Cart1 c1
INNER JOIN dbo.Cart2 c2 ON c1.Item = c2.Item

UNION ALL 

SELECT 
	*
FROM dbo.Cart1 c1
LEFT JOIN dbo.Cart2 c2 ON c1.Item = c2.Item
WHERE c2.Item IS NULL

UNION ALL

SELECT 
	*
FROM dbo.Cart1 c1
RIGHT JOIN dbo.Cart2 c2 ON c1.Item = c2.Item
WHERE c1.Item IS NULL