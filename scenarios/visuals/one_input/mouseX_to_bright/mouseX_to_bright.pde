
void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
}

void draw() {
  float bkg_color = ((float)mouseX/width)*255.0;
  background(bkg_color, bkg_color, bkg_color);
}