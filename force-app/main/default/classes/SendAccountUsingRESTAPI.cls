public class SendAccountUsingRESTAPI {
  private final String clientId = '3MVG9G9pzCUSkzZu6u3uUv2SwqlqThFbRgsIxxGFaDU0ibVvPqoNd0FjpudFBw5d0wFLQmgRcCYfuhXXnkKhT';
   private final String clientSecret = '503BDE94F1E9865A97773DB04E6649217137FCCB3178446632B1D9DF063DFC3B';
   private final String username = 'rishabhvash26@gmail.com';
   private final String password = 'raman1316A@LoP14I7CikmW0Z1nawDkaHHTw';
   class deserializeResponse
   {
      public String id;
      public String access_token;
   }
  public String ReturnAccessToken (SendAccountUsingRESTAPI acount)
   {
      String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
     Http h = new Http();
      HttpRequest req = new HttpRequest();
      req.setBody(reqbody);
      req.setMethod('POST');
      req.setEndpoint('https://test.salesforce.com/services/oauth2/token');
      HttpResponse res = h.send(req);
     deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
     system.debug('@@@@access_token@@'+resp1 );
      return resp1.access_token;
   }
}