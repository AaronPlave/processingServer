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
// hint(DISABLE_OPENGL_2X_SMOOTH);

class UIOpt {
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
  int U_DOT_SINGLE_STROKE_COLOR_R;
  int U_DOT_SINGLE_STROKE_COLOR_G;
  int U_DOT_SINGLE_STROKE_COLOR_B;
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
    U_DOT_FILL_THEME = true;
    U_DOT_STROKE = true;
    U_DOT_FILL = true;
    U_DOT_RADIUS_RANDOMIZE = true;
    U_DOT_OFFSET = true;

    // draw iterations
    U_NUM_ITERS = 1;
    U_NUM_ITERS_MAX = 20;

    // dot center offset
    U_DOT_OFFSET_MAX = 0;

    // dot radius
    U_DOT_RADIUS = 5;
    U_DOT_RADIUS_MIN = 1;
    U_DOT_RADIUS_MAX = 10;

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
    U_DOT_SINGLE_STROKE_COLOR_R = 50;
    U_DOT_SINGLE_STROKE_COLOR_G = 50;
    U_DOT_SINGLE_STROKE_COLOR_B = 50;
    //// END CUSTOMIZABLE PARAMS

    //// PREDEFINED PARAMS
    IMG_HEIGHT = 300;
    IMG_WIDTH = IMG_HEIGHT;
    U_DOTS_PER_ROW = 20;
    U_DOT_DIST = 10;
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

  ellipse(pos.x+offset.x,pos.y+offset.y,radius*2,radius*2);
  }
};

Dot[] dotArray = {};

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
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.radius = random(uiOpt.U_DOT_RADIUS_MIN, uiOpt.U_DOT_RADIUS_MAX);
    }
  }
}

void setRadiusMax(x) {
  uiOpt.U_DOT_RADIUS_MAX = x;
  if (uiOpt.U_DOT_RADIUS_RANDOMIZE) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.radius = random(uiOpt.U_DOT_RADIUS_MIN, uiOpt.U_DOT_RADIUS_MAX);
    }
  }
}

void setRadiusRandomize(randomize) {
  uiOpt.U_DOT_RADIUS_RANDOMIZE = randomize;
  if (randomize) {
    for (int i = 0; i < dotArray.length; i++) {
      Dot cDot = dotArray[i];
      cDot.radius = random(uiOpt.U_DOT_RADIUS_MIN, uiOpt.U_DOT_RADIUS_MAX);
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
        }

        // Init stroke
        newDot.strokeColor = color(uiOpt.U_DOT_SINGLE_STROKE_COLOR_R, uiOpt.U_DOT_SINGLE_STROKE_COLOR_G, uiOpt.U_DOT_SINGLE_STROKE_COLOR_B);
        newDot.strokeWgt = uiOpt.U_DOT_STROKE_WEIGHT;
        
        // Init fill
        int[] rgb = uiOpt.U_DOT_FILL_THEME_COLORS[int(random(0, uiOpt.U_DOT_FILL_THEME_COLORS.length))];
        newDot.fillColor = color(rgb[0], rgb[1], rgb[2]);

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
  // }
}

void draw() {
  if (!(uiOpt.U_DRAW)) {
    // return;
  }

 background(uiOpt.U_BG_COLOR);
 for (int i = 0; i < dotArray.length; i++) {
  Dot cDot = dotArray[i];
  cDot.drawDot();
 }

 uiOpt.U_DRAW = false;

}

//void keyPressed() {
//  if (keyCode == ENTER) {
//    saveFrame("../screenshots/screen-"+str(random(1000000))+".jpg");
//  }
//}
void printColor(color c) {
  println(red(c), blue(c), green(c));
}
