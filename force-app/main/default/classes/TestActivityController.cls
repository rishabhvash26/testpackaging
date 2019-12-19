@isTest
public class TestActivityController {
@testSetup
    public static void createTestData(){
        list <task> tasklist=TestDataFactory.createTaskRecord(40);
        insert tasklist;
    }
    
    @istest
    public static void getTaskList(){
       
       list<task>tsklist= ActivityController.getTaskList('TodaysTasks');
        system.assert(tsklist.size()>0,'assertion failed in todaysTasks');        
           tsklist=  ActivityController.getTaskList('OverdueTasks');
             system.assert(tsklist.size()>0,'assertion failed in OverdueTasks');
           tsklist=  ActivityController.getTaskList('ThisMonthTasks');
             system.assert(tsklist.size()>0,'assertion failed in ThisMonthTasks');
            tsklist= ActivityController.getTaskList('OpenTasks');
             system.assert(tsklist.size()>0,'assertion failed in OpenTasks');
    }
    
     @istest
    public static void negativeGetTaskList(){
      list<task>tsklist= ActivityController.getTaskList('');
        system.assert(tsklist==null,'assertion failed in getTaskList');  
    }
    @isTest
    public static void updateTaskList(){
       
        boolean result=ActivityController.updateTasks([select id from task limit 10]);
        system.assertEquals(true,result,'error in updateTasks');
    }
     @isTest
    public static void negativeUpdateTaskList(){
        list<task> tsklist=[select id from task limit 1];
        tsklist[0].id=null;
        boolean result=ActivityController.updateTasks(tsklist);
        system.assertEquals(false,false,'error in updateTasks');
    }
    @isTest
    public static void deleteTask(){
        list<task> tsklist=[select id from task limit 1];
        boolean result=ActivityController.deleteRecord(tsklist[0].Id);
        system.assertEquals(true,result,'error in deleteTask');
    }
    @isTest
    public static void negativeDeleteTask(){
       
        boolean result=ActivityController.deleteRecord( 'abcd');
        system.assertEquals(false,result,'error in deleteTask');
         boolean result1=ActivityController.deleteRecord( '');
        system.assertEquals(false,result1,'error in deleteTask');
    }
    @isTest 
    public static void countOfEachCategory(){
      string jsonstring=  ActivityController.countofTasks();
        system.assertEquals(true,string.isNotBlank(jsonstring),'error in countOfTasks');
    }
    
    
}