
import processing.sound.*;

SinOsc sine = new SinOsc(this);

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

void draw() {
  float value = ((float)mouseX/width);
  sine.amp(value);
}