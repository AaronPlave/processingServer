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
    // Initialize gui
    var UIOpts = function() {
        pOpt = pHandler.getUiOpt();
        this.U_DRAW = pOpt.U_DRAW;
        this.U_DOT_STROKE = pOpt.U_DOT_STROKE;
        this.U_DOT_STROKE_WEIGHT = pOpt.U_DOT_STROKE_WEIGHT;
        this.U_DOT_FILL = pOpt.U_DOT_FILL;
        this.U_DOT_SINGLE_FILL_COLOR = pOpt.U_DOT_SINGLE_FILL_COLOR;
        this.U_DOT_FILL_THEME = pOpt.U_DOT_FILL_THEME;
        this.U_DOT_OFFSET_MAX = pOpt.U_DOT_OFFSET_MAX;
    }
    _opts = new UIOpts();
    var gui = new dat.GUI();

    gui.add(_opts, 'U_DRAW');

    // Create folder and options

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

    // OFFSET
    var fOffset = gui.addFolder('Center Offset');
    var cOffset = fOffset.add(_opts, 'U_DOT_OFFSET_MAX', 0, 1000);
    cOffset.onChange(function(value) {
        pHandler.setOffset(value);
    })

    // Default open folders
    fFill.open();
    fStroke.open();
    fOffset.open();

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
