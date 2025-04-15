page 50123 "NVR Sales Activities"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "NVR Sales Orders";
    Caption = 'Sales Activities';

    layout
    {
        area(content)
        {
            cuegroup(SalesCues)
            {
                Caption = 'Sales Activities';
                field(UnPaidSalesOrders; UnPaidSalesOrdersCount)
                {
                    Caption = 'Open Sales Orders';
                    //DrillDownPageId = "NVR Sales Order List"; // Navigate to the Sales Order List
                    ToolTip = 'Shows the number of open sales orders.';
                    StyleExpr = 'UnFavorable';
                }
                field(PaidSalesOrders; PaidSalesOrdersCount)
                {
                    Caption = 'Paid Sales Orders';
                    //DrillDownPageId = "NVR Sales Order List"; // Navigate to the Sales Order List
                    ToolTip = 'Shows the number of paid sales orders.';
                    StyleExpr = 'Favorable';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Sales Activities
        PaidSalesOrdersCount := GetPaidSalesOrdersCount(); //Sales Activities
        UnPaidSalesOrdersCount := GetUnPaidSalesOrdersCount(); //Sales Activities
        //Total Sales Order Amount
        //Most sold product
        //Most listed Category
        //  
    end;

    var
        //OpenSalesOrdersCount: Integer;
        PaidSalesOrdersCount: Integer;
        UnPaidSalesOrdersCount: Integer;
    
    local procedure GetPaidSalesOrdersCount(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetnumberOfPaidSalesOrders())
    end;
    local procedure GetUnPaidSalesOrdersCount(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetnumberOfUnPaidSalesOrders())
    end;
}