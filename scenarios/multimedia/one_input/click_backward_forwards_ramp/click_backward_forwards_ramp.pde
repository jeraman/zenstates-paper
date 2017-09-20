

import processing.sound.*;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}
  
SinOsc sine = new SinOsc(this);
boolean forwards = true; 
  
void draw() {
  float frequency = 1;
  float denominator = 1000*frequency;
  float value = millis()%denominator;
  
  value = value/denominator;
  
  if (!forwards)
    value = 1- value;
  
  sine.amp(value);
  value = value*255;
  background(value, value, value); 
}

void mousePressed() {
  forwards = !forwards;
}