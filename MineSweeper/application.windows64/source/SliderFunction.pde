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
