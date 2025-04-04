page 50108 "Sales Order List"
{
    PageType = List;
    SourceTable = "Sales Order";

    layout
    {
        area(content)
        {
            repeater(Group)
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
        area(processing)
        {
            action(NewSalesOrder)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Pages."Sales Order Card");
                end;
            }
        }
    }
}
