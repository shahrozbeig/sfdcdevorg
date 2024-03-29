@isTest
public with sharing class ProjectCalloutServiceTest {
    @testSetup static void testSetupdata(){
        Account acc = new Account(Name='ABC Corp');
        insert acc;
		//create the opportunity record
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'ABC Corp1';
        opp1.Type = 'New Project';
        opp1.Amount = 1000;
        opp1.CloseDate = Date.today();
        opp1.StageName = 'Submitted Project';
        opp1.AccountId = acc.Id;
        insert opp1;
		//create the opportunity record
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'ABC Corp2';
        opp2.Type = 'New Project';
        opp2.Amount = 1000;
        opp2.CloseDate = Date.today();
        opp2.StageName = 'Resubmit Project';
        opp2.AccountId = acc.Id;
        insert opp2;
        //create the Custom Settings
        ServiceTokens__c servToken = new ServiceTokens__c();
        servToken.Name = 'ProjectServiceToken';
        servToken.Token__c = 'shgglskgblsbglbdsflgbldmfbgldb';
        insert servToken;
    }
    
    @isTest static void testPostCalloutSuccess() {
        Opportunity opp = [Select Id, Name, Account.Name, closedate, amount FROM Opportunity WHERE Name = 'ABC Corp1' Limit 1];
        List<Id> oppList = new List<Id>();
        oppList.add(opp.Id);
        System.assertEquals('ABC Corp1', opp.Name);
        System.assertEquals(1,oppList.size());
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        ProjectCalloutService.postOpportunityToPMS(oppList);
        // Verify that the response received contains fake values
        Test.stopTest();    
        opp = [select StageName from Opportunity where id =: opp.Id];
        System.assertEquals('Submitted Project',opp.StageName);
    }
    
    @isTest static void testPostCalloutFailure() {
        Opportunity opp = [Select Id, Name, Account.Name, closedate, amount FROM Opportunity WHERE Name = 'ABC Corp2' Limit 1];
        List<Id> oppList = new List<Id>();
        oppList.add(opp.Id);
        System.assertEquals('ABC Corp2', opp.Name);
        System.assertEquals(1,oppList.size());
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        ProjectCalloutService.postOpportunityToPMS(oppList);
        // Verify that the response received contains fake values
        Test.stopTest();        
        opp = [select StageName from Opportunity where id =: opp.Id];
        System.assertEquals('Resubmit Project',opp.StageName);
    }
}