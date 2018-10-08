var speedx = 4.3
var speedy = 6
var x = 0
var y = 0

function setup() {
   createCanvas(windowWidth,windowHeight);
   x = windowWidth / 2
   y = windowHeight / 2
}

function draw() {
  background(255, 255, 0)
  fill(0, 0, 255)
  ellipse(x, y, 40, 40)
  x = x + speedx
  y = y + speedy
  if (x < 0 || x > windowWidth) {
      speedx = -speedx;
  }
  if (y < 0 || y > windowHeight) {
      speedy = -speedy;
  }
}
