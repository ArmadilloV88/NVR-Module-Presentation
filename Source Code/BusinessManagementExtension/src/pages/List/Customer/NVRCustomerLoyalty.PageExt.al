/*
###COMMENTS###
must stay intact as it is or can be ultered by removing 
the Register for Loyalty Program action if data feeding 
to the base application took place
##############
*/
pageextension 50101 CustomerListExt extends "Customer List"
{
    actions
    {
        addlast("&Customer")
        {
            action(RegisterForLoyalty)
            {
                Caption = 'Register for Loyalty Program';
                ApplicationArea = All;
                Image = Discount;
                trigger OnAction()
                var
                    NVRCustomer: Record "NVR Customers";
                begin
                    if not NVRCustomer.Get(Rec."No.") then begin
                        NVRCustomer.Init();
                        NVRCustomer."CustomerID" := Rec."No.";
                        NVRCustomer.Name := Rec.Name;
                        NVRCustomer."Billing Address" := Rec.Address;
                        NVRCustomer.Email := 'Must be specified by the user.';
                        NVRCustomer.Phone := 'Must be specified by the user.';
                        NVRCustomer.Insert(true);
                        Commit();
                        Message('Customer %1 has been registered for the loyalty program.', Rec.Name);
                    end else
                        Message('Customer %1 is already registered.', Rec.Name);
                end;
            }
        }
        addfirst(processing)
        {
            action(NavToCustLytRolecentre)
            {
                Caption = 'Loyalty Role Center';
                ApplicationArea = All;
                Image = DataEntry;
                trigger OnAction()
                var
                    CustomerRoleCenter: Page "NVR Custom Role Center";
                begin
                    CustomerRoleCenter.RunModal();
                end;
            }
        }
    }
}