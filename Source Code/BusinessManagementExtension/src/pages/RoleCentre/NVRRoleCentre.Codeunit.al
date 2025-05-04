codeunit 50109 "NVR RoleCentreHandler"
{
    Subtype = Normal;

    procedure GetPartiallyPaidInvoicesCount(): Integer
    var
        InvoicesRec: Record "NVR Invoices";
        PartiallyPaidInvoicesCount: Integer;
    begin
        //search for all Invoices with the Status type Partially Paid
        InvoicesRec.SetRange("Status", Enum::"NVR PaymentStatusEnum"::PartiallyPaid);
        if InvoicesRec.FindSet() then begin
            repeat
                PartiallyPaidInvoicesCount := PartiallyPaidInvoicesCount + 1;
            until InvoicesRec.Next() = 0;
        end;
        exit(PartiallyPaidInvoicesCount);
    end;
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
        PaymentsRec: Record "NVR Payments";
        TotalPaidAmount: Decimal;
        PaidAmount: Decimal;
    begin
        // Paid: add full invoice amount
        InvoicesRec.SetRange("Status", Enum::"NVR PaymentStatusEnum"::Paid);
        if InvoicesRec.FindSet() then
            repeat
                TotalPaidAmount += InvoicesRec."InvoiceAmount";
            until InvoicesRec.Next() = 0;

        // Partially Paid: add only the paid portion
        InvoicesRec.Reset();
        InvoicesRec.SetRange("Status", Enum::"NVR PaymentStatusEnum"::PartiallyPaid);
        if InvoicesRec.FindSet() then
            repeat
                PaidAmount := 0;
                PaymentsRec.SetRange("InvoiceID", InvoicesRec."InvoiceID");
                if PaymentsRec.FindSet() then
                    repeat
                        PaidAmount += PaymentsRec."PaymentAmount";
                    until PaymentsRec.Next() = 0;
                TotalPaidAmount += PaidAmount;
            until InvoicesRec.Next() = 0;

        exit(TotalPaidAmount);
    end;
    procedure GetTotalAmountofUnPaidInvoices(): Decimal
    var
        InvoicesRec: Record "NVR Invoices";
        PaymentsRec: Record "NVR Payments";
        TotalUnPaidAmount: Decimal;
        PaidAmount: Decimal;
    begin
        // Not Paid: add full invoice amount
        InvoicesRec.SetRange("Status", Enum::"NVR PaymentStatusEnum"::NotPaid);
        if InvoicesRec.FindSet() then
            repeat
                TotalUnPaidAmount += InvoicesRec."InvoiceAmount";
            until InvoicesRec.Next() = 0;

        // Partially Paid: add only the unpaid portion
        InvoicesRec.Reset();
        InvoicesRec.SetRange("Status", Enum::"NVR PaymentStatusEnum"::PartiallyPaid);
        if InvoicesRec.FindSet() then
            repeat
                PaidAmount := 0;
                PaymentsRec.SetRange("InvoiceID", InvoicesRec."InvoiceID");
                if PaymentsRec.FindSet() then
                    repeat
                        PaidAmount += PaymentsRec."PaymentAmount";
                    until PaymentsRec.Next() = 0;
                TotalUnPaidAmount += (InvoicesRec."InvoiceAmount" - PaidAmount);
            until InvoicesRec.Next() = 0;

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
    var
        SalesOrderRec: Record "NVR Sales Orders";
    begin
        exit(SalesOrderRec.Count());
    end;
    procedure GetTotalNumberofInvoices(): Integer
    var
        Invoices: Record "NVR Invoices";
    begin
        exit(Invoices.Count());
    end;
    procedure GetTotalNumberofPayments(): Integer
    var
        Payments: Record "NVR Payments";
    begin
        exit(Payments.Count());
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
    procedure GetMostSoldProduct(): Text[100]
    var
        ProductsRec: Record "NVR SalesOrderLineProducts";
        Products: Record "NVR Products";
        MostSoldProductID: Code[20];
        MostSoldQuantity: Decimal; // Changed from Integer to Decimal
        CurrentProductQuantity: Decimal; // Changed from Integer to Decimal
    begin
        MostSoldQuantity := 0;

        // Loop through all products in the SalesOrderLineProducts table
        if ProductsRec.FindSet() then begin
            repeat
                CurrentProductQuantity := ProductsRec.Quantity;

                // Check if the current product has the highest quantity sold
                if CurrentProductQuantity > MostSoldQuantity then begin
                    MostSoldQuantity := CurrentProductQuantity;
                    MostSoldProductID := ProductsRec."ProductID";
                end;
            until ProductsRec.Next() = 0;
        end;

        // Retrieve the product name using the Product ID
        if Products.Get(MostSoldProductID) then
            exit(Products.ProductName)
        else
            exit('-');
    end;
    procedure GetMostListedCategory(): Text[100]
    var
        Products: Record "NVR Products";
        Categories: Record "NVR Product Categories";
        CategoryCount: Dictionary of [Code[20], Decimal]; // Changed value type to Decimal
        MostListedCategoryID: Code[20];
        MostListedCount: Decimal; // Changed from Integer to Decimal
        CurrentCount: Decimal; // Changed from Integer to Decimal
        CategoryID: Code[20];
    begin
        MostListedCount := 0;

        // Count the occurrences of each category in the Products table
        if Products.FindSet() then begin
            repeat
                if not CategoryCount.ContainsKey(Products."CategoryID") then
                    CategoryCount.Add(Products."CategoryID", 1)
                else begin
                    CurrentCount := CategoryCount.Get(Products."CategoryID");
                    CategoryCount.Set(Products."CategoryID", CurrentCount + 1);
                end;
            until Products.Next() = 0;
        end;

        // Find the category with the highest count
        foreach CategoryID in CategoryCount.Keys() do begin
            if CategoryCount.Get(CategoryID) > MostListedCount then begin
                MostListedCount := CategoryCount.Get(CategoryID);
                MostListedCategoryID := CategoryID;
            end;
        end;

        // Retrieve the category name using the Category ID
        if Categories.Get(MostListedCategoryID) then
            exit(Categories.CategoryName) // Replace 'CategoryName' with the correct field name
        else
            exit('-');
    end;
    procedure GetTotalSalesOrderAmount(): Decimal
    var
        SalesOrderRec: Record "NVR Sales Orders";
        TotalSalesOrderAmount: Decimal;
    begin
        TotalSalesOrderAmount := 0;

        // Sum up all the sales order amounts
        if SalesOrderRec.FindSet() then begin
            repeat
                TotalSalesOrderAmount := TotalSalesOrderAmount + SalesOrderRec.TotalAmount; // Replace 'OrderTotal' with the correct field name
            until SalesOrderRec.Next() = 0;
        end;
        exit(TotalSalesOrderAmount);
    end;
    procedure GetTotalInvoiceAmount(): Decimal
    var
        InvoicesRec: Record "NVR Invoices";
        TotalInvoiceAmount: Decimal;
    begin
        TotalInvoiceAmount := 0;
        if InvoicesRec.FindSet() then
            repeat
                TotalInvoiceAmount += InvoicesRec."InvoiceAmount";
            until InvoicesRec.Next() = 0;
        exit(TotalInvoiceAmount);
    end;
    procedure GetTotalPaidSalesOrderAmount(): Decimal
    var
        SalesOrderRec: Record "NVR Sales Orders";
        InvoiceRec: Record "NVR Invoices";
        PaymentRec: Record "NVR Payments";
        TotalPaidSalesOrderAmount: Decimal;
        PaidAmount: Decimal;
    begin
        TotalPaidSalesOrderAmount := 0;

        if SalesOrderRec.FindSet() then
            repeat
                if (SalesOrderRec."Payment Status" = Enum::"NVR PaymentStatusEnum"::Paid) or
                (SalesOrderRec."Payment Status" = Enum::"NVR PaymentStatusEnum"::PartiallyPaid) then
                begin
                    InvoiceRec.SetRange("SalesOrderID", SalesOrderRec."SalesOrderID");
                    if InvoiceRec.FindSet() then begin
                        repeat
                            case InvoiceRec.Status of
                                Enum::"NVR PaymentStatusEnum"::Paid:
                                    TotalPaidSalesOrderAmount += InvoiceRec."InvoiceAmount";
                                Enum::"NVR PaymentStatusEnum"::PartiallyPaid:
                                    begin
                                        PaidAmount := 0;
                                        PaymentRec.SetRange("InvoiceID", InvoiceRec."InvoiceID");
                                        if PaymentRec.FindSet() then
                                            repeat
                                                PaidAmount += PaymentRec."PaymentAmount";
                                            until PaymentRec.Next() = 0;
                                        TotalPaidSalesOrderAmount += PaidAmount;
                                    end;
                            end;
                        until InvoiceRec.Next() = 0;
                    end else
                        // No invoices, add sales order amount
                        TotalPaidSalesOrderAmount += SalesOrderRec.TotalAmount;
                end;
            until SalesOrderRec.Next() = 0;

        exit(TotalPaidSalesOrderAmount);
    end;
    procedure GetTotalUnPaidSalesOrderAmount(): Decimal
    begin
        exit(GetTotalSalesOrderAmount() - GetTotalPaidSalesOrderAmount());
    end;
    /*var
        SalesOrderRec: Record "NVR Sales Orders";
        InvoiceRec: Record "NVR Invoices";
        PaymentRec: Record "NVR Payments";
        TotalUnPaidSalesOrderAmount: Decimal;
        PaidAmount: Decimal;
    begin
        TotalUnPaidSalesOrderAmount := 0;

        if SalesOrderRec.FindSet() then
            repeat
                if (SalesOrderRec."Payment Status" = Enum::"NVR PaymentStatusEnum"::NotPaid) or
                (SalesOrderRec."Payment Status" = Enum::"NVR PaymentStatusEnum"::PartiallyPaid) then
                begin
                    InvoiceRec.SetRange("SalesOrderID", SalesOrderRec."SalesOrderID");
                    if InvoiceRec.FindSet() then begin
                        repeat
                            case InvoiceRec.Status of
                                Enum::"NVR PaymentStatusEnum"::NotPaid:
                                    TotalUnPaidSalesOrderAmount += InvoiceRec."InvoiceAmount";
                                Enum::"NVR PaymentStatusEnum"::PartiallyPaid:
                                    begin
                                        PaidAmount := 0;
                                        PaymentRec.SetRange("InvoiceID", InvoiceRec."InvoiceID");
                                        if PaymentRec.FindSet() then
                                            repeat
                                                PaidAmount += PaymentRec."PaymentAmount";
                                            until PaymentRec.Next() = 0;
                                        TotalUnPaidSalesOrderAmount += (InvoiceRec."InvoiceAmount" - PaidAmount);
                                    end;
                            end;
                        until InvoiceRec.Next() = 0;
                    end else
                        // No invoices, add sales order amount
                        TotalUnPaidSalesOrderAmount += SalesOrderRec.TotalAmount;
                end;
            until SalesOrderRec.Next() = 0;

        exit(TotalUnPaidSalesOrderAmount);
    end;*/
    procedure GetnumberOfPartiallyPaidSalesOrders(): Integer
    var
        SalesOrderRec: Record "NVR Sales Orders";
        PartiallyPaidSalesOrdersCount: Integer;
    begin
        //search for all Sales orders with the Status type Partially Paid
        SalesOrderRec.SetRange("Payment Status", Enum::"NVR PaymentStatusEnum"::PartiallyPaid);
        if SalesOrderRec.FindSet() then begin
            repeat
                PartiallyPaidSalesOrdersCount := PartiallyPaidSalesOrdersCount + 1;
            until SalesOrderRec.Next() = 0;
        end;
        exit(PartiallyPaidSalesOrdersCount);
    end;
}