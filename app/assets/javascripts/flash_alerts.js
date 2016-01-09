$(document).ready(function() {
    // fade out flash alerts one by one after 4 seconds
    setTimeout(function() {
	$(".fl-alert").each(function(index) {
	    if (!$(this).hasClass("no-fade")) {
		$(this).delay(50*index).fadeOut();
	    }
	});
    }, 4000 );
});
