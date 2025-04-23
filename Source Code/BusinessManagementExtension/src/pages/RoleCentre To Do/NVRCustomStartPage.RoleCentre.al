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
            //can add a graph that helps represent the group (Sales)
            //can add a listpart that shows the top customer loyalty leaderboard
            //can then have a pie chart that shows the top 10 customers by paid sales orders
        }
    }

    actions
    {
        // area(Sections)
        // {
        //     group(SalesDocuments)
        //     {
        //         Caption = 'Sales Documents';
        //         action(OpenSalesOrders)
        //         {
        //             Caption = 'Open Sales Orders';
        //             RunObject = Page "NVR Sales Order List";
        //             ApplicationArea = All;
        //         }
        //         action(OpenInvoices)
        //         {
        //             Caption = 'Open Invoices';
        //             RunObject = Page "NVR Invoice List";
        //             ApplicationArea = All;
        //         }
        //     }

        //     // group(FinanceDocuments)
        //     // {
        //     //     Caption = 'Finance Documents';
        //     //     action(OpenPayments)
        //     //     {
        //     //         Caption = 'Open Payments';
        //     //         RunObject = Page "NVR Payment List";
        //     //         ApplicationArea = All;
        //     //     }
        //     //     action(OpenUnpaidInvoices)
        //     //     {
        //     //         Caption = 'Open Unpaid Invoices';
        //     //         RunObject = Page "NVR Invoice List";
        //     //         ApplicationArea = All;
        //     //     }
        //     // }
        // }

        // area(Creation)
        // {
        //     action(AddSalesOrder)
        //     {
        //         Caption = 'Add Sales Order';
        //         RunObject = Page "NVR Sales Order Card";
        //         RunPageMode = Create;
        //         ApplicationArea = All;
        //     }//works fine
        //     // action(AddInvoice)
        //     // {
        //     //     Caption = 'Add Invoice';
        //     //     RunObject = Page "NVR Invoice Document";
        //     //     RunPageMode = Create;
        //     //     ApplicationArea = All;
        //     // } will cause a break (weird bug)
        //     action(AddCustomer){
        //         Caption = 'Add Customer';
        //         RunObject = Page "NVR Customer Card";
        //         RunPageMode = Create;
        //         ApplicationArea = All;
        //     }
        //     // action(AddProduct){
        //     //     Caption = 'Add Product';
        //     //     RunObject = Page "NVR Product Card";
        //     //     RunPageMode = Create;
        //     //     ApplicationArea = All;
        //     // }will cause a break (similiar to the invoice action)
        //     // action(AddPayments){
        //     //     Caption = 'Add Payment';
        //     //     RunObject = Page "Payment Journal";
        //     //     RunPageMode = Create;
        //     //     ApplicationArea = All;
        //     // } will cause a break (similiar to the invoice action)
        // }
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