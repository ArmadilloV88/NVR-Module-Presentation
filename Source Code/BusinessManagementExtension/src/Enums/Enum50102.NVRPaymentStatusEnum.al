enum 50101 NVRPaymentStatusEnum
{
    Extensible = false;
    value(0; NotPaid)
    {
        Caption = 'Not Paid';
    }
    value(1; Paid)
    {
        Caption = 'Paid';
    }
    value(2; PartiallyPaid)
    {
        Caption = 'Partially Paid';
    }
    value(3; OverPaid)
    {
        Caption = 'Over Paid';
    }
    value(4; Refunded)
    {
        Caption = 'Refunded';
    }
    value(5; Chargeback)
    {
        Caption = 'Chargeback';
    }
    value(6; Reversed)
    {
        Caption = 'Reversed';
    }
    value(7; Failed)
    {
        Caption = 'Failed';
    }
    value(8; Cancelled)
    {
        Caption = 'Cancelled';
    }
    value(9; Unknown)
    {
        Caption = 'Unknown';
    }
    value(10; Pending)
    {
        Caption = 'Pending';
    }
    value(11; InProgress)
    {
        Caption = 'In Progress';
    }
}
