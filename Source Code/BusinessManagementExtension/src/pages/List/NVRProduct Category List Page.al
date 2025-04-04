page 50106 "Product Category List"
{
    PageType = List;
    SourceTable = "NVR Product Categories";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("CategoryID"; "CategoryID")
                {
                    ApplicationArea = All;
                }

                field("CategoryName"; "CategoryName")
                {
                    ApplicationArea = All;
                }

                field("Description"; "Description")
                {
                    ApplicationArea = All;
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
                    Page.RunModal(Pages."Product Category Card");
                end;
            }
        }
    }
}
