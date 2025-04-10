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

                field("NVR Customer ID"; Rec.CustomerID)
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

                field("NVR Payment Status"; Rec."Payment Status")
                {
                    Caption = 'Payment Status';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = Currency.Code;
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
                    Page.RunModal(Page::"NVR Sales Order Card", Rec);
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
                    SalesOrderLineRecord: Record "NVR Sales Order Line";
                begin
                    if Rec.SalesOrderID = '' then
                        Error('The Sales Order ID is not available. Please ensure a valid Sales Order is selected.');

                    SalesOrderLineRecord.SetRange(SalesOrderID, Rec.SalesOrderID);

                    if SalesOrderLineRecord.FindSet() then
                        Page.RunModal(Page::"NVR Sales Order Line List", SalesOrderLineRecord)
                    else
                        Message('No sales order lines found for Sales Order ID: %1', Rec.SalesOrderID);
                end;
            }
            action(AddNewSalesOrderLine)
            {
                Caption = 'Add New Sales Order Line for this Sales Order';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order Line Card");
                end;
            }
            action(ViewInvoices)
            {
                Caption = 'View Invoices for this Sales Order';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InvoiceHelper: Codeunit "NVR InvoiceSalesOrderHandler";
                begin
                    if Rec.SalesOrderID = '' then
                        Error('The Sales Order ID is not available. Please ensure a valid Sales Order is selected.');

                    // Explicitly set the Sales Order ID in the Codeunit
                    InvoiceHelper.SetInvoiceSalesOrderID(Rec);

                    // Debugging message to confirm the Sales Order ID is set
                    Message('Sales Order ID Passed to Codeunit: %1', Rec.SalesOrderID);

                    // Open the Invoice List Page
                    Page.RunModal(Page::"NVR Invoice List");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Ensure the first record is loaded into Rec when the page opens
        if Rec.FindFirst() then
            CurrPage.Update(); // Refresh the page to reflect the first record
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // Ensure Rec is updated when a record is selected
        if Rec.SalesOrderID <> '' then
            Message('Current Record Sales Order ID: %1', Rec.SalesOrderID); // Debugging message
        //CurrPage.Update(); // Refresh the page to reflect the selected record
    end;

    [IntegrationEvent(false, false)]
    procedure OnSetInvoiceSalesOrderID(SalesOrderRecord: Record "NVR Sales Orders")
    begin 
    end;
}
//make a cardpart that shows the information of that sales order
//make a listpart that shows all the sales order lines of that sales order
/*Requires Testing and better refinement*/