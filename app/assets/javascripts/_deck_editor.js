// Deck editor
function DeckEditor(id) {
  this.id = id;
  this.tagsCount = 0;
  this.tags = $("#added-tags");
  // indicate whether the deck editor is in edit mode
  this.editDeckId = undefined;
}

DeckEditor.prototype.init = function() {
  var editor = this;

  editor.initTagsField(null);

  $(document).on("click", "#prof-add-deck-btn", function() {
    if (editor.editMode) {
      // previously edit mode, so there may be valus in the
      // form fields. Reset the editor
      editor.reset();
    }
    editor.editDeckId = undefined;
    editor.show();
  });
  $(document).on("click", "#overlay-for-deck-editor", function() {
    editor.hide();
  });

  // when checked "private", display Share as visitors
  // :: The mechinism of sharing may be more complicated,
  // including options "not to share", "share to followers" or
  // things like that.
  $(document).on("click", ".deck-prop-radios", function() {
    if ($("#prop-private").is(":checked")) {
      $("#share-as-visitors").removeClass("hidden");
    } else {
      $("#share-as-visitors").addClass("hidden");
    }
    // validate
    if (editor.validate()) {
      editor.toggleSubmitButton(true);
    } else {
      editor.toggleSubmitButton(false);
    }
  });

  // when form changes, validate it 
  $(document).on("keyup", "#new_deck :input", function() {
    if (editor.validate()) {
      editor.toggleSubmitButton(false);
    } else {
      editor.toggleSubmitButton(true);
    }
  });

  // on ajax success
  $(document).on("ajax:success", "#new_deck", function() {
    $("#overlay-for-deck-editor").css("display", "none");
    $("#" + editor.id).addClass("hidden");
    editor.reset();
  });

  // when clicked cancel btn, reset the editor and hide it
  $(document).on("click", "#deck-editor-cancel-btn", function() {
    editor.hide();
    editor.reset();
  });

  // when clicked delete button, delete the deck
  // this is only possible when in edit mode.
  $(document).on("click", "#deck-editor-delete-btn", function() {
    // assume in edit mode
    // change the _method input to delete
    $("#deck-method-field").val("delete");
    // submit the form
    $("#new_deck").submit();
  });

  // when clicked on the deck-gear, bring out the deck editor
  // make ajax request to grab the deck data, and fill the form
  $(document).on("click", ".deck-gear", function() {
    var deckId = $(this).closest(".one-deck").attr("id").split("_")[1];
    editor.reset(); // clear whatever is in the form

    editor.editDeckId = deckId;
    editor.show();
    editor.showDeckInfo(deckId);
  });

  // Dynamically prompt the user about the users while he is typing
  // This is good, because this way we can retrieve the user_id
  // at the same time as the user is selected.
}

DeckEditor.prototype.validate = function() {
  var editor = this;
  if ($("#deck_title").val().length <= 0
    || $("#deck_description").val().length <= 0) {
      return false;
  } else if (editor.tagsCount <= 0) {
    return false;
  }
  return true;
}

DeckEditor.prototype.reset = function() {
  $("#new_deck input[type='text']").val("");
  $("#deck_description").val("");
  $("#deck-editor-submit-btn").prop("disabled", true);
  $("#prop-public").prop("checked", true);
  $("#prop-private").prop("checked", false);
  this.tags.tagit('removeAll');
  this.editDeckId = undefined;
  // remove the hidden method field
  $("#deck-method-field").remove();
}

// make the given tag string a pretty tag element,
// and append it to "id", which is supposed to be
// an input text field
// raw - the raw string to be converted
// id - the id of the element that the element will be appended to
// return the width of the new item
DeckEditor.prototype.makePrettyBlock = function(raw, id) {
  var htmlString = "<li class='one-tag' id='tag-" + raw + "'>" + raw + "</li>";
  $("#"+id).append(htmlString);
  return $("#tag-" + raw).outerWidth();
}

// for some reason the .assignedTags() method do not
// work for the tagit object. 
DeckEditor.prototype.getTags = function() {
  var tags = [];
  $("#added-tags .tagit-label").each(function() {
    tags.push($(this).html());
  });
  return tags;
}

DeckEditor.prototype.show = function() {
  var editor = this;
  $("#overlay-for-deck-editor").css("display", "block");
  $("#" + editor.id).removeClass("hidden");

  if (editor.editDeckId) {
    // edit mode: change the style of some buttons, and
    // change the action of the form
    $("#deck-editor-delete-btn").removeClass("hidden");
    $("#deck-editor-submit-btn").html("Update");
    $("#deck-editor-submit-btn").attr("id", "deck-editor-update-btn");
    // For rails, we need to add a input field "_name" with value "patch"
    // to emulate the PATCH request
    $("#new_deck").append("<input name='_method' id='deck-method-field' type='hidden' value='patch'/>");
    // change the action
    $("#new_deck").attr("action", "/decks/" + editor.editDeckId);
  } else {
    // create mode: change the style of some buttons, and
    // change the action of the form
    $("#deck-editor-delete-btn").addClass("hidden");
    $("#deck-editor-update-btn").html("Submit");
    $("#deck-editor-update-btn").attr("id", "deck-editor-submit-btn");
    // remove the hidden method field
    $("#deck-method-field").remove();
    // reset the action
    $("#new_deck").attr("action", "/decks");
  }
}

DeckEditor.prototype.hide = function() {
  var editor = this;
  $("#overlay-for-deck-editor").css("display", "none");
  $("#" + editor.id).addClass("hidden");
}

DeckEditor.prototype.initTagsField = function(availableTags) {
  var editor = this;
  editor.tags.tagit({
    availableTags: availableTags,
    onTagAdded: function(event, ui) {
      editor.tagsCount += 1;
    },
    onTagRemoved: function(event, ui) {
      editor.tagsCount -= 1;
    }
  });
}

// given the deckId, display the info, such as title, decscription,
// in the editor. Make AJAX request.
DeckEditor.prototype.showDeckInfo = function(deckId) {
  var editor = this;
  $.ajax({
    type: 'GET',
    url: '/decks/' + deckId + '/deck_info',
    dataType: 'json',
    success: function(output) {
      console.log(output);
      // fill the form
      $("#deck_title").val(output["deck"]["title"]);
      $("#deck_description").val(output["deck"]["description"]);
      // change the radio button
      if (output["deck"]["open"]) {
	$("#prop-public").prop("checked", true);
	$("#prop-private").prop("checked", false);
	$("#share-as-visitors").addClass("hidden");	
      } else {
	$("#prop-public").prop("checked", false);
	$("#prop-private").prop("checked", true);
	$("#share-as-visitors").removeClass("hidden");
      }

      // add li elements to deck_tags
      var tags = output["tags"];
      editor.tagsCount = tags.length;
      tags.forEach(function(tag) {
	editor.tags.tagit('createTag', tag);
      });
    }
  });
}

// on - whether to enable the button
DeckEditor.prototype.toggleSubmitButton = function(on) {
  var editor = this;
  if (editor.editDeckId) {
    $("#deck-editor-update-btn").prop("disabled", !on);
  } else {
    $("#deck-editor-submit-btn").prop("disabled", !on);
  } 
}
