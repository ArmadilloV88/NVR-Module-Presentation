table 50106 "NVR Product Categories"
{
    DataClassification = CustomerContent;
    Caption = 'Product Categories', MaxLength = 30;
    TableType = Normal;
    
    fields
    {
        field(501061;"CategoryID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Category ID';
            NotBlank = true;
            Editable = false;
        }
        field(501062;"CategoryName"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Category Name';
            NotBlank = true;
            Editable = false;
        }
        field(501063;"Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            NotBlank = true;
            Editable = false;
        }
    }
    
    keys
    {
        key(PK; CategoryID)
        {
            Clustered = true;
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