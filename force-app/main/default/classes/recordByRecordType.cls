public class recordByRecordType {
    @auraEnabled
    public static map<id,list<contact>> getRecd(){
        map<id,list<contact> >recmap=new map<id,list<contact>>();
        list<account>acclst=new list<account>();
       // map<id,schema.RecordTypeInfo> recMap=schema.sobjectType.account.getRecordTypeinfosById();
        for(contact rc:[select name,recordTypeId from contact ]){
            
          //system.debug([select name from account where RecordTypeId=:rc order by recordTypeid].size());
            if(!recMap.containsKey(rc.recordTypeId)){
                recMap.put(rc.recordTypeId,new list<contact>());
            }
            recmap.get(rc.recordTypeId).add(rc);
        }
        return recMap;
    }
}