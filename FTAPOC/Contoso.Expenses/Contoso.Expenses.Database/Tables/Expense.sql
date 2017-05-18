CREATE TABLE [dbo].[Expense]
(
	[ExpenseId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [Purpose] NVARCHAR(256) NULL, 
    [Date] DATETIME NULL, 
    [Cost Center] NVARCHAR(20) NULL, 
    [Amount] FLOAT NULL, 
    [Approver] NVARCHAR(50) NULL, 
    [Receipt] NVARCHAR(256) NULL
)
