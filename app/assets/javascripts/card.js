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
  this.id = id;
  
  // the front or back contents
  this.s = {
    "front": $("#"+id).find(".flipper-front.card-side"),
    "back": $("#"+id).find(".flipper-back.card-side")
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
}

Card.prototype.adjustCardHeight = function() {
  // if both sides are not image are image, then just go the usual way
  if (this.contentType["front"] !== "img" && this.contentType["back"] !== "img") {
    var maxHeight = Math.max(this.s["back"].outerHeight(), this.s["front"].outerHeight());
    this.s["back"].outerHeight(maxHeight);
    this.s["front"].outerHeight(maxHeight);
    $("#"+this.id).height(maxHeight);
  } else if (this.contentType["front"] === "img" && this.contentType["back"] === "img") {
    // if both sides are images, use 250px
    this.s["back"].outerHeight(250);
    this.s["front"].outerHeight(250);
    $("#"+this.id).height(250);
    adjustImgSizeByHeight($("#"+this.s["front"].attr("id")+" .card-img .card-img-wrapper img"), 250);
    adjustImgSizeByHeight($("#"+this.s["back"].attr("id")+" .card-img .card-img-wrapper img"), 250);
    return;
  } else {
    // if one side is image, set the height of the card to the height of the
    // other side, then adjust the image size to fit the height
    if (this.contentType["front"] === "img") {
      this.adjustImgSideSize("front", "back");
    } else {
      this.adjustImgSideSize("back", "front");
    }
  }

  // if one side is text and overflows, add spoiler at the bottom of the card
  if (this.contentType["front"] === "text") {
    this.addSpoilerIfTooLong("front");
  }
  if (this.contentType["back"] === "text") {
    this.addSpoilerIfTooLong("back");
  }
}

Card.prototype.adjustImgSideSize = function(side, otherSide) {
  var height = this.s[otherSide].outerHeight();
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
  this.s["front"].css("cssText", "max-height: 300px");
  this.s["back"].css("cssText", "max-height: 300px");
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

function adjustImgSizeByHeight(imgObj, newHeight) {
  var origWidth = imgObj.outerWidth();
  var origHeight = imgObj.outerHeight();
  var newWidth = newHeight * origWidth/origHeight;
  imgObj.outerWidth(newWidth);
  imgObj.outerHeight(newHeight);
}
