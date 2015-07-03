// DOTS GENERATOR
// AARON PLAVE
// aplave@wesleyan.edu

//// DEFAULT CUSTOMIZABLE PARAMS
// CONFIGURABLES:
//  +Stroke on/off, color, thickness
//  Fill on/off, single color, random colors, ordered color scheme, random within scheme
//  -Blend mode of dot colors (multiply, divide, etc.)
//      This has some issues with background blending and loss of image quality (might be solved
//      using transformation to PDF.)
//  +Dot radius (px), randomized?
//  +Dots per row (px)
//  +Distance between dots (px)
//  Dot radii:
//    Radius1 length, radius2 length
//  +Dot radii uniformity yes/no (if no, randomly assign within boundaries, else user defines radii)
//  +Dot center offset
//  Dot shape:
//    Circle, ellipse, triangle, square, etc.
//  More complex random effects such as using perlin noise to randomly warp the dot plane
//  Number of draw iterations:  change conditions randomly or in order?
//  Shape noise, could add some amount of random *wiggliness* to each shape, uniformly or not. 

class UIOpt {
  boolean U_DRAW;
  boolean U_DRAW;
  boolean U_DOT_STROKE;
  boolean U_DOT_STROKE_RANDOMIZE;
  boolean U_DOT_FILL;
  boolean U_DOT_RADIUS_RANDOMIZE;
  boolean U_DOT_OFFSET;

  // dot center offset
  float U_DOT_OFFSET_X_MAX;
  float U_DOT_OFFSET_Y_MAX;

  // dot radius
  int U_DOT_RADIUS;
  int U_DOT_RADIUS_MIN;
  int U_DOT_RADIUS_MAX;

  // background color
  color U_BG_COLOR;

  // dot num colors
  int U_DOT_FILL_NUM_COLORS;

  // dot fill single color 
  color U_DOT_FILL_COLOR_1;
  color U_DOT_FILL_COLOR_2;
  color U_DOT_FILL_COLOR_3;

  // dot fill color dist
  String U_DOT_FILL_COLOR_DIST;

  // dot stroke
  float U_DOT_STROKE_WEIGHT;
  float U_DOT_STROKE_WEIGHT_MIN;
  float U_DOT_STROKE_WEIGHT_MAX;
  color U_DOT_SINGLE_STROKE_COLOR;
  //// END CUSTOMIZABLE PARAMS

  //// PREDEFINED PARAMS
  int IMG_HEIGHT;
  int IMG_WIDTH;
  int U_DOTS_PER_ROW;
  int U_DOTS_PER_COL;
  int U_DOT_DIST_X;
  int U_DOT_DIST_Y;
  int IMG_PADDING_X;
  int IMG_PADDING_Y;
  //// END PREDEFINED PARAMS

  UIOpt() {
    U_DRAW = true;
    U_DOT_FILL = randBool(0.75);
    U_DOT_FILL_NUM_COLORS = randInt(1,3);

    if (U_DOT_FILL) {
      // small chance to combine fill + stroke
      U_DOT_STROKE = randBool(0.15);
    } else {
      // if no fill, must have stroke
      U_DOT_STROKE = true;
    }

    // dot center offset
    U_DOT_OFFSET_X_MAX = randInt(0,100);
    U_DOT_OFFSET_Y_MAX = randInt(0,100);

    // dot radius
    U_DOT_RADIUS_RANDOMIZE = randBool(0.75);
    U_DOT_RADIUS = randInt(0.1,20);
    U_DOT_RADIUS_MIN = randInt(0.1,5);
    U_DOT_RADIUS_MAX = int(random(U_DOT_RADIUS_MIN, 200));

    // background color
    U_BG_COLOR = color(random(255),random(255),random(255),255);
    U_DOT_FILL_COLOR_1 = color(abs(abs(51-red(U_BG_COLOR))-255),abs(abs(51-green(U_BG_COLOR))-255),abs(abs(51-blue(U_BG_COLOR))-255),random(255));
    U_DOT_FILL_COLOR_2 = color(abs(abs(102-red(U_BG_COLOR))-255),abs(abs(102-green(U_BG_COLOR))-255),abs(abs(102-blue(U_BG_COLOR))-255),random(255));
    U_DOT_FILL_COLOR_3 = color(abs(abs(153-red(U_BG_COLOR))-255),abs(abs(153-green(U_BG_COLOR))-255),abs(abs(153-blue(U_BG_COLOR))-255),random(255));

    // dot fill colors 
    // U_DOT_FILL_COLOR_1 = color(255, 229, 110, 255);
    // U_DOT_FILL_COLOR_2 = color(215, 25, 32, 255);
    // U_DOT_FILL_COLOR_3 = color(0, 0, 0, 255);

    // dot fill color distribution
    int _rand = randInt(0,3);
    if (_rand == 1) {
      U_DOT_FILL_COLOR_DIST = "Random";
    } else if (_rand == 2) {
      U_DOT_FILL_COLOR_DIST = "Alternating";
    } else {
      U_DOT_FILL_COLOR_DIST = "Sorted";
    }

    // dot stroke
    U_DOT_STROKE_RANDOMIZE = randBool(0.4);
    U_DOT_STROKE_WEIGHT = random(0.3, 0.6);
    U_DOT_STROKE_WEIGHT_MIN  = random(0.3,0.5);
    U_DOT_STROKE_WEIGHT_MAX = random(0.5,1);
    U_DOT_SINGLE_STROKE_COLOR = color(255-red(U_BG_COLOR),255-green(U_BG_COLOR),255-blue(U_BG_COLOR),random(0.1,255));

    //// END CUSTOMIZABLE PARAMS

    //// PREDEFINED PARAMS
    IMG_HEIGHT = window.innerHeight*window.devicePixelRatio;
    ;
    IMG_WIDTH = window.innerWidth*window.devicePixelRatio;
    ;
    U_DOTS_PER_ROW = randInt(1,50);
    U_DOTS_PER_COL = randInt(1,50);
    U_DOT_DIST_X = randInt(0,50);
    U_DOT_DIST_Y = randInt(0,50);
    IMG_PADDING_X = (IMG_WIDTH - ((U_DOTS_PER_ROW-1) * U_DOT_DIST_X)) / 2;
    IMG_PADDING_Y = (IMG_HEIGHT - ((U_DOTS_PER_COL-1) * U_DOT_DIST_Y)) / 2;
    //// END PREDEFINED PARAMS
  }
};

UIOpt uiOpt;

void getUiOpt() {
  uiOpt.U_DRAW = true;
  return uiOpt;
}

void setUiOpt(x) {
  UIOpt newOpt = new UIOpt();
  String[] keys = Object.keys(x);
  for (int i = 0; i < keys.length; i++) {
    if (keys[i] == "U_BG_COLOR" || keys[i] == "U_DOT_SINGLE_STROKE_COLOR" || keys[i] == "U_DOT_SINGLE_FILL_COLOR") {
      int[] c = x[keys[i]];
      newOpt[keys[i]] = color(c[0], c[1], c[2], c[3]*255);
    } else {
      newOpt[keys[i]] = x[keys[i]];
    }
  }
  uiOpt = newOpt;
  recalculatePadding();
  dotArray = {};
  initDots();
}

// DOT CLASS DEF
class Dot {
  // PVector origin;
  PVector pos;
  PVector offset;
  PVector targetOffset;
  PVector offsetRate;

  float strokeWgt;
  color strokeColor, fillColor; 
  int fillColorId;
  float strokeRate;
  float targetStroke;
  int strokeDir;

  float radius; 
  float targetRadius;
  float radiusRate;
  int radiusDir;

  Dot() {
    origin = new PVector();
    pos = new PVector();
    offset = new PVector();
    targetOffset = new PVector();
  }

  // void setOrigin(int x, int y) {
  //   origin.x = x;
  //   origin.y = y;
  // }

  void setPos(int x, int y) {
    pos.x = x;
    pos.y = y;
  }

  void setOffset(float x, float y) {
    offset.x = x;
    offset.y = y;
  }

  boolean isInView() {
    int pX = pos.x + offset.x + radius;
    int pY = pos.y + offset.y + radius;
    if (pX < 0 || pX > window.innerWidth*window.devicePixelRatio) {
      return false;
    } 
    if (pY < 0 || pY > window.innerHeight*window.devicePixelRatio) {
      return false;
    }
    return true;
  }

  void drawDot() {

    // Determine fill
    if (uiOpt.U_DOT_FILL) {
      fill(fillColor);
    } else {
      noFill();
    }
    // Determine Next
    if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
      if (radiusDir == 1) {
        if (radius < targetRadius) {
          radius += radiusRate;
        }
      } else {
        if (radius > targetRadius) {
          radius += radiusRate;
        }
      }
    }

    if (uiOpt.U_DOT_STROKE) {
      // Determine stroke 
      stroke(strokeColor);
      if (uiOpt.U_DOT_STROKE_RANDOMIZE) {
        if (strokeDir == 1) {
          if (strokeWgt < targetStroke) {
            strokeWgt += strokeRate;
          }
        } else {
          if (strokeWgt > targetStroke) {
            strokeWgt += strokeRate;
          }
        }
        strokeWeight(strokeWgt);
      } else {
        strokeWeight(uiOpt.U_DOT_STROKE_WEIGHT);
      }
    } else {
      noStroke();
    }
    PVector dirOfTravel = PVector.sub(targetOffset, offset);
    dirOfTravel.normalize();
    offset.add(PVector.mult(dirOfTravel, offsetRate));

    // Determine if dot is onscreen, if so, draw.
    if (isInView()) {
      ellipse(pos.x+offset.x, pos.y+offset.y, radius, radius);
    }
  }
};

Dot[] dotArray = {
};

void checkDotConditions() {
  // Check radius travel
  boolean allRadiiReached = true;
  boolean allStrokesReached = true;
  boolean allOffsetsReached = true;
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
      if (cDot.radiusDir == 1) {
        if (!(cDot.radius >= cDot.targetRadius)) {
          allRadiiReached = false;
        }
      } else {
        if (!(cDot.radius <= cDot.targetRadius)) {
          allRadiiReached = false;
        }
      }
    }
    if (uiOpt.U_DOT_STROKE_RANDOMIZE) {
      if (cDot.strokeDir == 1) {
        if (!(cDot.strokeWgt >= cDot.targetStroke)) {
          allStrokesReached = false;
        }
      } else {
        if (!(cDot.strokeWgt <= cDot.targetStroke)) {
          allStrokesReached = false;
        }
      }
    }
    // Check offset travel
    if (!(dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) < 1)) {
      allOffsetsReached = false;
    }
  }
  // If all dots have reached their destinations, setRadiusRandomize.
  if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
    if (allRadiiReached) {
      setRadiusRandomize(true);
    }
  }

  // If all dots have reached their strokes, setRadiusRandomize.
  if (uiOpt.U_DOT_STROKE_RANDOMIZE) {
    if (allStrokesReached) {
      setStrokeRandomize(true);
    }
  }

  if (allOffsetsReached) {
    setOffsetXY(uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
  }
}

void setRadius(x) {
  uiOpt.U_DOT_RADIUS = x;
  if (!uiOpt.U_DOT_RADIUS_RANDOMIZE) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.radius = x;
    }
  }
}

void setRadiusMin(x) {
  uiOpt.U_DOT_RADIUS_MIN = x;
  if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
    setRadiusRandomize(true);
  }
}

void setRadiusMax(x) {
  uiOpt.U_DOT_RADIUS_MAX = x;
  if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
    setRadiusRandomize(true);
  }
}

void setRadiusRandomize(randomize) {
  uiOpt.U_DOT_RADIUS_RANDOMIZE = randomize;
  if (randomize) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.targetRadius = random(uiOpt.U_DOT_RADIUS_MIN, uiOpt.U_DOT_RADIUS_MAX);
      if (cDot.targetRadius > cDot.radius) {
        cDot.radiusDir = 1;
      } else {
        cDot.radiusDir = -1;
      }
      cDot.radiusRate = (cDot.targetRadius - cDot.radius) / 50;
    }
  } else {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.radius = uiOpt.U_DOT_RADIUS;
    }
  }
}

void setStrokeWgtMin(x) {
  uiOpt.U_DOT_STROKE_WEIGHT_MIN = x;
  if (uiOpt.U_DOT_STROKE_RANDOMIZE) {
    setStrokeRandomize(true);
  }
}

void setStrokeWgtMax(x) {
  uiOpt.U_DOT_STROKE_WEIGHT_MAX = x;
  if (uiOpt.U_DOT_STROKE_RANDOMIZE) {
    setStrokeRandomize(true);
  }
}

void setStrokeRandomize(randomize) {
  uiOpt.U_DOT_STROKE_RANDOMIZE = randomize;
  if (randomize) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.targetStroke = random(uiOpt.U_DOT_STROKE_WEIGHT_MIN, uiOpt.U_DOT_STROKE_WEIGHT_MAX);
      if (cDot.targetStroke > cDot.strokeWgt) {
        cDot.strokeDir = 1;
      } else {
        cDot.strokeDir = -1;
      }
      cDot.strokeRate = (cDot.targetStroke - cDot.strokeWgt) / 50;
    }
  } else {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.strokeWgt = uiOpt.U_DOT_STROKE_WEIGHT;
    }
  }
}

void setStrokeColor(x) {
  uiOpt.U_DOT_SINGLE_STROKE_COLOR = color(x[0], x[1], x[2], x[3]*255);
  if (uiOpt.U_DOT_STROKE) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.strokeColor = uiOpt.U_DOT_SINGLE_STROKE_COLOR;
    }
  }
}

// void setStrokeColorOpacity(x) {
//   uiOpt.U_DOT_SINGLE_STROKE_COLOR = (uiOpt.U_DOT_SINGLE_STROKE_COLOR & 0xffffff) | (x << 24); 
//   if (uiOpt.U_DOT_STROKE){
//     for (int i = 0; i < dotArray.length; i++) {
//       Dot cDot = dotArray[i];
//       cDot.strokeColor = uiOpt.U_DOT_SINGLE_STROKE_COLOR;
//     }
//   }
// }

void setOffsetX(x) {
  uiOpt.U_DOT_OFFSET_X_MAX = x;
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    cDot.targetOffset.x = random(-1*uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_X_MAX);
    cDot.offsetRate = dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) / 50;
  }
}
void setOffsetY(y) {
  uiOpt.U_DOT_OFFSET_Y_MAX = y;
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    cDot.targetOffset.y = random(-1*uiOpt.U_DOT_OFFSET_Y_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
    cDot.offsetRate = dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) / 50;
  }
}

void setOffsetXY(x, y) {
  uiOpt.U_DOT_OFFSET_X_MAX = x;
  uiOpt.U_DOT_OFFSET_Y_MAX = y;
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    cDot.targetOffset.x = random(-1*uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_X_MAX);
    cDot.targetOffset.y = random(-1*uiOpt.U_DOT_OFFSET_Y_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
    cDot.offsetRate = dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) / 50;
  }
}


void setBG(x) {
  // Assume alpha is out of 1. Change to 255.
  uiOpt.U_BG_COLOR = color(x[0], x[1], x[2], x[3]*255);
}

// void setBGOpacity(x) {
//     uiOpt.U_BG_COLOR = (uiOpt.U_BG_COLOR & 0xffffff) | (x << 24); 
// }

void setFillColor(x, num) {
  color[] colors = [uiOpt.U_DOT_FILL_COLOR_1, uiOpt.U_DOT_FILL_COLOR_2, uiOpt.U_DOT_FILL_COLOR_3];
  if (num < 0 || num > 3) {
    console.log("NUM COLORS OUT OF RANGE", num);
    return;
  }
  color currColor = colors[num];
  color newColor = color(x[0], x[1], x[2], x[3]*255);
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    if (cDot.fillColorId == num) {
      // replace the prev color with new color
      cDot.fillColor = newColor;
    }
  }
  if (num == 0) {
    uiOpt.U_DOT_FILL_COLOR_1 = newColor;
  } else if (num == 1) {
    uiOpt.U_DOT_FILL_COLOR_2 = newColor;
  } else {
    uiOpt.U_DOT_FILL_COLOR_3 = newColor;
  }
}

void setFillNumColors(x) {
  uiOpt.U_DOT_FILL_NUM_COLORS = x;
  updateDotFills();
}

void updateDotFills() {
  color[] colors = [uiOpt.U_DOT_FILL_COLOR_1, uiOpt.U_DOT_FILL_COLOR_2, uiOpt.U_DOT_FILL_COLOR_3];
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    int nextId = getNextFillColorId(i);
    cDot.fillColor = colors[nextId];
    cDot.fillColorId = nextId;
  }
}

int getNextFillColorId(i) {
  if (uiOpt.U_DOT_FILL_COLOR_DIST == "Random") {
    nextId = int(random(uiOpt.U_DOT_FILL_NUM_COLORS));
  } 
  else if (uiOpt.U_DOT_FILL_COLOR_DIST == "Alternating") {
    nextId = i % uiOpt.U_DOT_FILL_NUM_COLORS;
  } 
  else if (uiOpt.U_DOT_FILL_COLOR_DIST == "Sorted") {
    int numDots = uiOpt.U_DOTS_PER_COL*uiOpt.U_DOTS_PER_ROW;
    if (uiOpt.U_DOT_FILL_NUM_COLORS == 3) {
      float tmp = i / numDots;
      if (tmp < 0.33) {
        nextId = 0;
      } else if (tmp < 0.66) {
        nextId = 1;
      } else {
        nextId = 2;
      }
    }
    else if (uiOpt.U_DOT_FILL_NUM_COLORS == 2) {
      if (i / float(numDots) < 0.5) {
        nextId = 0;
      } else {
        nextId = 1;
      }
    } else {
      nextId = 0;
    }
  } 
  else {
    console.log("Dist", d, "is not a recognized dist.");
    nextId = 0;
  }
  return nextId;
}

void setFillColorDist(d) {
  if (d == uiOpt.U_DOT_FILL_COLOR_DIST) {
    return ;
  }
  uiOpt.U_DOT_FILL_COLOR_DIST = d;
  updateDotFills();
}

void recalculatePadding() {
  console.log("recalc");
  uiOpt.IMG_PADDING_X = (uiOpt.IMG_WIDTH - ((uiOpt.U_DOTS_PER_ROW-1) * uiOpt.U_DOT_DIST_X)) / 2;
  uiOpt.IMG_PADDING_Y = (uiOpt.IMG_HEIGHT - ((uiOpt.U_DOTS_PER_COL-1) * uiOpt.U_DOT_DIST_Y)) / 2;
}

void setDotsPerRow(x) {
  console.log("Set");
  dotArray = {
  };
  uiOpt.U_DOTS_PER_ROW = x;
  recalculatePadding();
  initDots();
}

void setDotsPerCol(x) {
  dotArray = {
  };
  uiOpt.U_DOTS_PER_COL = x;
  recalculatePadding();
  initDots();
}

void setDotDistXY(x, y) {
  uiOpt.U_DOT_DIST_X = x;
  uiOpt.U_DOT_DIST_Y = y;
  recalculatePadding();
  int c = 0;
  for (int i = 0; i < uiOpt.U_DOTS_PER_COL; i++) {
    for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
      Dot cDot = dotArray[c];

      // Init position
      cDot.setPos(uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST_X * j, uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST_Y);
      c += 1;
    }
  }
}

void setDotDistX(x) {
  setDotDistXY(x, uiOpt.U_DOT_DIST_Y);
}

void setDotDistY(y) {
  setDotDistXY(uiOpt.U_DOT_DIST_X, y);
}


void resizeImg() {
  // Determine new height and width
  uiOpt.IMG_HEIGHT = window.innerHeight*window.devicePixelRatio;
  uiOpt.IMG_WIDTH = window.innerWidth*window.devicePixelRatio;

  recalculatePadding();

  // Determine new dot positions
  int c = 0;
  for (int i = 0; i < uiOpt.U_DOTS_PER_COL; i++) {
    for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
      Dot cDot = dotArray[c];

      // Init position
      cDot.setPos(uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST_X * j, uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST_Y);
      c += 1;
    }
  }

  size(uiOpt.IMG_WIDTH, uiOpt.IMG_HEIGHT);
}

//// DRAWING CODE

void setup() {
  uiOpt = new UIOpt();
  size(uiOpt.IMG_WIDTH, uiOpt.IMG_HEIGHT);
  smooth(3); 
  background(uiOpt.U_BG_COLOR);
  frameRate(30);
  initDots();
}

void initDots() {
  color[] colors = [uiOpt.U_DOT_FILL_COLOR_1, uiOpt.U_DOT_FILL_COLOR_2, uiOpt.U_DOT_FILL_COLOR_3];
  int curr = 0;
  for (int i = 0; i < uiOpt.U_DOTS_PER_COL; i++) {
    for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
      Dot newDot = new Dot();

      // Init position
      int x1 = uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST_X * j;
      int y1 = uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST_Y;
      newDot.setPos(x1, y1);

      // Init radius
      if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
        newDot.radius = random(uiOpt.U_DOT_RADIUS_MIN, uiOpt.U_DOT_RADIUS_MAX);
      } else {
        newDot.radius = uiOpt.U_DOT_RADIUS;
      }

      // Init stroke
      newDot.strokeColor = uiOpt.U_DOT_SINGLE_STROKE_COLOR;
      if (uiOpt.U_DOT_STROKE_RANDOMIZE) {
        newDot.strokeWgt = random(uiOpt.U_DOT_STROKE_WEIGHT);
      } else {
        newDot.strokeWgt = uiOpt.U_DOT_STROKE_WEIGHT;
      }
      int nextId = getNextFillColorId(curr);
      newDot.fillColor = colors[nextId];
      newDot.fillColorId = nextId;

      // Init offset
      float offsetX = random(-1*uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_X_MAX);
      float offsetY = random(-1*uiOpt.U_DOT_OFFSET_Y_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
      newDot.setOffset(offsetX, offsetY);

      // Add dot to array
      dotArray = (Dot[]) append(dotArray, newDot);
      curr += 1;
    }
  }
  setRadiusRandomize(uiOpt.U_DOT_RADIUS_RANDOMIZE);
  setStrokeRandomize(uiOpt.U_DOT_STROKE_RANDOMIZE);
  setOffsetXY(uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
}

void draw() {
  // update frame rate display
  frameRateEl.innerHTML = round(frameRate, 3);

  if (!uiOpt.U_DRAW) {
    return;
  } 

  translate(-width/2, -height/2);
  scale(2);  

  background(uiOpt.U_BG_COLOR);

  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    cDot.drawDot();
  }
  checkDotConditions();
}

void printColor(color c) {
  println(red(c) +", " + blue(c) + ", " + green(c));
}
String colorToRGB(color c) {
  return [red(c), green(c), blue(c), round((alpha(c)/255.0)*100)*0.01];
}
boolean randBool(x) {
  // where x is the chance out of 1 of true
  if (random(1) < x) {
    return true;
  } 
  return false;
}
int randInt(x,y) {
  // int x is the min
  // int y is the max
  return int(random(x,y+1)); 
}
