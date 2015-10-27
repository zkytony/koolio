$(document).ready(function() {
    /*
      Initial state: 
      - Front button selected, Back button greyed
      - Create card button disabled
      - Display four buttons for content type selection
      
      Clicked Back/Front button:
      - Hide the Front/Back side
      - Display the Back/Front side
      - If Back/Front side has not been editied
        - Display four buttons for content type selection
	- Front/Back button greyed out
      - If Back/Front side is editing
        - Display whatever type-editor + content that the user was editing
	- Create card button is enabled

      Clicked text-editor button:
      - Hide the four content type buttons
      - Display the text-editor
      (same for other editors)
     */
    var frontSideBtn = $("#front-side-btn");
    var frontWrapper = $("#front-wrapper");
    var frontTypeSelector = $("front-type-select-container");
    var backSideBtn = $("#back-side-btn");
    var backWrapper = $("#back-wrapper");
    var backTypeSelector = $("back-type-select-container");
    
    frontSideBtn.click(function() {
	backWrapper.addClass("hidden");
	backSideBtn.prop("disabled", false);
	backSideBtn.removeClass("side-editing");
	if (frontWrapper.hasClass("edit-started")) {
	    // bring back the current type-editor + content
	} else {
	    frontTypeSelector.removeClass("hidden");
	}
	frontWrapper.removeClass("hidden");
	frontSideBtn.addClass("side-editing");
	frontSideBtn.prop("disabled", true);
    });

    backSideBtn.click(function() {
	frontWrapper.addClass("hidden");
	frontSideBtn.removeClass("side-editing");
	frontSideBtn.prop("disabled", false);
	if (backWrapper.hasClass("edit-started")) {
	    // bring back the current type-editor + content
	} else {
	    backTypeSelector.removeClass("hidden");
	}
	backWrapper.removeClass("hidden");
	backSideBtn.prop("disabled", true);
	backSideBtn.addClass("side-editing");
    });
    
});
