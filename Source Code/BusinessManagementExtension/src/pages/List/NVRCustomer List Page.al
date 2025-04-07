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
        }

        area(Processing)
        {
            action(ViewSalesOrders)
            {
                Caption = 'View Sales Orders';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order List");
                end;
                //Need to add the page linking between customer and sales order list
            }
            action(DeleteSalesOrder)
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
            }
        }
    }
}