$(document).ready(function() {
    // fade out flash alerts one by one after 4 seconds
    fadeOutAlerts(4000, 400);
});

// type can be error, warning, or success
function addAlert(type, message, wait) {
    var htmlStr = "<div class=\"fl-alert alert-" + type + "\">" + message + "</div>";
    $(".fl-alerts").append(htmlStr);
    fadeOutAlerts(wait, 400);
}

function fadeOutAlerts(wait, speed) {
    setTimeout(function() {
	$(".fl-alert").each(function(index) {
	    if (!$(this).hasClass("no-fade")) {
		$(this).delay(50*index).fadeOut(speed, function() {
		    $(this).remove();
		});
	    }
	});
    }, wait );
}
