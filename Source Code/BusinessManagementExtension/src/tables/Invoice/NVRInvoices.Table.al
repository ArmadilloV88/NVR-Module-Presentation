table 50102 "NVR Invoices"
{
    DataClassification = CustomerContent;
    Caption = 'Invoices', MaxLength = 30;
    TableType = Normal;

    fields
    {
        field(501021; InvoiceID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice ID';
            NotBlank = true;
            Editable = false;
        }
        field(501022; SalesOrderID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order ID';
            NotBlank = true;
            Editable = true;
            TableRelation = "NVR Sales Orders".SalesOrderID;
        }
        field(501023; InvoiceDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Date';
            NotBlank = true;
            Editable = true;
        }
        field(501024; DueDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
            NotBlank = true;
            Editable = true;
        }
        field(501025; InvoiceAmount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Due';
            Editable = true;
        }
        field(501026; Currency; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency';
            NotBlank = true;
            Editable = true;
            TableRelation = Currency.Code;
        }
        field(501027; Status; Enum "NVR PaymentStatusEnum")
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Status';
            NotBlank = true;
            Editable = false; // Make this field non-editable by the user

            trigger OnValidate()
            begin
                // Dynamically calculate the StatusStyle whenever the Status changes
                case Status of
                    Enum::"NVR PaymentStatusEnum"::Paid:
                        StatusStyle := 'Favorable'; // Green for Paid
                    Enum::"NVR PaymentStatusEnum"::NotPaid:
                        StatusStyle := 'UnFavorable'; // Red for Not Paid
                    Enum::"NVR PaymentStatusEnum"::PartiallyPaid:
                        StatusStyle := 'Attention'; // Orange for Partially Paid
                    else
                        StatusStyle := ''; // Default style
                end;
            end;
        }
        field(501028; AmountPaid; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Paid';
            Editable = true;
        }
        field(501029; "RemAmtToBePaidToInvoice"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining Amount to Be Paid';
            Editable = false; // Make this field non-editable
        }
        field(501030; StatusStyle; Text[30])
        {
            Caption = 'Status Style';
            Editable = false; // This field is calculated and not editable
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; InvoiceID)
        {
            Clustered = true;
        }
        key(FK1; SalesOrderID)
        {
            Clustered = false;
        }
    }

    
        Trigger OnInsert()
        var
            SalesOrderStatusUpdater: Codeunit "NVR Sales Order Status Updater";
            //SalesOrderRecord: Record "NVR Sales Orders";
        begin
            // Trigger the update for the related sales order
            //SalesOrderRecord.Get(Rec.SalesOrderID);
            SalesOrderStatusUpdater.UpdateSalesOrderStatus(UpdateSalesOrderStatusByID(Rec.SalesOrderID));
        end;

        Trigger OnModify()
        var
            SalesOrderStatusUpdater: Codeunit "NVR Sales Order Status Updater";
        begin
            // Trigger the update for the related sales order
            SalesOrderStatusUpdater.UpdateSalesOrderStatus(UpdateSalesOrderStatusByID(Rec.SalesOrderID));
        end;

        Trigger OnDelete()
        var
            SalesOrderStatusUpdater: Codeunit "NVR Sales Order Status Updater";
        begin
            // Trigger the update for the related sales order
            SalesOrderStatusUpdater.UpdateSalesOrderStatus(UpdateSalesOrderStatusByID(Rec.SalesOrderID));
        end;
        local procedure UpdateSalesOrderStatusByID(SalesOrderID: Code[20]) : Record "NVR Sales Orders"
        var
            SalesOrderRecord: Record "NVR Sales Orders";
            SalesOrderStatusUpdater: Codeunit "NVR Sales Order Status Updater";
        begin
            // Retrieve the sales order record based on the SalesOrderID
            if SalesOrderRecord.Get(SalesOrderID) then begin
                // Update the sales order status using the codeunit
                exit(SalesOrderRecord); // Return the updated sales order record
            end else begin
                // Handle the case where the sales order is not found
                //Error('Sales Order with ID %1 not found.', SalesOrderID);
            end;
        end;
}