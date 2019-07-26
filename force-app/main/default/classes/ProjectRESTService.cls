@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String	projectRef, String projectName, String opportunityId, Date startDate, Date endDate, Double amount, String status) {
        Savepoint savepoint = Database.setSavepoint();
        Project__c project = new Project__c();
        List<Project__c> projectsList = [SELECT Id, Name, Billable_Amount__c, Opportunity__c, ProjectRef__c, Start_Date__c, End_Date__c, Status__c FROM Project__c where ProjectRef__c = :projectRef];
        if(projectsList.size() > 0 ) {
            project = projectsList[0];
        }
        try {
            project.ProjectRef__c = projectRef;
            project.Name = projectName;
            project.Opportunity__c = opportunityId;
            project.Start_Date__c = startDate;
            project.End_Date__c = endDate;
            project.Billable_Amount__c = amount;
            project.Status__c = status;
            upsert project;

            Opportunity opp = new Opportunity(Id = opportunityId, DeliveryInstallationStatus__c = 'In Progress');
            update opp;

            return 'OK';
        } catch (Exception ex) {
            Database.rollback(savepoint);
            return ex.getMessage();
        }
    }
}