public class BillingCalloutService {
    
    public static void callBillingService ( List<Project__c> newProjects, Map<Id, Project__c> oldProjects ) { 
        
        List<Project__c> projectsToSync = new List<Project__c>();
        for ( Project__c proj : newProjects ) {
            
            Project__c oldProj = oldProjects.get( proj.Id );
            
            if ( meetCriteria( proj, oldProj ) ) {
                projectsToSync.add( proj );
            }
        }
        
        makeCallout( JSON.serialize( projectsToSync ) );
    }    
    
    @future( callout = true )
    public static void makeCallout( String serializeProjects ) {
        List<Project__c> recordsToBeProcessed = ( List<Project__c> )JSON.deserialize( serializeProjects, List<Project__c>.class );
        
        // Holds project Ids with callout responses
        Map<String, String> mapCalloutResponses = new Map<String, String>();
        
        // Credentials
        ServiceCredentials__c credentials = ServiceCredentials__c.getInstance('BillingServiceCredential');
        
        // List of Soap Requests to Process
        List<BillingServiceProxy.project> soapRequests = new List<BillingServiceProxy.project>();
        
        // Holds projects that will be updated if the callout was successfull made
        List<Project__c> projectsToUpdate = new List<Project__c>();
        
        for ( Project__c proj: recordsToBeProcessed ) {
            BillingServiceProxy.project project = new BillingServiceProxy.project();
            project.projectid = proj.ProjectRef__c;
            project.billAmount = proj.Billable_Amount__c;
            project.username = credentials.Username__c;
            project.password = credentials.Password__c;
            soapRequests.add( project );
        }
        
        // Iterating over the soap payloads, making the callout, and storing the values in the map with project reference.
        for ( BillingServiceProxy.project soapPayloads : soapRequests ) {
            BillingServiceProxy.InvoicesPortSoap11 invoiceCall = new BillingServiceProxy.InvoicesPortSoap11();
            mapCalloutResponses.put( soapPayloads.projectid, invoiceCall.billProject( soapPayloads ) );
        }
        
        // Iterating over the result to confirm if the project can be updated
        for ( String projectReference: mapCalloutResponses.keySet() ) {
            if ( mapCalloutResponses.get( projectReference ) != null &&  mapCalloutResponses.get( projectReference ).equalsIgnoreCase('OK') ) {
                Project__c projectToUpdate = new Project__c( ProjectRef__c = projectReference );
                projectToUpdate.Status__c = 'Billed';
                projectsToUpdate.add( projectToUpdate );	
            }
        }
        
        if ( projectsToUpdate.size() > 0 ) {
            upsert projectsToUpdate ProjectRef__c;
        }
    }
    
    public static Boolean meetCriteria( Project__c newProject, Project__c oldProject ) {
        if ( newProject.Status__c == 'Billable' && newProject.Status__c != oldProject.Status__c ) {
            return true;
        }
        
        return false;
    }
}