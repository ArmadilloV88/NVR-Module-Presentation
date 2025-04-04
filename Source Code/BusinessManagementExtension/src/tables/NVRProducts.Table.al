table 50105 "NVR Products"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(501051;ProductID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product ID';
            NotBlank = true;
            Editable = false;
        }
        field(501052;ProductName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Name';
            NotBlank = true;
            Editable = false;
        }
        field(501053;CategoryID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Category ID';
            NotBlank = true;
            Editable = false;
            TableRelation = "NVR Product Categories".CategoryID;
        }
        field(501054;UnitPrice; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
            NotBlank = true;
            Editable = false;
        }
        field(501055;StockQuantity; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Stock Quantity';
            NotBlank = true;
            Editable = false;
        }
        field(501056;Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            NotBlank = true;
            Editable = false;
        }
    }
    
    keys
    {
        key(PK; ProductID)
        {
            Clustered = true;
        }
        key(FK1;CategoryID)
        {
            Clustered = false;
        }
    }

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