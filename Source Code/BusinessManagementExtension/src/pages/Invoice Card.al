page 50104 "Invoice Card"
{
    PageType = Card;
    SourceTable = "Invoice";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Sales Order ID"; "Sales Order ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select an existing Sales Order for the Invoice';
                }

                field("Invoice Date"; "Invoice Date")
                {
                    ApplicationArea = All;
                }

                field("Amount"; "Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount to be invoiced for the Sales Order';
                }

                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnValidate()
    var
        SalesOrderRec: Record "Sales Order";
    begin
        if "Sales Order ID" = '' then
            Error('Sales Order must be selected before creating an Invoice.');

        if not SalesOrderRec.Get("Sales Order ID") then
            Error('Sales Order does not exist.');

        if "Amount" > SalesOrderRec."Remaining Amount" then
            Error('Invoice amount cannot exceed the remaining amount of the Sales Order.');
    end;
}
