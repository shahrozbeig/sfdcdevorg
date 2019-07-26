trigger updateAccNameAfter on Account (after insert) {
    List<Account> accountList = new List<Account>();
    // for(Account account: trigger.new){
    //         account.OwnerShip = 'Private';
    //         accountList.add(account);
    //     }
    //     update accountList;
}