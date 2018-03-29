class Ball {
  
double ballX;
double ballY;
double ballSpeedY = 0;
double ballSpeedX = 0;
int ballSize = 20;
double mass = 0;

// 1 is the normal value -> 0 is equal to infinite bouncing
double stiffness = 1.7;


int ballColor;
  
Ball(int ballX, int ballY, int ballSize, int ballColor) {
  this.ballX = ballX;
  this.ballY = ballY;
  this.ballSize = ballSize;
  this.ballColor = ballColor;
  this.mass = (ballSize * ballSize) / 20;
}

}
