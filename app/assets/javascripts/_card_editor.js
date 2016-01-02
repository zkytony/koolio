/*
   Editor object represents the whole editor, with both sides. It keeps track of its
   "inner editors", as well as the active ones (ones that are being edited for a certain
   side).
   formId: the id for form of this editor. It must have a child div with a "flipper" class.
*/
function Editor(formId) {
  // The type of the inner editor used on front or back. 
  // Use "prev" because it keeps track of the type of 
  // the "previously editing" editor.
  this.prevType = {"front": undefined, "back": undefined};

  
  this.innerEditors = {};
  this.activeInnerEditors = {"front": undefined, "back": undefined};
  this.hasDraft = {"front": false, "back": false};
  this.id = formId;
  
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
  var fv = new VideoEditor(editor, "front");
  fv.init();
  var bv = new VideoEditor(editor, "back");
  bv.init();
  editor.innerEditors = {
    "front": {
      "text": ft,
      "img": fi,
      "video": fv
    },
    "back": {
      "text": bt,
      "img": bi,
      "video": bv
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

// Post the file to the server
InnerEditor.prototype.sendFileAJAX = function(formdata, successCallBack) {
  var innerEditor = this;
  $.ajax({
    type: 'post',
    url: '/uploaded_files',
    data: formdata,  // formdata has a property "target" & "file_type" & "source_type"
    contentType: false,
    processData: false,
    dataType: 'json', // get back json
    beforeSend: function() {
      $("#" + innerEditor.type + "_" + innerEditor.side + "_waiting").removeClass("hidden");
    },
    success: function(output) {
      successCallBack(output);
    },
    complete: function() {
      $("#" + innerEditor.type + "_" + innerEditor.side + "_waiting").addClass("hidden");
    }
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

//////////////////////////////////////////////
/* ImageEditor object, inherits InnerEditor */
//////////////////////////////////////////////
ImageEditor.prototype = Object.create(InnerEditor.prototype);
function ImageEditor(editor, side) {
  InnerEditor.call(this, editor, side);
  this.type = "img";
  this.storeDir = undefined;
  this.imgFile = undefined; // file name
  this.host = undefined; // host is a string: http://xxxx.com
}

ImageEditor.prototype.init = function() {
  var imageEditor = this;

  // Make an AJAX call to send the file to the server once
  // it is selected.
  $(document).on("change", "#" + imageEditor.side + "-side-img-file", function() {
    var formdata = new FormData();
    var file = $(this).prop('files')[0];
    formdata.append("target", file);
    formdata.append("file_type", "img");
    formdata.append("source_type", "upload");
    
    imageEditor.sendFileAJAX(formdata, function(output) {
      imageEditor.displayPhase(output);
    });
  });

  // When clicked the link button, a form pops up
  $(document).on("click", "#" + imageEditor.side + "-side-img-link", function() {
    $("#" + imageEditor.side + "-img-link-paste").removeClass("hidden");
    $("#" + imageEditor.side + "-img-url").focus();
    // disable the two buttons
    $("#" + imageEditor.side + "-side-img-file").prop("disabled", true);
    $("#" + imageEditor.side + "-side-img-link").prop("disabled", true);
  });

  $(document.body).click(function(e) {
    var linkDiv = $("#" + imageEditor.side + "-img-link-paste");
    if (!linkDiv.hasClass("hidden")) {
      if (e.target.id !== "#" + imageEditor.side + "-side-img-link" && e.target.id !== "#" + imageEditor.side + "-img-link-paste" && !$.contains(linkDiv[0], e.target)) {
	linkDiv.addClass("hidden");
	$("#" + imageEditor.side + "-side-img-file").prop("disabled", false);
	$("#" + imageEditor.side + "-side-img-link").prop("disabled", false);
      }
    }
  });

  // When hit enter in the url input field, first validate
  // if the url is for an image, then use ajax to send the image to server.
  $("#" + imageEditor.side + "-img-url").keyup(function(e){
    if(e.keyCode == 13) {
      var url = $("#" + imageEditor.side + "-img-url").val();
      if (!isUrl(url)) {
	$("#" + imageEditor.side + "-url-alert-msg").removeClass("hidden");
	$("#" + imageEditor.side + "-url-alert-msg").html("Hmm... Invalid URL.");
	return;
      }

      // check if the url is an image; This is asynchronous
      $("<img>", {
	src: url,
	error: function() { 
	  $("#" + imageEditor.side + "-url-alert-msg").removeClass("hidden");
	  $("#" + imageEditor.side + "-url-alert-msg").html("Ooops. Not an image.");
	},
	load: function() {
	  $("#" + imageEditor.side + "-url-alert-msg").addClass("hidden");
	  $("#" + imageEditor.side + "-img-link-paste").addClass("hidden");
	  $("#" + imageEditor.side + "-img-link-paste").val("");
	  // now send an ajax request to the file uploader, and let
	  // the server side download and save the iamge.
	  var formdata = new FormData();
	  formdata.append("target", url);
	  formdata.append("file_type", "img");
	  formdata.append("source_type", "link");

	  imageEditor.sendFileAJAX(formdata, function(output) {
	    imageEditor.displayPhase(output);
	  });
	}
      });
    }
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
  $("#" + imageEditor.side + "-img-editor-container").addClass("hidden");
  $("#" + imageEditor.side + "-img-editor-display").addClass("hidden");
  $("#" + imageEditor.side + "-img-editor-uploader").removeClass("hidden");
  $("#" + imageEditor.side + "-img-display").attr("src", "");
  $("#" + imageEditor.side + "-img-descp").val("");
  $("#" + imageEditor.side + "-img-url").val("");
}

// Return the content of the image editor as JSON string
ImageEditor.prototype.grabContent = function() {
  var result = {};
  result["file_name"] = this.imgFile;
  result["store_dir"] = this.storeDir;
  result["host"] = this.host;
  result["descp"] = $("#" + this.side + "-img-descp").val();
  return result;
}

// Go to the display phase of the image editor. Show the image.
ImageEditor.prototype.displayPhase = function(output) {
  var imageEditor = this;
  var fileName = output["file_name"];
  var storeDir = output["store_dir"];
  var host = output["host"];
  if (fileName) {
    imageEditor.imgFile = fileName;
    imageEditor.storeDir = storeDir;
    imageEditor.host = host;
    // Go to display phase, display that imgFile
    $("#" + imageEditor.side + "-img-editor-uploader").addClass("hidden");

    $("#" + imageEditor.side + "-img-editor-display").removeClass("hidden");
    $("#" + imageEditor.side + "-img-display").attr("src", host + "/" + storeDir + "/" + fileName);

    // hasDraft is true for this side
    imageEditor.editor.hasDraft[imageEditor.side] = true;
    imageEditor.editor.updateCreateCardBtn();
  }
}
/* End of ImageEditor */

function isUrl(s) {
   var regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
   return regexp.test(s);
}

//////////////////////////////////////////////
/* VideoEditor object, inherits InnerEditor */
//////////////////////////////////////////////
VideoEditor.prototype = Object.create(InnerEditor.prototype);
function VideoEditor(editor, side) {
  InnerEditor.call(this, editor, side);
  this.type = "video";
  this.storeDir = undefined;
  this.videoFile = undefined; // file name
  this.host = undefined; // host is a string: http://xxxx.com
}

VideoEditor.prototype.init = function() {
  var videoEditor = this;
  $(document).on("change", "#" + videoEditor.side + "-side-video-file", function() {
    var formdata = new FormData();
    var file = $(this).prop('files')[0];
    formdata.append("target", file);
    formdata.append("file_type", "video");
    formdata.append("source_type", "upload");
    
    videoEditor.sendFileAJAX(formdata, function(output) {
      videoEditor.displayPhase(output);
    });
  });

  // When clicked the link button, a form pops up
  $("#" + videoEditor.side + "-side-video-link").prop("disabled", true);

  videoEditor.reset();
  InnerEditor.prototype.init.call(videoEditor);
}

VideoEditor.prototype.reset = function() {
  var videoEditor = this;
  $("#" + videoEditor.side + "-video-editor-container").addClass("hidden");
  $("#" + videoEditor.side + "-video-editor-uploader").removeClass("hidden");
  $("#" + videoEditor.side + "-video-url").val("");
  $("#" + videoEditor.side + "-video-editor-display").addClass("hidden");
  $("#" + videoEditor.side + "-video-display").html("");
}

// Go to the display phase of the video editor. Show the video.
VideoEditor.prototype.displayPhase = function(output) {
  var videoEditor = this;
  var fileName = output["file_name"];
  var storeDir = output["store_dir"];
  var host = output["host"];
  if (fileName) {
    videoEditor.videoFile = fileName;
    videoEditor.storeDir = storeDir;
    videoEditor.host = host;

    var videoType = fileName.substring(fileName.lastIndexOf(".")+1);
    // Go to display phase, display that videoFile
    $("#" + videoEditor.side + "-video-editor-uploader").addClass("hidden");
    $("#" + videoEditor.side + "-video-editor-display").removeClass("hidden");
    $("#" + videoEditor.side + "-video-display").html("<source src=\"" + host + "/" + storeDir + "/" + fileName + "\" type=\"video/" + videoType + "\">Your browser does not support video tag.");

    // hasDraft is true for this side
    videoEditor.editor.hasDraft[videoEditor.side] = true;
    videoEditor.editor.updateCreateCardBtn();
  }
}

// Return the content of the video editor as JSON string
VideoEditor.prototype.grabContent = function() {
  var result = {};
  result["file_name"] = this.videoFile;
  result["store_dir"] = this.storeDir;
  result["host"] = this.host;
  result["video_type"] = this.videoFile.substring(this.videoFile.lastIndexOf(".")+1);
  return result;
}

VideoEditor.prototype.updateTypeBtnStateIfHasDraft = function() {
  var videoEditor = this;
  if (videoEditor.editor.hasDraft[this.side]) {
    $("#" + videoEditor.side + "-type-video-btn").addClass("previous-type");
  } else {
    $("#" + videoEditor.side + "-type-video-btn").removeClass("previous-type");
  }
}
/* End of VideoEditor */
