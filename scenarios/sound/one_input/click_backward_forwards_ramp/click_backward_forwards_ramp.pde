

import processing.sound.*;

SinOsc sine = new SinOsc(this);

boolean forwards = true; 

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}
  
void draw() {
  float frequency = 1;
  
  float denominator = 1000*frequency;
  
  float value = millis()%denominator;
  
  value = value/denominator;
  
  if (!forwards)
    value = 1- value;
  
  sine.amp(value);
}

void mousePressed() {
  forwards = !forwards;
}