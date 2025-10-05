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

WITH recursive_cte AS (
	SELECT 
		Workflow
		, [Step Number]
		, CAST([Status] AS VARCHAR(MAX)) AS [Status]
	
	FROM dbo.ProcessLog
	WHERE [Step Number] = 1

	UNION ALL

	SELECT 
		a.Workflow
		, b.[Step Number] 
		, CAST((CASE WHEN 
				a.[Status] = b.[Status] THEN b.[Status]
				ELSE CONCAT(a.[Status], ', ', b.[Status]) 
				END
		   ) AS VARCHAR(MAX)) AS [Status]
	FROM recursive_cte a INNER JOIN dbo.ProcessLog b ON a.[Step Number] + 1 = b.[Step Number] AND a.[Workflow] = b.[Workflow]
),

max_steps_cte AS (
	SELECT
		Workflow
		, [Step Number]
		, [Status]
		, MAX([Step Number]) OVER (PARTITION BY Workflow) AS max_steps
	FROM recursive_cte
)


SELECT 
	Workflow
	, (CASE 
		WHEN CHARINDEX('Error', [Status], 0) > 0 AND (CHARINDEX('Complete', [Status], 0) > 0 OR CHARINDEX('Running', [Status], 0) > 0) THEN 'Indeterminate'
		WHEN CHARINDEX('Error', [Status], 0) = 0 AND CHARINDEX('Complete', [Status], 0) > 0 AND CHARINDEX('Running', [Status], 0) > 0 THEN 'Running'
		ELSE [Status]
		END) AS [Status]
FROM max_steps_cte
WHERE [Step Number] = max_steps