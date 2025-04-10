page 50112 "NVR Invoice Document"
{
    Caption = 'Invoice Document';
    PageType = Document;
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
    begin
        if Rec.InvoiceID <> '' then begin
            // Load Total Amount Due and Remaining Amount
            if Rec.SalesOrderID <> '' then begin
                if SalesOrder.Get(Rec.SalesOrderID) then begin
                    TotalAmountDue := SalesOrder."TotalAmount";
                    RemainingAmount := CalcRemainingAmount(Rec.SalesOrderID);
                end;
            end;

            // Calculate Amount Paid
            AmountPaid := CalcAmountPaid(Rec.InvoiceID);

            // Update the page to reflect the changes
            CurrPage.Update();
        end else begin
            Error('Invoice with ID %1 not found.', Rec.InvoiceID);
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
        NewRemainingAmount := CalcRemainingAmount(InvoiceRecord.SalesOrderID);

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
    begin
        // Load the current record into the variable
        InvoiceRecord := Rec;

        if InvoiceRecord.SalesOrderID <> '' then begin
            if SalesOrder.Get(InvoiceRecord.SalesOrderID) then begin
                TotalAmountDue := SalesOrder."TotalAmount";
                InvoiceRecord.Currency := SalesOrder.Currency;
            end else begin
                TotalAmountDue := 0;
                InvoiceRecord.Currency := '';
            end;
        end else begin
            TotalAmountDue := 0;
            InvoiceRecord.Currency := '';
        end;

        // Calculate Remaining Amount
        RemainingAmount := CalcRemainingAmount(InvoiceRecord.SalesOrderID);

        // Inject the data back into Rec to reflect it on the page
        Rec := InvoiceRecord;

        // Update the page to reflect the changes
        CurrPage.Update();
    end;

    procedure CalcRemainingAmount(SalesOrderID: Code[20]): Decimal
    var
        InvoiceRecord: Record "NVR Invoices";
        TotalInvoiceAmounts: Decimal;
    begin
        TotalInvoiceAmounts := 0;

        // Calculate the sum of all invoice amounts for the specified Sales Order ID
        InvoiceRecord.SetRange("SalesOrderID", SalesOrderID);
        if InvoiceRecord.FindSet() then
            repeat
                TotalInvoiceAmounts += InvoiceRecord."InvoiceAmount";
            until InvoiceRecord.Next() = 0;

        exit(TotalAmountDue - TotalInvoiceAmounts);
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