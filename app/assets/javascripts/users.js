var cards = {};
$(document).ready(function() {
  $(document).on("click", "#flip-to-login-btn", function() {
    flip($("#login-form-card"));
  });

  $(document).on("click", "#flip-to-join-btn", function() {
    flip($("#login-form-card"));
  });

  $(document).on("click", "#nav-signup-btn", function() {
    if ($("#login-form-card").hasClass('flip')) {
      $("#login-form-card").removeClass('flip');
    }
  });

  $(document).on("click", "#nav-login-btn", function() {
    if (!$("#login-form-card").hasClass('flip')) {
      $("#login-form-card").addClass('flip');
    }
  });

  $(document).on("submit", "#signup-form-front form", function(e) {
    if (!validateSignUpForm()) {
      e.preventDefault();
    }
  });

  $(document).on("submit", "#login-form-back form", function(e) {
    if (!validateLogInForm()) {
      e.preventDefault();
    }
  });

  // when clicked on follow btn, ajax request follow
  $(document).on("click", ".follow-btn", function() {
    ajaxToggleFollowUser($(this).attr("data-userid"), !$(this).hasClass("followed"));
  });

  // when clicked on the favorite button, toggle favorite;
  // this is for the info panels.
  $(document).on("click", ".deck-favorite-btn", function() {
    var btn = $(this);
    ajaxToggleFavoriteDeck(btn.attr("data-deckid"), !btn.hasClass("favored"));
  });
});

// userId is the id of the user to be followed
function ajaxToggleFollowUser(userId, follow) {
  var action = "follow";
  if (!follow) {
    action = "unfollow";
  }
  $.ajax({
    type: "POST",
    url: "/users/" + userId + "/" + action,
    contentType: "script",
    success: function(data) {
    }
  });
}

// toggle favorite of a deck
function ajaxToggleFavoriteDeck(deckId, favorite) {
  var action = "favorite";  // follow deck
  if (!favorite) {
    action = "unfavorite";  // unfollow deck
  }
  $.ajax({
    type: "POST",
    url: "/decks/" + deckId + "/" + action,
    contentType: "script",
    success: function(data) {
    }
  });
}

function ajaxGrabUsersList(userId, type) {
    $.ajax({
	type: "GET",
	url: "/users/listings",
	data: { user_id: userId, type: type },
	contentType: "script",
	success: function(data) {
	}
    });
}

function validateLogInForm() {
    var valid = true;
    var msgs = [];
    if ($("#session_username").val().length <= 0) {
	msgs.push("please enter your username");
	valid = false;
    }
    if ($("#session_password").val().length <= 0) {
	msgs.push("please enter your password");
	valid = false;
    }

    if (msgs.length == 2) {
	addAlert("error", "Ooops. Please enter your username and password.", 2500);
    } else if (!valid) {
	// length is 1
	addAlert("error", msgs[0], 2500);
    }
    return valid;
}

function validateSignUpForm() {
    var valid = true;
    var msgs = [];
    var blank = 0;
    if ($("#user_username").val().length <= 0) {
	valid = false;
	blank++;
	msgs.push("username can't be empty");
    } else if ($("#user_username").val().length < 4) {
	valid = false;
	msgs.push("username must have at least 4 characters.");
    } else if (!validateUsername($("#user_username").val())) {
	valid = false;
	msgs.push("username can only have alphabetical characters and numbers");
    }
    if ($("#user_email").val().length <= 0) {
	valid = false;
	msgs.push("email can't be empty");
	blank++;
    } else if (!validateEmail($("#user_email").val())) {
	valid = false;
	msgs.push("email format is invalid");
    } else {
	if ($("#user_email_confirm").val().length <= 0) {
	    valid = false;
	    msgs.push("please confirm your email address");
	    blank++;
	} else if ($("#user_email_confirm").val() !== $("#user_email").val()) {
	    valid = false;
	    msgs.push("email and confirmation don't match");
	}
    }
    if ($("#user_password").val().length <= 0) {
	valid = false;
	msgs.push("password can't be empty");
	blank++;
    } else if ($("#user_password").val().length < 6) {
	valid = false;
	msgs.push("password must be at least 6 characters");
    }

    if (blank >= 2) {
	addAlert("error", "Looks like there are many blank fields. Please fill them up.", 2500);
    } else {
	if (msgs.length <= 3) {
	    var i = 0;
	    for (i = 0; i < msgs.length; i++) {
		addAlert("error", msgs[i], 2500);
	    }
	} else {
	    var i = 0;
	    for (i = 0; i < 3; i++) {
		addAlert("error", msgs[i], 2500);
	    }
	    addAlert("warning", "There are more errors. Fix the above ones first.", 2500);
	}
    }

    return valid;
}

function validateEmail(email) {
  var re = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
  return re.test(email);
}

function validateUsername(username) {
    var re = /^[A-Za-z0-9]{4,}$/;
    return re.test(username);
}

// assume email format is valid
function validateEduEmail(email) {
   return email.substring(email.lastIndexOf(".")) === ".edu";
}
