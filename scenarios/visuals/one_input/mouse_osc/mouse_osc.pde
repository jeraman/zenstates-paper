
import java.util.*;

Queue q = new LinkedList();

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600); 
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
  
void draw() {
  float time = millis()/1000.0;

  float amplitude = 0.5;

  //float frequency = ((float)mouseX/width)*4;
  float frequency = setfrequency(((float)mouseX/width)*3);
  
  //frequency needs to be smoothed as pointed here:
  //https://medium.com/@olehch/lets-write-a-simple-sine-wave-generator-with-c-and-juce-c8ab42d1f54f
  

  float bkg_color = 0.5;
  
  bkg_color = bkg_color + (float) (amplitude * Math.sin((2*Math.PI*frequency*time)));
  
  println(bkg_color);
  
  bkg_color = bkg_color*255;
   
  background(bkg_color, bkg_color, bkg_color); 
}