

/*
You are given the following tables that list the requirements for a space mission and a list of potential 
candidates. Write an SQL statement to determine which candidates meet the mission's requirements.

Candidates
Candidate ID |	Description
----------------------------
1001		 | Geologist
1001		 | Astrogator
1001		 | Biochemist
1001		 | Technician
2002		 | Surgeon
2002		 | Machinist
2002		 | Geologist
3003		 | Geologist
3003		 | Astrogator
4004		 | Selenologis

Requirements
Description
-----------
Geologist
Astrogator
Technician


Here is the expected output.
Candidate ID
-------------
1001

*/

-- Create Tables
CREATE TABLE dbo.Candidates (
	CandidateID int
	, [Description] nvarchar(20) 
)


CREATE TABLE dbo.Requirements(
	[Description] nvarchar(20)
)

-- Prepare Data
INSERT INTO dbo.Candidates 
VALUES 
	(1001, 'Geologist')
	, (1001, 'Astrogator')
	, (1001, 'Biochemist')
	, (1001, 'Technician')
	, (2002, 'Surgeon')
	, (2002, 'Machinist')
	, (2002, 'Geologist')
	, (3003, 'Geologist')
	, (3003, 'Astrogator')
	, (4004, 'Selenologis')

INSERT INTO dbo.Requirements
VALUES
	('Geologist')
	, ('Astrogator')
	, ('Technician')


-- Solution 1:

;WITH CountReqs AS (
	SELECT 
		COUNT([Description]) AS count_reqs
	FROM dbo.Requirements
)

SELECT DISTINCT
	CandidateID
FROM dbo.Candidates c
INNER JOIN dbo.Requirements r on r.Description = c.Description
GROUP BY CandidateID
HAVING COUNT(CandidateID) = (SELECT count_reqs FROM CountReqs)


-- Solution 2:
SELECT 
	CandidateID
FROM dbo.Candidates c
WHERE c.[Description] IN (SELECT [Description] FROM dbo.Requirements)
GROUP BY c.CandidateID
HAVING COUNT(c.CandidateID) = (SELECT COUNT([Description]) FROM dbo.Requirements)
