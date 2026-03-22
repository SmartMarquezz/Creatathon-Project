trigger TAC_Project_ReadmePull on TAC_Project__c (after insert, after update) {
    Set<Id> toQueue = new Set<Id>();
    for (TAC_Project__c row : Trigger.new) {
        if (String.isBlank(row.GitHub_Repo_URL__c)) {
            continue;
        }
        if (Trigger.isInsert) {
            toQueue.add(row.Id);
        } else {
            TAC_Project__c oldRow = Trigger.oldMap.get(row.Id);
            if (row.GitHub_Repo_URL__c != oldRow.GitHub_Repo_URL__c) {
                toQueue.add(row.Id);
            }
        }
    }
    for (Id projectId : toQueue) {
        TAC_Project__c row = Trigger.newMap.get(projectId);
        System.enqueueJob(new TAC_FetchProjectReadmeQueueable(projectId, row.GitHub_Repo_URL__c));
    }
}
