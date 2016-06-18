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
