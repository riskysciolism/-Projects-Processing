class Menu {

  ArrayList<MenuButton> buttonList = new ArrayList<MenuButton>();
  ArrayList<SliderFigure> sliderList = new ArrayList<SliderFigure>();

  int mines = 25;
  

  void mouseFunction() {
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

  int getNumberMines() {
    return mines;
  }
  

  void drawMenu() {

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

  void drawButtons() {
    for (MenuButton buttons : buttonList) {
      buttons.drawButton();
    }
  }

  void drawSliders() {
    for (SliderFigure slider : sliderList) {
      slider.drawSlider();
    }
  }

  ButtonFunction getButtonFunction(int x, int y) {
    for (MenuButton buttons : buttonList) {
      if (x > buttons.posX && x < buttons.posX + buttons.buttonLength
        && y > buttons.posY && y < buttons.posY + buttons.buttonHeight) {

        return buttons.buttonFunction();
      }
    }
    return null;
  }

  SliderFigure getSlider (int x, int y) {
    for (SliderFigure slider : sliderList) {
      if (x >= slider.startPointX && x <= slider.startPointX + slider.sliderLength + 5 
        && y <= slider.startPointY + 10 && y >= slider.startPointY - 10) {

        return slider;
      }
    }
    return null;
  }
}