
import processing.sound.*;

SinOsc sine = new SinOsc(this);


boolean is_noise = false;
int     milestone = millis();
float   wait_time = random(0.2, 2);
float   value = 0;
int     channel   = 0;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
  sine.play();
}

void restart_counter() {
  milestone = millis();
  wait_time = ((float)mouseX/width);
  println(wait_time);
}

void draw() {
  float crono = (millis()-milestone)/1000.0;

  if (crono >= wait_time)
    is_noise = false;

  if (is_noise) 
    value = random(0, 255);
  else
    value = 0;
  
  sine.amp(value/255);
  sine.freq(channel*220);
}

void keyPressed() {
  channel = (channel +1)%3;
}

void mousePressed() {
  is_noise = true;
  restart_counter();
}