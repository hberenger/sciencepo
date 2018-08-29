// A mettre en haut
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

// 4 variables de plus
Capture video;
OpenCV opencv;
int resolutionCamX = 320;
int resolutionCamY = 240;

void setup() {
  // OK ça on connait
  size(800, 600);
  
  // Configuration de la capture
  video = new Capture(this, resolutionCamX, 240);
  opencv = new OpenCV(this, resolutionCamX, 240);
  // Essayer aussi : CASCADE_MOUTH, CASCADE_EYE , CASCADE_FRONTALFACE...
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
}

Rectangle detectFace() {
  // récupère le "bouding frame" (cadre) entourant les objets détectés
  Rectangle[] faces = opencv.detect();
  if ( faces.length > 0) {
    // Ajuste le premier cadre à la résolution du sketch
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
  // Envoie la vidéo à openCV pour traitement
  opencv.loadImage(video);

  // Affiche l'image capturée à l'écran
  image(video, 0, 0, width, height);

  Rectangle face = detectFace();
  
  if (face != null) {
    println(face.x + "," + face.y);
    // Dessine le cadre
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    rect(face.x, face.y, face.width, face.height);
  }
}

// Glue appelée à chaque image capturéz ; à copier dans le sketch
void captureEvent(Capture c) {
  c.read();
}
