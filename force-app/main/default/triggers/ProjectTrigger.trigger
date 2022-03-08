trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    Set<Id> projectIds = new Set<Id>();

    if(Trigger.isAfter && Trigger.isUpdate){
        for(Project__c project:Trigger.new){
            if(project.Status__c == 'Billable'){
                projectIds.add(project.Id);
            }
        }
    }

    if(projectIds.size()>0){
        BillingCalloutService.callBillingService(projectIds);
    }
}