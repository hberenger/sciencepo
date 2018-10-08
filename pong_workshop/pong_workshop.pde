// Constants
final float paddle_x = 10;
final float paddle_w = 8;
final float paddle_h = 50;
final float ball_size = 10;
// Variables
float ball_x;
float ball_y;
float speed_x;
float speed_y;
float paddle_y; // top border of the paddle
int score = 0;
int best_score = 0;
// new_game is a boolean value used to track the end of
// the game. When new_game is true, the display is frozen
// until the user presses a mouse button or the touchpad
boolean new_game = false;

void setup() {
  size(400, 400);
  setupInitialPositions();
  speed_x = 1.8; // or : random(-4, 4);
  speed_y = 2.5; // or : random(-4, 4);
  noStroke(); // do not draw outlines of shapes
}

// This function resets the ball and paddle to their initial positions
void setupInitialPositions() {
  ball_x = width / 2;
  ball_y = height / 2;
  paddle_y = height / 2 - paddle_h / 2;
}

void draw() {
  if (new_game) {
    // do nothing
    return;
  }
  background(200, 90, 25); // orange
      
  // The vertical position of the cursor in the screen gives
  // the position of the top of the paddle  
  paddle_y = mouseY;
  
  // top & bottom wall bouncing
  if (ball_y > 400 || ball_y < 0) {
    speed_y = -speed_y;
  }
  
  // right wall bouncing
  if (ball_x > 400) {
    speed_x = -speed_x;
  }
  
  float left_side_of_the_ball = ball_x - ball_size / 2;
  
  // bounce on left paddle
  if ( left_side_of_the_ball  > paddle_x
  && left_side_of_the_ball < paddle_x + paddle_w
  && ball_y > paddle_y
  && ball_y < paddle_y + paddle_h) {
    speed_x = -speed_x;
    score = score + 1; // increment the current score
  }
  
  // move the ball
  ball_x = ball_x + speed_x;
  ball_y = ball_y + speed_y;
  
  // detect the end of the game (when the ball is reasonably far away)
  if (ball_x < -50) {
    new_game = true;
    setupInitialPositions();
    if (score > best_score) {
      best_score = score; // update the best score if need be
    }
    score = 0;
    textAlign(CENTER);
    text("Out! Click to play again...", width / 2, height / 2 - 30);
  }
  
  // Display score and best score
  textAlign(LEFT);
  text("Score: " + score, 30, height - 30);
  if (best_score > 0) {
     text("Best: " + best_score, 30, height - 10);
  }
  
  // Draw the ball (yellow) and the paddle (white)
  fill(230, 230, 0);
  ellipse(ball_x, ball_y, ball_size, ball_size);
  fill(255);
  rect(paddle_x, paddle_y, paddle_w, paddle_h);
}

void mousePressed() {
  new_game = false;
}
