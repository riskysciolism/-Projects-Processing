class Pixel{
  int posX, posY;
  color pixelColor;
  boolean processed = false;
  
  
  Pixel(int posX, int posY, color pixelColor) {
    this.posX = posX;
    this.posY = posY;
    this.pixelColor = pixelColor;
  }
  
  void process() {
    this.processed = true;  
  }
  
  
}