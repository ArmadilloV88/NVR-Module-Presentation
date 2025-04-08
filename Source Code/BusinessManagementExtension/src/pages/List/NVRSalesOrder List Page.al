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
        area(Navigation)
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
        area(Processing)
        {
            action(ViewSalesOrderLines)
            {
                Caption = 'View Sales Order Lines';
                Image = List;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesOrderLineRecord: Record "NVR Sales Order Line"; // Correct table for sales order lines
                begin
                    // Ensure the Sales Order ID is available
                    if Rec.SalesOrderID = '' then begin
                        Error('The Sales Order ID is not available. Please ensure a valid Sales Order is selected.');
                    end;

                    // Debug the Sales Order ID
                    Message('Debug: Sales Order ID = %1', Rec.SalesOrderID);

                    // Filter the Sales Order Line record by the selected Sales Order ID
                    SalesOrderLineRecord.SetRange(SalesOrderID, Rec.SalesOrderID); // Correct field name

                    // Debug the filtered record count
                    if SalesOrderLineRecord.FindSet() then
                        Message('Debug: Found %1 sales order lines.', SalesOrderLineRecord.Count)
                    else
                        Message('No sales order lines found for Sales Order ID: %1', Rec.SalesOrderID);

                    // Open the Sales Order Line List page with the filtered record
                    Page.RunModal(Page::"NVR Sales Order Line List", SalesOrderLineRecord);
                end;
            }
            action(AddNewSalesOrderLine)
            {
                Caption = 'Add New Sales Order Line';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order Line Card");
                end;
            }
        }
    }
}

//make a cardpart that shows the information of that sales order
//make a listpart that shows all the sales order lines of that sales order
/*Requires Testing and better refinement*/