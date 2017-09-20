
void setup (){
  size(displayWidth, displayHeight);
  //size(800, 600);
}
  
void draw() {
  float frequency = 1;
  
  float denominator = 1000*frequency;
  
  float bkg_color = millis()%denominator;
  
  bkg_color = bkg_color/denominator;
  
  bkg_color = 1- bkg_color;
  
  bkg_color = bkg_color*255;
   
  background(bkg_color, bkg_color, bkg_color); 
}