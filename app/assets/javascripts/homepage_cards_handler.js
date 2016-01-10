/* Event handlers for cards at home page */
function CardsHandler() {
  // focusing card is should have the format "card_#{id}"
  this.focusingCardId = undefined; // html element id
  this.focusingCardRawId = undefined; // card_id
}

CardsHandler.prototype.init = function() {
  var handler = this;
  // flip when clicked home; support mobile
  $(document).on("click tap", ".home-card", function(e) {
    e.preventDefault();
    if (!$(e.target).hasClass("no-flip")) {
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

  // quick like btn fde in
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
  }, ".quick-card-like-btn-wrapper");
  // show dark-overlay when hit info-toggle
  // change the z-index of the current card to
  // 5, which is greater than the overlay z-index(3),
  // and the z-index of info panels (4).
  // When clicked somewhere else, hide the dark
  // overlay, and change the z-index of the card back
  // to auto. When toggling, checks if this .info-toggle
  // element has .toggle-off class. 
  $(document).on("click tap", ".info-toggle", function(e) {
    // only do the following if the dark-overlay is hidden
    if ($("#overlay-for-focus-card").hasClass("hidden")) {
      $("#overlay-for-focus-card").removeClass("hidden");
      var focusHomeCard = $(this).parents(".home-card");
      handler.handleFocusOn(focusHomeCard);
    } else {
      handler.handleFocusOff();
    }
  });
  $(document).on("click tap", "#overlay-for-focus-card", function(e) {
    e.preventDefault();
    handler.handleFocusOff();
  });
  // When clicked the card like button, send ajax request
  // to toggle like of this card, if and only if the btn is
  // not disabled
  $(document).on("click", "#like-card-btn", function() {
    if (!$("#like-card-btn").hasClass("disabled")) {
      var liked = $("#like-card-btn").hasClass("liked");
      ajaxLikeCard(liked, handler.focusingCardRawId);
    }
  });

  // this is another button to toggle like card
  $(document).on("click", ".quick-card-like-btn", function() {
    var liked = $(this).hasClass("liked");
    var cardId = $(this).attr("id").split("_")[2];
    ajaxLikeCard(liked, cardId);
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
  var width = 220;
  var margin = 30;
  //var height = $("#" + handler.focusingCardId).outerHeight();
  var cardPosition = $("#" + handler.focusingCardId).position();
  var focusedCard = cards[handler.focusingCardRawId];
  focusedCard.focus();
  var deckPanelLeft = (cardPosition.left + width + margin);
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
    }, // like panel final
    {
      opacity: 1
    } // deck panel finall
  );
}

CardsHandler.prototype.showCardInfoSetup = function(likePanelIniCSS, deckPanelIniCSS) {
  $("#like-comment-panel").removeClass("hidden");
  $("#deck-cards-panel").removeClass("hidden");  
  $("#like-comment-panel").css(likePanelIniCSS);
  $("#deck-cards-panel").css(deckPanelIniCSS);
}

CardsHandler.prototype.showCardInfoAnimate = function(likePanelFinalCSS, deckPanelFinalCSS) {
  $("#like-comment-panel").animate(likePanelFinalCSS, 150, function() {});
  $("#deck-cards-panel").animate(deckPanelFinalCSS, 150, function() {});  
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

CardsHandler.prototype.handleFocusOn = function(focusHomeCard) {
    var handler = this;
    focusHomeCard.css("z-index", "5");
    handler.focusingCardId = focusHomeCard.attr("id");
    handler.focusingCardRawId = handler.focusingCardId.split("_")[1];
    
    // Reset the info panels
    handler.resetLikeCommentsPanel();
    handler.resetDeckCardsPanel();
    // grab info first
    grabCardInfo(handler.focusingCardRawId);
    handler.showCardInfo();
}

CardsHandler.prototype.handleFocusOff = function() {
  var handler = this;
  $("#overlay-for-focus-card").addClass("hidden");
  $("#" + handler.focusingCardId).css("z-index", "auto");
  $("#like-comment-panel").addClass("hidden");
  $("#deck-cards-panel").addClass("hidden");
  var focusedCard = cards[handler.focusingCardRawId];
  focusedCard.s[focusedCard.currentSide].addClass("notransition");
  focusedCard.unfocus();
  focusedCard.s[focusedCard.currentSide].removeClass("notransition");
}
