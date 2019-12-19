public class Activity1Controller {
 private String baseQuery = 'Select ID,subject FROM task ORDER BY subject ASC';
  public String AccFilterId {get; set;}
  private Integer pageSize = 10;

  public Activity1Controller(){}

  public ApexPages.StandardSetController AccSetController {
        get{
            if(AccSetController == null){
                AccSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                AccSetController.setPageSize(pageSize);

                // We have to set FilterId after Pagesize, else it will not work
                if(AccFilterId != null)
                {
                    
                  AccSetController.setFilterId(AccFilterId);
                }
            }
            return AccSetController;
        }set;
    }

  public Activity1Controller(ApexPages.StandardSetController c) {   }

    //Navigate to first Page
    public void firstPage()
    {
      AccSetController.first();
    }

    //Navigate to last Page
    public void lastPage()
    {
      AccSetController.last();
    }

    //Navigate to Next page
    public void next()
    {
      if(AccSetController.getHasNext())
      {
        AccSetController.next();
      }
    }

    //Navigate to Prev Page
    public void prev()
    {
      if(AccSetController.getHasPrevious())
      {
        AccSetController.previous();
      }
    }

    public List<task> getAccounts()
    {
      return (List<task>)AccSetController.getRecords();
    }

    //Get all available list view for Account
    public  SelectOption[]  getAccountExistingViews(){
        return AccSetController.getListViewOptions();
    }

    /**
    * Reset List View
    */
    public PageReference resetFilter()
    {
      AccSetController = null;
        AccSetController.setPageNumber(1);
        return null;
    }
    public list<task>  taskSetController(){
        AccSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
         AccSetController.setPageSize(pageSize);

                // We have to set FilterId after Pagesize, else it will not work
                //if(AccFilterId != null)
                //{                   
                  AccSetController.setFilterId('00B2v00000C0jrUEAR');
               // }
        AccSetController.setPageNumber(1);
        return (List<task>)AccSetController.getRecords();
    }
}