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
    this.U_DOT_STOKE = true;
    this.U_DOT_FILL = false;
}

var _opts;

window.onload = function() {
    initialize();
}

function initialize() {
	_opts = new UIOpts();
    var gui = new dat.GUI();
    gui.add(_opts, 'U_DRAW');
    gui.add(_opts, 'U_DOT_STOKE');
    gui.add(_opts, 'U_DOT_FILL');

}
