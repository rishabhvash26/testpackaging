@RestResource( urlMapping='/project/*' )
global class ProjectRESTService {
    
    @HttpPost
    global static String postProjectData( String projectRef, String projectName, String opportunityId, Date startDate, Date endDate, Double amount, String status ) {
        
        // Creating savepoint	
        Savepoint sp = Database.setSavepoint();
        
        try {
            
            Project__c newProject = new Project__c();
            newProject.Name = projectName;
            newProject.Opportunity__c = opportunityId;
            newProject.ProjectRef__c = projectRef;
            newProject.Start_Date__c = startDate;
            newProject.End_Date__c = endDate;
            newProject.Billable_Amount__c = amount;
            newProject.Status__c = status;
            upsert newProject ProjectRef__c;
            
            Opportunity newOpportunity = new Opportunity( Id = opportunityId );
            newOpportunity.DeliveryInstallationStatus__c = 'In Progress';
            update newOpportunity;
            
            return 'OK';
            
        } catch( Exception e ) {
            // Rollback using the savepoint
            Database.rollback( sp );
            return e.getMessage();
        }
    }
}