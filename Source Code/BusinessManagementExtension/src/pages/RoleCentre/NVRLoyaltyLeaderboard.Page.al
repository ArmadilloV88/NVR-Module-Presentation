page 50132 "NVR CustomerLytLeaderboard"
{
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "NVR Customers";
    SourceTableView = SORTING("Loyalty Points") ORDER(Descending) WHERE("Loyalty Points" = filter(>= 0));
    Caption = 'Customer Loyalty Leaderboard';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."CustomerID") { Caption = 'Customer No.'; }
                field(Name; Rec.Name) { Caption = 'Customer Name'; }
                field("Loyalty Points"; Rec."Loyalty Points") { Caption = 'Loyalty Points'; }
                field("Loyalty Level"; Rec."Loyalty Level")
                {
                    Caption = 'Loyalty Level';
                    ApplicationArea = All;
                    Style = Strong; // Makes the text bold
                    //StyleExpr = GetLoyaltyLevelStyle(); // Applies conditional styling
                }
            }
        }
    }
    actions{
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
    }
}