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
                    Editable = false;
                }

                field("NVR Remaining Budget"; RemainingLineBudget)
                {
                    Caption = 'Remaining Line Budget';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = IsOverBudget;
                }
                field("NVR Remaining Sales Order Amount"; CalculateLineRemainingAmount(Rec."Line Amount", LineMaxBudget))
                {
                    Caption = 'Remaining Sales Order Amount';
                    ApplicationArea = All;
                    Editable = false;
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
                var
                    SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
                    CanAdd: Boolean;
                begin
                    // Ensure a valid Sales Order is selected
                    if Rec.SalesOrderID = '' then
                        Rec.SalesOrderID := SalesOrderLineHandler.GetSalesOrderID(); // Get the Sales Order ID from the handler

                    // Check if a new line can be added
                    CanAdd := SalesOrderLineHandler.CanAddMore(Rec.SalesOrderID);
                    // if not CanAdd then
                    //     Error('Cannot add more lines to this Sales Order. The total line amount exceeds the sales order total amount.');

                    // Commit the transaction before opening the page
                    COMMIT;


                    // Open the Sales Order Line Card page
                    Page.RunModal(Page::"NVR Sales Order Line Card");
                end;
            }
            action(ViewSalesOrderLine)
            {
                Caption = 'Edit Sales Order Line';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // Commit the transaction before opening the page
                    COMMIT;

                    // Open the Sales Order Line Card page
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
        RemainingLineBudget: Decimal;
        IsOverBudget: Boolean;

    trigger OnOpenPage()
    var
        SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
        FilteredSalesOrderID: Code[20];
    begin
        // Get the Sales Order ID from the handler
        FilteredSalesOrderID := SalesOrderLineHandler.GetSalesOrderID();

        // Apply the filter only if a valid Sales Order ID is returned
        if FilteredSalesOrderID <> '' then
            Rec.SetRange(SalesOrderID, FilteredSalesOrderID)
        else
            Error('No valid Sales Order ID found. Please ensure a Sales Order is selected.');
    end;

    trigger OnAfterGetRecord()
    begin
        RecalculateSalesOrderLine();
    end;

    procedure CalculateLineRemainingAmount(CurrentAmount: Decimal; MaxAmount: Decimal): Decimal
    begin
        exit(MaxAmount - CurrentAmount);    
    end;

    procedure RecalculateSalesOrderLine()
    var
        SalesOrderLineProducts: Record "NVR SalesOrderLineProducts";
        TotalLineAmount: Decimal;
        SalesOrder : Record "NVR Sales Orders";
    begin
        TotalLineAmount := 0; // Reset the total
        LineMaxBudget := 0; // Reset the max budget
        RemainingLineBudget := 0; // Reset the remaining budget

        // Sum up the Line Amount from related products
        SalesOrderLineProducts.SetRange("Sales Order Line ID", Rec."Sales Order Line ID");
        if SalesOrderLineProducts.FindSet() then
            repeat
                TotalLineAmount += SalesOrderLineProducts."Product Total Amount";
            until SalesOrderLineProducts.Next() = 0;

        // Calculate values without modifying the record
        if SalesOrder.Get(Rec.SalesOrderID) then
            LineMaxBudget := SalesOrder."TotalAmount";

        RemainingLineBudget := LineMaxBudget - TotalLineAmount;
        IsOverBudget := TotalLineAmount > LineMaxBudget;
    end;
}
/*Requires Further Testing and better refinement*/
//Needs better logic overlay and refinement - Need to work with budget distribution to each sales order line



/*page 50104 "NVR Sales Order Line List"
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
                    Editable = false;
                }

                field("NVR Remaining Budget"; RemainingLineBudget)
                {
                    Caption = 'Remaining Line Budget';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = IsOverBudget;
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
                var
                    SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
                    CanAdd: Boolean;
                begin
                    // Ensure a valid Sales Order is selected
                    if Rec.SalesOrderID = '' then
                        Error('Please select a valid Sales Order.');

                    // Check if a new line can be added
                    CanAdd := SalesOrderLineHandler.CanAddMore(Rec.SalesOrderID, Rec."Sales Order Line ID");
                    if not CanAdd then
                        Error('Cannot add more lines to this Sales Order. The total line amount exceeds the sales order total amount.');

                    // Commit the transaction before opening the page
                    COMMIT;

                    // Open the Sales Order Line Card page
                    Page.RunModal(Page::"NVR Sales Order Line Card");
                end;
            }

            action(ViewSalesOrderLine)
            {
                Caption = 'Edit Sales Order Line';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // Commit the transaction before opening the page
                    COMMIT;

                    // Open the Sales Order Line Card page
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
                    ProductAdditionRecord: Record "NVR SalesOrderLineProducts";
                begin
                    // Check if the current budget exceeds the max budget
                    if TotalLineAmount > LineMaxBudget then
                        Error('Cannot add a product. The current budget (%1) exceeds the maximum budget (%2).', Format(TotalLineAmount), Format(LineMaxBudget));

                    // Initialize a new record for the Product Addition page
                    ProductAdditionRecord.Init();
                    ProductAdditionRecord."Sales Order Line ID" := Rec."Sales Order Line ID";
                    ProductAdditionRecord.Insert(false);

                    // Commit the transaction before opening the page
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
                        Error('The Sales Order with ID %1 does not exist.', Rec.SalesOrderID);
                end;
            }

            action(ViewProducts)
            {
                Caption = 'View Products';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product List");
                end;
            }
        }
    }

    var
        TotalLineAmount: Decimal;
        LineMaxBudget: Decimal;
        RemainingLineBudget: Decimal;
        IsOverBudget: Boolean;

    trigger OnAfterGetRecord()
    begin
        // Recalculate values without modifying the record
        RecalculateSalesOrderLine();
        CurrPage.Update(); // Refresh the page to reflect the updated values
    end;

    procedure UpdateRemainingAmount(): Decimal
    var
        SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
    begin
        exit(SalesOrderLineHandler.GetRemainingDistibutionTotal(Rec.SalesOrderID));
    end;

    trigger OnOpenPage()
    var
        SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
        FilteredSalesOrderID: Code[20];
    begin
        // Get the Sales Order ID from the handler
        FilteredSalesOrderID := SalesOrderLineHandler.GetSalesOrderID();

        // Apply the filter only if a valid Sales Order ID is returned
        if FilteredSalesOrderID <> '' then
            Rec.SetRange(SalesOrderID, FilteredSalesOrderID)
        else
            Error('No valid Sales Order ID found. Please ensure a Sales Order is selected.');
    end;

    procedure RecalculateSalesOrderLine()
    var
        SalesOrderLineProducts: Record "NVR SalesOrderLineProducts";
        TotalLineAmount: Decimal;
        SalesOrder : Record "NVR Sales Orders";
    begin
        TotalLineAmount := 0; // Reset the total
        LineMaxBudget := 0; // Reset the max budget
        RemainingLineBudget := 0; // Reset the remaining budget

        // Sum up the Line Amount from related products
        SalesOrderLineProducts.SetRange("Sales Order Line ID", Rec."Sales Order Line ID");
        if SalesOrderLineProducts.FindSet() then
            repeat
                TotalLineAmount += SalesOrderLineProducts."Product Total Amount";
            until SalesOrderLineProducts.Next() = 0;

        // Calculate values without modifying the record
        if SalesOrder.Get(Rec.SalesOrderID) then
            LineMaxBudget := SalesOrder."TotalAmount";

        RemainingLineBudget := LineMaxBudget - TotalLineAmount;
        IsOverBudget := TotalLineAmount > LineMaxBudget;
    end;
}*/
/*Requires Further Testing and better refinement*/
//Needs better logic overlay and refinement - Need to work with budget distribution to each sales order line