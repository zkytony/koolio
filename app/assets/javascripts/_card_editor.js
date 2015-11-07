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

     When submit:
     - Grab the data entered on each side of the card, and convert them to
       JSON string according to the type of that side
     - Inject the JSON string to hidden fields of the form
       - only these hidden fields need to be Rail-ized
   */
  var frontPrevType = null;
  var backPrevType = null;

  var frontHasStuff = false;
  var backHasStuff = false;

  $("#front-side-btn").click(function() {
    sideBtnPressed("front", frontPrevType);
  });

  $("#back-side-btn").click(function() {
    sideBtnPressed("back", backPrevType);
  });

  /*** text ***/
  $("#front-text-edit-back-btn").click(function() {
    sideBtnPressed("back", backPrevType);
  });

  $("#back-text-edit-front-btn").click(function() {
    sideBtnPressed("front", frontPrevType);
  });
  /*** Front text ***/
  $("#front-type-text-btn").click(function() {
    $("#front-type-select-container").addClass("hidden");
    $("#front-text-editor-container").removeClass("hidden");
    frontPrevType = "text";
  });

  $("#front-text-change-type-btn").click(function() {
    showUpTypeSelector("front", frontPrevType);
    $("#front-text-editor-container").addClass("hidden");
  });

  $("#front-text-body").keyup(function() {
    if ($("#front-text-body").val()) {
      frontHasStuff = true;
    } else {
      frontHasStuff = false;
    }
    updateCreateCardBtn(frontHasStuff, backHasStuff);
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

  $("#back-text-body").keyup(function() {
    if ($("#back-text-body").val()) {
      backHasStuff = true;
    } else {
      backHasStuff = false;
    }
    updateCreateCardBtn(frontHasStuff, backHasStuff);
  });
  /*** End Back text ***/
  /*** End text ***/

  /**** image ****/
  $("#front-img-edit-back-btn").click(function() {
    sideBtnPressed("back", backPrevType);
  });
  $("#back-img-edit-back-btn").click(function() {
    sideBtnPressed("front", frontPrevType);
  });
  /**** Front image ****/
  $("#front-type-img-btn").click(function() {
    $("#front-type-select-container").addClass("hidden");
    $("#front-img-editor-container").removeClass("hidden");
    frontPrevType = "img";
  });

  $("#front-img-change-type-btn").click(function() {
    showUpTypeSelector("front", frontPrevType);
    $("#front-img-editor-container").addClass("hidden");
  });
  /**** End Front image ****/
  /**** End image ****/

  /*** Handle submission ***/
  $("#card-editor-form").submit(function() {
    var frontContent = {type: frontPrevType};
    frontContent["content"] = grabContentWithType(frontPrevType, "front");

    var backContent = {type: backPrevType};
    backContent["content"] = grabContentWithType(backPrevType, "back");

    var frontJSON = JSON.stringify(frontContent);
    var backJSON = JSON.stringify(backContent);
    // Inject these two content into the hidden fields of the card editor form
  });
  /*** End Handle submission ***/
});
/* end document.ready */

// side can be either front or back
function sideBtnPressed(side, prevType) {
  var otherSide = "";
  if (side == "front") {
    otherSide = "back";
  } else {
    otherSide = "front";
  }
  flip($("#card-editor-flipper"));
  $("#" + otherSide + "-side-btn").removeClass("side-editing");
  $("#" + otherSide + "-side-btn").prop("disabled", false);
  if (prevType != null) {
    $("#" + side + "-" + prevType + "-editor-container").removeClass("hidden");
  } else {
    $("#" + side + "-type-select-container").removeClass("hidden");
  }
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
    case "img":
      // when to put it on hold
      break;

    default:
      break;
  }
}

function updateCreateCardBtn(frontHasStuff, backHasStuff) {
  if (frontHasStuff && backHasStuff) {
    $("#create-card-btn").prop("disabled", false);
  } else {
    $("#create-card-btn").prop("disabled", true);
  }
}

function grabContentWithType(type, side) {
  var result = {};
  switch (type) {
    case "text":
      result["title"] = $("#" + side + "-text-title").val();
      result["body"] = $("#" + side + "-text-body").val();
      break;
     
    default:
      break;
  }
  return result;
}
