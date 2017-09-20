
import processing.sound.*;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);
boolean is_slow = true;
float   amplitude = 0.5;
float   f1 = 1;
float   f2 = 10;
float   opacity = 0.5;
int     channel = 0;

void draw() {
  float frequency = 1;

  if (is_slow) 
    frequency = f1;
  else
    frequency = f2;

  opacity = 0.5;
  float time = millis()/1000.0;
  opacity = opacity + (float) (amplitude * Math.sin((2*Math.PI*frequency*time)));
  opacity = opacity*255;
  
  if (channel==0)
    background(opacity, 0, 0);
  if (channel==1)
    background(0, opacity, 0);
  if (channel==2)
    background(0, 0, opacity);
    
  sine.amp(opacity/255);
  sine.freq(channel*220);
}

void keyPressed() {
  channel = (channel +1)%3;
}

void mousePressed() {
  is_slow=!is_slow;
}