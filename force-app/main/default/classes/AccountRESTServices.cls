@RestResource(urlMapping='/account/*')
global with sharing class AccountRESTServices {
    @HttpPost
    global static String deleteAccount() {
        Account accountToDelete;
        RestRequest request = RestContext.request;
        // RestResponse response = RestContext.response;
        String connectionId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        try {
            List<Account> accountList = [SELECT Id, Name FROM Account WHERE ConnectionId__c = :connectionId LIMIT 1];
            if(!accountList.isEmpty()) {
                accountToDelete = accountList[0];
                delete accountToDelete;
            }
            return 'Account with ' + connectionId + ' has been deleted';
        } catch (Exception ex) {
            return 'Account with ' + connectionId + ' failed to delete' 
                    + 'Here is the error msg: ' + ex;
        }
    }

    @HttpGet
    global static String getSObjectDetail() {
        String resultToReturn;
        RestRequest request = RestContext.request;
        // RestResponse response = RestContext.response;
        Map<String,String> parametersMap = request.params;
        String connectionId = parametersMap.get('connectionId');
        try {
            if(parametersMap.get('action') == 'getAccount') {
                resultToReturn = AccountRESTServices.getAccountLinkedWithconnectionId(connectionId);
            } else if(parametersMap.get('action') == 'getUser') {
                resultToReturn = AccountRESTServices.getUserLinkedWithconnectionId(connectionId);
            }
            return resultToReturn + ' exist with connection Id = ' + connectionId;
        } catch (Exception ex) {
            return 'An exception has ocured.' + ex;
        }
        
    }

    private static String getAccountLinkedWithconnectionId(String connectionId) {
        Account result = [SELECT Id, Name FROM Account WHERE ConnectionId__c = :connectionId ][0];
        return result.Name;
    }

    private static String getUserLinkedWithconnectionId(String connectionId) {
        User result = [SELECT Id, Name, isActive FROM User WHERE Connection_Id__c = :connectionId ][0];
        return result.Name;
    }
}