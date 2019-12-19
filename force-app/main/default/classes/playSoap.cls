global class playSoap {
    webservice static list<string> getAcc(){
        list<string> actlist=new list<string>();
        for(account act:[select name from account])
            actlist.add(act.name);
        return actlist;
    }
  
}