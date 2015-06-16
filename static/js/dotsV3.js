// var _options = {
//     "dotsPerRow": eValue,
//     "dotRadius": eValue,
//     "dotDist": eValue("dotDist"),
//     "numIters": eValue("numIters"),
//     "dotRadiusRandomize": radioCheckBool(g("dotRadiusRandomize")),
//     "dotRadiusMin": eValue("dotRadiusMin"),
//     "dotRadiusMax": eValue("dotRadiusMax"),
//     "dotCenterRandomize": radioCheckBool(g("dotCenterRandomize")),
//     "dotOffsetMax": eValue("dotOffsetMax"),
//     "fill": radioCheckBool(g("fill")),
//     "stroke": radioCheckBool(g("stroke")),
//     "strokeWeight": eValue("strokeWeight"),
// }

var UIOpts = function() {
    this.U_DRAW = true;
    this.U_DOT_STROKE = false;
    this.U_DOT_STROKE_WEIGHT = 0.5;
    this.U_DOT_FILL = true;
    this.U_DOT_OFFSET_MAX = 5;
}

window.onload = function() {
    initialize();
}

// var pHandler;
// var _opts;

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
    _opts = new UIOpts();
    var gui = new dat.GUI();

    gui.add(_opts, 'U_DRAW');

    // Create folder and options
    var fFill = gui.addFolder('Fill');
    var cFill = fFill.add(_opts, 'U_DOT_FILL');
    cFill.onChange(function(value) {
    	cFill.U_DOT_FILL = value;
    })

    var fStroke = gui.addFolder('Stroke');
    var cStroke = fStroke.add(_opts, 'U_DOT_STROKE');
    var cStrokeWgt = fStroke.add(_opts, 'U_DOT_STROKE_WEIGHT', 0, 30);
    cStrokeWgt.onChange(function(value) {
        pHandler.getUiOpt().U_DOT_STROKE_WEIGHT = value;
    })

    var fOffset = gui.addFolder('Center Offset');
    fOffset.add(_opts, 'U_DOT_OFFSET_MAX', 0, 1000);

    // Default open folders
    fFill.open();
    fStroke.open();
    fOffset.open();

}
