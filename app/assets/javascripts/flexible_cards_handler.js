// Override the show, retrieve card info prototype for "all".
// Since each time period is a masonry subject.
// This type of card handler adjusts the location of displaying the 
// deck panel by calculating available rooms.
FlexCardsHandler.prototype = Object.create(CardsHandler.prototype);
function FlexCardsHandler(borderId, cardsGutter) {
  CardsHandler.call(this);
  this.borderId = borderId;
  this.cardsGutter = cardsGutter;
}

FlexCardsHandler.prototype.showCardInfo = function() {
  // Handle the case where it is currently displaying "all" cards.
  var handler = this;
  // show the panels, with quick animation
  // first place the panels at the same position
  // as the parent card, then do the slide
  var width = 220; // card width
  //var height = $("#" + handler.focusingCardId).outerHeight();
  var cardPosition = $("#" + handler.focusingCardId).position();
  var focusedCard = cards[handler.focusingCardRawId];
  focusedCard.focus();
  $("#like-comment-panel").removeClass("hidden");
  $("#deck-cards-panel").removeClass("hidden");
  // first align the comment panel with the card

  // if the deck panel is out of bound, reverse the deckPanelLeft
  // to show it on the other side
  var deckPanelLeft = (cardPosition.left + width + handler.cardsGutter);
  if (deckPanelLeft + width > $("#" + handler.borderId).outerWidth()) {
    deckPanelLeft = (cardPosition.left - width - handler.cardsGutter);
  }
  handler.showCardInfoSetup(
    { 
      top: (cardPosition.top + focusedCard.getTrueHeight(focusedCard.currentSide) + handler.cardsGutter) + "px",
      left: cardPosition.left + "px",
      opacity: 0      
    }, // like panel initial
    {
      top: cardPosition.top + "px",
      left: deckPanelLeft,
      opacity: 0
    } // deck panel initial
  );

  handler.showCardInfoAnimate(
    { 
      opacity: 1
    }, // like panel initial
    {
      opacity: 1
    } // deck panel initial
  );
}
