trigger ProjectTrigger on Project__c (after update) {
    if ( !System.isFuture() ) {
        BillingCalloutService.callBillingService( Trigger.new, Trigger.OldMap );
    }
}