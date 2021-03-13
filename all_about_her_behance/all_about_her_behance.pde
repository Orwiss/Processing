int numX = 19;
int numY = 19;

String[][] t = new String[numX][numY];

void setup() {
  size(1000, 1000);
  stroke(255, 30, 30);
  strokeWeight(4);
  textSize(24);
  textAlign(CENTER, CENTER);
  
  for (int y = 0; y < numY; y++) {
    for (int x = 0; x < numX; x++) {
      t[x][y] = str(char(int(random(65, 90))));
    }
  } 
}

void draw() {
  background(255);
  noFill();
  circle(mouseX, mouseY, 36);
  
  fill(0);
  for (int y = 0; y < numY; y++) {
    for (int x = 0; x < numX; x++) {
      int posX = 50 * (x+1);
      int posY = 50 * (y+1);
      
      pushMatrix();
      translate(posX, posY);
      rotate(atan2(mouseY-posY, mouseX-posX)+radians(dist(mouseX, mouseY, posX, posY)/90));
      text(t[x][y], 0, 0);
      popMatrix();
    }
  }
}
