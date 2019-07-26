public with sharing class ProjectCalloutService {

    @InvocableMethod(label='post to PMS' description='Data integreation specialist superbadge')
    public static void postOpportunityToPMS(List<Id> opportunityIdsList) {
        Opportunity opportunity;
        if(opportunityIdsList.size() > 0) {
            opportunity = [SELECT Id, Name, Account.Name, closeDate, Amount FROM Opportunity where Id = :opportunityIdsList[0]];
        }

        ServiceTokens__c serviceTokenCS = ServiceTokens__c.getValues('ProjectServiceToken');
        String serviceToken = serviceTokenCS.Token__c;

        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('opportunityId ', opportunity.Id);
        gen.writeStringField('opportunityName', opportunity.Name);
        gen.writeStringField('accountName', opportunity.Account.Name);
        gen.writeDateField('closeDate', opportunity.closeDate);
        gen.writeNumberField('amount', opportunity.Amount);
        gen.writeEndObject();    
        String jsonInputToPost = gen.getAsString();
        System.debug('jsonMaterials' + jsonInputToPost);

        System.enqueueJob(new QueueablePMSCall(serviceToken, jsonInputToPost, opportunity.Id));
        
    }

    @Future(callout=true)
    public static void postOpportunityToPMSystem(String serviceToken, String jsonInputToPost, Id opportunityId) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
        request.setHeader('token', serviceToken);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('accept', 'application/json');
        request.setBody(jsonInputToPost);
        Http http = new Http();
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 201) {
            Opportunity opp = new Opportunity(Id = opportunityId
                                                      ,StageName = 'Submitted Project');
            update opp;
        } else if(response.getStatusCode() == 500) {
            Opportunity opp = new Opportunity(Id = opportunityId
                                                      ,StageName = 'Resubmit Project');
            update opp;
        } 
    }

    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        private String serviceToken;
        private String jsonInputToPost;
        private Id opportunityId;
        public QueueablePMSCall(String serviceToken, String jsonInputToPost, Id opportunityId) {
            this.serviceToken = serviceToken;
            this.jsonInputToPost = jsonInputToPost;
            this.opportunityId = opportunityId;
        }
        
        public void execute(QueueableContext context) {
            postOpportunityToPMSystem(serviceToken, jsonInputToPost, opportunityId);
        }
    }

}