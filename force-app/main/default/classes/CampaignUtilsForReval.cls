public without sharing class CampaignUtils {
    public static void addCampaignMemberStatuses(List<Campaign> newCampaignsList) {
        List<CampaignMemberStatus> campaignMembersToInsert = new List<CampaignMemberStatus>();

        try {
            for (Campaign camp : newCampaignsList) {
                if(camp.Type != null && camp.Type != '') {
                    String statusPicklistValues = CampaignMemberStatus__c.getInstance(camp.Type).Status_Picklist_Values__c;
                    if(statusPicklistValues != null) {
                        for (String status : statusPicklistValues.split(',')) {
                            CampaignMemberStatus cms = new CampaignMemberStatus(CampaignID = camp.id, Label = status, IsDefault = false, HasResponded = false);
                            campaignMembersToInsert.add(cms);
                        }
                    } else {
                        System.debug('statusPicklistValues is null');
                    }
                } else {
                    System.debug('No Member Status added as the Campaign with name "' + camp.Name + '" and Salesforce Id "' + camp.Id + '" does not have any type.');
                }
            }

            if(campaignMembersToInsert != null && !campaignMembersToInsert.isEmpty()) {
                insert campaignMembersToInsert;
            }
        } catch (Exception ex) {
            System.debug('CampaignAll trigger failed with an exception "' + ex.getMessage() +  '". Contact Admin/developres.');
        }
    }

    public static void updateCampaignMemberStatuses(List<Campaign> newCampaignsList, Map<Id, Campaign> oldCampaignsMap) {
        Map<Id, List<CampaignMemberStatus>> mapOfCampIdToCampMembers = new Map<Id, List<CampaignMemberStatus>>();
        Set<Id> newCampaignsIdSet = new Set<Id>();
        List<String> statusAssigned = new List<String>();
        List<String> statusToDelete = new List<String>();
        List<CampaignMemberStatus> statusToInsert = new List<CampaignMemberStatus>();
        
        for (Campaign camp : [SELECT Id, Name, (SELECT Id, Label from CampaignMemberStatuses) from Campaign]) {
            mapOfCampIdToCampMembers.put(camp.Id, camp.CampaignMemberStatuses);
        }
        for (Campaign camp : newCampaignsList) {
            newCampaignsIdSet.add(camp.Id);
            if(camp.Type != oldCampaignsMap.get(camp.Id).Type && camp.Type != null && camp.Type != '') {
                if(mapOfCampIdToCampMembers.containsKey(camp.Id)) {
                    for (CampaignMemberStatus campMemberStatus : mapOfCampIdToCampMembers.get(camp.Id)) {
                        statusAssigned.add(campMemberStatus.Label.toLowerCase());
                    }
                }

                /* 
                String oldStatuses = CampaignMemberStatus__c.getInstance(oldCampaignsMap.get(camp.Id).Type).Status_Picklist_Values__c;
                List<String> oldStatusesList = oldStatuses.split(',');
                for (String status : oldStatusesList) {
                    if(!statusAssigned.contains(status)) {
                        statusToDelete.add(status);
                    }
                } 
                if(statusToDelete != null && !statusToDelete.isEmpty()) {
                    delete [SELECT Id from CampaignMemberStatus where Label in :statusToDelete AND CampaignId in :newCampaignsIdSet];
                } 
                */

                String newStatuses = CampaignMemberStatus__c.getInstance(camp.Type).Status_Picklist_Values__c;
                List<String> newStatusesList = newStatuses.split(',');
                for (String status : newStatusesList) {
                    if(!statusAssigned.contains(status.toLowerCase())) {
                        System.debug('New Status: ' + status);
                        CampaignMemberStatus cms = new CampaignMemberStatus(CampaignID = camp.id, Label = status, IsDefault = false, HasResponded = false);
                        statusToInsert.add(cms);
                    }
                }
            }

            if(statusToInsert != null && !statusToInsert.isEmpty()) {
                insert statusToInsert;
            }

        }
    }
}
