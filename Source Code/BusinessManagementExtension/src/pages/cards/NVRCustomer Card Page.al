page 50110 "NVR Customer Card"
{
    Caption = 'Customer Card';
    PageType = Card;
    SourceTable = "NVR Customers";
    Editable = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Customer)
            {

                field("Customer ID"; Rec.CustomerID)
                {
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = Customer."No."; // Links to the "No." field in the base Customer table
                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                    begin
                        // Pull data from the base Customer table when a customer is selected
                        if Customer.Get(Rec.CustomerID) then begin
                            Rec.Name := Customer.Name;
                            Rec.Email := 'Must be specified by the user.';
                            Rec.Phone := 'Must be specified by the user.';
                            Rec."Billing Address" := Customer.Address;
                            Rec."Shipping Address" := 'Must be specified by the user.'; // Placeholder for shipping address
                            //Rec."Payment Terms" := Customer."Payment Terms Code";
                        end else
                            Error('Customer not found in the base application.');
                    end;
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
                    Editable = false;
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
                    close;
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
