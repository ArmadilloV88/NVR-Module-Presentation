page 50101 "Product Card"
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
                    ToolTip = 'Select a Product Category';
                    trigger OnValidate()
                    begin
                        if "Category" = '' then
                            Error('Product Category must be assigned to the product.');
                    end;
                }
            }
        }
    }
}
