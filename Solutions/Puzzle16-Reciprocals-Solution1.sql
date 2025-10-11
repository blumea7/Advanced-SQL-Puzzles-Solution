USE AdvancedSQLPuzzles
GO

/*

Puzzle 16: Reciprocals

You work for a software company that released a 2-player game and you need to tally the scores

Given the ff. table, write an SQL statement to determine the reciprocals and calculate their aggregate scote

======================================
Player A	|	Player B	|	Score
======================================
1001		| 2002			| 150
3003		| 4004			| 15
4004		| 3003			| 125
=======================================


Expected Output: 

======================================
Player A	|	Player B	|	Score
======================================
1001		| 2002			| 150
3003		| 4004			| 140
=======================================

*/


-- Prepare Data

DROP TABLE IF EXISTS dbo.Reciprocals

CREATE TABLE dbo.Reciprocals (
	[Player A] INTEGER
	, [Player B] INTEGER
	, Score	INTEGER
)


INSERT INTO dbo.Reciprocals VALUES
	(1001, 2002, 150)
	, (3003, 4004, 15)
	, (4004, 3003, 125)

-- Check Data

SELECT * FROM dbo.Reciprocals;

-- Solution 1:

WITH team_score AS (
	SELECT 
		(CASE 
			WHEN [Player A] < [Player B] THEN CONCAT([Player A], '-', [Player B]) 
			ELSE  CONCAT([Player B], '-', [Player A])
		END) AS [Team]
		, SUM(Score) AS Score
	FROM dbo.Reciprocals
	GROUP BY
		(CASE 
			WHEN [Player A] < [Player B] THEN CONCAT([Player A], '-', [Player B]) 
			ELSE  CONCAT([Player B], '-', [Player A])
		END)
)

SELECT 
	LEFT([Team], CHARINDEX('-', [Team]) - 1) AS [Player A] 
	, RIGHT([Team], LEN([Team]) - CHARINDEX('-', [Team])) AS [Player A]
	, Score
FROM team_score
