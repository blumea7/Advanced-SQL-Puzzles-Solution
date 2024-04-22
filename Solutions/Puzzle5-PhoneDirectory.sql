/*
Puzzle #5 Phone Directory

Your customer phone directory table allows individuals to set up a home, cellular, or work phone
number.

Sample Data
Customer ID | Type      |   Phone Number
--------------------------------------
1001        | Cellular  | 555-897-5421
1001        | Work      | 555-897-6542
1001        | Home      | 555-698-9874
2002        | Cellular  | 555-963-6544
2002        | Work      | 555-812-9856
3003        | Cellular  | 555-987-6541

Write an SQL statement to transform the following table into the expected output.

Here is the expected output.

Customer ID | Cellular      | Work          | Home
---------------------------------------------------
1001        | 555-897-5421  | 555-897-6542  | 555-698-9874
2002        | 555-963-6544  | 555-812-9856  |
3003        | 555-987-6541  |               |


*/

USE AdvancedSQLPuzzles
GO

-- Prepare Data

CREATE TABLE dbo.PhoneDirectory(
	CustomerID int 
	, [Type] nvarchar(15)
	, PhoneNumber nchar(12)
)

INSERT INTO dbo.PhoneDirectory (
	CustomerID
	, [Type]
	, PhoneNumber
) VALUES 
	(1001, 'Cellular', '555-897-5421')
	, (1001, 'Work', '555-897-6542')
	, (1001, 'Home', '555-698-9874')
	, (2002, 'Cellular', '555-963-6544')
	, (2002, 'Work', '555-812-9856')
	, (3003, 'Cellular', '555-987-6541')


-- Solution
WITH CTE AS (
	SELECT 
		CustomerID
		, CASE WHEN [Type] = 'Cellular' THEN PhoneNumber ELSE '' END AS "Cellular"
		, CASE WHEN [Type] = 'Work' THEN PhoneNumber ELSE '' END AS "Work"
		, CASE WHEN [Type] = 'Home' THEN PhoneNumber ELSE '' END AS "Home"

	FROM dbo.PhoneDirectory
)

SELECT 
	CustomerID
	, MAX(Cellular) AS 'Cellular'
	, MAX(Work) AS 'Work' 
	, MAX(Home) AS 'Home'
FROM CTE
GROUP BY CustomerID