public class ProjectCalloutService{
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Post Opportunity To PMS' description='Posts Opportunity details to PMS')
	public static void postOpportunityToPMS(List<Id> opportunityIds){

        String jsonOpp;
        String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;

        // query 
        List<Opportunity> opps = new List<Opportunity>([SELECT Name, Account.Name, CloseDate, Amount
                                                        FROM Opportunity WHERE Id IN :opportunityIds]);
        if (opps.size()>0){
            for (Opportunity opp:opps){
                jsonOpp = '{"opportunityId" : "' + opp.Id + 
                '", "opportunityName" : "'+opp.Name+
                '", "accountName" : "'+opp.Account.Name+
                '", "closeDate" : "'+String.ValueOf(opp.CloseDate) +   
                '", "amount" : "'+opp.Amount+'"}';
                system.debug(jsonOpp);
                System.enqueueJob(new QueueablePMSCall(jsonOpp, serviceToken, opp.Id));
            }
        }
    
    }

    
    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{

        private String serviceToken;
        private String jsonInput;
        private String oppId;
        
        public QueueablePMSCall(String jsonInput, String serviceToken, Id oppId){
            this.jsonInput = jsonInput;
            this.serviceToken = serviceToken;
            this.oppId = oppId;
        }

        public void execute(QueueableContext qc){
            postToPMS(jsonInput, serviceToken, oppId);
        }
    }

//    @Future(callout=true)
    private static void postToPMS(String jsonInput, String serviceToken, Id oppId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
        request.setHeader('token',serviceToken);
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setBody(jsonInput);
        system.debug('Request: ' + request);
        response = http.send(request);
        system.debug('Response: ' + response);
        
        Opportunity opp = new Opportunity (Id = oppId);
        if (response.getStatusCode()==201){
            opp.StageName = 'Submitted Project';    
        } else {
            opp.StageName = 'Resubmit Project';
        }
        update opp;


    }

 
}