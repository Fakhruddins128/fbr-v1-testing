-- Migration: Add InitialStock to Items table and fix InvoiceItems and PurchaseItems tables

USE FBR_SaaS;
GO

-- 1. Add InitialStock to Items table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Items') AND name = 'InitialStock')
BEGIN
    ALTER TABLE Items ADD InitialStock DECIMAL(18, 2) DEFAULT 0;
    PRINT 'InitialStock added to Items table.';
END
GO

-- 2. Add CurrentStock to Items table (for caching, but will be updated by triggers or application logic)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Items') AND name = 'CurrentStock')
BEGIN
    ALTER TABLE Items ADD CurrentStock DECIMAL(18, 2) DEFAULT 0;
    PRINT 'CurrentStock added to Items table.';
END
GO

-- 3. Fix InvoiceItems table: Add a proper ItemRefID (Foreign Key to Items)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('InvoiceItems') AND name = 'ItemRefID')
BEGIN
    ALTER TABLE InvoiceItems ADD ItemRefID UNIQUEIDENTIFIER NULL;
    ALTER TABLE InvoiceItems ADD CONSTRAINT FK_InvoiceItems_Items FOREIGN KEY (ItemRefID) REFERENCES Items(ItemID);
    PRINT 'ItemRefID added to InvoiceItems table.';
END
GO

-- 4. Fix PurchaseItems table: Add a proper ItemRefID (Foreign Key to Items)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseItems') AND name = 'ItemRefID')
BEGIN
    ALTER TABLE PurchaseItems ADD ItemRefID UNIQUEIDENTIFIER NULL;
    ALTER TABLE PurchaseItems ADD CONSTRAINT FK_PurchaseItems_Items FOREIGN KEY (ItemRefID) REFERENCES Items(ItemID);
    PRINT 'ItemRefID added to PurchaseItems table.';
END
GO

-- 5. Initialize CurrentStock for existing items
UPDATE Items SET CurrentStock = InitialStock;
GO

PRINT 'Migration completed successfully.';
GO
