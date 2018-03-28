// -----TODO-----
// * make game start and game over screen
// * make one able to specify the number of mines
// * make textSize relative to number of cells
// * refractor the code
// 
//

int rows      = 10;
int columns   = 10;

Menu menu = new Menu();

Cell cellArray[][] = new Cell[rows][columns];
ArrayList<String> cordArray = new ArrayList();

void makeGrid() {
  //Create cells and position them
  int cellWidth = floor(width / rows);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < columns; j++) {
      cellArray[i][j] = new Cell(j * cellWidth, i * cellWidth, cellWidth);
    }
  }
  //Count mine neighbours for each cell in advance
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < columns; j++) {
      numberOfNeighbours(i, j);
    }
  }
}

void drawGrid() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < columns; j++) {
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
      if (x + j > -1 && x + j < columns && y + i > -1 && y + i < rows) {
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
  cordArray.add(y+""+x);

  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (x + j > -1 && x + j < columns && y + i > -1 && y + i < rows) {
        if (cellArray[y + i][x + j].neighbours == 0) {
          int yNew = y + i;
          int xNew = x + j;

          if (!cordArray.contains(yNew+""+xNew)) {
            cellArray[yNew][xNew].reveal();
            floodAlgorithm(yNew, xNew);
          }
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
    if(won()) {
       setCurrentView(State.Won);
    } 
    break;

  case Won:
    menu.drawMenu();
    break;

  case Lost:
    menu.drawMenu();
    break;
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
      for (int j = 0; j < columns; j++) {
        if (mouseX > cellArray[i][j].x && mouseX < cellArray[i][j].x + cellArray[i][j].w
          && mouseY > cellArray[i][j].y && mouseY < cellArray[i][j].y + cellArray[i][j].w) {

          Cell currentCell = cellArray[i][j];
          //reveal Cell
          if (mouseButton == LEFT) {    
            if (!currentCell.revealed) {
              // hit a mine --> GameOver!
              if (currentCell.getHasMine()) {
                for (int k = 0; k < rows; k++) {
                  for (int l = 0; l < columns; l++) {
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
    for (int j = 0; j < columns; j++) {
      Cell currentCell = cellArray[i][j];
      if(!currentCell.hasMine() & !currentCell.revealed) {
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