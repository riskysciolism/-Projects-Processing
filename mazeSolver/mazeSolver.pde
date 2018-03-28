PImage maze;
int numberOfPixels;
Pixel[][] pixelArray;
int mouseCounter = 0;
PVector start, end;

void setup() {
  size(1000, 1000);
  
  maze = loadImage("bw.png");
  maze.loadPixels();
  numberOfPixels = maze.height * maze.width;
  pixelArray = new Pixel[maze.height][maze.width];
  getPixels();
}

void draw() {
  
  setPixels();
  maze.updatePixels();
  image(maze, 0,0);
}

void mouseClicked(){
 
  if (mouseCounter == 0) {
    start = new PVector(mouseX, mouseY);
    mouseCounter++;
  } else {
    if(pixelArray[(int)mouseY][(int)mouseX].pixelColor == pixelArray[(int)start.y][(int)start.x].pixelColor){
      end = new PVector(mouseX, mouseY);
      mouseCounter = 0;
      floodAlgorithm((int)start.y, (int)start.x);
      
      if(pixelArray[(int)end.y][(int)end.x].processed) {
        println("solveable");
      } else {
        println("not solveable");  
      }
    }
    else {
      println("Target must be same color");
    }
  } 
}

void getPixels() {
  for(int i = 0; i < maze.height; i++) {
    for(int j = 0; j < maze.width; j++) {
      pixelArray[i][j] = new Pixel(j, i, maze.pixels[i * maze.width + j]);
    }
  } 
}

void setPixels() {
  for(int i = 0; i < maze.height; i++) {
    for(int j = 0; j < maze.width; j++) {
      maze.pixels[i * maze.width + j] = pixelArray[i][j].pixelColor;
    }
  } 
  
}

void floodAlgorithm(int y, int x) {

  pixelArray[y][x].process();

  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (x + j > -1 && x + j < maze.width && y + i > -1 && y + i < maze.height) {
        if (pixelArray[y + i][x + j].pixelColor == color(255,255,255) && !pixelArray[y + i][x + j].processed) {
          int yNew = y + i;
          int xNew = x + j;
          //change to Path
          pixelArray[y][x].pixelColor = color(255,0,0);
          
          pixelArray[yNew][xNew].process();
          floodAlgorithm(yNew, xNew);
          
        } else {
          pixelArray[y + i][x + j].process();
        }
      }
    }
  }
}