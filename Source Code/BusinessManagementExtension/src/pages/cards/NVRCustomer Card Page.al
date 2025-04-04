page 50107 "Customer Card"
{
    PageType = Card;
    SourceTable = "Customer";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Customer ID"; "Customer ID")
                {
                    ApplicationArea = All;
                }

                field("Name"; "Name")
                {
                    ApplicationArea = All;
                }

                field("Address"; "Address")
                {
                    ApplicationArea = All;
                }

                field("City"; "City")
                {
                    ApplicationArea = All;
                }

                field("Country/Region"; "Country/Region")
                {
                    ApplicationArea = All;
                }

                field("Phone"; "Phone")
                {
                    ApplicationArea = All;
                }

                field("Email"; "Email")
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
                    Message('Customer saved successfully!');
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
