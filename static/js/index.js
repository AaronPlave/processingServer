window.onload = function() {
    var submit = document.getElementById("gen-submit");
    submit.addEventListener("click", function(evt) {
        evt.preventDefault();


        // gather variables
        var options = {
            "dotsPerRow": eValue("dotsPerRow"),
            "dotRadius": eValue("dotRadius"),
            "dotDist": eValue("dotDist"),
            "numIters": eValue("numIters"),
            "dotRadiusRandomize": radioCheckBool(g("dotRadiusRandomize")),
            "dotRadiusMin": eValue("dotRadiusMin"),
            "dotRadiusMax": eValue("dotRadiusMax"),
            "dotCenterRandomize": radioCheckBool(g("dotCenterRandomize")),
            "dotOffsetMax": eValue("dotOffsetMax"),
            "fill": radioCheckBool(g("fill")),
            "stroke": radioCheckBool(g("stroke")),
            "strokeWeight": eValue("strokeWeight"),
        }
        var params = "";
        for (i in options) {
            params += i.toString() + "=" + options[i] + "&";
        }
        var params = params.slice(0, -1);

        // send http request
        var http = new XMLHttpRequest();
        var url = "dotsV2/submit";

        http.open("GET", url + "?" + params, true);
        http.onreadystatechange = function() {
            if (!(http.readyState == 4 && http.status == 200)) {
                var imgPath = JSON.parse(http.responseText).img;
            	document.getElementById("gen-image").src=imgPath;
            }
        }
        http.send(null);
    })
}

function eValue(id) {
    return document.getElementsByName(id)[0].value;
}

function g(name) {
    return document.getElementsByName(name);
}

function radioCheckBool(els) {
    if (els[0].value == "True") {
        return els[0].checked;
    } else {
        return els[1].checked;
    }
}
