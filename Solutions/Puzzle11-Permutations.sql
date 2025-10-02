USE AdvancedSQLPuzzles;

/*
	Puzzle 11: Permutations

	Determine all posible permutations of the given test cases: A, B, C
	Code should take into account possible varying number of test cases.


*/
-- Prepare Data

DROP TABLE IF EXISTS dbo.Permutation;

CREATE TABLE dbo.Permutation(
	[Test Case] VARCHAR
)

INSERT INTO dbo.Permutation VALUES
	('A')
	, ('B')
	, ('C');


-- Solution 

DECLARE @max_iteration INTEGER;
SET @max_iteration = (SELECT COUNT([Test Case]) FROM dbo.Permutation);


WITH permutation_cte AS (
	SELECT 
		CAST([Test Case] AS VARCHAR(MAX)) AS answer
		, iteration = 1
	FROM dbo.Permutation


	UNION ALL

	SELECT
		CAST(CONCAT(a.answer,',', b.[Test Case]) AS VARCHAR(MAX)) AS answer
		, iteration = a.iteration + 1
	FROM permutation_cte a CROSS JOIN dbo.Permutation b
		WHERE CHARINDEX(b.[Test Case], a.answer) = 0
		AND  iteration < @max_iteration

)

SELECT 
	answer
FROM permutation_cte
WHERE iteration = @max_iteration
ORDER BY answer ASC