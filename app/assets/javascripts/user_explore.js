var noOngoingLoad = true;
$(document).ready(function() {
  $(".home-card").each(function() {
    dealWithHomeCard($(this));
  });

  $("#nav-explore-btn").addClass("nav-option-highlighted");

  $("#recommended-contents-wrapper").masonry({
    columnWidth: 240,
    gutter: 10,
    itemSelector: '.home-card'
    transitionDuration: 0
  });

  // When scroll to nearly the bottom, grab more recommended contents
  var limit = 20;
  $(window).scroll(function() {
    if ($(document).height() - limit <= $(window).scrollTop() + $(window).height()) {
      if (noOngoingLoad) {
	var id = $(".catg-item.selected").attr("id").split("_")[1];
	grabRecommendContents(getContentType(), getSortMethod(), id, true);
      }
    }
  });

  // When clicked on a category, ajax grab cards in that category
  $(document).on("click", ".catg-item", function() {
    var id = $(this).attr("id").split("_")[1];
    var oldId = $(".catg-item.selected").attr("id").split("_")[1];
    $("#catg_" + oldId).removeClass("selected");
    $("#catg_" + id).addClass("selected");
    // removed all current cards
    $("#recommended-contents-wrapper").html("");
    grabRecommendContents(getContentType(), getSortMethod(), id, false);
  });

  // When clicked on sort method, ajax grab cards sorted in that way
  $(document).on("click", ".sort-item", function() {
    if ($(this).hasClass("selected")) {
      return;
    }
    $(".sort-item").removeClass("selected");
    $(this).addClass("selected");
    var id = $(".catg-item.selected").attr("id").split("_")[1];
    grabRecommendContents(getContentType(), getSortMethod(), id, false);
  });

  $(document).on("click", ".type-item", function() {
    if ($(this).hasClass("selected")) {
      return;
    }
    $(".type-item").removeClass("selected");
    $(this).addClass("selected");
    var id = $(".catg-item.selected").attr("id").split("_")[1];
    grabRecommendContents(getContentType(), getSortMethod(), id, false);
  });

  var editor = new Editor("new_card");
  editor.init();

  var cardsHandler = new FlexCardsHandler("recommended-contents-wrapper", 30);
  cardsHandler.init();
});

function getSortMethod() {
  if ($("#sort-time").hasClass("selected")) {
    return "time";
  } else {
    return "popular";
  }
}

function getContentType() {
  if ($("#see-decks").hasClass("selected")) {
    return "deck";
  } else {
    return "card";
  }
}

// more is a boolean; true if it is grabbing more contents for scrolling
function grabRecommendContents(contentType, sortMethod, catgId, more) {
  noOngoingLoad = false;
  
  var content_ids = [];
  if (contentType === "card") {
    $(".home-card").each(function() {
      content_ids.push($(this).attr("id").split("_")[1]);
    });
  } else {
    $(".one-deck").each(function() {
      content_ids.push($(this).attr("id").split("_")[1]);
    });    
  }

  $.ajax({
    // send to current page (user show)
    type: 'GET',
    url: '/explore',
    data: { more: more, content_ids: content_ids, category_id: catgId, sort: sortMethod, type: contentType },
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
    error: function(jqXHR, textStatus, errorThrown) {
      console.log(textStatus, errorThrown);
    }
  });
}

