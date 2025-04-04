permissionset 50110 "NVR Extension Perm."
{
    Assignable = true;
    Caption = 'NVR Permissions Set', MaxLength = 30;
    Permissions =
        table "NVR Sales Orders" = X,
        tabledata "NVR Sales Orders" = RMID,
        table "NVR Customers" = X,
        tabledata "NVR Customers" = RMID,
        table "NVR Invoices" = X,
        tabledata "NVR Invoices" = RMID;
}