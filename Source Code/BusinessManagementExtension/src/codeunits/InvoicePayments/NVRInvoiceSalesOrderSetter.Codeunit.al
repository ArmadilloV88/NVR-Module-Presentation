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
        // Initialize and create a new invoice
        NewInvoice.Init();
        NewInvoice."InvoiceID" := GenerateUniqueInvoiceID();
        Message('New Invoice ID: %1', NewInvoice."InvoiceID");
        NewInvoice."SalesOrderID" := StoredSalesOrderID;

        // Insert the new invoice into the database
        NewInvoice.Insert(true);

        // Return the newly created invoice
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

            //Message('Invoice Updated: %1 with New Amount: %2', InvoiceID, Format(NewInvoiceAmount));
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
        until not TempInvoiceRecord.Get(NewID); // Ensure the ID does not already exist

        exit(NewID);
    end;

    procedure UpdateInvoiceAmountPaid(InvoiceID: Code[20]) : Decimal
    var
        InvoiceToUpdate: Record "NVR Invoices";
        PaymentRecord: Record "NVR Payments";
        TotalPayments: Decimal;
    begin
        if InvoiceToUpdate.Get(InvoiceID) then begin
            // Initialize total payments
            TotalPayments := 0;

            // Sum all payments made to the invoice
            PaymentRecord.SetRange("InvoiceID", InvoiceID);
            if PaymentRecord.FindSet() then
                repeat
                    TotalPayments += PaymentRecord."PaymentAmount";
                until PaymentRecord.Next() = 0;

            exit(TotalPayments);

            //Message('Invoice Amount Paid Updated: %1', Format(TotalPayments));
        end else
            Error('Invoice with ID %1 not found.', InvoiceID);

    end;

    procedure GetStoredSalesOrderID(): Code[20]
    begin
        exit(StoredSalesOrderID);
    end;
}