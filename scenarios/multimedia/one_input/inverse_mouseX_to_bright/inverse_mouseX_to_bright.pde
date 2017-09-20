
import processing.sound.*;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);

void draw() {
  float value = 1-((float)mouseX/width);
  sine.amp(value);
  value = value*255.0;
  background(value, value, value);
}