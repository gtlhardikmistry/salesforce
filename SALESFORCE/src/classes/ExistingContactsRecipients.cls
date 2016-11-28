public class ExistingContactsRecipients {
    public String searchValue{get;set;}
    public List <cContact> contactList {
        get;
        set;
    }   
    public List <cContact> getContacts() {
        if (contactList == null) {
            contactList = new List <cContact>();
            for (Contact c: [SELECT Name,Address_Line_1__c,Address_Line_2__c,MailingCity,MailingCountry,MailingState,MailingPostalCode from Contact where Id  not in(Select Contact_Id__c from Mailing_List_Recipient__c where Mailing_List_Id__c = :ApexPages.currentPage().getParameters().get('id'))]) {                
                contactList.add(new cContact(c));
            }
        }
        return contactList;
    } 
    public PageReference searchContacts() {
        contactList = null;
        if (contactList == null) {
            contactList = new List <cContact>();
            String finalSearchValue = '%' + searchValue + '%';
            for (Contact c: [SELECT Name,Address_Line_1__c,Address_Line_2__c,MailingCity,MailingCountry,MailingState,MailingPostalCode from Contact where Name like :finalSearchValue and Id  not in(Select Contact_Id__c from Mailing_List_Recipient__c where Mailing_List_Id__c = :ApexPages.currentPage().getParameters().get('id'))]) {                
                contactList.add(new cContact(c));
            }
        }
        return null;
    } 
	public PageReference addContacts() {        
        List <Mailing_List_Recipient__c> mList = new List <Mailing_List_Recipient__c>();
		for (cContact cCon: getContacts()) {
            if (cCon.selected == true) {
                Mailing_List_Recipient__C mlRecipient = new Mailing_List_Recipient__C();
                mlRecipient.Contact_Id__c = cCon.con.Id;
                mlRecipient.Mailing_List_Id__c = ApexPages.currentPage().getParameters().get('id');
                mList.add(mlRecipient);
            }
        } 
        if (mList.size() > 0) {
             Insert mList;             
        }          
        contactList = null;
        PageReference redirectPage = Page.getRecipientForMailingList;
        redirectPage.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
        redirectPage.setRedirect(true);
        return redirectPage;
    }     
    public class cContact {
        public Contact con {
            get;
            set;
        }
        public Boolean selected {
            get;
            set;
        }
        public cContact(Contact c) {
            con = c;
            selected = false;
        }
    }
}