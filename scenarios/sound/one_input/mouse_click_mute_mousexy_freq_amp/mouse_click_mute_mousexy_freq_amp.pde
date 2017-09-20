

import processing.sound.*;

SinOsc sine = new SinOsc(this);

boolean buttonDown = false;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

void draw() {
  float value1 = ((float)mouseX/width);
  float value2 = ((float)mouseY/height);
  
  if (buttonDown) {
    value1=0;
    value2=0;
  }
  
  sine.amp(value1);
  sine.freq(value2*660);
}

void mousePressed() {
  buttonDown = !buttonDown;
}