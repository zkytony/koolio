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
}
