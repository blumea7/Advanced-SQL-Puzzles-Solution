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
SELECT * FROM dbo.SeatingChart


-- Solution 

--Create Helper Table containing Complete Seat Numbers

DROP TABLE IF EXISTS dbo.CompleteSeats

CREATE TABLE dbo.CompleteSeats(
	SeatNumber INTEGER
);

WITH complete_seats_cte AS (
	
		SELECT 
			ROW_NUMBER() OVER(ORDER BY a.SeatNumber) as CompleteSeats
		FROM dbo.SeatingChart a CROSS JOIN dbo.SeatingChart b
	
	)

INSERT INTO dbo.CompleteSeats 
	SELECT CompleteSeats
	FROM complete_seats_cte
	WHERE CompleteSeats <= (SELECT MAX(SeatNumber) FROM dbo.SeatingChart)



-- Solve Gap Start and Gap Seat 


SELECT 
	SeatList = a.SeatNumber
	, b.SeatNumber
FROM dbo.CompleteSeats a LEFT JOIN dbo.SeatingChart b ON a.SeatNumber = b.SeatNumber