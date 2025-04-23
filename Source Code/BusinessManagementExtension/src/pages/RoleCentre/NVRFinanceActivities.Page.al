page 50119 "NVR Finance Activities"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "NVR Invoices";
    Caption = 'Finance Activities';

    layout
    {
        area(content)
        {
            cuegroup(FinanceCues)
            {
                Caption = 'Finance Activities';
                field(UnPaidInvoices; UnPaidInvoicesCount)
                {
                    Caption = 'Un-Paid Invoices';
                    //DrillDownPageId = "NVR Invoice List"; // Navigate to the Invoice List
                    ToolTip = 'Shows the number of Un-Paid invoices.';
                    //color this field red if overdue
                    StyleExpr = 'UnFavorable';
                }
                field(PaidInvoices; PaidInvoicesCount)
                {
                    Caption = 'Paid Invoices';
                    //DrillDownPageId = "NVR Invoice List"; // Navigate to the Invoice List
                    ToolTip = 'Shows the number of Un-Paid invoices.';
                    //color this field red if overdue
                    StyleExpr = 'Favorable';
                }
                field(TotalUnPaidAmountField; TotalUnPaidAmount)
                {
                    Caption = 'Total Unpaid Amount';
                    ToolTip = 'Shows the total amount unpaid for invoices.';
                    StyleExpr = 'UnFavorable';
                }
                field(TotalPaidAmountField; TotalPaidAmount)
                {
                    Caption = 'Total Paid Amount';
                    ToolTip = 'Shows the total amount paid for invoices.';
                    StyleExpr = 'Favorable';
                }
                field(HighestPaymentAmount; HighestPaymentAmount)
                {
                    Caption = 'Highest Payment Amount';
                    ToolTip = 'Shows the highest payment amount.';
                    StyleExpr = 'Favorable';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Finance Activities
        UnPaidInvoicesCount := GetUnPaidInvoicesCount();
        PaidInvoicesCount := GetPaidInvoicesCount();
        TotalPaidAmount := GetTotalPaidAmount();
        TotalUnPaidAmount := GetTotalUnPaidAmount();
        HighestPaymentAmount := GetHighestPaymentAmount();
        //
    end;

    var
        HighestPaymentAmount: Decimal;
        UnPaidInvoicesCount: Integer;
        PaidInvoicesCount: Integer;
        TotalPaidAmount: Decimal;
        TotalUnPaidAmount: Decimal;
    local procedure GetUnPaidInvoicesCount(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetnumberOfUnPaidSalesOrders())
    end;
    local procedure GetPaidInvoicesCount(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetnumberOfPaidSalesOrders())
    end;
    local procedure GetTotalPaidAmount(): Decimal
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetTotalAmountofPaidInvoices())
    end;
    local procedure GetTotalUnPaidAmount(): Decimal
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetTotalAmountofUnPaidInvoices())
    end;
    local procedure GetHighestPaymentAmount(): Decimal
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetHighestPaymentAmount());
    end;

}