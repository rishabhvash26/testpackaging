public class httpClientCopy {
 private String url;
    private Boolean isDelete = false;
    private Boolean isPost = false;
    private Boolean isPut = false;
    private EinsteinVision_PredictionService predictionService;
    private JSONParser parser;
    private string body;

    // Values for HTTP response
    private String errorMessage;
    private Integer statusCode;
    private String statusMessage;


    public httpClientCopy(EinsteinVision_PredictionService predictionService, String url) {
        this.predictionService = predictionService;
        this.url = url;
    }

    public httpClientCopy(EinsteinVision_PredictionService predictionService, String url, string body) {
        system.debug('blobBdy--->'+ body);
        this.predictionService = predictionService;
        this.url = url;
        this.body = body;
        isPost(true);
    }

    public boolean isDelete() {
        return isDelete;
    }

    public void isDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }

    public boolean isPost() {
        return isPost;
    }

    public void isPost(boolean isPost) {
        this.isPost = isPost;
    }
    
    public boolean isPut() {
        return isPut;
    }

    public void isPut(boolean isPut) {
        this.isPut = isPut;
    }

    public void execute() {
        if (url!=null) {
            
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer ' + predictionService.getBearerToken());
            request.setHeader('Cache-Control', 'no-cache');
            
            request.setMethod('GET');

            if (isDelete()) {
                request.setMethod('DELETE');
            } else if (isPost() || isPut()) {
                request.setHeader('Content-Type', EinsteinVision_HttpBodyPart.GetContentType());
                request.setBody(body);
                if (isPut()) {
                    request.setMethod('PUT');
                } else {
                    request.setMethod('POST');
                }
            }

            request.setEndpoint(url);
            system.debug('request body'+request.getBody());

             Http http = new Http();
             HTTPResponse response = http.send(request);
system.debug('status code'+response.getStatusCode());
            predictionService.isExecuting(true);
            
            updateResponseValues(response);
        }
    }

    public Boolean isError() {
        return (getStatusCode()!=200 && getStatusCode()!=204);
    }

    public Integer getStatusCode() {
        return statusCode;
    }

    public String getStatusMessage() {
        return statusMessage;
    }

    public String getResponseError() {
        return errorMessage;
    }

    private void updateResponseValues(HTTPResponse response) {
    system.debug('responded body'+response.getBody());
        statusCode = response.getStatusCode();
        statusMessage = response.getStatus();
        if (getStatusCode()==400 || getStatusCode()==200) {
            try {
                parser = JSON.createParser(response.getBody());
            } catch (Exception e) {
                errorMessage = 'Could not read JSON data';
                return;
            }
            if (getStatusCode()==200) {
                Boolean hasDataToken = false;
                while (parser.nextToken()!=null) {
                    if (parser.getCurrentToken()==JSONToken.FIELD_NAME) {
                        String currentProperty = parser.getText();
                        if (currentProperty=='data' || currentProperty=='metricsData') {
                            parser.nextToken();
                            hasDataToken = true;
                            break;
                        }
                    }
                }
                if (!hasDataToken) {
                    parser = JSON.createParser(response.getBody());
                }
            } else {
                while (parser.nextToken()!=null) {
                    if (parser.getCurrentToken()==JSONToken.FIELD_NAME) {
                        String currentProperty = parser.getText();
                        if (currentProperty=='message') {
                            parser.nextToken();
                            errorMessage = parser.getText();
                            break;
                        }
                    }
                }
            }
        }
        predictionService.isExecuting(false);
    }

    public String getUrl() {
        return url;
    }

    public JSONParser getParser() {
        return parser;
    }
}