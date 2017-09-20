
import processing.sound.*;

int channel = 0;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);

void draw() {
  float bkg_color = 1-((float)mouseX/width);
  bkg_color = bkg_color*255.0;

  if (channel==0)
    background(bkg_color, 0, 0);
  if (channel==1)
    background(0, bkg_color, 0);
  if (channel==2)
    background(0, 0, bkg_color);
  
  sine.amp(1-((float)mouseX/width));
  sine.freq(channel*220);
}

void keyPressed() {
  channel = (channel +1)%3;
}