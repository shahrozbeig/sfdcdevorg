public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST' + Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList){
        List<Product2> needsAnnouncement = new List<Product2>();

        Map<String, Inventory_Setting__mdt> inventoryMdtSettingMap = new Map<String, Inventory_Setting__mdt>();

        for (Inventory_Setting__mdt ism: [SELECT Id, Label, Developername, Low_Quantity_Alert__c FROM Inventory_Setting__mdt]) {
            inventoryMdtSettingMap.put(ism.Label, ism);
        }

        for (Integer i = 0; i < newList.size(); i++) {
            if(newList[i].Quantity_Remaining__c != oldList[i].Quantity_Remaining__c 
            && newList[i].Quantity_Remaining__c < inventoryMdtSettingMap.get(newList[i].Family).Low_Quantity_Alert__c) {
                needsAnnouncement.add(newList[i]);
            }
        }

        // Pass records to the postAlerts method
        PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant

            ConnectApi.AnnouncementInput announcementInput = new ConnectApi.AnnouncementInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            messageBodyInput.messageSegments = new List<ConnectApi.messageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            announcementInput.parentId = COLLABORATION_GROUP[0].Id;
            announcementInput.body = messageBodyInput;
            announcementInput.expirationDate = Date.today().addDays(1);
            announcementInput.sendEmails = false;
            toPost.add(announcementInput);
        }
        // Create and enqueue an instance of the announcementQueuable class with the list of Products
        AnnouncementQueueable q = new AnnouncementQueueable();
        q.toPost = toPost;
        System.enqueueJob(q);
    }
}