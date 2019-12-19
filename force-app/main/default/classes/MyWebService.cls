global class MyWebService {
    webservice static Id makeContact(String contactLastName) {
        Contact c = new Contact(lastName = contactLastName);
        insert c;
        return c.id;
    }
     webservice static list<account> getAcc(string name){
        return [select name from account where name=:name];
    }
}