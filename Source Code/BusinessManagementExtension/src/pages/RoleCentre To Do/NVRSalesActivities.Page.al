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
                    ToolTip = 'Shows the number of open sales orders.';
                    StyleExpr = 'UnFavorable';
                }
                field(PaidSalesOrders; PaidSalesOrdersCount)
                {
                    Caption = 'Paid Sales Orders';
                    ToolTip = 'Shows the number of paid sales orders.';
                    StyleExpr = 'Favorable';
                }
                field(TotalSalesOrderAmount; TotalSalesOrderAmount)
                {
                    Caption = 'Total Sales Order Amount';
                    ToolTip = 'Shows the total amount of all sales orders.';
                    //StyleExpr = 'Favorable';
                }
            }
            group(TextFields)
            {
                Caption = 'Additional Information';

            field(MostSoldProduct; MostSoldProduct)
            {
                Caption = 'Most Sold Product';
                ToolTip = 'Shows the name of the most sold product.';
            }
            field(MostListedCategory; MostListedCategory)
            {
                Caption = 'Most Listed Category';
                ToolTip = 'Shows the most listed product category.';
            }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Sales Activities
        PaidSalesOrdersCount := GetPaidSalesOrdersCount(); //Sales Activities
        UnPaidSalesOrdersCount := GetUnPaidSalesOrdersCount(); //Sales Activities
        TotalSalesOrderAmount := GetTotalSalesOrderAmount(); //Sales Activities
        MostSoldProduct := GetMostSoldProduct(); //Sales Activities
        MostListedCategory := GetMostListedCategory(); //Sales Activities
        //  
    end;

    var
        PaidSalesOrdersCount: Integer;
        UnPaidSalesOrdersCount: Integer;
        TotalSalesOrderAmount : Decimal;
        MostSoldProduct: Text[100];
        MostListedCategory: Text[100];

    local procedure GetTotalSalesOrderAmount(): Decimal
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetTotalSalesOrderAmount())
    end;
    local procedure GetMostSoldProduct(): Text[100]
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetMostSoldProduct())
    end;
    local procedure GetMostListedCategory(): Text[100]
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetMostListedCategory())
    end;
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