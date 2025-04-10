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

    trigger OnInsert()
    begin
        // No automatic calculation of RemAmtToBePaidToInvoice here
    end;

    trigger OnModify()
    begin
        
    end;

    trigger OnDelete()
    begin
        // No automatic calculation of RemAmtToBePaidToInvoice here
    end;

    trigger OnRename()
    begin
        // No automatic calculation of RemAmtToBePaidToInvoice here
    end;
}