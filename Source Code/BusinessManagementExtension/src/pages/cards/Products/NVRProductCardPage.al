page 50121 "NVR Product Card"
{
    PageType = Card;
    SourceTable = "NVR Products";
    Editable = true;
    Caption = 'Product Card';
    ApplicationArea = All;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            group(Product)
            {
                field("NVR Product ID"; Rec.ProductID)
                {
                    Caption = 'Product ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NVR Product Name"; rec.ProductName)
                {
                    Caption = 'Product Name';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                    //trigger OnValidate()
                    //begin
                        //check if the name is valid (optional)
                    //end;
                }
                field("NVR Category ID"; Rec.CategoryID)
                {
                    Caption = 'Category ID';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                    //we need to show the category name instead of the ID
                    TableRelation = "NVR Product Categories".CategoryID;
                }
                field("NVR Unit Price"; Rec.UnitPrice)
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                    Editable = true;
                    //trigger OnValidate()
                    //begin
                        //check if its numeric
                        //defencive programming to check if the price is in the correct format and is also not unnormally far in the future or past
                    //end;
                }
                field("NVR Stock Quantity"; Rec.StockQuantity)
                {
                    Caption = 'Stock Quantity';
                    ApplicationArea = All;
                    Editable = true;
                    //trigger OnValidate()
                    //begin
                        //check if its numeric
                        //defencive programming to check if the quantity is in the correct format and is also not unnormally far in the future or past
                    //end;

                }
                field("NVR Description"; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = false;
                    //trigger OnValidate()
                    //begin
                        //check if the description is valid (optional)
                    //end;

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
                    // Save the record and close the page
                    Rec.Modify(true);
                    // Show a message to the user and optionally have a confirm and cancel button in it
                    Message('Product saved successfully!');
                    Close;
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
        area(Processing)
        {
            action(AddProductCategory)
            {
                Caption = 'Add Product Category';
                Image = Add;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Category Card"); // Opens the product category card page for adding a product category
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        Product: Record "NVR Products";
        NewID: Code[20];
        Counter: Integer;
    begin
        if Rec.ProductID = '' then begin
            Counter := 0;
            repeat
                // Generate a unique ID (e.g., "PROD" + a counter)
                Counter := Counter + 1;
                NewID := 'PROD' + PadStr(Format(Counter), 16, '0'); // Prefix with "PROD" and pad with zeros to fit within 20 characters
            until not Product.Get(NewID); // Ensure the ID does not already exist

            Rec.ProductID := NewID; // Assign the unique ID to the ProductID field

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
