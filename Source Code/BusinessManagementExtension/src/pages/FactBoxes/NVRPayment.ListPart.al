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
                field("Remaining Amount"; GetRemainingAmount())
                {
                    Caption = 'Remaining Amount';
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
                    NewPaymentID: Code[20];
                    Counter: Integer;
                begin
                    // Validate the Selected Invoice
                    if SelectedInvoice.IsEmpty() then
                        Error('Please select a valid Invoice before adding a payment.');

                    // Check if the invoice is fully paid
                    if SelectedInvoice.Status = Enum::"NVR PaymentStatusEnum"::Paid then
                        Error('The selected invoice is already fully paid. No additional payments can be added.');

                    // Generate a unique Payment ID
                    Counter := 0;
                    repeat
                        Counter += 1;
                        NewPaymentID := 'PAY' + PadStr(Format(Counter), 17, '0'); // Prefix with "PAY" and pad with zeros
                    until not NewPayment.Get(NewPaymentID);

                    // Initialize a new payment record
                    NewPayment.Init();
                    NewPayment.PaymentID := NewPaymentID;
                    NewPayment.InvoiceID := SelectedInvoice.InvoiceID;

                    // Insert the new payment record into the database
                    NewPayment.Insert(true);

                    // Commit the transaction to allow Page.RunModal
                    Commit();

                    // Open the Payment Card page for the new payment
                    Page.RunModal(Page::"NVR Payment Card", NewPayment);

                    // Dynamically update the remaining amount of the associated invoice
                    UpdateRemainingAmountToBePaid(SelectedInvoice.InvoiceID);

                    // Refresh the parent page (NVR Invoice List)
                    CurrPage.Update();
                end;
            }

            action(DeletePayment)
            {
                Caption = 'Delete Payment';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceRecord: Record "NVR Invoices";
                begin
                    // Validate that a payment is selected
                    if Rec.IsEmpty() then
                        Error('Please select a payment to delete.');

                    // Retrieve the associated invoice
                    if not InvoiceRecord.Get(Rec.InvoiceID) then
                        Error('The associated invoice could not be found.');

                    // Subtract the payment amount from the invoice's AmountPaid
                    InvoiceRecord.AmountPaid := InvoiceRecord.AmountPaid - Rec.PaymentAmount;

                    // Ensure the AmountPaid does not go below zero
                    if InvoiceRecord.AmountPaid < 0 then
                        InvoiceRecord.AmountPaid := 0;

                    // Save the updated invoice record
                    InvoiceRecord.Modify();

                    // Delete the selected payment
                    Rec.Delete();

                    // Recalculate the remaining amount and status for the invoice
                    UpdateRemainingAmountToBePaid(InvoiceRecord.InvoiceID);

                    // Refresh the parent page (NVR Invoice List)
                    CurrPage.Update();
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

            // Dynamically calculate the remaining amount
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

    procedure GetRemainingAmount(): Decimal
    var
        InvoiceRecord: Record "NVR Invoices";
    begin
        if InvoiceRecord.Get(Rec.InvoiceID) then
            exit(InvoiceRecord."RemAmtToBePaidToInvoice");
        exit(0);
    end;

    var
        SelectedInvoice: Record "NVR Invoices";
}