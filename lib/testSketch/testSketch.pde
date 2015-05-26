void setup() {
  size(700, 700); 
  background(255); 
  smooth();

  // Read file
  String[] inputLines = loadStrings("settings.txt");
  int inputInt = int(split(inputLines[0],",")[0]);

  float strokeMin = 0.1;
  float alpha = 255.0;
  float prevX = random(width);
  float prevY = random(height);
  int numLines = inputInt;
  float strokeMax = 1;
  float colorB = 0;

  for (int i = 1; i < numLines; i++) {
    strokeWeight(strokeMin + strokeMax * (float(i) / numLines));
    stroke(20, 50, 20+colorB, alpha);
    colorB = (float(i)/numLines)*255;
    float randX = random(width);
    float randY = random(height);
    line(prevX, prevY, randX, randY);
    prevX = randX;
    prevY = randY;
    alpha = 255 - 0.5 * colorB;
  }
  save("test.jpg");
  exit();
}

