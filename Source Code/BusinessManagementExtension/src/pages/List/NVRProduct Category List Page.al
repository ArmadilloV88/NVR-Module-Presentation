page 50106 "NVR Product Category List"
{
    Caption = 'Product Categories List';
    PageType = List;
    SourceTable = "NVR Product Categories";

    layout
    {
        area(content)
        {
            repeater(Categories)
            {
                field("NVR CategoryID"; Rec.CategoryID)
                {
                    Caption = 'Category ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR CategoryName"; Rec.CategoryName)
                {
                    Caption = 'Category Name';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Description"; rec.Description)
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
        area(processing)
        {
            action(EditProductCategory)
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
                    if Confirm('Are you sure you want to delete this product category?') then begin
                        Rec.Delete();
                        Message('Product category deleted successfully.');
                    end;
                end;
            }
        }
        area(Creation)
        {
            action(NewProductCategory)
            {
                Caption = 'New Product Category';
                Image = New;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Category Card");
                end;
            }
        }
    }
}
/*Requires Testing and better refinement*/