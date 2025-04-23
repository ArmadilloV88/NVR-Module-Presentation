table 50100 "NVR Customers"
{
    TableType = Normal;
    DataClassification = CustomerContent;
    Caption = 'Customers';
    DrillDownPageId = "NVR Customer List";
    
    fields
    {
        field(501001;CustomerID; Code[20])
        {
            Caption = 'Customer ID';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            NotBlank = true;
            //Editable = false;
        }
        field(501002;Name; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
            TableRelation = Customer.Name;
            NotBlank = true;
            //Editable = false;
            trigger OnValidate()
            begin
                //require Defencive coding (Cannot have numbers in it), also ensure that the name is pulled from the base application customer table
            end;
        }
        field(501003;Email; Text[100])
        {
            Caption = 'Customer Email';
            DataClassification = CustomerContent;
            NotBlank = true;
            //Editable = true;
            trigger OnValidate()
            begin
                //require Defencive coding (Must follow the email structure, use RegEx for that)
            end;
        }
        field(501004;Phone; Text[100])
        {
            Caption = 'Customer Phone';
            DataClassification = CustomerContent;
            NotBlank = false;
            //Editable = true;
            //TableRelation = Customer."Phone No.";
            trigger OnValidate()
            begin
                //require Defencive coding (Must follow the phone structure, use RegEx for that)
            end;
        }
        field(501005;"Billing Address"; Text[100])
        {
            Caption = 'Customer Billing Address';
            DataClassification = CustomerContent;
            NotBlank = true;
            //Editable = true;
            TableRelation = Customer.Address;
        }
        field(501006;"Shipping Address"; Text[100])
        {
            Caption = 'Customer Billing Address';
            DataClassification = CustomerContent;
            NotBlank = false;
            //Editable = true;
        }
        field(501007;"Payment Terms"; Enum "NVR PaymentTermsEnum")
        {
            InitValue = 21; // Unknown
            Caption = 'Payment Terms';
            DataClassification = CustomerContent;
            NotBlank = false;
            //Editable = true;
        }
    }
    
    keys
    {
        key(PK; CustomerID)
        {
            Clustered = true;
        }
        key(FK1; Phone)
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