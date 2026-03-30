USE AdvancedSQLPuzzles
GO

/*
	Puzzle 25: Top Vendors
	Return the vendor from which each customer has placed the most orders

	Expected Output: 

	--------------------------
	Customer ID |  Vendor
	--------------------------
	1001		| Direct Parts
	2002		| ACME
	--------------------------
*/


-- Create Table
DROP TABLE IF EXISTS dbo.TopVendors

CREATE TABLE dbo.TopVendors (
	[Order ID] int
	, [Customer ID] int
	, [Count] int
	, [Vendor] nvarchar(25)
);


-- Populate Table
INSERT INTO dbo.TopVendors VALUES 
	(1, 1001, 12, 'Direct Parts')
	, (2, 1001, 54, 'Direct Parts')
	, (3, 1001, 32, 'ACME')
	, (4, 2002, 7, 'ACME')
	, (5, 2002, 16, 'ACME')
	, (6, 2002, 5, 'Direct Parts');


-- Check Data
SELECT TOP(10) * FROM dbo.TopVendors