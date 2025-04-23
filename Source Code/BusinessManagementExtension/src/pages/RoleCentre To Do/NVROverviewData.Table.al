table 50110 "NVR Document Overview"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Total Sales Orders"; Integer) {}
        field(3; "Total Invoices"; Integer) {}
        field(4; "Total Payments"; Integer) {}
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}