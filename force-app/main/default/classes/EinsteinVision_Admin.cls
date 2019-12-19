public class EinsteinVision_Admin {
    @AuraEnabled
    public static void createDatasetFromUrl(String zipUrl) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        service.createDatasetFromUrlAsync(zipUrl);
    }
    @AuraEnabled
    public static List<EinsteinVision_Dataset> getDatasets() {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        return datasets;
    }
    @AuraEnabled
    public static String trainDataset(Decimal datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Model model = service.trainDataset(Long.valueOf(String.valueOf(datasetId)), 'Training', 0, 0, '');
        return model.modelId;
    }
    @AuraEnabled
    public static void deleteDataset(Long datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        service.deleteDataset(datasetId);
    }
    @AuraEnabled
    public static List<EinsteinVision_Model> getModels(Long datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Model[] models = service.getModels(datasetId);
        return models;
    }
    @AuraEnabled
    public static string getCatPrediction( String base64,string currentTime,string currentDay,date todayDate,string name) {
    // public static string getCatPrediction( id catId ,string fileName,string base64) {
       //  system.debug('filename'+fileName);
        Blob fileBlob = EncodingUtil.base64Decode(base64);
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            system.debug(dataset.Name);
            if (dataset.Name.equals('sample6')) {
                EinsteinVision_Model[] models = service.getModels(dataset);
                EinsteinVision_Model model = models.get(0);
                EinsteinVision_PredictionResult result = service.predictBlob(model.modelId, fileBlob, '');
                system.debug(result);
                EinsteinVision_Probability probability = result.probabilities.get(0);
                system.debug(probability);
               list<Record_List__c> rcdList=new list<Record_List__c>();
                rcdlist.add(new Record_List__c(name=probability.label,time__c=currentTime,Day__c=currentDay,date__c=todayDate));
                system.debug('rcdlist'+rcdlist);
                insert rcdlist;
               /*Cat__c cat = [SELECT Id FROM Cat__C WHERE Id=:catId];
                cat.Cat_Breed__c = probability.label;
                system.debug('cat object'+cat);
                update cat;
                Attachment[] attsOld = [SELECT Id FROM Attachment WHERE ParentId=:catId];
                delete attsOld;
                Attachment att = new Attachment();
                att.Body = fileBlob;
                att.ParentId = cat.Id;
                att.Name = fileName;
                insert att;*/
                return model.modelId;
            }
        }
        return null;
    }
    @AuraEnabled
    public static List<EinsteinVision_Label> getCatLabels() {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            if (dataset.Name.equals('Cats')) {
                return dataset.labelSummary.labels;
            }
        }
        return null;
    }
    @AuraEnabled
    public static String getImageUrlFromAttachment(Id catId,string base64,string expectedLabel,string modelId) {
        List<Attachment> atts = [SELECT Id FROM Attachment WHERE ParentId=:catId];
        if (atts.size()>0) {
            return atts.get(0).Id;
        }
        return '';
    }
     @AuraEnabled
    public static void sendFeedback(Id catId,string modelId) {
       Attachment[] attsOld = [SELECT name,body FROM Attachment WHERE ParentId=:catId];        
        list<Cat__c> cat = [SELECT cat_breed__c FROM Cat__C WHERE Id=:catId];
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        service.createFeedback(modelId, cat[0].Cat_Breed__c, attsOld[0].body,attsOld[0].name);
        
    }
    

    
    }