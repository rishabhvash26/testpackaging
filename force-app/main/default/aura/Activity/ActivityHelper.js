({
    getTasks:function(component,event,helper,typeOfTask){
        var action = component.get("c.getTaskList");
        action.setParams({ typeOfTask : typeOfTask });     
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('alltasks',response.getReturnValue());
            if (state === "SUCCESS" && response.getReturnValue()!=null) {
                //alert();
                if(response.getReturnValue().length==0){
                    component.set("v.noRecords",true);
                    component.set("v.todaytasklist",[]);
                    component.set("v.pageNumber",0);
                    component.set("v.totalPages",0);
                }
                else{
                    component.set("v.noRecords",false);                
                    var resultData = response.getReturnValue();               
                    var dataSize=resultData.length;
                    component.set("v.dataSize", resultData.length);
                    component.set("v.allRecords",resultData);                                      
                    var recSize=parseInt(component.get("v.pageSize"));
                    var num=0;
                    var pgNumber=0;
                    var pagecount=0;
                    var taskRecords=[];
                    var dataSize=component.get("v.allRecords").length;
                    var recSize=component.get("v.pageSize");
                    for(var i=0;i<dataSize;i++){
                        if(component.get("v.allRecords")[i]!='undefined'){
                            component.get("v.allRecords")[i].checkboxVal=false; 
                            if(component.get("v.allRecords")[i].hasOwnProperty('ActivityDate')==false){
                                component.get("v.allRecords")[i].ActivityDate=null;
                            }
                        }                
                    }
                    for(var i=0;i<dataSize;i++){
                        if(num>=recSize){
                            break;
                        }
                        if(component.get("v.allRecords")[i]!='undefined'){
                            
                            taskRecords.push(component.get("v.allRecords")[i]);
                            num++;                    
                        }                
                    }
                    console.log(taskRecords);
                    component.set("v.paginationList",taskRecords);         
                    component.set("v.showspinner",false);
                    component.set("v.todaytasklist",component.get("v.paginationList"));
                    component.set("v.showFooter",true);               
                    pagecount= Math.ceil(dataSize/recSize);
                    component.set("v.totalPages",pagecount);
                    component.set("v.pageNumber",1);
                    pgNumber=component.get("v.pageNumber");
                    
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    /*******************************************************************************************************
    * @description This method is used  handle pagination in datatable.
    * @returns void.
    */
    pagination:function(component,event,helper){
        var allRecords=[];
        var totalPages=0;        
        console.log(component.get("v.allRecords").length);
        allRecords=component.get("v.allRecords"); 
        totalPages=Math.ceil((allRecords.length)/component.get("v.pageSize"));
        var total=allRecords.length;   
        var recSize=parseInt(component.get("v.pageSize"));
        var pgNumber=component.get("v.pageNumber");       
        var start=(parseInt(component.get("v.pageNumber"))-1)*parseInt(component.get("v.pageSize"));       
        var j=0;
        var tempArray=[];      
        for(var i=start;i<total;i++){
            if(j>=recSize){
                break;  
            }
            if(allRecords[i]!='undefined'){               
                tempArray.push(allRecords[i]);
                j++;               
            }            
        }   
        console.log("pgnumber",pgNumber);
        console.log("totalPages",totalPages);
        if(pgNumber==totalPages){
            component.set("v.isLastPage", true);
        } else{
            component.set("v.isLastPage", false);
        }
        console.log('after pagination',tempArray);
        component.set("v.paginationList",tempArray);
        component.set("v.todaytasklist", tempArray);
    },
    getRecordsLength:function(component,event,helper){
        var action = component.get("c.countofTasks");
        //action.setParams({ listViewName : typeOfTask });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var tasklist= JSON.parse(response.getReturnValue());
                console.log(tasklist.allopen);
                component.set("v.todaytasklistlength",tasklist.todaytask);
                component.set("v.overduetasklistlength",tasklist.overdue);
                component.set("v.thismonthtasklistlength",tasklist.thismonth);
                component.set("v.allopentasklistlength",tasklist.allopen);             
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    update:function(component,event,helper){       
        var updateResult=[];
        for(var i=0;i<component.get("v.allRecords").length;i++){
            
            if(component.get("v.allRecords")[i].Status=="Completed"||component.get("v.allRecords")[i].Status=="In Progress")
                updateResult.push(component.get("v.allRecords")[i]);
        }
        console.log('updresult',updateResult);
        var action = component.get("c.updateTasks");
        action.setParams({ taskList : updateResult });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {        
                //do something
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    deleteTask:function(component,event,helper,recordId){
        
        var action = component.get("c.deleteRecord");
        action.setParams({ recordId : recordId });               
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"Success",
                    "message": "Selected record has been deleted successfully."
                });
                toastEvent.fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    }
    
})