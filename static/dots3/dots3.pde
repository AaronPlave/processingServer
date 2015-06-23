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
  boolean U_DOT_FILL_THEME;
  boolean U_DOT_STROKE;
  boolean U_DOT_STROKE_RANDOMIZE;
  boolean U_DOT_FILL;
  boolean U_DOT_RADIUS_RANDOMIZE;
  boolean U_DOT_OFFSET;

  // draw iterations
  int U_NUM_ITERS;
  int U_NUM_ITERS_MAX;

  // dot center offset
  float U_DOT_OFFSET_MAX;

  // dot radius
  int U_DOT_RADIUS;
  int U_DOT_RADIUS_MIN;
  int U_DOT_RADIUS_MAX;

  // background color
  color U_BG_COLOR;

  // dot fill single color 
  color U_DOT_SINGLE_FILL_COLOR;

  // dot fill theme colors 
  int[][] U_DOT_FILL_THEME_COLORS;

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
  int U_DOT_DIST;
  int IMG_PADDING_X;
  int IMG_PADDING_Y;
  //// END PREDEFINED PARAMS
  
  UIOpt() {
    U_DRAW = true;
    U_DOT_FILL_THEME = true;
    U_DOT_STROKE = false;
    U_DOT_STROKE_RANDOMIZE = false;
    U_DOT_FILL = true;
    U_DOT_RADIUS_RANDOMIZE = true;
    U_DOT_OFFSET = true;

    // draw iterations
    U_NUM_ITERS = 1;
    U_NUM_ITERS_MAX = 20;

    // dot center offset
    U_DOT_OFFSET_MAX = 3;

    // dot radius
    U_DOT_RADIUS = 10;
    U_DOT_RADIUS_MIN = 3;
    U_DOT_RADIUS_MAX = 25;

    // background color
    U_BG_COLOR = color(255,253,247);

    // dot fill single color 
    U_DOT_SINGLE_FILL_COLOR = color(20,253,247);

    // dot fill theme colors 
    U_DOT_FILL_THEME_COLORS = {
      {
        255, 229, 110
      }
      , {
        215, 25, 32
      }
      , {
        0, 0, 0
      }
    };

    // dot stroke
    U_DOT_STROKE_WEIGHT = 0.5;
    U_DOT_STROKE_WEIGHT_MIN  = 0.5;
    U_DOT_STROKE_WEIGHT_MAX = 5;
    U_DOT_SINGLE_STROKE_COLOR = color(255,0,247);
    //// END CUSTOMIZABLE PARAMS

    //// PREDEFINED PARAMS
    IMG_HEIGHT = window.innerHeight;
    IMG_WIDTH = window.innerWidth;
    U_DOTS_PER_ROW = 10;
    U_DOT_DIST = 25;
    IMG_PADDING_X = (IMG_WIDTH - ((U_DOTS_PER_ROW-1) * U_DOT_DIST)) / 2;
    IMG_PADDING_Y = (IMG_HEIGHT - ((U_DOTS_PER_ROW-1) * U_DOT_DIST)) / 2;
    MAX_DOTS_PER_ROW = 1000;
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
      console.log(c);
      newOpt[keys[i]] = color(c[0],c[1],c[2]);
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

  void setOffset(float x, float y){
    offset.x = x;
    offset.y = y;
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

    PVector dirOfTravel = PVector.sub(targetOffset,offset);
    dirOfTravel.normalize();
    offset.add(PVector.mult(dirOfTravel,offsetRate));

    ellipse(pos.x+offset.x,pos.y+offset.y,radius,radius);
  }
};

  

Dot[] dotArray = {};

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
    if (!(dist(cDot.offset.x,cDot.offset.y,cDot.targetOffset.x,cDot.targetOffset.y) < 1)) {
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
    setOffset(uiOpt.U_DOT_OFFSET_MAX);
  }
  // }
  // Dot cDot = dotArray[0];
  // if (!(dist(cDot.offset.x,cDot.offset.y,cDot.targetOffset.x,cDot.targetOffset.y) < 1)) {

  // } else {
  //   setOffset(uiOpt.U_DOT_OFFSET_MAX);
  // }

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
      cDot.targetStroke = random(uiOpt.U_DOT_STROKE_WEIGHT_MIN,uiOpt.U_DOT_STROKE_WEIGHT_MAX);
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
  uiOpt.U_DOT_SINGLE_STROKE_COLOR = color(x[0],x[1],x[2]);
  if (uiOpt.U_DOT_STROKE){
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.strokeColor = uiOpt.U_DOT_SINGLE_STROKE_COLOR;
    }
  }
}

void setOffset(x) {
  uiOpt.U_DOT_OFFSET_MAX = x;
  for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.targetOffset.x = random(-1*uiOpt.U_DOT_OFFSET_MAX, uiOpt.U_DOT_OFFSET_MAX);
      cDot.targetOffset.y = random(-1*uiOpt.U_DOT_OFFSET_MAX, uiOpt.U_DOT_OFFSET_MAX);
      cDot.offsetRate = dist(cDot.offset.x,cDot.offset.y,cDot.targetOffset.x,cDot.targetOffset.y) / 50;
    }
}

void setBG(x) {
  uiOpt.U_BG_COLOR = color(x[0],x[1],x[2]);
}


void setSingleFillColor(x) {
  uiOpt.U_DOT_SINGLE_FILL_COLOR = color(x[0],x[1],x[2]);
  if (!uiOpt.U_DOT_FILL_THEME){
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.fillColor = uiOpt.U_DOT_SINGLE_FILL_COLOR;
    }
  }
}

void setTheme(themeOn) {
  uiOpt.U_DOT_FILL_THEME = themeOn
  if (themeOn) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      int[] rgb = uiOpt.U_DOT_FILL_THEME_COLORS[int(random(0, uiOpt.U_DOT_FILL_THEME_COLORS.length))];
      cDot.fillColor = color(rgb[0], rgb[1], rgb[2]);
    }
  } else {
      for (int i = 0; i < dotArray.length; i++) {
        Dot cDot = dotArray[i];
        cDot.fillColor = uiOpt.U_DOT_SINGLE_FILL_COLOR;
      }
    }
}

void recalculatePadding() {
    uiOpt.IMG_PADDING_X = (uiOpt.IMG_WIDTH - ((uiOpt.U_DOTS_PER_ROW-1) * uiOpt.U_DOT_DIST)) / 2;
    uiOpt.IMG_PADDING_Y = (uiOpt.IMG_HEIGHT - ((uiOpt.U_DOTS_PER_ROW-1) * uiOpt.U_DOT_DIST)) / 2;
}
void setDotsPerRow(x) {
  dotArray = {};
  uiOpt.U_DOTS_PER_ROW = x;
  initDots();
  recalculatePadding();
}

void setDotDist(distance) {
  uiOpt.U_DOT_DIST = distance;
  recalculatePadding();
  int c = 0;
  for (int i = 0; i < uiOpt.U_DOTS_PER_ROW; i++) {
    for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
      Dot cDot = dotArray[c];

      // Init position
      cDot.setPos(uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST * j,uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST);
      c += 1;
    }
  }
}

void resizeImg() {
  // Determine new height and width
  uiOpt.IMG_HEIGHT = window.innerHeight;
  uiOpt.IMG_WIDTH = window.innerWidth;

  recalculatePadding();

  // Determine new dot positions
  int c = 0;
  for (int i = 0; i < uiOpt.U_DOTS_PER_ROW; i++) {
    for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
      Dot cDot = dotArray[c];

      // Init position
      cDot.setPos(uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST * j,uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST);
      c += 1;
    }
  }

  size(uiOpt.IMG_WIDTH, uiOpt.IMG_HEIGHT);

}

//// DRAWING CODE
void setup() {
  uiOpt = new UIOpt();
  size(uiOpt.IMG_WIDTH, uiOpt.IMG_HEIGHT);
  smooth(8); 
  background(uiOpt.U_BG_COLOR);
  frameRate(30);

  initDots();
}

void initDots() {
  // for (int ite = 0; ite < U_NUM_ITERS; ite++) {
    for (int i = 0; i < uiOpt.U_DOTS_PER_ROW; i++) {
      for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
        Dot newDot = new Dot();

        // Init position
        int x1 = uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST * j;
        int y1 = uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST;
        newDot.setPos(x1,y1);

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
        
        // Init fill
        if (uiOpt.U_DOT_FILL_THEME) {
          int[] rgb = uiOpt.U_DOT_FILL_THEME_COLORS[int(random(0, uiOpt.U_DOT_FILL_THEME_COLORS.length))];
          newDot.fillColor = color(rgb[0], rgb[1], rgb[2]);
        } else {
          newDot.fillColor = uiOpt.U_DOT_SINGLE_FILL_COLOR;
        }

        // Init offset
        float offsetX = 0;
        float offsetY = 0;
        if (uiOpt.U_DOT_OFFSET) {
          offsetX = random(-1*uiOpt.U_DOT_OFFSET_MAX, uiOpt.U_DOT_OFFSET_MAX);
          offsetY = random(-1*uiOpt.U_DOT_OFFSET_MAX, uiOpt.U_DOT_OFFSET_MAX);
        }
        newDot.setOffset(offsetX,offsetY);

        // Add dot to array
        dotArray = (Dot[]) append(dotArray, newDot);
      }
    }
    setRadiusRandomize(uiOpt.U_DOT_RADIUS_RANDOMIZE);
    setStrokeRandomize(uiOpt.U_DOT_STROKE_RANDOMIZE);
    setOffset(uiOpt.U_DOT_OFFSET_MAX);
  // }
}

void draw() {
  if (!uiOpt.U_DRAW) {
    return;
  } 

  background(uiOpt.U_BG_COLOR);
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    cDot.drawDot();
  }
  checkDotConditions();
}

//void keyPressed() {
//  if (keyCode == ENTER) {
//    saveFrame("../screenshots/screen-"+str(random(1000000))+".jpg");
//  }
//}
void printColor(color c) {
  println(red(c) +", " + blue(c) + ", " + green(c));
}
String colorToRGB(color c) {
  return [red(c),green(c),blue(c)];
}
