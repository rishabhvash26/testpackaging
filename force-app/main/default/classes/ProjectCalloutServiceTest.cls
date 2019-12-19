@isTest
private class ProjectCalloutServiceTest {
    
    public static final Integer BULK_COUNT = 100;
    
    @testSetup
    public static void setupData() {
        ServiceTokens__c newServiceToken = new ServiceTokens__c();
        newServiceToken.Name = 'ProjectServiceToken';
        newServiceToken.Token__c = 'TestingPurpose';
        insert newServiceToken;
    }
    
    @isTest
    public static void testProjectCalloutSuccess() {
        
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
        
        List<Id> oppIds = new List<Id>();
        for ( Opportunity opp : opportunitiesToCreate ) {
            oppIds.add( opp.Id );
        }
        
        // Calling the invocable method to cover the process builder scenario. 
        ProjectCalloutService.postOpportunityToPMS( oppIds );
        
        // Testing the Queuable Job
        Test.startTest();        
        // The mock that will be used in this test, has to successfully insert data
        Test.setMock( HttpCalloutMock.class, new ProjectCalloutServiceMock() );
        // Queue processing
        System.enqueueJob(new ProjectCalloutService.QueueablePMSCall( opportunitiesToCreate ) );
        // Calling the future method, out of the test context, as it is assyncrhonous and the records wouldn't be updated in time to assert
        ProjectCalloutService.makeCallout( JSON.serialize( opportunitiesToCreate ) );        
        Test.stopTest();
        
        // Queryng the opportunity to confirm that the values were updated.
        for ( Opportunity updatedOpp : [ SELECT StageName FROM Opportunity ] ) {
            System.assertEquals( 'Submitted Project', updatedOpp.StageName , 'something went wrong' ); 
        }
    }
    
    @isTest
    public static void testProjectCalloutFailure() {
        
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
        
        List<Id> oppIds = new List<Id>();
        for ( Opportunity opp : opportunitiesToCreate ) {
            oppIds.add( opp.Id );
        }
        
        // Calling the invocable method to cover the process builder scenario. 
        ProjectCalloutService.postOpportunityToPMS( oppIds );
        
        // Testing the Queuable Job
        Test.startTest();        
        // The mock that will be used in this test, has to failed to update the data
        Test.setMock( HttpCalloutMock.class, new ProjectCalloutServiceMockFailure() );
        // Queue processing
        System.enqueueJob(new ProjectCalloutService.QueueablePMSCall( opportunitiesToCreate ) );
        // Calling the future method, out of the test context, as it is assyncrhonous and the records wouldn't be updated in time to assert
        ProjectCalloutService.makeCallout( JSON.serialize( opportunitiesToCreate ) );
        Test.stopTest();
        
        // Queryng the opportunity to confirm that the values were updated.
        for ( Opportunity updatedOpp : [ SELECT StageName FROM Opportunity ] ) {
            System.assertEquals( 'Resubmit Project', updatedOpp.StageName, 'something went wrong' ); 
        }
    }    
}