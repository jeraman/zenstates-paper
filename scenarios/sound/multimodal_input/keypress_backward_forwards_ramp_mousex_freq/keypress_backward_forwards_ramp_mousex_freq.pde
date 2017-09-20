
import processing.sound.*;

SinOsc sine = new SinOsc(this);

boolean forwards = true; 

void setup () {
  size(displayWidth, displayHeight);
   //size(800, 600);
  sine.play();
}

void draw() {
  float frequency = 1;

  float denominator = 1000*frequency;

  float opacity = millis()%denominator;

  opacity = opacity/denominator;

  if (!forwards)
    opacity = 1- opacity;

  sine.amp(opacity);
  sine.freq(mouseX*2);
  
}

void keyPressed() {
  forwards = !forwards;
}