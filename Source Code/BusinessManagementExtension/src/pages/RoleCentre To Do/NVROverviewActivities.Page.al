page 50118 "NVR Overview Activities"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "NVR Sales Orders";
    Caption = 'Overview Activities';

    layout
    {
        area(content)
        {
            cuegroup(OverviewCues)
            {
                Caption = 'Overview Activities';

                field(TotalNumberofSalesOrders; TotalNumberofSalesOrders)
                {
                    Caption = 'Total Sales Orders';
                    ToolTip = 'Shows the total number of sales orders.';
                }
                field(TotalNumberofInvoices; TotalNumberofInvoices)
                {
                    Caption = 'Total Number of Invoices';
                    ToolTip = 'Shows the total number of invoices.';
                }
                field(TotalNumberofPayments; TotalNumberofPayments)
                {
                    Caption = 'Total Number of Payments';
                    ToolTip = 'Shows the number of payments.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        TotalNumberofSalesOrders := GetTotalNumberofSalesOrders();
        TotalNumberofInvoices := GetTotalNumberofInvoices();
        TotalNumberofPayments := GetTotalNumberofPayments();
    end;

    var
        TotalNumberofSalesOrders: Integer;
        TotalNumberofInvoices: Integer;
        TotalNumberofPayments: Integer;
    local procedure GetTotalNumberofSalesOrders(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetTotalNumberofSalesOrders())
    end;
    local procedure GetTotalNumberofInvoices(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetTotalNumberofInvoices())
    end;
    local procedure GetTotalNumberofPayments(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetTotalNumberofPayments())
    end;
}