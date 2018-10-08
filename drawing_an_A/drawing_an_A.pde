void setup() {
  size(400, 400);
  stroke(255);
  strokeWeight(10);
}
void draw() {
  background(192, 0, 255); // clears the screen
  line(100, 350, 200, 50);
  line(300, 350, 200, 50);
  line(150, 200, mouseX, mouseY);
  fill(255, 0, 0);
  ellipse(mouseX, mouseY, 40, 40);
  fill(0, 255, 0);
  rect(mouseX, mouseY, 50, 50);
}
