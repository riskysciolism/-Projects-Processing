class SliderDragable {
  int size;
  int posX;
  int posY;
 
  SliderDragable(int size, int posX, int posY){
    this.size = size;
    this.posX = posX;
    this.posY = posY;
    
  }
  
  void drawDragable(){
    fill(0);
    stroke(2);
    line(posX, posY - size / 2, posX, posY + size / 2);
  }
  
}