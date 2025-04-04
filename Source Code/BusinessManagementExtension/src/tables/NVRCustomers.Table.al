table 50100 "Customers"
{
    TableType = Normal;
    DataClassification = CustomerContent;
    Caption = 'Customers';
    
    fields
    {
        field(501001;CustomerID; Code[20])
        {
            Caption = 'Customer ID';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            NotBlank = true;
            Editable = false;
        }
        field(501002;Name; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
            TableRelation = Customer.Name;
            NotBlank = true;
            Editable = false;
        }
        field(501003;OrderDate; Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = false;
        }
        field(501004;TotalAmount; Decimal)
        {
            Caption = 'Order Amount';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = false;
        }
        field(501005;Status; Enum "NVRPaymentStatusEnum")
        {
            InitValue = 9; // Unknown
            Caption = 'Payment Status';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = false;
        }
    }
    
    keys
    {
        key(PK; CustomerID)
        {
            Clustered = true;
        }
    }
}