
import processing.sound.*;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  
  sine.play();
}

SinOsc  sine = new SinOsc(this);
boolean going_up = true;
int     milestone = millis();
float   value = 0;

void draw() {
  float crono = (millis()-milestone)/1000.0;
      
  if (going_up)
    value = crono;
  else
    value = 1-crono; //<>//
  
  if (value >= 0.99 & going_up) {
    going_up = false;
    milestone = millis();
  } 
  
  if (value <= 0.01 & !going_up) {
    going_up = true;
    int wait_time = (int)random(10, 2000);
    delay(wait_time);
    milestone = millis();
  }
  
  sine.amp(value); 
  value = value*255;
  background(value, value, value); 
}