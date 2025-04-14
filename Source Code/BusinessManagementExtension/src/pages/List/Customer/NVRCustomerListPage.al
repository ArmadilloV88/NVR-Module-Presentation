page 50100 "NVR Customer List"
{
    //ModifyAllowed = false;
    Caption = 'Customer List';
    ApplicationArea = All;
    PageType = List;
    SourceTable = "NVR Customers";
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Customers)
            {
                field("NVR Customer ID"; Rec.CustomerID)
                {
                    Caption = 'Customer ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                
                field("NVR Name"; Rec.Name)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                /*redundant as the factbox shows the customer details
                field("NVR Email"; Rec.Email)
                {
                    Caption = 'Email Address';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Phone"; Rec.Phone)
                {
                    Caption = 'Phone Number';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Billing Address"; Rec."Billing Address")
                {
                    Caption = 'Billing Address';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Shipping Address"; Rec."Shipping Address")
                {
                    Caption = 'Shipping Address';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Payment Terms"; Rec."Payment Terms")
                {
                    Caption = 'Payment Terms';
                    Editable = false;
                    ApplicationArea = All;
                }*/
            }
        }
        area(FactBoxes)
        {
            part(CustomerInfo; "NVR Customer Info FactBox")
            {
                ApplicationArea = All;
                Caption = 'Customer Info';
                SubPageLink = "CustomerID" = FIELD(CustomerID);
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(NewCustomer)
            {
                Caption = 'New Customer';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Customer Card");
                end;
            }
            //will be replaced with a button in the base customer list
            action(EditCustomer)
            {
                Caption = 'Edit Customer';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Customer Card");
                end;
            }
            action(DeleteCustomer)
            {
                Caption = 'Delete Customer';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustomerRecord: Record "NVR Customers"; // Replace with the correct table for customers
                begin
                    // Ensure the Customer ID is available
                    if Rec.CustomerID = '' then begin
                        Error('The Customer ID is not available. Please ensure a valid customer is selected.');
                    end;

                    // Filter the Customer record by the selected Customer ID
                    CustomerRecord.SetRange("CustomerID", Rec.CustomerID);

                    // Check if there are any customers to delete
                    if not CustomerRecord.FindFirst() then begin
                        Message('No customer found with the selected ID.');
                        exit;
                    end;

                    // Confirm deletion
                    if not Confirm('Are you sure you want to delete the customer %1?', false, Rec.Name) then
                        exit;

                    // Delete the customer record
                    CustomerRecord.Delete();
                    Message('Customer %1 has been deleted successfully.', Rec.Name);
                end;
            }
            
        }

        area(Processing)
        {
            action(ViewSalesOrders)
            {
                Caption = 'View Sales Orders';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                var 
                    Handler : Codeunit "NVR SalesOrderHandler";
                begin
                    //Message('Customer ID to be passed: %1', Rec.CustomerID);
                    Handler.SetCustomerID(Rec.CustomerID); // Set the Customer ID in the handler
                    Page.RunModal(Page::"NVR Sales Order List");
                end;
                //Need to add the page linking between customer and sales order list
            }
            action(ViewProducts)
            {
                Caption = 'View Products';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product List"); // Opens the product list page
                end;
            }
            action(ViewSalesOrderLines)
            {
                Caption = 'View Sales Order Lines';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order Line List"); // Opens the sales order line list page
                end;
            }
            action(ViewProductCategories)
            {
                Caption = 'View Product Categories';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Category List"); // Opens the product category list page
                end;
            }
            /*action(ViewInvoices)
            {
                Caption = 'View Invoices';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Invoice List"); // Opens the invoice list page
                end;
            }*///Moved this over to the Sales Order List page as a button
            
            /*Phase 2
                View of Invoices - Christiaan
                View of Payments - Christiaan
                View of Loyalty points - Christiaan
                Extend the customer table in both Base customer table and NVR customer table to show loyalty level - Tiffany
                Customer Page List Extension (Use the customer list to show their loyalty level and to import their data to the NVR Customer table by a single button) - Christiaan
            Phase 3
                Top 10 loyalty customers - Christiaan
                Top 10 sales products - Christiaan
                Customer Loyalty Report - Tiffany
                Sales and Inventory Report - Tiffany
            Phase 4
                Import/Export of customer data - Tiffany
                Create a custome RoleCentre page to display cuegroups data using codeunits - Christiaan
            Phase 5
                Implement the assisted setup wizard - Christiaan
                Implement a specific role to access the extension (Role can be selected from the assisted setup or be created) - Tiffany
                Ensure 2 roles are created, 1 for inventory Mnaagement and 1 for sales management - Tiffany
            /*
            
            /*action(DeleteSalesOrder)
            {
                Caption = 'Delete Sales Order';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesOrderRecord: Record "NVR Sales Orders"; // Replace with the correct table for sales orders
                begin
                    // Ensure the Customer ID is available
                    if Rec.CustomerID = '' then begin
                        Error('The Customer ID is not available. Please ensure a valid customer is selected.');
                    end;

                    // Filter the Sales Order record by the selected Customer ID
                    SalesOrderRecord.SetRange("CustomerID", Rec.CustomerID);

                    // Check if there are any sales orders to delete
                    if not SalesOrderRecord.FindFirst() then begin
                        Message('No sales orders found for the selected customer.');
                        exit;
                    end;

                    // Confirm deletion
                    if not Confirm('Are you sure you want to delete the sales order for customer %1?', false, Rec.Name) then
                        exit;

                    // Delete the sales order
                    SalesOrderRecord.Delete();
                    Message('Sales order for customer %1 has been deleted successfully.', Rec.Name);
                end;
            }*/
        }
    }
}