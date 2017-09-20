

import processing.sound.*;

SinOsc sine = new SinOsc(this);

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}
  
void draw() {
  sine.amp(random(0, 1));
  //background(random(0, 255), random(0, 255), random(0, 255)); 
}