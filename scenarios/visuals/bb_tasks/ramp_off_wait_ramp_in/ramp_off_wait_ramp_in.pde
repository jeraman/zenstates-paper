boolean going_up = true;
int     milestone = millis();
int     wait_time = 2000;
float   bkg_color = 0;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
}

void draw() {
  float crono = (millis()-milestone)/1000.0;
      
  if (going_up)
    bkg_color = crono;
  else
    bkg_color = 1-crono; //<>//
  
  if (bkg_color >= 0.99 & going_up) {
    going_up = false;
    milestone = millis();
  } 
  
  if (bkg_color <= 0.01 & !going_up) {
    going_up = true;
    delay(wait_time);
    milestone = millis();
  }
  
  bkg_color = bkg_color*255;
  background(bkg_color, bkg_color, bkg_color); 
  println(bkg_color);
}