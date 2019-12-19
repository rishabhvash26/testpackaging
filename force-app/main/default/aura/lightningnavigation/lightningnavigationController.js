({
	onbtnClick : function(component, event, helper) {
        
         var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url" : 'https://lwc26-dev-ed--c.visualforce.com/apex/accontdetail?core.apexpages.request.devconsole=1' ,
        "isredirect":true
    });
    urlEvent.fire();
	}
})