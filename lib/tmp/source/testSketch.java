import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class testSketch extends PApplet {

public void setup() {
  size(700, 700); 
  background(255); 
  smooth();

  // Read file
  String[] inputLines = loadStrings("settings.txt");
  int inputInt = PApplet.parseInt(split(inputLines[0],",")[0]);

  float strokeMin = 0.1f;
  float alpha = 255.0f;
  float prevX = random(width);
  float prevY = random(height);
  int numLines = inputInt;
  float strokeMax = 1;
  float colorB = 0;

  for (int i = 1; i < numLines; i++) {
    strokeWeight(strokeMin + strokeMax * (PApplet.parseFloat(i) / numLines));
    stroke(20, 50, 20+colorB, alpha);
    colorB = (PApplet.parseFloat(i)/numLines)*255;
    float randX = random(width);
    float randY = random(height);
    line(prevX, prevY, randX, randY);
    prevX = randX;
    prevY = randY;
    alpha = 255 - 0.5f * colorB;
  }
  save("test.jpg");
  exit();
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "testSketch" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
