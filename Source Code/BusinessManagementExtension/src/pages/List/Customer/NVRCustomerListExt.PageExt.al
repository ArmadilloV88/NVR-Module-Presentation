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
    actions
    {
        addlast(Processing)
        {
            action(CalculateLoyaltyPoints)
            {
                Caption = 'Calculate Loyalty Points';
                Image = Calculate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoyaltyHandler: Codeunit "NVR Loyalty Points Handler";
                begin
                    Rec:= LoyaltyHandler.CalculateLoyaltyPoints(Rec);
                    Message('Loyalty points and levels have been updated for all customers.');
                end;
            }
        }
    }

    local procedure GetLoyaltyPoints(): Integer
    var 
        CustomerLoyaltyCalc : Codeunit "NVR Loyalty Points Handler";
        CalcLoyaltyPoint : Record "NVR Customers";
    begin
        CalcLoyaltyPoint := CustomerLoyaltyCalc.CalculateLoyaltyPoints(Rec);
        exit(CalcLoyaltyPoint."Loyalty Points");
    end;
    local procedure GetLoyaltyLevel(): Enum "NVR Loyalty Level"
    var 
        CustomerLoyaltyCalc : Codeunit "NVR Loyalty Points Handler";
        CalcLoyaltyLevel : Record "NVR Customers";
    begin
         CalcLoyaltyLevel := CustomerLoyaltyCalc.CalculateLoyaltyPoints(Rec);
         exit(CalcLoyaltyLevel."Loyalty Level");
    end;
}