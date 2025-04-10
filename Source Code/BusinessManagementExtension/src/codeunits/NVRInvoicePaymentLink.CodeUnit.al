codeunit 50118 "NVR Payment EventHandler"
{
    Subtype = Normal;

    [EventSubscriber(ObjectType::Page, Page::"NVR Payment ListPart", 'OnPaymentDeleted', '', false, false)]
    procedure HandlePaymentDeleted(InvoiceID: Code[20])
    var
        InvoiceRecord: Record "NVR Invoices";
    begin
        // Retrieve the associated invoice
        if InvoiceRecord.Get(InvoiceID) then begin
            // Perform any additional logic here if needed
            //Message('Invoice %1 has been updated after payment deletion.', InvoiceID);
        end;
    end;

    procedure UpdateInvoiceAfterPaymentChange(InvoiceID: Code[20])
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

            // Update the invoice status and style based on the remaining amount
            if InvoiceRecord."RemAmtToBePaidToInvoice" = 0 then begin
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