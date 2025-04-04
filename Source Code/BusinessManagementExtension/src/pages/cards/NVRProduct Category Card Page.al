page 50107 "Product Category Card"
{
    PageType = Card;
    SourceTable = "NVR Product Categories";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("CategoryID"; "CategoryID")
                {
                    ApplicationArea = All;
                    Editable = false;
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
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Message('Product Category saved successfully!');
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
