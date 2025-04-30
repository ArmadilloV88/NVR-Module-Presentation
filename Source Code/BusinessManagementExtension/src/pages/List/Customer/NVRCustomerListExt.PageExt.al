pageextension 50113 "NVR Customer List Ext" extends "NVR Customer List"
{
    layout
    {
        addlast(Customers)
        {
            field("Loyalty Points"; GetLoyaltyPoints())
            {
                Caption = 'Loyalty Points';
                ApplicationArea = All;
                Editable = false;
            }
            field("Loyalty Level"; GetLoyaltyLevel())
            {
                Caption = 'Loyalty Level';
                ApplicationArea = All;
                Editable = false;
                Style = Strong; // Makes the text bold
                //StyleExpr = GetLoyaltyLevelStyle(); // Applies conditional styling
            }
        }
    }

    local procedure GetLoyaltyPoints(): Integer
    var
        CustomerRecord: Record "NVR Customers";
    begin
        if CustomerRecord.Get(Rec."CustomerID") then
            exit(CustomerRecord."Loyalty Points");
        exit(0); // Default to 0 if no record is found
    end;
    local procedure GetLoyaltyLevel(): Enum "NVR Loyalty Level"
    var 
        CustomerLoyaltyCalc : Codeunit "NVR Loyalty Points Handler";
    begin
         Rec := CustomerLoyaltyCalc.CalculateLoyaltyPoints(Rec);
         exit(Rec."Loyalty Level");
    end;
}