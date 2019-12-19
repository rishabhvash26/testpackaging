({
	createRecord : function (component, event, helper) {
    var navEvt = $A.get("e.force:navigateToURL");
       // alert(component.get("v.record"));
    navEvt.setParams({
      "url":'https://lwc26-dev-ed.my.salesforce.com/0032v00002jTO6I',
        "isredirect":true,
    });
    navEvt.fire();
}
})