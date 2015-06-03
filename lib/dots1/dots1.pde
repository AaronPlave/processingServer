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
//  Number of draw iterations: redraw background yes/no, change conditions randomly or in order?
//  Shape noise, could add some amount of random *wiggliness* to each shape, uniformly or not. 

boolean U_DOT_SINGLE_COLOR = false;
boolean U_DOT_THEME = true;
boolean U_DOT_STROKE = false;
boolean U_DOT_FILL = true;
boolean U_DOT_RANDOM_RADIUS = true;
boolean U_DOT_OFFSET = false;

// dot center offset
float U_DOT_OFFSET_MAX = 10;

// dot radius
float U_DOT_RADIUS_DEFAULT = 20.0;
float U_DOT_RADIUS_MIN = 1;
float U_DOT_RADIUS_MAX = 10;

// background color
int U_BG_COLOR_R = 255;
int U_BG_COLOR_G = 253;
int U_BG_COLOR_B = 247;

// dot fill single color 
int U_DOT_SINGLE_FILL_COLOR_R = 200;
int U_DOT_SINGLE_FILL_COLOR_G = 0;
int U_DOT_SINGLE_FILL_COLOR_B = 100;

// dot fill theme colors 
int[][] U_DOT_THEME_COLORS = {
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
float U_DOT_STROKE_WEIGHT = 0.5;
int U_DOT_SINGLE_STROKE_COLOR_R = 50;
int U_DOT_SINGLE_STROKE_COLOR_G = 50;
int U_DOT_SINGLE_STROKE_COLOR_B = 50;
//// END CUSTOMIZABLE PARAMS

//// PREDEFINED PARAMS
int IMG_HEIGHT = 700;
int IMG_WIDTH = IMG_HEIGHT;
int U_DOTS_PER_ROW = 50;
int DOT_DIST = 10;
int IMG_PADDING = (IMG_WIDTH - ((U_DOTS_PER_ROW-1) * DOT_DIST)) / 2;
int MAX_DOTS_PER_ROW = 100;
//// END PREDEFINED PARAMS

//// DRAWING CODE
void setup() {
  // Read from CSV
  Table settingsTable = loadTable("settings.csv", "header, csv");
  for (TableRow row : settingsTable.rows()) {
    U_DOT_FILL = row.getString("fill").equals("True") ? true : false;
    U_DOTS_PER_ROW = int(row.getString("dotsPerRow")) <= MAX_DOTS_PER_ROW ? 
                      int(row.getString("dotsPerRow")) : MAX_DOTS_PER_ROW;
    IMG_PADDING = (IMG_WIDTH - ((U_DOTS_PER_ROW-1) * DOT_DIST)) / 2;
                      
    println(U_DOT_FILL,U_DOTS_PER_ROW);
  }
  size(IMG_HEIGHT, IMG_WIDTH);
  smooth(); 
  background(U_BG_COLOR_R, U_BG_COLOR_G, U_BG_COLOR_B);

  // Determine blend mode
  // blendMode(EXCLUSION); 
  noLoop();
  // frameRate(2);
}
void draw() {
//  background(U_BG_COLOR_R, U_BG_COLOR_G, U_BG_COLOR_B);
  for (int i = 0; i < U_DOTS_PER_ROW; i++) {
    for (int j = 0; j < U_DOTS_PER_ROW; j++) {
      int x1 = IMG_PADDING + DOT_DIST * j;
      int y1 = IMG_PADDING + i * DOT_DIST;
      setColor();
      drawDot(x1, y1, U_DOT_RADIUS_DEFAULT);
    }
  }
  save("test.jpg");
  exit();
}

void setColor() {
  // Determine stroke
  if (U_DOT_STROKE) {
    stroke(U_DOT_SINGLE_STROKE_COLOR_R, U_DOT_SINGLE_STROKE_COLOR_G, U_DOT_SINGLE_STROKE_COLOR_B);
    strokeWeight(U_DOT_STROKE_WEIGHT);
  } else {
    noStroke();
  }
  // Determine dot fill
  if (U_DOT_FILL) {
    if (U_DOT_SINGLE_COLOR) {
      fill(U_DOT_SINGLE_FILL_COLOR_R, U_DOT_SINGLE_FILL_COLOR_G, U_DOT_SINGLE_FILL_COLOR_B);
    } else if (U_DOT_THEME) {
      int[] rgb = U_DOT_THEME_COLORS[int(random(0, U_DOT_THEME_COLORS.length))];
      fill(rgb[0], rgb[1], rgb[2]);
    }
  } else {
    noFill();
  }
}
void drawDot(int x, int y, float radius) {
  // Determine radius
  if (U_DOT_RANDOM_RADIUS) {
    radius = random(U_DOT_RADIUS_MIN, U_DOT_RADIUS_MAX);
  }
  float offsetX = 0;
  float offsetY = 0;
  if (U_DOT_OFFSET) {
    offsetX = random(-1*U_DOT_OFFSET_MAX, U_DOT_OFFSET_MAX);
    offsetY = random(-1*U_DOT_OFFSET_MAX, U_DOT_OFFSET_MAX);
  }
  ellipse(x+offsetX, y+offsetY, radius, radius);
}
//void keyPressed() {
//  if (keyCode == ENTER) {
//    saveFrame("../screenshots/screen-"+str(random(1000000))+".jpg");
//  }
//}
