({
    onUploadImage: function(component, file, base64Data) {
        var action = component.get("c.getCatPrediction");
        var catId = component.get("v.recordId");
        console.log('filename',file.name);
        action.setParams({
            catId: catId,
            fileName: file.name,
            base64: base64Data
        });
        action.setCallback(this, function(a) {
            component.set("v.spinnerWaiting", false);
            var state = a.getState();
            if (state === 'ERROR') {
                console.log(a.getError());
                alert("An error has occurred");
            } else {
               
                component.set("v.modelId",a.getReturnValue());
                 console.log(component.get("v.modelId"));
               $A.get('e.force:refreshView').fire();
            }
        });
        component.set("v.spinnerWaiting", true);
        $A.enqueueAction(action);
    },
    onGetImageUrl: function(component, file, base64Data) {
        var action = component.get("c.getImageUrlFromAttachment");
        var catId = component.get("v.recordId");
        action.setParams({
            catId: catId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === 'ERROR') {
                console.log(a.getError());
                alert("An error has occurred");
            } else {
                if (!a.getReturnValue()=='') {
                    component.set("v.image", "/servlet/servlet.FileDownload?file=" + a.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },
     SendFeedback: function(component) {
         console.log('in sendfeedback');
        var action = component.get("c.sendFeedback");
        var catId = component.get("v.recordId");
        action.setParams({
            catId: catId,
           modelId: component.get("v.modelId"),
            
           
        });
        action.setCallback(this, function(a) {
            component.set("v.spinnerWaiting", false);
            var state = a.getState();
            if (state === 'ERROR') {
                console.log(a.getError());
                alert("An error has occurred");
            } else {
                console.log('sendfeedbacksuccessful');
               // component.get("c.modelId",a.getReturnValue());
               $A.get('e.force:refreshView').fire();
            }
        });
        component.set("v.spinnerWaiting", true);
        $A.enqueueAction(action);
    }
})