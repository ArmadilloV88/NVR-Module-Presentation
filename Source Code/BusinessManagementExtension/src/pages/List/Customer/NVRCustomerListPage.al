/*
###COMMENTS###

##############
*/
page 50100 "NVR Customer List"
{
    Caption = 'Customer List';
    ApplicationArea = All;
    PageType = List;
    SourceTable = "NVR Customers";
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Customers)
            {
                field("NVR Customer ID"; Rec.CustomerID)
                {
                    Caption = 'Customer ID';
                    Editable = false;
                    ApplicationArea = All;
                }

                field("NVR Name"; Rec.Name)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(CustomerInfo; "NVR Customer Info FactBox")
            {
                ApplicationArea = All;
                Caption = 'Customer Info';
                SubPageLink = "CustomerID" = FIELD(CustomerID);
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(EditCustomer)
            {
                Caption = 'Edit Customer';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"NVR Customer Card");
                end;
            }

            action(DeleteCustomer)
            {
                Caption = 'Delete Customer';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustomerRecord: Record "NVR Customers"; 
                begin
                    if Rec.CustomerID = '' then
                        Error('The Customer ID is not available. Please ensure a valid customer is selected.');

                    CustomerRecord.SetRange("CustomerID", Rec.CustomerID);

                    if not CustomerRecord.FindFirst() then
                        Message('No customer found with the selected ID.');

                    if not Confirm('Are you sure you want to delete the customer %1?', false, Rec.Name) then
                        exit;

                    CustomerRecord.Delete();
                    Message('Customer %1 has been deleted successfully.', Rec.Name);
                end;
            }
        }
    }
}
