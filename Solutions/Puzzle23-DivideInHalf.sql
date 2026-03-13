USE AdvancedSQLPuzzles
GO

/*
	Puzzle 23: Divide in Half

	You work for a gaming company and need to rank players by their score into two categories. 
	Players that rank in the top half must be given a value of 1, and the remaining players must be given a 
	value of 2. 

	------------------
	Player ID |	Score
	------------------
	1001	  | 2343
	2002	  | 9432
	3003	  | 6548
	4004	  | 1054
	5005	  | 6832
	-----------------

	Here is the expected output

	-------------------------------
	Player ID |	Score	| Quartile
	-------------------------------
	1001	  | 2343	|	9432
	2002	  | 9432	|	6548
	3003	  | 6548	|	6832
	4004	  | 1054	|	2343
	5005	  | 6832	|	1054
	-------------------------------
*/


-- Create Table Structure
DROP TABLE IF EXISTS dbo.DivideInHalf

CREATE TABLE dbo.DivideInHalf (
	PlayerID INT
	, Score INT
);


-- Populate Table
INSERT INTO dbo.DivideInHalf VALUES
	(1001, 2343)
	, (2002, 9432)
	, (3003, 6548)
	, (4004, 1054)
	, (5005, 6832)

-- Check Data
SELECT * FROM dbo.DivideInHalf;


-- Solution

WITH PlayerHalfCTE AS (
	SELECT 
		ROUND(CAST(COUNT(PlayerID)/2.0 AS DECIMAL), 2) AS PlayerHalf
	FROM  dbo.DivideInHalf
), 

PlayerRankCTE AS (
	SELECT 
		PlayerID
		, Score
		, (RANK() OVER( PARTITION BY (NULL) ORDER BY Score DESC)) AS PlayerRank 
	FROM dbo.DivideInHalf
)

SELECT 
	PlayerID
	, Score
	, (CASE 
		WHEN PlayerRank <= (SELECT MIN(PlayerHalf) FROM PlayerHalfCTE) THEN 1 ELSE 2
	  END) AS Quartile
FROM PlayerRankCTE


	