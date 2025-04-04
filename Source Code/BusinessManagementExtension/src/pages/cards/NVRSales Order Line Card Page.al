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
                }

                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = "NVR Sales Orders".SalesOrderID;
                }

                field("NVR Product ID"; Rec.ProductID)
                {
                    Caption = 'Product IDs';
                    ApplicationArea = All;
                    Editable = false;
                    //TableRelation = "NVR Products".ProductID; // Links to the "Product ID" field in the base Product table
                    //we need to make another table for the products as we need to show a list of products in the Sales order line
                }

                field("NVR Quantity"; Rec.Quantity)
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
                }

                field("NVR Line Amount"; Rec."Line Amount")
                {
                    Caption = 'Total Line Amount';
                    ApplicationArea = All;
                    Editable = false;
                    //we need to ensure that each sales order line does not exceed the sales order amount. for example if you have 1 sales order that has an amount due of 30 000 and the sales order line thats made has an amount of 20 000 that means the left over is 10 000 and any sales order line that is made next musnt exceed 10 000 in order to respect the sales order amount. so the equation will be Remain = sales order amount -(sum of all sales order lines that reference the respective sales order).
                }
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
    trigger OnOpenPage()
    var
        SalesOrderLine: Record "NVR Sales Order Line";
        NewID: Code[20];
        Counter: Integer;
    begin
        if Rec."Sales Order Line ID" = '' then begin
            Counter := 0;
            repeat
                // Generate a unique ID (e.g., "SOL" + a counter)
                Counter := Counter + 1;
                NewID := 'SOL' + PadStr(Format(Counter), 17, '0'); // Prefix with "SOL" and pad with zeros to fit within 20 characters
            until not SalesOrderLine.Get(NewID); // Ensure the ID does not already exist

            Rec."Sales Order Line ID" := NewID; // Assign the unique ID to the record

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