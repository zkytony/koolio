$(document).ready(function() {
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
	dealWithHomeCard($(this));
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

function grabRecommendContents() {
  $.ajax({
    // send to current page (user show)
    type: 'GET',    
    dataType: 'script',
    success: function(data) {
      // return a script that will render the recommended contents html
      $(document).ready(function() {
	$("#recommended-contents-wrapper").masonry('reloadItems');
	$(".home-card").each(function() {
	  dealWithHomeCard($(this));
	});
	// This is how you reload with masonry
	$("#recommended-contents-wrapper").masonry();
      });
    },
  });
}

