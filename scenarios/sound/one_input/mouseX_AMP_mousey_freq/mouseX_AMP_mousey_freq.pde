
import processing.sound.*;

SinOsc sine = new SinOsc(this);

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

void draw() {
  float xpos = ((float)mouseX/width);
  float ypos = ((float)mouseY/height);
  
  sine.amp(xpos);
  sine.freq(ypos*660);
}