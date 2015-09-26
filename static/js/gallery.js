window.onload = initialize();


function initialize() {
    httpGetAsync("/getAllSketches", function(response) {
        var sketches = JSON.parse(response);
        var imgGrid = document.getElementById("imgGrid");
        for (var i = 0; i < sketches.length; i++) {
            var el = document.createElement("a");
            el.href = "dotsGenerator/" + sketches[i].id;
            el.className = "thumbnail";
            el.innerHTML = "<img src=" + sketches[i].thumbnail + ">";
	        imgGrid.appendChild(el);
        }
    })


}


function httpGetAsync(theUrl, callback) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
    xmlHttp.open("GET", theUrl, true); // true for asynchronous 
    xmlHttp.send(null);
}
