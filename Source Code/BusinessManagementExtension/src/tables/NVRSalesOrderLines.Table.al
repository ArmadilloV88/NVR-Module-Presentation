table 50104 "NVR Sales Order Line"
{
    Caption = 'Sales Order Line';
    TableType = Normal;
    DataClassification = CustomerContent;
    
    fields
    {
        field(501041;"Sales Order Line ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order Line ID';
            NotBlank = true;
            Editable = false;
        }
        field(501042;SalesOrderID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order Line ID';
            NotBlank = true;
            Editable = false;
            TableRelation = "NVR Sales Orders".SalesOrderID;
        }
        field(501043;ProductID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product ID';
            NotBlank = true;
            Editable = false;
            TableRelation = "NVR Products".ProductID;

            // Validates to get unit price based of product ID
            trigger OnValidate()
            var
                Product : Record "NVR Products";
            begin
                if Product.Get("ProductID") then begin
                    Unitprice := Product."UnitPrice";
                end else begin
                    Unitprice := 0;
                end;
            end;
        }
        field(501044;Quantity; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            NotBlank = true;
            Editable = false;
        }
        field(501045;Unitprice; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
            NotBlank = true;
            Editable = false;
        }
    }
    
    keys
    {
        key(PK; "Sales Order Line ID")
        {
            Clustered = true;
        }
        key(FK1; "SalesOrderID")
        {
            Clustered = false;
        }
        key(FK2; "ProductID")
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