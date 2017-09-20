

import processing.sound.*;

SinOsc sine = new SinOsc(this);

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  
  sine.play();
}
  
void draw() {
  float time = millis()/1000.0;

  float amplitude = 0.5;

  float frequency = 1;

  float value = 0.5;
  
  value = value + (float) (amplitude * Math.sin((2*Math.PI*frequency*time)));
  
   sine.amp(value);
}