$(document).ready(function() {
    $(document).on("click", "#nav-username", function() {
	$("#profile-pic-dropdown").removeClass("hidden");
    });

    if ($("#nav-inbox-btn").position()) {
	$("#nav-inbox").css("left", $("#nav-inbox-btn").position().left - $("#nav-inbox").width());
    }

    grabNotifications();

    // toggle dropdown when hover on name
    $(document).on({
	mouseenter: function () {
	    $("#profile-pic-dropdown").removeClass("hidden");
	    $("#nav-inbox").addClass("hidden");
	    $("#nav-inbox-btn").removeClass("nav-option-highlighted");
	},
	mouseleave: function () {
	    $("#profile-pic-dropdown").addClass("hidden");
	}
    }, "#nav-username");

    // toggle inbox when hover
    $(document).on({
	mouseenter: function () {
	    $("#nav-inbox").removeClass("hidden");
	    $("#nav-inbox-btn").addClass("nav-option-highlighted");
	},
    }, "#nav-inbox-btn");
    $(document).on({
	mouseleave: function () {
	    $("#nav-inbox").addClass("hidden");
	    $("#nav-inbox-btn").removeClass("nav-option-highlighted");
	}
    }, "#nav-inbox");

    // before submitting the search, change its action; appending the
    // search string
    $("#nav-search").submit(function() {
	var query = $("#nav-search-input").val();
	$("#nav-search").attr("action", "/search/" + query);
    });
});

function grabNotifications() {
    $.ajax({
	type: "GET",
	url: "/notifications/",
	contentType: "script",
	success: function(output) {
	}
    });
}
