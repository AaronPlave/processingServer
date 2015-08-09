// DOTS GENERATOR
// AARON PLAVE
// aaronplave@gmail.com

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


// ENABLE FOR PREDETERMINED DOT UIOPT PARAMS FOR TESTING
boolean TEST_MODE = true;

class UIOpt {
  boolean U_DRAW;
  boolean U_DOT_STROKE;
  boolean U_DOT_STROKE_RANDOMIZE;
  boolean U_DOT_FILL;
  boolean U_DOT_RADIUS_RANDOMIZE;
  boolean U_DOT_OFFSET;

  // canvas zoom
  float U_ZOOM;

  // dot center offset
  float U_DOT_OFFSET_X_MAX;
  float U_DOT_OFFSET_Y_MAX;

  float U_DOT_ROTATION;

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
  int U_DOT_ANIMATION_SPEED;
  int U_DOT_ANIMATION_SPEED_MIN;
  int U_DOT_ANIMATION_SPEED_MAX;
  //// END PREDEFINED PARAMS

  UIOpt() {
    U_DRAW = true;
    if (TEST_MODE) {
      U_DOT_FILL = true;
      U_DOT_STROKE = false;
      U_DOT_FILL_NUM_COLORS = 3;
      U_ZOOM = 2.5;
      U_DOT_ROTATION = 0;
      U_DOTS_PER_ROW = 10;
      U_DOTS_PER_COL = 10;
      U_DOT_DIST_X = 20;
      U_DOT_DIST_Y = 20;
      U_DOT_ANIMATION_SPEED_MIN = 500;
      U_DOT_ANIMATION_SPEED_MAX = 15;
      U_DOT_ANIMATION_SPEED = 93;
      U_DOT_OFFSET_X_MAX = 0;
      U_DOT_OFFSET_Y_MAX = 0;
      U_DOT_RADIUS_RANDOMIZE = false;
      U_DOT_RADIUS = 15;
      U_DOT_RADIUS_MIN = 1;
      U_DOT_RADIUS_MAX = 5;
      U_BG_COLOR = color(255,249,233,255);
      U_DOT_FILL_COLOR_1 = color(255, 229, 110, 255);
      U_DOT_FILL_COLOR_2 = color(215, 25, 32, 255);
      U_DOT_FILL_COLOR_3 = color(0, 0, 0, 255);
      int _rand = 3;
      if (_rand == 1) {
        U_DOT_FILL_COLOR_DIST = "Random";
      } else if (_rand == 2) {
        U_DOT_FILL_COLOR_DIST = "Alternating";
      } else {
        U_DOT_FILL_COLOR_DIST = "Sorted";
      }
       // dot stroke
      U_DOT_STROKE_RANDOMIZE = false;
      U_DOT_STROKE_WEIGHT = 0.5;
      U_DOT_STROKE_WEIGHT_MIN  = 0.2;
      U_DOT_STROKE_WEIGHT_MAX = 0.7;
      U_DOT_SINGLE_STROKE_COLOR = color(0,0,0,0);
    }
    else {
      U_DOT_FILL = randBool(0.75);
      if (U_DOT_FILL) {
        // small chance to combine fill + stroke
        U_DOT_STROKE = randBool(0.15);
      } else {
        // if no fill, must have stroke
        U_DOT_STROKE = true;
      }
      U_DOT_ANIMATION_SPEED_MIN = 500;
      U_DOT_ANIMATION_SPEED_MAX = 10;
      U_DOT_ANIMATION_SPEED = randInt(U_DOT_ANIMATION_SPEED_MIN,U_DOT_ANIMATION_SPEED_MAX);

      // Rotation degree
      U_DOT_ROTATION = randInt(0,360);
      U_ZOOM = 2.5;
      U_DOTS_PER_ROW = randInt(1,50);
      U_DOTS_PER_COL = randInt(1,50);
      U_DOT_DIST_X = randInt(0,100);
      U_DOT_DIST_Y = randInt(0,100);
      // dot center offset
      U_DOT_OFFSET_X_MAX = randInt(0,100);
      U_DOT_OFFSET_Y_MAX = randInt(0,100);
      U_DOT_RADIUS_RANDOMIZE = randBool(0.75);
      // dot radius
      U_DOT_RADIUS = randInt(0.1,20);
      U_DOT_RADIUS_MIN = randInt(0.1,5);
      U_DOT_RADIUS_MAX = int(random(U_DOT_RADIUS_MIN, 200));
      // background color
      U_BG_COLOR = color(random(255),random(255),random(255),255);
      // dot fill colors 
      U_DOT_FILL_NUM_COLORS = randInt(1,3);
      U_DOT_FILL_COLOR_1 = color(abs(abs(51-red(U_BG_COLOR))-255),abs(abs(51-green(U_BG_COLOR))-255),abs(abs(51-blue(U_BG_COLOR))-255),random(255));
      U_DOT_FILL_COLOR_2 = color(abs(abs(102-red(U_BG_COLOR))-255),abs(abs(102-green(U_BG_COLOR))-255),abs(abs(102-blue(U_BG_COLOR))-255),random(255));
      U_DOT_FILL_COLOR_3 = color(abs(abs(153-red(U_BG_COLOR))-255),abs(abs(153-green(U_BG_COLOR))-255),abs(abs(153-blue(U_BG_COLOR))-255),random(255));
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
    } 
   
    IMG_HEIGHT = window.innerHeight*window.devicePixelRatio;
    IMG_WIDTH = window.innerWidth*window.devicePixelRatio;
    
    IMG_PADDING_X = (IMG_WIDTH - ((U_DOTS_PER_ROW-1) * U_DOT_DIST_X)) / 2;
    IMG_PADDING_Y = (IMG_HEIGHT - ((U_DOTS_PER_COL-1) * U_DOT_DIST_Y)) / 2;
  }
};


UIOpt uiOpt;

void reset() {
  uiOpt = new UIOpt();
  dotArray = {};
  background(uiOpt.U_BG_COLOR);
  initDots();
};

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
  PVector spacingFactor;
  PVector prevOffset;
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
    pos = new PVector();
    offset = new PVector();
    spacingFactor = new PVector();
    targetOffset = new PVector();
    prevOffset = new PVector();
  }

  void setPos(int x, int y) {
    pos.x = x;
    pos.y = y;
  }

  void setOffset(float x, float y) {
    offset.x = x;
    offset.y = y;
  }

  void setSpacingFactor(float x, float y) {
    spacingFactor.x = x;
    spacingFactor.y = y;
  }

  PVector getRealPos() {
    PVector realPos = new PVector();
    realPos.x = pos.x+uiOpt.U_DOT_DIST_X*spacingFactor.x;
    realPos.y = pos.y+uiOpt.U_DOT_DIST_Y*spacingFactor.y;
    return realPos;
  }

  boolean isInView() {
    int pX = pos.x + offset.x + radius + uiOpt.U_DOT_DIST_X*spacingFactor.x - uiOpt.IMG_WIDTH/2;
    int pY = pos.y + offset.y + radius + uiOpt.U_DOT_DIST_Y*spacingFactor.y - uiOpt.IMG_HEIGHT/2;

    int pXRot = pX*cos(radians(uiOpt.U_DOT_ROTATION))+pY*sin(radians(uiOpt.U_DOT_ROTATION));
    int pYRot = pX*(-1*sin(radians(uiOpt.U_DOT_ROTATION)))+pY*cos(radians(uiOpt.U_DOT_ROTATION));
    
    pXRot += uiOpt.IMG_WIDTH/2;
    pYRot += uiOpt.IMG_HEIGHT/2;

    int leftBoundX = (uiOpt.IMG_WIDTH - uiOpt.IMG_WIDTH*uiOpt.U_ZOOM)/2;
    int leftBoundY = (uiOpt.IMG_HEIGHT - uiOpt.IMG_HEIGHT*uiOpt.U_ZOOM)/2;


    int rightBoundX = (window.innerWidth*window.devicePixelRatio - window.innerWidth*window.devicePixelRatio*uiOpt.U_ZOOM)/2;
    int rightBoundY = (window.innerHeight*window.devicePixelRatio - window.innerHeight*window.devicePixelRatio*uiOpt.U_ZOOM)/2;

    if (pXRot < -leftBoundY || pXRot > window.innerWidth*window.devicePixelRatio) {
      return false;
    } 
    if (pYRot < -leftBoundX || pYRot > window.innerHeight*window.devicePixelRatio) {
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

    // Determine stroke 
    if (uiOpt.U_DOT_STROKE) {
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

    // Determine offset travel
    PVector dirOfTravel = PVector.sub(targetOffset, offset);
    float totalDist = abs(dist(targetOffset.x,targetOffset.y,prevOffset.x,prevOffset.y));
    // console.log("offset",offset,"targetOffset",targetOffset,"prev",prevOffset);
    float progress = abs(dist(targetOffset.x,targetOffset.y,offset.x,offset.y));
    if (totalDist < 0.1) {
      float speedFactor = 0.01;
    } else {
      if (progress > totalDist) {
      float speedFactor = 0.01 + sin((totalDist/progress)*PI);
      } else {
        float speedFactor = 0.01 + sin((progress/totalDist)*PI);
        // float speedFactor = 0.01 + sin((totalDist/progress)*PI);
      }
    }
    dirOfTravel.normalize();
    // console.log("offsetRate:",offsetRate,"speedFactor:",speedFactor,"progress:",progress,"totalDist:",totalDist, "prev",prevOffset,"tar:",targetOffset,"off",offset);
    // console.log("speedFactor",speedFactor);
    // console.log("totalDist",totalDist);
    // console.log("totalDist",totalDist);
    // console.log("progress",progress);
    offset.add(PVector.mult(dirOfTravel, offsetRate*speedFactor));

    // Determine if dot is onscreen, if so, draw.
    // if (isInView()) {
    ellipse(pos.x+offset.x+uiOpt.U_DOT_DIST_X*spacingFactor.x, 
            pos.y+offset.y+uiOpt.U_DOT_DIST_Y*spacingFactor.y, 
            radius, radius);
      // console.log(pos.x+offset.x+uiOpt.U_DOT_DIST_X*spacingFactor.x);
    // }
  }
};

Dot[] dotArray = {
};

void checkDotConditions() {
  // Check radius travel
  boolean allRadiiReached = true;
  boolean allStrokesReached = true;

  int numOffsetsReached = 0;
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
    if (dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) < 3) {
      numOffsetsReached += 1;
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

  if ((numOffsetsReached/float(dotArray.length)) == 1) {
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
      cDot.radiusRate = (cDot.targetRadius - cDot.radius) / uiOpt.U_DOT_ANIMATION_SPEED;
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
      cDot.strokeRate = (cDot.targetStroke - cDot.strokeWgt) / uiOpt.U_DOT_ANIMATION_SPEED;
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
    if (!(cDot.targetOffset.x)) {
      cDot.prevOffset.x = cDot.offset.x;
    } else {
      cDot.prevOffset.x = cDot.targetOffset.x;
    }
    cDot.targetOffset.x = random(-1*uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_X_MAX);
    cDot.offsetRate = dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) / uiOpt.U_DOT_ANIMATION_SPEED;
  }
}
void setOffsetY(y) {
  uiOpt.U_DOT_OFFSET_Y_MAX = y;
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    if (!(cDot.targetOffset.y)) {
      cDot.prevOffset.y = cDot.offset.y;
    } else {
      cDot.prevOffset.y = cDot.targetOffset.y;
    }
    cDot.targetOffset.y = random(-1*uiOpt.U_DOT_OFFSET_Y_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
    cDot.offsetRate = dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) / uiOpt.U_DOT_ANIMATION_SPEED;
  }
}

void setOffsetXY(x, y) {
  uiOpt.U_DOT_OFFSET_X_MAX = x;
  uiOpt.U_DOT_OFFSET_Y_MAX = y;
  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    if (!(cDot.targetOffset.x)) {
      cDot.prevOffset.x = cDot.offset.x;
    } else {
      cDot.prevOffset.x = cDot.targetOffset.x;
    }
    if (!(cDot.targetOffset.y)) {
      cDot.prevOffset.y = cDot.offset.y;
    } else {
      cDot.prevOffset.y = cDot.targetOffset.y;
    }
    cDot.targetOffset.x = random(-1*uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_X_MAX);
    cDot.targetOffset.y = random(-1*uiOpt.U_DOT_OFFSET_Y_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
    cDot.offsetRate = dist(cDot.offset.x, cDot.offset.y, cDot.targetOffset.x, cDot.targetOffset.y) / uiOpt.U_DOT_ANIMATION_SPEED;
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

void setAnimationSpeed(x) {
  uiOpt.U_DOT_ANIMATION_SPEED = calcValueInRange(x,0,100,uiOpt.U_DOT_ANIMATION_SPEED_MIN,uiOpt.U_DOT_ANIMATION_SPEED_MAX);
  if (uiOpt.U_DOT_ANIMATION_SPEED == 0) {
    uiOpt.U_DOT_ANIMATION_SPEED = 1;
  }
  setRadiusRandomize(uiOpt.U_DOT_RADIUS_RANDOMIZE);
  setStrokeRandomize(uiOpt.U_DOT_STROKE_RANDOMIZE);
  setOffsetXY(uiOpt.U_DOT_OFFSET_X_MAX, uiOpt.U_DOT_OFFSET_Y_MAX);
}

int calcValueInRange(x,min1,max1,min2,max2) {
  // calculate value of x based on range of min2 max2 coming from min1 max1
  return (((max2-min2)*(x-min1))/(max1-min1))+min2;
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
  uiOpt.IMG_PADDING_X = (uiOpt.IMG_WIDTH - ((uiOpt.U_DOTS_PER_ROW-1) * uiOpt.U_DOT_DIST_X)) / 2;
  uiOpt.IMG_PADDING_Y = (uiOpt.IMG_HEIGHT - ((uiOpt.U_DOTS_PER_COL-1) * uiOpt.U_DOT_DIST_Y)) / 2;
}

void setDotsPerRow(x) {
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
  
  recalculatePadding();
  // int c = 0;
  // for (int i = 0; i < uiOpt.U_DOTS_PER_COL; i++) {
  //   for (int j = 0; j < uiOpt.U_DOTS_PER_ROW; j++) {
  //     Dot cDot = dotArray[c];

  //     // Init position
  //     // Translate point to 0,0
  //     // int xOrigin = cDot.pos.x - uiOpt.IMG_WIDTH/2;
  //     // int yOrigin = cDot.pos.y - uiOpt.IMG_HEIGHT/2;

  //     // // Rotate around 0,0
  //     // int xR = xOrigin*cos(radians(uiOpt.U_DOT_ROTATION))+yOrigin*sin(radians(uiOpt.U_DOT_ROTATION));
  //     // int yR = xOrigin*(-1*sin(radians(uiOpt.U_DOT_ROTATION)))+yOrigin*cos(radians(uiOpt.U_DOT_ROTATION));
  //     // // console.log("x1R,y1R",x1R,y1R);

  //     // // Translate back to original coordinate space
  //     // int x2 = xR + uiOpt.IMG_WIDTH/2;
  //     // int y2 = yR + uiOpt.IMG_HEIGHT/2;

  //     // // Factor in new dot dist
  //     // int x3 = (uiOpt.IMG_WIDTH/2) + i * (uiOpt.U_DOT_DIST_X);
  //     // int y3 =(uiOpt.IMG_HEIGHT/2) + j * (uiOpt.U_DOT_DIST_Y);
  //     // console.log(x2,y2);
  //     // console.log(x2-uiOpt.IMG_WIDTH/2,y3 - uiOpt.IMG_HEIGHT/2);
  //     // console.log(x3,y3);
  //     // newDot.setPos(x2, y2);
  //     // cDot.setPos(x3, y3);

      
      
  //     // int distFromCenterX = cDot.pos.x - (uiOpt.IMG_WIDTH/2);
  //     // int distFromCenterY = cDot.pos.y - (uiOpt.IMG_HEIGHT/2);

  //     // calc position deltas
  //     // float rowMiddle = (uiOpt.U_DOTS_PER_ROW+1)/2.0;
  //     // float colMiddle = (uiOpt.U_DOTS_PER_COL+1)/2.0;
  //     // // console.log(rowMiddle,colMiddle,uiOpt.U_DOT});
  //     // int newPosX = cDot.pos.x + (((j+1) - rowMiddle) * (x-uiOpt.U_DOT_DIST_X));
  //     // int newPosY = cDot.pos.y + (((i+1) - colMiddle) * (y-uiOpt.U_DOT_DIST_Y));
  //     // cDot.setPos(newPosX,newPosY);
  //     // cDot.spacing.x = uiOpt.U_DOT_DIST_X * j;
  //     // cDot.spacing.y = uiOpt.U_DOT_DIST_Y * i;
  //     // cDot.setPos(cDot.pos.x,cDot.pos.y);
  //     // cDot.setPos(uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST_X * j, uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST_Y);
  //     // c += 1;
  //   }
  // }
  uiOpt.U_DOT_DIST_X = x;
  uiOpt.U_DOT_DIST_Y = y;
}

void setDotDistX(x) {
  setDotDistXY(x, uiOpt.U_DOT_DIST_Y);
}

void setDotDistY(y) {
  setDotDistXY(uiOpt.U_DOT_DIST_X, y);
}

PVector calcRotation(Dot cDot, int a) {
  // Rotate dot pos
  // Translate point to 0,0
  PVector realPos = cDot.getRealPos();
  int xOrigin = realPos.x - uiOpt.IMG_WIDTH/2;
  int yOrigin = realPos.y - uiOpt.IMG_HEIGHT/2;

  // Rotate around 0,0
  int xR = xOrigin*cos(radians(uiOpt.U_DOT_ROTATION-a))+yOrigin*sin(radians(uiOpt.U_DOT_ROTATION-a));
  int yR = xOrigin*(-1*sin(radians(uiOpt.U_DOT_ROTATION-a)))+yOrigin*cos(radians(uiOpt.U_DOT_ROTATION-a));
  // console.log("x1R,y1R",x1R,y1R);

  // Translate back to original coordinate space
  int x2 = xR + uiOpt.IMG_WIDTH/2;
  int y2 = yR + uiOpt.IMG_HEIGHT/2;
  PVector newPos = new PVector();
  newPos.x = x2;
  newPos.y = y2;
  return newPos;
}

PVector calcSpacingFactorRotation(Dot cDot, int a){
  // Rotate Spacing Factor
  // Rotate around 0,0
  PVector newSpacing = new PVector();
  newSpacing.x = cDot.spacingFactor.x*cos(radians(uiOpt.U_DOT_ROTATION-a))+cDot.spacingFactor.y*sin(radians(uiOpt.U_DOT_ROTATION-a));
  newSpacing.y = cDot.spacingFactor.x*(-1*sin(radians(uiOpt.U_DOT_ROTATION-a)))+cDot.spacingFactor.y*cos(radians(uiOpt.U_DOT_ROTATION-a));
  return newSpacing;
}


// void setRotation(a) {
//   for (int i = 0; i < dotArray.length; i++) {
//     Dot cDot = dotArray[i];
//     PVector newPos = calcRotation(cDot, a);
//     PVector newSpacing = calcSpacingFactorRotation(cDot,a);
//     cDot.setSpacingFactor(newSpacing.x,newSpacing.y);
//     cDot.setPos(newPos.x-newSpacing.x*uiOpt.U_DOT_DIST_X, newPos.y-newSpacing.y*uiOpt.U_DOT_DIST_Y);
//   }
//   uiOpt.U_DOT_ROTATION = a;
// }

void setRotation(a) {
  uiOpt.U_DOT_ROTATION = a;
}

void setZoom(a) {
  uiOpt.U_ZOOM = a;
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
      int x1 = uiOpt.IMG_PADDING_X + uiOpt.U_DOT_DIST_X * j;
      int y1 = uiOpt.IMG_PADDING_Y + i * uiOpt.U_DOT_DIST_Y;
      cDot.setPos(x1, y1);

      // Recalc spacing factor
      float tmpX = ((uiOpt.U_DOTS_PER_ROW-1)/2) - j;
      float tmpY = ((uiOpt.U_DOTS_PER_COL-1)/2) - i;
      cDot.setSpacingFactor(tmpX,tmpY);
      
      // Translate point to 0,0
      PVector realPos = cDot.getRealPos();
      int xOrigin = realPos.x - uiOpt.IMG_WIDTH/2;
      int yOrigin = realPos.y - uiOpt.IMG_HEIGHT/2;

      // Rotate around 0,0
      int xR = xOrigin*cos(radians(uiOpt.U_DOT_ROTATION))+yOrigin*sin(radians(uiOpt.U_DOT_ROTATION));
      int yR = xOrigin*(-1*sin(radians(uiOpt.U_DOT_ROTATION)))+yOrigin*cos(radians(uiOpt.U_DOT_ROTATION));

      // Translate back to original coordinate space
      int x2 = xR + uiOpt.IMG_WIDTH/2;
      int y2 = yR + uiOpt.IMG_HEIGHT/2;

      cDot.setPos(x2, y2);
      c+=1;
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

      // Recalc spacing factor
      float tmpX = ((uiOpt.U_DOTS_PER_ROW-1)/2) - j;
      float tmpY = ((uiOpt.U_DOTS_PER_COL-1)/2) - i;
      newDot.setSpacingFactor(tmpX,tmpY);
      
      // Translate point to 0,0
      PVector realPos = newDot.getRealPos();
      int xOrigin = realPos.x - uiOpt.IMG_WIDTH/2;
      int yOrigin = realPos.y - uiOpt.IMG_HEIGHT/2;

      // Rotate around 0,0
      int xR = xOrigin*cos(radians(uiOpt.U_DOT_ROTATION))+yOrigin*sin(radians(uiOpt.U_DOT_ROTATION));
      int yR = xOrigin*(-1*sin(radians(uiOpt.U_DOT_ROTATION)))+yOrigin*cos(radians(uiOpt.U_DOT_ROTATION));

      // Translate back to original coordinate space
      int x2 = xR + uiOpt.IMG_WIDTH/2;
      int y2 = yR + uiOpt.IMG_HEIGHT/2;

      newDot.setPos(x2, y2);

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

  // 1: 0, 2: -w/2, 3: -w, 4: -1.5w,
  // float zoomFactor = 2;
  // float zoomFactor = 3;
  // float zoomFactor = 4;
  // translate(0,0);
  // translate(-width/2,-height/2);
  // translate(-width,-height);
  translate((uiOpt.U_ZOOM-1)*(-width/2),(uiOpt.U_ZOOM-1)*(-height/2));
  scale(uiOpt.U_ZOOM);  

  background(uiOpt.U_BG_COLOR); 

  translate(width/2, height/2);
  rotate(radians(uiOpt.U_DOT_ROTATION));
  translate(-width/2, -height/2);

  for (int i = 0; i < dotArray.length; i++) {
    Dot cDot = dotArray[i];
    cDot.drawDot();
  }

  checkDotConditions();
}

void saveToPDF() {
  save("diagonal.pdf");
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