table 50101 "Sales Orders"
{
    DataClassification = ToBeClassified;
    
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
    }
    
    fieldgroups
    {
        // Add changes to field groups here
    }
    
    var
        myInt: Integer;
    
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