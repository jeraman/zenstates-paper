import processing.sound.*;

SinOsc sine = new SinOsc(this);

boolean is_noise = true;
int     milestone = millis();
float   wait_time = random(0.2, 2);
float   value = 0;


void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
  
  sine.play();
}

void restart_counter() {
  milestone = millis();
  wait_time = random(0.2, 2);
  println(wait_time);
}

void draw() {
  float crono = (millis()-milestone)/1000.0;
  
  if (crono >= wait_time) {
    restart_counter();
    is_noise = !is_noise;
  }
  
  if (is_noise) 
    value = random(0,255);
  else
    value = 0;
  
  sine.amp(value/255);
}