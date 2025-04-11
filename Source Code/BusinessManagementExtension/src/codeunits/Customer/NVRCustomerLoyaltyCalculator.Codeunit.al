codeunit 50112 "NVR Loyalty Points Handler"
{
    Subtype = Normal;

    procedure UpdateAllCustomers()
    var
        CustomerRecord: Record "NVR Customers";
    begin
        // Loop through all customers
        if CustomerRecord.FindSet() then
            repeat
                // Call CalculateLoyaltyPoints for each customer
                CalculateLoyaltyPoints(CustomerRecord);
            until CustomerRecord.Next() = 0;
    end;

    procedure CalculateLoyaltyPoints(CustomerRecord: Record "NVR Customers") : Record "NVR Customers"
    var
        SalesOrderRecord: Record "NVR Sales Orders";
        InvoiceRecord: Record "NVR Invoices";
        TotalAmountPaid: Decimal;
        LoyaltyPoints: Integer;
        LoyaltyLevel: Enum "NVR Loyalty Level";
    begin
        LoyaltyPoints := 0;

        // Retrieve all sales orders for the customer
        SalesOrderRecord.SetRange("CustomerID", CustomerRecord."CustomerID");
        if SalesOrderRecord.FindSet() then
            repeat
                // Calculate the total amount paid for the sales order
                TotalAmountPaid := 0;
                InvoiceRecord.SetRange("SalesOrderID", SalesOrderRecord."SalesOrderID");
                if InvoiceRecord.FindSet() then
                    repeat
                        TotalAmountPaid += InvoiceRecord."AmountPaid";
                    until InvoiceRecord.Next() = 0;

                // Check if the sales order is fully paid
                if TotalAmountPaid >= SalesOrderRecord."TotalAmount" then
                    LoyaltyPoints += Round(SalesOrderRecord."TotalAmount", 1); // Add the total amount as points
            until SalesOrderRecord.Next() = 0;

        // Update the customer's loyalty points
        CustomerRecord."Loyalty Points" := LoyaltyPoints;

        // Determine the loyalty level based on points
        if (LoyaltyPoints >= 1) and (LoyaltyPoints <= 5) then
            LoyaltyLevel := LoyaltyLevel::"Level 1"
        else if (LoyaltyPoints >= 6) and (LoyaltyPoints <= 11) then
            LoyaltyLevel := LoyaltyLevel::"Level 2"
        else if (LoyaltyPoints >= 12) and (LoyaltyPoints <= 17) then
            LoyaltyLevel := LoyaltyLevel::"Level 3"
        else if (LoyaltyPoints >= 18) and (LoyaltyPoints <= 23) then
            LoyaltyLevel := LoyaltyLevel::"Level 4"
        else if (LoyaltyPoints >= 24) and (LoyaltyPoints <= 29) then
            LoyaltyLevel := LoyaltyLevel::"Level 5"
        else if (LoyaltyPoints >= 30) and (LoyaltyPoints <= 35) then
            LoyaltyLevel := LoyaltyLevel::"Level 6"
        else if (LoyaltyPoints >= 36) and (LoyaltyPoints <= 41) then
            LoyaltyLevel := LoyaltyLevel::"Level 7"
        else if (LoyaltyPoints >= 42) and (LoyaltyPoints <= 47) then
            LoyaltyLevel := LoyaltyLevel::"Level 8"
        else if (LoyaltyPoints >= 48) and (LoyaltyPoints <= 53) then
            LoyaltyLevel := LoyaltyLevel::"Level 9"
        else if (LoyaltyPoints) >= 54 then
            LoyaltyLevel := LoyaltyLevel::"Level 10";

        // Update the customer's loyalty level
        CustomerRecord."Loyalty Level" := LoyaltyLevel.AsInteger();
        CustomerRecord.Modify();
        exit(CustomerRecord);
    end;
}


//this code unit will need further verification. 
//Currently set to level : 1
//1 - Only checks if the invcoices are paid per the Sales Order amount due, have not verified if the salesorders have the correct lines.
//2 - Checks Invoices and payments if they match, checks if the invoices are paying the sales order, checks if the sales order has the correct lines distribution.
//3 - Checks Invoices and payments if they match, checks if the invoices are paying the sales order, checks if the sales order has the correct lines distribution and product lines matches. 
//3 - Checks Invoices and payments if they match, checks if the invoices are paying the sales order, checks if the sales order has the correct lines distribution and product lines matches, checks if the sales order lines are making profit.
//3 - Checks Invoices and payments if they match, checks if the invoices are paying the sales order, checks if the sales order has the correct lines distribution and product lines matches, checks if the sales order lines are making profit, Requires client verification of the products that were order and does a cross reference check. (will require further development :: Not in scope as of yet)