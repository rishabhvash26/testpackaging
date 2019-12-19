({
	onIt : function(component, event, helper) {
        var action=component.getEvent("cevent");
        action.fire();
		
	},
    handle : function(component, event, helper){
        alert("in grandchild");
    }
})