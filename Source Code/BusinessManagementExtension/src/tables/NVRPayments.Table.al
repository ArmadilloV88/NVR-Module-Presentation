table 50103 "NVR Payments"
{
    DataClassification = CustomerContent;
    Caption = 'Payments', MaxLength = 30;
    TableType = Normal;
    
    fields
    {
        field(501031;PaymentID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment ID';
            NotBlank = true;
            Editable = false;
        }
        field(501032;InvoiceID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment ID';
            NotBlank = true;
            Editable = false;
            TableRelation = "NVR Invoices".InvoiceID;
        }
        field(501033;"Payment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Date';
            NotBlank = true;
            Editable = false;
        }
        field(501034;PaymentMethod; Enum "NVR PaymentMethods")
        {
            InitValue = 6; // Unknown
            DataClassification = CustomerContent;
            Caption = 'Payment Method';
            NotBlank = true;
            Editable = false;
        }
    }
    
    keys
    {
        key(PK; PaymentID)
        {
            Clustered = true;
        }
        key(FK1;InvoiceID)
        {
            Clustered = false;
        }
    }
    //Might be used later for defencive programming
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