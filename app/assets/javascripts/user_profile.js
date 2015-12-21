$(document).ready(function() {
    // get the user id from the url
    // the profile url will be '/users/:id/profile'
    var path = window.location.pathname;  // "/xxx/xxx/xxx.."
    var userId = path.split("/")[2];
    ajaxGrabCardsForProfile(userId, "all");

    $(document).on("click", "#hot-item", function() {
	$(".tab-item").removeClass("selected");
	$("#hot-item").addClass("selected");
	ajaxGrabCardsForProfile(userId, "hot");
    });

    $(document).on("click", "#all-item", function() {
	$(".tab-item").removeClass("selected");
	$("#all-item").addClass("selected");
	ajaxGrabCardsForProfile(userId, "all");
    });

    $(document).on("click", "#decks-item", function() {
//	ajaxGrabDecksForProfile(userId);
    });

    var cardsHandler = new CardsHandler();
    cardsHandler.init();
});

// AJAX request to grab a certain number of cards
// to display on the profile page.
// type - either "all", or "hot". "all" will result
//        in cards sorted by created time; "hot" will
//        result in cards sorted by number of likes.
function ajaxGrabCardsForProfile(userId, type) {
    $.ajax({
	type: "GET",
	url: '/users/' + userId + '/profile_cards',
	data: { type: type },
	dataType: 'script', // get the script which will run itself
	success: function(output) {
	    //alert(output);
	    if (type === "hot") {
		$("#hot-contents").masonry('reloadItems');
	    } else if (type === "all") {
		$(".time-period").masonry('reloadItems');
	    }

	    $(".home-card").each(function() {
		dealWithHomeCard($(this));
	    });

	    if (type === "hot") {
		$("#hot-contents").masonry({
		    columnWidth: 270,
		    gutter: 20,
		    itemSelector: ".home-card",
		    transitionDuration: 0
		});
	    } else if (type === "all") {
		$(".time-period").masonry({
		    columnWidth: 270,
		    gutter: 20,
		    itemSelector: ".home-card",
		    transitionDuration: 0
		});
	    }
	}
    });
}

