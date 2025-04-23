page 50102 "NVR Invoice List"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Caption = 'Invoice List';
    PageType = List;
    SourceTable = "NVR Invoices";

    layout
    {
        area(content)
        {
            repeater(Invoices)
            {
                field("NVR Invoice ID"; Rec.InvoiceID)
                {
                    Caption = 'Invoice ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Invoice Date"; Rec.InvoiceDate)
                {
                    Caption = 'Invoice Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Due Date"; Rec.DueDate)
                {
                    Caption = 'Due Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Invoice Amount Due"; Rec.InvoiceAmount)
                {
                    Caption = 'Invoice Amount Due';
                    ApplicationArea = All;
                    Editable = true;
                }
                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                    //doesnt display correctly
                }
                Field("NVR Amount Paid"; Rec.AmountPaid)
                {
                    Caption = 'Amount Paid';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("NVR Status"; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    Editable = false; // Status is non-editable
                    StyleExpr = Rec.StatusStyle; // Bind to the StatusStyle field in the table
                }
            }
            part(PaymentsListPart; "NVR Payment ListPart")
            {
                SubPageLink = "InvoiceID" = FIELD(InvoiceID); // Automatically filter payments by the selected invoice
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditInvoice)
            {
                Caption = 'Edit Invoice';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceHandler: Codeunit "NVR InvoiceSalesOrderHandler";
                begin
                    if Rec.InvoiceID = '' then
                        Error('No Invoice is selected. Please select an invoice to edit.');

                    
                    Page.RunModal(Page::"NVR Invoice Document", Rec);

                    // Update the invoice status and remaining amount after editing
                    UpdateInvoiceStatusAndRemainingAmount(Rec.InvoiceID);

                    Message('Invoice %1 has been updated successfully.', Rec.InvoiceID);
                end;
            }
            action(DeleteInvoice)
            {
                Caption = 'Delete Invoice';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceHandler: Codeunit "NVR InvoiceSalesOrderHandler";
                begin
                    if Rec.InvoiceID = '' then
                        Error('No Invoice is selected. Please select an invoice to delete.');

                    if Confirm('Are you sure you want to delete this invoice?', false) then begin
                        // Delete the invoice using the Codeunit
                        InvoiceHandler.DeleteInvoice(Rec.InvoiceID);

                        CurrPage.Update(); // Refresh the page to reflect the changes
                        Message('Invoice %1 has been deleted successfully.', Rec.InvoiceID);
                    end;
                end;
            }
            action(ViewPayments)
            {
                Caption = 'View Payments';
                Image = List;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Payment List");
                end;
            }//might get removed
        }
        area(Creation)
        {
            action(NewInvoice)
            {
                Caption = 'New Invoice';
                Image = Invoice;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceHandler: Codeunit "NVR InvoiceSalesOrderHandler";
                    ValidationHandler: Codeunit "NVR InvoiceHandler";
                    Handler: Codeunit "NVR InvoiceSalesOrderHandler";
                    
                    NewInvoice: Record "NVR Invoices";
                begin
                    if Handler.GetStoredSalesOrderID() <> '' then begin
                        if ValidationHandler.CalcRemainingAmount(Handler.GetStoredSalesOrderID()) = 0 then 
                        begin
                            Error('Error : Unable to add a new invoice to this sales order as the sales order is fully invoiced');
                            exit;
                            
                        end;
                    end;

                    // Add a new invoice using the Codeunit
                    NewInvoice := InvoiceHandler.AddNewInvoice();
                    //Message('New Invoice Created: %1 SalesOrderID : %2' , NewInvoice.InvoiceID, NewInvoice.SalesOrderID);
                    
                    Commit(); // Commit the changes to the database

                    // Open the Invoice Document page with the new Invoice ID
                    Page.RunModal(Page::"NVR Invoice Document", NewInvoice);

                    // Update the invoice status and remaining amount after creating a new invoice
                    UpdateInvoiceStatusAndRemainingAmount(NewInvoice.InvoiceID);

                    //Message('New Invoice %1 has been created successfully.', NewInvoice.InvoiceID);
                end;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetCurrRecord()
    var
        PaymentsListPartPage: Page "NVR Payment ListPart";
        InvoiceHandler: Codeunit "NVR InvoiceHandler";
    begin
        InvoiceHandler.SetSalesOrderID(Rec.SalesOrderID);
        // Pass the current record to the Payment ListPart
        CurrPage.PaymentsListPart.PAGE.SetSelectedInvoice(Rec);
        UpdateTheAmountPaid();

    end;

    trigger OnOpenPage()
    var
        Handler: Codeunit "NVR InvoiceSalesOrderHandler";
        Invoices: Record "NVR Invoices";
        SalesOrderID: Code[20];
    begin
        // Retrieve the SalesOrderID using the GetSalesOrderID procedure
        SalesOrderID := Handler.GetStoredSalesOrderID();
        //Message('Sales Order ID Retrieved: %1', SalesOrderID);

        // Apply a filter to only show invoices with the retrieved SalesOrderID
        if SalesOrderID <> '' then
            Rec.SetRange("SalesOrderID", SalesOrderID);
    end;

    procedure UpdateTheAmountPaid()
    var
        InvoiceHandler: Codeunit "NVR InvoiceSalesOrderHandler";
        UpdatedAmountPaid: Decimal;
        Invoices: Record "NVR Invoices";
    begin
        // Check if an invoice is selected
        if Rec.InvoiceID = '' then
            exit; // Exit the procedure if no invoice is selected

        if Invoices.Get(Rec.InvoiceID) then begin
            // Update the invoice amount paid using the Codeunit
            UpdatedAmountPaid := InvoiceHandler.UpdateInvoiceAmountPaid(Rec.InvoiceID);
            Rec.AmountPaid := UpdatedAmountPaid;
            Rec.Modify(true); // Save the changes to the record
        end else
            Error('Invoice with ID %1 not found.', Rec.InvoiceID);
    end;
    procedure UpdateInvoiceStatusAndRemainingAmount(InvoiceID: Code[20])
    var
        InvoiceRecord: Record "NVR Invoices";
        PaymentRecord: Record "NVR Payments";
        TotalPayments: Decimal;
        RemainingAmount: Decimal;
        Tolerance: Decimal;
    begin
        // Initialize the total payments and tolerance
        TotalPayments := 0;
        Tolerance := 0.01; // Allow for small rounding differences

        // Retrieve the invoice record
        if InvoiceRecord.Get(InvoiceID) then begin
            // Sum all payments made to the invoice
            PaymentRecord.SetRange("InvoiceID", InvoiceID);
            if PaymentRecord.FindSet() then
                repeat
                    TotalPayments += PaymentRecord."PaymentAmount";
                until PaymentRecord.Next() = 0;

            // Dynamically calculate the remaining amount
            RemainingAmount := InvoiceRecord."InvoiceAmount" - TotalPayments;

            // Ensure the remaining amount is not negative
            if RemainingAmount < 0 then
                RemainingAmount := 0;

            // Update the invoice status based on the remaining amount
            if RemainingAmount <= Tolerance then begin
                InvoiceRecord.Status := Enum::"NVR PaymentStatusEnum"::Paid;
                InvoiceRecord.StatusStyle := 'Favorable'; // Green for Paid
            end else if TotalPayments = 0 then begin
                InvoiceRecord.Status := Enum::"NVR PaymentStatusEnum"::NotPaid;
                InvoiceRecord.StatusStyle := 'UnFavorable'; // Red for Not Paid
            end else begin
                InvoiceRecord.Status := Enum::"NVR PaymentStatusEnum"::PartiallyPaid;
                InvoiceRecord.StatusStyle := 'Attention'; // Orange for Partially Paid
            end;

            // Save the updated invoice record
            InvoiceRecord.Modify();
        end;
    end;
}
//we need to add a listpart where we can see all the payments made to the specific invoice selected on the List page.
//an invoice status is determined by if the payments correspond to the invoice amount due. So if the amount due is 6000 then the payments (one or more) need to equivilate to the amount due of 6000 in order to make the status paid. This will mean that the Invoice status must not be editable by the user.