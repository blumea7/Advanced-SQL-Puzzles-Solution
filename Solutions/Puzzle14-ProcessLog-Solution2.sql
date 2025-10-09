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

-- Solution 


WITH status_cte AS (
	SELECT 
		Workflow
		, MAX(CASE WHEN [Status] = 'Error'THEN 'Error' END) AS [Error]
		, MAX(CASE WHEN [Status] = 'Complete'THEN 'Complete' END) AS [Complete]
		, MAX(CASE WHEN [Status] = 'Running'THEN 'Running' END) AS [Running]
	FROM dbo.ProcessLog
	GROUP BY Workflow
),

concatenated_cte AS (
	SELECT
		Workflow
		, CONCAT([Error], [Complete], [Running]) AS All_Status
	FROM status_cte
)

SELECT 
	Workflow
	, (CASE 
		  WHEN CHARINDEX('Error', All_Status) > 0 AND CHARINDEX('Running', All_Status) > 0 AND CHARINDEX('Running', All_Status) > 0 THEN 'Indeterminate' 
		  WHEN CHARINDEX('Running', All_Status) > 0 AND CHARINDEX('Complete', All_Status) > 0 THEN 'Running'
		  ELSE All_Status
	   END) AS [Status]
FROM concatenated_cte