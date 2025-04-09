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
                    StyleExpr = StatusStyle; // Dynamically apply style based on status
                }
            }
            part(PaymentsListPart; "NVR Payment ListPart")
            {
                SubPageLink = "InvoiceID" = FIELD(InvoiceID); // Link payments to the current invoice
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
                end;
            }
            action(NewPayment)
            {
                Caption = 'New Payment';
                Image = Payment;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Payment Card");
                end;
            }
        }
    }

    var
        StatusStyle: Text;

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
        
    trigger OnAfterGetRecord()
    var
        PaymentRecord: Record "NVR Payments";
        TotalPayments: Decimal;
    begin
        // Calculate the total payments for the current invoice
        TotalPayments := 0;
        PaymentRecord.SetRange("InvoiceID", Rec.InvoiceID);
        if PaymentRecord.FindSet() then
            repeat
                TotalPayments += PaymentRecord."PaymentAmount";
            until PaymentRecord.Next() = 0;

        // Determine the status based on payments
        if TotalPayments = Rec.InvoiceAmount then
            Rec.Status := Enum::"NVR PaymentStatusEnum"::Paid
        else if TotalPayments = 0 then
            Rec.Status := Enum::"NVR PaymentStatusEnum"::NotPaid
        else
            Rec.Status := Enum::"NVR PaymentStatusEnum"::PartiallyPaid;

        // Apply styles based on status
        case Rec.Status of
            Enum::"NVR PaymentStatusEnum"::Paid:
                StatusStyle := 'Favorable'; // Green
            Enum::"NVR PaymentStatusEnum"::NotPaid:
                StatusStyle := 'Unfavorable'; // Red
            Enum::"NVR PaymentStatusEnum"::PartiallyPaid:
                StatusStyle := 'Attention'; // Yellow
            else
                StatusStyle := ''; // Default style
        end;
    end;
}
//we need to add a listpart where we can see all the payments made to the specific invoice selected on the List page.
//an invoice status is determined by if the payments correspond to the invoice amount due. So if the amount due is 6000 then the payments (one or more) need to equivilate to the amount due of 6000 in order to make the status paid. This will mean that the Invoice status must not be editable by the user.