codeunit 50105 "NVR InvoiceHandler"
{
    SingleInstance = true;

    var 
        StoredSalesOrderID: Code[20];
        SalesOrderLineID: Code[20];
    
    procedure CalcRemainingAmount(SalesOrderID: Code[20]): Decimal
    var
        InvoiceRecord: Record "NVR Invoices";
        TotalInvoiceAmounts: Decimal;
        SalesOrderLineHandler : Codeunit "NVR SalesOrderLineHandler";
    begin
        TotalInvoiceAmounts := 0;
        if SalesOrderID <> '' then begin
            // Calculate the sum of all invoice amounts for the specified Sales Order ID
            InvoiceRecord.SetRange("SalesOrderID", SalesOrderID);
            if InvoiceRecord.FindSet() then
                repeat
                    TotalInvoiceAmounts += InvoiceRecord."InvoiceAmount";
                until InvoiceRecord.Next() = 0;
            exit(SalesOrderLineHandler.GetSalesOrderTotal(SalesOrderID) - TotalInvoiceAmounts);    
        end else begin
            exit(0);
        end;

        

        
    end;

    procedure SetSalesOrderID(SalesOrderID: Code[20])
    begin
        StoredSalesOrderID := SalesOrderID;
    end;

    procedure GetSalesOrderID(): Code[20]
    begin
        exit(StoredSalesOrderID);
    end;
}