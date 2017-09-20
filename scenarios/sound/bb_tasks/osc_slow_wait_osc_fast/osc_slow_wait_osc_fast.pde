import processing.sound.*; //<>//

SinOsc sine = new SinOsc(this);

boolean is_slow = true;
int     milestone = millis();
float   wait_time = 2;

float amplitude = 0.5;
float f1 = 1;
float f2 = 10;
float value = 0.5;

void setup () {
   size(displayWidth, displayHeight);
  //size(800, 600);
  
  sine.play();
}

void restart_counter() {
  milestone = millis();
}

void draw() {
  float crono = (millis()-milestone)/1000.0;
  float frequency = 1;

  if (crono >= wait_time) {
    restart_counter();
    is_slow = !is_slow;
  }

  if (is_slow) 
    frequency = f1;
  else
    frequency = f2;

  value = 0.5;
  
  float time = millis()/1000.0;
  
  value = value + (float) (amplitude * Math.sin((2*Math.PI*frequency*time)));
  
  sine.amp(value);
}