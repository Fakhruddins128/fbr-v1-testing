IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Invoices]') AND name = 'PONumber')
BEGIN
    ALTER TABLE Invoices ADD PONumber NVARCHAR(50) NULL;
END

