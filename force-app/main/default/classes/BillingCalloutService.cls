public with sharing class BillingCalloutService {
    Map<Id,Project__c> mapOfProjects;
    // List<Project__c> projectsToUpdate;
    public static void callBillingService(List<Project__c> projectsList) {
        for (Project__c project : projectsList) {
            if(project.Status__c == 'Billable') {
                ServiceCredentials__c serviceCreds = ServiceCredentials__c.getInstance('BillingServiceCredential');
                BillingCalloutService.callBillingSystem(project.Id, project.ProjectRef__c, project.Billable_Amount__c, serviceCreds.Username__c, serviceCreds.Password__c);
            }
        }
        /* if(projectsToUpdate.size() > 0 ) {
            update projectsToUpdate;
        } */
    }

    @Future(callout=true)
    public static void callBillingSystem(Id projectId, String projectRef, Decimal amount, String username, String password) {
        BillingServiceProxy.project billingProject = new BillingServiceProxy.project();
        billingProject.username = username;
        billingProject.password = password;
        billingProject.projectid = projectRef;
        billingProject.billAmount = amount;

        Project__c project = new Project__c(Id = projectId);
        BillingServiceProxy.InvoicesPortSoap11 invoiceCall = new BillingServiceProxy.InvoicesPortSoap11();
        String billProjectResponse = invoiceCall.billProject(billingProject);
        
        if(billProjectResponse != null && billProjectResponse.equalsIgnoreCase('OK')) {
            project.Status__c  = 'Billed';
            update project;
        }
    }
}