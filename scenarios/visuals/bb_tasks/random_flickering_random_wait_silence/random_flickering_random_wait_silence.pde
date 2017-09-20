boolean is_noise = true;
int     milestone = millis();
float   wait_time = random(0.2, 2);
float   bkg_color = 0;


void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
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
    bkg_color = random(0,255);
  else
    bkg_color = 0;
  
  background(bkg_color, bkg_color, bkg_color); 
}