//<-----Inspiration and Sources----->
// https://www.toptal.com/game/ultimate-guide-to-processing-simple-game
// http://gamedev.stackexchange.com/questions/20516/ball-collisions-sticking-together
// https://gamedevelopment.tutsplus.com/tutorials/when-worlds-collide-simulating-circle-circle-collisions--gamedev-769

//<-----Author----->
// Richard Musebrink
// richard.musebrink@gmail.com

//Big thanks to the user "aaaaaaaaaaaa" on stackexchange for the momentum calculation

double gravity = 1;
double airFriction = 0.0003;
double surfaceFriction = 0.1;
double rollingFriction = 0.01;

final int WALL_SIZE = 50;
final int BALL_COUNT = 20;
final int PLAYER_SIZE = 30;

// ArrayList of a bunch of balls
ArrayList<Ball> arrayOfBalls = new ArrayList();
// PlayerBall
Ball ball;
   
// <TODO>
// + make fields private and write getter and setter methods
// + implement a "world" : obstacles, etc.
// </TODO>

void setup() {
  size(1366, 768);
  
  // initializing of balls
  for(int i = 0 ; i < BALL_COUNT ; i++) {
   arrayOfBalls.add(new Ball((int)random(0 + WALL_SIZE,width - WALL_SIZE), (int)random(0 + WALL_SIZE, height - WALL_SIZE), (int)random(10, 50), color(0,0,0)));
  }
  
  //Player ball
  ball = arrayOfBalls.get(0);
  ball.ballColor = #399EBF;
  ball.ballSize = PLAYER_SIZE;
  
  frameRate(60);
}

// following methods refer to a given ball object

void applyGravity(Ball ball) {
  ball.ballSpeedY += gravity;
  ball.ballY += ball.ballSpeedY;
  ball.ballSpeedY -= ball.ballSpeedY * airFriction;
}

void applyHorizontalSpeed(Ball ball){
  ball.ballX += ball.ballSpeedX;
  ball.ballSpeedX -= ball.ballSpeedX * airFriction;
}

void makeBounceTop(double surface, Ball ball) {
  ball.ballY = surface + (ball.ballSize / 2) + WALL_SIZE;
  ball.ballSpeedY *= -1;
  ball.ballSpeedY -= ball.ballSpeedY * (surfaceFriction * ball.stiffness);
}

void makeBounceBottom(double surface, Ball ball) {
  ball.ballY = surface - (ball.ballSize / 2) - WALL_SIZE;
  ball.ballSpeedY *= -1;
  ball.ballSpeedY -= ball.ballSpeedY * (surfaceFriction * ball.stiffness) ;
  ball.ballSpeedX -= ball.ballSpeedX * rollingFriction;
  if(ball.ballSpeedX < 1 && ball.ballSpeedX >= 0) {
    ball.ballSpeedX -= 0.01;
  }else if(ball.ballSpeedX > -1 && ball.ballSpeedX <= 0) {
    ball.ballSpeedX += 0.01; 
  }
  
}

void makeBounceLeft(double surface, Ball ball) {
  ball.ballX = surface + (ball.ballSize / 2) + WALL_SIZE;
  ball.ballSpeedX *= -1;
  ball.ballSpeedX -= ball.ballSpeedX * surfaceFriction;
}

void makeBounceRight(double surface, Ball ball) {
  ball.ballX = surface - (ball.ballSize / 2) - WALL_SIZE;
  ball.ballSpeedX *= -1;
  ball.ballSpeedX -= ball.ballSpeedX * surfaceFriction;
}

void keepInScreen(Ball ball) {
  //ball hits floor
  if (ball.ballY + (ball.ballSize / 2) > height - WALL_SIZE) {
     makeBounceBottom(height, ball); 
  }
  
  //ball hits ceiling
  if (ball.ballY - (ball.ballSize / 2) < 0 + WALL_SIZE) {
     makeBounceTop(0, ball); 
  }
  
  //ball hits left side
  if (ball.ballX - (ball.ballSize / 2) < 0 + WALL_SIZE){
    makeBounceLeft(0, ball);
  }
  
  //ball hits right side
  if (ball.ballX + (ball.ballSize / 2) > width - WALL_SIZE){
    makeBounceRight(width, ball);
  }
}

// controls the momentum and angle of collided balls after collision
// has to be done by elastic collision
void handleCollision() {
  double xDist, yDist;
  
  for(int i = 0; i < arrayOfBalls.size(); i++) {
    Ball A = arrayOfBalls.get(i);
    for(int j = i + 1; j < arrayOfBalls.size(); j++) { 
      Ball B = arrayOfBalls.get(j);
      xDist = A.ballX - B.ballX;
      yDist = A.ballY - B.ballY;
      double distSquared = xDist * xDist + yDist * yDist;
      
      //checks the squared distance for collision
      if(distSquared <= (A.ballSize / 2 + B.ballSize / 2) * (A.ballSize / 2 + B.ballSize / 2)) {
        double xVelocity = B.ballSpeedX - A.ballSpeedX;
        double yVelocity = B.ballSpeedY - A.ballSpeedY;
        double dotProduct = xDist * xVelocity + yDist * yVelocity;
        
        //checks if the objects moves towards one another
        if(dotProduct > 0) {
          double collisionScale = dotProduct / distSquared;
          double xCollision = xDist * collisionScale;
          double yCollision = yDist * collisionScale;
          
          double combindedMass = A.mass + B.mass;
          double collisionWeightA = 2 * B.mass / combindedMass;
          double collisionWeightB = 2 * A.mass / combindedMass;
          
          //The Collision vector is the speed difference projected on the Dist vector
          A.ballSpeedX += collisionWeightA * xCollision;
          A.ballSpeedY += collisionWeightA * yCollision;
          B.ballSpeedX -= collisionWeightB * xCollision;
          B.ballSpeedY -= collisionWeightB * yCollision;
        }
      }
    }
  }
}

boolean touchesGround() {
  if( ball.ballY + (ball.ballSize / 2) == height - WALL_SIZE) {
    return true;
  }else {
    return false;
  }
}

boolean touchesRoof() {
  if(ball.ballY - (ball.ballSize / 2) == 0 + WALL_SIZE) {
    return true;
  }else {
    return false;
  }
}

void mouseDragged() {
  if (mouseX > pmouseX + 15) {
    if (ball.ballSpeedX < 30 || ball.ballSpeedX == 0) {
        ball.ballSpeedX += 20;
      }
  } else if (mouseX < pmouseX - 15) {
    if (ball.ballSpeedX > -30 || ball.ballSpeedX == 0) {
      ball.ballSpeedX -= 20;
    }
  }
  if (mouseY < pmouseY - 15) {
     if(touchesGround()) {
       ball.ballSpeedY = -20; 
    } 
  }
}

boolean spaceCondition() {
	if((Math.round(gravity * 100.0) / 100.0) == 0) {
      return true;
    }else {
      return false;
    }
}

void keyPressed() {
  if (keyCode == UP) {
    if(touchesGround() || spaceCondition()) {
       ball.ballSpeedY = -20; 
    }
  }
  
  if (keyCode == LEFT) {
    if (ball.ballSpeedX > -30 || ball.ballSpeedX == 0) {
      ball.ballSpeedX -= 20;
    }
  }
  
  if (keyCode == RIGHT) {
    if (ball.ballSpeedX < 30 || ball.ballSpeedX == 0) {
      ball.ballSpeedX += 20;
    }
  }
  
  if (keyCode == DOWN) {
    if(spaceCondition() && ball.ballSpeedY < 30 || touchesRoof() && ball.ballSpeedY < 30) {
      ball.ballSpeedY += 20;
    }
  }
  
  if (key == 'N' || key == 'n') {
    gravity -= 0.1;
    if(gravity <= -10) {
      gravity = -10; 
    }
  }
  
  if (key == 'M' || key == 'm') {
    gravity += 0.1;
    if( gravity >= 10) {
      gravity = 10; 
    }
  }
}



void drawArrayOfBalls(){
  for(Ball balls : arrayOfBalls) {
    fill(balls.ballColor);
    stroke(balls.ballColor);
    ellipse((int)balls.ballX, (int)balls.ballY, balls.ballSize, balls.ballSize);
  }
}

void draw(){
  background(255);
  textSize(15);
  text("Arrow-keys for control", 10, 30);
  text("n and m for gravity manipulation", 10, 50);
  text("Gravity: " + Math.round(gravity * 100.0) / 100.0, 10, 70);
  fill(0);
  
  drawArrayOfBalls();
  for(Ball balls : arrayOfBalls) {
    applyGravity(balls);
    applyHorizontalSpeed(balls);
    keepInScreen(balls);
  }
  handleCollision();
}
