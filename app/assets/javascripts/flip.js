$(document).ready(function() {
    $(".card").click(function() {
	flip($(this));
    });
});

function flip(jqueryObj) {
  if (!jqueryObj.hasClass('flip')) {
    jqueryObj.addClass('flip');
  } else {
    jqueryObj.removeClass('flip');
  }
}
