({
	oninIt : function(component, event, helper) {
		var action=component.get('c.getRecd');
        action.setCallback(this,function(response){
            var cust=[];
            var conts=response.getReturnValue();
            for(var key in conts){
                cust.push({key:key,value:conts[key]});
            }
            component.set("v.conlist",cust);
             console.log(cust);
        });
        $A.enqueueAction(action);
       
	}
})