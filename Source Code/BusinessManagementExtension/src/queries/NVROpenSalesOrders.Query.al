/*query 50101 "NVR Open Sales Orders"
{
    QueryType = Normal;
    DataItem(SalesOrders; "NVR Sales Orders")
    {
        Column(SalesOrderID; "SalesOrderID")
        {
        }
        Filter(Status; const(Open));
    }
}*/