permissionset 50110 "NVR Extension Perm."
{
    Assignable = true;
    Caption = 'NVR Permissions Set', MaxLength = 30;
    Permissions =
        table "Sales Orders" = X,
        tabledata "Sales Orders" = RMID,
        table "NVR Customers" = X,
        tabledata "NVR Customers" = RMID,
        table "NVR Invoices" = X,
        tabledata "NVR Invoices" = RMID;
}