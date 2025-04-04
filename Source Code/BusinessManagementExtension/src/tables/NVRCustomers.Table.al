table 50100 "NVR Customers"
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
        //require Defencive coding (Cannot have numbers in it)
        field(501002;Name; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
            TableRelation = Customer.Name;
            NotBlank = true;
            Editable = true;
        }
        //require Defencive coding (Must follow the email structure, use RegEx for that)
        field(501003;Email; Text[100])
        {
            Caption = 'Customer Email';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = true;
            trigger OnValidate()
            begin

            end;
        }
        //require Defencive coding (Must follow the phone structure, use RegEx for that)
        field(501004;Phone; Text[100])
        {
            Caption = 'Customer Phone';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = true;
        }
        field(501005;"Billing Address"; Text[100])
        {
            Caption = 'Customer Billing Address';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = true;
        }
        field(501006;"Shipping Address"; Text[100])
        {
            Caption = 'Customer Billing Address';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = true;
        }
        field(501007;"Payment Terms"; Enum "NVR PaymentTermsEnum")
        {
            InitValue = 21; // Unknown
            Caption = 'Payment Terms';
            DataClassification = CustomerContent;
            NotBlank = true;
            Editable = true;
        }
    }
    
    keys
    {
        key(PK; CustomerID)
        {
            Clustered = true;
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