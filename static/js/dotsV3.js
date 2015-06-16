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
    this.U_DOT_STROKE = true;
    this.U_DOT_FILL = true;
}

var _opts;

window.onload = function() {
    initialize();
}

function initialize() {
	var canvasHolder = document.getElementById("canvasHolder");
	var canvasRef = document.createElement('canvas');
	var p = Processing.loadSketchFromSources(canvasRef, ['static/dots3/dots3.pde']);
	canvasHolder.appendChild(canvasRef);

	_opts = new UIOpts();
    var gui = new dat.GUI();
    gui.add(_opts, 'U_DRAW');
    gui.add(_opts, 'U_DOT_STROKE');
    gui.add(_opts, 'U_DOT_FILL');

}
