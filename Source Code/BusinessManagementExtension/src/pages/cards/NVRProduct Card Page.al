page 50121 "NVR Product Card"
{
    PageType = Card;
    SourceTable = "NVR Products";

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
                    trigger OnValidate()
                    begin
                        //check if the name is valid (optional)
                    end;
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
                    trigger OnValidate()
                    begin
                        //check if its numeric
                        //defencive programming to check if the price is in the correct format and is also not unnormally far in the future or past
                    end;
                }
                field("NVR Stock Quantity"; Rec.StockQuantity)
                {
                    Caption = 'Stock Quantity';
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        //check if its numeric
                        //defencive programming to check if the quantity is in the correct format and is also not unnormally far in the future or past
                    end;

                }
                field("NVR Description"; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = false;
                    trigger OnValidate()
                    begin
                        //check if the description is valid (optional)
                    end;

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
    }
}
