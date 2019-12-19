({
	linkClick : function(component, event, helper) {
	component.set("v.recid",event.currentTarget.dataset.value);
        component.set("v.flag",true);
    },
    doinit:function(component, event, helper){
        alert('hello');	
    var action=component.get("c.processRecords");
        action.setCallback(this,function(response){
           
            component.set("v.names",response.getReturnValue());
             console.log(component.get("v.names"));
        });
        $A.enqueueAction(action);
}
})