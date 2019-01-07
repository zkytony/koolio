var cards = {};
$(document).ready(function() {
    $(".home-card").each(function() {
	dealWithHomeCard($(this));
    });
    
    var cardsHandler = new FlexCardsHandler("embedded-card-wrapper", 30);
    cardsHandler.init();
})
