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
            action(NewProductCategory)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Product Category Card", Rec);
                end;
            }
        }
    }
}
/*Requires Testing and better refinement*/