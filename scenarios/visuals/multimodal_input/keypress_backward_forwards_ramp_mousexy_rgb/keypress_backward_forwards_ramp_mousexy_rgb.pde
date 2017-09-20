
boolean forwards = true; 

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
}

void draw() {
  float frequency = 1;

  float denominator = 1000*frequency;

  float opacity = millis()%denominator;

  opacity = opacity/denominator;

  if (!forwards)
    opacity = 1- opacity;

  //opacity = opacity*255;

  float r = ((float)mouseX/width)  * opacity * 255;
  float g = ((float)mouseY/height) * opacity * 255;
  float b = ((float)mouseY/height) * opacity * 255;
  background(r, g, b);
}

void keyPressed() {
  forwards = !forwards;
}