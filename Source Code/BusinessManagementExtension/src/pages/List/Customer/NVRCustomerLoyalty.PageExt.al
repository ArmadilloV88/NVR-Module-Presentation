pageextension 50101 CustomerCardExt extends "Customer List"
{
    actions
    {
        addlast(Processing)
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
    }
}