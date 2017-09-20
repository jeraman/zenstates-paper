import processing.sound.*;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

SinOsc  sine = new SinOsc(this);
boolean going_up = true;
int     milestone = millis();
int     wait_time = 2000;
float   opacity = 0;

void draw() {
  float crono = (millis()-milestone)/1000.0;
      
  if (going_up)
    opacity = crono;
  else
    opacity = 1-crono;
  
  if (opacity >= 0.99 & going_up) {
    going_up = false;
    milestone = millis();
  } 
  
  if (opacity <= 0.01 & !going_up) {
    going_up = true;
    delay(wait_time);
    milestone = millis();
  }
  
  float value1 = ((float)mouseX/width)  * opacity * 255;
  float value2 = ((float)mouseY/height) * opacity * 255;
  sine.amp(value1/255);
  sine.freq(value2*2);
  background(value1,value2, value2);
}