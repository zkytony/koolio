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

    // toggle inbox when click
    $(document).on("click", "#nav-inbox-btn", function() {
	if ($("#nav-inbox").hasClass("hidden")) {
	    $("#nav-inbox").removeClass("hidden");
	    $("#nav-inbox-btn").addClass("nav-option-highlighted");
	} else {
	    $("#nav-inbox").addClass("hidden");
	    $("#nav-inbox-btn").removeClass("nav-option-highlighted");
	}
    });

});
