class Menu {

  ArrayList<Button> buttonList = new ArrayList<Button>();

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

  void drawButtons() {
    for (Button buttons : buttonList) {
      buttons.drawButton();
    }
  }

  ButtonFunction getButtonFunction(int x, int y) {
    for (Button buttons : buttonList) {
      if (x > buttons.posX && x < buttons.posX + buttons.buttonLength
        && y > buttons.posY && y < buttons.posY + buttons.buttonHeight) {

        return buttons.buttonFunction();
      }
    }
    return null;
  }
}