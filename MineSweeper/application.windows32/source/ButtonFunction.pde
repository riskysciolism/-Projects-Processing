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
