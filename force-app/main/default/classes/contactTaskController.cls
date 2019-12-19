public class contactTaskController {
    @AuraEnabled
    public static void insertContact(contact conObj){
        Database.insert(conObj,false);
    }

}