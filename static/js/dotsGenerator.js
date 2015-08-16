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
}

function postCallback(request) {
    var publishUrl = window.location.host + "/dotsGenerator/" + request.responseText;
    document.getElementById("publishUrl").value = publishUrl;
}

window.onresize = function() {
    // Set Canvas height and width
    pHandler.resizeImg();
    canvasRef.style.height = String(window.innerHeight) + "px";
    canvasRef.style.width = String(window.innerWidth) + "px";
}

window.onload = function() {
    initialize();
}
var randomThemeChance = 0;
var pHandler;
var _opts;
var gui;
var folders = [];
var fFill;
var viewMode = "create";
var canvasRef;
var frameRateEl;
var fillColorThemes = {
    "": "",
    "(2) Complementary RO BG": [
        [240, 90, 34, 1],
        [109, 199, 190, 1]
    ],
    "(2) Complementary O B": [
        [245, 138, 31, 1],
        [0, 172, 220, 1]
    ],
    "(2) Complementary YO BV": [
        [252, 184, 19, 1],
        [82, 79, 160, 1],
    ],
    "(2) Complementary Y V": [
        [252, 238, 30, 1],
        [105, 61, 141, 1],
    ],
    "(3) Russian Poster Art 1": [
        [255, 229, 110, 1],
        [215, 25, 32, 1],
        [0, 0, 0, 1]
    ],
    "(3) Russian Poster Art 2": [
        [240, 90, 34, 1],
        [255, 244, 222, 1],
        [80, 133, 181, 1]
    ],
    "(3) Russian Poster Art 7": [
        [226, 166, 92, 1],
        [221, 209, 222, 1],
        [35, 31, 32, 1]
    ],
    "(3) Russian Poster Art 8": [
        [255, 218, 137, 1],
        [132, 170, 142, 1],
        [236, 28, 36, 1]
    ],
    "(3) Pop Art 2": [
        [58, 77, 128, 1],
        [215, 25, 33, 1],
        [255, 255, 255, 1]
    ],
    "(3) Pop Art 4": [
        [252, 230, 0, 1],
        [83, 193, 185, 1],
        [236, 28, 36, 1]
    ],
    "(3) Desaturated 2": [
        [83, 105, 122, 1],
        [216, 208, 62, 1],
        [194, 138, 109, 1]
    ],
    "(3) Desaturated 6": [
        [176, 191, 200, 1],
        [128, 157, 172, 1],
        [70, 112, 129, 1]
    ],
    "(3) Saturated 2": [
        [240, 96, 34, 1],
        [25, 187, 220, 1],
        [205, 144, 45, 1]
    ],
    "(3) Saturated 3": [
        [255, 221, 0, 1],
        [94, 180, 70, 1],
        [9, 76, 160, 1]
    ],
    "(3) Saturated 4": [
        [210, 188, 42, 1],
        [0, 182, 193, 1],
        [211, 64, 136, 1]
    ],
    "(3) Saturated 5": [
        [255, 221, 0, 1],
        [0, 105, 180, 1],
        [236, 28, 36, 1]
    ],
    "(3) Warm 2": [
        [252, 238, 30, 1],
        [233, 55, 67, 1],
        [243, 158, 79, 1]
    ],
    "(3) Warm 4": [
        [165, 76, 44, 1],
        [244, 178, 48, 1],
        [167, 185, 58, 1]
    ],
    "(3) Corporate 2": [
        [0, 117, 177, 1],
        [163, 194, 218, 1],
        [35, 31, 32, 1]
    ],
    "(3) Corporate 4": [
        [253, 233, 63, 1],
        [2, 143, 206, 1],
        [35, 31, 32, 1]
    ],
    "(3) eCommerce 1": [
        [253, 233, 63, 1],
        [0, 178, 189, 1],
        [97, 84, 163, 1]
    ],
    "(3) Industrial 1": [
        [175, 166, 143, 1],
        [126, 115, 91, 1],
        [218, 215, 196, 1]
    ],
    "(3) Industrial 3": [
        [128, 157, 172, 1],
        [170, 172, 175, 1],
        [230, 230, 224, 1]
    ],
    "(3) Orange Juice": [
        [251, 187, 34, 1],
        [245, 180, 84, 1],
        [237, 149, 33, 1]
    ],
    "(3) Citrus 2": [
        [255, 195, 12, 1],
        [238, 124, 50, 1],
        [240, 95, 91, 1]
    ],
    "(3) Lollipop 2": [
        [255, 197, 10, 1],
        [86, 82, 162, 1],
        [41, 171, 226, 1]
    ],
    "(3) Analogous V RV R": [
        [101, 45, 144, 1],
        [182, 36, 103, 1],
        [236, 28, 36, 1]
    ],
    "(3) Analogous O YO Y": [
        [245, 138, 31, 1],
        [252, 184, 19, 1],
        [252, 238, 30, 1]
    ],
    "(3) Analogous R RO O": [
        [236, 28, 36, 1],
        [240, 90, 34, 1],
        [245, 138, 31, 1]
    ],
    "(3) Split Complementary O BG BV": [
        [245, 138, 31, 1],
        [109, 199, 190, 1],
        [82, 79, 160, 1]
    ],
    "(3) Split Complementary YO B V": [
        [252, 184, 19, 1],
        [0, 172, 220, 1],
        [101, 45, 144, 1]
    ],
    "(3) Split Complementary BG R O": [
        [109, 199, 190, 1],
        [236, 28, 36, 1],
        [245, 138, 31, 1]
    ]
}

function initialize() {
    var canvasHolder = document.getElementById("canvasHolder");
    canvasRef = document.createElement('canvas');
    canvasRef.id = "dotsSketch";
    var p = Processing.loadSketchFromSources(canvasRef, ['../static/dots3/dots3.pde']);
    canvasHolder.appendChild(canvasRef);

    // wait for sketch to load to assign handler
    var _timer = 0,
        _timeout = 5000,
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
        // var image = document.getElementsByTagName("canvas")[0].toDataURL();

    // Initialize gui
    var UIOpts = function() {
        var pOpt = pHandler.getUiOpt();
        this.U_DRAW = pOpt.U_DRAW;
        this.U_RESET = function() {
            pHandler.reset();
            resetControls();
        }
        this.U_BG_COLOR = pHandler.colorToRGB(pOpt.U_BG_COLOR);
        this.U_DOTS_PER_ROW = pOpt.U_DOTS_PER_ROW;
        this.U_DOTS_PER_COL = pOpt.U_DOTS_PER_COL;
        this.U_DOT_DIST_X = pOpt.U_DOT_DIST_X;
        this.U_DOT_DIST_Y = pOpt.U_DOT_DIST_Y;
        this.U_DOT_ROTATION = pOpt.U_DOT_ROTATION;
        this.U_ZOOM = pOpt.U_ZOOM;
        this.U_DOT_ANIMATION_SPEED = pHandler.calcValueInRange(pOpt.U_DOT_ANIMATION_SPEED, pOpt.U_DOT_ANIMATION_SPEED_MIN, pOpt.U_DOT_ANIMATION_SPEED_MAX, 0, 100);
        this.U_DOT_STROKE = pOpt.U_DOT_STROKE;
        this.U_DOT_STROKE_WEIGHT = pOpt.U_DOT_STROKE_WEIGHT;
        this.U_DOT_STROKE_WEIGHT_MIN = pOpt.U_DOT_STROKE_WEIGHT_MIN;
        this.U_DOT_STROKE_WEIGHT_MAX = pOpt.U_DOT_STROKE_WEIGHT_MAX;
        this.U_DOT_STROKE_RANDOMIZE = pOpt.U_DOT_STROKE_RANDOMIZE
        this.U_DOT_SINGLE_STROKE_COLOR = pHandler.colorToRGB(pOpt.U_DOT_SINGLE_STROKE_COLOR);
        this.U_DOT_SINGLE_STROKE_COLOR_OPACITY = pHandler.colorToRGB(pOpt.U_DOT_SINGLE_STROKE_COLOR)[3];
        this.U_DOT_FILL = pOpt.U_DOT_FILL;
        this.U_DOT_FILL_NUM_COLORS = pOpt.U_DOT_FILL_NUM_COLORS;
        this.U_DOT_FILL_COLOR_1 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_1);
        this.U_DOT_FILL_COLOR_2 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_2);
        this.U_DOT_FILL_COLOR_3 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_3);
        this.U_DOT_FILL_COLOR_MODE = pOpt.U_DOT_FILL_COLOR_MODE;
        this.U_DOT_FILL_THEMES = "";
        this.U_DOT_FILL_COLOR_DIST = pOpt.U_DOT_FILL_COLOR_DIST;
        this.U_DOT_FILL_COLOR_RAND_H_MIN = pOpt.U_DOT_FILL_COLOR_RAND_H_MIN;
        this.U_DOT_FILL_COLOR_RAND_H_MAX = pOpt.U_DOT_FILL_COLOR_RAND_H_MAX;
        this.U_DOT_FILL_COLOR_RAND_S_MIN = pOpt.U_DOT_FILL_COLOR_RAND_S_MIN;
        this.U_DOT_FILL_COLOR_RAND_S_MAX = pOpt.U_DOT_FILL_COLOR_RAND_S_MAX;
        this.U_DOT_FILL_COLOR_RAND_B_MIN = pOpt.U_DOT_FILL_COLOR_RAND_B_MIN;
        this.U_DOT_FILL_COLOR_RAND_B_MAX = pOpt.U_DOT_FILL_COLOR_RAND_B_MAX;
        this.U_DOT_OFFSET_X_MAX = pOpt.U_DOT_OFFSET_X_MAX;
        this.U_DOT_OFFSET_Y_MAX = pOpt.U_DOT_OFFSET_Y_MAX;
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

    var vReset = gui.add(_opts, 'U_RESET').name("Randomize");

    // Create folder and options

    // BACKGROUND
    var fBG = gui.addFolder('Background');
    folders.push(fBG);
    var cBG = fBG.addColor(_opts, 'U_BG_COLOR').name("Color");
    cBG.onChange(function(value) {
        if (typeof(value) === "string") {
            if (value.indexOf("#") === 0) {
                // Case where alpha is set to 1, the color
                // selector reverts to hex... Of course.
                pHandler.setBG(hexToRgb(value));
            } else {
                var tmpColor = rgbaStringToList(value);
                // Hardcode bg opacity to 1.
                // tmpColor[3] = 1;
                pHandler.setBG(tmpColor);
            }
        } else {
            // Case where it returns a list (object type).
            // Have to 
            // value[3] = 1;
            pHandler.setBG(value);
        }
    });

    // LAYOUT
    var fLayout = gui.addFolder('Layout');
    folders.push(fLayout);
    var cDotsPerRow = fLayout.add(_opts, 'U_DOTS_PER_ROW', 0, 50).step(1).name("Dots Per Row");
    cDotsPerRow.onChange(function(value) {
        pHandler.setDotsPerRow(value);
    });
    var cDotsPerCol = fLayout.add(_opts, 'U_DOTS_PER_COL', 0, 50).step(1).name("Dots Per Col");
    cDotsPerCol.onChange(function(value) {
        pHandler.setDotsPerCol(value);
    });
    var cDotDistX = fLayout.add(_opts, 'U_DOT_DIST_X', 0, 100).step(1).name("Dot Spacing X");
    cDotDistX.onChange(function(value) {
        pHandler.setDotDistX(value);
    });
    var cDotDistY = fLayout.add(_opts, 'U_DOT_DIST_Y', 0, 100).step(1).name("Dot Spacing Y");
    cDotDistY.onChange(function(value) {
        pHandler.setDotDistY(value);
    });
    var cDotRotation = fLayout.add(_opts, 'U_DOT_ROTATION', 0, 360).step(1).name("Grid Rotation");
    cDotRotation.onChange(function(value) {
        pHandler.setRotation(value);
    });
    var cZoom = fLayout.add(_opts, 'U_ZOOM', 0, 10).step(0.01).name("Zoom");
    cZoom.onChange(function(value) {
        pHandler.setZoom(value);
    });

    var cDotAnimationSpeed = fLayout.add(_opts, 'U_DOT_ANIMATION_SPEED', 0, 100).step(1).name("Animation Speed");
    cDotAnimationSpeed.onChange(function(value) {
        pHandler.setAnimationSpeed(value);
    });

    // FILL
    fFill = gui.addFolder('Fill');
    folders.push(fFill);
    var cFill = fFill.add(_opts, 'U_DOT_FILL').name("Enabled");
    cFill.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_FILL = value;
    });
    var cFillNumColors = fFill.add(_opts, 'U_DOT_FILL_NUM_COLORS', [1, 2, 3]).name("# Fill Colors");
    cFillNumColors.onChange(function(value) {
        pHandler.setFillNumColors(value);
    });

    var cFillColor1 = fFill.addColor(_opts, 'U_DOT_FILL_COLOR_1').name("Color 1");
    cFillColor1.onChange(function(value) {
        if (typeof(value) === "string") {
            if (value.indexOf("#") === 0) {
                // Case where alpha is set to 1, the color
                // selector reverts to hex... Of course.
                pHandler.setFillColor(hexToRgb(value), 0);
            } else {
                pHandler.setFillColor(rgbaStringToList(value), 0);
            }
        } else {
            // Case where it returns a list (object type).
            pHandler.setFillColor(value, 0);
        }
        // Hacky fix for the color themes that need to be reset
        // since dat gui only uses onchange so can't resubmit same
        // option for now...
        fFill.__controllers[5].setValue("");
    });
    var cFillColor2 = fFill.addColor(_opts, 'U_DOT_FILL_COLOR_2').name("Color 2");
    cFillColor2.onChange(function(value) {
        if (typeof(value) === "string") {
            if (value.indexOf("#") === 0) {
                // Case where alpha is set to 1, the color
                // selector reverts to hex... Of course.
                pHandler.setFillColor(hexToRgb(value), 1);
            } else {
                pHandler.setFillColor(rgbaStringToList(value), 1);
            }
        } else {
            // Case where it returns a list (object type).
            pHandler.setFillColor(value, 1);
        }
        // Hacky fix for the color themes that need to be reset
        // since dat gui only uses onchange so can't resubmit same
        // option for now...
        fFill.__controllers[5].setValue("");
    });
    var cFillColor3 = fFill.addColor(_opts, 'U_DOT_FILL_COLOR_3').name("Color 3");
    cFillColor3.onChange(function(value) {
        if (typeof(value) === "string") {
            if (value.indexOf("#") === 0) {
                // Case where alpha is set to 1, the color
                // selector reverts to hex... Of course.
                pHandler.setFillColor(hexToRgb(value), 2);
            } else {
                pHandler.setFillColor(rgbaStringToList(value), 2);
            }
        } else {
            // Case where it returns a list (object type).
            pHandler.setFillColor(value, 2);
        }
        // Hacky fix for the color themes that need to be reset
        // since dat gui only uses onchange so can't resubmit same
        // option for now...
        fFill.__controllers[5].setValue("");
    });

    var cFillThemes = fFill.add(_opts, 'U_DOT_FILL_THEMES', Object.keys(fillColorThemes)).name("Fill Themes");
    cFillThemes.onChange(function(value) {
        var t = fillColorThemes[value];
        if (t === "") {
            return;
        }
        if (t.length > 0) {
            pHandler.setFillColor(t[0], 0);
        }
        if (t.length > 1) {
            pHandler.setFillColor(t[1], 1);
        }
        if (t.length > 2) {
            pHandler.setFillColor(t[2], 2);
        }
        updateColors();
    });
    var cFillColorDist = fFill.add(_opts, 'U_DOT_FILL_COLOR_DIST', ["Random", "Alternating", "Sorted"]).name("Color Arrangement");
    cFillColorDist.onChange(function(value) {
        pHandler.setFillColorDist(value);
    });


    var cFillColorMode = fFill.add(_opts, 'U_DOT_FILL_COLOR_MODE', ["Theme", "Random"]).name("Color Mode");
    cFillColorMode.onChange(function(value) {
        pHandler.setFillColorMode(value);
    });

    var cFillColorRandHMin = fFill.add(_opts, "U_DOT_FILL_COLOR_RAND_H_MIN", 0, 300).name("Random H Min");
    cFillColorRandHMin.onChange(function(value) {
        pHandler.setHSB("H", "MIN", value);
    });
    var cFillColorRandHMax = fFill.add(_opts, "U_DOT_FILL_COLOR_RAND_H_MAX", 0, 300).name("Random H Max");
    cFillColorRandHMax.onChange(function(value) {
        pHandler.setHSB("H", "MAX", value);
    });
    var cFillColorRandSMin = fFill.add(_opts, "U_DOT_FILL_COLOR_RAND_S_MIN", 0, 300).name("Random S Min");
    cFillColorRandSMin.onChange(function(value) {
        pHandler.setHSB("S", "MIN", value);
    });
    var cFillColorRandSMax = fFill.add(_opts, "U_DOT_FILL_COLOR_RAND_S_MAX", 0, 300).name("Random S Max");
    cFillColorRandSMax.onChange(function(value) {
        pHandler.setHSB("S", "MAX", value);
    });
    var cFillColorRandBMin = fFill.add(_opts, "U_DOT_FILL_COLOR_RAND_B_MIN", 0, 300).name("Random B Min");
    cFillColorRandBMin.onChange(function(value) {
        pHandler.setHSB("B", "MIN", value);
    });
    var cFillColorRandBMax = fFill.add(_opts, "U_DOT_FILL_COLOR_RAND_B_MAX", 0, 300).name("Random B Max");
    cFillColorRandBMax.onChange(function(value) {
        pHandler.setHSB("B", "MAX", value);
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
            if (value.indexOf("#") === 0) {
                // Case where alpha is set to 1, the color
                // selector reverts to hex... Of course.
                pHandler.setStrokeColor(hexToRgb(value));
            } else {
                pHandler.setStrokeColor(rgbaStringToList(value));
            }
        } else {
            // Case where it returns a list (object type).
            pHandler.setStrokeColor(value);
        }
    });
    // var cStrokeColorOpacity = fStroke.add(_opts, 'U_DOT_SINGLE_STROKE_COLOR_OPACITY', 0, 255).step(1).name("Color Opacity");
    // cStrokeColorOpacity.onChange(function(value) {
    //     pHandler.setStrokeColorOpacity(value);
    // });

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
    var cOffsetX = fOffset.add(_opts, 'U_DOT_OFFSET_X_MAX', 0, 100).name("Max Offset X");
    cOffsetX.onChange(function(value) {
        pHandler.setOffsetX(value);
    })
    var cOffsetY = fOffset.add(_opts, 'U_DOT_OFFSET_Y_MAX', 0, 100).name("Max Offset Y");
    cOffsetY.onChange(function(value) {
        pHandler.setOffsetY(value);
    })

    // RADIUS
    var fRadius = gui.addFolder('Radius');
    folders.push(fRadius);
    var cRadius = fRadius.add(_opts, 'U_DOT_RADIUS', 0, 300).name("Radius Size");
    cRadius.onChange(function(value) {
        pHandler.setRadius(value);
    })
    var cRadiusRandomize = fRadius.add(_opts, 'U_DOT_RADIUS_RANDOMIZE').name("Random Radius");
    cRadiusRandomize.onChange(function(value) {
        pHandler.setRadiusRandomize(value);
    })
    var cRadiusMin = fRadius.add(_opts, 'U_DOT_RADIUS_MIN', 0, 300).name("Random Min");
    cRadiusMin.onChange(function(value) {
        pHandler.setRadiusMin(value);
    })
    var cRadiusMax = fRadius.add(_opts, 'U_DOT_RADIUS_MAX', 0, 300).name("Random Max");;
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
        var currOpts = JSON.stringify(optsToJSON());
        var textArea = document.getElementById("inputArea");
        textArea.value = currOpts;
    })

    // Initialize publish button
    var publishEl = document.getElementById("publishButton");
    publishEl.addEventListener("click", function(evt) {
        var canvas = document.getElementsByTagName("canvas")[0];
        var dataUri = canvas.toDataURL();
        // CROP image to smallest dimension to make square 
        // RESIZE image to thumbnail size

        var newCanvas = document.createElement("canvas");
        var targetSize = 600;
        var newWidth = canvas.width;
        var newHeight = canvas.height;
        var widthOffset = 0;
        var heightOffset = 0;

        if (canvas.width < canvas.height) {
            // crop height
            newHeight = newWidth;
            heightOffset = (canvas.height - canvas.width);
        } else {
            // crop width
            newWidth = newHeight;
            widthOffset = (canvas.width - canvas.height);
        }
        newCanvas.width = targetSize;
        newCanvas.height = targetSize;

        newCanvas.getContext('2d').drawImage(canvas, widthOffset / 2, heightOffset / 2, canvas.width - widthOffset, canvas.height - heightOffset, 0, 0, targetSize, targetSize);
        var data = {
            "opts": optsToJSON(),
            "img": newCanvas.toDataURL()
        };
        post("/dotsGenerator/publish", JSON.stringify(data), postCallback);
    })

    // Check for shared opts
    if (sharedOpts) {
        var jsonString = sharedOpts.replace(new RegExp('&#34;', 'g'), '"');
        loadOptsFromJSON(JSON.parse(jsonString).data);
        resetControls();
        // Call resize to fit whatever shared sketch is to current window
        pHandler.resizeImg();
    } else {
        // Chance of randomly assigning color theme
        if (Math.random() < randomThemeChance) {
            var randInt = Math.floor((Math.random() * Object.keys(fillColorThemes).length));
            var t = fillColorThemes[Object.keys(fillColorThemes)[randInt]];
            if (t === "") {
                return;
            }
            if (t.length > 0) {
                pHandler.setFillColor(t[0], 0);
            }
            if (t.length > 1) {
                pHandler.setFillColor(t[1], 1);
            }
            if (t.length > 2) {
                pHandler.setFillColor(t[2], 2);
            }
            updateColors();
        }
    }

    // Set Canvas height and width
    canvasRef.style.height = String(window.innerHeight) + "px";
    canvasRef.style.width = String(window.innerWidth) + "px";

    // Initialize frame rate element
    frameRateEl = document.getElementById("frameRate");

    // Set up viewing modes
    window.addEventListener("mousemove", function() {
        if (viewMode === "view") {
            disableFullscreen();
            viewMode = "create";
        }
    });

    canvasRef.addEventListener("click", function() {
        console.log("canvasRef click");
        if (viewMode === "create") {
            enableFullscreen();
            viewMode = "view";
        } else if (viewMode === "view") {
            disableFullscreen();
            viewMode = "create";
        }
    });

    // Set up fix for stupid color picker position issue
    //ColorPickerFix
    $('.main').scroll(function() {
        var scroll = $('.main').scrollTop();
        $(".selector").css('-webkit-transform', 'translate(0px,' + (-scroll) + 'px)');
    });

}

function resetControls() {
    // update the controls local vars 
    var pOpt = pHandler.getUiOpt();
    _opts.U_DRAW = pOpt.U_DRAW;
    _opts.U_BG_COLOR = pHandler.colorToRGB(pOpt.U_BG_COLOR);
    // _opts.U_BG_COLOR_OPACITY = pHandler.colorToRGB(pOpt.U_BG_COLOR)[3];
    _opts.U_DOTS_PER_ROW = pOpt.U_DOTS_PER_ROW;
    _opts.U_DOTS_PER_COL = pOpt.U_DOTS_PER_COL;
    _opts.U_DOT_DIST_X = pOpt.U_DOT_DIST_X;
    _opts.U_DOT_DIST_Y = pOpt.U_DOT_DIST_Y;
    _opts.U_DOT_ROTATION = pOpt.U_DOT_ROTATION;
    _opts.U_ZOOM = pOpt.U_ZOOM;
    _opts.U_DOT_ANIMATION_SPEED = pHandler.calcValueInRange(pOpt.U_DOT_ANIMATION_SPEED, pOpt.U_DOT_ANIMATION_SPEED_MIN, pOpt.U_DOT_ANIMATION_SPEED_MAX, 0, 100);
    _opts.U_DOT_STROKE = pOpt.U_DOT_STROKE;
    _opts.U_DOT_STROKE_WEIGHT = pOpt.U_DOT_STROKE_WEIGHT;
    _opts.U_DOT_STROKE_WEIGHT_MIN = pOpt.U_DOT_STROKE_WEIGHT_MIN;
    _opts.U_DOT_STROKE_WEIGHT_MAX = pOpt.U_DOT_STROKE_WEIGHT_MAX;
    _opts.U_DOT_STROKE_RANDOMIZE = pOpt.U_DOT_STROKE_RANDOMIZE
    _opts.U_DOT_SINGLE_STROKE_COLOR = pHandler.colorToRGB(pOpt.U_DOT_SINGLE_STROKE_COLOR);
    _opts.U_DOT_FILL = pOpt.U_DOT_FILL;
    _opts.U_DOT_FILL_NUM_COLORS = pOpt.U_DOT_FILL_NUM_COLORS;
    _opts.U_DOT_FILL_COLOR_1 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_1);
    _opts.U_DOT_FILL_COLOR_2 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_2);
    _opts.U_DOT_FILL_COLOR_3 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_3);
    _opts.U_DOT_FILL_COLOR_MODE = pOpt.U_DOT_FILL_COLOR_MODE; // color mode switch
    _opts.U_DOT_FILL_THEMES = ""; // dummy variable for UI
    _opts.U_DOT_FILL_COLOR_DIST = pOpt.U_DOT_FILL_COLOR_DIST;
    _opts.U_DOT_FILL_COLOR_RAND_H_MIN = pOpt.U_DOT_FILL_COLOR_RAND_H_MIN;
    _opts.U_DOT_FILL_COLOR_RAND_H_MAX = pOpt.U_DOT_FILL_COLOR_RAND_H_MAX;
    _opts.U_DOT_FILL_COLOR_RAND_S_MIN = pOpt.U_DOT_FILL_COLOR_RAND_S_MIN;
    _opts.U_DOT_FILL_COLOR_RAND_S_MAX = pOpt.U_DOT_FILL_COLOR_RAND_S_MAX;
    _opts.U_DOT_FILL_COLOR_RAND_B_MIN = pOpt.U_DOT_FILL_COLOR_RAND_B_MIN;
    _opts.U_DOT_FILL_COLOR_RAND_B_MAX = pOpt.U_DOT_FILL_COLOR_RAND_B_MAX;
    _opts.U_DOT_OFFSET_X_MAX = pOpt.U_DOT_OFFSET_X_MAX;
    _opts.U_DOT_OFFSET_Y_MAX = pOpt.U_DOT_OFFSET_Y_MAX;
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

function updateColors() {
    var pOpt = pHandler.getUiOpt();
    _opts.U_DOT_FILL_COLOR_1 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_1);
    _opts.U_DOT_FILL_COLOR_2 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_2);
    _opts.U_DOT_FILL_COLOR_3 = pHandler.colorToRGB(pOpt.U_DOT_FILL_COLOR_3);
    var fc = fFill.__controllers;
    for (var j = 0; j < fc.length; j++) {
        fc[j].updateDisplay();
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
    return newObj;
}

function loadOptsFromJSON(json) {
    if (json === "") {
        console.log("BAD JSON");
        alert("Unable to load requested sketch.");
        return;
    }
    pHandler.setUiOpt(json);
}

function rgbaStringToList(l) {
    // Super hard coded, can fix later if it's an issue.
    // Assumes the 'a' value is out of 255.
    var s1 = l.split("rgba(")[1];
    var s2 = s1.split(")")[0];
    var sVals = s2.split(",")
    var vals = [parseInt(sVals[0]), parseInt(sVals[1]), parseInt(sVals[2]), parseFloat(sVals[3])];
    return vals;
}

function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? [parseInt(result[1], 16), parseInt(result[2], 16), parseInt(result[3], 16), 1] : null;
}

function disableFullscreen() {
    document.body.className = "inherit";
    document.getElementById("generatorContainer").style.display = "inherit";
    document.getElementsByClassName("dg main a")[0].style.display = "inherit";
    frameRateEl.style.display = "inherit";
}

function enableFullscreen() {
    document.body.className = "fullscreen";
    document.getElementById("generatorContainer").style.display = "none";
    document.getElementsByClassName("dg main a")[0].style.display = "none";
    frameRateEl.style.display = "none";
}

function isRetinaDisplay() {
    if (window.matchMedia) {
        var mq = window.matchMedia("only screen and (min--moz-device-pixel-ratio: 1.3), only screen and (-o-min-device-pixel-ratio: 2.6/2), only screen and (-webkit-min-device-pixel-ratio: 1.3), only screen  and (min-device-pixel-ratio: 1.3), only screen and (min-resolution: 1.3dppx)");
        if (mq && mq.matches || (window.devicePixelRatio > 1)) {
            return true;
        } else {
            return false;
        }
    }
}

function cloneCanvas(oldCanvas) {

    //create a new canvas
    var newCanvas = document.createElement('canvas');
    var context = newCanvas.getContext('2d');

    //set dimensions
    newCanvas.width = oldCanvas.width;
    newCanvas.height = oldCanvas.height;

    //apply the old canvas to the new one
    context.drawImage(oldCanvas, 0, 0);

    //return the new canvas
    return newCanvas;
}

function savePDF() {
    pHandler.saveToPDF();
}
