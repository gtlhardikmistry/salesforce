public class MyPageController {

private ApexPages.StandardController controller;
public MyPageController(ApexPages.StandardController controller) {
    	this.controller = controller;
	}
      public PageReference saveAndCongrat() {
      controller.save(); // This takes care of the details for you.
      PageReference congratsPage = Page.quickAdd;
      congratsPage.setRedirect(true);
      return congratsPage;
    }   
}