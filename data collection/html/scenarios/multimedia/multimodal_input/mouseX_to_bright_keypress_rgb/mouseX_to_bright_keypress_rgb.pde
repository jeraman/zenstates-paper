

import processing.sound.*;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);
int channel = 0;

void draw() {
  float value = ((float)mouseX/width);
  value = value*255.0;

  if (channel==0)
    background(value, 0, 0);
  if (channel==1)
    background(0, value, 0);
  if (channel==2)
    background(0, 0, value);
    
  sine.amp(value/255);
  sine.freq(channel*220);
}

void keyPressed() {
  channel = (channel +1)%3;
}