@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    //Implement service logic here

    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId,
        Date StartDate, Date EndDate, Double Amount, String Status){

        String returnMessage = 'OK';
        Savepoint sp = Database.setSavepoint();

        try{
            if(String.isBlank(OpportunityId)){
                returnMessage = 'No opportunity Id';
            } else {
                Opportunity oppty = new Opportunity(Id = OpportunityId,
                DeliveryInstallationStatus__c = 'In progress');    

                update oppty;

                Project__c project = new Project__c(ProjectRef__c = ProjectRef,
                                                    Name = ProjectName,
                                                    Opportunity__c = OpportunityId,
                                                    Start_Date__c = StartDate,
                                                    End_Date__c = EndDate,
                                                    Billable_Amount__c = Amount,
                                                    Status__c = Status);

                upsert project ProjectRef__c;
            }
        }
        catch(Exception ex){
            Database.rollback(sp);
            returnMessage = 'Error';
        }

        return returnMessage;
    } 
}