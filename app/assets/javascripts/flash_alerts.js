$(document).ready(function() {
    // fade out flash alerts one by one after 4 seconds
    setTimeout(function() {
	$(".fl-alert").each(function(index) {
	    $(this).delay(50*index).fadeOut();
	});
    }, 4000 );
});
