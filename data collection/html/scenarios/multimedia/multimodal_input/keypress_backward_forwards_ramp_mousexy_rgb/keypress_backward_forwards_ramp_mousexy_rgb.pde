
import processing.sound.*;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);
boolean forwards = true; 

void draw() {
  float frequency = 1;
  float denominator = 1000*frequency;
  float opacity = millis()%denominator;
  opacity = opacity/denominator;

  if (!forwards)
    opacity = 1- opacity;

  float value1 = ((float)mouseX/width)  * opacity * 255;
  float value2 = ((float)mouseY/height) * opacity * 255;
  
  sine.amp(opacity);
  sine.freq(mouseX*2);
  background(value1, value2, value2);
}

void keyPressed() {
  forwards = !forwards;
}