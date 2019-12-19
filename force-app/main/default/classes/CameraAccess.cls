public class CameraAccess{
    public ContentVersion cont {get;set;}
    string empId;
    public CameraAccess() {
        
    }         
    public void methodOne(){
        string mytime=Datetime.now().format('hh:mm:ss a', 'Asia/Kolkata');        
        date todayDate=System.today();
        string name=Apexpages.currentPage().getParameters().get('name');
        String image = Apexpages.currentPage().getParameters().get('image');       
        String currentDay = Apexpages.currentPage().getParameters().get('currentDay');
        system.debug(todayDate+'.....'+currentDay+'....'+myTime);
        String blobStr = image.substring( image.indexOf('base64,')+7 , image.length());      
        EinsteinVision_Admin.getCatPrediction( blobStr,myTime,currentDay,todayDate,name);
    }
}