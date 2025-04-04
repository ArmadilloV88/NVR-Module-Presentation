page 50112 "NVR Invoice Card"
{
    Caption = 'Invoice Card';
    PageType = Card;
    SourceTable = "NVR Invoices";

    layout
    {
        area(content)
        {
            group(Invoice)
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
                    Editable = true;
                    NotBlank = true;
                    TableRelation = "NVR Sales Orders".SalesOrderID;
                    //this must show a drop down of all the sales order ids in the sales order table
                }
                field("NVR Invoice Date"; Rec.InvoiceDate)
                {
                    Caption = 'Invoice Date';
                    ApplicationArea = All;
                    NotBlank = true;
                    Editable = true;
                    //defencive programming to check if the date is in the correct format and is also not unnormally far in the future or past
                }
                field("NVR Due Date"; Rec.DueDate)
                {
                    Caption = 'Due Date';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                    //defencive programming to check if the date is in the correct format and is also not unnormally far in the future or past
                }
                field("NVR Amount Due"; Rec.AmountDue)
                {
                    Caption = 'Amount Due';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                }
                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                    TableRelation = Currency.Code;
                }
                field("NVR Status"; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                    //TableRelation = "NVR PaymentStatusEnum";

                //needs to be a dropdown that allows the user to select the values from the enum
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Message('Invoice saved successfully!');
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Close;
                end;
            }
        }
    }
}
