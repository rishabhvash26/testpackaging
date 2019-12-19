public class ProjectCalloutService {
    @InvocableMethod
    public static void postOpportunityToPMS( List<Id> opportunityIds ) {
        List<Opportunity> opportunitiesToBeProcessed = [ SELECT ID, NAME, ACCOUNT.NAME, CLOSEDATE, AMOUNT 
                                                        FROM OPPORTUNITY WHERE ID =: opportunityIds ];
        
 		System.enqueueJob( new QueueablePMSCall( opportunitiesToBeProcessed ) );
    }
    
    @future( callout = true )
    public static void makeCallout( String serializedOpportunities ) {
        List<Opportunity> recordsToBeProcessed = ( List<Opportunity> )JSON.deserialize( serializedOpportunities, List<Opportunity>.class );
        
        // Retrieving the token
        ServiceTokens__c serviceToken = ServiceTokens__c.getvalues('ProjectServiceToken');
        
        // Map to hold all the Callouts that will be done.
        Map<HttpRequest, Id> requests = new Map<HttpRequest, Id>();
        // Map to hold the Callout responses (This map can be used in the catch block, to store the requests that failed)
        // And later on be saved in a error log object.
        Map<Id, HTTPResponse> responses = new Map<Id, HTTPResponse>();
        HttpRequest request;
        HTTPResponse response;
        
        for ( Opportunity opp : recordsToBeProcessed ) {
            
            request = new HttpRequest();
            request.setEndpoint( 'callout:ProjectService'  );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'application/json' );
            request.setHeader( 'token', serviceToken.Token__c);
            request.setBody( JSON.serialize( new OpportunityWrapper( opp.Id, opp.Name, opp.Account.Name, String.valueOf( opp.CloseDate ), opp.Amount ) ) );
            requests.put( request, opp.Id );	        
        }
        
        Http http = new Http();
        response = new HTTPResponse();
        
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for ( HttpRequest req : requests.keySet() ) {
            try {
                response = http.send( req );
                Opportunity oppToUpdate = new Opportunity( Id = requests.get( req ) );
                if ( response.getStatusCode() == 201 ) {
                    oppToUpdate.StageName = 'Submitted Project';
                } else {
                    oppToUpdate.StageName = 'Resubmit Project';
                }
                opportunitiesToUpdate.add( oppToUpdate );
            } catch( System.CalloutException e ) {
                System.debug(  e.getMessage() );
            }
        }
        
        if ( opportunitiesToUpdate.size() > 0 ) {
            update opportunitiesToUpdate;
        }
    }
    
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        List<Opportunity> opportunitiesToBeProcessed;
        
        public QueueablePMSCall( List<Opportunity> opportunitiesToBeProcessed ) {
            this.opportunitiesToBeProcessed = opportunitiesToBeProcessed;
        }
        
        public void execute( QueueableContext context ) {
            makeCallout( JSON.serialize( opportunitiesToBeProcessed ) );
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