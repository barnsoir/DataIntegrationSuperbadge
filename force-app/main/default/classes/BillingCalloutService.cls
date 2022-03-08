public class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    public static void callBillingService(Set<Id> projectIds){
        ServiceCredentials__c srvcCrd = ServiceCredentials__c.getValues('BillingServiceCredential');
        List<Project__c> projects = [SELECT Id, ProjectRef__c, Billable_Amount__c FROM Project__c WHERE Id in :projectIds];

        List<Project__c> projectsForUpdate = new List<Project__c>();

        for(Project__c project:projects){
            
            BillingServiceProxy.project projectInstance = new BillingServiceProxy.project();
            projectInstance.username = srvcCrd.Username__c;
            projectInstance.password = srvcCrd.Password__c;
            projectInstance.billAmount = project.Billable_Amount__c;
            projectInstance.projectid = project.ProjectRef__c;
            BillingServiceProxy.InvoicesPortSoap11 invPortSoapInstance = new BillingServiceProxy.InvoicesPortSoap11();
            String response = invPortSoapInstance.billProject(projectInstance);

            if(response!=null && response.equalsIgnoreCase('OK')){
                Project__c updatedProject = new Project__c(Id = project.Id,
                                                        Status__c = 'Billed');
                projectsForUpdate.add(updatedProject);
            }    
        }

        if(projectsForUpdate.size()>0){
            update projectsForUpdate;
        }
    }
}