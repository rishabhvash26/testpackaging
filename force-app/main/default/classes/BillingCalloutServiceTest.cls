@isTest
private class BillingCalloutServiceTest {
    
    public static final Integer BULK_COUNT = 100;
    
    @testSetup
    public static void setupData() {
        ServiceCredentials__c newServiceCredentials = new ServiceCredentials__c();
        newServiceCredentials.Name = 'BillingServiceCredential';
        newServiceCredentials.Username__c = 'TestingPurpose';
        newServiceCredentials.Password__c = 'TestingPurpose1';
        insert newServiceCredentials;
        
        List<Account> accountsToCreate = new List<Account>();
        for ( Integer i = 0; i < BULK_COUNT; i++ ) {
            Account newAccount = new Account();
            newAccount.Name = 'Test data ' + i;
            accountsToCreate.add( newAccount );
        }
        
        insert accountsToCreate;
        
        List<Opportunity> opportunitiesToCreate = new List<Opportunity>();
        
        // Iterating over accounts, to prepare the opportunities that will be inserted
        for ( Account acc: accountsToCreate ) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.CloseDate = Date.today();
            newOpportunity.Name = 'Test Opportunity ' + acc.Name;
            newOpportunity.AccountId = acc.Id;
            newOpportunity.Amount = 100000;
            newOpportunity.StageName = 'Prospecting';
            opportunitiesToCreate.add( newOpportunity );
        }
        
        insert opportunitiesToCreate;  
        
        List<Project__c> projectsToCreate = new List<Project__c>();
        
        for ( Opportunity opp: opportunitiesToCreate ) {
            Project__c proj = new Project__c();
            proj.Name = 'TestProj' + opp.Name;
            proj.Billable_Amount__c = 1000;        
            proj.ProjectRef__c = 'TestRef ' + opp.Name;
            proj.Status__c = 'Running';
            proj.Opportunity__c = opp.Id;
            projectsToCreate.add( proj );
        }
        
        insert projectsToCreate;
    }    
    
    @isTest static void testCalloutSuccess(){
        Test.setMock( WebServiceMock.class, new BillingCalloutServiceMock() ); 
        
        Test.startTest();
        
        // Holds lists of records that will be updated
        List<Project__c> projectsList = [SELECT Status__c, Id FROM Project__c ];
        for ( Project__c projectsToUpdate: projectsList ) {
            projectsToUpdate.Status__c = 'Billable';
        }
        
        update projectsList;
        
        Test.stopTest();
        
        // Confirming that records were updated
        for ( Project__c updatedProjects: [SELECT Status__c FROM Project__c ] ) {
            System.assertEquals( 'Billed', updatedProjects.Status__c );
        }
    }
    
    @isTest static void testCalloutFailure(){
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure()); 
        
        Test.startTest();
        
        // Holds lists of records that will be updated
        List<Project__c> projectsList = [SELECT Status__c, Id FROM Project__c ];
        for ( Project__c projectsToUpdate: projectsList ) {
            projectsToUpdate.Status__c = 'Running';
        }
        
        update projectsList;
        
        Test.stopTest();
        
        // Confirming that records were updated
        for ( Project__c updatedProjects: [SELECT Status__c, Id FROM Project__c ] ) {
            System.assertEquals( 'Running', updatedProjects.Status__c );
        }
    } 
}