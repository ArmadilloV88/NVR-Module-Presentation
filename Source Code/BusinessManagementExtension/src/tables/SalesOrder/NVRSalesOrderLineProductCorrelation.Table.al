table 50107 "NVR SalesOrderLineProducts"
//used to store the product to sales order list correlation
//specifies the relationship between the 2 tables
{
    DataClassification = CustomerContent;
    Caption = 'Sales Order Line Products', MaxLength = 30;
    TableType = Normal;

    fields
    {
        field(501071; EntryID; Integer)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(501072; SalesOrderID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order ID';
            TableRelation = "NVR Sales Orders".SalesOrderID;
        }
        field(501077; "Sales Order Line ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order Line ID';
            NotBlank = true;
            TableRelation = "NVR Sales Order Line"."Sales Order Line ID";
        }
        field(501073; ProductID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product ID';
            NotBlank = true;
            Editable = true;
            TableRelation = "NVR Products".ProductID;
        }
        field(501074; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            trigger OnValidate()
            begin
                ValidateProductTotalAgainstSalesOrder();
            end;
        }
        field(501075; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
            Editable = false;
            trigger OnValidate()
            begin
                ValidateProductTotalAgainstSalesOrder();
            end;
        }
        field(501076; "Product Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Price';
            Editable = false;
        }
    }

    keys
    {
        key(PK; EntryID)
        {
            Clustered = true;
        }
    }
    
        trigger OnInsert()
        begin
            // Call validation when a new product is added
            ValidateProductTotalAgainstSalesOrder();
        end;

        trigger OnModify()
        begin
            // Call validation when an existing product is modified
            ValidateProductTotalAgainstSalesOrder();
        end;
    

    procedure ValidateProductTotalAgainstSalesOrder()
    var
        SalesOrderLine: Record "NVR Sales Order Line";
        SalesOrder: Record "NVR Sales Orders";
        LineProducts: Record "NVR SalesOrderLineProducts";
        TotalProductValue: Decimal;
    begin
        // Get the related Sales Order Line
        if not SalesOrderLine.Get("Sales Order Line ID") then
            exit;

        // Get the parent Sales Order
        if not SalesOrder.Get(SalesOrderLine.SalesOrderID) then
            exit;

        // Initialize the total product value
        TotalProductValue := 0;

        // Sum all product values (Quantity * Unit Price) for the current Sales Order Line
        LineProducts.SetRange("Sales Order Line ID", "Sales Order Line ID");
        if LineProducts.FindSet() then
            repeat
                TotalProductValue += LineProducts.Quantity * LineProducts."Unit Price";
            until LineProducts.Next() = 0;

        // Check if the total value exceeds the Sales Order's total amount
        if TotalProductValue > SalesOrder.TotalAmount then
        Error(
            'The total value of products (%1) exceeds the allowed amount (%2). Adjust quantities or remove products.',
            Format(TotalProductValue),
            Format(SalesOrder.TotalAmount)
        );
    end;
}