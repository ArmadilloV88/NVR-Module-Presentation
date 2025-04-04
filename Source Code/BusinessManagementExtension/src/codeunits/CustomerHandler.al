codeunit 50100 "Customer Handler"
{
    procedure UpdateCustomerLoyaltyPoints(CustomerID: Code[20]; Points: Integer)
    var
        CustomerRec: Record "CustomerDetails";
    begin
        if CustomerRec.Get(CustomerID) then begin
            CustomerRec."Loyalty Points" := CustomerRec."Loyalty Points" + Points;
            CustomerRec.Modify();
        end;
    end;
}
