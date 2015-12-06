$(document).ready(function() {
  $(document).on("click", "#flip-to-login-btn", function() {
    flip($("#login-form-card"));
  });

  $(document).on("click", "#flip-to-join-btn", function() {
    flip($("#login-form-card"));
  });

  $(document).on("click", "#nav-signup-btn", function() {
    if ($("#login-form-card").hasClass('flip')) {
      $("#login-form-card").removeClass('flip');
    }
  });

  $(document).on("click", "#nav-login-btn", function() {
    if (!$("#login-form-card").hasClass('flip')) {
      $("#login-form-card").addClass('flip');
    }
  });

  $(document).on("click", "#add-card-btn", function() {
    $(".glass-overlay").css("display", "block");
    $("#editor-container-home").css("display", "block");
  });

  $(document).on("click", ".glass-overlay", function() {
    $(".glass-overlay").css("display", "none");
    $("#editor-container-home").css("display", "none");
  });

  var editor = new Editor("new_card");
  editor.init();

  $("#new_card").on("ajax:success", function(e, data, status, xhr) {
    // when new card is created, refresh the recommended content
    // by ajax query to user:show again
    grabRecommendContents();
  });
    
  $(".home-card").each(function() {
    adjustCardHeight($(this));
  });

  $("#recommended-contents-wrapper").masonry({
    columnWidth: 270,
    gutter: 10,
    itemSelector: ".home-card",
    transitionDuration: 0
  });

  var cardsHandler = new CardsHandler();
  cardsHandler.init();
});

function grabRecommendContents() {
  $.ajax({
    // send to current page (user show)
    type: 'GET',    
    dataType: 'script',
    success: function(data) {
      // return a script that will render the recommended contents html
      $(document).ready(function() {
	$(".home-card").each(function() {
	  adjustCardHeight($(this));
	});
	// This is how you reload with masonry
	$("#recommended-contents-wrapper").masonry('reloadItems');
	$("#recommended-contents-wrapper").masonry();
      });
    }
  });
}

// homeCard: individual instance of $(".home-card")
function adjustCardHeight(homeCard) {
  var back = homeCard.find(".flipper-back.card-side");
  var front = homeCard.find(".flipper-front.card-side");
  var maxHeight = Math.max(back.outerHeight(), front.outerHeight());
  back.outerHeight(maxHeight);
  front.outerHeight(maxHeight);
  homeCard.height(maxHeight);
}

/* Event handlers for cards at home page */
function CardsHandler() {
  // focusing card is should have the format "card_#{id}"
  this.focusingCardId = undefined; // html element id
  this.focusingCardRawId = undefined; // card_id
}

CardsHandler.prototype.init = function() {
  var handler = this;
  // flip when clicked home card
  $(document).on('click', '.home-card', function(e) {
    // check if the target has class that's in the flipExceptionList
    if (!$(e.target).hasClass("no-flip")) {
      flip($(this));
    }
  });

  // toggle info fade in and fade out
  $(document).on({
    mouseenter: function () {
      $(this).stop().animate({
	opacity: 1
      }, 150);
    },
    mouseleave: function () {
      $(this).stop().animate({
	opacity: 0
      }, 150);
    }
  }, ".info-toggle-wrapper");

  // show dark-overlay when hit info-toggle
  // change the z-index of the current card to
  // 5, which is greater than the overlay z-index(3),
  // and the z-index of info panels (4).
  // When clicked somewhere else, hide the dark
  // overlay, and change the z-index of the card back
  // to auto. When toggling, checks if this .info-toggle
  // element has .toggle-off class. 
  $(document).on("click", ".info-toggle", function() {
    // only do the following if the dark-overlay is hidden
    if ($(".dark-overlay").hasClass("hidden")) {
      $(".dark-overlay").removeClass("hidden");
      var focusHomeCard = $(this).parents(".home-card");
      focusHomeCard.css("z-index", "5");
      handler.focusingCardId = focusHomeCard.attr("id");
      handler.focusingCardRawId = handler.focusingCardId.split("_")[1]
      
      // Reset the info panels
      handler.resetLikeCommentsPanel();
      handler.resetDeckCardsPanel();
      // grab info first
      grabCardInfo(handler.focusingCardRawId);

      // show the panels, with quick animation
      // first place the panels at the same position
      // as the parent card, then do the slide
      var height = $("#" + handler.focusingCardId).outerHeight();
      var width = 250;
      var margin = 30;
      var cardPosition = $("#" + handler.focusingCardId).position();
      $("#like-comment-panel").removeClass("hidden");
      $("#deck-cards-panel").removeClass("hidden");
      $("#like-comment-panel").css({
	top: cardPosition.top + "px",
	left: cardPosition.left + "px"
      });
      $("#deck-cards-panel").css({
	top: cardPosition.top + "px",
	left: cardPosition.left + "px"
      });
      $("#like-comment-panel").animate({
	top: (cardPosition.top + height + margin) + "px",
      }, 300, function() {
	// show info
      });
      $("#deck-cards-panel").animate({
	left: (cardPosition.left + width + margin) + "px"
      }, 300, function() {
	// show info
      });
    } else {
      var cardPosition = $("#" + handler.focusingCardId).position();
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
      $(".dark-overlay").addClass("hidden");
    }
  });
  $(document).on("click", ".dark-overlay", function() {
    $(".dark-overlay").addClass("hidden");
    $("#" + handler.focusingCardId).css("z-index", "auto");
    $("#like-comment-panel").addClass("hidden");
    $("#deck-cards-panel").addClass("hidden");
  });
  // When clicked the card like button, send ajax request
  // to increase the count of likes of that card. When clicked
  // again, fire request to decrement it.
  $(document).on("click", "#like-card-btn", function() {
    var liked = $("#like-card-btn").hasClass("liked");
    ajaxLikeCard(liked, handler.focusingCardRawId);
  });
  
  // Submit text area on enter hit
  // TODO: This isn't a good idea. Maybe there should be a submit
  // button. But it hasn't been designed yet.
  $(document).on("keyup", "#new_comment textarea", function(e) {
    e = e || event;
    if (e.keyCode === 13) {
      // hit enter
      // Set value of the card_id hidden field to the id of this
      // card; If the content does not only contain the new line 
      // character submit the form. (i.e. length > 1)
      var content = $("#comment_content").val();
      if (content.length > 1) {
	$("#comment_card_id").val(handler.focusingCardRawId);
	// remove the last character, which is a \r (new line)
	$("#comment_content").val(content.substring(0, content.length-1));
	$("#new_comment").submit();
	$("#comment_card_id").val("");
	$("#comment_content").val("");
      } else {
	$("#comment_content").val("");
      }
    }
  });
}

CardsHandler.prototype.resetLikeCommentsPanel = function() {
  $("#n_likes").html("...");
  $("#n_comments").html("...");
  $("#comment_list").html("");
}

CardsHandler.prototype.resetDeckCardsPanel = function() {
  $("#deck_author").html("...");
  $("#deck_title").html("...");
}

// AJAX request to request card info which includes number of likes,
// number of comments, and comments, as well as the deck title,
// deck id, author name, author id, number of favorites the deck
// has, and other cards in the deck. The result will be script
// that renders the info. TODO: This method might be inefficient
// because there is no caching of the data obtained.
function grabCardInfo(cardId) {
  $.ajax({
    type: 'GET',
    url: '/cards/' + cardId + '/card_info',
    dataType: 'script',
    success: function(output) {
      
    }
  });
}

// AJAX request to increment/decrement the number of likes for a
// card given its id.
function ajaxLikeCard(liked, cardId) {
  var type = "POST";
  var action = "like";
  if (liked) {
    // should delete
    type = "DELETE";
    action = "unlike";
  }
  $.ajax({
    type: type,
    url: '/cards/' + cardId + '/' + action,
    dataType: 'script', // get back script
    success: function(output) {
    }
  });
}
