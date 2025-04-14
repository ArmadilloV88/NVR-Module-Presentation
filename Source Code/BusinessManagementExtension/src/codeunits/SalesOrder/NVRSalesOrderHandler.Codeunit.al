codeunit 50108 "NVR SalesOrderHandler"
{
    SingleInstance = true;

    var
        CustomerID: Code[20];

    procedure SetCustomerID(NewCustomerID: Code[20])
    begin
        //Message('Setting Customer ID to: %1', NewCustomerID);
        CustomerID := NewCustomerID;
    end;

    procedure GetCustomerID(): Code[20]
    begin
        //Message('Getting Customer ID: %1', CustomerID);
        exit(CustomerID);
    end;
}