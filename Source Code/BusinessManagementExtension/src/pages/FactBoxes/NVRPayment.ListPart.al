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
                    PaymentHandler: Codeunit "NVR Payment EventHandler";
                begin
                    //Message('(Payment ListPart) Selected Invoice: %1', SelectedInvoice.InvoiceID); // Debugging message

                    // Validate the Selected Invoice
                    if SelectedInvoice.IsEmpty() then
                        Error('Please select a valid Invoice before adding a payment.');

                    // Check if the invoice is fully paid
                    if SelectedInvoice.Status = Enum::"NVR PaymentStatusEnum"::Paid then begin
                        Message('The selected invoice is already fully paid. There is no need to add a payment.');
                        exit; // Exit the action as no further processing is needed
                    end;

                    // Generate a unique Payment ID
                    Counter := 0;
                    repeat
                        Counter += 1;
                        NewPaymentID := 'PAY' + PadStr(Format(Counter), 17, '0'); // Prefix with "PAY" and pad with zeros
                    until not NewPayment.Get(NewPaymentID);

                    // Initialize a new payment record
                    NewPayment.Init();
                    NewPayment.PaymentID := NewPaymentID;
                    NewPayment.InvoiceID := SelectedInvoice.InvoiceID; // Set the InvoiceID
                    NewPayment."Payment Date" := Today; // Set the default payment date

                    // Insert the new payment record into the database
                    NewPayment.Insert(true);

                    // Commit the transaction to allow Page.RunModal
                    Commit();

                    // Open the Payment Card page for the new payment
                    Page.RunModal(Page::"NVR Payment Card", NewPayment); // Pass the NewPayment record

                    // Delegate the remaining amount and status update to the Codeunit
                    PaymentHandler.UpdateInvoiceAfterPaymentChange(SelectedInvoice.InvoiceID);

                    // Refresh the current page (Payment ListPart)
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
                    PaymentHandler: Codeunit "NVR Payment EventHandler";
                begin
                    // Validate that a payment is selected
                    if Rec.IsEmpty() then
                        Error('Please select a payment to delete.');

                    // Retrieve the associated invoice
                    if not InvoiceRecord.Get(Rec.InvoiceID) then
                        Error('The associated invoice could not be found.');

                    // Delete the selected payment
                    Rec.Delete();

                    // Delegate the remaining amount and status update to the Codeunit
                    PaymentHandler.UpdateInvoiceAfterPaymentChange(InvoiceRecord.InvoiceID);

                    // Trigger the event to notify the parent page
                    OnPaymentDeleted(InvoiceRecord.InvoiceID);

                    // Refresh the current page (Payment ListPart)
                    CurrPage.Update();
                end;
            }
        }
    }

    [IntegrationEvent(false, false)]
    procedure OnPaymentDeleted(InvoiceID: Code[20])
    begin
        // Event triggered when a payment is deleted
    end;

    procedure SetSelectedInvoice(Invoice: Record "NVR Invoices")
    begin
        SelectedInvoice := Invoice; // Assign the passed invoice to the SelectedInvoice variable
        //Message('(Payment ListPart) Selected Invoice: %1', SelectedInvoice.InvoiceID); // Debugging message
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