page 50102 "NVR Invoice List"
{
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
                begin
                    Page.RunModal(Page::"NVR Invoice Document", Rec);

                    // Update the invoice status and remaining amount after editing
                    UpdateInvoiceStatusAndRemainingAmount(Rec.InvoiceID);
                end;
            }
            action(DeleteInvoice)
            {
                Caption = 'Delete Invoice';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to delete this invoice?', false) then begin
                        Rec.Delete(); // Delete the record
                        Commit(); // Commit the transaction to ensure the record is fully removed
                        CurrPage.Update(); // Refresh the page to reflect the changes
                        Message('Invoice deleted successfully!');
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
            }
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
                    InvoiceRecord: Record "NVR Invoices";
                    NewInvoiceID: Code[20];
                begin
                    // Generate a unique Invoice ID
                    NewInvoiceID := GenerateUniqueInvoiceID();

                    // Initialize the record with the generated Invoice ID
                    InvoiceRecord.Init();
                    InvoiceRecord."InvoiceID" := NewInvoiceID;
                    InvoiceRecord.Insert(true); // Save the record to the database

                    // Commit the transaction to ensure the record is saved
                    Commit();

                    // Open the Invoice Document page with the new Invoice ID
                    Page.RunModal(Page::"NVR Invoice Document", InvoiceRecord);

                    // Update the invoice status and remaining amount after creating a new invoice
                    UpdateInvoiceStatusAndRemainingAmount(InvoiceRecord.InvoiceID);
                end;
            }
        }
    }

    var
        StatusStyle: Text;
        SelectedInvoice: Record "NVR Invoices"; // Variable to store the currently selected invoice

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

    trigger OnAfterGetCurrRecord()
    var
        PaymentsListPartPage: Page "NVR Payment ListPart";
    begin
        // Assign the current record to SelectedInvoice
        SelectedInvoice := Rec;

        // Debugging messages to verify the assignment
        //Message('Current Record Invoice ID: %1', Rec.InvoiceID); // Debugging message
        //Message('Selected Invoice ID in Invoice List Page: %1', SelectedInvoice.InvoiceID); // Debugging message

        // Pass the SelectedInvoice to the Payment ListPart
        CurrPage.PaymentsListPart.PAGE.SetSelectedInvoice(SelectedInvoice);
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