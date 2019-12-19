@isTest
private class ProjectRESTServiceTest {

    public static final Integer BULK_COUNT = 1;
    
    @testSetup
    public static void setupData() {
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
    }
  	
    @isTest static void testSuccessfulProjectRestService() {

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/project/';
        request.httpMethod = 'POST';
        
        // Querying Opp
        Opportunity opportunity = [SELECT Id FROM Opportunity];
	
        RestContext.request = request;
        String response = ProjectRESTService.postProjectData( 'Reference Name', 'Project Name', opportunity.Id, 
                                                             Date.today(), Date.today().addDays( 1 ), 150000, 'Running ' );
        
        System.assertEquals( 'OK', response, 'The response should be OK' );
    }
    
    @isTest static void testFailureProjectRestService() {

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/project/';
        request.httpMethod = 'POST';
	
        RestContext.request = request;
        String response = ProjectRESTService.postProjectData( 'Reference Failre', 'It should fail', 'Using a opp Id that does not exist', 
                                                               Date.today(), Date.today().addDays( 1 ), 150000, 'Running ' );
        
        System.assertEquals( 'Invalid id: Using a opp Id that does not exist', response, 'The response should be Invalid id: Using a opp Id that does not exist' );
    }    
}