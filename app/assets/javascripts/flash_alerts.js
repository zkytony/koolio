$(document).ready(function() {
    // fade out flash alerts one by one after 4 seconds
    fadeOutAlerts(4000, 400);
});

// type can be error, warning, info, or success
// To have an alert show infinite amount of time, set wait to -1
function addAlert(type, message, wait, id="") {
    var htmlStr = "";
    var extraClass = "";
    if (wait == -1) {
	extraClass = "no-fade";
    }
    if (id.length > 0) {
	htmlStr = "<div id=\"" + id + "\"class=\"fl-alert alert-" + type + " " + extraClass + "\">" + message + "</div>";
    } else {
	htmlStr = "<div class=\"fl-alert alert-" + type + " " + extraClass + "\">" + message + "</div>";
    }
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
