trigger updateAccountName on Account (before insert, before update) {
    if(trigger.isBefore){
        for(Account account: trigger.new){
            account.Ownership = 'Public';
        }
    }
}