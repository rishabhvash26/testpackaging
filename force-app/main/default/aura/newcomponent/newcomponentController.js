({

createButtonDynamically : function(component, event, helper) {

//Creating button dynamically

var db=component.find("newtag");

$A.createComponent (

"ui:button",

{

"label":"New Button"+db.get("v.body").length,

"press": component.getReference("c.showPressedButtonLabel")

},

function(dynamicButton, status, errorMessage)

{

//Add the new button to the body array

if (status === "SUCCESS") {

var bdy=db.get("v.body");

bdy.push(dynamicButton);

db.set("v.body",bdy);

}

else if (status === "INCOMPLETE") {

console.log("No response from the server!")

}

else if (status === "ERROR") {

console.log("Error: " +errorMessage);

}

}

);

},
})