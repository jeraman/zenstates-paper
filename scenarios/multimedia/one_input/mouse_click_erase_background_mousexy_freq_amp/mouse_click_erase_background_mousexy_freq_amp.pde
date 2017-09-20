

import processing.sound.*;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);
boolean buttonDown = false;

void draw() {
  float value1 = ((float)mouseX/width)  * 255;
  float value2 = ((float)mouseY/height) * 255;
  
  if (buttonDown) {
    value1=0;
    value2=0;
  }
  
  sine.amp(value1/255);
  sine.freq(value2*2);
  
  background(value1, value2, value2);
}

void mousePressed() {
  buttonDown = !buttonDown;
}