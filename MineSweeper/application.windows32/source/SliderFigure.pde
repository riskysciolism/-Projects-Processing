class SliderFigure {
  int sliderLength;
  int precision;
  int startPointX;
  int startPointY;
  boolean valueVisible = false;
  SliderDragable dragger;
  String text;
  SliderFunction function;
  int sliderMin;
  int sliderMax;
  
  SliderFigure(int startPointX, int startPointY, int sliderLength, boolean valueVisible, int value, String text, SliderFunction function, int sliderMin, int sliderMax){
    this.startPointX = startPointX;
    this.startPointY = startPointY;
    this.sliderLength = sliderLength;
    this.valueVisible = valueVisible;
    this.text = text;
    this.function = function;
    this.sliderMin = sliderMin;
    this.sliderMax = sliderMax;
    
    this.dragger = new SliderDragable(this.sliderLength / 20, (int)map(value, sliderMin, sliderMax, this.startPointX, this.startPointX + this.sliderLength), this.startPointY);
    
  }
  
  int getSliderValue() {
    return ceil(map(this.dragger.posX, this.startPointX, this.startPointX + this.sliderLength, sliderMin, sliderMax));
  }
  
  
  SliderFunction sliderFunction() {
    return function;  
  }
  
  
  
  void drawSlider() {
    fill(0);
    stroke(2);
    strokeWeight(2);
    
    line(this.startPointX, this.startPointY, this.startPointX + this.sliderLength, this.startPointY);
    
    if(valueVisible){
      fill(0);
      text(text + this.getSliderValue(), this.startPointX + this.sliderLength / 2, this.startPointY + 40);
    }
    
    this.dragger.drawDragable();
  }
}
