tableextension 50108 "NVR Customer Loyalty Extension" extends "NVR Customers"
{
    fields
    {
        field(50100; "Loyalty Points"; Integer)
        {
            Caption = 'Loyalty Points';
            DataClassification = CustomerContent;
        }
        field(50101; "Loyalty Level"; Option)
        {
            Caption = 'Loyalty Level';
            DataClassification = CustomerContent;
            OptionMembers = Bronze, Silver, Gold, Platinum;
        }
    }
}
