/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
 **/
public class TestDataFactory {

    public static list<task> createTaskRecord(integer size){
        list<task> tsklist=new list<task>();
        for(integer i=0;i<size;i++){
            task obj=new task(subject='test'+i,priority='High',activityDate=date.today().addDays(i),ownerId=UserInfo.getUserId(),status='Not Started');
            tsklist.add(obj);
        }
        tsklist.add(new task(subject='testoverdue',priority='High',activityDate=date.newinstance(date.today().year(), (date.today().month())-1, 17),ownerId=UserInfo.getUserId(),status='Not Started'));
        return tsklist;
    }
    
 
}