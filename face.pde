// Put this at the top of your sketch
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

// 4 more variables
Capture video;
OpenCV opencv;
int resolutionCamX = 320;
int resolutionCamY = 240;

void setup() {
  // OK, we already know this 'size' function
  size(800, 600);
  
  // Video capture configuration
  video = new Capture(this, resolutionCamX, resolutionCamY);
  opencv = new OpenCV(this, resolutionCamX, resolutionCamY);
  // Try also : CASCADE_MOUTH, CASCADE_EYE, CASCADE_FRONTALFACE...
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
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

void draw() {
  // Sends the video to openCV for processing
  opencv.loadImage(video);

  // Displays the captured image in the main window
  image(video, 0, 0, width, height);

  Rectangle face = detectFace();
  
  if (face != null) {
    println(face.x + "," + face.y);
    // Draws the green frame
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    rect(face.x, face.y, face.width, face.height);
  }
}

// Boilerplate "glue" code ; called for each captured image
// To be copied into your sketch
void captureEvent(Capture c) {
  c.read();
}

