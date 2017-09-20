import processing.sound.*;

void setup () {
  size(displayWidth, displayHeight);
  sine.play();
}

SinOsc sine = new SinOsc(this);

void draw() {
  float value = millis()%1000;
  value = 1-(value/1000);
  sine.amp(value);
  value = value*255;
  background(value, value, value);
}