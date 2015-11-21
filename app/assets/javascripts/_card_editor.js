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
function Editor(formId) {
  this.prevType = {"front": undefined, "back": undefined};
  this.innerEditors = {};
  this.activeInnerEditors = {"front": undefined, "back": undefined};
  this.hasDraft = {"front": false, "back": false};
  this.id = formId;
  this.innerEditors = {};
  
  // if .flipper does not have .flip, then the current side is front
  // else the current side has been flipped - back
  if (!$("#" + this.id + " .flipper").hasClass("flip")) {
     this.currentSide = "front"; 
  } else {
    this.currentSide = "back"; 
  }
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
  editor.innerEditors = {
    "front": {
      "text": ft,
      "img": fi
    },
    "back": {
      "text": bt,
      "img": bi
    }
  }

  // when ajax is success, call init again
  $("#" + editor.id).on("ajax:success", function(e, data, status, xhr) {
    editor.reset();
  });
 
  // on-submit
  $("#" + editor.id).submit(function() {
    var frontContent = {type: editor.prevType["front"]};
    frontContent["content"] = editor.activeInnerEditors["front"].grabContent();

    var backContent = {type: editor.prevType["back"]};
    backContent["content"] = editor.activeInnerEditors["back"].grabContent();

    var frontJSON = JSON.stringify(frontContent);
    var backJSON = JSON.stringify(backContent);

    // Inject these two content into the hidden fields of the card editor form
    $("#card_front_content").val(frontJSON);
    $("#card_back_content").val(backJSON);
    // deck_id ??
  });
}

// Flip to the other side of the editor
Editor.prototype.flip = function() {
  var otherSide = null;
  if (this.currentSide == "front") {
    otherSide = "back";
  } else {
    otherSide = "front";
  }
  flip($("#" + this.id + " .flipper"));
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
  this.activeInnerEditors[this.currentSide] = this.innerEditors[this.currentSide][this.prevType[this.currentSide]];
}

// Goes back to the phase of selecting type
Editor.prototype.changeType = function(inner) {
  $("#" + this.currentSide + "-type-select-container").removeClass("hidden");
  
  inner.updateTypeBtnStateIfHasDraft();
  $("#" + this.currentSide + "-" + this.prevType[this.currentSide] + "-editor-container").addClass("hidden");
}

Editor.prototype.updateCreateCardBtn = function() {
  if (this.hasDraft["front"] && this.hasDraft["back"]) {
    $("#create-card-btn").prop("disabled", false);
  } else {
    $("#create-card-btn").prop("disabled", true);
  }
}

Editor.prototype.reset = function() {
  var editor = this;
  // make sure that front side is facing up
  if (editor.currentSide !== "front") {
    editor.flip();
  }
  
  for (var side in editor.innerEditors) {
    types = editor.innerEditors[side];
    for (var type in types) {
      types[type].reset();
    }
  }
  $("#front-type-select-container").removeClass("hidden");
  $("#back-type-select-container").removeClass("hidden");
  editor.prevType = {"front": undefined, "back": undefined};
  editor.activeInnerEditors = {"front": undefined, "back": undefined};
  editor.hasDraft = {"front": false, "back": false};
  editor.updateCreateCardBtn();
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
}

// Check if the content in this inner editor has draft.
// If yes, then it should add class "previous-type" to the type-btn
// for this type of inner editor
InnerEditor.prototype.updateTypeBtnStateIfHasDraft = function() {
  // could not implement here
}

InnerEditor.prototype.init = function() {
  var innerEditor = this;
  $("#" + innerEditor.side + "-type-" + innerEditor.type + "-btn").click(function() {
    innerEditor.editor.use(innerEditor.type);
  });

  var otherSide = null;
  if (innerEditor.side == "front") {
    otherSide = "back";
  } else {
    otherSide = "front";
  }
  $(document).on("click", "#" + innerEditor.side + "-" + innerEditor.type + "-edit-" + otherSide + "-btn", function() {
    innerEditor.editor.flip(); // editor is the reference - it affects other inner editors as well
  });

  $(document).on("click", "#" + innerEditor.side + "-" + innerEditor.type + "-change-type-btn", function() {
    innerEditor.editor.changeType(innerEditor);
  });
}

// This method returns a JSON String of the data on this editor
// that should be used for saving content to database
InnerEditor.prototype.grabContent = function() {
  // cannot implement here since type is undefined
}

// This method resets the form contents of this particular
// inner editor
InnerEditor.prototype.reset = function() {
  // could not implement here
}
/* End of InnerEditor */

/* TextEditor object, inherits InnerEditor */
TextEditor.prototype = Object.create(InnerEditor.prototype);
function TextEditor(editor, side) {
  InnerEditor.call(this, editor, side);
  this.type = "text";
}

TextEditor.prototype.updateTypeBtnStateIfHasDraft = function() {
  var textEditor = this;
  if (textEditor.editor.hasDraft[this.side]) {
    $("#" + textEditor.side + "-type-text-btn").addClass("previous-type");
  } else {
    $("#" + textEditor.side + "-type-text-btn").removeClass("previous-type");
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
  textEditor.reset();
  InnerEditor.prototype.init.call(textEditor);
}

TextEditor.prototype.reset = function() {
  var textEditor = this;
  $("#" + textEditor.side + "-text-editor-container").addClass("hidden");
  $("#" + textEditor.side + "-text-title").val("");
  $("#" + textEditor.side + "-text-body").val("");
}

TextEditor.prototype.grabContent = function() {
  var result = {};
  result["title"] = $("#" + this.side + "-text-title").val();
  result["body"] = $("#" + this.side + "-text-body").val();
  return result;
}
/* End of TextEditor */

/* ImageEditor object, inherits InnerEditor */
ImageEditor.prototype = Object.create(InnerEditor.prototype);
function ImageEditor(editor, side) {
  InnerEditor.call(this, editor, side);
  this.type = "img";
  this.storeDir = undefined;
  this.imgFile = undefined; // url to that image file
}

ImageEditor.prototype.init = function() {
  var imageEditor = this;

  // Make an AJAX call to send the file to the server once
  // it is selected.
  $(document).on("change", "#" + imageEditor.side + "-side-img-file", function() {
    var formdata = new FormData();
    var file = $(this).prop('files')[0];
    formdata.append("file", file);
    formdata.append("type", "img");
    
    imageEditor.sendFileAJAX(formdata);
  });

  imageEditor.reset();
  InnerEditor.prototype.init.call(imageEditor);
}

ImageEditor.prototype.updateTypeBtnStateIfHasDraft = function() {
  var imageEditor = this;
  if (imageEditor.editor.hasDraft[this.side]) {
    $("#" + imageEditor.side + "-type-img-btn").addClass("previous-type");
  } else {
    $("#" + imageEditor.side + "-type-img-btn").removeClass("previous-type");
  }
}

ImageEditor.prototype.reset = function() {
  var imageEditor = this;
  $("#" + imageEditor.side + "-image-editor-container").addClass("hidden");
}

// Return the content of the image editor as JSON string
ImageEditor.prototype.grabContent = function() {
  var result = {};
  result["file_name"] = this.imgFile;
  result["store_dir"] = this.storeDir;
  result["descp"] = $("#" + this.side + "-img-descp").val();
  return result;
}

// Post the file to the server
ImageEditor.prototype.sendFileAJAX = function(formdata) {
  var imageEditor = this;
  $.ajax({
    type: 'post',
    url: '/uploaded_files',
    data: formdata,  // formdata has a property "file"
    contentType: false,
    processData: false,
    dataType: 'json', // get back json
    success: function(output) {
      var fileName = output["file_name"];
      var storeDir = output["store_dir"];
      if (fileName) {
	imageEditor.imgFile = fileName;
	imageEditor.storeDir = storeDir;
	// Go to display phase, display that imgFile
	$("#" + imageEditor.side + "-img-editor-uploader").addClass("hidden");
	$("#" + imageEditor.side + "-img-editor-display").removeClass("hidden");
	$("#" + imageEditor.side + "-img-display").attr("src", "/" + imageEditor.storeDir + "/" + imageEditor.imgFile);

	// hasDraft is true for this side
	imageEditor.editor.hasDraft[imageEditor.side] = true;
	imageEditor.editor.updateCreateCardBtn();
      }
    }
  });
}
/* End of ImageEditor */
