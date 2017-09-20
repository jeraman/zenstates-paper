
import processing.sound.*;


void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);

void draw() {
  float value = millis()%1000;
  value = value/1000;
  sine.amp(value);
  value = value*255;
  background(value, value, value);
}