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
            group(TextFields)
            {
                Caption = 'Most Loyal Customer';
                field(MostLoyalCustomerName; HighestLoyaltyCustomerName)
                {
                    Caption = 'Most Loyal Customer';
                    ToolTip = 'Shows the name of the most loyal customer.';
                }
                field(MostLoyalCustomerLoyaltyPoints; HighestLoyaltyCustomer."Loyalty Points")
                {
                    Caption = 'Loyalty Points';
                    ToolTip = 'Shows the loyalty points of the most loyal customer.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        TotalNumberofSalesOrders := GetTotalNumberofSalesOrders();
        TotalNumberofInvoices := GetTotalNumberofInvoices();
        TotalNumberofPayments := GetTotalNumberofPayments();
        HighestLoyaltyCustomer := GetHighestLoyaltyCustomer();
        HighestLoyaltyCustomerName := HighestLoyaltyCustomer.Name;
    end;

    var
        TotalNumberofSalesOrders: Integer;
        TotalNumberofInvoices: Integer;
        TotalNumberofPayments: Integer;
        HighestLoyaltyCustomer: Record "NVR Customers";
        HighestLoyaltyCustomerName: Text[100];
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
    local procedure GetHighestLoyaltyCustomer(): Record "NVR Customers"
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetHighestLoyaltyCustomer())
    end;
}