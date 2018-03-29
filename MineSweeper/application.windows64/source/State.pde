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
