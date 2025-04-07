page 50122 "NVR Product Addition"
{
//this is used to do the actual addition of a product to the sales order line list by linking a product to a sales order line
    Caption = 'NVR Product Addition';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NVR SalesOrderLineProducts";
    
    layout
    {
        area(Content)
        {
            group(ProductAddition)
            {
                field("SalesOrderLineID"; Rec."Sales Order Line ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = "NVR Sales Order Line"."Sales Order Line ID";
                }
                field("Product"; Rec.ProductID)
                {
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = "NVR Products".ProductID;
                    trigger OnValidate()
                    var
                        Product: Record "NVR Products";
                    begin
                        if Product.Get(Rec.ProductID) then
                            Rec."Unit Price" := Product."UnitPrice" // Fetch the Unit Price from the product table
                        else
                            Error('The selected Product ID does not exist.');
                    end;
                }
                field("Quantity"; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    var
                        Product: Record "NVR Products";
                    begin
                        // Ensure the quantity does not exceed the available stock
                        if Product.Get(Rec.ProductID) then begin
                            if Rec.Quantity > Product."StockQuantity" then
                                Error('The quantity cannot exceed the available stock of %1.', Product."StockQuantity");
                        end;

                        // Recalculate the Line Amount
                        Rec."Line Amount" := Rec.Quantity * Rec."Unit Price";
                    end;

                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                    Editable = false;
                    //we need to pull the actual unit price of the product from the product table using the selected product id

                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        Rec."Line Amount" := Rec.Quantity * Rec."Unit Price"; // Calculate the total line amount
                    end;
                    //this is where the quantity multiplied by the unit price of a product
                }
            }
        }
    }
    
    actions
    {
        area(Navigation)
        {
            action(Confirm)
            {
                Caption = 'OK';
                Image = Approval;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // Check if the Sales Order Line ID is null or empty
                    if Rec."Sales Order Line ID" = '' then begin
                        Error('The Sales Order Line ID cannot be empty. Please select a valid Sales Order Line ID.');
                    end;

                    // Save the record and close the page
                    Rec.Modify(true);
                    Message('Product added to Sales Order Line successfully!');
                    Close();
                end;
            }
            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Close();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec."Sales Order Line ID" = '' then
            if Rec.FIND('-') then
                Rec."Sales Order Line ID" := Rec."Sales Order Line ID"; // Pre-fill the field with the first value in the range
    end;
}