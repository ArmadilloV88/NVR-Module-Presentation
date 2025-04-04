page 50102 "Sales Order List"
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

                field("Customer"; "Customer")
                {
                    ApplicationArea = All;
                }

                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                }

                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }

                field("Total Amount"; "Total Amount")
                {
                    ApplicationArea = All;
                }

                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
