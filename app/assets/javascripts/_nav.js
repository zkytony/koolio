$(document).ready(function() {
    if ($("#nav-inbox-btn").position()) {
	$("#nav-inbox").css("left", $("#nav-inbox-btn").position().left - $("#nav-inbox").width() + $("#nav-inbox-btn").width());
    }

    if ($("#nav-inbox").length) {
	grabNotifications();
    }

    // toggle dropdown when hover on name
    $(document).on({
	mouseenter: function () {
	    if ($("#profile-pic-dropdown").hasClass("hidden")) {
		showDropDown();
	    }
	},
	mouseleave: function () {
	    if (!$("#profile-pic-dropdown").hasClass("hidden")) {
		hideDropDown();
	    }
	}
    }, "#nav-username");

    $(document).on("click tap", "#nav-username p", function(e) {
	e.preventDefault();

	if ($("#profile-pic-dropdown").hasClass("hidden")) {
	    showDropDown();
	} else {
	    hideDropDown();
	}
    });

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

function showDropDown() {
    $("#profile-pic-dropdown").removeClass("hidden");
    $("#nav-inbox").addClass("hidden");
    $("#nav-inbox-btn").removeClass("nav-option-highlighted");
}

function hideDropDown() {
    $("#profile-pic-dropdown").addClass("hidden");
}
