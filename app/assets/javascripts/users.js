$(document).ready(function() {

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
    dataType: 'script',
    success: function(data) {
      // return a script that will render the recommended contents html
    }
  });
}
