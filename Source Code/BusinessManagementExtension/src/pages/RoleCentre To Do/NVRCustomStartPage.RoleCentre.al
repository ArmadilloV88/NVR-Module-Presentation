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
            part(Activities; "Small Business Owner Act.")
            {
                Caption = 'Here are main your activities';
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
            group(FinanceActivitiesGroup)
            {
                Caption = 'Loyalty Finance Activities';
                part(Finance; "NVR Finance Activities")
                {
                    Caption = 'Finance Activities';
                    ApplicationArea = All;
                }
            }
            part("FinancePerformance";"Finance Performance")
            {
                Caption = 'Finance Performance';
                ApplicationArea = All;
            }
            group(SalesActivitiesGroup)
            {
                Caption = 'Loyalty Sales Activities';
                part(Sales; "NVR Sales Activities")
                {
                    Caption = 'Sales Activities';
                    ApplicationArea = All;
                }
            }
            part("SalesPipeline"; "Sales Pipeline Chart")
            {
                Caption = 'Sales Pipeline Chart';
                ApplicationArea = All;
            }
            part("Sales&Relationships";"Sales & Relationship Mgr. Act.")
            {
                Caption = 'Sales & Relationship Manager Activities';
                ApplicationArea = All;
            }
            part("TopFiveSalesCustomers";"Help And Chart Wrapper")
            {
                Caption = 'Help And Chart Wrapper';
                ApplicationArea = All;
            }
            part(CustomerLoyaltyLeaderboard; "NVR CustomerLytLeaderboard")
            {
                Caption = 'Top Customer Loyalty Leaderboard';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(SalesDocuments)
            {
                Caption = 'Sales Documents';
                action(OpenSalesOrders)
                {
                    Caption = 'Open Sales Orders';
                    RunObject = Page "NVR Sales Order List";
                    ApplicationArea = All;
                }
                action(OpenInvoices)
                {
                    Caption = 'Open Invoices';
                    RunObject = Page "NVR Invoice List";
                    ApplicationArea = All;
                }
            }

            group(FinanceDocuments)
            {
                Caption = 'Finance Documents';
                action(OpenPayments)
                {
                    Caption = 'Open Payments';
                    RunObject = Page "NVR Payment List";
                    ApplicationArea = All;
                }
                action(OpenUnpaidInvoices)
                {
                    Caption = 'Open Unpaid Invoices';
                    RunObject = Page "NVR Invoice List";
                    ApplicationArea = All;
                }
            }
        }
//Next to finish develop is the functionality linking to the Rolecentre Page
        area(Creation)
        {
            action(AddSalesOrder)
            {
                Caption = 'Add Sales Order';
                RunObject = Page "Sales Order";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(AddInvoice)
            {
                Caption = 'Add Invoice';
                RunObject = Page "Sales Invoice";
                RunPageMode = Create;
                ApplicationArea = All;
            }
        }
        area(Processing)
        {
            group(General)
            {
                Caption = 'General';
                action(ShowAllCustomers)
                {
                    Caption = 'Show All Customers';
                    RunObject = Page "Customer List";
                    ApplicationArea = All;
                }
                action(ShowAllLoyaltyCustomers)
                {
                    Caption = 'Show All Customers in Loyalty Program';
                    Image = LineDiscount;
                    RunObject = Page "Customer List";
                    ApplicationArea = All;
                }

                action(ShowAllVendors)
                {
                    Caption = 'Show All Vendors';
                    RunObject = Page "Vendor List";
                    ApplicationArea = All;
                }
            }

        }

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