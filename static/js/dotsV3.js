function post(url, data, callback) {
    // assumes data is a json
    var async = true;
    var request = new XMLHttpRequest();

    request.onload = function() {
        callback(request);
    }

    request.open("POST",url,async);
    request.setRequestHeader("Content-Type","application/json;charset=UTF-8");
    request.send(data);
    // http.onreadystatechange = function() {
    //     if (!(http.readyState == 4 && http.status == 200)) {
    //         var imgPath = JSON.parse(http.responseText).img;
    //         document.getElementById("gen-image").src = imgPath;
    //     }
    // }
}

function postCallback(request) {
    console.log(request.status,request.responseText);
    var shareUrl = window.location.host + "/dotsV3/" + request.responseText;
    document.getElementById("shareUrl").value = shareUrl;
}

window.onload = function() {
    initialize();
}

var pHandler;
var _opts;

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
    var gui = new dat.GUI();

    var vDraw = gui.add(_opts, 'U_DRAW');
    vDraw.onChange(function(value) {
        pHandler.getUiOpt().U_DRAW = value;
    });

    // Create folder and options

    // BACKGROUND
    var fBG = gui.addFolder('Background');
    var cBG = fBG.addColor(_opts, 'U_BG_COLOR').listen();
    cBG.onChange(function(value) {
        console.log(value);
        if (typeof(value) === "string") {
            pHandler.setBG(hexToRgb(value));
        } else {
            console.log(value);
            pHandler.setBG(value);
        }
    });

    // LAYOUT
    var fLayout = gui.addFolder('Layout');
    var cDotsPerRow = fLayout.add(_opts, 'U_DOTS_PER_ROW', 0, 80).step(1).listen();
    cDotsPerRow.onChange(function(value) {
        pHandler.setDotsPerRow(value);
    });
    var cDotDist = fLayout.add(_opts, 'U_DOT_DIST', 0, 100).step(1).listen();
    cDotDist.onChange(function(value) {
        pHandler.setDotDist(value);
    });

    // FILL
    var fFill = gui.addFolder('Fill');
    var cFill = fFill.add(_opts, 'U_DOT_FILL').listen();
    cFill.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_FILL = value;
    });
    var cFillSingleColor = fFill.addColor(_opts, 'U_DOT_SINGLE_FILL_COLOR').listen();
    cFillSingleColor.onChange(function(value) {
        if (typeof(value) === "string") {
            pHandler.setSingleFillColor(hexToRgb(value));
        } else {
            pHandler.setSingleFillColor(value);
        }
    });
    var cFillTheme = fFill.add(_opts, 'U_DOT_FILL_THEME').listen();
    cFillTheme.onChange(function(value) {
        pHandler.setTheme(value);
    });

    // STROKE
    var fStroke = gui.addFolder('Stroke');
    var cStroke = fStroke.add(_opts, 'U_DOT_STROKE').listen();
    cStroke.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_STROKE = value;
    });
    var cStrokeWgt = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT', 0.05, 30).listen();
    cStrokeWgt.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_STROKE_WEIGHT = value;
    });
    var cStrokeWgtMin = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT_MIN', 0.05, 30).listen();
    cStrokeWgtMin.onChange(function(value) {
        pHandler.setStrokeWgtMin(value);
    });
    var cStrokeWgtMax = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT_MAX', 0.05, 30).listen();
    cStrokeWgtMax.onChange(function(value) {
        pHandler.setStrokeWgtMax(value);
    });
    var cStrokeColor = fStroke.addColor(_opts, 'U_DOT_SINGLE_STROKE_COLOR').listen();
    cStrokeColor.onChange(function(value) {
        console.log(value, "strkClr");
        if (typeof(value) === "string") {
            pHandler.setStrokeColor(hexToRgb(value));
        } else {
            pHandler.setStrokeColor(value);
        }
    });
    var cStrokeRandomize = fStroke.add(_opts, 'U_DOT_STROKE_RANDOMIZE', 0, 30).listen();
    cStrokeRandomize.onChange(function(value) {
        pHandler.setStrokeRandomize(value);
    });

    // OFFSET
    var fOffset = gui.addFolder('Center Offset');
    var cOffset = fOffset.add(_opts, 'U_DOT_OFFSET_MAX', 0, 100).listen();
    cOffset.onChange(function(value) {
        pHandler.setOffset(value);
    })

    // RADIUS
    var fRadius = gui.addFolder('Radius');
    var cRadius = fRadius.add(_opts, 'U_DOT_RADIUS', 0, 100).listen();
    cRadius.onChange(function(value) {
        pHandler.setRadius(value);
    })
    var cRadiusRandomize = fRadius.add(_opts, 'U_DOT_RADIUS_RANDOMIZE').listen();
    cRadiusRandomize.onChange(function(value) {
        pHandler.setRadiusRandomize(value);
    })
    var cRadiusMin = fRadius.add(_opts, 'U_DOT_RADIUS_MIN', 0, 200).listen();
    cRadiusMin.onChange(function(value) {
        pHandler.setRadiusMin(value);
    })
    var cRadiusMax = fRadius.add(_opts, 'U_DOT_RADIUS_MAX', 0, 200).listen();
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

        // set the controls 
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
        post("/dotsV3/share",optsToJSON(),postCallback);
    })

    // Check for shared opts
    if (sharedOpts) {
        var jsonString = sharedOpts.replace(new RegExp('&#34;', 'g'), '"');
        loadOptsFromJSON(JSON.parse(jsonString).data);
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
