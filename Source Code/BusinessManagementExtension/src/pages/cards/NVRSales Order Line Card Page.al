page 50114 "NVR Sales Order Line Card"
{
    //we might need to do this page differently as we need to show a list of products in the Sales order line
    Caption = 'Sales Order Line Card';
    PageType = Card;
    SourceTable = "NVR Sales Order Line";

    layout
    {
        area(content)
        {
            group(SalesOrderLine)
            {
                field("NVR Sales Order Line ID"; Rec."Sales Order Line ID")
                {
                    Caption = 'Sales Order Line ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Product ID"; Rec.ProductID)
                {
                    Caption = 'Product ID';
                    ApplicationArea = All;
                    Editable = false;
                    //we need to show a list of products in the Sales order line
                }

                field("NVR Quantity"; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Unit Price"; Rec.Unitprice)
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Line Amount"; Rec."Line Amount")
                {
                    Caption = 'Total Line Amount';
                    ApplicationArea = All;
                    Editable = false;
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
                    Message('Sales Order Line saved successfully!');
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
