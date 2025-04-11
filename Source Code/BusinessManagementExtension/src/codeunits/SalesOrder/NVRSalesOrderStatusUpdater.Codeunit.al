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

        // Update the payment status based on the total amount paid
        if TotalAmountPaid >= SalesOrderRecord."TotalAmount" then
            SalesOrderRecord."Payment Status" := Enum::"NVR PaymentStatusEnum"::Paid
        else if TotalAmountPaid > 0 then
            SalesOrderRecord."Payment Status" := Enum::"NVR PaymentStatusEnum"::PartiallyPaid
        else
            SalesOrderRecord."Payment Status" := Enum::"NVR PaymentStatusEnum"::NotPaid;

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