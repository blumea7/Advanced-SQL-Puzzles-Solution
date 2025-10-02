USE AdvancedSQLPuzzles;

/*
	Puzzle 12: Average Days 

	Determine the average number of days between executions for each workflow

	Workflow	|	Execution Date
	=====================================
	Alpha		|	6/1/2018
	Alpha		|	6/14/2018
	Alpha		|	6/15/2018
	Bravo		|	6/1/2018
	Bravo		|	6/2/2018
	Bravo		|	6/19/2018
	Charlie		|	6/1/2018
	Charlie		|	6/15/2018
	Charlie		|	6/30/2018


*/
-- Prepare Data

DROP TABLE IF EXISTS dbo.Workflows;

CREATE TABLE dbo.Workflows (
	Workflow VARCHAR(20)
	, [Execution Date] DATE
)

INSERT INTO dbo.Workflows VALUES
	('Alpha', '6/1/2018')
	, ('Alpha', '6/14/2018')
	, ('Alpha', '6/15/2018')
	, ('Bravo', '6/1/2018')
	, ('Bravo', '6/2/2018')
	, ('Bravo', '6/19/2018')
	, ('Charlie', '6/1/2018')
	, ('Charlie', '6/15/2018')
	, ('Charlie', '6/30/2018');


WITH prev_date_cte AS (
SELECT
	*
	, LAG([Execution Date], 1) OVER(PARTITION BY Workflow ORDER BY [Execution Date]) AS prev_exec_date
FROM dbo.Workflows
), 

date_diff_cte AS (
	SELECT 
		Workflow
		, DATEDIFF(DAY, prev_exec_date, [Execution Date]) AS Diff
	FROM prev_date_cte
)

SELECT 
	Workflow
	, AVG(Diff) AS [Ave. Execution Date Diff]
FROM date_diff_cte
GROUP BY Workflow