$(document).ready(function() {
    $(document).on("click", "#nav-username", function() {
	$("#profile-pic-dropdown").removeClass("hidden");
    });

    // toggle dropdown when hover on name
    $(document).on({
	mouseenter: function () {
	    $("#profile-pic-dropdown").removeClass("hidden");
	},
	mouseleave: function () {
	    $("#profile-pic-dropdown").addClass("hidden");
	}
    }, "#nav-username");

});
