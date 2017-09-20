boolean is_noise = false;
int     milestone = millis();
float   wait_time = random(0.2, 2);
float   bkg_color = 0;
int     channel   = 0;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
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
    bkg_color = random(0, 255);
  else
    bkg_color = 0;

  if (channel==0)
    background(bkg_color, 0, 0);
  if (channel==1)
    background(0, bkg_color, 0);
  if (channel==2)
    background(0, 0, bkg_color);
}

void keyPressed() {
  is_noise = true;
  restart_counter();
}

void mousePressed() {
  channel = (channel +1)%3;
}