var noOngoingLoad = true;
$(document).ready(function() {
  $(".home-card").each(function() {
    dealWithHomeCard($(this));
  });

  $("#nav-explore-btn").addClass("nav-option-highlighted");

  $("#recommended-contents-wrapper").masonry({
    columnWidth: 270,
    gutter: 10,
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
    url: '/explore',
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

