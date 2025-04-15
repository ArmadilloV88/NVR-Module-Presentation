page 50115 "NVR Welcoming Headline"
{
    PageType = HeadlinePart;
    ApplicationArea = All;
    UsageCategory = Administration;
    //SourceTable = TableName;
    
    layout
    {
        area(Content)
        {
            field(Headline1; 'Welcome to the custom Navertica SA role Center ' + UserId)
            {
                //Caption = 'Welcoming';
                ApplicationArea = All;
                ToolTip = 'This is a custom role center for Navertica SA.';
            }
            field(Headline2; 'Here you can find your activities and tasks.')
            {
                ApplicationArea = All;
                ToolTip = 'This is a custom role center for Navertica SA.';
            }
            field(Headline3; 'Your highest loyalty customer is "' + HighestLoyaltyCustomerName +'" with ' + Format(HighestLoyaltyCustomer."Loyalty Points") + ' loyalty points.')
            {
                ApplicationArea = All;
                ToolTip = 'This is a custom role center for Navertica SA.';
            }
        }
    }
    trigger OnOpenPage()
    begin
        HighestLoyaltyCustomer := GetHighestLoyaltyCustomer();

        HighestLoyaltyCustomerName := HighestLoyaltyCustomer.Name;
    end;
    var
        HighestLoyaltyCustomer: Record "NVR Customers";
        HighestLoyaltyCustomerName: Text[100];
    local procedure GetHighestLoyaltyCustomer(): Record "NVR Customers"
    var
        Handler : Codeunit "NVR RoleCentreHandler";
    begin
        exit(Handler.GetHighestLoyaltyCustomer())
    end;
}