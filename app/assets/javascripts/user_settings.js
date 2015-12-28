$(document).ready(function() {
    $("#setting-items-wrapper").masonry({
	columnWidth: 200,
	gutter: 10,
	itemSelector: ".setting-item",
    });

    // when clicked on "change" button, flip the setting-item
    $(document).on("click", ".setting-action-btn", function() {
	// id is of the form change-XXX-btn
	var settingFor = $(this).attr("id").split("-")[1];
	flip($("#" + settingFor + "-setting"));
    });

    // AJAX submit the form
    $(document).on("click", "#setting-confirm-btn", function() {
	var userId = $(".user_setting_id").attr("id").split("_")[1];
	data = grabFormData();
	ajaxUpdateUser(data, userId);
    });
})

// grab the user update form data
function grabFormData() {
    var data = {};
    data["username"] = $("#user_name").val();
    data["email"] = $("#user_email").val();
    data["password"] = $("#user_password").val();
    data["first_name"] = $("#user_first_name").val();
    data["last_name"] = $("#user_last_name").val();
    data["gender"] = getGender();
    if ($("#dob-month").val() && $("#dob-day").val() && $("#dob-year").val()) {
	data["birthday"] = $("#dob-month").val() + "/" + $("#dob-day").val() + "/" + $("#dob-year").val();
    } else {
	data["birthday"] = "";
    }
    alert(data["password"]);
    return data;
}

function ajaxUpdateUser(data, userId) {
    console.log(data);
    $.ajax({
	type: "PATCH",
	url: "/users/" + userId,
	data: { new_attrs: data },
	dataType: "script",
	success: function(output) {
	    alert(output);
	}
    });
}

// return empty string if neither one is chosen
function getGender() {
    if ($("#user_gender_male").is(':checked')) {
	return "male";
    } else if ($("#user_gender_female").is(':checked')) {
	return "female";
    }
    return "";
}
