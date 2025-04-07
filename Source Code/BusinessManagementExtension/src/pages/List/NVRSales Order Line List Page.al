page 50104 "NVR Sales Order Line List"
{
    Caption = 'Sales Order Line List';
    PageType = List;
    SourceTable = "NVR Sales Order Line";

    layout
    {
        area(content)
        {
            repeater(SalesOrderLines)
            {
                field("NVR Sales Order Line ID"; Rec."Sales Order Line ID")
                {
                    Caption = 'Sales Order Line ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Current Amount"; Rec."Line Amount")
                {
                    Caption = 'Current Line Amount';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Line Budget"; LineMaxBudget)
                {
                    Caption = 'Line Max. Budget';
                    ApplicationArea = All;
                    Editable = false; // This field is calculated and should not be editable
                }

                field("NVR Remaining Budget"; RemainingBudget)
                {
                    Caption = 'Remaining Budget';
                    ApplicationArea = All;
                    Editable = false; // This field is calculated and should not be editable
                    Style = Unfavorable; // Red text
                    StyleExpr = IsOverBudget; // Apply style if over budget
                }
            }
            part(SalesOrderLineProductsPart; "NVR Sls. Ord. Line Prdt.")
            {
                SubPageLink = "Sales Order Line ID" = field("Sales Order Line ID");
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(NewSalesOrderLine)
            {
                Caption = 'New Sales Order Line';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order Line Card");
                end;
            }
            action(ViewSalesOrderLine)
            {
                Caption = 'View Sales Order Line';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Sales Order Line Card", Rec);
                end;
            }
            action(AddProduct)
            {
                Caption = 'Add Product to Order Line';
                Image = Add;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ProductAdditionRecord: Record "NVR SalesOrderLineProducts"; // Replace with the correct table for the NVR Product Addition page
                begin
                    // Check if the current budget exceeds the max budget
                    if TotalLineAmount > LineMaxBudget then begin
                        Message('Cannot add a product. The current budget (%1) exceeds the maximum budget (%2).', Format(TotalLineAmount), Format(LineMaxBudget));
                        exit; // Prevent further execution
                    end;

                    // Initialize a new record for the Product Addition page
                    ProductAdditionRecord.Init();
                    ProductAdditionRecord."Sales Order Line ID" := Rec."Sales Order Line ID"; // Pass the selected Sales Order Line ID
                    ProductAdditionRecord.Insert(false); // Insert the record into the database

                    // Commit the transaction to avoid locking issues
                    COMMIT;

                    // Open the Product Addition page with the new record
                    Page.RunModal(Page::"NVR Product Addition", ProductAdditionRecord);
                end;
            }
        }
        area(Processing)
        {
            action(ViewSalesOrder)
            {
                Caption = 'View Sales Order';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesOrder: Record "NVR Sales Orders";
                begin
                    if SalesOrder.Get(Rec.SalesOrderID) then
                        Page.RunModal(Page::"NVR Sales Order Card", SalesOrder)
                    else
                        Message('The Sales Order with ID %1 does not exist.', Rec.SalesOrderID);
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
    }

    var
        TotalLineAmount: Decimal;
        LineMaxBudget: Decimal;
        RemainingBudget: Decimal;
        IsOverBudget: Boolean;

    trigger OnAfterGetRecord()
    begin
        RecalculateSalesOrderLine();
    end;

    procedure RecalculateSalesOrderLine()
    var
        SalesOrder: Record "NVR Sales Orders";
        SalesOrderLineProducts: Record "NVR SalesOrderLineProducts";
    begin
        TotalLineAmount := 0; // Reset the total
        LineMaxBudget := 0; // Reset the max budget
        RemainingBudget := 0; // Reset the remaining budget

        // Sum up the Line Amount from related products
        SalesOrderLineProducts.SetRange("Sales Order Line ID", Rec."Sales Order Line ID");
        if SalesOrderLineProducts.FindSet() then
            repeat
                TotalLineAmount += SalesOrderLineProducts."Line Amount";
            until SalesOrderLineProducts.Next() = 0;

        Rec."Line Amount" := TotalLineAmount; // Update the Line Amount field with the calculated total

        // Fetch the total amount from the Sales Order table
        if SalesOrder.Get(Rec.SalesOrderID) then
            LineMaxBudget := SalesOrder."TotalAmount"; // Assign the total amount to the LineMaxBudget variable

        // Calculate the remaining budget
        RemainingBudget := LineMaxBudget - TotalLineAmount;

        // Determine if the current sales order line is over budget
        IsOverBudget := TotalLineAmount > LineMaxBudget;
    end;
}