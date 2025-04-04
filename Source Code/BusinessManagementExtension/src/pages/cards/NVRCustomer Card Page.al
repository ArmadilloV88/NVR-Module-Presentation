page 50110 "NVR Customer Card"
{
    Caption = 'Customer Card';
    PageType = Card;
    SourceTable = "NVR Customers";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Customer ID"; Rec.CustomerID)
                {
                    //this will need to be a drop down list of customers from the base application customer table
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Name"; Rec.Name)
                {
                    //this will not be editable as the customer name needs to be found via the customer id
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Email"; Rec.Email)
                {
                    //this can be editable however as soon as the customer id is selected, the email should be pulled from the NVR customers table
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Phone"; Rec.Phone)
                {
                    //this can be editable however as soon as the customer id is selected, the phone should be pulled from the NVR customers table
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Address"; Rec."Billing Address")
                {
                    //this can be editable however as soon as the customer id is selected, the billing address should be pulled from the NVR customers table
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Shipping Address"; Rec."Shipping Address")
                {
                    //this can be editable however as soon as the customer id is selected, the shipping address should be pulled from the NVR customers table
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    //also ensure that its a drop down cause this is an enum
                    //this can be editable however as soon as the customer id is selected, the payment terms should be pulled from the NVR customers table
                    Editable = true;
                    ApplicationArea = All;

                }

                //later we will add the loyalty system once main functionality is working and bug free
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
                    // Code to save the customer details
                    Rec.Modify(true); // Save changes to the record
                    Message('Customer saved successfully!');
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
