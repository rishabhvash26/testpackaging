public class OpportunityTriggerHandler {
    
    @InvocableMethod
    public static void postOpportunityToPMS( List<Id> opportunityIds ) {
        List<Opportunity> opportunitiesToBeProcessed = [ SELECT ID, NAME, ACCOUNT.NAME, CLOSEDATE, AMOUNT 
                                                        FROM OPPORTUNITY WHERE ID =: opportunityIds ];
        
        // Retrieving the token
        ServiceTokens__c ST = ServiceTokens__c.getvalues('ProjectServiceToken');
        
        // Map to hold all the Callouts that will be done.
        Map<HttpRequest, Id> requests = new Map<HttpRequest, Id>();
        // Map to hold the Callout responses
        Map<Id, HTTPResponse> responses = new Map<Id, HTTPResponse>();
        HttpRequest request;
        HTTPResponse response;
        
        for ( Opportunity opp : opportunitiesToBeProcessed ) {
            
            request = new HttpRequest();
            request.setEndpoint( 'callout:ProjectService'  );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'application/json' );
            request.setHeader( 'token', ST.Token__c);
            request.setBody( JSON.serialize( new OpportunityWrapper( opp.Id, opp.Name, opp.Account.Name, String.valueOf( opp.CloseDate ), opp.Amount ) ) );
            requests.put( request, opp.Id );	        
        }
        
        Http http = new Http();
        response = new HTTPResponse();
        
        for ( HttpRequest req : requests.keySet() ) {
            try {
                response = http.send( req );
            } catch( System.CalloutException e ) {
                System.debug(  e.getMessage() );
            }
        }   
    }
   
    public class OpportunityWrapper {
        public String opportunityId;
        public String opportunityName;
        public String accountName;
        public String closeDate;
        public Decimal amount;
        
        public OpportunityWrapper( String opportunityId, String opportunityName, String accountName,
                                  String closeDate, Decimal amount ) {
            this.opportunityId = opportunityId;
            this.opportunityName = opportunityName;
            this.accountName = accountName;
            this.closeDate = closeDate;
            this.amount = amount;
        }
    }
    
}