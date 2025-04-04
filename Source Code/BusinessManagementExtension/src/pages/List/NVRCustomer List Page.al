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
                /*redundant as the factbox shows the customer details
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
                }*/
            }
        }
        area(FactBoxes)
        {
            part(CustomerInfo; "NVR Customer Info FactBox")
            {
                ApplicationArea = All;
                Caption = 'Customer Info';
                SubPageLink = "CustomerID" = FIELD(CustomerID);
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(NewCustomer)
            {
                Caption = 'New Customer';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Customer Card");
                end;
            }
            action(ViewSalesOrders)
            {
                //Need to add the page linking between customer and sales order list
            }
            action(ViewProducts)
            {
                //Need to add the page linking between customer and product list
            }

        }
    }
}