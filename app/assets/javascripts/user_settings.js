$(document).ready(function() {
    $("#setting-items-wrapper").masonry({
	columnWidth: 200,
	gutter: 10,
	itemSelector: ".setting-item",
    });

    var avatarEditors = {};
    avatarEditors["front"] = new AvatarEditor("front");
    avatarEditors["back"] = new AvatarEditor("back");
    avatarEditors["front"].init();
    avatarEditors["back"].init();

    // when clicked on "change" button, flip the setting-item
    $(document).on("click", ".setting-action-btn", function() {
	// id is of the form change-XXX-btn
	var settingFor = $(this).attr("id").split("-")[1];
	flip($("#" + settingFor + "-setting"));
    });

    // AJAX submit the form
    $(document).on("click", "#setting-confirm-btn", function() {
	var userId = $(".user_setting_id").attr("id").split("_")[1];
	data = grabFormData();
	data["avatar"] = JSON.stringify({
	    "front": avatarEditors["front"].grabContent(),
	    "back" : avatarEditors["back"].grabContent(),
	});
	ajaxUpdateUser(data, userId);
    });

    // when click on the prof pic, flip it
    $(document).on("click", ".avatar-side", function() {
	flip($("#avatar-card"));
    });

    // when click on the change avatar btn, display the avatar editor
    $(document).on("click", "#change-avatar-btn", function() {
	$("#avatar-editors").removeClass("hidden");
	$("#overlay-for-avatar-editor").removeClass("hidden");
    });

    // when hit confirm
    $(document).on("click", ".inner-confirm-btn", function() {
	// If one side has uploaded image, take the croppedUrl
	// as the src for that side's avatar;

	// check front
	if (avatarEditors["front"].croppedUrl()) {
	    $("#avatar-front-img").attr("src", avatarEditors["front"].croppedUrl());
	}
	// check back
	if (avatarEditors["back"].croppedUrl()) {
	    $("#avatar-back-img").attr("src", avatarEditors["back"].croppedUrl());
	}
	// hide the editor
	$("#avatar-editors").addClass("hidden");
	$("#overlay-for-avatar-editor").addClass("hidden");
    });

    $(document).on("click", "#overlay-for-avatar-editor", function() {
	$("#avatar-editors").addClass("hidden");
	$("#overlay-for-avatar-editor").addClass("hidden");
    });
});

// grab the user update form data
function grabFormData() {
    var data = {};
    data["username"] = $("#user_name").val();
    data["email"] = $("#user_email").val();
    data["password"] = $("#user_password").val();
    data["first_name"] = $("#user_first_name").val();
    data["last_name"] = $("#user_last_name").val();
    data["gender"] = getGender();
    if ($("#dob-month").val() && $("#dob-day").val() && $("#dob-year").val()) {
	data["birthday"] = $("#dob-month").val() + "/" + $("#dob-day").val() + "/" + $("#dob-year").val();
    } else {
	data["birthday"] = "";
    }
    return data;
}

function ajaxUpdateUser(data, userId) {
    $.ajax({
	type: "PATCH",
	url: "/users/" + userId,
	data: { new_attrs: data },
	dataType: "script",
	success: function(output) {
	    // flip every edited item back, and reset
	    $(".setting-item").each(function(){
		if ($(this).hasClass("flipper") && $(this).hasClass("flip")) {
		    // flip back
		    flip($(this));
		}
	    });
	    // flip back the avatar
	    if ($("#avatar-card").hasClass("flip")) {
		flip($("#avatar-card"));
	    }
	}
    });
}

// return empty string if neither one is chosen
function getGender() {
    if ($("#user_gender_male").is(':checked')) {
	return "male";
    } else if ($("#user_gender_female").is(':checked')) {
	return "female";
    }
    return "";
}

// avatar editor, referring to one side of the avatar editors
function AvatarEditor(side) {
  this.side = side;
  this.storeDir = undefined;
  this.imgFile = undefined; // file name
  this.host = undefined; // host is a string: http://xxxx.com
  this.confirmCallback = null;
  // attributes of the cropped image
  this.cropX = undefined;
  this.cropY = undefined;
  this.cropW = undefined;
  this.cropH = undefined;

  // either upload or link
  this.currentSource = undefined;
  // either a file or a url
  this.currentTarget = undefined;
}

AvatarEditor.prototype.init = function() {
  var avatarEditor = this;
  var otherSide = null;
  if (avatarEditor.side == "front") {
    otherSide = "back";
  } else {
    otherSide = "front";
  }

  // UI twisting
  $(".inner-change-type-btn").addClass("hidden");
  $(".image-descp").addClass("hidden");
  $(".inner-confirm-btn").removeClass("hidden");

  // when click on edit-SIDE button, flip the editor
  $(document).on("click", "#" + avatarEditor.side + "-img-edit-" + otherSide + "-btn", function() {
    avatarEditor.flip();
  });

  //////////////////// CROPPING BEGGIN ///////////////////////
  // initialize JCrop
  initJCrop(avatarEditor.side);

  function initJCrop() {
    $("#" + avatarEditor.side + "-img-to-crop").Jcrop({
      setSelect: [0, 0, 220, 220],
      aspectRatio: 1,
      boxWidth: 500,
      boxHeight: 450,
      minSize: [ 100, 100 ],
      onSelect: updateCroppingAttributes,
      onChange: updateCroppingAttributes,
    });
  }

  // When selected an image, use FileReader to load it, then
  // display the cropping phase
  $(document).on("change", "#" + avatarEditor.side + "-side-img-file", function() {
    var input = $(this)[0];
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
	var fileTarget = $("#" + avatarEditor.side + "-side-img-file").prop('files')[0];
	if (fileTarget.size > 1500000) {
	  addAlert("error", "Image file too large (Max size: 1.5MB)", 3000);
	} else {
	  $("#" + avatarEditor.side + "-img-to-crop").attr("src", e.target.result);
	  avatarEditor.currentTarget = fileTarget
	  avatarEditor.currentSource = "upload";
	  avatarEditor.cropPhase();
	}
      };
      reader.readAsDataURL(input.files[0]);
    }
  });

  // when clicked 'OK' in cropping phase, get the cropped image, and
  // use ajax to send the file to the server
  $(document).on("click", "#" + avatarEditor.side + "-img-cropper-confirm-btn", function() {
    var formdata = new FormData();
    formdata.append("target", avatarEditor.currentTarget);
    formdata.append("file_type", "img");
    formdata.append("source_type", avatarEditor.currentSource);
    formdata.append("crop_x", $("#crop_x").val());
    formdata.append("crop_y", $("#crop_y").val());
    formdata.append("crop_w", $("#crop_w").val());
    formdata.append("crop_h", $("#crop_h").val());

    avatarEditor.sendFileAJAX(formdata);
    // hide the cropper
    $("#" + avatarEditor.side + "-img-editor-uploader").removeClass("hidden");
    $("#" + avatarEditor.side + "-img-editor-cropper").addClass("hidden");
  });

  // when clicked the cancel crop btn, reset the cropper and hide it
  $(document).on("click", "#" + avatarEditor.side + "-img-cropper-cancel-btn", function() {
    $("#" + avatarEditor.side + "-img-editor-uploader").removeClass("hidden");
    $("#" + avatarEditor.side + "-img-editor-cropper").addClass("hidden");
    // reset jcrop
    $("#" + avatarEditor.side + "-img-cropper-wrapper").html("");
    $("#" + avatarEditor.side + "-img-cropper-wrapper").prepend("<img id='" + avatarEditor.side + "-img-to-crop' src='' alt='your browser may not support FileReader API.'>");
    initJCrop(avatarEditor.side);
  });
  //////////// CROPING DONE /////////////////
}

AvatarEditor.prototype.flip = function() {
    var avatarEditor = this;
    var otherSide = null;
    if (avatarEditor.side == "front") {
	otherSide = "back";
    } else {
	otherSide = "front";
    }
    flip($("#avatar-editors"));
}

// This method sends an ajax request to upload the file
AvatarEditor.prototype.sendFileAJAX = function(formdata) {
    var avatarEditor = this;
    $.ajax({
	type: 'post',
	url: '/uploaded_files',
	data: formdata,  // formdata has a property "target" & "file_type" & "source_type"
	contentType: false,
	processData: false,
	dataType: 'json', // get back json
	beforeSend: function() {
	  $("#img_" + avatarEditor.side + "_waiting").removeClass("hidden");
	},
	success: function(output) {
	    var fileName = output["file_name"];
	    var storeDir = output["store_dir"];
	    var host = output["host"];
	    if (fileName) {
		avatarEditor.imgFile = fileName;
		avatarEditor.storeDir = storeDir;
		avatarEditor.host = host;
		avatarEditor.displayPhase(host + "/" + storeDir + "/cropped_" + fileName);
	    }
	},
	complete: function() {
	  $("#img_" + avatarEditor.side + "_waiting").addClass("hidden");
	}
    });
}

// Go to the display phase of the image editor. Show the image.
AvatarEditor.prototype.displayPhase = function(croppedUrl) {
    var avatarEditor = this;
    if (croppedUrl) {
	// Go to display phase, display that imgFile
	$("#" + avatarEditor.side + "-img-editor-uploader").addClass("hidden");
	$("#" + avatarEditor.side + "-img-editor-display").removeClass("hidden");
	$("#" + avatarEditor.side + "-img-display").attr("src", croppedUrl);

	// hasDraft is true for this side
	//avatarEditor.editor.hasDraft[avatarEditor.side] = true;
	//avatarEditor.editor.updateCreateCardBtn();
    }
}

AvatarEditor.prototype.grabContent = function() {
    if (!this.host) {
	return "";
    }
    var result = {};
    result["file_name"] = this.imgFile;
    result["store_dir"] = this.storeDir;
    result["host"] = this.host;
    return result;
}

AvatarEditor.prototype.onConfirm = function(callback) {
    this.confirmCallback = callback;
}

AvatarEditor.prototype.croppedUrl = function() {
    if (!this.host) {
	return null;
    }
    return this.host + "/" + this.storeDir + "/cropped_" + this.imgFile;
}

// go to crop phase;
// input is a javascript input[type='file'] object, not a jquery object
AvatarEditor.prototype.cropPhase = function() {
  var avatarEditor = this;

  // hide the upload phase
  $("#" + avatarEditor.side + "-img-editor-uploader").addClass("hidden");
  $("#" + avatarEditor.side + "-img-editor-cropper").removeClass("hidden");
  $("#" + avatarEditor.side + "-img-editor-display").addClass("hidden");
};

function getUrl(href) {
    var l = document.createElement("a");
    l.href = href;
    return l;
}

function getUrlFileName(href) {
    var index = href.lastIndexOf("/") + 1;
    var filename = href.substring(index);
}
