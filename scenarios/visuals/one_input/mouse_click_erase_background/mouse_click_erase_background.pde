

boolean buttonDown = false;

void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
}

void draw() {
  float r = ((float)mouseX/width)  * 255;
  float g = ((float)mouseY/height) * 255;
  float b = ((float)mouseY/height) * 255;
  
  if (buttonDown) {
    r=0;
    g=0;
    b=0;
  }
  
  background(r, g, b);
}

void mousePressed() {
  buttonDown = !buttonDown;
}