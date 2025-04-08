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
                }
                field("NVR Currency"; Rec.Currency)
                {
                    Caption = 'Currency';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Status"; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NVR Total Amount Due"; TotalAmountDue)
                {
                    Caption = 'Total Amount Due';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                }
                field("NVR Remaining Amount"; RemainingAmount)
                {
                    Caption = 'Remaining Amount';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                }
                field("NVR Amount Paid"; AmountPaid)
                {
                    Caption = 'Amount Paid';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = false;
                }
                field("NVR Invoice Amount Due"; Rec.InvoiceAmount)
                {
                    Caption = 'Invoice Amount Due';
                    ApplicationArea = All;
                    DecimalPlaces = 2;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        // Ensure the Invoice Amount Due is less than or equal to the Total Amount Due
                        if Rec.InvoiceAmount > TotalAmountDue then begin
                            Message('The Invoice Amount Due cannot exceed the Total Amount Due (%1). It has been adjusted to the Total Amount Due.', Format(TotalAmountDue));
                            Rec.InvoiceAmount := TotalAmountDue; // Adjust the Invoice Amount Due to the Total Amount Due
                        end;
                    end;
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                part(PaymentList; "NVR Payment ListPart")
                {
                    ApplicationArea = All;
                    SubPageLink = "InvoiceID" = FIELD(InvoiceID); // Link payments to the current invoice
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
        PaymentRecord: Record "NVR Payments";
        TotalPayments: Decimal;
    begin
        // Ensure the Invoice ID is set
        if Rec."InvoiceID" = '' then begin
            Counter := 0;
            repeat
                Counter := Counter + 1;
                NewID := 'INV' + PadStr(Format(Counter), 17, '0'); // Prefix with "INV" and pad with zeros
            until not Rec.Get(NewID);

            Rec."InvoiceID" := NewID;

            // Save the record to ensure the Invoice ID is persisted
            if Rec.IsTemporary then
                Rec.Insert()
            else
                Rec.Modify(true); // Save the record to the database
        end;

        // Debugging: Confirm the Invoice ID is set
        Message('Invoice ID in Invoice Document: %1', Rec.InvoiceID);

        // Pull Total Amount and Currency from Sales Order
        if SalesOrder.Get(Rec.SalesOrderID) then begin
            TotalAmountDue := SalesOrder."TotalAmount";
            Rec.Currency := SalesOrder.Currency; // Set the currency from the Sales Order
        end;

        // Calculate Total Payments for the Invoice
        TotalPayments := 0;
        PaymentRecord.SetRange("InvoiceID", Rec.InvoiceID);
        if PaymentRecord.FindSet() then
            repeat
                TotalPayments += PaymentRecord."PaymentAmount";
            until PaymentRecord.Next() = 0;

        AmountPaid := TotalPayments; // Set the total payments as the amount paid
        RemainingAmount := Rec.InvoiceAmount - AmountPaid; // Calculate the remaining amount

        // Update the page to reflect the changes
        CurrPage.Update();
    end;

    var
        TotalAmountDue: Decimal;
        RemainingAmount: Decimal;
        AmountPaid: Decimal;
        Counter: Integer;
        NewID: Code[20];
}
//Phase 3/4 - thinking of adding the information of the sales order and sales order line aswell as product information to show what is being sold. This can be used later for the report.