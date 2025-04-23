page 50110 "NVR Customer Card"
{
    Caption = 'Add New Customer';
    PageType = Card;
    SourceTable = "NVR Customers";
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
                    Editable = true; // Allow editing on new customers
                    TableRelation = Customer;
                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                        NVRCustomers: Record "NVR Customers";
                    begin
                        if IsNew and NVRCustomers.Get(Rec.CustomerID) then
                            Error('This Customer ID already exists in NVR Customers. Please enter a unique ID.');

                        if Customer.Get(Rec.CustomerID) then begin
                            Rec.Name := Customer.Name;
                            Rec.Email := 'Must be specified by the user.';
                            Rec.Phone := 'Must be specified by the user.';
                            Rec."Billing Address" := Customer.Address;
                            Rec."Shipping Address" := 'Must be specified by the user.';
                        end else
                            Error('Customer not found in the base application.');
                    end;
                }

                field("Name"; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Email"; Rec.Email)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Phone"; Rec.Phone)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Address"; Rec."Billing Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipping Address"; Rec."Shipping Address")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = All;
                    Editable = true;
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
                Caption = 'Save';
                Image = Save;
                ApplicationArea = All;
                trigger OnAction()
                var
                    NVRCustomers: Record "NVR Customers";
                begin
                    if Rec.CustomerID = '' then
                        Error('Customer ID must be specified.');

                    if IsNew then begin
                        if NVRCustomers.Get(Rec.CustomerID) then
                            Error('This Customer ID already exists in NVR Customers. Please enter a unique ID.');

                        if Rec.Name = '' then
                            Error('Customer Name must be specified.');

                        NVRCustomers := Rec;
                        NVRCustomers.Insert(true);
                        Message('Customer saved successfully!');
                    end else begin
                        Rec.Modify(true);
                        Message('Customer updated successfully!');
                    end;
                    Close;
                end;
            }

            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Close;
                end;
            }
        }
    }

    var
        IsNew: Boolean;

    trigger OnOpenPage()
    var
        NVRCustomers: Record "NVR Customers";
    begin
        // Ensure this is a new customer
        IsNew := not NVRCustomers.Get(Rec."CustomerID");

        // If the page is new, clear all the fields for a fresh record
        if IsNew then begin
            Clear(Rec);
            //Rec.Clear();
        end;
    end;
}
