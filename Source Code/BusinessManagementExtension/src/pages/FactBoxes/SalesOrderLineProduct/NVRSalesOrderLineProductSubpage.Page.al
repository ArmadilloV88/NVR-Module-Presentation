page 50109 "NVR Sls. Ord. Line Prdt."
{
    
    PageType = ListPart;
    SourceTable = "NVR SalesOrderLineProducts";
    ApplicationArea = All;
    Caption = 'Products in Sales Order Line';

    layout
    {
        area(content)
        {
            repeater(Products)
            {
                field("Product ID"; Rec.ProductID)
                {
                    Caption = 'Product ID';
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    ApplicationArea = All;
                }

                field("Unit Price"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            /*action(AddProduct)
            {
                Caption = 'Add Product';
                Image = Add;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ProductAdditionRecord: Record "NVR SalesOrderLineProducts"; // Replace with the correct table for the NVR Product Addition page
                begin
                    Message('Sales Order Line ID: %1', Rec."Sales Order Line ID");
                    // Ensure the Sales Order Line ID is available
                    if Rec."Sales Order Line ID" = '' then begin
                        Error('The Sales Order Line ID is not available. Please ensure a valid Sales Order Line is selected.');
                    end;

                    // Initialize a new record for the Product Addition page
                    ProductAdditionRecord.Init();
                    ProductAdditionRecord."Sales Order Line ID" := Rec."Sales Order Line ID"; // Pass the correct Sales Order Line ID

                    // Open the Product Addition page with the new record
                    Page.RunModal(Page::"NVR Product Addition", ProductAdditionRecord);
                end;
            }*/
            action(DeleteProduct)
            {
                Caption = 'Delete Product';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesOrderLine: Record "NVR Sales Order Line";
                    SalesOrderLineProducts: Record "NVR SalesOrderLineProducts";
                begin
                    if Confirm('Are you sure you want to delete this product?') then begin
                        // Store the Sales Order Line ID before deleting the product
                        if SalesOrderLine.Get(Rec."Sales Order Line ID") then begin
                            Rec.Delete(); // Delete the current product record

                            // Recalculate the Sales Order Line
                            SalesOrderLineProducts.SetRange("Sales Order Line ID", SalesOrderLine."Sales Order Line ID");
                            SalesOrderLine."Line Amount" := 0; // Reset the Line Amount

                            if SalesOrderLineProducts.FindSet() then
                                repeat
                                    SalesOrderLine."Line Amount" += SalesOrderLineProducts."Line Amount";
                                until SalesOrderLineProducts.Next() = 0;

                            SalesOrderLine.Modify(); // Save the updated Sales Order Line

                            // Refresh the subpage to reflect changes
                            CurrPage.Update();

                            Message('Product deleted successfully, and Sales Order Line updated.');
                        end else
                            Error('The related Sales Order Line could not be found.');
                    end;
                end;
            }

            /*action(CalculateAmount)
            {
                Caption = 'Recalculate Line Amount';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec."Line Amount" := Rec.Quantity * Rec."Unit Price";
                    Rec.Modify();
                end;
            }*/
        }
    }

    trigger OnAfterGetRecord()
    var
        Product: Record "NVR Products";
    begin
        if Product.Get(Rec.ProductID) then begin
            Rec."Unit Price" := Product."UnitPrice";
            Rec."Line Amount" := Rec.Quantity * Rec."Unit Price";
        end;
    end;
}