public class ActivityController {
   static Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.task.fields.getMap();
    @auraEnabled
    public static list<task> getTaskList(string typeOfTask){
        
            if(String.isNotBlank(typeOfTask) && fieldMap.get('subject').getDescribe().isAccessible()&&fieldMap.get('status').getDescribe().isAccessible()&&fieldMap.get('priority').getDescribe().isAccessible()&&fieldMap.get('ownerId').getDescribe().isAccessible()&&fieldMap.get('accountId').getDescribe().isAccessible()){ 
            if(typeOfTask=='TodaysTasks'){
                return [select ID,subject, Owner.name,account.name,status,priority,activitydate from task where (ActivityDate=TODAY) AND (status!='Completed')];
            }
            else if(typeOfTask=='OverdueTasks'){
                return [select ID,subject, Owner.name,account.name,status,priority,activitydate from task where (status!='Completed') and( ActivityDate<today or ActivityDate=null)];
            }
            else if(typeOfTask=='ThisMonthTasks'){
                return [select ID,subject, Owner.name,account.name,status,priority,activitydate from task where status!='Completed' and ActivityDate=THIS_Month ];
            }
            else if(typeOfTask=='OpenTasks'){
                return [select ID,subject, Owner.name,account.name,status,priority,activitydate from task where status!='completed'];
            }
        }
        return null;
    }
    @auraEnabled
    public static boolean updateTasks(list<task> taskList){
       if(taskList.size()>0&&Schema.sObjectType.Task.fields.ownerId.isUpdateable()&&Schema.sObjectType.task.fields.priority.isUpdateable()&&
          Schema.sObjectType.task.fields.Status.isUpdateable()&&Schema.sObjectType.task.fields.subject.isUpdateable()&&Schema.sObjectType.task.fields.whoId.isUpdateable()){
        try{
            update taskList;
            return true;
        } 
          
        catch(Exception e)
        {
            system.debug(e.getMessage());
            return false;
        }
       
          }
         return false;
    }
    @auraEnabled
    public static string countofTasks(){
        boolean flag;
        map<string,integer> mp1=new map<string,integer>();
        mp1.put('todaytask',0);
        mp1.put('thismonth',0);
        mp1.put('overdue',0);
        mp1.put('allopen',0);
        for(task ar:[select activitydate from task   where (status!='Completed') ])
        {
            flag=false;
            system.debug(ar);
            if((date)ar.get('activitydate')!=null&&(date)ar.get('activitydate')==date.today()){
                mp1.put('todaytask',mp1.get('todaytask')+1);
                if(!flag){
                    mp1.put('allopen',mp1.get('allopen')+1);
                    flag=true;}
            }
         
            if((date)ar.get('activitydate')!=null &&((date)ar.get('activitydate')).month()==date.today().month()){
                mp1.put('thismonth',mp1.get('thismonth')+1);
                if(!flag){
                    mp1.put('allopen',mp1.get('allopen')+1);
                    flag=true;
                }
                
            }
                       
            if((date)ar.get('activitydate')!=null&&(date)ar.get('activitydate')<date.today()||ar.get('activitydate')==null){
                mp1.put('overdue',mp1.get('overdue')+1);
                if(!flag){
                    mp1.put('allopen',mp1.get('allopen')+1);
                    flag=true;
                }
            }
            if((date)ar.get('activitydate')!=null&&(((date)ar.get('activitydate')).month()>date.today().month()||(((date)ar.get('activitydate')).year()>date.today().year()))){
                mp1.put('allopen',mp1.get('allopen')+1);
            }
         
        }
        system.debug(Json.serialize(mp1));
       return Json.serialize(mp1);
      // return mp1;
    }
    @auraEnabled
    public static boolean deleteRecord(string recordId){
        
        if(String.isNotBlank(recordId)&&Schema.sObjectType.task.isDeletable()){
        try{
             database.delete(recordId,false);
            return true;
        }
        catch(exception e){
            system.debug(e.getMessage());
            return false;
        }
       
        }
        
        return false;
    }
}