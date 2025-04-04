page 50110 "Sales Order Line List"
{
    PageType = List;
    SourceTable = "Sales Order Line";

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

                field("Line ID"; "Line ID")
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
        area(processing)
        {
            action(NewSalesOrderLine)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Pages."Sales Order Line Card");
                end;
            }
        }
    }
}
