({
    doInit:function(component, event, helper){
        helper.getRecordsLength(component, event, helper);
        helper.getTasks(component, event, helper,'OpenTasks');
         $A.util.addClass(component.find('menu'), 'slds-button_icon-small');;
    },
    
    todayTaskTab: function(component, event, helper) {
        var tab1 = component.find('todayTaskTab');
        var tab2 = component.find('overdueTaskTab'); 
        var tab3 = component.find('thisMonthTaskTab');        
        var tab4 = component.find('allOpenTaskTab');       
         $A.util.addClass(tab1, 'selected');
        $A.util.removeClass(tab1, 'metro');
        $A.util.addClass(tab2, 'metro');
        $A.util.removeClass(tab2, 'selected');
         $A.util.addClass(tab3, 'metro');
        $A.util.removeClass(tab3, 'selected');
         $A.util.addClass(tab4, 'metro');
        $A.util.removeClass(tab4, 'selected');
        if(component.get("v.allRecords").length>0){
            helper.update(component,event,helper);
        }      
        helper.getTasks(component, event, helper,'TodaysTasks') ;
    },
    overdueTaskTab: function(component, event, helper) {
         var tab1 = component.find('todayTaskTab');
        var tab2 = component.find('overdueTaskTab'); 
        var tab3 = component.find('thisMonthTaskTab');        
        var tab4 = component.find('allOpenTaskTab');  
        
        $A.util.addClass(tab2, 'selected');
        $A.util.removeClass(tab2, 'metro');
        $A.util.addClass(tab1, 'metro');
        $A.util.removeClass(tab1, 'selected');
         $A.util.addClass(tab3, 'metro');
        $A.util.removeClass(tab3, 'selected');
         $A.util.addClass(tab4, 'metro');
        $A.util.removeClass(tab4, 'selected');
        if(component.get("v.allRecords").length>0){
            helper.update(component, event, helper);
        }
        helper.getTasks(component, event, helper,'OverdueTasks');
    },
    thisMonthTaskTab: function(component, event, helper) {
         var tab1 = component.find('todayTaskTab');
        var tab2 = component.find('overdueTaskTab'); 
        var tab3 = component.find('thisMonthTaskTab');        
        var tab4 = component.find('allOpenTaskTab');  
         $A.util.addClass(tab3, 'selected');
        $A.util.removeClass(tab3, 'metro');
        $A.util.addClass(tab1, 'metro');
        $A.util.removeClass(tab1, 'selected');
         $A.util.addClass(tab2, 'metro');
        $A.util.removeClass(tab2, 'selected');
         $A.util.addClass(tab4, 'metro');
         $A.util.removeClass(tab4, 'selected');
        if(component.get("v.allRecords").length>0){
            helper.update(component, event, helper);
        }
        helper.getTasks(component, event, helper,'ThisMonthTasks');
    },
    allOpenTaskTab: function(component, event, helper) {
         var tab1 = component.find('todayTaskTab');
        var tab2 = component.find('overdueTaskTab'); 
        var tab3 = component.find('thisMonthTaskTab');        
        var tab4 = component.find('allOpenTaskTab');  
        $A.util.addClass(tab4, 'selected');
        $A.util.removeClass(tab4, 'metro');
        $A.util.addClass(tab1, 'metro');
        $A.util.removeClass(tab1, 'selected');
         $A.util.addClass(tab2, 'metro');
        $A.util.removeClass(tab2, 'selected');
         $A.util.addClass(tab3, 'metro');
         $A.util.removeClass(tab3, 'selected');
        if(component.get("v.allRecords").length>0){
            helper.update(component, event, helper);
        }
        helper.getTasks(component, event, helper,'OpenTasks');
    },
    navigateToRecord : function(component , event, helper){
        window.open('/' + event.getParam('recordId'));  
    },
    /*******************************************************************************************************
    * @description This method is used to view previous page in datatable.
    * @returns void.
    */
    onPrev:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.pagination(component,event, helper);
    },   
    /*******************************************************************************************************
    * @description This method is used to view next page in datatable.
    * @returns void.
    */
    onNext:function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.pagination(component,event,helper);
    },
    newTask:function (component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/lightning/o/Task/new?nooverride=1&backgroundContext=%2Flightning%2Fpage%2Fhome'
        });
        urlEvent.fire();  
    },
    onEyeClick:function (component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/lightning/o/Task/home'
        });
        urlEvent.fire();  
    },
    onValChange:function (component, event, helper){
        var checkboxval=event.getSource().get("v.checked");
        var recordId=event.getSource().get("v.name");
        if(checkboxval){
            //component.find(recordId).classList.add("strike");
            var id=component.get("v.allRecords").findIndex(x => x.Id == recordId); 
            
            component.get("v.allRecords")[id].Status="Completed";
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type":"Success",
                "message": "Your Task Status have been updated to Closed successfully."
            });
            toastEvent.fire();
            console.log('changed',component.get("v.allRecords")[id]);
            
        }
        else if(!checkboxval){
            var id=component.get("v.allRecords").findIndex(x => x.Id == recordId); 
            
            component.get("v.allRecords")[id].Status="In Progress";
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type":"Success",
                "message": "Your Task Status have been updated to In Progress successfully."
            });
            toastEvent.fire();
            console.log('changed',component.get("v.allRecords")[id]);
        }
    },
    onRefreshClick:function(component, event, helper){
        helper.update(component, event, helper);
        helper.getRecordsLength(component, event, helper);
        helper.getTasks(component, event, helper,'OpenTasks');
        
    },
    onRecordEditOrDelete : function(component, event, helper) {
         var selectedMenu= event.detail.menuItem.get("v.value");
         var recordId=event.getSource().get("v.name");
        switch(selectedMenu) {
            case "edit":
    var editRecordEvent = $A.get("e.force:editRecord");
    editRecordEvent.setParams({
        "recordId": recordId
    });
    editRecordEvent.fire();
                break;
            case "delete":
         var index=component.get("v.allRecords").findIndex(x => x.Id == recordId);  
                component.get("v.allRecords").splice(index,1);
                if(component.get("v.allRecords").length==0){
                    component.set("v.noRecords",true);
                }
                helper.pagination(component, event, helper);
   helper.deleteTask(component, event, helper,recordId);
                helper.getRecordsLength(component, event, helper);
                break;
            
        }
        
}
})