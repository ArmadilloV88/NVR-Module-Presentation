page 50101 "NVR Custom Role Center"
{
    PageType = RoleCenter;
    Caption = 'NVR Custom Role Center';
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            group(HeadlineGroup)
            {
                part(Headline; "NVR Welcoming Headline")
                {
                    Caption = 'Welcome to Navertica SA Role Center';
                    ApplicationArea = All;
                }
            }
            part (Graph;"Help And Chart Wrapper")
            {
                Caption = 'Help & Chart';
                ApplicationArea = All;
            }
            part(Activities; "Small Business Owner Act.")
            {
                Caption = 'Here are your main activities';
                ApplicationArea = All;
            }
            part(AnotherChart; "Opportunity Chart")
            {
                Caption = 'Opportunity Chart';
                ApplicationArea = All;
            }
            group(OverviewActivities)
            {
                Caption = 'Overview';
                part(Overview; "NVR Overview Activities")
                {
                    Caption = 'Loyalty overview activities';
                    ApplicationArea = All;
                }
            }
            part(FinanceChart; "Cash Flow Forecast Chart")
            {
                Caption = 'Cash Flow Forecast Chart';
                ApplicationArea = All;
            }
            group(FinanceActivitiesGroup)
            {
                Caption = 'Loyalty Finance Activities';
                part(Finance; "NVR Finance Activities")
                {
                    Caption = 'Finance Activities';
                    ApplicationArea = All;
                }
            }
            part(SalesChart; "Sales Pipeline Chart")
            {
                Caption = 'Sales Pipeline Chart';
                ApplicationArea = All;
            }
            //can add a graph that helps represent the group (Finances)
            group(SalesActivitiesGroup)
            {
                Caption = 'Loyalty Sales Activities';
                part(Sales; "NVR Sales Activities")
                {
                    Caption = 'Sales Activities';
                    ApplicationArea = All;
                }
            }
            part(LeaderBoard; "NVR CustomerLytLeaderboard")
            {
                Caption = 'Customer Loyalty Leaderboard';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(SalesOrder)
            {
                Caption = 'SalesOrders';
                action(ViewSalesOrders)
                {
                    Caption = 'View Sales Orders';
                    RunObject = Page "NVR Sales Order List";
                    ApplicationArea = All;
                }//works fine
            }
            group(Invoices)
            {
                Caption = 'Invoices';
                action(ViewInvoices)
                {
                    Caption = 'View Invoices';
                    RunObject = Page "NVR Invoice List";
                    ApplicationArea = All;
                }

            }
            group(Customers)
            {
                Caption = 'Customers';
                action(ViewCustomers)
                {
                    Caption = 'View Customers';
                    RunObject = Page "NVR Customer List";
                    ApplicationArea = All;
                }
            }
            group(Products)
            {
                Caption = 'Products';
                action(ViewProducts)
                {
                    Caption = 'View Products';
                    RunObject = Page "NVR Product List";
                    ApplicationArea = All;
                }
            }
        }
        // area(Creation)
        // {
        //     // action(NewCustomer)
        //     // {
        //     //     Caption = 'New Customer';
        //     //     Image = New;
        //     //     ApplicationArea = All;
        //     //     // trigger OnAction()
        //     //     // var
        //     //     //     CustomerRec: Record "NVR Customers";
        //     //     // begin
        //     //     //     Clear(CustomerRec); // Ensure it's a blank record
        //     //     //     Page.RunModal(Page::"NVR Customer Card");
        //     //     // end;
        //     //     RunObject = Page "NVR Customer Card";
        //     // }

        // }
        area(Reporting)
        {
            /*action(SalesReport)
            {
                Caption = 'Sales Report';
                RunObject = Report "Sales - Invoice";
                ApplicationArea = All;
            }*/
        }
    }
}