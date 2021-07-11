void setup() {
  size(800, 800);
}

void draw() {
  background(0);
  for(int i = 0; i < 10; i++) {
    shine();
  }  
}

void shine() {
  float r = random(230, 255);
  float g = random(70);
  float l = random(200);
  float l2 = l + random(10, 40);
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(radians(random(360)));
  strokeWeight(random(8));
  stroke(r, g, 0);
  line(0, 0, 0, l);
  line(0, l2, 0, l2+6);
  popMatrix();
}
