codeunit 50107 "NVR SalesOrderLineHandler"
{
    SingleInstance = true;

    var
        SalesOrderID: Code[20];

    procedure SetSalesOrderID(NewSalesOrderID: Code[20])
    begin
        Message('Setting Sales Order ID to %1', NewSalesOrderID);
        SalesOrderID := NewSalesOrderID;
    end;

    procedure GetSalesOrderID(): Code[20]
    begin
        Message('Getting Sales Order ID: %1', SalesOrderID);
        exit(SalesOrderID);
    end;

    procedure GetSalesOrderCurrency(SalesOrderID : Code[20]): Code[10]
    var
        SalesOrder : Record "NVR Sales Orders";
    begin
        if SalesOrder.Get(SalesOrderID) then begin
            exit(SalesOrder.Currency);
        end else begin
            Error('Sales Order not found: %1', SalesOrderID);
        end;
    end;
    procedure GetSalesOrderTotal(SalesOrderID : Code[20]): Decimal
    var 
        SalesOrder : Record "NVR Sales Orders";
        Total : Decimal;
    begin
        if SalesOrder.Get(SalesOrderID) then begin
            Total := SalesOrder.TotalAmount;
            exit(Total);
        end else begin
            Error('Sales Order not found: %1', SalesOrderID);
        end;
    end;

    procedure GetRemainingDistibutionTotal(SalesOrderID: Code[20]): Decimal
    var
        SalesOrders: Record "NVR Sales Orders";
        SalesOrderLine: Record "NVR Sales Order Line";
        Remaining: Decimal;
        TotalLineAmount: Decimal;
    begin
        // Check if the Sales Order exists
        if SalesOrders.Get(SalesOrderID) then begin
            // Initialize the total line amount
            TotalLineAmount := 0;

            // Filter Sales Order Lines by the given SalesOrderID
            SalesOrderLine.SetRange(SalesOrderID, SalesOrderID);

            // Sum up the Line Amounts for all Sales Order Lines
            if SalesOrderLine.FindSet() then
                repeat
                    TotalLineAmount += SalesOrderLine."Line Amount";
                until SalesOrderLine.Next() = 0;

            // Calculate the remaining amount
            Remaining := SalesOrders.TotalAmount - TotalLineAmount;

            // Return the remaining amount
            exit(Remaining);
        end else begin
            // Throw an error if the Sales Order is not found
            Error('Sales Order not found: %1', SalesOrderID);
        end;
    end;

    procedure CanAddMore(SalesOrderID: Code[20]; SalesOrderLineID: Code[20]): Boolean
    var
        SalesOrderLine: Record "NVR Sales Order Line";
        SalesOrder: Record "NVR Sales Orders";
        TotalLineAmount: Decimal;
    begin
        if SalesOrderLine.Get(SalesOrderLineID) then begin
            if SalesOrder.Get(SalesOrderID) then begin
                TotalLineAmount := 0;

                // Filter Sales Order Lines by the given SalesOrderID
                SalesOrderLine.SetRange(SalesOrderID, SalesOrderID);

                // Sum up the Line Amounts for all Sales Order Lines
                if SalesOrderLine.FindSet() then
                    repeat
                        TotalLineAmount += SalesOrderLine."Line Amount";
                    until SalesOrderLine.Next() = 0;

                // Check if the total line amount exceeds the sales order total amount
                exit(TotalLineAmount <= SalesOrder.TotalAmount);
            end else
                Error('Sales Order not found: %1', SalesOrderID);
        end else
            Error('Sales Order Line not found: %1', SalesOrderLineID);
    end;

    procedure CanAddMore(SalesOrderID: Code[20]): Boolean
    var
        SalesOrderLine: Record "NVR Sales Order Line";
        SalesOrder: Record "NVR Sales Orders";
        TotalLineAmount: Decimal;
    begin
        // Check if the Sales Order exists
        if SalesOrder.Get(SalesOrderID) then begin
            TotalLineAmount := 0;

            // Filter Sales Order Lines by the given SalesOrderID
            SalesOrderLine.SetRange(SalesOrderID, SalesOrderID);

            // Sum up the Line Amounts for all Sales Order Lines
            if SalesOrderLine.FindSet() then
                repeat
                    TotalLineAmount += SalesOrderLine."Line Amount";
                until SalesOrderLine.Next() = 0;

            // Check if the total line amount exceeds the sales order total amount
            exit(TotalLineAmount <= SalesOrder.TotalAmount);
        end else
            Error('Sales Order not found: %1', SalesOrderID);
    end;
    
    procedure GenerateUniqueSalesOrderLineID(): Code[20]
    var
        SalesOrderLine: Record "NVR Sales Order Line";
        NewID: Code[20];
        Counter: Integer;
    begin
        Counter := 0;
        repeat
            Counter := Counter + 1;
            NewID := 'SOL' + PadStr(Format(Counter), 17, '0'); // Prefix with "SOL" and pad with zeros
        until not SalesOrderLine.Get(NewID); // Ensure the ID does not already exist

        exit(NewID);
    end;
}