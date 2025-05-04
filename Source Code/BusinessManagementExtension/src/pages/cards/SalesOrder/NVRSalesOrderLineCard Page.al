page 50114 "NVR Sales Order Line Card"
{
    //we might need to do this page differently as we need to show a list of products in the Sales order line
    Caption = 'Sales Order Line Card';
    PageType = Card;
    SourceTable = "NVR Sales Order Line";

    layout
    {
        area(content)
        {
            group(SalesOrderLine)
            {
                field("NVR Sales Order Line ID"; Rec."Sales Order Line ID")
                {
                    Caption = 'Sales Order Line ID';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = "NVR Sales Order Line"."Sales Order Line ID";
                }

                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = "NVR Sales Orders".SalesOrderID;
                }

                /*field("NVR Product ID"; Rec.ProductID)
                {
                    Caption = 'Product IDs';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = "NVR Products".ProductID; // Links to the "Product ID" field in the base Product table
                    //TableRelation = "NVR Products".ProductID; // Links to the "Product ID" field in the base Product table
                    //we need to make another table for the products as we need to show a list of products in the Sales order line
                }*/

                /*field("NVR Quantity"; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    ApplicationArea = All;
                    Editable = true;
                }

                field("NVR Unit Price"; Rec.Unitprice)
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                    Editable = false;
                }*/

                field("NVR Remaining Distribution"; GetDistributionRemaining(Rec.SalesOrderID, Rec."Sales Order Line ID"))
                {
                    Caption = 'Remaining Distribution';
                    ApplicationArea = All;
                    Editable = false;
                    //we need to ensure that the remaining distribution is not negative. if it is we need to throw an error.
                }
                field("NVR Line Amount"; Rec."Line Amount")
                {
                    Caption = 'Total sales order budget';
                    ApplicationArea = All;
                    Editable = true;
                    //we need to ensure that each sales order line does not exceed the sales order amount. for example if you have 1 sales order that has an amount due of 30 000 and the sales order line thats made has an amount of 20 000 that means the left over is 10 000 and any sales order line that is made next musnt exceed 10 000 in order to respect the sales order amount. so the equation will be Remain = sales order amount -(sum of all sales order lines that reference the respective sales order).
                }
                field("NVR Currency"; RetriveSalesOrderLineCurrency(Rec.SalesOrderID))
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                    //we need to ensure that the currency is the same as the sales order currency. if not we need to throw an error.
                }
            }
            part(SalesOrderLineProductsPart; "NVR Sls. Ord. Line Prdt.")
            {
                SubPageLink = "Sales Order Line ID" = field("Sales Order Line ID");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.Modify(true);
                    Message('Sales Order Line saved successfully!');
                    Close();
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Close;
                end;
            }
        }
    }

    local procedure RetriveSalesOrderLineCurrency(SalesOrderID : Code[20]) : Code[10]
    var
        SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
        currency: Code[10];
    begin
        currency := SalesOrderLineHandler.GetSalesOrderCurrency(SalesOrderID);
        if currency = '' then begin
            Error('Sales Order not found: %1', SalesOrderID);
        end;
        exit(currency);
    end;

    local procedure GetDistributionRemaining(SalesOrderID: Code[20]; SalesOrderLineID : Code[20]): Decimal
    var
        SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
        Remaining: Decimal;
    begin
        Remaining := SalesOrderLineHandler.GetRemainingDistibutionTotal(SalesOrderID);
        if Remaining < 0 then begin
            Error('The remaining distribution cannot be negative. Please check the sales order line.');
        end;
        exit(Remaining);
    end;

    trigger OnClosePage()
    var 
        SalesOrders: Record "NVR Sales Orders";
    begin
        if SalesOrders.Get(Rec.SalesOrderID) then begin
            if Rec."Line Amount" > SalesOrders.TotalAmount then begin
                Error('The sales order line amount cannot exceed the total sales order amount. Please check the sales order line.');
                Rec."Line Amount" := SalesOrders.TotalAmount; // Reset to the total amount of the sales order
            end;
        end else begin
            Error('Sales Order not found: %1', Rec.SalesOrderID);
        end;

    end;

    trigger OnOpenPage()
    var
        SalesOrderLine: Record "NVR Sales Order Line";
        SalesOrderLineHandler: Codeunit "NVR SalesOrderLineHandler";
        NewID: Code[20];
        Counter: Integer;
        Remaining: Decimal;
    begin
        // Get the remaining distribution amount
        Remaining := GetDistributionRemaining(SalesOrderLineHandler.GetSalesOrderID(), Rec."Sales Order Line ID");

        // Check if the remaining amount is 0 or less
        /*if Remaining <= 0 then
            Error('You cannot add any more Sales Order Lines. There is no available budget remaining for this Sales Order.');*/

        if Rec."Sales Order Line ID" = '' then begin
            Counter := 0;
            repeat
                // Generate a unique ID (e.g., "SOL" + a counter)
                Counter := Counter + 1;
                NewID := 'SOL' + PadStr(Format(Counter), 17, '0'); // Prefix with "SOL" and pad with zeros to fit within 20 characters
            until not SalesOrderLine.Get(NewID); // Ensure the ID does not already exist

            Rec."Sales Order Line ID" := NewID; // Assign the unique ID to the record

            Rec.SalesOrderID := SalesOrderLineHandler.GetSalesOrderID();

            if Rec.IsTemporary then begin
                Rec.Insert(); // Insert the record into the database if it's new
            end else begin
                Rec.Insert(true); // Insert the record into the database if it is not temporary
            end;

            // Reload the record to ensure the new key is displayed on the card
            if Rec.Get(NewID) then
                CurrPage.Update(); // Refresh the page to display the updated value
        end;
    end;
}