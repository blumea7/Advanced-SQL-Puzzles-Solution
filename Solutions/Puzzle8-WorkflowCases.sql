/*
Puzzle 8 - Workflow Cases

You have a report of all workflows and their case results. 
A value of 0 signifies the workflow failed, and a value of 1 signifies the workflow passed.
Write an SQL statement that transforms the following table into the expected output.

Workflow | Case 1 | Case 2 | Case 3
------------------------------------
Alpha	 |   0    |   0	   |  0
Bravo    |   0    |   1    |  1
Charlie  |   1    |   0    |  0
Delta    |   0    |   0    |  0


Here's the expected output

Workflow | Passed
-----------------
Alpha	 |  0
Bravo    |  2
Charlie  |  1
Delta    |  0


*/

-- Prepare Data

DECLARE @WorkflowResults TABLE(
	Workflow nvarchar(10)
	, Case1 int
	, Case2 int
	, Case3 int
)

INSERT INTO @WorkflowResults
VALUES
	('Alpha', 0, 0, 0)
	, ('Bravo', 0, 1, 1)
	, ('Charlie', 1, 0, 0)
	, ('Delta', 0, 0, 0)


-- SELECT * FROM @WorkflowResults

-- Solution 1
SELECT
	Workflow 
	, Case1 + Case2 + Case3 AS Passed
FROM  @WorkflowResults


-- Solution 2
;WITH UnpivotCTE AS(
SELECT 
	Workflow
	, CaseNum
	, CaseStatus
FROM @WorkflowResults

UNPIVOT(
	CaseStatus
	FOR CaseNum IN (Case1, Case2, Case3)
) AS unpivot_data
)

SELECT 
	Workflow
	, SUM(CaseStatus)
FROM UnpivotCTE
GROUP BY Workflow