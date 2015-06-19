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
  boolean U_DOT_FILL;
  boolean U_DOT_RADIUS_RANDOMIZE;
  boolean U_DOT_OFFSET;

  // draw iterations
  int U_NUM_ITERS;
  int U_NUM_ITERS_MAX;

  // dot center offset
  float U_DOT_OFFSET_MAX;
  float U_DOT_OFFSET_PRE;

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
  int U_DOT_SINGLE_STROKE_COLOR;
  //// END CUSTOMIZABLE PARAMS

  //// PREDEFINED PARAMS
  int IMG_HEIGHT;
  int IMG_WIDTH;
  int U_DOTS_PER_ROW;
  int U_DOT_DIST;
  int IMG_PADDING;
  int MAX_DOTS_PER_ROW;
  //// END PREDEFINED PARAMS
  
  UIOpt() {
    U_DRAW = true;
    U_DRAW = false;
    U_DOT_FILL_THEME = true;
    U_DOT_STROKE = false;
    U_DOT_FILL = true;
    U_DOT_RADIUS_RANDOMIZE = true;
    U_DOT_OFFSET = true;

    // draw iterations
    U_NUM_ITERS = 1;
    U_NUM_ITERS_MAX = 20;

    // dot center offset
    U_DOT_OFFSET_MAX = 0;

    // dot radius
    U_DOT_RADIUS = 10;
    U_DOT_RADIUS_MIN = 3;
    U_DOT_RADIUS_MAX = 15;

    // background color
    U_BG_COLOR = "#FFFDF7";

    // dot fill single color 
    U_DOT_SINGLE_FILL_COLOR = "#c80064";

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
    U_DOT_SINGLE_STROKE_COLOR = "#323232";
    //// END CUSTOMIZABLE PARAMS

    //// PREDEFINED PARAMS
    IMG_HEIGHT = 500;
    IMG_WIDTH = IMG_HEIGHT;
    U_DOTS_PER_ROW = 9;
    U_DOT_DIST = 20;
    IMG_PADDING = (IMG_WIDTH - ((U_DOTS_PER_ROW-1) * U_DOT_DIST)) / 2;
    MAX_DOTS_PER_ROW = 1000;
    //// END PREDEFINED PARAMS
  }
};

UIOpt uiOpt;

void getUiOpt() {
  uiOpt.U_DRAW = true;
  return uiOpt;
}

// DOT CLASS DEF
class Dot {
  PVector pos;
  PVector offset;
  float radius; 
  float strokeWgt;
  color strokeColor, fillColor; 
  float targetRadius;
  float radiusRate;
  int radiusDir;

  Dot() {
    pos = new PVector();
    offset = new PVector();
  }

  void setPos(int x, int y) {
    pos.x = x;
    pos.y = y;
  }

  void setOffset(float x, float y){
    offset.x = x;
    offset.y = y;
  }

  void drawDot() {
  // Determine stroke 
  if (uiOpt.U_DOT_STROKE) {
    stroke(strokeColor);
    strokeWeight(uiOpt.U_DOT_STROKE_WEIGHT);
  } else {
    noStroke();
  }
  // Determine fill
  if (uiOpt.U_DOT_FILL) {
    fill(fillColor);
  } else {
    noFill();
  }

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

  ellipse(pos.x+offset.x,pos.y+offset.y,radius,radius);
  }
};

  

Dot[] dotArray = {};

void checkDotConditions() {
  if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[int(random(dotArray.length))];
      if (cDot.radiusDir == 1) {
        if (!(cDot.radius >= cDot.targetRadius)) {
          return;
        }
      } else {
          if (!(cDot.radius <= cDot.targetRadius)) {
            return;
          }
      }
    }
    setRadiusRandomize(true);
  }
}

void setOffset(x) {
  uiOpt.U_DOT_OFFSET_MAX = x;
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    cDot.offset.x = random(-1*uiOpt.U_DOT_OFFSET_MAX, uiOpt.U_DOT_OFFSET_MAX);
    cDot.offset.y = random(-1*uiOpt.U_DOT_OFFSET_MAX, uiOpt.U_DOT_OFFSET_MAX);
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
void setBG(x) {
  uiOpt.U_BG_COLOR = color(x[0],x[1],x[2]);
}

void setStrokeColor(x){
  uiOpt.U_DOT_SINGLE_STROKE_COLOR = color(x[0],x[1],x[2]);
  if (uiOpt.U_DOT_STROKE){
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.strokeColor = uiOpt.U_DOT_SINGLE_STROKE_COLOR;
    }
  }
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

void setDotsPerRow(x) {
  dotArray = {};
  uiOpt.U_DOTS_PER_ROW = x;
  uiOpt.IMG_PADDING = (uiOpt.IMG_WIDTH - ((uiOpt.U_DOTS_PER_ROW-1) * uiOpt.U_DOT_DIST)) / 2;
  initDots();
}

void setDotDist(distance) {
  uiOpt.U_DOT_DIST = distance;
  uiOpt.IMG_PADDING = (uiOpt.IMG_WIDTH - ((uiOpt.U_DOTS_PER_ROW-1) * uiOpt.U_DOT_DIST)) / 2;
  int c = 0;
  for (int i = 0; i < uiOpt.U_DOTS_PER_ROW; i++) {
    for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
      Dot cDot = dotArray[c];

      // Init position
      cDot.setPos(uiOpt.IMG_PADDING + uiOpt.U_DOT_DIST * j,uiOpt.IMG_PADDING + i * uiOpt.U_DOT_DIST);
      c += 1;
    }
  }
}

//// DRAWING CODE
void setup() {
  uiOpt = new UIOpt();
  size(uiOpt.IMG_HEIGHT, uiOpt.IMG_WIDTH);
  smooth(); 
  background(uiOpt.U_BG_COLOR);
  frameRate(24);

  initDots();
}

void initDots() {
  // for (int ite = 0; ite < U_NUM_ITERS; ite++) {
    for (int i = 0; i < uiOpt.U_DOTS_PER_ROW; i++) {
      for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
        Dot newDot = new Dot();

        // Init position
        int x1 = uiOpt.IMG_PADDING + uiOpt.U_DOT_DIST * j;
        int y1 = uiOpt.IMG_PADDING + i * uiOpt.U_DOT_DIST;
        newDot.setPos(x1,y1);

        // Init radius
        if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
          newDot.radius = random(uiOpt.U_DOT_RADIUS_MIN, uiOpt.U_DOT_RADIUS_MAX);
        } else {
          newDot.radius = uiOpt.U_DOT_RADIUS;
        }

        // Init stroke
        newDot.strokeColor = uiOpt.U_DOT_SINGLE_STROKE_COLOR;
        newDot.strokeWgt = uiOpt.U_DOT_STROKE_WEIGHT;
        
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

  if (!uiOpt.U_DRAW) {
    // uiOpt.U_DRAW = false;
  }
}

//void keyPressed() {
//  if (keyCode == ENTER) {
//    saveFrame("../screenshots/screen-"+str(random(1000000))+".jpg");
//  }
//}
void printColor(color c) {
  println(red(c), blue(c), green(c));
}
