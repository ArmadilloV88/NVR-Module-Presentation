page 50101 "Product List"
{
    PageType = List;
    SourceTable = "Product";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product ID"; "Product ID")
                {
                    ApplicationArea = All;
                }

                field("Name"; "Name")
                {
                    ApplicationArea = All;
                }

                field("Category"; "Category")
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
            action(NewProduct)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Pages."Product Card");
                end;
            }
        }
    }
}
