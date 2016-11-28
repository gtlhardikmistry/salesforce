public class RecipientForMailingList {
    public String mailingListName;    
    public Blob csvFileBody {
        get;
        set;
    }
    public string csvAsString {
        get;
        set;
    }
    public String[] csvFileLines {
        get;
        set;
    }
    public List < cContact > contactList {
        get;
        set;
    }
    public Boolean displayPopup {
        get;
        set;
    }
    public RecipientForMailingList() {
        csvFileLines = new String[] {};
    }
    public String getListName() {
        Mailing_List__c mailingList = [Select Title__c from Mailing_List__c where Id = : ApexPages.currentPage().getParameters().get('id')];
        return mailingList.Title__c;
    }
    public List < cContact > getRecipients() {
        if (contactList == null) {
            contactList = new List < cContact > ();
            for (Contact c: [SELECT Name, Address_Line_1__c, Address_Line_2__c, MailingCity, MailingCountry, MailingState, MailingPostalCode, Id from Contact where Id in (Select Contact_Id__c from Mailing_List_Recipient__c where Mailing_List_Id__c = : ApexPages.currentPage().getParameters().get('id'))]) {
                contactList.add(new cContact(c));
            }
        }
        return contactList;
    }
    public PageReference removeRecipients() {
        List < Mailing_List_Recipient__c > mList = new List < Mailing_List_Recipient__c > ();
        for (cContact cCon: getRecipients()) {
            if (cCon.selected == true) {
                for (Mailing_List_Recipient__c m: [SELECT Contact_Id__c, Mailing_List_Id__c from Mailing_List_Recipient__c where Mailing_List_Id__c = : ApexPages.currentPage().getParameters().get('id') and Contact_Id__c = : cCon.con.Id]) {

                    mList.add(m);
                }
            }
        }
        if (mList.size() > 0)
            Delete mList;

        contactList = null;
        return null;
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
    public void showPopup() {
        displayPopup = true;
    }
    public void closePopup() {
        displayPopup = false;
    }
    public PageReference removeMailingList() {
        Mailing_List__c mailingList = new Mailing_List__c();
        mailingList.Id = ApexPages.currentPage().getParameters().get('id');   
        Delete mailingList;  
        PageReference redirectPage = Page.mailingList;
        redirectPage.setRedirect(true);
        return redirectPage;
    }
    public void importCSVFile() {
        try {
            List <Contact> conList = new LIST <Contact>();
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            for (Integer i = 1; i < csvFileLines.size(); i++){
                Contact conObj = new Contact();
                string[] csvRecordData = csvFileLines[i].split(',');
                conObj.Salutation = csvRecordData[0];
                conObj.FirstName = csvRecordData[1];
                conObj.LastName = csvRecordData[2];                
                conObj.Position__c = csvRecordData[3];
                conObj.Company__c = csvRecordData[4];
                conObj.Address_Line_1__c = csvRecordData[5];
                conObj.Address_Line_2__c = csvRecordData[6];
                conObj.MailingCity = csvRecordData[7];
                conObj.MailingState = csvRecordData[8];
                conObj.MailingPostalCode = csvRecordData[9];
                conObj.MailingCountry = csvRecordData[10];
                conObj.Attribute_A__c = csvRecordData[11];
                conObj.Attribute_B__c = csvRecordData[12];
                conList.add(conObj);                
                //contactList.add(new cContact(conObj));
                closePopup();
            }
            insert conList;
            List < Mailing_List_Recipient__c > mList = new List < Mailing_List_Recipient__c > ();
            for (Contact c : conList) {
                Mailing_List_Recipient__c m = new Mailing_List_Recipient__c();
                m.Contact_Id__c = c.Id;
                m.Mailing_List_Id__c = ApexPages.currentPage().getParameters().get('id');
                mList.add(m);
            }
            Insert mList;
            contactList = Null;
            getRecipients();        
        }
        catch (Exception e){
            //ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured while importin data Please make sure input csv file is correct');
            //ApexPages.addMessage(errorMessage);
        }
    }
}