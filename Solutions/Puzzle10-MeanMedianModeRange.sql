USE AdvancedSQLPuzzles
GO

/*

Puzzle 10 - Mean, Median, Mode, Range


Write an SQL statement to determine the mean, median, mode, and range of the given set of integers

5, 6, 10, 10, 13, 14, 17, 20, 81, 90, 78


*/

-- Prepare Data

DROP TABLE IF EXISTS dbo.integers;

CREATE TABLE dbo.integers (
	IntegerValue INTEGER 
);

INSERT INTO dbo.integers VALUES 
	(5)
	, (6) 
	, (10)
	, (10)
	, (13)
	, (14)
	, (17)
	, (20)
	, (81)
	, (90)
	, (78);

-- Solution 

WITH median_cte_1 AS (
	SELECT 
		IntegerValue
		, ROW_NUMBER() OVER(PARTITION BY NULL ORDER BY IntegerVAlue ASC) AS order_
		, COUNT(IntegerValue) OVER(PARTITION BY NULL) AS integer_count
		, CAST(COUNT(IntegerValue) OVER(PARTITION BY NULL) AS FLOAT)/2 AS median_pos
	FROM dbo.integers
),

median_cte_2 AS (
	SELECT 
		IntegerValue
		, (CASE WHEN (integer_count % 2) = 0 AND (order_- median_pos) IN (0, 0.5) THEN 1
			   WHEN  (integer_count % 2) != 0 AND (order_- median_pos) IN (0.5) THEN 1
			   ELSE 0 
		  END) AS flag
	FROM median_cte_1
),

average_cte AS (
	SELECT 
		IntegerValue
		, COUNT(IntegerValue) OVER (PARTITION BY NULL) AS total_count
	FROM dbo.integers
), 

mode_cte AS (
	SELECT 
		IntegerValue
		, COUNT(IntegerValue) AS instance_count
	FROM dbo.integers
	GROUP BY IntegerValue
), 

range_cte AS (
	SELECT 
		MAX(IntegerValue) AS MaxInt
		, MIN(IntegerValue) AS MinInt
	FROM dbo.integers
)

SELECT 
	AVG(IntegerValue) AS CalcValue, 
	Attribute = 'median'
FROM median_cte_2
	WHERE flag = 1

UNION ALL 

SELECT 
	ROUND(CAST(SUM(IntegerValue) AS float)/total_count,2) AS CalcValue,
	Attribute = 'mean'
FROM average_cte
GROUP BY total_count

UNION ALL

SELECT
	IntegerValue AS CalcValue
	, Attribute = 'mode'
FROM mode_cte
	WHERE instance_count IN (SELECT MAX(instance_count) FROM mode_cte)


UNION ALL

SELECT
	(MaxInt - MinInt) AS CalcValue
	, Attirbute = 'range'
FROM range_cte