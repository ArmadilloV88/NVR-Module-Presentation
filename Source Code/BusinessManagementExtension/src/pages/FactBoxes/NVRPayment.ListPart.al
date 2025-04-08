page 50117 "NVR Payment ListPart"
{
    PageType = ListPart;
    SourceTable = "NVR Payments";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Payments)
            {
                field("Payment ID"; Rec.PaymentID)
                {
                    Caption = 'Payment ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice ID"; Rec.InvoiceID)
                {
                    Caption = 'Invoice ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    Caption = 'Payment Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Method"; Rec.PaymentMethod)
                {
                    Caption = 'Payment Method';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Amount"; Rec.PaymentAmount)
                {
                    Caption = 'Payment Amount';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(AddPayment)
            {
                Caption = 'Add Payment';
                Image = Add;
                ApplicationArea = All;
                trigger OnAction()
                var
                    NewPayment: Record "NVR Payments";
                    InvoiceRecord: Record "NVR Invoices";
                    InvoiceID: Code[20];
                    NewPaymentID: Code[20];
                    Counter: Integer;
                begin
                    // Debug the Invoice ID
                    InvoiceID := Rec.InvoiceID;
                    Message('Invoice ID in AddPayment: %1', InvoiceID);

                    // Validate the Invoice ID
                    if InvoiceID = '' then
                        Error('Please select a valid Invoice ID before adding a payment.');

                    // Check if the invoice exists and its status
                    if InvoiceRecord.Get(InvoiceID) then begin
                        if InvoiceRecord.Status = Enum::"NVR PaymentStatusEnum"::Paid then begin
                            Message('The invoice is already fully paid. No additional payments are required.');
                            exit; // Exit the action as no payment is needed
                        end;
                    end else begin
                        Error('The selected Invoice ID does not exist.');
                    end;

                    // Generate a unique Payment ID
                    Counter := 0;
                    repeat
                        Counter += 1;
                        NewPaymentID := 'PAY' + PadStr(Format(Counter), 17, '0'); // Prefix with "PAY" and pad with zeros
                    until not NewPayment.Get(NewPaymentID);

                    // Initialize a new temporary payment record
                    NewPayment.Init();
                    NewPayment.PaymentID := NewPaymentID; // Assign the unique Payment ID
                    NewPayment.InvoiceID := InvoiceID; // Link the payment to the invoice

                    // Insert the new payment record into the database
                    NewPayment.Insert(true);

                    // Commit the transaction to allow Page.RunModal
                    Commit();

                    // Open the Payment Card page for the new payment
                    Page.RunModal(Page::"NVR Payment Card", NewPayment);

                    // Update the remaining amount and status of the associated invoice
                    UpdateRemainingAmountToBePaid(InvoiceID);
                end;
            }
            action(EditPayment)
            {
                Caption = 'Edit Payment';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceID: Code[20];
                begin
                    InvoiceID := Rec.InvoiceID;

                    // Open the Payment Card page to edit the selected payment
                    Page.RunModal(Page::"NVR Payment Card", Rec);

                    // Update the remaining amount and status of the associated invoice
                    if InvoiceID <> '' then
                        UpdateRemainingAmountToBePaid(InvoiceID);
                end;
            }
            action(DeletePayment)
            {
                Caption = 'Delete Payment';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceID: Code[20];
                begin
                    InvoiceID := Rec.InvoiceID;

                    // Delete the selected payment
                    if Rec.Delete() then begin
                        Message('Payment deleted successfully!');

                        // Update the remaining amount and status of the associated invoice
                        if InvoiceID <> '' then
                            UpdateRemainingAmountToBePaid(InvoiceID);
                    end else begin
                        Error('Failed to delete payment.');
                    end;
                end;
            }
        }
    }

    procedure UpdateRemainingAmountToBePaid(InvoiceID: Code[20])
    var
        InvoiceRecord: Record "NVR Invoices";
        PaymentRecord: Record "NVR Payments";
        TotalPayments: Decimal;
    begin
        // Initialize the total payments
        TotalPayments := 0;

        // Retrieve the invoice record
        if InvoiceRecord.Get(InvoiceID) then begin
            // Sum all payments made to the invoice
            PaymentRecord.SetRange("InvoiceID", InvoiceID);
            if PaymentRecord.FindSet() then
                repeat
                    TotalPayments += PaymentRecord."PaymentAmount";
                until PaymentRecord.Next() = 0;

            // Calculate the remaining amount to be paid
            InvoiceRecord."RemAmtToBePaidToInvoice" := InvoiceRecord."InvoiceAmount" - TotalPayments;

            // Ensure the remaining amount is not negative
            if InvoiceRecord."RemAmtToBePaidToInvoice" < 0 then
                InvoiceRecord."RemAmtToBePaidToInvoice" := 0;

            // Update the invoice status based on the remaining amount
            if InvoiceRecord."RemAmtToBePaidToInvoice" = 0 then
                InvoiceRecord.Status := Enum::"NVR PaymentStatusEnum"::Paid
            else if TotalPayments = 0 then
                InvoiceRecord.Status := Enum::"NVR PaymentStatusEnum"::NotPaid
            else
                InvoiceRecord.Status := Enum::"NVR PaymentStatusEnum"::PartiallyPaid;

            // Save the changes to the invoice
            InvoiceRecord.Modify();
        end;
    end;
    trigger OnOpenPage()
    begin
        Message('Invoice ID in Payment ListPart: %1', Rec.InvoiceID);
    end;
}