page 50103 "Sales Order Line Card"
{
    PageType = Card;
    SourceTable = "Sales Order Line";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Sales Order ID"; "Sales Order ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select an existing Sales Order';
                }

                field("Product ID"; "Product ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select a Product for the Sales Order Line';
                }

                field("Quantity"; "Quantity")
                {
                    ApplicationArea = All;
                }

                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                }

                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnValidate()
    begin
        if "Sales Order ID" = '' then
            Error('Sales Order must be selected.');

        if "Product ID" = '' then
            Error('Product must be selected for the Sales Order Line.');
    end;
}
