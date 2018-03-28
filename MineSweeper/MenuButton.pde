class MenuButton {
  
  int offSet = 0;
  int posX;
  int posY;
  int buttonLength;
  int buttonHeight;
  String text;
  ButtonFunction buttonFunction;
  boolean filled = false;
 
  MenuButton(int offSet, String text, ButtonFunction buttonFunction) {
    this.offSet = offSet;
    this.buttonLength = width / 4;
    this.buttonHeight = height / 20;
    this.posX = width / 2 - buttonLength / 2; 
    this.posY = height / 2 + 50 + offSet;
    this.text = text;
    this.buttonFunction = buttonFunction;
  }
  
  MenuButton(int posX, int posY, String text, ButtonFunction buttonFunction, boolean filled) {
    this.buttonLength = width / 4;
    this.buttonHeight = height / 20;
    this.posX = posX; 
    this.posY = posY;
    this.text = text;
    this.buttonFunction = buttonFunction;
    this.filled = filled;
  }
  
  ButtonFunction buttonFunction() {
    return buttonFunction;
  }
  
  
  void drawButton() {
    noFill();
    if(this.filled) {
      fill(255, 200);
    }
    noStroke();
    //stroke(1);
    rect(this.posX , this.posY + 5, this.buttonLength, this.buttonHeight);
    fill(0);
    textSize(30);
    textAlign(CENTER);
    text(this.text, this.posX + this.buttonLength / 2, this.posY + this.buttonHeight - 5);
  }
  
}