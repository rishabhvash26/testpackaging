public class practicecontroller {
    public list<opportunity>opplist{
        get{
            opplist=[select name from opportunity];
            return opplist;
        }
        set;
    }
}