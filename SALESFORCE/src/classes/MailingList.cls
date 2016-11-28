public class MailingList {
     public List < MailingListWrapper > mailingList {
        get;
        set;
    }  
    public List < MailingListWrapper > getAllMailingList() {
        if (mailingList == null) {
            mailingList = new List < MailingListWrapper > ();
            for (Mailing_List__c m: [SELECT Mailing_List_Id__c,Title__c,Description__C from Mailing_List__c]) {
                
                mailingList.add(new MailingListWrapper(m));
            }
        }
        return mailingList;
    }    
    public PageReference removeMailingList() {        
        List < Mailing_List__c > selectedMailingList = new List < Mailing_List__c > ();        
        for (MailingListWrapper mList: getAllMailingList()) {
            if (mList.selected == true) {
                selectedMailingList.add(mList.wMailingList);
            }
        }        
        if (selectedMailingList.size() > 0)
            Delete selectedMailingList;
         
        mailingList = null;
        return null;
    }
    
    public class MailingListWrapper {
        public Mailing_List__c wMailingList {
            get;
            set;
        }
        public Boolean selected {
            get;
            set;
        }
        public MailingListWrapper(Mailing_List__c  m) {
            wMailingList = m;
            selected = false;
        }
    }
}