public class AccountCreation{
 public Account objAcc;
 public String name;
 
 public void newAccount(account acc) {
// objAcc = new Account(Name = name, AccountNumber = 'ACC1000', Type = 'Customer - Direct');
 try {
    upsert acc;
 }catch(DMLException e) {
   system.debug('error'+e.getMessage());
 }
 }
}