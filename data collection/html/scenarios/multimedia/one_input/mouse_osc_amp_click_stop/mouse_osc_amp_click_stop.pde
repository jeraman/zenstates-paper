

import processing.sound.*;

import java.util.*;


Queue q = new LinkedList();

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600); 
  sine.play();
}

float queueAverage() {
  float sum = 0;
  for ( Object f : q)  sum += (float) f;
  return sum/q.size();
}

float setfrequency(float a) {
  q.add(a);
  
  if (q.size()>1000)
    q.remove();
    
   return queueAverage();
}
  
SinOsc sine = new SinOsc(this);
boolean oscilate = true;
float   last_value;
  
void draw() {
  float time = millis()/1000.0;
  float amplitude = 0.5;
  float frequency = ((float)mouseX/width)*4;
  float value = 0.5;
  
  if (oscilate) {
    value = value + (float) (amplitude * Math.sin((2*Math.PI*frequency*time)));
    value = value*255;
    last_value = value;
  }
  
  sine.amp(last_value/255); 
  background(last_value, last_value, last_value);  
}

void mousePressed () {
  oscilate = !oscilate;
}