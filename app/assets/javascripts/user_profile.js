var noOngoingLoad = true;
$(document).ready(function() {
  // get the user id from the url
  // the profile url will be '/users/:id/profile'
  var path = window.location.pathname;  // "/xxx/xxx/xxx.."
  var userId = path.split("/")[2];
  ajaxGrabCardsForProfile(userId, "all", false);

  $(document).on("click", "#hot-item", function() {
    $("#all-contents").html("");
    $("#decks-contents").html("");
    $(".tab-item").removeClass("selected");
    $("#hot-item").addClass("selected");
    ajaxGrabCardsForProfile(userId, "hot", false);
  });

  $(document).on("click", "#all-item", function() {
    $("#all-contents").html("");
    $("#hot-contents").html("");
    $(".tab-item").removeClass("selected");
    $("#all-item").addClass("selected");
    ajaxGrabCardsForProfile(userId, "all", false);
  });

  $(document).on("click", "#decks-item", function() {
    $("#all-contents").html("");
    $("#hot-contents").html("");
    $(".tab-item").removeClass("selected");
    $("#decks-item").addClass("selected");
    ajaxGrabDecksForProfile(userId);
  });

  $(document).on("click", "#decks-item", function() {
    //	ajaxGrabDecksForProfile(userId);
  });

  // When scroll to nearly the bottom, grab more cards for "hot-contents"
  var limit = 20;
  $(window).scroll(function() {
    var isHot = $("#hot-item").hasClass("selected");
    var isAll = $("#all-item").hasClass("selected")
    if (isHot || isAll) {
      if ($(document).height() - limit <= $(window).scrollTop() + $(window).height()) {
	if (noOngoingLoad) {
	  if (isHot) {
	    ajaxGrabCardsForProfile(userId, "hot", true);
	  } else if (isAll) {
	    ajaxGrabCardsForProfile(userId, "all", true);
	  }
	}
      }
    }
  });

  var cardsHandler = new ProfileCardsHandler();
  cardsHandler.init();
});

// AJAX request to grab a certain number of cards
// to display on the profile page.
// type - either "all", or "hot". "all" will result
//        in cards sorted by created time; "hot" will
//        result in cards sorted by number of likes.
// more - boolean; true if this ajax is to fetch
//        more elements
function ajaxGrabCardsForProfile(userId, type, more) {
  noOngoingLoad = false;

  var card_ids = [];
  $(".home-card").each(function() {
    card_ids.push($(this).attr("id").split("_")[1]);
  });

  $.ajax({
    type: "GET",
    url: '/users/' + userId + '/profile_cards',
    data: { type: type, more: more, card_ids: card_ids },
    dataType: 'script', // get the script which will run itself
    success: function(output) {
      //alert(output);
      if (type === "hot") {
	$("#hot-contents").masonry('reloadItems');
      } else if (type === "all") {
	//$(".time-period").masonry('reloadItems');
      }

      $(".home-card").each(function() {
	  if (!$(this).hasClass("focused")) {
	      dealWithHomeCard($(this));
	  }
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
      noOngoingLoad = true;
    }
  });
}

// AJAX request to get a certain number of decks for the
// given user. The output is a script, which will show the
// decks in the #decks-contents div. Each deck is shown
// as a square which has four cells; each cell is a "scaled"
// version of one card inside the deck.
function ajaxGrabDecksForProfile(userId) {
  $.ajax({
    type: "GET",
    url: '/users/' + userId + '/profile_decks',
    dataType: 'script', // get the script which will run itself
    success: function(output) {
      //alert(output);
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
  var type = $(".tab-item.selected").html().toLowerCase();

  var handler = this;
  // show the panels, with quick animation
  // first place the panels at the same position
  // as the parent card, then do the slide
  var width = 250;
  var margin = 40;
  //var height = $("#" + handler.focusingCardId).outerHeight();
  var cardPosition = $("#" + handler.focusingCardId).position();

  if (type === "all") {
    // each time period's position top attribute should be set
    // correctly.
    var parentTimePeriod = $("#" + handler.focusingCardId).closest(".time-period");
    cardPosition.top = cardPosition.top + parentTimePeriod.position().top;
  }

  var focusedCard = cards[handler.focusingCardRawId];
  focusedCard.focus();
  $("#like-comment-panel").removeClass("hidden");
  $("#deck-cards-panel").removeClass("hidden");
  // first align the comment panel with the card

  // if the deck panel is out of bound, reverse the deckPanelLeft
  // to show it on the other side
  var deckPanelLeft = (cardPosition.left + width + margin);
  if (deckPanelLeft + width > $("#" + type + "-contents").outerWidth()) {
    deckPanelLeft = (cardPosition.left - width - margin);
  }
  handler.showCardInfoSetup(
    { 
      top: (cardPosition.top + focusedCard.getTrueHeight(focusedCard.currentSide) + margin) + "px",
      left: cardPosition.left + "px",
      opacity: 0      
    }, // like panel initial
    {
      top: cardPosition.top + "px",
      left: deckPanelLeft,
      opacity: 0
    } // deck panel initial
  );

  handler.showCardInfoAnimate(
    { 
      opacity: 1
    }, // like panel initial
    {
      opacity: 1
    } // deck panel initial
  );
}

ProfileCardsHandler.prototype.handleFlip = function(cardObj) {
  var handler = this;
  var card = cards[cardObj.attr("id").split("_")[1]];
  flipCard(card);

  if (card.focused) {
    var type = $(".tab-item.selected").html().toLowerCase();
    var margin = 30;
    var cardPosition = $("#" + handler.focusingCardId).position();

    if (type === "all") {
      // each time period's position top attribute should be set
      // correctly.
      var parentTimePeriod = $("#" + handler.focusingCardId).closest(".time-period");
      cardPosition.top = cardPosition.top + parentTimePeriod.position().top;
    }

    $("#like-comment-panel").stop().animate({
      top: (cardPosition.top + card.getTrueHeight(card.currentSide) + margin) + "px",
    }, 300, function() {
      // show info
    });    
  }
}
