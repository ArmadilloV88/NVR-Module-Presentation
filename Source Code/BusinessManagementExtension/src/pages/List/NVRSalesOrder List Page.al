page 50108 "NVR Sales Order List"
{
    Caption = 'Sales Orders';
    PageType = List;
    SourceTable = "NVR Sales Orders";

    layout
    {
        area(content)
        {
            repeater(SalesOrders)
            {
                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Customer ID"; rec.CustomerID)
                {
                    Caption = 'Customer ID';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = "NVR Customers".CustomerID;
                }

                field("NVR Order Date"; Rec.OrderDate)
                {
                    Caption = 'Order Date';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Total Amount"; Rec.TotalAmount)
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 2;
                }

                field("NVR Payment Status"; rec."Payment Status")
                {
                    Caption = 'Payment Status';
                    ApplicationArea = All;
                    Editable = false;
                    //need to ensure it shows the caption of the enum
                }

                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = Currency.Code;
                    //ensure that it shows the currency symbol or suffix example : ZAR
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
                Caption = 'New Sales Order';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order Card");
                end;
            }
            action(EditSalesOrder)
            {
                 Caption = 'Edit Sales Order';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order Card",Rec);
                end;
            }

        }
    }
}

//make a cardpart that shows the information of that sales order
