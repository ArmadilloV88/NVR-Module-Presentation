page 50115 "NVR Welcoming Headline"
{
    PageType = HeadlinePart;
    ApplicationArea = All;
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            field(Headline1; 'Welcome to the business loyalty portal ' + UserId)
            {
                //Caption = 'Welcoming';
                ApplicationArea = All;
                ToolTip = 'This is a custom role center made by Navertica SA.';
            }
            field(Headline2; 'Here you can find your activities and tasks.')
            {
                ApplicationArea = All;
                ToolTip = 'This is a custom role center made by Navertica SA.';
            }
        }
    }
}