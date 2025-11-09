USE AdvancedSQLPuzzles
GO
/*

Puzzle 22: Occurrences

Write an SQL statement that returns all distinct process log messages
and the workflow where the message occurred most often

===================================================================
Workflow	|	Message								|	Occurences
===================================================================
Bravo		|	Error: Cannot Divide by 0			|	3
Alpha		|	Error: Conversion Failed			|	5
Charlie		|	Error: Conversion Failed			|	7
Alpha		|	Error: Unidentified error occurred	|	9
Bravo		|	Error: Unidentified error occurred  |	1
Charlie		|	Error: Unidentified error occurred	|	10
Alpha		|	Status Complete						|	8
Charlie		|	Status Complete						|	6
===================================================================


Expected Output
===================================================================
Workflow	|	Message								|	Occurences
===================================================================
Bravo		|	Error: Cannot Divide by 0			|	3
Charlie		|	Error: Conversion Failed			|	7
Charlie		|	Error: Unidentified error occurred	|	10
Alpha		|	Status Complete						|	8
===================================================================


*/

DROP TABLE IF EXISTS dbo.Occurrences;

CREATE TABLE dbo.Occurrences (
	Workflow VARCHAR(10)
	, [Message] VARCHAR(50)
	, Occurences TINYINT
)

INSERT INTO dbo.Occurrences VALUES
	('Bravo', 'Error: Cannot Divide by 0', '3')
	, ('Alpha', 'Error: Conversion Failed', '5')
	, ('Charlie', 'Error: Conversion Failed', '7')
	, ('Alpha', 'Error: Unidentified error occurred', '9')
	, ('Bravo', 'Error: Unidentified error occurred', '1')
	, ('Charlie', 'Error: Unidentified error occurred', '10')
	, ('Alpha', 'Status Complete', '8')
	, ('Charlie', 'Status Complete', '6')

-- Check Data

SELECT * FROM dbo.Occurrences;

-- Solution 

WITH RankCTE AS (
	SELECT
		Workflow
		, [Message]
		, Occurences
		, RANK() OVER(PARTITION BY Message ORDER BY Occurences DESC) AS RankOccurrences
	FROM dbo.Occurrences
)

SELECT
	Workflow
	, [Message]
	, Occurences
FROM RankCTE
	WHERE RankOccurrences = 1