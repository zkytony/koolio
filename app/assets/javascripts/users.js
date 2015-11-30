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
  this.focusingCardId = undefined;
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
      }, 200, function() {
	// ajax grab card info, if not already done
      });
      $("#deck-cards-panel").animate({
	left: (cardPosition.left + width + margin) + "px"
      }, 200, function() {
	// ajax grab deck cards, if not already done
      });
    } else {
      var cardPosition = $("#" + handler.focusingCardId).position();
      $("#like-comment-panel").animate({
	top: cardPosition.top + "px",
      }, 200, function() {
	$("#like-comment-panel").addClass("hidden");
      });
      $("#deck-cards-panel").animate({
	left: cardPosition.left + "px"
      }, 200, function() {
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
}
