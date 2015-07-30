$(document).ready ->
    $("#nav-pic").click ->
        if $("#profile-pic-dropdown").hasClass("hidden")
            $("#profile-pic-dropdown").removeClass("hidden")
        else
            $("#profile-pic-dropdown").addClass("hidden")
    $(document).on "click", (event) ->
        if event.target.id != "nav-pic" and event.target.id != "nav-pic-img"
            $("#profile-pic-dropdown").addClass("hidden")
    return
