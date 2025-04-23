page 50103 "NVR Payment List"
{
    ModifyAllowed = false;
    InsertAllowed = true;
    DeleteAllowed = false;
    ApplicationArea = All;
    Caption = 'Payment List';
    PageType = List;
    SourceTable = "NVR Payments";

    layout
    {
        area(content)
        {
            repeater(Payments)
            {
                field("NVR Payment ID"; Rec.PaymentID)
                {
                    Caption = 'Payment ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Invoice ID"; Rec.InvoiceID)
                {
                    Caption = 'Invoice ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Payment Date"; rec."Payment Date")
                {
                    Caption = 'Payment Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Payment Method"; Rec.PaymentMethod)
                {
                    Caption = 'Payment Method';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Payment Amount"; Rec.PaymentAmount)
                {
                    Caption = 'Payment Amount';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
    actions{
        area(Processing)
        {
            action(DeletePayment)
            {
                ApplicationArea = All;
                Caption = 'Delete Payment';
                Image = Delete;
                trigger OnAction()
                var
                    RecRef: RecordRef;
                    FieldRef: FieldRef;
                begin
                    UpdateInvoiceAmountAndStatus();
                    RecRef.GetTable(Rec);
                    RecRef.Delete(true);
                    Message('Payment Deleted');
                end;
            }
        }
    }
    procedure UpdateInvoiceAmountAndStatus()
    var
        InvoiceRec: Record "NVR Invoices";
    begin
        // Validate if the Invoice ID is provided
        if Rec.InvoiceID = '' then
            Error('Error: No Invoice ID is provided. Please select a valid Invoice.');

        // Check if the Invoice exists
        if not InvoiceRec.Get(Rec.InvoiceID) then
            Error('Error: Invoice with ID %1 not found.', Rec.InvoiceID);

        // Update the Amount Paid
        InvoiceRec.AmountPaid := InvoiceRec.AmountPaid - Rec.PaymentAmount;

        // Recalculate the Remaining Amount to be Paid
        InvoiceRec."RemAmtToBePaidToInvoice" := InvoiceRec."InvoiceAmount" - InvoiceRec.AmountPaid;

        // Update the Invoice Status and Style based on the remaining amount
        if InvoiceRec."RemAmtToBePaidToInvoice" = 0 then begin
            InvoiceRec.Status := InvoiceRec.Status::Paid;
            InvoiceRec.StatusStyle := 'Favorable'; // Green for Paid
        end else if InvoiceRec."RemAmtToBePaidToInvoice" = InvoiceRec."InvoiceAmount" then begin
            InvoiceRec.Status := InvoiceRec.Status::NotPaid;
            InvoiceRec.StatusStyle := 'Unfavorable'; // Red for Not Paid
        end else begin
            InvoiceRec.Status := InvoiceRec.Status::PartiallyPaid;
            InvoiceRec.StatusStyle := 'Attention'; // Orange for Partially Paid
        end;

        // Save the changes to the Invoice record
        InvoiceRec.Modify(true);

        // Display a confirmation message
        Message('Invoice %1 updated successfully. Remaining Amount: %2, Status: %3',
            InvoiceRec.InvoiceID, Format(InvoiceRec."RemAmtToBePaidToInvoice"), InvoiceRec.Status);
    end;
}
