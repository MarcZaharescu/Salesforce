public class retrieveGAdata {
   
    public static string token; 
    public static final string sDate = 'yesterday'; 
    public static final string eDate = 'yesterday'; 
    
 
    class JsonGA { 
      List <List <string>> rows; 
    } 
    
    @future(callout=true)
    public static void main(){
        token = getToken(); 
        string s = getReportGa(sDate,eDate,token); 
        JsonGA data = (JsonGA) JSON.deserialize(s, JsonGA.class); 
        saveDataToSF(data.rows);
        
 
    }
    
    public  retrieveGAdata()
    {   
 
    }
    
    public static void saveDataToSF(List<List<String>> jsonData)
    { 
        MAP<String, String> contactMap = new Map<String ,String>();
      
        Integer j=0;
        for(List<String> rows : jsonData)
        {
            j=j+1;
            Integer i=0;
            String uData='';
            String contactNr;
            for(String cell: rows)    
            { i=i+1;
             
                if(i==7)
                    contactNr=cell;
                    
                if(i!=7)
                    uData+=cell +'~';
     
            }
             contactMap.put(contactNr,uData);
            
            
          
        }
       
        List<Contact> contactsToUpdate = new List<Contact>([Select id, 	MBACOID__c from Contact where	MBACOID__c in: contactMap.keyset() ]);
        List<Lead> leadsToUpdate= new List<Lead>([Select id, MBACOID__c from Lead where MBACOID__c in: contactMap.keyset() and isConverted =false]);
        
        system.debug('Total companies found: ' + contactMap.size()); 
        system.debug('Found contacts: ' + contactsToUpdate.size());
        system.debug('Found leads: ' + leadsToUpdate.size());
      
        
        //update the contacts
        for(Contact c: contactsToUpdate)
        {
            String[] s= contactMap.get(c.MBACOID__c).split('~');
            
            {
                //system.debug(c);
                //0 - days since last session
                //1 - campaign
                //2 - source/medium
                //3 - social network
                //4 - country
                //5 - city
                //6 - #sessions
                //7 - session duration
                //8 - session date
                //9 - monthly logins
                c.GA_Days_Since_Last_Session__c= Integer.valueof(s[0]);
                c.GA_Campaign__c = s[1];
                c.GA_City__c = s[5];
                c.GA_Country__c=s[4];
                c.GA_Social__c=s[3];
                c.GA_Source_Medium__c=s[2];
                c.GA_Sessions__c=Integer.valueOf(s[6]);
                c.GA_Session_Duration__c = Integer.valueof(s[7]);
                c.GA_Session_date__c = Date.today().addDays(-1);
                
                if(c.GA_Monthly_Sessions__c!=null)
                c.GA_Monthly_Sessions__c= c.GA_Monthly_Sessions__c+1;
                 else
                c.GA_Monthly_Sessions__c=1;
                  
         
            }
            
        }
        
        update contactsToUpdate;
        
        //update the leads
                for(Lead l: leadsToUpdate)
        {
            String[] s= contactMap.get(l.MBACOID__c).split('~');
          
            {
                //system.debug(c);
                //0 - days since last session
                //1 - campaign
                //2 - source/medium
                //3 - social network
                //4 - country
                //5 - city
                //6 - #sessions
                //7 - session duration
                //8 - session date
                //9 - monthly logins
                l.GA_Days_Since_Last_Session__c= Integer.valueof(s[0]);
                l.GA_Campaign__c = s[1];
                l.GA_City__c = s[5];
                l.GA_Country__c=s[4];
                l.GA_Social__c=s[3];
                l.GA_Source_Medium__c=s[2];
                l.GA_Sessions__c=Integer.valueOf(s[6]);
                l.GA_Session_Duration__c = Integer.valueof(s[7]);
                l.GA_Session_Date__C = Date.today().addDays(-1);
                 
                 if(l.GA_Monthly_Sessions__c!=null)
                l.GA_Monthly_Sessions__c= l.GA_Monthly_Sessions__c+1;
                 else
                l.GA_Monthly_Sessions__c=1;
               
                
            }
            
            
        }
        
        update leadsToUpdate;
        
    
        
    }
     
    
 public  static string getReportGA(String startDate, String endDate, String accessToken) { 

 Http h = new Http(); 
 HttpRequest req = new HttpRequest(); 
 HttpResponse res = new HttpResponse(); 
 req.setEndpoint('https://www.googleapis.com/analytics/v3/data/ga?ids=ga%3A106432907&max-results=10000&start-date='+startDate+'&end-date='+endDate+'&metrics=ga%3Asessions%2Cga%3AsessionDuration&dimensions=ga%3AdaysSinceLastSession%2Cga%3Acampaign%2Cga%3AsourceMedium%2Cga%3AsocialNetwork%2Cga%3Acountry%2Cga%3Acity%2Cga%3Adimension2&filters=ga%3AsessionDuration%3E1&access_token='+accessToken); 
 req.setMethod('GET'); 
 req.setHeader('ContentSize','0'); 
  
  // bypass test callout   
 if(!Test.isRunningTest()) 
 res=h.send(req); 
     
 String response_debug = res.getBody() +' '+ res.getStatusCode(); 
 
    
	if(res.getStatusCode() == 200) { 
	integer index = res.getBody().indexOf('"rows"'); 
	if(index > 0) return ('{'+res.getBody().substring(index)); 
	} 
	 
  if(Test.isRunningTest()) 
    return '{"rows":[["(not set)","(direct)","(none)","(not set)","(not set)","1268671129.1461742784","20160427","1"],["(not set)","(direct)","(none)","(not set)","(not set)","1552591024.1461739405","20160427","1"],["(not set)","google","organic","(not set)","(not set)","1193545818.1461677175","20160426","1"],["(not set)","google","organic","(not set)","(not set)","1398384632.1461756110","20160427","1"],["(not set)","google","organic","(not set)","(not set)","2044217737.1461681684","20160426","1"],["(not set)","google","organic","(not set)","(not set)","464202607.1461748103","20160427","1"],["(not set)","google","organic","(not set)","(not set)","506164572.1458026944","20160427","1"],["(not set)","google","organic","(not set)","(not set)","591527855.1461734167","20160427","1"],["(not set)","vendeefintech.com","referral","(not set)","(not set)","1091463501.1461677672","20160426","1"],["CFO ROLE","ppc","LinkedIn","DE","(not set)","282778109.1461693678","20160426","1"],["CFO ROLE","ppc","LinkedIn","DE Sponsored","(not set)","1455442275.1461748783","20160427","1"],["CFO ROLE","ppc","LinkedIn","DE Sponsored","(not set)","2050299093.1461654806","20160426","1"],["CFO Role","ppc","LinkedIn","FR","(not set)","365958580.1461659954","20160426","1"],["CFO Role","ppc","LinkedIn","FR Sponsored","(not set)","2127801427.1461697646","20160426","1"],["CFO Role","ppc","LinkedIn","FR Sponsored","(not set)","455649687.1461672141","20160426","1"],["MainADV","ppc","LinkedIn","IT Sponsored","(not set)","119193884.1459863673","20160426","1"]]}'; 
 else   
    return '{'+response_debug;
} 
 

    
public static String getToken(){

Http h = new Http();
HttpRequest req = new HttpRequest();
HttpResponse res = new HttpResponse();
req.setEndpoint('https://accounts.google.com/o/oauth2/token');
req.setMethod('POST');

req.setHeader('ContentType','application/x-www-form-urlencoded');

String header = '{"alg":"RS256","typ":"JWT"}';
String header_encoded = EncodingUtil.base64Encode(blob.valueof(header));

String claim_set = '{"iss":"ga-salesforce-integration-1300@appspot.gserviceaccount.com"';
claim_set += ',"scope":"https://www.googleapis.com/auth/analytics.readonly"';
claim_set += ',"aud":"https://accounts.google.com/o/oauth2/token"';
claim_set += ',"exp":"' + datetime.now().addHours(1).getTime()/1000;
claim_set += '","iat":"' + datetime.now().getTime()/1000 + '"}';

String claim_set_encoded = EncodingUtil.base64Encode(blob.valueof(claim_set));

String signature_encoded = header_encoded + '.' + claim_set_encoded;

String key = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCZgpxiY1KpEf7fG5Nz1+3ls3kZlj/s07YKWE9G5wqu6tDYpQjBxUJLhhsf3G+PxL/paxL6q6kOFGtdXrPSI2tZn7SQskujzuTC2R0Jvh6hY2fx+TLa61wUBSI2tVX/VnyhUseGxVZ6cXpeqemUaS1Xm40o4vX6VNDmGgVPcURVioczyn+/KO9sLwkiyo2vrDFVti0tZzRs+T+ok3LnrSXVk2uNT51mbNWP8Iz4lMAOnYryQfYI60w0p3G2LO7cbBBLowLswYN6krDG9Rxyk9ReBTYNE4p13qblQcw69Iipm3/+w59MiCiIzL49Kk3l5R/P94L+I1coEUf0G5WSg5C7AgMBAAECggEAJIkvi0M0c0TzMkqv54xm9JqooexevpEM7J1kEO4AXu1IU6fD08qNIsiCQC0I6GDdhEKVu8+LZux5OTnG9qazcBtQsHefBRfC3pUqEh2L0MGGBdNXxT7rJWCrafXyx9jfxM2c63igQngrtcge7dGylv1QtYB/Jtt09K8QwH2m0+zL1QMYJLJtTYTYoIRanUWqIYgEXFfkKnCCmGqikooyYYGTVFTbwh5CLglf6UDyU68GUWuioOesZa17FK9BzbWHFmH10EXhL85d9BLWanV836oMFl9eGvhGhtzRya/Sgso1HS83570X5xcXD2N5fUyBZ7vQ8hGsACX3YEsxcC7+8QKBgQDYL2dd4bU29jWkUQ01ANYHw6j3Sds4biF+TfymFvpEGWrd83l50+YCRW1DaLbaZ0VR8eq3r36podaYqOUQDXp/cf2HP1pXA4ulbVh0wR5SG1QWBTme4I940dlkIRfEBOyTizUbXLTSge5bctyA0Ta0zSAAFgzREeUQ2jske4B1zQKBgQC1yDy1WZX07MOwsAudZCffdyptIH+JEhmNR1VloLqtz6gx23ubXde7wDrHRTWULCGaMCJlGz/XPCkZ4MPO+JOK8XXAtDPpDFJZIyzxykatzM2e/WOcsyxtRw1GSINAex2LZg9u2P73SqsUEZcmYlg91yHQvGNdhKlJBORzZdmYpwKBgA6FUJobuQJSE1RQJWT0A2xOFiFWEqV9sD49msTFMlY0ptr1qaknNIHei/JFLFMLMLrKVwuze/yE5FcosQoc/adlzrOw666AjHa2G4TsG89ECqfX/gDP8JMa9VEmb+Q4uHNInG6UEYk6NPprgqgcZWJLjOS0lnPMkehJ4EMZEI3ZAoGBALEls1OfO+11FbcHuCnnQpwYyvWRp/dx9gihrWzeV02ugeAkXa6oouXKjP1IStBcuVpC8iHJjks3y232hZsazt2mNPRYKAZCBbXr+46daodQgEkh8YLxcKgFh8AoRg/+ampASWXifYWL9HAYPE4hpJCPJ9r823B1KWuJIv/6DzUdAoGABKFKjjsHh4xaRk3MHGTeb5PUITcM3pCR+TaqrrndqlRas4nuZyZC7mxcpryJcwAMI3biGVTxphyQzEHqBlg/2DK9K47Lx28EQ5TbDtBd0aZgiFRf1gj8eoXxA9z42miZdDhM0lmoC3+Qyn1aKF9iDL5y2EbUbAtzC5VEUrDHGkY';

blob private_key = EncodingUtil.base64Decode(key);
signature_encoded = signature_encoded.replaceAll('=','');
String signature_encoded_url = EncodingUtil.urlEncode(signature_encoded,'UTF-8');
blob signature_blob =   blob.valueof(signature_encoded_url);

String signature_blob_string = EncodingUtil.base64Encode(Crypto.sign('RSA-SHA256', signature_blob, private_key));

String JWT = signature_encoded + '.' + signature_blob_string;

JWT = JWT.replaceAll('=','');

String grant_string= 'urn:ietf:params:oauth:grant-type:jwt-bearer';
req.setBody('grant_type=' + EncodingUtil.urlEncode(grant_string, 'UTF-8') + '&assertion=' + EncodingUtil.urlEncode(JWT, 'UTF-8'));
if(!Test.isRunningTest())
res = h.send(req);
String response_debug = res.getBody() +' '+ res.getStatusCode();
 
if(res.getStatusCode() == 200) {
    JSONParser parser = JSON.createParser(res.getBody());
    while (parser.nextToken() != null) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
            // Move to the value.
            parser.nextToken();
            // Return the access_token
            return parser.getText();
        }
    }
}
return 'error';
    
}
    
}