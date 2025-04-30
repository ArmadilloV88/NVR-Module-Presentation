/*xmlport 50100 "Customer Import"
{
    format = Xml;

    element(Customer)
 {
 field("Customer ID"; "Customer ID");
 field("Loyalty Points"; "Loyalty Points");
 field("Preferred Contact Method"; "Preferred Contact Method");
 }
 
 procedure ImportCustomerData()
 var
 InStream: InStream;
 XmlDoc: XmlDocument;
 begin
 // Logic for processing XML and importing customer data
 end;
}
###COMMENTS###
Requires more development time to accomplish as the exporting is easily possible 
by extracting as a json but then we will need to make logic for importing and knowing 
where exactly to store however this can rather be accomplished with linking the application 
to the base application feeds
##############
*/