page 50100 "Product Category List"
{
    PageType = List;
    SourceTable = "Product Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category ID"; "Category ID")
                {
                    ApplicationArea = All;
                }

                field("Name"; "Name")
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
}
