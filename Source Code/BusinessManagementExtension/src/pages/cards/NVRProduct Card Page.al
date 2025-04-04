page 50102 "Product Card"
{
    PageType = Card;
    SourceTable = "Product";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Product ID"; "Product ID")
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

                field("Category"; "Category")
                {
                    ApplicationArea = All;
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
                    Message('Product saved successfully!');
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
