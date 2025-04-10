/*codeunit 50102 "Customer Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Events",
   'OnCustomerCreated', '', true, true)]
    procedure SendWelcomeEmail(CustomerID: Code[20])
    begin
        // Code to send a welcome email
    end;
}*/