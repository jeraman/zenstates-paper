
import processing.sound.*;
import java.util.*;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc sine = new SinOsc(this);
  
void draw() {
  float time = millis()/1000.0;
  float amplitude = 0.5;
  float frequency = ((float)mouseX/width)*4;
  float value = 0.5;
  
  value = value + (float) (amplitude * Math.sin((2*Math.PI*frequency*time)));
  sine.amp(value);
  value = value*255;
  background(value, value, value); 
}