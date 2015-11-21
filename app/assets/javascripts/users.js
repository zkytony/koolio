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

  // flip when clicked home card
  $("#recommended-contents-wrapper").on('click', '.home-card', function() {
    flip($(this));
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
