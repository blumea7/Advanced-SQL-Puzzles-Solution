/*
Puzzle 9 - Matching Sets

Write an SQL statement that matches an employee to all other employees who carry the same license

Employee ID	| License
----------------------
1001		| Class A
1001		| Class B
1001		| Class C
2002		| Class A
2002		| Class B
2002		| Class C
3003		| Class A
3003		| Class D
4004		| Class A
4004		| Class B
4004		| Class D
5005		| Class A
5005		| Class B
5005		| Class D

Here is the expected output.

Employee ID |	Employee ID | Count
-----------------------------------
1001		|	2002		| 3
2002		|   1001		| 3
4004		|	5005		| 3
5005		|	4004		| 3

*/

USE AdvancedSQLPuzzles
GO

-- Prepare Data

DROP TABLE IF EXISTS EmployeeLicense

CREATE TABLE EmployeeLicense (
	EmployeeID int
	, License char(7)
)

INSERT INTO EmployeeLicense 
VALUES 
	(1001, 'Class A')
	, (1001, 'Class B')
	, (1001, 'Class C')
	, (2002, 'Class A')
	, (2002, 'Class B')
	, (2002, 'Class C')
	, (3003, 'Class A')
	, (3003, 'Class D')
	, (4004, 'Class A')
	, (4004, 'Class B')
	, (4004, 'Class D')
	, (5005, 'Class A')
	, (5005, 'Class B')
	, (5005, 'Class D')


-- Solution
;WITH MatchingSets AS (
SELECT 
	EL1.EmployeeID AS EmployeeID1
	, EL2.EmployeeID AS EmployeeID2
	, COUNT(EL1.License) AS MatchCount
FROM EmployeeLicense EL1 
INNER JOIN EmployeeLicense EL2 ON EL2.License = EL1.License AND EL1.EmployeeID <> EL2.EmployeeID
GROUP BY EL1.EmployeeID, EL2.EmployeeID
),

LicenseCount AS (SELECT 
	EmployeeID
	, COUNT(License) AS LicenseCount
FROM EmployeeLicense
GROUP BY EmployeeID
)

SELECT 
	EmployeeID1
	, EmployeeID2
	, MatchCount
FROM MatchingSets MS 
INNER JOIN LicenseCount LC ON MS.EmployeeID1 = LC.EmployeeID AND MS.MatchCount = LC.LicenseCount
INNER JOIN LicenseCount LC2 ON MS.EmployeeID2 = LC2.EmployeeID AND MS.MatchCount = LC2.LicenseCount


