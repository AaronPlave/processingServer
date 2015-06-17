window.onload = function() {
    initialize();
}

var pHandler;
var _opts;

function initialize() {
    var canvasHolder = document.getElementById("canvasHolder");
    var canvasRef = document.createElement('canvas');
    canvasRef.id = "dotsSketch"
    var p = Processing.loadSketchFromSources(canvasRef, ['static/dots3/dots3.pde']);
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
        pOpt = pHandler.getUiOpt();
        // this.U_DRAW = pOpt.U_DRAW;
        this.U_BG_COLOR = pOpt.U_BG_COLOR;
        this.U_DOTS_PER_ROW = pOpt.U_DOTS_PER_ROW;
        this.U_DOT_STROKE = pOpt.U_DOT_STROKE;
        this.U_DOT_STROKE_WEIGHT = pOpt.U_DOT_STROKE_WEIGHT;
        this.U_DOT_SINGLE_STROKE_COLOR = pOpt.U_DOT_SINGLE_STROKE_COLOR;
        this.U_DOT_FILL = pOpt.U_DOT_FILL;
        this.U_DOT_SINGLE_FILL_COLOR = pOpt.U_DOT_SINGLE_FILL_COLOR;
        this.U_DOT_FILL_THEME = pOpt.U_DOT_FILL_THEME;
        this.U_DOT_OFFSET_MAX = pOpt.U_DOT_OFFSET_MAX;
        this.U_DOT_RADIUS = pOpt.U_DOT_RADIUS;
        this.U_DOT_RADIUS_RANDOMIZE = pOpt.U_DOT_RADIUS_RANDOMIZE;
        this.U_DOT_RADIUS_MIN = pOpt.U_DOT_RADIUS_MIN;
        this.U_DOT_RADIUS_MAX = pOpt.U_DOT_RADIUS_MAX;
    }
    _opts = new UIOpts();
    var gui = new dat.GUI();

    // gui.add(_opts, 'U_DRAW');

    // Create folder and options

    // BACKGROUND
    var fBG = gui.addFolder('Background');
    var cBG = fBG.addColor(_opts, 'U_BG_COLOR');
    cBG.onChange(function(value) {
        if (typeof(value) === "string") {
            pHandler.setBG(hexToRgb(value));
        } else {
            pHandler.setBG(value);
        }
    });

    // LAYOUT
    var fLayout = gui.addFolder('Layout');
    var cDotsPerRow = fLayout.add(_opts,'U_DOTS_PER_ROW',0,40).step(1);
    cDotsPerRow.onChange(function(value) {
        pHandler.setDotsPerRow(value);
    });

    // FILL
    var fFill = gui.addFolder('Fill');
    var cFill = fFill.add(_opts, 'U_DOT_FILL');
    cFill.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_FILL = value;
    });
    var cFillSingleColor = fFill.addColor(_opts, 'U_DOT_SINGLE_FILL_COLOR');
    cFillSingleColor.onChange(function(value) {
        if (typeof(value) === "string") {
            pHandler.setSingleFillColor(hexToRgb(value));
        } else {
            pHandler.setSingleFillColor(value);
        }
    });
    var cFillTheme = fFill.add(_opts, 'U_DOT_FILL_THEME');
    cFillTheme.onChange(function(value) {
        pHandler.setTheme(value);
    });

    // STROKE
    var fStroke = gui.addFolder('Stroke');
    var cStroke = fStroke.add(_opts, 'U_DOT_STROKE');
    cStroke.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_STROKE = value;
    });
    var cStrokeWgt = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT', 0, 30);
    cStrokeWgt.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_STROKE_WEIGHT = value;
    });
    var cStrokeColor = fStroke.addColor(_opts, 'U_DOT_SINGLE_STROKE_COLOR');
    cStrokeColor.onChange(function(value) {
        if (typeof(value) === "string") {
            pHandler.setStrokeColor(hexToRgb(value));
        } else {
            pHandler.setStrokeColor(value);
        }
    });

    // OFFSET
    var fOffset = gui.addFolder('Center Offset');
    var cOffset = fOffset.add(_opts, 'U_DOT_OFFSET_MAX', 0, 750);
    cOffset.onChange(function(value) {
        pHandler.setOffset(value);
    })

    // RADIUS
    var fRadius = gui.addFolder('Radius');
    var cRadius = fRadius.add(_opts, 'U_DOT_RADIUS', 0, 100);
    cRadius.onChange(function(value) {
        pHandler.setRadius(value);
    })
    var cRadiusRandomize = fRadius.add(_opts, 'U_DOT_RADIUS_RANDOMIZE');
    cRadiusRandomize.onChange(function(value) {
        pHandler.setRadiusRandomize(value);
    })
    var cRadiusMin = fRadius.add(_opts, 'U_DOT_RADIUS_MIN',0,100);
    cRadiusMin.onChange(function(value) {
        pHandler.setRadiusMin(value);
    })
    var cRadiusMax = fRadius.add(_opts, 'U_DOT_RADIUS_MAX',0,100);
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
