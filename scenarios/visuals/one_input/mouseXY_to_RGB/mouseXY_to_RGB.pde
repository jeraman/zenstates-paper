
void setup () {
  size(displayWidth, displayHeight);
  //size(800, 600);
}

void draw() {
  float xpos = ((float)mouseX/width);
  float ypos = ((float)mouseY/height);
  background(xpos*255, xpos*255, ypos*255);
}