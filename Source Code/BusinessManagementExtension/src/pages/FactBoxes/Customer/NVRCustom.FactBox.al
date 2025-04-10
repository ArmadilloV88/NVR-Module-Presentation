page 50120 "NVR Customer Info FactBox"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "NVR Customers";
    Caption = 'Customer Information';

    layout
    {
        area(content)
        {
            group("Customer Details")
            {
                field("Customer ID"; Rec.CustomerID)
                {
                    ApplicationArea = All;
                    Caption = 'Customer ID';
                }
                field("Name"; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Email"; Rec.Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                }
                field("Phone"; Rec.Phone)
                {
                    ApplicationArea = All;
                    Caption = 'Phone';
                }
                field("Billing Address"; Rec."Billing Address")
                {
                    ApplicationArea = All;
                    Caption = 'Billing Address';
                }
                field("Shipping Address"; Rec."Shipping Address")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Address';
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Terms';
                }
            }
        }
    }
}