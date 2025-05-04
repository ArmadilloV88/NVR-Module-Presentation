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
                field(PartiallyPaidInvoices; PartiallyPaidInvoicesCount)
                {
                    Caption = 'Partially Paid Invoices';
                    //DrillDownPageId = "NVR Invoice List"; // Navigate to the Invoice List
                    ToolTip = 'Shows the number of partially paid invoices.';
                    //color this field red if overdue
                    StyleExpr = 'UnFavorable';
                }
                field(TotalInvoiceAmount; TotalInvoiceAmount)
                {
                    Caption = 'Total Invoice Amount';
                    ToolTip = 'Shows the total amount of all invoices.';
                    //StyleExpr = 'Favorable';
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
            }
            group(TextFields)
            {
                Caption = 'Additional Information';
                field(HighestPaymentAmount; HighestPaymentAmount)
                {
                    Caption = 'Highest Payment Amount';
                    ToolTip = 'Shows the highest payment amount.';
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
        PartiallyPaidInvoicesCount := GetPartiallyPaidInvoicesCount();
        TotalInvoiceAmount := GetTotalInvoiceAmount();
        //
    end;

    var
        HighestPaymentAmount: Decimal;
        UnPaidInvoicesCount: Integer;
        PaidInvoicesCount: Integer;
        TotalPaidAmount: Decimal;
        TotalUnPaidAmount: Decimal;
        PartiallyPaidInvoicesCount: Integer;
        TotalInvoiceAmount: Decimal;

    local procedure GetTotalInvoiceAmount(): Decimal
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetTotalInvoiceAmount())
    end;

    local procedure GetPartiallyPaidInvoicesCount(): Integer
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetPartiallyPaidInvoicesCount())
    end;
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