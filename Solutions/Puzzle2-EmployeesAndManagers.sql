/*

Puzzle #2 - Managers and Employees

Given the following hierarchical table, write a SQL statement that determines the
1) Count of employees a manager supervises
2) Level of depth each employee has from the president
3) Total count of employees with lower career level than an Employee

Employee ID | Manager ID | Job Title
----------------------------------
1001		|			 | President
2002		| 1001		 | Director
3003		| 1001		 | Office Manager
4004		| 2002		 | Engineer
5005		| 2002		 | Engineer
6006		| 2002		 | Engineer

Expected outputs
1. 

ManagerID	| Supervisees
1001		| 2
2002		| 3

2.

Employee ID | Manager ID | Job Title		| Depth
-------------------------------------------------------------
1001		|			 | President		| 0
2002		| 1001		 | Director			| 1
3003		| 1001		 | Office Manager	| 1
4004		| 2002		 | Engineer			| 2
5005		| 2002		 | Engineer			| 2
6006		| 2002		 | Engineer			| 2

3. 
Employee ID | Manager ID | Job Title		| Depth  |  Count Lower
-----------------------------------------------------------------
1001		|			 | President		| 0		 | 5
2002		| 1001		 | Director			| 1		 | 3
3003		| 1001		 | Office Manager	| 1		 | 3
4004		| 2002		 | Engineer			| 2      | 0
5005		| 2002		 | Engineer			| 2      | 0 
6006		| 2002		 | Engineer			| 2      | 0


*/


-- Prepare Data

USE AdvancedSQLPuzzles
GO

DROP TABLE IF EXISTS dbo.Employees

CREATE TABLE dbo.Employees (
	EmployeeID int
	, ManagerID int
	, JobTitle nvarchar(50)
	, CONSTRAINT PK_Employees_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)
)

INSERT INTO dbo.Employees (EmployeeID, ManagerID, JobTitle)
VALUES 
	(1001,NULL,'President')
	,(2002,1001,'Director')
	,(3003,1001,'Office Manager')
	,(4004,2002,'Engineer')
	,(5005,2002,'Engineer')
	,(6006,2002,'Engineer')

-- Problem 1: Count of employees a manager supervises

SELECT 
	e.ManagerID
	, COUNT(e.EmployeeID) AS Supervisees
FROM dbo.Employees e
WHERE e.ManagerID IS NOT NULL
GROUP BY e.ManagerID


-- Problem 2: Level of depth each employee has from the president

;WITH cte AS (
	SELECT 
		EmployeeID = emp.EmployeeID, 
		ManagerID = emp.ManagerID, 
		JobTitle = emp.JobTitle, 
		Depth = 0
	FROM dbo.Employees emp
	WHERE emp.ManagerID IS NULL

	UNION ALL
	SELECT 
		emp2.EmployeeID, emp2.ManagerID, emp2.JobTitle, Depth = Depth+1
	FROM cte
	INNER JOIN dbo.Employees emp2 ON emp2.ManagerID = cte.EmployeeID
)

SELECT * FROM cte

-- Problem 3. Total count of employees with lower career level than the current row Employee

--TO DO
;WITH cte AS (
	SELECT
		EmployeeID = emp.EmployeeID
		, ManagerID = emp.ManagerID
		, JobTitle = emp.JobTitle
		, Depth = 0
	FROM dbo.Employees emp
	WHERE emp.ManagerID IS NULL

	UNION ALL

	SELECT 
		emp2.EmployeeID
		, emp2.ManagerID
		, emp2.JobTitle
		, Depth = Depth + 1
	FROM cte 
	INNER JOIN dbo.Employees emp2 ON cte.EmployeeID = emp2.ManagerID

)

, cte2 AS (
SELECT 
	*
	, COUNT(cte.EmployeeID) OVER(PARTITION BY (SELECT NULL)) AS Total
	, COUNT(cte.EmployeeID) OVER(PARTITION BY (SELECT Depth)) AS CountPerLevel
FROM cte
)

, cte3 AS (
	SELECT 
		cte2.EmployeeID
		, cte2.ManagerID
		, cte2.JobTitle
		, cte2.Depth
		, CountLower = cte2.Total - cte2.CountPerLevel
	FROM cte2
	WHERE cte2.ManagerID IS NULL

	UNION ALL

	SELECT 
		  cte2.EmployeeID
		, cte2.ManagerID
		, cte2.JobTitle
		, cte2.Depth
		, CountLower = CountLower - cte2.CountPerLevel
	FROM cte3
	INNER JOIN cte2 ON cte2.ManagerID = cte3.EmployeeID
)

SELECT
	*
FROM cte3