page 50104 "Invoice List"
{
    PageType = List;
    SourceTable = "Invoice";

    layout
    {
        area(content)
        {
            repeater(Group)
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
        area(processing)
        {
            action(NewInvoice)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Pages."Invoice Card");
                end;
            }
        }
    }
}
