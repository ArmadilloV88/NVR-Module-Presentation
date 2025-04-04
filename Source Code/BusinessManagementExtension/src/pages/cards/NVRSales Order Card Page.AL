page 50111 "NVR Sales Order Card"
{
    PageType = Card;
    SourceTable = "NVR Sales Orders";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Customer ID"; rec.CustomerID)
                {
                    Caption = 'Customer ID';
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = "NVR Customers".CustomerID;
                }

                field("NVR Order Date"; Rec.OrderDate)
                {
                    Caption = 'Order Date';
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        //check if the date is the correct format
                    end;
                }

                field("NVR Total Amount"; Rec.TotalAmount)
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                    Editable = true;
                    DecimalPlaces = 2;
                }

                field("NVR Payment Status"; rec."Payment Status")
                {
                    Caption = 'Payment Status';
                    ApplicationArea = All;
                    Editable = true;
                    //need to ensure it shows the caption of the enum, similiar to a drop down list
                }

                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = Currency.Code;
                    //ensure that it shows the currency symbol or suffix example : ZAR
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
                    // Code to save the sales order details
                    // This will typically involve calling the table's Insert or Modify method
                    // and possibly validating the data before saving.
                    Rec.Modify(true);
                    Message('Sales Order saved successfully!');
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
