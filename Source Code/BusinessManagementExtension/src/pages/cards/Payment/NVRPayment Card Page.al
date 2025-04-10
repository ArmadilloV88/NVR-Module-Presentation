page 50113 "NVR Payment Card"
{
    Caption = 'Payment Card';
    PageType = Card;
    SourceTable = "NVR Payments";

    layout
    {
        area(content)
        {
            group(Group)
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
                    TableRelation = "NVR Invoices".InvoiceID;
                    trigger OnValidate()
                    var
                        InvoiceRecord: Record "NVR Invoices";
                    begin
                        // Retrieve the invoice record and update the RemainingAmt
                        if InvoiceRecord.Get(Rec.InvoiceID) then
                            RemainingAmt := InvoiceRecord."RemAmtToBePaidToInvoice"
                        else
                            RemainingAmt := 0;
                    end;
                }
                field("NVR Payment Date"; Rec."Payment Date")
                {
                    Caption = 'Payment Date';
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        // Check if the payment date is in the future (should only accept present and past dates)
                        if Rec."Payment Date" > Today then
                            Error('The payment date cannot be in the future. Please select today or a past date.');
                    end;
                }
                field("NVR Payment Method"; Rec.PaymentMethod)
                {
                    Caption = 'Payment Method';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("NVR Payment Amount"; Rec.PaymentAmount)
                {
                    Caption = 'Payment Amount';
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        InvoiceRecord: Record "NVR Invoices";
                    begin
                        // Check if the Invoice ID is valid
                        if Rec.InvoiceID = '' then
                            Error('Please select a valid Invoice ID before entering the payment amount.');

                        // Retrieve the invoice record
                        if InvoiceRecord.Get(Rec.InvoiceID) then begin
                            // Check if the invoice is already paid
                            if InvoiceRecord.Status = Enum::"NVR PaymentStatusEnum"::Paid then begin
                                Message('The invoice is already fully paid. The payment amount cannot be changed.');
                                Rec.PaymentAmount := xRec.PaymentAmount; // Reset to the original payment amount
                                exit;
                            end;

                            // Check if the payment amount exceeds the remaining amount
                            if Rec.PaymentAmount > InvoiceRecord."RemAmtToBePaidToInvoice" then begin
                                Message('The payment amount exceeds the remaining amount for the invoice. It will be adjusted to the remaining amount.');
                                Rec.PaymentAmount := InvoiceRecord."RemAmtToBePaidToInvoice"; // Adjust the payment amount
                            end;

                            // Call the procedure to update the remaining amount and status
                            UpdateRemainingAmountToBePaid(Rec.InvoiceID);

                            // Refresh the RemainingAmt variable
                            RemainingAmt := InvoiceRecord."RemAmtToBePaidToInvoice";
                        end else
                            Error('The selected Invoice ID does not exist.');
                    end;
                }
                field("NVR Remaining Amount"; RemainingAmt)
                {
                    Caption = 'Remaining Amount that can be paid to invoice';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceRecord: Record "NVR Invoices";
                begin
                    // Save the payment record
                    Rec.Modify(true);

                    // Refresh the RemainingAmt field and update the status
                    if InvoiceRecord.Get(Rec.InvoiceID) then begin
                        UpdateRemainingAmountToBePaid(Rec.InvoiceID);
                        RemainingAmt := InvoiceRecord."RemAmtToBePaidToInvoice";
                    end;

                    Message('Payment saved successfully!');
                    Close();
                end;
            }

            /*action(DeletePayment)
            {
                Caption = 'Delete Payment';
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceRecord: Record "NVR Invoices";
                begin
                    // Delete the payment record
                    if Confirm('Are you sure you want to delete this payment?', false) then begin
                        Rec.Delete(true);

                        // Refresh the RemainingAmt field and update the status
                        if InvoiceRecord.Get(Rec.InvoiceID) then begin
                            UpdateRemainingAmountToBePaid(Rec.InvoiceID);
                            RemainingAmt := InvoiceRecord."RemAmtToBePaidToInvoice";
                        end;

                        Message('Payment deleted successfully!');
                        Close();
                    end;
                end;
            }*/

            action(Cancel)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Close(); // Close the page without saving
                end;
            }
        }
    }

    trigger OnClosePage()
    var
        InvoiceRecord: Record "NVR Invoices";
    begin
        // Prevent automatic saving of the record when the page is closed
        if Confirm('Do you want to save changes?', false) then begin
            Rec.Modify(true); // Save the record

            // Refresh the RemainingAmt field and update the status
            if InvoiceRecord.Get(Rec.InvoiceID) then begin
                UpdateRemainingAmountToBePaid(Rec.InvoiceID);
                RemainingAmt := InvoiceRecord."RemAmtToBePaidToInvoice";
            end;
        end;
    end;

    trigger OnOpenPage()
    var
        InvoiceRecord: Record "NVR Invoices";
    begin
        //Message('(Payment Card) Invoice ID : %1', Rec.InvoiceID);
        // Initialize RemainingAmt based on the selected Invoice ID
        if Rec.InvoiceID <> '' then begin
            if InvoiceRecord.Get(Rec.InvoiceID) then
                RemainingAmt := InvoiceRecord."RemAmtToBePaidToInvoice"
            else
                RemainingAmt := 0;
        end;
    end;

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

    var
        RemainingAmt: Decimal;
}
//weird bug with the payment method, if the payment method is credit card it complains however anything else is fine