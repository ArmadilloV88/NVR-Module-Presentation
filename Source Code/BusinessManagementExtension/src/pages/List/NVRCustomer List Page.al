page 50106 "Customer List"
{
    PageType = List;
    SourceTable = "Customer";

    layout
    {
        area(content)
        {
            repeater(Group)
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
        area(processing)
        {
            action(NewCustomer)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Pages."Customer Card");
                end;
            }
        }
    }
}
