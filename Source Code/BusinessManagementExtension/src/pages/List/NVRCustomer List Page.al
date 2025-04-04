page 50100 "NVR Customer List"
{
    ModifyAllowed = false;
    Caption = 'Customer List';
    ApplicationArea = All;
    PageType = List;

    SourceTable = "NVR Customers";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("NVR Customer ID"; Rec.CustomerID)
                {
                    Caption = 'Customer ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Name"; Rec.Name)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Email"; Rec.Email)
                {
                    Caption = 'Email Address';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Phone"; Rec.Phone)
                {
                    Caption = 'Phone Number';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Billing Address"; Rec."Billing Address")
                {
                    Caption = 'Billing Address';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Shipping Address"; Rec."Shipping Address")
                {
                    Caption = 'Shipping Address';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Payment Terms"; Rec."Payment Terms")
                {
                    Caption = 'Payment Terms';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewCustomer)
            {
                Caption = 'New Customer';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Customer Card", Rec);
                end;
            }
        }
    }
    //Add a card part to this segment to show customer information only, we can have in the card part an option to edit the customer where you will navigate to the customer card.
}