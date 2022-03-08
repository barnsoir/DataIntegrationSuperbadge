@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @testSetup
  static void createTestData(){

    Opportunity testOpp = new Opportunity(Name = 'Test Opportunity',
                                          Type = 'New Project',
                                          Amount = 100,
                                          CloseDate = System.today(),
                                          StageName = 'Prospecting'
                                          );
    insert testOpp;       

  }

  @isTest
  static void projectRestServiceTestPositive(){

    Opportunity testOppty = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity LIMIT 1];

    String response = ProjectRESTService.postProjectData('ABC1', 'Test Project ABC1', testOppty.Id, System.today(), System.today(), 123, 'Running');

    System.assertEquals('OK', response);
  }

  @isTest
  static void projectRestServiceTestNegative(){

    Opportunity testOppty = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity LIMIT 1];

    String response = ProjectRESTService.postProjectData('ABC1', 'Test Project ABC1', testOppty.Id, System.today(), System.today(), 123, 'Amazing');

    System.assertEquals('Error', response);
  }
}