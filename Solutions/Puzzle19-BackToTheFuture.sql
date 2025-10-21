USE AdvancedSQLPuzzles
GO

/*
Puzzle 19: Back to the Future

Write an SQL statement to merge the overlapping time periods.

============================
Start Date	|	End Date
============================
1/1/2018	| 1/5/2018
1/3/2018	| 1/9/2018
1/10/2018	| 1/11/2018
1/12/2018	| 1/16/2018
1/15/2018	| 1/19/2018
=============================

Here's the expected output.

============================
Start Date	|	End Date
============================
1/1/2018	| 1/9/2018
1/10/2018	| 1/11/2018
1/12/2018	| 1/19/2018
============================


*/

-- Prepare Data


DROP TABLE IF EXISTS dbo.BackToTheFuture;


CREATE TABLE dbo.BackToTheFuture(
	StartDate DATE
	, EndDate DATE
)

INSERT INTO dbo.BackToTheFuture VALUES
	('1/1/2018', '1/5/2018')
	, ('1/3/2018', '1/9/2018')
	, ('1/10/2018', '1/11/2018')
	, ('1/12/2018', '1/16/2018')
	, ('1/15/2018', '1/19/2018')



-- Check Data
SELECT * FROM dbo.BackToTheFuture;

-- Solution 1: LEAD() Function

WITH NextDatesCTE AS (
	SELECT 
		StartDate
		, EndDate
		, LEAD(StartDate) OVER(ORDER BY StartDate) AS NextStartDate
		, LEAD(EndDate) OVER(ORDER BY EndDate) AS NextEndDate
	FROM dbo.BackToTheFuture
),

MergeFlagCTE AS (
	SELECT
		StartDate
		, EndDate
		, NextStartDate
		, NextEndDate
		, (CASE WHEN NextStartDate BETWEEN StartDate AND EndDate THEN 1 ELSE 0 END) AS MergeFlag
	FROM NextDatesCTE
), 

MergedEndDatesCTE AS (
	SELECT 
		NextEndDate
	FROM MergeFlagCTE
	WHERE MergeFlag = 1
)

SELECT * FROM
	(
	SELECT 
		StartDate 
		, EndDate = NextEndDate
	FROM MergeFlagCTE 
	WHERE MergeFlag = 1

	UNION ALL

	SELECT 
		StartDate
		, EndDate 
	FROM MergeFlagCTE
	WHERE MergeFlag = 0
	AND EndDate NOT IN (SELECT NextEndDate FROM MergedEndDatesCTE)
	) answer
ORDER BY StartDate ASC;


-- Solution 2: Self-Join

WITH MergedDates AS (
	SELECT 
		a.StartDate 
		, b.EndDate 
	FROM dbo.BackToTheFuture a INNER JOIN dbo.BackToTheFuture b ON a.EndDate > b.StartDate AND a.EndDate <b.EndDate
), 

UnMergedDates AS (
	SELECT
		StartDate
		, EndDate
	FROM dbo.BackToTheFuture 
		WHERE StartDate NOT IN (SELECT StartDate FROM MergedDates) AND EndDate NOT IN (SELECT EndDate FROM MergedDates)
)

SELECT * FROM (
	SELECT * FROM MergedDates
		UNION ALL
	SELECT * FROM UnMergedDates
) answer
ORDER BY StartDate