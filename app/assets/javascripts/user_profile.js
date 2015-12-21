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

    var cardsHandler = new ProfileCardsHandler();
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
//		$("#hot-contents").masonry('reloadItems');
	    } else if (type === "all") {
//		$(".time-period").masonry('reloadItems');
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

// Override the show, retrieve card info prototype for "all".
// Since each time period is a masonry subject.
ProfileCardsHandler.prototype = Object.create(CardsHandler.prototype);
function ProfileCardsHandler() {
    CardsHandler.call(this);
}

ProfileCardsHandler.prototype.showCardInfo = function() {
    // Handle the case where it is currently displaying "all" cards.
    var type = $(".tab-item.selected").html().toLowerCase()

    var handler = this;
    // show the panels, with quick animation
    // first place the panels at the same position
    // as the parent card, then do the slide
    var width = 250;
    var margin = 30;
    //var height = $("#" + handler.focusingCardId).outerHeight();
    var cardPosition = $("#" + handler.focusingCardId).position();

    if (type === "all") {
	// each time period's position top attribute should be set
	// correctly.
	var parentTimePeriod = $("#" + handler.focusingCardId).closest(".time-period");
	cardPosition.top = cardPosition.top + parentTimePeriod.position().top;
    }

    var focusedCard = cards[handler.focusingCardId];
    focusedCard.focus();
    $("#like-comment-panel").removeClass("hidden");
    $("#deck-cards-panel").removeClass("hidden");
    // first align the comment panel with the card
    $("#like-comment-panel").css({
	top: cardPosition.top + "px",
	left: cardPosition.left + "px"
    });
    $("#deck-cards-panel").css({
	top: cardPosition.top + "px",
	left: cardPosition.left + "px"
    });
    $("#like-comment-panel").animate({
	top: (cardPosition.top + focusedCard.getTrueHeight(focusedCard.currentSide) + margin) + "px",
    }, 300, function() {
	// show info
    });
    $("#deck-cards-panel").animate({
	left: (cardPosition.left + width + margin) + "px"
    }, 300, function() {
	// show info
    });  ;
}

ProfileCardsHandler.prototype.retrieveCardInfo = function() {
    var handler = this;
    // Handle the case where it is currently displaying "all" cards.
    var type = $(".tab-item.selected").html().toLowerCase()
    // clicked on info toggle again, but glass overlay is
    // not hidden. So retreive the panels
    var cardPosition = $("#" + handler.focusingCardId).position();

    if (type === "all") {
	// each time period's position top attribute should be set
	// correctly.
	var parentTimePeriod = $("#" + handler.focusingCardId).closest(".time-period");
	cardPosition.top = cardPosition.top + parentTimePeriod.position().top;
    }

    $("#like-comment-panel").animate({
	top: cardPosition.top + "px",
    }, 300, function() {
	$("#like-comment-panel").addClass("hidden");
    });
    $("#deck-cards-panel").animate({
	left: cardPosition.left + "px"
    }, 300, function() {
	$("#deck-cards-panel").addClass("hidden");
	$("#" + handler.focusingCardId).css("z-index", "auto");
    });  
}
