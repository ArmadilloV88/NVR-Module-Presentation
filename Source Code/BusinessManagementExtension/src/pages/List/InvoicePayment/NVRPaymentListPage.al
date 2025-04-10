page 50103 "NVR Payment List"
{
    ModifyAllowed = false;
    InsertAllowed = true;
    DeleteAllowed = false;
    ApplicationArea = All;
    Caption = 'Payment List';
    PageType = List;
    SourceTable = "NVR Payments";

    layout
    {
        area(content)
        {
            repeater(Payments)
            {
                field("NVR Payment ID"; Rec.PaymentID)
                {
                    Caption = 'Payment ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Invoice ID"; Rec.InvoiceID)
                {
                    Caption = 'Invoice ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Payment Date"; rec."Payment Date")
                {
                    Caption = 'Payment Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Payment Method"; Rec.PaymentMethod)
                {
                    Caption = 'Payment Method';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Payment Amount"; Rec.PaymentAmount)
                {
                    Caption = 'Payment Amount';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        /*area(processing)
        {
            action(NewPayment)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Payment Card");
                end;
            }
        }*/
    }
}
