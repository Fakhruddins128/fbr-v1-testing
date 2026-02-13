IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Invoices]') AND name = 'FBRInvoiceNumber')
BEGIN
    ALTER TABLE Invoices ADD FBRInvoiceNumber NVARCHAR(50) NULL;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Invoices]') AND name = 'FBRResponseStatus')
BEGIN
    ALTER TABLE Invoices ADD FBRResponseStatus NVARCHAR(50) NULL;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Invoices]') AND name = 'FBRResponseMessage')
BEGIN
    ALTER TABLE Invoices ADD FBRResponseMessage NVARCHAR(MAX) NULL;
END
