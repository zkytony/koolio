// Deck editor
function DeckEditor(id) {
    this.id = id;
}

DeckEditor.prototype.init = function() {
    var editor = this;
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
    $(document).on("change", "#new_deck :input", function() {
	if (editor.validate()) {
	    $("#deck-editor-submit-btn").prop("disabled", false);
	} else {
	    $("#deck-editor-submit-btn").prop("disabled", true);
	}
    });

/*    // Before submitting, validate the form
    $("#new_deck").submit(function(e) {
	e.preventDefault();
	if (editor.validate()) {
	    $(this).submit();
	}
    });
*/

    // on ajax success
    $(document).on("ajax:success", "#new_deck", function() {
	$("#overlay-for-deck-editor").css("display", "none");
	$("#" + editor.id).addClass("hidden");
	editor.reset();
    });

    // Dynamically convert tags entered into a pretty tag element

    // Dynamically prompt the user about the users while he is typing
    // This is good, because this way we can retrieve the user_id
    // at the same time as the user is selected.
}

DeckEditor.prototype.validate = function() {
    if ($("#deck_title").val().length <= 0
	&& $("#deck_description").val().length <= 0) {
	return false;
    } else if ($("#deck-tags").val().length <= 0) {
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
}
