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
// * refractor the code
// 
//

int rows = 20;
int mines = 25;
int cellWidth;

Menu menu = new Menu();

Cell cellArray[][]; 

public void makeMines() {
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

public void makeGrid() {
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



public void drawGrid() {
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

public void numberOfNeighbours(int y, int x) {
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
public void floodAlgorithm(int y, int x) {

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
    break;

  case Won:
    menu.drawMenu();
    break;

  case Lost:
    menu.drawMenu();
    break;
  }
}

public void mouseDragged() {
  if (getCurrentView() == State.Options) {
    menu.mouseFunction();
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

public boolean won() {
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

public void setup() {
  
  setCurrentView(State.Menu);
}

public void draw() {
  background(255);
  gameState();
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
  int tSize = floor(map(cellWidth, 800, 8, 300, 10));
  
  Cell(int x, int y, int w) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.mine = false;
    this.revealed = false;
  }
  
  public void showNeighbours() {
    if(neighbours != 0) {
      fill(0);
      textSize(tSize);
      textAlign(CENTER);
      text(neighbours, this.x + this.w / 2, this.y + this.w / 2 + tSize / 3);
    }
  }
  
  public boolean hasMine() {
    if(random(1) > 0.5f){
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

  ArrayList<MenuButton> buttonList = new ArrayList<MenuButton>();
  ArrayList<SliderFigure> sliderList = new ArrayList<SliderFigure>();

  int mines = 25;
  

  public void mouseFunction() {
      SliderFigure currentSlider = getSlider(mouseX, mouseY);
      
      if (currentSlider != null) {
        
        SliderFunction currentSliderFunction = currentSlider.function;
        
        if (mouseX <= currentSlider.startPointX) {
          currentSlider.dragger.posX = currentSlider.startPointX;
        }
        
        if (mouseX >= currentSlider.startPointX + currentSlider.sliderLength) {
          currentSlider.dragger.posX = currentSlider.startPointX + currentSlider.sliderLength;
        } else {
          currentSlider.dragger.posX = mouseX;
        }
  
        if (currentSliderFunction == SliderFunction.rowNumber) {
          rows = currentSlider.getSliderValue();
          if(rows * rows < mines) {
            mines = rows * rows;
          }
          
        } else if (currentSliderFunction == SliderFunction.mineNumber) {
          mines = currentSlider.getSliderValue();
          if(rows * rows < mines) {
            mines = rows * rows;
          }
        }
      }
  }

  public int getNumberMines() {
    return mines;
  }
  

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

      MenuButton gameStart = new MenuButton(0, "Start Game", ButtonFunction.gameStart);
      buttonList.add(gameStart);
      MenuButton gameOptions = new MenuButton(50, "Options", ButtonFunction.gameOptions);
      buttonList.add(gameOptions);
      MenuButton gameClose = new MenuButton(100, "Close Game", ButtonFunction.gameClose);
      buttonList.add(gameClose);

      drawButtons();
    } else if (currentView == State.Options) {
      buttonList.clear();
      sliderList.clear();
      
      fill(255);
      noStroke();
      rect(0, 0, width, height);

      //Sliders
      //Slider Rows
      SliderFigure sliderRows = new SliderFigure(800 / 2 - 150, 800 / 2 - 200, 300, true, rows, "Number of lines: ", SliderFunction.rowNumber, 1, 50);
      sliderList.add(sliderRows);

      //Slider Mines
      SliderFigure sliderMines = new SliderFigure(800 / 2 - 150, 800 / 2 - 100, 300, true, mines, "Number of mines: ", SliderFunction.mineNumber, 1, 2500);
      sliderList.add(sliderMines);

      drawSliders();

      fill(0);
      MenuButton gameMenu = new MenuButton (0, "Back", ButtonFunction.gameMenu);
      buttonList.add(gameMenu);
      drawButtons();
    } else if (currentView == State.Won) {
      buttonList.clear();
      drawGrid();
      fill(255, 150);
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

      MenuButton gameRestart = new MenuButton (width / 2 - width / 8, 230, "Restart", ButtonFunction.gameStart, true);
      buttonList.add(gameRestart);
      MenuButton gameMenu = new MenuButton (width / 2 - width / 8, 280, "Menu", ButtonFunction.gameMenu, true);
      buttonList.add(gameMenu);
      drawButtons();
    } else if (currentView == State.Lost) {
      buttonList.clear();
      drawGrid();
      fill(255, 150);
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

      MenuButton gameRestart = new MenuButton (width / 2 - width / 8, 230, "Restart", ButtonFunction.gameStart, true);
      buttonList.add(gameRestart);
      MenuButton gameMenu = new MenuButton (width / 2 - width / 8, 280, "Menu", ButtonFunction.gameMenu, true);
      buttonList.add(gameMenu);
      drawButtons();
    }
  }

  public void drawButtons() {
    for (MenuButton buttons : buttonList) {
      buttons.drawButton();
    }
  }

  public void drawSliders() {
    for (SliderFigure slider : sliderList) {
      slider.drawSlider();
    }
  }

  public ButtonFunction getButtonFunction(int x, int y) {
    for (MenuButton buttons : buttonList) {
      if (x > buttons.posX && x < buttons.posX + buttons.buttonLength
        && y > buttons.posY && y < buttons.posY + buttons.buttonHeight) {

        return buttons.buttonFunction();
      }
    }
    return null;
  }

  public SliderFigure getSlider (int x, int y) {
    for (SliderFigure slider : sliderList) {
      if (x >= slider.startPointX && x <= slider.startPointX + slider.sliderLength + 5 
        && y <= slider.startPointY + 10 && y >= slider.startPointY - 10) {

        return slider;
      }
    }
    return null;
  }
}
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
  
  public ButtonFunction buttonFunction() {
    return buttonFunction;
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
class SliderDragable {
  int size;
  int posX;
  int posY;
 
  SliderDragable(int size, int posX, int posY){
    this.size = size;
    this.posX = posX;
    this.posY = posY;
    
  }
  
  public void drawDragable(){
    fill(0);
    stroke(2);
    line(posX, posY - size / 2, posX, posY + size / 2);
  }
  
}
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
  
  public int getSliderValue() {
    return ceil(map(this.dragger.posX, this.startPointX, this.startPointX + this.sliderLength, sliderMin, sliderMax));
  }
  
  
  public SliderFunction sliderFunction() {
    return function;  
  }
  
  
  
  public void drawSlider() {
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
SliderFunction currentSliderFunction;

enum SliderFunction {
  rowNumber,
  columnNumber,
  mineNumber
}

//getter and setter of the enum
public void setCurrentFunction(SliderFunction currentSliderFunction) {
        this.currentSliderFunction = currentSliderFunction;
    }

public SliderFunction getCurrentSliderFunction() {
        return currentSliderFunction;
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
