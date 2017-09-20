

import processing.sound.*;

SinOsc sine = new SinOsc(this);


int channel = 0;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

void draw() {
  float value = random(0, 1);
  sine.amp(value);
  sine.freq((channel*220));
}

void mousePressed() {
  channel = (channel+1)%3;
}