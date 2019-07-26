@isTest
private class ProjectRESTServiceTest {
	
    public static testMethod void testSuccess(){
		Account acct = new Account(Name='Test Account');
		insert acct;
        
        LIST<Opportunity> oppLIST = new LIST<Opportunity>();
		oppLIST.add(new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acct.id, 
            CloseDate = System.Today(),            
            Amount = 12480.00,
            Type = 'New Project',
            StageName='Qualification'));
        insert oppLIST;
        
        
        
        Project__c prjt = new Project__c();
        prjt.ProjectRef__c = 'ProjectRef';
        prjt.Name = 'ProjectName';
        prjt.Opportunity__c = oppList[0].Id;
        prjt.Start_Date__c = Date.today();
        prjt.End_Date__c = (Date.today()).addDays(10);
        prjt.Billable_Amount__c = 1000;
        prjt.Status__c = 'Running';
        
        INSERT prjt;
        // Start Test
		Test.startTest();
		        
        // Process  test
		string strResponse = ProjectRESTService.postProjectData('ProjectRef', 'testing1104', 
			string.valueOf(oppLIST[0].ID), oppLIST[0].CloseDate, oppLIST[0].CloseDate, double.valueOf(oppLIST[0].Amount), 'Running');
        system.assertNotEquals('OK', strResponse);
        
        // Stop Test
		Test.stopTest();
        
        // Verify outcome
        Opportunity opp = [select ID, StageName from Opportunity where ID = :oppLIST[0].ID LIMIT 1][0];
        system.assertEquals('Submitted Project', opp.StageName);
	} // END testSuccess

    public static testMethod void testFailure(){
        // Not using bulk because REST call doesn't support BULK
        // Not using Running User because this is a DE org and only supports 2 users
        
        // Create Test Account
		Account acct = new Account(Name='Test Account');
		insert acct;
        
        // Create Test Opportunity
        LIST<Opportunity> oppLIST = new LIST<Opportunity>();
		oppLIST.add(new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acct.id, 
            CloseDate = System.Today(),            
            Amount = 12480.00,
            Type = 'New Project',
            StageName='Qualification'));
        insert oppLIST;
        
        // Start Test
		Test.startTest();
        
        // Process  test
        //ProjectRESTService.strSimulateError = 'CATCH';
		string strResponse = ProjectRESTService.postProjectData('testing1104', 'testing1104', 
			string.valueOf(oppLIST[0].ID), oppLIST[0].CloseDate, oppLIST[0].CloseDate, double.valueOf(oppLIST[0].Amount), 'Running');
        system.assertEquals('OK', strResponse);
        
        // Stop Test
		Test.stopTest();
        
	} // END testFailure

} // END ProjectRESTServiceTest