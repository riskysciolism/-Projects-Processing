 // -----TODO----- //<>//
// * refractor the code
// 
//

int rows = 20;
int mines = 25;
int cellWidth;

Menu menu = new Menu();

Cell cellArray[][]; 

void makeMines() {
  ArrayList<int[]> mineOptions = new ArrayList();
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < rows; j++) {
      mineOptions.add(new int[]{i,j});
    }
  }
  int setMines = 0;
  
  while(setMines < menu.mines) {
    
    int randomIndex = floor(random(0, mineOptions.size()));
    
    int[] currentCords = mineOptions.get(randomIndex);
    
    cellArray[currentCords[0]][currentCords[1]].mine = true;
    
    mineOptions.remove(randomIndex);
    
    setMines++;
  }
  println(setMines);
}

void makeGrid() {
  cellArray = new Cell[rows][rows];
  //Create cells and position them
    cellWidth = floor(width / rows);
 
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < rows; j++) {
      cellArray[i][j] = new Cell(j * cellWidth, i * cellWidth, cellWidth);
    }
  }
  makeMines();

  //Count mine neighbours for each cell in advance
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < rows; j++) {
      numberOfNeighbours(i, j);
    }
  }
}



void drawGrid() {
  strokeWeight(1);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < rows; j++) {
      Cell currentCell = cellArray[i][j];
      fill(currentCell.cellColor);
      stroke(1);
      rect(currentCell.x, currentCell.y, currentCell.w, currentCell.w);
      // Mine
      if (currentCell.mine && currentCell.revealed) {
        if (currentCell.flagged) {
          rect(currentCell.x + currentCell.w / 4, currentCell.y + currentCell.w / 4, currentCell.w / 2, currentCell.w / 2);
        }
        ellipse(currentCell.x + currentCell.w / 2, currentCell.y + currentCell.w / 2, currentCell.w / 2, currentCell.w / 2);
      } else {
        // no Mine
        if (currentCell.revealed) {
          currentCell.showNeighbours();
          if (currentCell.neighbours == 0) {
            currentCell.cellColor = 210;
          }
        } else {
          if (currentCell.flagged) {
            rect(currentCell.x + currentCell.w / 4, currentCell.y + currentCell.w / 4, currentCell.w / 2, currentCell.w / 2);
          }
        }
      }
    }
  }
}

void numberOfNeighbours(int y, int x) {
  int neighbourCount = 0;
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (x + j > -1 && x + j < rows && y + i > -1 && y + i < rows) {
        if (cellArray[y + i][x + j].getHasMine()) {
          neighbourCount++;
        }
      }
    }
  }
  //write neighbour count in field of cell
  cellArray[y][x].neighbours = neighbourCount;
}

/**
 Flood Algorithms checks surrounding cells for condition and if met runs recursive on them
 **/
void floodAlgorithm(int y, int x) {

  cellArray[y][x].reveal();

  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (x + j > -1 && x + j < rows && y + i > -1 && y + i < rows) {
        if (cellArray[y + i][x + j].neighbours == 0 && !cellArray[y + i][x + j].revealed) {
          int yNew = y + i;
          int xNew = x + j;
          
          cellArray[yNew][xNew].reveal();
          floodAlgorithm(yNew, xNew);
          
        } else {
          cellArray[y + i][x + j].reveal();
        }
      }
    }
  }
}

void gameState() {
  switch(currentView) {
  case Menu:
    menu.drawMenu();
    break;

  case Options:
    menu.drawMenu();
    break;

  case Game:
    drawGrid();
    break;

  case Won:
    menu.drawMenu();
    break;

  case Lost:
    menu.drawMenu();
    break;
  }
}

void mouseDragged() {
  if (getCurrentView() == State.Options) {
    menu.mouseFunction();
  }
}


void mousePressed() {

  if (getCurrentView() == State.Menu) {
    currentFunction = menu.getButtonFunction(mouseX, mouseY);
    println(currentFunction);

    if (currentFunction != null) {    
      switch(currentFunction) {
      case gameStart:
        makeGrid();
        setCurrentView(State.Game);
        break;

      case gameOptions:
        setCurrentView(State.Options);
        break;

      case gameClose:
        exit();
        break;

      case gameMenu:
        break;

      default:
        break;
      }
    }
  } else if (getCurrentView() == State.Options) {
    menu.mouseFunction();
    currentFunction = menu.getButtonFunction(mouseX, mouseY);
    println(currentFunction);
    if (currentFunction != null) {
      switch(currentFunction) {
      case gameStart:
        break;

      case gameOptions:
        break;

      case gameClose:
        break;

      case gameMenu:
        setCurrentView(State.Menu);
        break;

      default:
        break;
      }
    }
  } else if (getCurrentView() == State.Lost) {

    currentFunction = menu.getButtonFunction(mouseX, mouseY);
    println(currentFunction);
    if (currentFunction != null) {
      switch(currentFunction) {
      case gameStart:
        makeGrid();
        setCurrentView(State.Game);
        break;

      case gameOptions:
        break;

      case gameClose:
        break;

      case gameMenu:
        setCurrentView(State.Menu);
        break;

      default:
        break;
      }
    }
  } else if (getCurrentView() == State.Won) {

    currentFunction = menu.getButtonFunction(mouseX, mouseY);
    println(currentFunction);
    if (currentFunction != null) {
      switch(currentFunction) {
      case gameStart:
        makeGrid();
        setCurrentView(State.Game);
        break;

      case gameOptions:
        break;

      case gameClose:
        break;

      case gameMenu:
        setCurrentView(State.Menu);
        break;

      default:
        break;
      }
    }
  } else if (getCurrentView() == State.Game) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < rows; j++) {
        if (mouseX > cellArray[i][j].x && mouseX < cellArray[i][j].x + cellArray[i][j].w
          && mouseY > cellArray[i][j].y && mouseY < cellArray[i][j].y + cellArray[i][j].w) {

          Cell currentCell = cellArray[i][j];
          //reveal Cell
          if (mouseButton == LEFT) {    
            if (!currentCell.revealed) {
              // hit a mine --> GameOver!
              if (currentCell.getHasMine()) {
                for (int k = 0; k < rows; k++) {
                  for (int l = 0; l < rows; l++) {
                    cellArray[k][l].reveal();
                  }
                }
                currentCell.cellColor = color(255, 0, 0);
                setCurrentView(State.Lost);
              } else {
                //didnt hit a mine
                if (currentCell.neighbours == 0) {
                  floodAlgorithm(i, j);
                }
                currentCell.reveal();
                //Checks if all fields which arent mines are revealed --> won
                if (won()) {
                  setCurrentView(State.Won);
                }
              }
            }
          } else {
            //flag cell
            if (mouseButton == RIGHT) {
              if (currentCell.flagged == false) {
                currentCell.flag();
              } else {
                currentCell.unFlag();
              }
            }
          }
        }
      }
    }
  }
}

boolean won() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < rows; j++) {
      Cell currentCell = cellArray[i][j];
      if (!currentCell.mine && !currentCell.revealed) {
        println(currentCell.x + ", " + currentCell.y);
        return false;
      }
    }
  }
  return true;
}

void setup() {
  size(801, 801);
  setCurrentView(State.Menu);
}

void draw() {
  background(255);
  gameState();
}