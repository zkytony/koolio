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
      //flip($(this));

      handler.handleFlip($(this));
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
      handler.focusingCardRawId = handler.focusingCardId.split("_")[1];
      
      // Reset the info panels
      handler.resetLikeCommentsPanel();
      handler.resetDeckCardsPanel();
      // grab info first
      grabCardInfo(handler.focusingCardRawId);
      handler.showCardInfo();
    } else {
      var focusedCard = cards[handler.focusingCardRawId];
      focusedCard.unfocus();
      $(".dark-overlay").addClass("hidden");
      handler.retrieveCardInfo();
    }
  });
  $(document).on("click", ".dark-overlay", function() {
    $(".dark-overlay").addClass("hidden");
    $("#" + handler.focusingCardId).css("z-index", "auto");
    $("#like-comment-panel").addClass("hidden");
    $("#deck-cards-panel").addClass("hidden");
    var focusedCard = cards[handler.focusingCardRawId];
    focusedCard.s[focusedCard.currentSide].addClass("notransition");
    focusedCard.unfocus();
    focusedCard.s[focusedCard.currentSide].removeClass("notransition");
  });
  // When clicked the card like button, send ajax request
  // to toggle like of this card
  $(document).on("click", "#like-card-btn", function() {
    var liked = $("#like-card-btn").hasClass("liked");
    ajaxLikeCard(liked, handler.focusingCardRawId);
  });

  // When clicked like comment btn, ajax request to toggle like
  // of this comment.
  $(document).on("click", ".like-comment-btn", function() {
    var liked = $(this).hasClass("liked");
    // id is of the format comlk_#
    var commentId = $(this).attr("id").split("_")[1];
    ajaxLikeComment(liked, commentId);
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

// This method may need to be overriden in the case that
// not all cards are "masonried" in one div.
CardsHandler.prototype.showCardInfo = function() {
  var handler = this;
  // show the panels, with quick animation
  // first place the panels at the same position
  // as the parent card, then do the slide
  var width = 250;
  var margin = 30;
  //var height = $("#" + handler.focusingCardId).outerHeight();
  var cardPosition = $("#" + handler.focusingCardId).position();
  var focusedCard = cards[handler.focusingCardRawId];
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
  });  
}

// This method may need to be overriden in the case that
// not all cards are "masonried" in one div.
CardsHandler.prototype.retrieveCardInfo = function() {
  var handler = this;
  $("#like-comment-panel").addClass("hidden");
  $("#deck-cards-panel").addClass("hidden");
  $("#" + handler.focusingCardId).css("z-index", "auto");
}

// card is a jquery obj
CardsHandler.prototype.handleFlip = function(cardObj) {
  var card = cards[cardObj.attr("id").split("_")[1]];
  flipCard(card);
}
