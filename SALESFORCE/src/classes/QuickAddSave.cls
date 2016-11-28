public class QuickAddSave {
        private ApexPages.StandardController controller;    
        public QuickAddSave(ApexPages.StandardController controller) {
            this.controller = controller;       
        }
          public PageReference saveAndRedirect() {
              PageReference redirectPage ;
              controller.save();
              if (ApexPages.currentPage().getParameters().get('mid') != Null){
                  Mailing_List_Recipient__c mListRecipient = new Mailing_List_Recipient__c();
                  mListRecipient.Contact_Id__c =  controller.getId();
                  mListRecipient.Mailing_List_Id__c = ApexPages.currentPage().getParameters().get('mid');
                  insert mListRecipient;
                  redirectPage = Page.getRecipientForMailingList;
                  redirectPage.getParameters().put('id',ApexPages.currentPage().getParameters().get('mid'));
                 } else {
                  redirectPage = Page.quickAdd;
                  redirectPage.getParameters().put('sfdc.tabName','01r28000000tnV8');
                 }     
          redirectPage.setRedirect(true);
          return redirectPage;
       }   
}