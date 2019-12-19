@isTest(SeeAllData=false)
public class TesClasstForSeeAllData{
   
    @isTest (SeeAllData=true)
    public static void testMethodForSeeAllData() {
        
        Pricebook2 pricebookRecord = [Select Id from Pricebook2 LIMIT 1];
        System.debug('############# pricebookRecord '+pricebookRecord);

        Product2 productRecord = [Select Id from Product2 LIMIT 1];
        System.debug('############# productRecord'+productRecord);

        Id IdstdPriceBookId = Test.getStandardPricebookId();
        System.debug('############# '+IdstdPriceBookId );
    }
    
}