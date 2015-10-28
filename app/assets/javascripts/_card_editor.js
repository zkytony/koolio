$(document).ready(function() {
  /*
     Initial state: 
     - Front button selected, Back button greyed
     - Create card button disabled
     - Display four buttons for content type selection
     
     Clicked Back/Front button:
     - Hide the Front/Back side
     - Display the Back/Front side
     - If Back/Front side has not been given a content type
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
  var frontPrevType = null;
  var backPrevType = null;

  $("#front-side-btn").click(function() {
    sideBtnPressed("front");
  });

  $("#back-side-btn").click(function() {
    sideBtnPressed("back");
  });

  /*** Front text ***/
  $("#front-type-text-btn").click(function() {
    $("#front-type-select-container").addClass("hidden");
    $("#front-text-editor-container").removeClass("hidden");
    frontPrevType = "text";
  });

  $("#front-text-edit-back-btn").click(function() {
    sideBtnPressed("back");
  });

  $("#back-text-edit-front-btn").click(function() {
    sideBtnPressed("front");
  });

  $("#front-text-change-type-btn").click(function() {
    showUpTypeSelector("front", frontPrevType);
    $("#front-text-editor-container").addClass("hidden");
  });
  /*** End Front text ***/

  /*** Back text ***/
  $("#back-type-text-btn").click(function() {
    $("#back-type-select-container").addClass("hidden");
    $("#back-text-editor-container").removeClass("hidden");
    backPrevType = "text";
  });

  $("#back-text-change-type-btn").click(function() {
    showUpTypeSelector("back", backPrevType);
    $("#back-text-editor-container").addClass("hidden");
  });
  /*** End Back text ***/
});

// side can be either front or back
function sideBtnPressed(side) {
  var otherSide = "";
  if (side == "front") {
    otherSide = "back";
  } else {
    otherSide = "front";
  }
  flip($("#card-editor-flipper"));
  $("#" + otherSide + "-side-btn").removeClass("side-editing");
  $("#" + otherSide + "-side-btn").prop("disabled", false);
  $("#" + side + "-type-select-container").removeClass("hidden");
  $("#" + side + "-side-btn").prop("disabled", true);
  $("#" + side + "-side-btn").addClass("side-editing");

}

function showUpTypeSelector(side, prevType) {
  $("#" + side + "-type-select-container").removeClass("hidden");
  switch (prevType) {
    case "text":
      if ($("#" + side + "-text-body").val())
	$("#" + side + "-type-text-btn").addClass("previous-type");
      break;

    default:
      break;
  }
}
