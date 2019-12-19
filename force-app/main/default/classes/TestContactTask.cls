@IsTest
public class TestContactTask {
    public static list<contact> contList=new list<contact>();
    @isTest
    public static void testRecords(){
        
        COntact con=new Contact(lastName='test' ,accountId='0012v00002biSPH');
        
        contactTaskController.insertContact(con);        
        
    }
    
    
    
}