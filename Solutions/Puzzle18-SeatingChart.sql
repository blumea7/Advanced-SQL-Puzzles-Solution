USE AdvancedSQLPuzzles
GO

/*

Puzzle 18: Seating Chart

Given the set of integers provided in the ff. DDL Statement, 
write SQL statements to determine the ff:

1) Gap Starts and Gap Ends
2) Total Missing Numbers
3) Count of odd and even numbers


============
SeatNumber	
============
7
13
14
15
27
28
29
30
31
32
33
34
35
52
53
54
============


Expected Output


=========================
Gap Start	|	Gap End 
=========================
	1		|	6
	8		|	12
	16		|	26
	36		|	51
=========================


======================
Total Missing Numbers	
======================
		38
======================



=========================
	Type	|	Count 
=========================
	Even	|	7
	Odd		|	9
=========================

*/



-- Prepare Data
DROP TABLE IF EXISTS dbo.SeatingChart;

CREATE TABLE dbo.SeatingChart (
	SeatNumber INTEGER
);

INSERT INTO dbo.SeatingChart VALUES
	(7),(13),(14),(15),(27),(28),(29),(30), 
	(31),(32),(33),(34),(35),(52),(53),(54);


-- Check Data
SELECT * FROM dbo.SeatingChart;


-- Solution 

-- Solve Gap Start and Gap End problem

WITH SeatingChartWithZero AS (
	SELECT SeatNumber = 0 
	UNION ALL
	SELECT * FROM dbo.SeatingChart
),

GapCTE AS (
	SELECT 
		SeatNumber 
		, (LEAD(SeatNumber) OVER(PARTITION BY NULL ORDER BY SeatNumber)- SeatNumber) AS Gap
	FROM SeatingChartWithZero
)

SELECT 
	SeatNumber + 1 AS GapStart
	, SeatNumber + Gap - 1 AS GapEnd
FROM GapCTE
WHERE Gap > 1;


-- Solve Total Missing Numbers
SELECT 
(SELECT MAX(SeatNumber) FROM dbo.SeatingChart) -
(SELECT COUNT(SeatNumber) FROM dbo.SeatingChart) AS [Total Missing Numbers];


-- Solve Odd, Even Count

WITH OddEven_cte AS(
	SELECT
		SeatNumber
		, (CASE
			WHEN SeatNumber % 2 = 0 THEN 'Even'
			WHEN SeatNumber % 2 <> 0 THEN 'Odd'
		  END) AS Type
	FROM dbo.SeatingChart
)

SELECT 
	[Type],
	COUNT([Type]) AS [Count]
FROM OddEven_cte
GROUP BY [Type]