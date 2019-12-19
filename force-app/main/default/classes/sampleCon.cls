global class sampleCon {
    public list<account> records{get{
        records=[select name,industry from account];
        return records;
    }
        set;}
    @auraEnabled
    public  static list<string>  sampleCon1() {
        list<string> pklist=new list<string>();
        //contacts1=new list<selectOption>();
        schema.describefieldResult res=account.type.getDescribe();
        list<schema.PicklistEntry> lst=res.getPicklistValues();
        for(schema.PicklistEntry pk:lst)
            pklist.add(pk.getlabel());
        system.debug(pklist);
        return pklist;
        
    }
    @auraEnabled
     public  static map<string,string>  sampleCon2() {
       map<string,string> nmap= new map<string,string>();
         nmap.put('abc','1');
         nmap.put('bcd','2');
        return nmap;
        
    }
    
    @auraEnabled
    public static list<string> notesAttach(string str){
        set<string> noteslist=new set<string>();
        if(str=='Notes'){
            system.debug('in notes');
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            list<note> notesIdlst=   [select parentid from note];
            
            for(note noteId:notesIdlst){
                string keyCode=string.valueOf(noteid.parentId).substring(0,3);
                for(Schema.SObjectType objectInstance : gd.values())
                {
                    
                    if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
                    {//do your processing with the API name what you want
                        noteslist.add( objectInstance.getDescribe().getName());
                    }
                }
            }
            
        }
        
        if(str=='Attachment'){
            system.debug('in attachment');
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            list<attachment> notesIdlst=   [select parentId from Attachment];
            
            for(attachment noteId:notesIdlst){
                string keyCode=string.valueOf(noteid.parentId).substring(0,3);
                for(Schema.SObjectType objectInstance : gd.values())
                {
                    
                    if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
                    {//do your processing with the API name what you want
                        noteslist.add( objectInstance.getDescribe().getName());
                    }
                }
            }
            
        }
        list<string> notelsst=new list<string>();
        notelsst.addAll(noteslist);
        system.debug(noteslist);
        return notelsst;
    }
     @auraEnabled
    public static list<contact> processRecords()
    {   
         // Get those records based on the IDs
         //List<Account> accts = [SELECT Name FROM Account WHERE Id IN :recordIds];
       return [select name from contact limit 10];
         // Process records
    }
    
    
}