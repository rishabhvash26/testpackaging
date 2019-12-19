public class EinsteinVision_FeedbackDataset extends EinsteinVision_HttpBodyPart {
 public enum Types {
        BASE64,
        FILEBLOB,
        URL
    }
    
    private String modelId;
    private string data;
    private String ExpectedLabel;
    private Types type;
    private String sampleId;
     private string bodyBlob;
     private EinsteinVision_PredictionService predictionService;
    
    public EinsteinVision_FeedbackDataset(String modelId,string ExpectedLabel, string data, Types type,string sampleiId) {
        this.modelId = modelId;
        system.debug('base64'+data);
        this.sampleId=sampleId;
        this.data = data;
        this.Expectedlabel = Expectedlabel;
        this.type = type;
    }
    
    public blob build() {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('modelId', modelId);
        body += WriteBoundary();
        body += WriteBodyParameter('expectedLabel', ExpectedLabel);
        
      /*  if (sampleId!=null && !sampleId.equals('')) {
            body += WriteBoundary();
            body += WriteBodyParameter('sampleId', sampleId);
sampleBase64Content
        }*/
        body += WriteBoundary();
        if (type==Types.BASE64) {
            body += WriteBodyParameter('data', data);
        } else if (type==Types.URL) {
            body += WriteBodyParameter('sampleLocation', data);
        }
        body += WriteBoundary(EndingType.CrLf);
        system.debug('body=='+body);
        blob bdblob=EncodingUtil.base64Decode(body);
         bodyBlob =  body;
        return bdblob;
    }
    public void uploadFile( EinsteinVision_PredictionService predictionService){
        this.predictionService=predictionService;
          HttpRequest request = new HttpRequest();
        
            request.setHeader('Authorization', 'Bearer ' + predictionService.getBearerToken());
            request.setHeader('Cache-Control', 'no-cache');
            
           // request.setMethod('GET');
         request.setHeader('Content-Type', EinsteinVision_HttpBodyPart.GetContentType());
        
                request.setBody(bodyBlob);			
        request.setMethod('POST');
            

            request.setEndpoint('https://api.einstein.ai/v2/vision/feedback');
            system.debug('request body'+request.getBody());

             Http http = new Http();
             HTTPResponse response = http.send(request);
system.debug('status code'+response.getStatusCode());
        system.debug('status code'+response.getBody());
    }
    
    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        this.modelId = modelId;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getExpectedLabel() {
        return Expectedlabel;
    }

    public void setExpectedLabel(String Expectedlabel) {
        this.Expectedlabel = Expectedlabel;
    }

    public Types getType() {
        return type;
    }

    public void setType(Types type) {
        this.type = type;
    }

    
}