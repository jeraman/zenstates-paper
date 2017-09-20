
int channel = 0;

void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
}

void draw() {
  float bkg_color = 1-((float)mouseX/width);
  bkg_color = bkg_color*255.0;

  if (channel==0)
    background(bkg_color, 0, 0);
  if (channel==1)
    background(0, bkg_color, 0);
  if (channel==2)
    background(0, 0, bkg_color);
}

void keyPressed() {
  channel = (channel +1)%3;
}