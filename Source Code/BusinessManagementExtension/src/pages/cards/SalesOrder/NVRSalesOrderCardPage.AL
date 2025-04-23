page 50111 "NVR Sales Order Card"
{
    PageType = Card;
    SourceTable = "NVR Sales Orders";
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("NVR Customer ID"; rec.CustomerID)
                {
                    Caption = 'Customer ID';
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = "NVR Customers".CustomerID;
                }

                field("NVR Order Date"; Rec.OrderDate)
                {
                    Caption = 'Order Date';
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        //check if the date is the correct format
                    end;
                }

                field("NVR Total Amount"; Rec.TotalAmount)
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                    Editable = true;
                    DecimalPlaces = 2;
                }

                field("NVR Payment Status"; rec."Payment Status")
                {
                    Caption = 'Payment Status';
                    ApplicationArea = All;
                    Editable = false;
                    //need to ensure it shows the caption of the enum, similiar to a drop down list
                }

                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = Currency.Code;
                    //ensure that it shows the currency symbol or suffix example : ZAR
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
                    // Code to save the sales order details
                    // This will typically involve calling the table's Insert or Modify method
                    // and possibly validating the data before saving.
                    Rec.Modify(true);
                    Message('Sales Order saved successfully!');
                    close;
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
    procedure GetNewID()
    begin
        
    end;

    trigger OnOpenPage()
    var
        SalesOrder: Record "NVR Sales Orders";
        NewID: Code[20];
        Counter: Integer;
    begin
        if Rec.SalesOrderID = '' then begin
            Counter := 0;
            repeat
                // Generate a unique ID (e.g., "SO" + a counter)
                Counter := Counter + 1;
                NewID := 'SO' + PadStr(Format(Counter), 18, '0'); // Prefix with "SO" and pad with zeros to fit within 20 characters
            until not SalesOrder.Get(NewID); // Ensure the ID does not already exist

            Rec.SalesOrderID := NewID; // Assign the unique ID to the record

            if Rec.IsTemporary then begin
                Rec.Insert(); // Insert the record into the database if it's new
            end else begin
                Rec.Insert(true); // Insert the record into the database if it is not temporary
            end;

            // Reload the record to ensure the new key is displayed on the card
            if Rec.Get(NewID) then
                CurrPage.Update(); // Refresh the page to display the updated value
        end;
    end;
}
