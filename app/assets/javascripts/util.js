function UrlExists(url) {
    var http = new XMLHttpRequest();
    http.open('HEAD', url, false);
    http.send();
    return http.status!=404;
}

function GetFileTypeFromUrl(url) {
    // smart way to parse an url:
    var parser = document.createElement('a');
    parser.href = url;
    var chunks = parser.pathname.split("/");
    filename = chunks[chunks.length-1];
    if (filename.includes(".")) {
	var extension = filename.split('.').pop(); 
	extension = extension.split(/\#|\?/g)[0];
	return extension.toLowerCase();
    } else {
	return null;
    }
}

function isUrl(s) {
   var regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
   return regexp.test(s);
}

function SimpleExtToMime(ext) {
    switch(ext) {
	case "gif":
  	  return "image/gif";
	case "png":
	  return "image/png";
	case "jfif":
	case "jpe":
	case "jpeg":
	case "jpg":
	  return "image/jpeg";
	default:
	  return null;
    }
}

function SelectText(element) {
    // From Stackoverflow http://stackoverflow.com/questions/985272/selecting-text-in-an-element-akin-to-highlighting-with-your-mouse
    var doc = document
        , text = doc.getElementById(element)
        , range, selection
    ;    
    if (doc.body.createTextRange) {
        range = document.body.createTextRange();
        range.moveToElementText(text);
        range.select();
    } else if (window.getSelection) {
        selection = window.getSelection();        
        range = document.createRange();
        range.selectNodeContents(text);
        selection.removeAllRanges();
        selection.addRange(range);
    }
}
