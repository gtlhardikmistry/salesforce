public class MailingListSave {
private ApexPages.StandardController controller;
public MailingListSave(ApexPages.StandardController controller) {
    	this.controller = controller;
	}
      public PageReference saveAndRedirect() {
      controller.save();
      PageReference redirectPage = Page.mailingList;
      redirectPage.getParameters().put('sfdc.tabName','01r28000000todw');
      redirectPage.setRedirect(true);
      return redirectPage;
    }  
}