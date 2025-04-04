page 50105 "Payment Card"
{
    PageType = Card;
    SourceTable = "Payment";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Invoice ID"; "Invoice ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select an existing Invoice for the Payment';
                }

                field("Payment Date"; "Payment Date")
                {
                    ApplicationArea = All;
                }

                field("Amount"; "Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnValidate()
    var
        InvoiceRec: Record "Invoice";
    begin
        if "Invoice ID" = '' then
            Error('Invoice must be selected before making a Payment.');

        if not InvoiceRec.Get("Invoice ID") then
            Error('Invoice does not exist.');

        if "Amount" > InvoiceRec."Remaining Amount" then
            Error('Payment cannot exceed the remaining amount due on the Invoice.');
    end;
}
