// Put this at the top of your sketch
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

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
// 4 more variables
Capture video;
OpenCV opencv;
int resolutionCamX = 320;
int resolutionCamY = 240;

void setup() {
  size(400, 400);
  setupInitialPositions();
  speed_x = 1.8; // or : random(-4, 4);
  speed_y = 2.5; // or : random(-4, 4);
  noStroke(); // do not draw outlines of shapes
  // Video capture configuration
  video = new Capture(this, resolutionCamX, resolutionCamY);
  opencv = new OpenCV(this, resolutionCamX, resolutionCamY);
  // Try also : CASCADE_MOUTH, CASCADE_EYE, CASCADE_FRONTALFACE...
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
}

// This function resets the ball and paddle to their initial positions
void setupInitialPositions() {
  ball_x = width / 2;
  ball_y = height / 2;
  paddle_y = height / 2 - paddle_h / 2;
}

Rectangle detectFace() {
  // Returns the "bouding frame" surrounding the detected objects
  Rectangle[] faces = opencv.detect();
  if ( faces.length > 0) {
    // Adjust the first frame to the sketch resolution
    int xRect = faces[0].x * width / resolutionCamX;
    int yRect = faces[0].y * height / resolutionCamY;
    int wRect = faces[0].width * width / resolutionCamX;
    int hRect = faces[0].height * height / resolutionCamY;
    return new Rectangle(xRect, yRect, wRect, hRect);
  } else {
    return null;
  }
}

// Boilerplate "glue" code ; called for each captured image
// To be copied into your sketch
void captureEvent(Capture c) {
  c.read();
}

void drawFaceFrame(Rectangle face) {
    // Draws a green frame around the head
    pushStyle();
    noFill();
    stroke(128, 255, 128);
    strokeWeight(2);
    rect(face.x, face.y, face.width, face.height);
    popStyle();
}

void draw() {
  // Sends the video to openCV for processing
  opencv.loadImage(video);
  
  if (new_game) {
    // do nothing
    return;
  }
  
  // Displays the captured image in the main window
  image(video, 0, 0, width, height);

  Rectangle face = detectFace();
  
  if (face != null) {
    drawFaceFrame(face);
    
    // here we map the face position to the paddle position
    // First we compute linear mapping coefficients, such that:
    // - when the top of the face frame is at some fixed, arbitrary distance "M" from
    //   the top of the screen, the top of the paddle is aligned with the top of the screen.
    // - reciprocally, when the bottom of the face frame is at "M" pixels from the
    //   bottom of the screen, then the bottom of the paddle is at the bottom of the screen.
    final float M = 30;
    final float alpha = (height - paddle_h)/(height - 2*M - face.height);
    final float beta = - alpha * (M + face.height/2);
    // Then we apply the linear mapping coefficients to the face ordinate, to get
    // the ordinate of the top of the paddle.
    final float expected_paddle_y = alpha * (face.y + face.height/2) + beta;  
    // Last, we apply a simple low-pass filter to smooth the paddle movements :
    paddle_y = paddle_y * 0.8 + expected_paddle_y * 0.2;  
  }
  
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
