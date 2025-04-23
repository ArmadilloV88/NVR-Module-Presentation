permissionset 50100 "NVR Customer Loyalty Officer"
{
    Caption = 'Customer Loyalty Officer Permissions';
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
        tabledata "NVR SalesOrderLineProducts" = RMID,
        //tabledata "NVR Customers" = RMID,
        page "NVR Customer List" = X,
        page "NVR Customer Card" = X,
        page "NVR Custom Role Center" = X;
}