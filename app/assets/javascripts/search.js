var cards = {};

$(document).ready(function() {
    $(".home-card").each(function() {
	dealWithHomeCard($(this));
    });

    $("#search-results-container").masonry({
	columnWidth: 270,
	gutter: 10,
	itemSelector: ".search-result-item",
	transitionDuration: 0
    });

    var cardsHandler = new FlexCardsHandler("search-results-container", 30);
    cardsHandler.init();
});
