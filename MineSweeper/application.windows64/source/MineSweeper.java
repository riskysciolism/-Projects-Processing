import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MineSweeper extends PApplet {

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

public void makeGrid() {
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

public void drawGrid() {
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

public void numberOfNeighbours(int y, int x) {
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
public void floodAlgorithm(int y, int x) {

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

public void gameState() {
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


public void mousePressed() {

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

public boolean won() {
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

public void setup() {
  
  setCurrentView(State.Menu);
}

public void draw() {
  background(255);
  gameState();
}

class Button {
  
  int offSet = 0;
  int posX;
  int posY;
  int buttonLength;
  int buttonHeight;
  String text;
  ButtonFunction function;
  boolean filled = false;
 
  Button(int offSet, String text, ButtonFunction function) {
    this.offSet = offSet;
    this.buttonLength = width / 4;
    this.buttonHeight = height / 20;
    this.posX = width / 2 - buttonLength / 2; 
    this.posY = height / 2 + 50 + offSet;
    this.text = text;
    this.function = function;
  }
  
  Button(int posX, int posY, String text, ButtonFunction function, boolean filled) {
    this.buttonLength = width / 4;
    this.buttonHeight = height / 20;
    this.posX = posX; 
    this.posY = posY;
    this.text = text;
    this.function = function;
    this.filled = filled;
  }
  
  public ButtonFunction buttonFunction() {
    return function;
  }
  
  
  public void drawButton() {
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
ButtonFunction currentFunction;

enum ButtonFunction {
  gameStart,
  gameOptions,
  gameClose,
  gameMenu
}

//getter and setter of the enum
public void setCurrentFunction(ButtonFunction currentFunction) {
        this.currentFunction = currentFunction;
    }

public ButtonFunction getCurrentFunction() {
        return currentFunction;
}
class Cell {
  int x;
  int y;
  int w;
  int neighbours = 0;
  boolean mine;
  boolean flagged = false;
  boolean revealed;
  int cellColor = color(255);
  
  Cell(int x, int y, int w) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.mine = hasMine();
    this.revealed = false;
  }
  
  public void showNeighbours() {
    if(neighbours != 0) {
      fill(0);
      textSize(30);
      textAlign(CENTER);
      text(neighbours, this.x + this.w / 2, this.y + this.w / 2 + 10);
    }
  }
  
  public boolean hasMine() {
    if(random(1) > 0.85f){
      return true;
    }
    return false;
  }
  
  public boolean getHasMine() {
    return this.mine;  
  }
  
  public void flag() {
    flagged = true;
  }
  
  public void unFlag() {
    flagged = false;
  }
  
  public void reveal() {
    revealed = true;
  }
  
}
class Menu {

  ArrayList<Button> buttonList = new ArrayList<Button>();

  public void drawMenu() {

    if (currentView == State.Menu) {
      buttonList.clear();
      fill(255);
      noStroke();
      rect(0, 0, width, height);
      fill(0);
      textAlign(CENTER);
      textSize(100);

      text("MineSweeper", width / 2, height / 2);

      Button gameStart = new Button(0, "Start Game", ButtonFunction.gameStart);
      buttonList.add(gameStart);
      Button gameOptions = new Button(50, "Options", ButtonFunction.gameOptions);
      buttonList.add(gameOptions);
      Button gameClose = new Button(100, "Close Game", ButtonFunction.gameClose);
      buttonList.add(gameClose);

      drawButtons();
    } else if (currentView == State.Options) {
      buttonList.clear();
      fill(255);
      noStroke();
      rect(0, 0, width, height);
      fill(0);
      Button gameMenu = new Button (0, "Back", ButtonFunction.gameMenu);
      buttonList.add(gameMenu);
      drawButtons();
      
    } else if (currentView == State.Won) {
      buttonList.clear();
      drawGrid();
      fill(255, 100);
      noStroke();
      rect(0, 0, width, height);
      fill(50, 100);
      rect(width / 2 - 150, 150, 300, 300);
      fill(70, 100);
      rect(width / 2 - 150, 150, 300, 70);
      fill(0);
      textAlign(CENTER);
      textSize(50);
      text("WON", width / 2, 200);

      Button gameRestart = new Button (width / 2 - width / 8, 230, "Restart", ButtonFunction.gameStart, true);
      buttonList.add(gameRestart);
      Button gameMenu = new Button (width / 2 - width / 8, 280, "Menu", ButtonFunction.gameMenu, true);
      buttonList.add(gameMenu);
      drawButtons();
      
    } else if (currentView == State.Lost) {
      buttonList.clear();
      drawGrid();
      fill(255, 100);
      noStroke();
      rect(0, 0, width, height);
      fill(50, 100);
      rect(width / 2 - 150, 150, 300, 300);
      fill(70, 100);
      rect(width / 2 - 150, 150, 300, 70);
      fill(0);
      textAlign(CENTER);
      textSize(50);
      text("Game Over", width / 2, 200);

      Button gameRestart = new Button (width / 2 - width / 8, 230, "Restart", ButtonFunction.gameStart, true);
      buttonList.add(gameRestart);
      Button gameMenu = new Button (width / 2 - width / 8, 280, "Menu", ButtonFunction.gameMenu, true);
      buttonList.add(gameMenu);
      drawButtons();
    }
  }

  public void drawButtons() {
    for (Button buttons : buttonList) {
      buttons.drawButton();
    }
  }

  public ButtonFunction getButtonFunction(int x, int y) {
    for (Button buttons : buttonList) {
      if (x > buttons.posX && x < buttons.posX + buttons.buttonLength
        && y > buttons.posY && y < buttons.posY + buttons.buttonHeight) {

        return buttons.buttonFunction();
      }
    }
    return null;
  }
}

State currentView;

enum State {
  Menu,
  Options,
  Game,
  Won,
  Lost
}

//getter and setter of the enum
public void setCurrentView(State currentView) {
        this.currentView = currentView;
    }

public State getCurrentView() {
        return currentView;
}
  public void settings() {  size(801, 801); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MineSweeper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
