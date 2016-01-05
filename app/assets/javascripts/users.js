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

  // when clicked on follow btn, ajax request follow
  $(document).on("click", ".follow-btn", function() {
    ajaxToggleFollowUser($(this).attr("data-userid"), !$(this).hasClass("followed"));
  });

  // when clicked on the favorite button, toggle favorite;
  // this is for the info panels.
  $(document).on("click", ".deck-favorite-btn", function() {
    var btn = $(this);
    ajaxToggleFavoriteDeck(btn.attr("data-deckid"), !btn.hasClass("favored"));
  });
});

// userId is the id of the user to be followed
function ajaxToggleFollowUser(userId, follow) {
  var action = "follow";
  if (!follow) {
    action = "unfollow";
  }
  $.ajax({
    type: "POST",
    url: "/users/" + userId + "/" + action,
    contentType: "script",
    success: function(data) {
    }
  });
}

// toggle favorite of a deck
function ajaxToggleFavoriteDeck(deckId, favorite) {
  var action = "favorite";
  if (!favorite) {
    action = "unfavorite";
  }
  $.ajax({
    type: "POST",
    url: "/decks/" + deckId + "/" + action,
    contentType: "script",
    success: function(data) {
    }
  });
}
