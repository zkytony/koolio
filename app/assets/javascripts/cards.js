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
    beforeSend: function() {
      // disable permalink and embed button
      $("#card_link_btn").addClass("disabled");
      $("#card_embed_btn").addClass("disabled");
    },
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

// Adjust the height of the given home-card jquery object.
// Also updates the global cards object
function dealWithHomeCard(homecard) {
  var id = homecard.attr("id").split("_")[1];
  if (!cards.hasOwnProperty(id)) {
    cards[id] = new Card(id, "front");
  } else {
    // need to update the front and back jQuery object for the card
    cards[id].updateFrontBackJQueryObjects();
  }
  cards[id].adjustCardHeight();
}
