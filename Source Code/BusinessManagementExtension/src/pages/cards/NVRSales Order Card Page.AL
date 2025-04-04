page 50109 "Sales Order Card"
{
    PageType = Card;
    SourceTable = "Sales Order";

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

                field("Customer ID"; "Customer ID")
                {
                    ApplicationArea = All;
                }

                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                }

                field("Amount"; "Amount")
                {
                    ApplicationArea = All;
                }

                field("Status"; "Status")
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
                    Message('Sales Order saved successfully!');
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
