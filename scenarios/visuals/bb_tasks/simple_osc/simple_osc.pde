
void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
}
  
void draw() {
  float time = millis()/1000.0;

  float amplitude = 0.5;

  float frequency = 1;

  float bkg_color = 0.5;
  
  bkg_color = bkg_color + (float) (amplitude * Math.sin((2*Math.PI*frequency*time)));
  
  bkg_color = bkg_color*255;
   
  background(bkg_color, bkg_color, bkg_color); 
}