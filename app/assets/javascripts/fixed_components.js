$(document).ready(function() {
    $(document).on("click", "#feedback-btn", function() {
	addAlert("info", "Please send feed back to <a href=\"mailto:feedback@koolio.io\">feedback@koolio.io</a>. Thank you very much!", 4500);
    });
});
