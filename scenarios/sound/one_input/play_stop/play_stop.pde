
import processing.sound.*;

SinOsc sine = new SinOsc(this);
boolean is_playing = true;


void setup() {
  size(displayWidth, displayHeight);
  //size(640, 360);
  // Create the sine oscillator.
  sine.play();
}


void draw() {
}

void mousePressed() {
  if (is_playing)
    sine.stop();
  else
    sine.play();

  is_playing = !is_playing;
}