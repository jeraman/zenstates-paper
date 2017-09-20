
import processing.sound.*;



void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);

void draw() {
  float xpos = ((float)mouseX/width);
  float ypos = ((float)mouseY/height);
  
  sine.amp(xpos);
  sine.freq(ypos*660);
  background(xpos*255, xpos*255, ypos*255);
}