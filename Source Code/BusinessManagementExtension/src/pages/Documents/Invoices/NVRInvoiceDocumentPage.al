page 50112 "NVR Invoice Document"
{
    Caption = 'Invoice Document';
    PageType = Card;
    SourceTable = "NVR Invoices";

    layout
    {
        area(content)
        {
            group(Header)
            {
                Caption = 'Invoice Details';
                field("NVR Invoice ID"; Rec.InvoiceID)
                {
                    Caption = 'Invoice ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Sales Order ID"; Rec.SalesOrderID)
                {
                    Caption = 'Sales Order ID';
                    ApplicationArea = All;
                    Editable = true;
                    NotBlank = true;
                    TableRelation = "NVR Sales Orders".SalesOrderID;
                    trigger OnValidate()
                    begin
                        HandleSalesOrderSelection();
                    end;
                }
                field("NVR Invoice Date"; Rec.InvoiceDate)
                {
                    Caption = 'Invoice Date';
                    ApplicationArea = All;
                    Editable = true;
                }
                field("NVR Due Date"; Rec.DueDate)
                {
                    Caption = 'Due Date';
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        if Rec.DueDate < Rec.InvoiceDate then
                            Error('The Due Date cannot be earlier than the Invoice Date.');
                    end;
                }
                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Status"; Rec.Status)
                {
                    Caption = 'Overall Status';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Total Amount Due"; TotalAmountDue)
                {
                    Caption = 'Total Amount from Sales Order';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                }
                field("NVR Remaining Amount"; RemainingAmount)
                {
                    Caption = 'Remaining Amount that can be invoiced';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                    StyleExpr = RemainingAmountStyle; // Dynamically update style
                }
                field("NVR Amount Paid"; AmountPaid)
                {
                    Caption = 'Amount Paid via payments';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                }
                field("NVR Invoice Amount Due"; Rec.InvoiceAmount)
                {
                    Caption = 'Invoice Amount';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        ValidateInvoiceAmount();
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(OK)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.Modify(true);
                    Message('Invoice saved successfully!');
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Close;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        SalesOrder: Record "NVR Sales Orders";
        InvoiceHandler: Codeunit "NVR InvoiceSalesOrderHandler";
        ValidationHandler: Codeunit "NVR InvoiceHandler";
        NewInvoice: Record "NVR Invoices";
    begin
        if Rec.InvoiceID <> '' then begin
            Message('Invoice ID: %1', Rec.InvoiceID);
            // Load Total Amount Due and Remaining Amount
            if Rec.SalesOrderID <> '' then begin
                if SalesOrder.Get(Rec.SalesOrderID) then begin
                    TotalAmountDue := SalesOrder."TotalAmount";
                    RemainingAmount := ValidationHandler.CalcRemainingAmount(Rec.SalesOrderID);
                end;
            end;

            // Calculate Amount Paid
            AmountPaid := CalcAmountPaid(Rec.InvoiceID);

            // Update the page to reflect the changes
            CurrPage.Update();
        end else begin
            Message('No Invoice ID found. Generating a new Invoice ID.');
            // Generate a new Invoice ID
            NewInvoice := InvoiceHandler.AddNewInvoice();

            // Reload the record to ensure the page is bound to the correct record
            if Rec.Get(NewInvoice.InvoiceID) then
                Message('New Invoice ID: %1', NewInvoice.InvoiceID);
                Rec := NewInvoice; // Set the current record to the new invoice
                //CurrPage.Update(); // Refresh the page to display the new Invoice ID
        end;
    end;

    var
        TotalAmountDue: Decimal;
        RemainingAmount: Decimal;
        AmountPaid: Decimal;
        RemainingAmountStyle: Text;


    procedure ValidateInvoiceAmount()
    var
        InvoiceRecord: Record "NVR Invoices";
        NewRemainingAmount: Decimal;
        InvoiceHandler: Codeunit "NVR InvoiceHandler";
    begin
        // Load the current record into the variable
        InvoiceRecord := Rec;

        // Scenario 1: Remaining Amount is 0 or less, and user tries to increase the Invoice Amount
        if RemainingAmount <= 0 then begin
            if InvoiceRecord.InvoiceAmount > Rec.InvoiceAmount then begin
                Message(
                    'The Invoice Amount Due cannot exceed the Remaining Amount (%1). The existing Invoice Amount (%2) will be retained.',
                    Format(RemainingAmount), Format(Rec.InvoiceAmount)
                );
                InvoiceRecord.InvoiceAmount := Rec.InvoiceAmount; // Retain the existing Invoice Amount
                CurrPage.Update(); // Refresh the page to reflect the retained value
                exit; // Exit to prevent further processing
            end;
        end;

        // Scenario 2: Entered Invoice Amount is greater than the Remaining Amount
        if InvoiceRecord.InvoiceAmount > (Rec.InvoiceAmount + RemainingAmount) then begin
            Message(
                'The Invoice Amount Due cannot exceed the Remaining Amount (%1). The existing Invoice Amount (%2) will be retained.',
                Format(RemainingAmount), Format(Rec.InvoiceAmount)
            );
            InvoiceRecord.InvoiceAmount := Rec.InvoiceAmount; // Retain the existing Invoice Amount
            CurrPage.Update(); // Refresh the page to reflect the retained value
            exit; // Exit to prevent further processing
        end;

        // Scenario 3: Recalculate Remaining Amount and validate if it becomes negative
        // Save the updated Invoice Amount to the table
        InvoiceRecord.Modify(true);

        // Recalculate the Remaining Amount
        NewRemainingAmount := InvoiceHandler.CalcRemainingAmount(InvoiceRecord.SalesOrderID);

        // Check if the Remaining Amount is valid
        if not IsRemainingAmountValid(NewRemainingAmount) then begin
            Message(
                'The Invoice Amount Due cannot result in a negative Remaining Amount (%1).',
                Format(NewRemainingAmount), Format(InvoiceRecord.InvoiceAmount)
            );
            InvoiceRecord.InvoiceAmount := Rec.InvoiceAmount; // Retain the existing Invoice Amount
            CurrPage.Update(); // Refresh the page to reflect the retained value
            exit; // Exit to prevent further processing
        end;

        // Update the Remaining Amount and style dynamically
        RemainingAmount := NewRemainingAmount;

        // Update the `RemAmtToBePaidToInvoice` only if the invoice amount is valid
        InvoiceRecord.RemAmtToBePaidToInvoice := InvoiceRecord.InvoiceAmount;

        // Inject the updated data back into Rec to reflect it on the page
        Rec := InvoiceRecord;

        // Update the page to reflect the changes
        CurrPage.Update();
    end;

    procedure HandleSalesOrderSelection()
    var
        SalesOrder: Record "NVR Sales Orders";
        InvoiceRecord: Record "NVR Invoices";
        InvoiceHandler: Codeunit "NVR InvoiceHandler";
    begin
        // Load the current record into the variable
        InvoiceRecord := Rec;

        // Validate if a Sales Order ID is provided
        if InvoiceRecord.SalesOrderID = '' then
            Error('Error: No Sales Order ID is provided. Please select a valid Sales Order.');

        // Check if the Sales Order exists
        if not SalesOrder.Get(InvoiceRecord.SalesOrderID) then
            Error('Error: Sales Order with ID %1 not found.', InvoiceRecord.SalesOrderID);

        // Calculate the Remaining Amount for the Sales Order
        RemainingAmount := InvoiceHandler.CalcRemainingAmount(InvoiceRecord.SalesOrderID);

        // Validate if the Sales Order has remaining amount to invoice
        if RemainingAmount = 0 then
            Error('Error: Unable to add a new invoice to this Sales Order as it is fully invoiced. Please select another Sales Order.');

        // Update Total Amount Due and Currency from the Sales Order
        TotalAmountDue := SalesOrder."TotalAmount";
        InvoiceRecord.Currency := SalesOrder.Currency;

        // Inject the updated data back into Rec to reflect it on the page
        Rec := InvoiceRecord;

        // Refresh the page to display the updated values
        CurrPage.Update();
    end;

    procedure CalcAmountPaid(InvoiceID: Code[20]): Decimal
    var
        PaymentRecord: Record "NVR Payments";
        TotalPayments: Decimal;
    begin
        TotalPayments := 0;

        // Calculate the sum of all payments for the specified Invoice ID
        PaymentRecord.SetRange("InvoiceID", InvoiceID);
        if PaymentRecord.FindSet() then
            repeat
                TotalPayments += PaymentRecord."PaymentAmount";
            until PaymentRecord.Next() = 0;

        exit(TotalPayments);
    end;

    procedure IsRemainingAmountValid(NewRemainingAmount: Decimal): Boolean
    begin
        if NewRemainingAmount < 0 then
            exit(false); // Invalid if Remaining Amount is negative
        exit(true); // Valid if Remaining Amount is zero or positive
    end;
}
//Phase 3/4 - thinking of adding the information of the sales order and sales order line aswell as product information to show what is being sold. This can be used later for the report.