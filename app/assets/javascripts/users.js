var cards = {};
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
});


// homeCard: individual instance of $(".home-card")
function adjustCardHeight(homeCard) {
  var back = homeCard.find(".flipper-back.card-side");
  var front = homeCard.find(".flipper-front.card-side");

  var maxHeight = Math.max(back.outerHeight(), front.outerHeight());
  back.outerHeight(maxHeight);
  front.outerHeight(maxHeight);
  homeCard.height(maxHeight);
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

// AJAX request to increment/decrement the number of likes for a
// comment given its id.
function ajaxLikeComment(liked, commentId) {
  var type = "POST";
  var action = "like";
  if (liked) {
    // should delete
    type = "DELETE";
    action = "unlike";
  }
  $.ajax({
    type: type,
    url: '/comments/' + commentId + '/' + action,
    dataType: 'script', // get back script
    success: function(output) {
    }
  });
}

// card is a Card prototype object
function flipCard(card) {
  card.flip();

  // if the card is focused, we may need to adjust the position
  // of the like-comment panel
  if (card.focused) {
    var cardPosition = card.getPosition();
    var margin = 30;
    $("#like-comment-panel").animate({
      top: (cardPosition.top + card.getTrueHeight(card.currentSide) + margin) + "px",
    }, 300, function() {
      // show info
    });
  }

}

// Adjust the height of the given home-card jquery object.
// Also updates the global cards object
function dealWithHomeCard(homecard) {
  var id = homecard.attr("id");
  if (!cards.hasOwnProperty(id)) {
    cards[id] = new Card(id, "front");
  } else {
    // need to update the front and back jQuery object for the card
    cards[id].updateFrontBackJQueryObjects();
  }
  cards[id].adjustCardHeight();
}

