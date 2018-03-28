class Cell {
  int x;
  int y;
  int w;
  int neighbours = 0;
  boolean mine;
  boolean flagged = false;
  boolean revealed;
  color cellColor = color(255);
  int tSize = floor(map(cellWidth, 800, 8, 300, 10));
  
  Cell(int x, int y, int w) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.mine = false;
    this.revealed = false;
  }
  
  void showNeighbours() {
    if(neighbours != 0) {
      fill(0);
      textSize(tSize);
      textAlign(CENTER);
      text(neighbours, this.x + this.w / 2, this.y + this.w / 2 + tSize / 3);
    }
  }
  
  boolean hasMine() {
    if(random(1) > 0.5){
      return true;
    }
    return false;
  }
  
  boolean getHasMine() {
    return this.mine;  
  }
  
  void flag() {
    flagged = true;
  }
  
  void unFlag() {
    flagged = false;
  }
  
  void reveal() {
    revealed = true;
  }
  
}