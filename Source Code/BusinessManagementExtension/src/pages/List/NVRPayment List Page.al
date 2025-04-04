page 50105 "Payment List"
{
    PageType = List;
    SourceTable = "Payment";

    layout
    {
        area(content)
        {
            repeater(Group)
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
        area(processing)
        {
            action(NewPayment)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Pages."Payment Card");
                end;
            }
        }
    }
}
