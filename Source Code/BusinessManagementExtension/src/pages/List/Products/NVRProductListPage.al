page 50105 "NVR Product List"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;
    Caption = 'Products List';
    PageType = List;
    SourceTable = "NVR Products";

    layout
    {
        area(content)
        {
            repeater(products)
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
                    Editable = false;
                }
                field("NVR Category ID"; Rec.CategoryID)
                {
                    Caption = 'Category ID';
                    ApplicationArea = All;
                    Editable = false;
                    //we need to show the category name instead of the ID
                    TableRelation = "NVR Product Categories".CategoryID;
                }
                field("NVR Unit Price"; Rec.UnitPrice)
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Stock Quantity"; Rec.StockQuantity)
                {
                    Caption = 'Stock Quantity';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Description"; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(NewProduct)
            {
                Caption = 'New Product';
                Image = NewItem;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Card");
                end;
            }
            action(ViewProduct)
            {
                Caption = 'Edit Product';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Card", Rec);
                end;
            }
            action(DeleteProduct)
            {
                Caption = 'Delete Product';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // Code to delete the selected product
                    if Rec.Delete() then
                        Message('Product deleted successfully.');
                end;
            }
        }
        area(Processing)
        {
            action(AddProductCategory)
            {
                Caption = 'Add Product Category';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Category Card");
                end;
            }
            action(ViewProductCategory)
            {
                Caption = 'View Product Category';
                Image = View;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Category List");
                end;
            }
            /*action(EditProductCategory)
            {
                Caption = 'Edit Product Category';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Category Card", Rec);
                end;
            }
            action(DeleteProductCategory)
            {
                Caption = 'Delete Product Category';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // Code to delete the selected product category
                    if Rec.Delete() then
                        Message('Product category deleted successfully.');
                        Close();
                end;
            }*/
        }
    }
}
/*Requires Testing and better refinement*/