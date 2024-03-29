({
    onCreateDataset: function(component) {
        var action = component.get("c.createDatasetFromUrl");
        var zipUrl = component.find("zipUrl").get("v.value");
        var self = this;
        action.setParams({
            zipUrl: zipUrl
        });
        action.setCallback(this, function(response) {
            component.set("v.waiting", false);
            var state = response.getState();
            if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        return alert(errors[0].message);
                    }
                } else {
                    return console.log("Unknown error");
                }
            }
            var result = response.getReturnValue();
            self.onLoadDatasets(component);
        });
        component.set("v.waiting", true);
        $A.enqueueAction(action);
    },
    onLoadDatasets : function(component) {
        var self = this;
        var action = component.get("c.getDatasets");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        return alert(errors[0].message);
                    }
                } else {
                    return console.log("Unknown error");
                }
            }
            component.set("v.datasets", response.getReturnValue());
            var dataset = response.getReturnValue();
            if (dataset && dataset.length>0) {
	            self.onModelStatus(component, dataset);
            } else {
		        component.set("v.spinnerWaiting", false);
            }
        });
        component.set("v.spinnerWaiting", true);
        $A.enqueueAction(action);
    },
    onModelStatus : function(component, datasets) {
        var action = component.get("c.getModels");
        action.setParams({
            datasetId: datasets[0].id
        });
        action.setCallback(this, function(response) {
            component.set("v.spinnerWaiting", false);
            var state = response.getState();
            if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        return alert(errors[0].message);
                    }
                } else {
                    return console.log("Unknown error");
                }
            } else {
                
                component.set("v.models", response.getReturnValue());
            }
        });
        component.set("v.spinnerWaiting", true);
        $A.enqueueAction(action);
    },
    onDeleteDataset : function(component, event) {
        var action = component.get("c.deleteDataset");
        var datasetId = event.getSource().get("v.value");
        var self = this;
        action.setParams({
            datasetId: datasetId
        });
        action.setCallback(this, function(response) {
            component.set("v.spinnerWaiting", false);
            var state = response.getState();
            if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        return alert(errors[0].message);
                    }
                } else {
                    return console.log("Unknown error");
                }
            }
            self.onLoadDatasets(component);
        });
        component.set("v.spinnerWaiting", true);
        $A.enqueueAction(action);
    },
    onTrainDataset : function(component, event) {
        var action = component.get("c.trainDataset");
        var datasetId = event.getSource().get("v.value");
        var self = this;
        action.setParams({
            datasetId: datasetId
        });
        action.setCallback(this, function(response) {
            component.set("v.spinnerWaiting", false);
            var state = response.getState();
            if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        return alert(errors[0].message);
                    }
                } else {
                    return console.log("Unknown error");
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "The model id for the training is " + response.getReturnValue() + ". Refresh the dataset for seeing the training progress."
                });
                toastEvent.fire();
            }
        });
        component.set("v.spinnerWaiting", true);
        $A.enqueueAction(action);
    }
    
})