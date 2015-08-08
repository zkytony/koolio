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
});

