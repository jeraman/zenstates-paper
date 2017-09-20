
import processing.sound.*;

SinOsc sine = new SinOsc(this);

boolean going_up = true;
int     milestone = millis();
int     wait_time = 2000;
float   value = 0;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  
  sine.play();
}

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
    delay(wait_time);
    milestone = millis();
  }
  
  sine.amp(value);
}