public class SendAccount {

//<strong>    Use your Client Id </strong>
String clientId ='3MVG9pe2TCoA1Pf6ke8vIXVMrsx_jqEurxk2Dsqd4FUVpLu.u9wb4rHojOIphDr4AiZxaM7_bKE4XnqBZeKJg';

//<strong> //Use your Client Secret</strong>
String clientsecret='8A77A9374001EC60854B27FAA42E51B2BFC75F7B20CACD4FC053370947B4387C';

//<strong>   //Your Destination org username</strong>
String username='rishabhvash@cloudcertitude.com';

//<strong>//Your Destination org</strong><strong>Password+Security Token</strong>
String password='aerishabh2141@Avj9hzPsNrRVSXNIsPqy8ry0Tb';

String accesstoken_url='https://login.salesforce.com/services/oauth2/token';

String authurl='https://login.salesforce.com/services/oauth2/authorize';

public class deserializeResponse {

public String id;

public String access_token;

}

public String ReturnAccessToken(SendAccount Acc){

//String reqbody = 'grant_type='+password+&amp;client_id='+clientId+'&amp;client_secret='+clientSecret+'&amp;username='+username+'&amp;password='+password;
String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
 //String reqbody='{"grant_type":"password","client_id":clientId,"client_secret":clientSecret,"username":username,"password":password}';

Http h= new Http();

HttpRequest req= new HttpRequest();

req.setBody(reqbody);

req.setMethod('POST');

//<strong>       //Change "ap4" in url to your Destination Org Instance</strong>
req.setEndpoint('https://login.salesforce.com/services/oauth2/token');

HttpResponse res=h.send(req);

System.debug(res.getBody()+'By-AP-1986-Response');

deserializeResponse resp1=
(deserializeResponse)JSON.deserialize(res.getBody(),deserializeResponse.class);

System.debug(resp1.access_token+'By-AP-deserializeresponse');
    System.debug(resp1.id+'By-AP-deserializeresponse');

return resp1.access_token;

}

@future(callout=true)

public static void createAccount(){
//String Accname, String Phone, String Website
SendAccount acc1= new SendAccount();

String accessToken=acc1.ReturnAccessToken(acc1);

System.debug(accessToken+'###AP');

if(accessToken!=null){

//<strong>           //Change "ap4" in url to your Destination Org</strong>
String endPoint='https://resumemaker-dev-ed.my.salesforce.com/services/apexrest/v1/Account/0010o00002C1McwAAF'; //<strong> </strong>

//String jsonstr='{"Name":"'+ Accname +'","Phone":"'+ Phone +'","Website":"'+ Website +'"}';

Http h2= new Http();

HttpRequest req2= new HttpRequest();

req2.setHeader('Authorization','Bearer ' + accessToken);

//req2.setHeader('Content-Type','application/json');

//req2.setHeader('accept','application/json');

//req2.setBody(jsonstr);

req2.setMethod('GET');

req2.setEndpoint(endPoint);

HttpResponse res2=h2.send(req2);

System.debug(res2+'###Akash###');

account resp1=(account)JSON.deserialize(res2.getBody(),account.class);

System.debug('### Deserialized Response ###'+resp1);

}

}

}