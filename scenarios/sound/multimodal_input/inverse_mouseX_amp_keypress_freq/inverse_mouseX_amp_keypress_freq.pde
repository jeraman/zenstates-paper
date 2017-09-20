
import processing.sound.*;

SinOsc sine = new SinOsc(this);

int channel = 0;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

void draw() {
  float opacity = ((float)mouseX)/width;
  opacity = opacity -1;
  sine.amp(opacity);
  sine.freq(channel*220);
}

void keyPressed() {
  channel = (channel +1)%3;
}