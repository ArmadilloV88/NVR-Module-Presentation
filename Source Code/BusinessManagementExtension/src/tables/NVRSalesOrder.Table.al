table 50101 "Sales Orders"
{
    DataClassification = ToBeClassified;
    Caption = 'Sales Orders', MaxLength = 30;
    TableType = Normal;

    fields
    {
        field(501011;SalesOrderID; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Order ID';
            NotBlank = true;
            Editable = false;
        }
        field(501012;CustomerID; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer ID';
            NotBlank = true;
            Editable = false;
            TableRelation = "NVR Customers".CustomerID;
        }
        field(501013;OrderDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Date';
            NotBlank = true;
            Editable = false;
        }
        field(501014; "Payment Status"; Enum "NVR PaymentStatusEnum")
        {
            InitValue = 0; // Not Paid
            DataClassification = ToBeClassified;
            Caption = 'Payment Status';
            NotBlank = true;
            Editable = false;
        }

        field(501015;TotalAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Amount';
            NotBlank = true;
            Editable = false;
        }
        field(501016;Currency; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency';
            NotBlank = true;
            Editable = false;
            TableRelation = Currency.Code;
        }

    }
    keys
    {
        key(PK; SalesOrderID)
        {
            Clustered = true;
        }
        key(FK1;CustomerID)
        {
            Clustered = false;
        }
        key(FK2;Currency)
        {
            Clustered = false;
        }
    }
    //might be used later for defencive programming
    trigger OnInsert()
    begin
        
    end;
    
    trigger OnModify()
    begin
        
    end;
    
    trigger OnDelete()
    begin
        
    end;
    
    trigger OnRename()
    begin
        
    end;
    
}