/**
 * @name AnnouncementQueueable
 * @description This class posts Chatter Announcements using Queueuable interface
**/
public class AnnouncementQueueable implements Queueable {
    /**
     * list of announcements to be posted on "Inventory Announcements" chatter group
    */
    public List<ConnectApi.AnnouncementInput> toPost;

    public void execute(QueueableContext qc) {
        PostAnnouncements(toPost);
    }

    /**
     * @name postAnnouncements
     * @description This method calls the ConnectApi's postAnnoucement method to post to the chatter group
     * it also check for the DML/Posts limits available, if yes then post otherwise it request itself to post
    **/
    public static void PostAnnouncements(List<ConnectApi.AnnouncementInput> announcements){
        while ( announcements.size() > 0 ){
            if ( Limits.getDMLStatements() < Limits.getLimitDMLStatements() && !test.isRunningTest() ){
                ConnectApi.AnnouncementInput a = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', a);
            } else if ( announcements.size() > 0 && !test.isRunningTest() ) {
                AnnouncementQueueable q = new AnnouncementQueueable();
                q.toPost = announcements;
                /**
                 * Enqueueing the above instance of announcementQueueable class
                 */
                System.enqueueJob(q);
            }
        }
    }

}