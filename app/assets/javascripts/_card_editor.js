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

/*
   Editor object (The whole editor, with both sides) 
   defaultSide: the default side facing the user initially
   id: the id for the container of the editor, MUST have the "flipper" class.
*/
function Editor(defaultSide, id) {
  this.prevType = {"front": undefined, "back": undefined};
  this.currentSide = defaultSide;
  this.id = id;
  this.hasDraft = {"front": false, "back": false};
}

Editor.prototype.init = function() {
  var editor = this;
  $("#front-side-btn").click(function() {
    editor.flip();
  });

  $("#back-side-btn").click(function() {
    editor.flip();
  });
  // text, img, vid
  var ft = new TextEditor(editor, "front");
  ft.init();
  var bt = new TextEditor(editor, "back");
  bt.init();
  var fi = new ImageEditor(editor, "front");
  fi.init();
  var bi = new ImageEditor(editor, "back");
  bi.init();
}

// Flip to the other side of the editor
Editor.prototype.flip = function() {
  var otherSide = null;
  if (this.currentSide == "front") {
    otherSide = "back";
  } else {
    otherSide = "front";
  }
  flip($("#" + this.id));
  $("#" + otherSide + "-side-btn").addClass("side-editing");
  $("#" + otherSide + "-side-btn").prop("disabled", true);
  if (this.prevType[otherSide] != null) {
    $("#" + otherSide + "-" + this.prevType[otherSide] + "-editor-container").removeClass("hidden");
  } else {
    $("#" + otherSide + "-type-select-container").removeClass("hidden");
  }
  $("#" + this.currentSide + "-side-btn").prop("disabled", false);
  $("#" + this.currentSide + "-side-btn").removeClass("side-editing");
  this.currentSide = otherSide;
}

// Choose an inner editor
Editor.prototype.use = function(type) {
  $("#" + this.currentSide + "-type-select-container").addClass("hidden");
  $("#" + this.currentSide + "-" + type + "-editor-container").removeClass("hidden");
  this.prevType[this.currentSide] = type;
}

// Goes back to the phase of selecting type
Editor.prototype.changeType = function(inner) {
  $("#" + this.currentSide + "-type-select-container").removeClass("hidden");
  
  inner.updateDraftState();
  $("#" + this.currentSide + "-" + this.prevType[this.currentSide] + "-editor-container").addClass("hidden");
}

Editor.prototype.updateCreateCardBtn = function() {
  if (this.hasDraft["front"] && this.hasDraft["back"]) {
    $("#create-card-btn").prop("disabled", false);
  } else {
    $("#create-card-btn").prop("disabled", true);
  }
}
/* End of Editor */


/* 
   InnerEditor object (The inner editor, e.g. text editor, image editor...) 
   editor: the outer (whole) Editor object
   side: which side is this inner editor on
*/
function InnerEditor(editor, side) {
  this.editor = editor;
  this.type = undefined;
  this.side = side;
  this.hasDraft = false;
}

// Check if the content in this inner editor has draft.
// If yes, then it should add class "previous-type" to the type-btn
// for this type of inner editor
InnerEditor.prototype.updateTypeBtnIfHasDraft = function() {
  // could not implement here
}

InnerEditor.prototype.init = function() {
  var innerEditor = this;
  $("#" + this.side + "-type-" + this.type + "-btn").click(function() {
    innerEditor.editor.use(innerEditor.type);
  });

  var otherSide = null;
  if (innerEditor.side == "front") {
    otherSide = "back";
  } else {
    otherSide = "front";
  }
  $("#" + this.side + "-" + this.type + "-edit-" + otherSide + "-btn").click(function() {
    innerEditor.editor.flip(); // editor is the reference - it affects other inner editors as well
  });

  $("#" + this.side + "-" + this.type + "-change-type-btn").click(function() {
    innerEditor.editor.changeType(this);
  });

}
/* End of InnerEditor */

/* TextEditor object, inherits InnerEditor */
TextEditor.prototype = Object.create(InnerEditor.prototype);
function TextEditor(editor, side) {
  InnerEditor.call(this, editor, side);
  this.type = "text";
}

TextEditor.prototype.updateTypeBtnStateIfHasDraft = function() {
  if (this.editor.hasDraft[this.side]) {
    $("#" + this.side + "-type-text-btn").addClass("previous-type");
  }
}

TextEditor.prototype.init = function() {
  var textEditor = this;
  $("#" + textEditor.side + "-text-body").keyup(function() {
    if ($("#" + textEditor.side + "-text-body").val()) {
      textEditor.editor.hasDraft[textEditor.side] = true;
    } else {
      textEditor.editor.hasDraft[textEditor.side] = false;
    }
    textEditor.editor.updateCreateCardBtn();
  });
  InnerEditor.prototype.init.call(textEditor);
}
/* ImageEditor object, inherits InnerEditor */
ImageEditor.prototype = Object.create(InnerEditor.prototype);
function ImageEditor(editor, side) {
  InnerEditor.call(this, editor, side);
  this.type = "img";
}

ImageEditor.prototype.updateTypeBtnStateIfHasDraft = function() {
  // not yet implemented
}

$(document).ready(function() {
  var editor = new Editor("front", "card-editor-flipper");
  editor.init();
});
