page 50111 "Sales Order Line Card"
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
                }

                field("Product ID"; "Product ID")
                {
                    ApplicationArea = All;
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

    actions
    {
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Message('Sales Order Line saved successfully!');
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Close;
                end;
            }
        }
    }
}
