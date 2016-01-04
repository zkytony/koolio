var noOngoingLoad = true;
$(document).ready(function() {
  $(document).on("click", "#add-card-btn", function() {
    $(".glass-overlay").css("display", "block");
    $("#editor-container-home").css("display", "block");
  });

  $(document).on("click", "#add-card-prompt", function() {
    $(".glass-overlay").css("display", "block");
    $("#editor-container-home").css("display", "block");
  });

  $(document).on("click", "#overlay-for-editor", function() {
    $("#overlay-for-editor").css("display", "none");
    $("#editor-container-home").css("display", "none");
  });

  $("#new_card").on("ajax:success", function(e, data, status, xhr) {
    // when new card is created, refresh the recommended content
    // by ajax query to user:show again
    grabRecommendContents(false);
  });

  $("#nav-home-btn").addClass("nav-option-highlighted");

  $(".home-card").each(function() {
    dealWithHomeCard($(this));
  });

  $("#recommended-contents-wrapper").masonry({
    columnWidth: 270,
    gutter: 10,
    itemSelector: '.home-card',
    transitionDuration: 0
  });

  // When scroll to nearly the bottom, grab more recommended contents
  var limit = 20;
  $(window).scroll(function() {
    if ($(document).height() - limit <= $(window).scrollTop() + $(window).height()) {
      if (noOngoingLoad) {
	grabRecommendContents(true);
      }
    }
  });

  var editor = new Editor("new_card");
  editor.init();

  var cardsHandler = new FlexCardsHandler("recommended-contents-wrapper", 30);
  cardsHandler.init();
});

// more is a boolean; true if it is grabbing more contents for scrolling
function grabRecommendContents(more) {
  noOngoingLoad = false;
  
  var card_ids = [];
  $(".home-card").each(function() {
    card_ids.push($(this).attr("id").split("_")[1]);
  });

  $.ajax({
    // send to current page (user show)
    type: 'GET',
    data: { more: more, card_ids: card_ids },
    dataType: 'script',
    success: function(data) {
      // return a script that will render the recommended contents html
      $(document).ready(function() {
	$("#recommended-contents-wrapper").masonry('reloadItems');
	$(".home-card").each(function() {
	  if (!$(this).hasClass("focused")) {
	    dealWithHomeCard($(this));
	  }
	});
	// This is how you reload with masonry
	$("#recommended-contents-wrapper").masonry();
      });
      noOngoingLoad = true;
    },
  });
}

