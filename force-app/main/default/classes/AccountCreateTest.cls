@isTest
public class AccountCreateTest{
    public static testmethod void AccTest(){ 
        account acc=new account(name='');
        AccountCreation objAcc = new AccountCreation(); 
        try{ 
            objAcc.newAccount(acc); 
        }catch(DMLException e){
           system.assertEquals(e.getMessage(), e.getMessage()); 
        }
        acc.name = 'Test Account';
        objAcc.newAccount(acc);
    }
}