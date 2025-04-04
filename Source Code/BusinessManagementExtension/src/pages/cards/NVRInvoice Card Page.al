page 50105 "Invoice Card"
{
    PageType = Card;
    SourceTable = "Invoice";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Invoice ID"; "Invoice ID")
                {
                    ApplicationArea = All;
                }

                field("Sales Order ID"; "Sales Order ID")
                {
                    ApplicationArea = All;
                }

                field("Invoice Date"; "Invoice Date")
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

    actions
    {
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Message('Invoice saved successfully!');
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
