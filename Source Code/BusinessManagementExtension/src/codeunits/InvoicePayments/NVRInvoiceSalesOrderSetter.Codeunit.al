codeunit 50104 "NVR InvoiceSalesOrderHandler"
{

    SingleInstance = true;
    var
        InvoiceRec: Record "NVR Invoices";
        StoredSalesOrderID: Code[20]; // Variable to store the SalesOrderID

    procedure SetInvoiceSalesOrderID(SalesOrderRecord: Record "NVR Sales Orders")
    begin
        // Store the SalesOrderID for later use
        StoredSalesOrderID := SalesOrderRecord."SalesOrderID";
        //Message('Sales Order ID Stored in Codeunit: %1', StoredSalesOrderID);
    end;

    procedure AddNewInvoice(): Record "NVR Invoices"
    var
        NewInvoice: Record "NVR Invoices";
    begin
        //Message('Sales Order for gen ID: %1', StoredSalesOrderID);
        if StoredSalesOrderID = '' then
            Error('No Sales Order ID is stored. Please set the Sales Order ID first.');

        // Initialize and create a new invoice
        NewInvoice.Init();
        NewInvoice."InvoiceID" := GenerateUniqueInvoiceID();
        NewInvoice."SalesOrderID" := StoredSalesOrderID;
        NewInvoice.Insert(true);

        Message('New Invoice Created: %1 for Sales Order ID: %2', NewInvoice."InvoiceID", StoredSalesOrderID);
        exit(NewInvoice);
    end;

    procedure DeleteInvoice(InvoiceID: Code[20])
    var
        InvoiceToDelete: Record "NVR Invoices";
    begin
        if InvoiceToDelete.Get(InvoiceID) then begin
            InvoiceToDelete.Delete();
            //Message('Invoice Deleted: %1', InvoiceID);
        end else
            Error('Invoice with ID %1 not found.', InvoiceID);
    end;

    procedure EditInvoice(InvoiceID: Code[20]; NewInvoiceAmount: Decimal)
    var
        InvoiceToEdit: Record "NVR Invoices";
    begin
        if InvoiceToEdit.Get(InvoiceID) then begin
            // Update the invoice details
            InvoiceToEdit."InvoiceAmount" := NewInvoiceAmount;
            InvoiceToEdit.Modify(true);

            Message('Invoice Updated: %1 with New Amount: %2', InvoiceID, Format(NewInvoiceAmount));
        end else
            Error('Invoice with ID %1 not found.', InvoiceID);
    end;

    procedure GenerateUniqueInvoiceID(): Code[20]
    var
        Counter: Integer;
        NewID: Code[20];
        TempInvoiceRecord: Record "NVR Invoices";
    begin
        Counter := 0;
        repeat
            Counter := Counter + 1;
            NewID := 'INV' + PadStr(Format(Counter), 17, '0'); // Prefix with "INV" and pad with zeros
        until not TempInvoiceRecord.Get(NewID);

        exit(NewID);
    end;

    procedure GetStoredSalesOrderID(): Code[20]
    begin
        exit(StoredSalesOrderID);
    end;
}