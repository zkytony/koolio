// Deck editor
function DeckEditor(id) {
  this.id = id;
  this.tagsCount = 0;
  this.tags = $("#added-tags");
}

DeckEditor.prototype.init = function() {
  var editor = this;

  editor.tags.tagit({
    onTagAdded: function(event, ui) {
      editor.tagsCount += 1;
    },
    onTagRemoved: function(event, ui) {
      editor.tagsCount -= 1;
    }
  });

  $(document).on("click", "#prof-add-deck-btn", function() {
    $("#overlay-for-deck-editor").css("display", "block");
    $("#" + editor.id).removeClass("hidden");
  });
  $(document).on("click", "#overlay-for-deck-editor", function() {
    $("#overlay-for-deck-editor").css("display", "none");
    $("#" + editor.id).addClass("hidden");
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
  });

  // when form changes, validate it 
  $(document).on("keyup", "#new_deck :input", function() {
    if (editor.validate()) {
      $("#deck-editor-submit-btn").prop("disabled", false);
    } else {
      $("#deck-editor-submit-btn").prop("disabled", true);
    }
  });

  // on ajax success
  $(document).on("ajax:success", "#new_deck", function() {
    $("#overlay-for-deck-editor").css("display", "none");
    $("#" + editor.id).addClass("hidden");
    editor.reset();
  });

  // Dynamically prompt the user about the users while he is typing
  // This is good, because this way we can retrieve the user_id
  // at the same time as the user is selected.
}

DeckEditor.prototype.validate = function() {
  if ($("#deck_title").val().length <= 0
    || $("#deck_description").val().length <= 0) {
      return false;
  } else if (this.tagsCount <= 0) {
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
