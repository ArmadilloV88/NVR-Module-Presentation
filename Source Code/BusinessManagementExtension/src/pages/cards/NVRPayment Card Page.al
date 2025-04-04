page 50106 "Payment Card"
{
    PageType = Card;
    SourceTable = "Payment";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Payment ID"; "Payment ID")
                {
                    ApplicationArea = All;
                }

                field("Invoice ID"; "Invoice ID")
                {
                    ApplicationArea = All;
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

    actions
    {
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Message('Payment saved successfully!');
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
