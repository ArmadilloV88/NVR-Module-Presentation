codeunit 50109 "NVR RoleCentreHandler"
{
    procedure GetnumberOfPaidSalesOrders(): Integer
    var
        SalesOrderRec: Record "NVR Sales Orders";
        OpenSalesOrdersCount: Integer;
    begin
        //search for all Sales orders with the Status type Paid
        SalesOrderRec.SetRange("Payment Status", Enum::"NVR PaymentStatusEnum"::Paid);
        if SalesOrderRec.FindSet() then begin
            repeat
                OpenSalesOrdersCount := OpenSalesOrdersCount + 1;
            until SalesOrderRec.Next() = 0;
        end;
        exit(OpenSalesOrdersCount);
    end;
    procedure GetnumberOfUnPaidSalesOrders(): Integer
    var
        SalesOrderRec: Record "NVR Sales Orders";
        OpenSalesOrdersCount: Integer;
    begin
        //search for all Sales orders with the Status type Not Paid
        SalesOrderRec.SetRange("Payment Status", Enum::"NVR PaymentStatusEnum"::NotPaid);
        if SalesOrderRec.FindSet() then begin
            repeat
                OpenSalesOrdersCount := OpenSalesOrdersCount + 1;
            until SalesOrderRec.Next() = 0;
        end;
        exit(OpenSalesOrdersCount);
    end;
    procedure GetTotalAmountofPaidInvoices(): Decimal
    var
        InvoicesRec: Record "NVR Invoices";
        TotalUnPaidAmount: Decimal;
    begin
        //search for all Invoices with the Status type Not Paid
        InvoicesRec.SetRange("Status", Enum::"NVR PaymentStatusEnum"::Paid);
        if InvoicesRec.FindSet() then begin
            repeat
                TotalUnPaidAmount := TotalUnPaidAmount + InvoicesRec."InvoiceAmount";
            until InvoicesRec.Next() = 0;
        end;
        exit(TotalUnPaidAmount);
    end;
    procedure GetTotalAmountofUnPaidInvoices(): Decimal
    var
        InvoicesRec: Record "NVR Invoices";
        TotalUnPaidAmount: Decimal;
    begin
        //search for all Invoices with the Status type Not Paid
        InvoicesRec.SetRange("Status", Enum::"NVR PaymentStatusEnum"::NotPaid);
        if InvoicesRec.FindSet() then begin
            repeat
                TotalUnPaidAmount := TotalUnPaidAmount + InvoicesRec."InvoiceAmount";
            until InvoicesRec.Next() = 0;
        end;
        exit(TotalUnPaidAmount);
    end;
    procedure GetHighestLoyaltyCustomer(): Record "NVR Customers"
    var
        CustomerRec: Record "NVR Customers";
        LoyaltyPointsHandler: Codeunit "NVR Loyalty Points Handler";
        HighestLoyaltyCustomer: Record "NVR Customers";
        CurrentLoyaltyPoints: Integer;
        MaxLoyaltyPoints: Integer;
    begin
        MaxLoyaltyPoints := 0;

        // Loop through all customers in the NVR Customers table
        if CustomerRec.FindSet() then begin
            repeat
                // Calculate loyalty points for the current customer
                CurrentLoyaltyPoints := LoyaltyPointsHandler.CalculateLoyaltyPoints(CustomerRec)."Loyalty Points";

                // Check if the current customer has the highest loyalty points
                if CurrentLoyaltyPoints > MaxLoyaltyPoints then begin
                    MaxLoyaltyPoints := CurrentLoyaltyPoints;
                    HighestLoyaltyCustomer := CustomerRec; // Store the customer with the highest points
                end;
            until CustomerRec.Next() = 0;
        end;

        // Return the customer with the highest loyalty points
        exit(HighestLoyaltyCustomer);
    end;
    procedure GetTotalNumberofSalesOrders(): Integer
    begin
        //search for all Sales orders with the Status type Not Paid
        exit(GetnumberOfPaidSalesOrders() + GetnumberOfUnPaidSalesOrders());
    end;
    procedure GetTotalNumberofInvoices(): Integer
    var
        Invoices: Record "NVR Invoices";

    begin
        //Count all the invoice records in the NVR Invoices Table
        if Invoices.FindSet() then begin
            repeat
                exit(Invoices.Count());
            until Invoices.Next() = 0;
        end;
    end;
    procedure GetTotalNumberofPayments(): Integer
    var
        Payments: Record "NVR Payments";
    begin
        //search for all Payments with the Status type Not Paid
        //Payments.SetRange("Payment Status", Enum::"NVR PaymentStatusEnum"::Paid);
        if Payments.FindSet() then begin
            repeat
                exit(Payments.Count());
            until Payments.Next() = 0;
        end;
        exit(0); // Return 0 if no payments found
    end;
    procedure GetHighestPaymentAmount(): Decimal
    var
        Payments: Record "NVR Payments";
        HighestPaymentAmount: Decimal;
    begin
        if Payments.FindSet() then begin
            repeat
                if Payments.PaymentAmount > HighestPaymentAmount then begin
                    HighestPaymentAmount := Payments.PaymentAmount;
                end;
            until Payments.Next() = 0;
        end;
        exit(HighestPaymentAmount);
    end;
}