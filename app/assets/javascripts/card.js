// A card represents one flippable two sided card
// id - the id of the flipper
// side - the default side of the card, either "front" or "back"
//
// A card's html is structured like this:
// class= .flipper.home-card; id=card_#
//     class= .flipper-front.card-side; id=card_#_front_{type}
//     class= .flipper-back.card-side; id=card_#_back_{type}
//
// For text type side:
// class= .card-text; 
//     class= .card-text-title
//         <h1>
//     class= .card-text-body
//         <p>
// 
// For image type side:
// class= .card-img; 
//     class= .card_img_wrapper
//         <img>
//         class= .card-descp
//             <p>
//
// This class adjusts the size of the card according to
// the situation, for example, the card is focused.
function Card(id, side) {
  this.id = "card_" + id;
  
  // the front or back contents
  this.s = {
    "front": $("#"+this.id).find(".flipper-front.card-side"),
    "back": $("#"+this.id).find(".flipper-back.card-side")
  }

  this.contentType = {
    "front": this.s["front"].attr("id").split("_")[3],
    "back": this.s["back"].attr("id").split("_")[3],
  }

  // if spoiler added for a side, the side's true
  // height is updated here; a side without
  // spoiler may have undefined attributes here.
  this.trueHeight = {
    "front": undefined,
    "back": undefined
  };

  this.focused = false;
  this.currentSide = side;
  
  this.stdWidth = 220;
  this.stdMinHeight = 220;
  this.stdMaxHeight = 220;
}

Card.prototype.adjustCardHeight = function() {
  // if both sides are not image
  var card = this;

  // force the front and back to be both 220px height, regardless
  // of type
  $("#" + card.id).height(card.stdMaxHeight);
  card.s["front"].outerHeight(card.stdMaxHeight);
  card.s["back"].outerHeight(card.stdMaxHeight);
  
  // If either side has image, adjust the image to fit 220px height
  if (card.contentType["front"] === "img") {
    adjustImgSizeByHeight($("#" + card.s["front"].attr("id") + " .card-img .card-img-wrapper img"), card.stdMaxHeight);
  }
  if (card.contentType["back"] === "img") {
    adjustImgSizeByHeight($("#" + card.s["back"].attr("id") + " .card-img .card-img-wrapper img"), card.stdMaxHeight);
  }

  /*
  if (card.contentType["front"] !== "img" && card.contentType["back"] !== "img") {
    // if either side is video, limit the max height to 220
    if (card.contentType["front"] === "video" || card.contentType["back"] === "video") {
      card.s["back"].outerHeight(220);
      card.s["front"].outerHeight(220);
      $("#"+card.id).height(220);
    } else {
      var maxHeight = Math.max(card.s["back"].outerHeight(), card.s["front"].outerHeight());
      card.s["back"].outerHeight(maxHeight);
      card.s["front"].outerHeight(maxHeight);
      $("#"+card.id).height(maxHeight);
    }
  } else if (card.contentType["front"] === "img" && card.contentType["back"] === "img") {
    // if both sides are images, use 220px
    card.s["back"].outerHeight(220);
    card.s["front"].outerHeight(220);
    $("#"+card.id).height(220);
    adjustImgSizeByHeight($("#"+card.s["front"].attr("id")+" .card-img .card-img-wrapper img"), 220);
    adjustImgSizeByHeight($("#"+card.s["back"].attr("id")+" .card-img .card-img-wrapper img"), 220);
    return;
  } else {
    // if one side is image, set the height of the card to the height of the
    // other side, then adjust the image size to fit the height
    if (card.contentType["front"] === "img") {
      card.adjustImgSideSize("front", "back");
    } else {
      card.adjustImgSideSize("back", "front");
    }
  }
  */

  // if one side is text and overflows, add spoiler at the bottom of the card
  // detecting is done by addSpoilerIfTooLong()
  if (card.contentType["front"] === "text") {
    card.addSpoilerIfTooLong("front");
  }
  if (card.contentType["back"] === "text") {
    card.addSpoilerIfTooLong("back");
  }
}

Card.prototype.adjustImgSideSize = function(side, otherSide) {
  var height = $("#"+this.s[otherSide].attr("id")).outerHeight();
  $("#"+this.id).height(height);
  this.s[side].outerHeight(height);
  // adjust image size
  adjustImgSizeByHeight($("#"+this.s[side].attr("id")+" .card-img .card-img-wrapper img"), height);
}

// this is for text type side
Card.prototype.addSpoilerIfTooLong = function(side) {
  // 260 is the content height limit
  var height = $("#"+this.s[side].attr("id")+" .card-text").outerHeight();
  if (height > 260) {
    this.s[side].addClass("spoiler");
    this.trueHeight[side] = height + 30;
  }
}

Card.prototype.focus = function() {
  this.focused = true;
  $("#"+this.id).addClass("focused");

  // make the card longer if has spoiler
  if (this.s["front"].hasClass("spoiler")) {
    // set max-height to trueHeight + 30
    this.s["front"].css("cssText", "max-height:" + this.trueHeight["front"] + "px");
    this.s["front"].removeClass("spoiler");
  }

  if (this.s["back"].hasClass("spoiler")) {
    // set height to trueHeight + 10
    //this.s["back"].outerHeight(this.trueHeight["back"] + 30);
    this.s["back"].css("cssText", "max-height:" + this.trueHeight["back"] + "px");
    this.s["back"].removeClass("spoiler");
  }
}

Card.prototype.unfocus = function() {
  this.focused = false;
  $("#"+this.id).removeClass("focused");
  this.s["front"].css("max-height", "270px"); // 220 + 50
  this.s["back"].css("max-height", "270px");
  //this.s["front"].removeAttr("style");
  //this.s["back"].removeAttr("style");
  // if one side is text and overflows, add spoiler at the bottom of the card
  if (this.contentType["front"] === "text") {
    this.addSpoilerIfTooLong("front");
  }
  if (this.contentType["back"] === "text") {
    this.addSpoilerIfTooLong("back");
  }
}

Card.prototype.flip = function() {
  flip($("#"+this.id));
  if (this.currentSide === "front") {
    this.currentSide = "back";
  } else {
    this.currentSide = "front";
  }
}

Card.prototype.getTrueHeight = function(side) {
  if (this.trueHeight[side]) {
    return this.trueHeight[side];
  } else {
    // no true height. So it fits. Just return
    // the outerHeight of the side
    return this.s[side].outerHeight();
  }
}

Card.prototype.getPosition = function() {
  return $("#"+this.id).position();
}

// Update the front and back jquery objects
Card.prototype.updateFrontBackJQueryObjects = function() {
  // the front or back contents
  this.s = {
    "front": $("#"+this.id).find(".flipper-front.card-side"),
    "back": $("#"+this.id).find(".flipper-back.card-side")
  }  
}

// Given an image jquery object and a height, change the dimensions
// of the image based on that height, such that the new height will
// be equal to the given height, and the new width will be proportionally
// changed with respect to the given height.
function adjustImgSizeByHeight(imgObj, newHeight) {
  var origWidth = imgObj.outerWidth();
  var origHeight = imgObj.outerHeight();
  var newWidth = newHeight * origWidth/origHeight;
  imgObj.outerWidth(newWidth);
  imgObj.outerHeight(newHeight);
}

// card is a Card prototype object
function flipCard(card) {
  card.flip();

  // if the card is focused, we may need to adjust the position
  // of the like-comment panel
  if (card.focused) {
    var cardPosition = card.getPosition();
    var margin = 30;
    $("#like-comment-panel").animate({
      top: (cardPosition.top + card.getTrueHeight(card.currentSide) + margin) + "px",
    }, 300, function() {
      // show info
    });
  }
}

// Adjust the height of the given home-card jquery object.
// Also updates the global cards object
function dealWithHomeCard(homecard) {
  var id = homecard.attr("id").split("_")[1];
  if (!cards.hasOwnProperty(id)) {
    cards[id] = new Card(id, "front");
  } else {
    // need to update the front and back jQuery object for the card
    cards[id].updateFrontBackJQueryObjects();
  }
  cards[id].adjustCardHeight();
}
