//SoundGlitch

import processing.sound.*;

FFT circle;
FFT wave;
Sound sound;
SoundFile music;
int band1 = 512;
int band2 = 1024;

float waveLow, waveHigh;
float[] waveForm = new float[band2];
float[] waveR = new float[band2];
float[] thetaR = new float[band2];
float[] waveG = new float[band2];
float[] thetaG = new float[band2];
float[] waveB = new float[band2];
float[] thetaB = new float[band2];
float[] circleForm = new float[band1];
float[] deg = new float[band1];
float x, y;
float circleX, circleY;
float rX = random(10000);
float rY = random(10000);

void setup() {
  size(1920, 1080);
  background(0);
  noStroke();
  blendMode(SCREEN);
  frameRate(30);
  
  sound = new Sound(this);
  circle = new FFT(this, band1);
  wave = new FFT(this, band2);
  music = new SoundFile(this, "test.mp3");
  music.play();
  circle.input(music);
  wave.input(music);
  
  for (int i = 0; i < band2; i += width/band2) {
    thetaR[i] = i;
    thetaG[i] = i*1.3;
    thetaB[i] = i*0.75;
  }
}

void draw() {
  background(0);
  sound.volume(0.05);
  
  //WAVE FFT ANALYZE 
  wave.analyze(waveForm);
  for (int i = 0; i < band2; i++) {
    waveForm[i] = sqrt(waveForm[i])*sqrt(0.00075*(i+1));
  }
  
  //WAVE RED
  fill(255, 0, 0);
  beginShape();
  vertex(-100, height);
  vertex(-100, height/2);
  waveLow = random(height*0.45,height*0.55);
  waveHigh = random(height*0.65, height*0.75);
  for (int i = 0; i < band2; i += width/band2*6) {
    waveR[i] = map(sin(radians(thetaR[i])), -1, 1, waveLow, waveHigh);
    curveVertex(i * width/band2, waveR[i]);
    curveVertex(i * width/band2 + (waveForm[i]*height*1.6), waveR[i] + (waveForm[i]*height*1.6));
    thetaR[i] += 8;
  }
  vertex(width+100, height/2);
  vertex(width+100, height);
  endShape(CLOSE);
  
  //WAVE GREEN
  fill(0, 255, 0);
  beginShape();
  vertex(-100, height);
  vertex(-100, height/2);
  waveLow = random(height*0.45,height*0.55);
  waveHigh = random(height*0.65, height*0.75);
  for (int i = 0; i < band2; i += width/band2*6) {
    waveG[i] = map(sin(radians(thetaG[i])), -1, 1, waveLow, waveHigh);
    curveVertex(i * width/band2, waveG[i]);
    curveVertex(i * width/band2 + (waveForm[i]*height*1.6), waveG[i] + (waveForm[i]*height*1.6));
    thetaG[i] += 10;
  }
  vertex(width+100, height/2);
  vertex(width+100, height);
  endShape(CLOSE);
  
  //WAVE BLUE
  fill(0, 0, 255);
  beginShape();
  vertex(-100, height);
  vertex(-100, height/2);
  waveLow = random(height*0.45,height*0.55);
  waveHigh = random(height*0.65, height*0.75);
  for (int i = 0; i < band2; i += width/band2*6) {
    waveB[i] = map(sin(radians(thetaB[i])), -1, 1, waveLow, waveHigh);
    curveVertex(i * width/band2, waveB[i]);
    curveVertex(i * width/band2 + (waveForm[i]*height*1.6), waveB[i] + (waveForm[i]*height*1.6));
    thetaB[i] += 6;
  }
  vertex(width+100, height/2);
  vertex(width+100, height);
  endShape(CLOSE);
  
  //CIRCLE FFT ANALYZE 
  circle.analyze(circleForm);
  for (int i = 0; i < band1; i++) {
    circleForm[i] = sqrt(circleForm[i])*sqrt(0.00075*(i+1));
    deg[i] = map(i, 0, 512, 0, 360);
  }
  
  //CIRCLE
  pushMatrix();
  circleX = map(noise(rX), 0, 1, width*0.475, width*0.525);
  circleY = map(noise(rY), 0, 1, height*0.275, height*0.325);
  //translate(width/2, height*0.3);
  translate(circleX, circleY);
  fill(255);
  beginShape();
  for (int i = 0; i < band1; i++) {
    x = (cos(radians(deg[i]+180))*300) + (circleForm[i]*height*1.4);
    y = (sin(radians(deg[i]+180))*300) + (circleForm[i]*height*1.4);
    curveVertex(x, y);
  }
  endShape(CLOSE);
  rX += 0.1;
  rY += 0.1;
  popMatrix();
}








//elastic_band(x)

float movePointX, movePointY;
float leftX, leftY;
float rightX, rightY;
float leftPointX, leftPointY;
float rightPointX, rightPointY;
float direction = 1;
float fX = 0;
float fY = 0;
float theta;
boolean move = false;
boolean over = false;

void setup() {
  size(800, 800);
  strokeWeight(4);
  
  leftPointX = width * 0.1;
  leftPointY = height / 2;
  rightPointX = width * 0.9;
  rightPointY = height / 2;
  
  leftX = leftPointX;
  leftY = leftPointY;
  rightX = rightPointX;
  rightY = rightPointY;
  
  movePointX = width / 2;
  movePointY = height / 2;
}

void draw() {
  background(255);
  
  updateBand();
  drawBand();
  
  if (fX != 0 && fY != 0) {
    println(fX, fY, sin(radians(theta)));
  }
}

void drawBand() {
  noFill();
  stroke(0);
  beginShape();
  vertex(leftPointX, leftPointY);
  bezierVertex(leftPointX, leftPointY, leftX, leftY, movePointX, movePointY);
  bezierVertex(rightX, rightY, rightPointX, rightPointY, rightPointX, rightPointY);
  endShape();
  
  fill(255, 30, 30);
  noStroke();
  circle(movePointX, movePointY, 40);
  fill(0);
  circle(leftPointX, leftPointY, 10);
  circle(rightPointX, rightPointY, 10);
}

void updateBand() {
  if (!move) {
    if (movePointX != width/2) {
      theta = 0;
    } else {
      theta = 90;
    }
    
    if (sin(radians(theta)) == 0 || sin(radians(theta)) == 1) {
      if (direction == 1) {
        direction = -1;
      } else {
        direction = 1;
      }
      fX *= 0.8;
      fY *= 0.8;
    }
    
    movePointX = map(sin(radians(theta)), 0, 1, (width/2) + fX, (width/2) - fX);
    movePointY = map(sin(radians(theta)), 0, 1, (height/2) + fY, (height/2) - fY);
    
    theta ++;
  }

  if (fX < 0.01) {
    fX = 0;
  }
  
  if (fY < 0.01) {
    fY = 0;
  }
  
  if (dist(mouseX, mouseY, movePointX, movePointY) < 40) {
    over = true;
  } else {
    over = false;
  }

  if (move) {
    movePointX = mouseX;
    movePointY = mouseY;
    movePointX = constrain(movePointX, 0, width);
    movePointY = constrain(movePointY, 0, height);
  }
}

void mousePressed() {
  if (over) {
    move = true;
  }
}

void mouseReleased() {
  move = false;
  
  if (movePointX < width/2) {
    fX = (width/2) - movePointX;
  } else {
    fX = movePointX - (width/2);
  }
  
  if (movePointY < height/2) {
    fY = (height/2) - movePointY;
  } else {
    fY = movePointY - (height/2);
  }
}







//mesh

float prevX;
float prevY;
float newX;
float newY;

int num = 40;
int x[]= new int[num];
int y[]= new int[num];
int repel = 24;

float d;

void setup() {
  size(1000, 1000);

  for (int i = 1; i < num; i++) {
    x[i] = i * 20 + (width - (num * 20)) / 2;
    y[i] = i * 20 + (height - (num * 20)) / 2;
  }
}

void draw() {
  background(255);
  fill(0);
  stroke(0);

  for (int i = 1; i < x.length; i++) {
    prevX = -1;
    for (int j = 1; j < y.length; j++) {
      d = dist(mouseX, mouseY, x[i], y[j]);
      if (d == 0) {
        d = 0.001;
      }
      newX = x[i] - (repel / d) * (mouseX - x[i]);
      newY = y[j] - (repel / d) * (mouseY - y[j]);
      circle(newX, newY, 10);
      if (prevX != -1) {
        line(prevX, prevY, newX, newY);
      }
      prevX = newX;
      prevY = newY;
    }
  }
  
  for (int j = 1; j < y.length; j++) {
    prevX = -1;
    for (int i = 1; i < x.length; i++) {
      d=dist(mouseX, mouseY, x[i], y[j]);
      if (d == 0) {
        d = 0.001;
      }
      newX = x[i] - (repel / d) *(mouseX - x[i]);
      newY = y[j] - (repel / d) *(mouseY - y[j]);
      if (prevX != -1) {
        line(prevX, prevY, newX, newY);
      }
      prevX = newX;
      prevY = newY;
    }
  }
}







//mobile

float radius = 240;
int num = 24;
int max = 144;
Mobile[] mobile = new Mobile[max];
float deg = 0;
float[] thetaY = new float[max];
float[] thetaRS = new float[max];
float[] thetaS = new float[max];

void setup() {
  size(1000, 1000, P3D);
  smooth(4);
  
  for (int i = 0; i < max; i++) {
    thetaY[i] = random(360);
    thetaRS[i] = random(0.4, 2);
    thetaS[i] = random(10, 40);
  }
}

void draw() {
  background(0);
  lights();
  camera(500, 600, 1200, 500, 550, 0, 0, 1, 0);
  
  if (mousePressed && mouseX >= 0 && mouseX <= width && mouseY > 900) {
    radius = map(mouseX, 0, width, 120, 480);
    num = int(map(mouseX, 0, width, 4, max));
  }
  
  //Ring
  pushMatrix();
  translate(500, 0, 0);
  rotateX(radians(90));
  stroke(150);
  noFill();
  circle(0, 0, radius * 2);
  popMatrix();
  
  //Mobile
  pushMatrix();
  translate(500, 0, 0);
  rotateY(radians(deg));
  
  for (int i = 0; i < num; i++) {
    mobile[i] = new Mobile(i * (360/float(num)), radius, num);
    mobile[i].item(thetaY[i], thetaRS[i], thetaS[i]);
    thetaY[i] ++;
    thetaRS[i] ++;
  }
  popMatrix();
  
  deg += 0.5;
}







//3d_planet

int planets = 8;
float moveX;
float[] thetaX = new float[planets];
float moveY;
float[] thetaY = new float[planets];
float moveZ;
float[] thetaZ = new float[planets];
float[] speed = new float[planets];

float red;
float thetaR = 0;
float green;
float thetaG = 120;
float blue;
float thetaB = 240;

void setup() { 
  size(1920, 1080, P3D);
  noStroke();
  smooth(4);
  planetSet(1, 0, 6);
  planetSet(2, 90, 2.5);
  planetSet(3, 45, 1.5);
}

void draw() {
  background(0);
  directionalLight(width/2, height*2, 800, 0, 0, -1);
  
  camera(width/2, height*1.25, width*2, width/2, height/2, 0, 0, -1, 0);
  
  pushMatrix();
  translate(width/2, height/2, 0);
  fill(255);
  sphere(150);
  popMatrix();
  
  planet(1, 20, 400, 250);
  planet(2, 40, 600, -100);
  planet(3, 35, 900, 100);
  
  for (int i = 0; i < planets; i++) {
    thetaX[i] += speed[i];
    thetaY[i] += speed[i];
    thetaZ[i] += speed[i];
  }
  
  thetaR += 3;
  thetaG += 3;
  thetaB += 3;
}

void planetSet(int num, float deg, float spd) {
  thetaX[num] = deg;
  thetaY[num] = deg;
  thetaZ[num] = deg+90;
  speed[num] = spd;
}

void planet(int num, float size, float radius, float tilt) {
  moveX = map(sin(radians(thetaX[num])), -1, 1, radius, -radius);
  moveY = map(sin(radians(thetaY[num])), -1, 1, tilt, -tilt);
  moveZ = map(sin(radians(thetaZ[num])), -1, 1, -radius, radius);
  
  red = map(sin(radians(thetaR)), -1, 1, 0, 255);
  green = map(sin(radians(thetaG)), -1, 1, 0, 255);
  blue = map(sin(radians(thetaB)), -1, 1, 0, 255);
  
  pushMatrix();
  translate((width/2)+moveX, (height/2)+moveY, moveZ);
  fill(red, green, blue);
  sphere(size);
  popMatrix();
}







//3d_land

int w = 1200;
int h = 1200;
int row, col;
int num = 20;

float fly = 0;

float[][] land;

void setup() {
  size(600, 600, P3D);
  row = w / num;
  col = h / num;
  land = new float[col][row];
  
}

void draw() {
  
  fly -= 0.05;
  
  float yoff = fly;
  for (int y = 0; y < row; y++) {
    float xoff = 0;
    for (int x = 0; x < col; x++) {
      land[x][y] = map(noise(xoff, yoff), 0, 1, -200, 200);
      xoff += 0.4;
    }
    yoff += 0.4;
  }
  
  background(0);
  stroke(255);
  fill(75);
  
  translate(width/2, height/2+400);
  rotateX(PI/4);
  translate(-w, -h);
  for (int y = 0; y < row-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < col; x++) {
      vertex(x*col, y*row, land[x][y]);
      vertex(x*col, (y+1)*row, land[x][y+1]);
    }
    endShape();
  }
}







//shape_maker

int num = 3;
Point[] p = new Point[num];
Point[] p1 = new Point[num];
Point[] p2 = new Point[num];

float rX;
float rY;
int rL;
int rLp;

void setup() {
  size(1000, 1000);
  strokeWeight(2);
  textSize(12);
  textAlign(CENTER, CENTER);
  
  //Default Shape
  p[0] = new Point(500, 250);
  p1[0] = new Point(550, 250);
  p2[0] = new Point(450, 250);
  p[1] = new Point(250, 750);
  p1[1] = new Point(220, 720);
  p2[1] = new Point(280, 780);
  p[2] = new Point(750, 750);
  p1[2] = new Point(720, 780);
  p2[2] = new Point(780, 720);
}

void draw() {
  background(0);
  
  //Button
  fill(255, 50);
  stroke(255);
  square(960, 0, 40);
  square(960, 40, 40);
  fill(255);
  text("Add", 980, 20);
  text("Reset", 980, 60);
  
  for (int i = 0; i < num; i++) {
    p[i].dragEvent(0);
    p1[i].dragEvent(1);
    p2[i].dragEvent(1);
  }
  
  //Shape by Point
  beginShape();
  stroke(255);
  noFill();
  vertex(p[0].x(), p[0].y());
  for (int i = 1; i < num; i++) {
    bezierVertex(p2[i-1].x(), p2[i-1].y(), p1[i].x(), p1[i].y(), p[i].x(), p[i].y());
  }
  bezierVertex(p2[num-1].x(), p2[num-1].y(), p1[0].x(), p1[0].y(), p[0].x(), p[0].y());
  endShape(CLOSE);
  
  //Point
  for (int i = 0; i < num; i++) {
    stroke(255, 255, 60);
    line(p[i].x(), p[i].y(), p1[i].x(), p1[i].y());
    line(p[i].x(), p[i].y(), p2[i].x(), p2[i].y());
    noStroke();
    fill(255, 255, 60);
    circle(p1[i].x(), p1[i].y(), 20);
    circle(p2[i].x(), p2[i].y(), 20);
    
    noStroke();
    fill(255, 30, 30);
    circle(p[i].x(), p[i].y(), 40);
  }
}

void mouseClicked() {
  if (mouseX > 960 && mouseX < 1000 && mouseY > 0 && mouseY < 40) {
    num += 1;
    p = (Point[]) expand(p, num);
    p1 = (Point[]) expand(p1, num);
    p2 = (Point[]) expand(p2, num);
    
    rL = int(random(num-1));
    if (rL == 0) {
      rLp = num-2;
    } else {
      rLp = rL-1;
    }
    
    rX = bezierPoint(p[rLp].x(), p2[rLp].x(), p1[rL].x(), p[rL].x(), random(0.3, 0.7));
    rY = bezierPoint(p[rLp].y(), p2[rLp].y(), p1[rL].y(), p[rL].y(), random(0.3, 0.7));
    
    p[num-1] = new Point(rX, rY);
    p1[num-1] = new Point(rX-60, rY);
    p2[num-1] = new Point(rX+60, rY);
  }
  else if (mouseX > 960 && mouseX < 1000 && mouseY > 40 && mouseY < 80) {
    num = 3;
    p[0] = new Point(500, 250);
    p1[0] = new Point(550, 250);
    p2[0] = new Point(450, 250);
    p[1] = new Point(250, 750);
    p1[1] = new Point(220, 720);
    p2[1] = new Point(280, 780);
    p[2] = new Point(750, 750);
    p1[2] = new Point(720, 780);
    p2[2] = new Point(780, 720);
  }
}

class Point {
  float pX;
  float pY;
  float radius;
  
  Point(float _x, float _y) {
    pX = _x;
    pY = _y;
  }
  
  float x() {
    return pX;
  }
  float y() {
    return pY;
  }
  
  void dragEvent(int mode) {
    if (mode == 0) {
      radius = 50;
    } else if (mode == 1) {
      radius = 30;
    }
    
    if (dist(mouseX, mouseY, pX, pY) < radius && mousePressed) {
      pX = mouseX;
      pY = mouseY;
    }
  }
}
