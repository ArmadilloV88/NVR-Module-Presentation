page 50102 "NVR Invoice List"
{
    Caption = 'Invoice List';
    PageType = List;
    SourceTable = "NVR Invoices";

    layout
    {
        area(content)
        {
            repeater(Invoices)
            {
                field("NVR Invoice ID"; Rec.InvoiceID)
                {
                    Caption = 'Invoice ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Invoice Date"; Rec.InvoiceDate)
                {
                    Caption = 'Invoice Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Due Date"; Rec.DueDate)
                {
                    Caption = 'Due Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Amount Due"; Rec.AmountDue)
                {
                    Caption = 'Amount Due';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Status"; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewInvoice)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Customer Card", Rec);
                end;
            }
        }
    }
}
