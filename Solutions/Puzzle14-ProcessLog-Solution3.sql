USE AdvancedSQLPuzzles
GO

/*

Your process log has several workflows broken down step by step numbers w/ the possible
status values of Complete, Running, or Error

Create an overall status based on the ff: requirements:

	- If all steps of a workflow are of same status, return that distinct status
	- If any step has an Error along with Complete or Running, declare overall status as Indeterminate
	- If steps have a combination of Complete and Running (w/o Errors), return Running.


Workflow with Steps Data: 

===========================================
Workflow	|	Step Number	|	Status
===========================================
Alpha		|		1		|	Error
Alpha		|		1		|	Complete
Alpha		|		1		|	Running
Bravo		|		1		|	Complete
Bravo		|		2		|	Complete
Charlie		|		1		|	Running
Charlie		|		1		|	Running
Delta		|		1		|	Error
Delta		|		2		|	Error
Echo		|		1		|	Running
Echo		|		2		|	Complete
===========================================

Expected Output

===============================
Workflow	|	Status
===============================
Alpha		|	Indeterminate
Branvo		|	Complete
Charlie		|	Running
Delta		|	Error
Echo		|	Running


*/

-- Prepare Data

DROP TABLE IF EXISTS dbo.ProcessLog;

CREATE TABLE dbo.ProcessLog (
	Workflow VARCHAR(10)
	, [Step Number] INTEGER
	, [Status] VARCHAR(10)
);

INSERT INTO dbo.ProcessLog VALUES 
	('Alpha', 1, 'Error')
	, ('Alpha', 2, 'Complete')
	, ('Alpha', 3, 'Running')
	, ('Bravo', 1, 'Complete')
	, ('Bravo', 2, 'Complete')
	, ('Charlie', 1, 'Running')
	, ('Charlie', 2, 'Running')
	, ('Delta', 1, 'Error')
	, ('Delta', 2, 'Error')
	, ('Echo', 1, 'Running')
	, ('Echo', 2, 'Complete');

-- Check Data

SELECT * FROM dbo.ProcessLog;


WITH distinct_CTE AS (
	SELECT DISTINCT
		Workflow
		, [Status]
	FROM dbo.ProcessLog
),

all_status_CTE AS(
	SELECT 
		Workflow
		, STRING_AGG([Status], ',') AS All_Status
		, COUNT(DISTINCT [Status]) AS distinct_count
	FROM distinct_CTE
	GROUP BY Workflow
)

SELECT 
	Workflow
	, (CASE 
		WHEN distinct_count = 1 THEN [All_Status] 
		WHEN [All_Status] LIKE '%Error%' AND [All_Status] LIKE '%Running%' AND [All_Status] LIKE '%Complete%' THEN 'Indeterminate'
		WHEN [All_Status] LIKE '%Running%' AND [All_Status] LIKE '%Complete%' THEN 'Running'
	  END) AS [Status]
FROM all_status_CTE