@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here

  @testSetup
  static void createTestData(){

    Opportunity testOpp = new Opportunity(Name = 'Test Opportunity',
                                          Type = 'New Project',
                                          Amount = 100,
                                          CloseDate = System.today(),
                                          StageName = 'Prospecting'
                                          );
    insert testOpp;       

    ServiceTokens__c serviceToken = new ServiceTokens__c();
    serviceToken.Name = 'ProjectServiceToken';
    serviceToken.Token__c = 'tokenname';
    insert serviceToken;                
  }

  @isTest
  static void testPositiveCall(){

    Opportunity oppty = [Select Id, StageName from Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
    List<Id> oppIds = new List<Id>();
    oppIds.add(oppty.id);

    oppty.StageName = 'Closed Won';


    Test.startTest();
    //  ProjectCalloutService.postOpportunityToPMS(oppIds);
      Test.setMock(HTTPCalloutMock.class, new ProjectCalloutServiceMock());
      update oppty;    
    Test.stopTest();

    oppty = [SELECT StageName FROM Opportunity WHERE Id = :oppty.Id];
    system.assertEquals('Submitted Project', oppty.StageName);
  }

  @isTest
  static void testNegativeCall(){

    Opportunity oppty = [Select Id, StageName from Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
    List<Id> oppIds = new List<Id>();
    oppIds.add(oppty.id);

    oppty.StageName = 'Closed Won';


    Test.startTest();
    //  ProjectCalloutService.postOpportunityToPMS(oppIds);
      Test.setMock(HTTPCalloutMock.class, new ProjectCalloutServiceMockFailure());
      update oppty;    
    Test.stopTest();

    oppty = [SELECT StageName FROM Opportunity WHERE Id = :oppty.Id];
    system.assertEquals('Resubmit Project', oppty.StageName);
  }
}