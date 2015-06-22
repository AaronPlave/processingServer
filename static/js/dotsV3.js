function post(url, data, callback) {
    // assumes data is a json
    var async = true;
    var request = new XMLHttpRequest();

    request.onload = function() {
        callback(request);
    }

    request.open("POST", url, async);
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    request.send(data);
    // http.onreadystatechange = function() {
    //     if (!(http.readyState == 4 && http.status == 200)) {
    //         var imgPath = JSON.parse(http.responseText).img;
    //         document.getElementById("gen-image").src = imgPath;
    //     }
    // }
}

function postCallback(request) {
    console.log(request.status, request.responseText);
    var shareUrl = window.location.host + "/dotsV3/" + request.responseText;
    document.getElementById("shareUrl").value = shareUrl;
}

window.onresize = function() {
    pHandler.resizeImg();
}

window.onload = function() {
    initialize();
}

var pHandler;
var _opts;
var gui;
var folders = [];
var mouseTimer;

function initialize() {
    var canvasHolder = document.getElementById("canvasHolder");
    var canvasRef = document.createElement('canvas');
    canvasRef.id = "dotsSketch"
    var p = Processing.loadSketchFromSources(canvasRef, ['../static/dots3/dots3.pde']);
    canvasHolder.appendChild(canvasRef);

    // wait for sketch to load to assign handler
    var _timer = 0,
        _timeout = 3000,
        _mem = setInterval(function() {
            pHandler = Processing.getInstanceById("dotsSketch");
            if (pHandler) {
                console.log("SKETCH HAS LOADED");
                clearInterval(_mem);
                initGui();
            } else {
                _timer += 10;
                if (_timer > _timeout) {
                    console.log("FAILED TO LOAD SKETCH");
                    clearInterval(_mem);
                }
            }
        }, 10);
}

function initGui() {
    // Initialize save button
    var saveEl = document.getElementById("saveImg");
    saveEl.addEventListener("click", function(evt) {
        var image = document.getElementsByTagName("canvas")[0].toDataURL();
        window.open(image, '_blank');
    })
    var image = document.getElementsByTagName("canvas")[0].toDataURL();

    // Initialize gui
    var UIOpts = function() {
        var pOpt = pHandler.getUiOpt();
        this.U_DRAW = pOpt.U_DRAW;
        this.U_BG_COLOR = pHandler.colorToRGB(pOpt.U_BG_COLOR);
        this.U_DOTS_PER_ROW = pOpt.U_DOTS_PER_ROW;
        this.U_DOT_DIST = pOpt.U_DOT_DIST;
        this.U_DOT_STROKE = pOpt.U_DOT_STROKE;
        this.U_DOT_STROKE_WEIGHT = pOpt.U_DOT_STROKE_WEIGHT;
        this.U_DOT_STROKE_WEIGHT_MIN = pOpt.U_DOT_STROKE_WEIGHT_MIN;
        this.U_DOT_STROKE_WEIGHT_MAX = pOpt.U_DOT_STROKE_WEIGHT_MAX;
        this.U_DOT_STROKE_RANDOMIZE = pOpt.U_DOT_STROKE_RANDOMIZE
        this.U_DOT_SINGLE_STROKE_COLOR = pHandler.colorToRGB(pOpt.U_DOT_SINGLE_STROKE_COLOR);
        this.U_DOT_FILL = pOpt.U_DOT_FILL;
        this.U_DOT_SINGLE_FILL_COLOR = pHandler.colorToRGB(pOpt.U_DOT_SINGLE_FILL_COLOR);
        this.U_DOT_FILL_THEME = pOpt.U_DOT_FILL_THEME;
        this.U_DOT_OFFSET_MAX = pOpt.U_DOT_OFFSET_MAX;
        this.U_DOT_RADIUS = pOpt.U_DOT_RADIUS;
        this.U_DOT_RADIUS_RANDOMIZE = pOpt.U_DOT_RADIUS_RANDOMIZE;
        this.U_DOT_RADIUS_MIN = pOpt.U_DOT_RADIUS_MIN;
        this.U_DOT_RADIUS_MAX = pOpt.U_DOT_RADIUS_MAX;
    }
    _opts = new UIOpts();
    gui = new dat.GUI();

    var vDraw = gui.add(_opts, 'U_DRAW').name("Animate");
    vDraw.onChange(function(value) {
        pHandler.getUiOpt().U_DRAW = value;
    });

    // Create folder and options

    // BACKGROUND
    var fBG = gui.addFolder('Background');
    folders.push(fBG);
    var cBG = fBG.addColor(_opts, 'U_BG_COLOR').name("Color");
    cBG.onChange(function(value) {
        if (typeof(value) === "string") {
            pHandler.setBG(hexToRgb(value));
        } else {
            pHandler.setBG(value);
        }
    });

    // LAYOUT
    var fLayout = gui.addFolder('Layout');
    folders.push(fLayout);
    var cDotsPerRow = fLayout.add(_opts, 'U_DOTS_PER_ROW', 0, 80).step(1).name("Dots Per Row");
    cDotsPerRow.onChange(function(value) {
        pHandler.setDotsPerRow(value);
    });
    var cDotDist = fLayout.add(_opts, 'U_DOT_DIST', 0, 100).step(1).name("Dot Spacing");
    cDotDist.onChange(function(value) {
        pHandler.setDotDist(value);
    });

    // FILL
    var fFill = gui.addFolder('Fill');
    folders.push(fFill);
    var cFill = fFill.add(_opts, 'U_DOT_FILL').name("Enabled");
    cFill.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_FILL = value;
    });
    var cFillSingleColor = fFill.addColor(_opts, 'U_DOT_SINGLE_FILL_COLOR').name("Single Color");
    cFillSingleColor.onChange(function(value) {
        if (typeof(value) === "string") {
            pHandler.setSingleFillColor(hexToRgb(value));
        } else {
            pHandler.setSingleFillColor(value);
        }
    });
    var cFillTheme = fFill.add(_opts, 'U_DOT_FILL_THEME').name("Enable Theme");
    cFillTheme.onChange(function(value) {
        pHandler.setTheme(value);
    });

    // STROKE
    var fStroke = gui.addFolder('Stroke');
    folders.push(fStroke);
    var cStroke = fStroke.add(_opts, 'U_DOT_STROKE').name("Enable");
    cStroke.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_STROKE = value;
    });
    var cStrokeWgt = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT', 0.05, 30).name("Weight");
    cStrokeWgt.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_STROKE_WEIGHT = value;
    });
    var cStrokeColor = fStroke.addColor(_opts, 'U_DOT_SINGLE_STROKE_COLOR').name("Color");;
    cStrokeColor.onChange(function(value) {
        if (typeof(value) === "string") {
            pHandler.setStrokeColor(hexToRgb(value));
        } else {
            pHandler.setStrokeColor(value);
        }
    });
    var cStrokeRandomize = fStroke.add(_opts, 'U_DOT_STROKE_RANDOMIZE', 0, 30).name("Random Stroke");
    cStrokeRandomize.onChange(function(value) {
        pHandler.setStrokeRandomize(value);
    });
    var cStrokeWgtMin = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT_MIN', 0.05, 30).name("Random Min");
    cStrokeWgtMin.onChange(function(value) {
        pHandler.setStrokeWgtMin(value);
    });
    var cStrokeWgtMax = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT_MAX', 0.05, 30).name("Random Max");
    cStrokeWgtMax.onChange(function(value) {
        pHandler.setStrokeWgtMax(value);
    });

    // OFFSET
    var fOffset = gui.addFolder('Center Offset');
    folders.push(fOffset);
    var cOffset = fOffset.add(_opts, 'U_DOT_OFFSET_MAX', 0, 100).name("Max Offset");
    cOffset.onChange(function(value) {
        pHandler.setOffset(value);
    })

    // RADIUS
    var fRadius = gui.addFolder('Radius');
    folders.push(fRadius);
    var cRadius = fRadius.add(_opts, 'U_DOT_RADIUS', 0, 100).name("Radius Size");
    cRadius.onChange(function(value) {
        pHandler.setRadius(value);
    })
    var cRadiusRandomize = fRadius.add(_opts, 'U_DOT_RADIUS_RANDOMIZE').name("Random Radius");
    cRadiusRandomize.onChange(function(value) {
        pHandler.setRadiusRandomize(value);
    })
    var cRadiusMin = fRadius.add(_opts, 'U_DOT_RADIUS_MIN', 0, 200).name("Random Min");
    cRadiusMin.onChange(function(value) {
        pHandler.setRadiusMin(value);
    })
    var cRadiusMax = fRadius.add(_opts, 'U_DOT_RADIUS_MAX', 0, 200).name("Random Max");;
    cRadiusMax.onChange(function(value) {
        pHandler.setRadiusMax(value);
    })

    // Default open folders
    fLayout.open();
    fBG.open();
    fFill.open();
    fStroke.open();
    fOffset.open();
    fRadius.open();

    // Init export and load buttons
    var loadButton = document.getElementById("loadJSON");
    loadButton.addEventListener("click", function(evt) {
        var textArea = document.getElementById("inputArea");
        loadOptsFromJSON(JSON.parse(textArea.value));
        resetControls();

    })

    var exportButton = document.getElementById("exportJSON");
    exportButton.addEventListener("click", function(evt) {
        var currOpts = optsToJSON();
        var textArea = document.getElementById("inputArea");
        textArea.value = currOpts;
    })

    // Initialize share button
    var shareEl = document.getElementById("shareButton");
    shareEl.addEventListener("click", function(evt) {
        post("/dotsV3/share", optsToJSON(), postCallback);
    })

    // Check for shared opts
    if (sharedOpts) {
        var jsonString = sharedOpts.replace(new RegExp('&#34;', 'g'), '"');
        loadOptsFromJSON(JSON.parse(jsonString).data);
        resetControls();
        // Call resize to fit whatever shared sketch is to current window
        pHandler.resizeImg();
    }

}

function resetControls() {
    // update the controls local vars 
    var pOpt = pHandler.getUiOpt();
    _opts.U_DRAW = pOpt.U_DRAW;
    _opts.U_BG_COLOR = pHandler.colorToRGB(pOpt.U_BG_COLOR);
    _opts.U_DOTS_PER_ROW = pOpt.U_DOTS_PER_ROW;
    _opts.U_DOT_DIST = pOpt.U_DOT_DIST;
    _opts.U_DOT_STROKE = pOpt.U_DOT_STROKE;
    _opts.U_DOT_STROKE_WEIGHT = pOpt.U_DOT_STROKE_WEIGHT;
    _opts.U_DOT_STROKE_WEIGHT_MIN = pOpt.U_DOT_STROKE_WEIGHT_MIN;
    _opts.U_DOT_STROKE_WEIGHT_MAX = pOpt.U_DOT_STROKE_WEIGHT_MAX;
    _opts.U_DOT_STROKE_RANDOMIZE = pOpt.U_DOT_STROKE_RANDOMIZE
    _opts.U_DOT_SINGLE_STROKE_COLOR = pHandler.colorToRGB(pOpt.U_DOT_SINGLE_STROKE_COLOR);
    _opts.U_DOT_FILL = pOpt.U_DOT_FILL;
    _opts.U_DOT_SINGLE_FILL_COLOR = pHandler.colorToRGB(pOpt.U_DOT_SINGLE_FILL_COLOR);
    _opts.U_DOT_FILL_THEME = pOpt.U_DOT_FILL_THEME;
    _opts.U_DOT_OFFSET_MAX = pOpt.U_DOT_OFFSET_MAX;
    _opts.U_DOT_RADIUS = pOpt.U_DOT_RADIUS;
    _opts.U_DOT_RADIUS_RANDOMIZE = pOpt.U_DOT_RADIUS_RANDOMIZE;
    _opts.U_DOT_RADIUS_MIN = pOpt.U_DOT_RADIUS_MIN;
    _opts.U_DOT_RADIUS_MAX = pOpt.U_DOT_RADIUS_MAX;

    // update the gui
    for (var i = 0; i < folders.length; i++) {
        var fc = folders[i].__controllers;
        for (var j = 0; j < fc.length; j++) {
            fc[j].updateDisplay();
        }
    }
}

var colorVars = ["U_BG_COLOR", "U_DOT_SINGLE_STROKE_COLOR", "U_DOT_SINGLE_FILL_COLOR"];

function optsToJSON() {
    var pOpts = pHandler.getUiOpt();
    var keys = Object.keys(pOpts);
    var newObj = {};
    for (var i = 0; i < keys.length; i++) {
        if (keys[i] === "$self") {
            continue;
        } else {
            var newVal = pOpts[keys[i]];
            if (colorVars.indexOf(keys[i]) != -1) {
                newVal = pHandler.colorToRGB(newVal);
            }
            newObj[keys[i]] = newVal;
        }
    }
    return JSON.stringify(newObj);
}

function loadOptsFromJSON(json) {
    if (json === "") {
        console.log("BAD JSON");
        return;
    }
    // var newOpt = JSON.parse(json);
    pHandler.setUiOpt(json);
}

function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? [parseInt(result[1], 16), parseInt(result[2], 16), parseInt(result[3], 16)] : null;
}

function enableFullscreen() {
    document.body.className = "fullscreen";
    document.getElementById("generatorContainer").style.display = "none";
    document.getElementsByClassName("dg main a")[0].style.display = "none";    
}

window.addEventListener("mousemove",function(){
    document.body.className = "inherit";
    document.getElementById("generatorContainer").style.display = "inherit";
    document.getElementsByClassName("dg main a")[0].style.display = "inherit";
    clearTimeout(mouseTimer);
    mouseTimer=setTimeout(enableFullscreen,3000);
});