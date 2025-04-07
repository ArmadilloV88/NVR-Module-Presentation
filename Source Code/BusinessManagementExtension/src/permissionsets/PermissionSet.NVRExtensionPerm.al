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
        tabledata "NVR Invoices" = RMID,
        Table "NVR Products" = X,
        tabledata "NVR Products" = RMID,
        table "NVR Sales Order Line" = X,
        tabledata "NVR Sales Order Line" = RMID,
        table "NVR Product Categories" = X,
        tabledata "NVR Product Categories" = RMID,
        table "NVR payments" = X,
        tabledata "NVR payments" = RMID,
        table "NVR SalesOrderLineProducts" = X,
        tabledata "NVR SalesOrderLineProducts" = RMID;
}
//Should be 8 total tables