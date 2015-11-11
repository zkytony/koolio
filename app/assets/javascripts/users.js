$(document).ready(function() {
  // grab recommend contents once page loaded
  grabRecommendContents();

  $("#flip-to-login-btn").click(function() {
    flip($("#login-form-card"));
  });

  $("#flip-to-join-btn").click(function() {
    flip($("#login-form-card"));
  });

  $("#nav-signup-btn").click(function() {
    if ($("#login-form-card").hasClass('flip')) {
      $("#login-form-card").removeClass('flip');
    }
  });

  $("#nav-login-btn").click(function() {
    if (!$("#login-form-card").hasClass('flip')) {
      $("#login-form-card").addClass('flip');
    }
  });

  $("#add-card-btn").click(function() {
    $(".glass-overlay").css("display", "block");
    $("#editor-container-home").css("display", "block");
  });

  $(".glass-overlay").click(function() {
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
});

function grabRecommendContents() {
  $.ajax({
    // send to current page (user show)
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      // The format of the returned json object should be
      // '0' (or other index):
      //     id:
      //     front_content:
      //     back_content:
      //     flips:
      //     created_at:
      //     updated_at:
      //     user_id;
      //     deck_id;
      //     hide:
      for (var i in data) {
	var content = data[i];
	if (content.hasOwnProperty("front_content")) {
	  // this indicates that content is card
	  buildCardHTML(content);
	}
      }
    }
  });
}

// Given a card with attributes like this:
//     id:
//     front_content:
//     back_content:
//     flips:
//     created_at:
//     updated_at:
//     user_id;
//     deck_id;
//     hide:
function buildCardHTML(card) {
  var frontContent = JSON.parse(card["front_content"]);
  var backContent = JSON.parse(card["back_content"]);
  
}

// Given frontContent, backContent, which have properties
//    type:
//    content:
// Constructs a javascript prototype object Card
function Card(frontContent, backContent) {
}
