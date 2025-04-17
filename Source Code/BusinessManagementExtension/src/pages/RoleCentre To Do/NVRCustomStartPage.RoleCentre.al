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

            group(OverviewActivities)
            {
                Caption = 'Overview';
                part(Overview; "NVR Overview Activities")
                {
                    Caption = 'Overview Activities';
                    ApplicationArea = All;
                }
            }
            //can add a graph that helps represent the group (Overview)
            //It can show a pie or bar graph that shows the difference between the totalnumber of sales orders, invoices and payments
            group(FinanceActivitiesGroup)
            {
                Caption = 'Finance Activities';
                part(Finance; "NVR Finance Activities")
                {
                    Caption = 'Finance Activities';
                    ApplicationArea = All;
                }
            }
            //can add a graph that helps represent the group (Finances)
            group(SalesActivitiesGroup)
            {
                Caption = 'Sales Activities';
                part(Sales; "NVR Sales Activities")
                {
                    Caption = 'Sales Activities';
                    ApplicationArea = All;
                }
            }
            //can add a graph that helps represent the group (Sales)
            //can add a listpart that shows the top customer loyalty leaderboard
            //can then have a pie chart that shows the top 10 customers by paid sales orders
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