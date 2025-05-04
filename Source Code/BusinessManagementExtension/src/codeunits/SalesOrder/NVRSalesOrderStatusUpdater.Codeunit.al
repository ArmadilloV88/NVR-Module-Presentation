codeunit 50114 "NVR Sales Order Status Updater"
{
    Subtype = Normal;
    procedure UpdateSalesOrderStatus(SalesOrderRecord: Record "NVR Sales Orders")
    var
        InvoiceRecord: Record "NVR Invoices";
        TotalAmountPaid: Decimal;
    begin
        // Initialize the total amount paid
        TotalAmountPaid := 0;

        // Retrieve all invoices linked to the sales order
        InvoiceRecord.SetRange("SalesOrderID", SalesOrderRecord."SalesOrderID");
        if InvoiceRecord.FindSet() then
            repeat
                TotalAmountPaid += InvoiceRecord."AmountPaid";
            until InvoiceRecord.Next() = 0;
        if TotalAmountPaid >= SalesOrderRecord."TotalAmount" then begin
        SalesOrderRecord."Payment Status" := Enum::"NVR PaymentStatusEnum"::Paid;
        SalesOrderRecord."StatusStyle" := 'Favorable';
        end else if TotalAmountPaid > 0 then begin
            SalesOrderRecord."Payment Status" := Enum::"NVR PaymentStatusEnum"::PartiallyPaid;
            SalesOrderRecord."StatusStyle" := 'Attention';
        end else begin
            SalesOrderRecord."Payment Status" := Enum::"NVR PaymentStatusEnum"::NotPaid;
            SalesOrderRecord."StatusStyle" := 'UnFavorable';
        end;
        // Save the updated sales order record
        if SalesOrderRecord.Modify() then
            Commit(); // Ensure the changes are saved immediately
    end;
    procedure UpdateAllSalesOrders()
    var
        SalesOrderRecord: Record "NVR Sales Orders";
    begin
        // Loop through all sales orders and update their statuses
        if SalesOrderRecord.FindSet() then
            repeat
                UpdateSalesOrderStatus(SalesOrderRecord);
            until SalesOrderRecord.Next() = 0;
    end;
}