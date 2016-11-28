public class QuickAdd  
 {  
     
     //Our collection of the class/wrapper objects cContact 
    public List < cContact > contactList {
        get;
        set;
    }

    //This method uses a simple SOQL query to return a List of Contacts
    public List < cContact > getContacts() {
        if (contactList == null) {
            contactList = new List < cContact > ();
            for (Contact c: [SELECT Name,Address_Line_1__c,Address_Line_2__c,MailingCountry,MailingState,MailingCity,MailingPostalCode from Contact limit 10]) {
                // As each contact is processed we create a new cContact object and add it to the contactList
                contactList.add(new cContact(c));
            }
        }
        return contactList;
    }
      
     public PageReference deleteContacts() {        
        List < Contact > selectedContacts = new List < Contact > ();        
        for (cContact cCon: getContacts()) {
            if (cCon.selected == true) {
                selectedContacts.add(cCon.con);
            }
        }        
        if (selectedContacts.size() > 0)
            Delete selectedContacts;
         
        contactList = null;
        return null;
    }
     
    
 }