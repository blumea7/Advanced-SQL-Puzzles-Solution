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


-- Solution

WITH correct_player_cte AS (
	SELECT 
		(CASE WHEN [Player A] < [Player B] THEN [Player A] ELSE [Player B] END) AS [Player A]
		, (CASE WHEN [Player B] > [Player A] THEN [Player B] ELSE [Player A] END) AS [Player B]
		, Score
	FROM dbo.Reciprocals
)

SELECT
	[Player A]
	, [Player B]
	, SUM(Score) AS Score
FROM correct_player_cte
GROUP BY [Player A], [Player B]