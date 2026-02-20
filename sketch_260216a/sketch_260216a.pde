import processing.serial.*;

Serial myPort;

// ======================
// GAME VARIABLES
// ======================

String gameState = "WAIT";
int failStartTime = 0;
int reactionTime = 0;
int level = 1;

// Animation
float globalTime = 0;
float gridOffset = 0;
float pulseVal = 0;

ArrayList<Particle> particles = new ArrayList<Particle>();

// Cyberpunk Colors
color bgDark    = #050510;
color neonCyan  = #00F3FF;
color neonPink  = #FF0055;
color neonLime  = #CCFF00;
color neonAlert = #FF3333;

PFont fontHeader;
PFont fontSub;

// ======================
void setup() {

  fullScreen(P2D);
  smooth(8);

  fontHeader = createFont("Arial Bold", 100);
  fontSub    = createFont("Arial", 40);

  textAlign(CENTER, CENTER);

  // -------- SERIAL --------
  printArray(Serial.list()); // check port list
  String portName = "COM7";  // <<< CHANGE THIS
  myPort = new Serial(this, portName, 9600);
}

// ======================
void draw() {

  background(bgDark);
  globalTime += 0.02;

  drawMovingGrid();
  drawVignette();

  updateParticles();

  switch(gameState) {
  case "WAIT":
    drawWaiting();
    break;
  case "RESULT":
    drawResult();
    break;
  case "FAIL":
    drawFail();
    break;
  }

  drawLevelDisplay();
  drawScanlines();
}

// ======================
// VISUAL EFFECTS
// ======================

void drawMovingGrid() {

  strokeWeight(2);
  stroke(neonPink, 50);

  gridOffset = (millis() / 5.0) % 100;

  for (int x = -width; x < width*2; x += 100) {
    line(x, height, width/2 + (x-width/2)*0.2, height/2 - 100);
  }

  for (int y = height/2; y < height; y += 40) {

    float yPos = y + (gridOffset * (y/(float)height));
    if (yPos > height) yPos -= (height/2);

    float alpha = map(yPos, height/2, height, 0, 100);
    stroke(neonCyan, alpha);
    line(0, yPos, width, yPos);
  }

  noStroke();
  fill(neonPink, 50);
  rect(0, height/2 - 102, width, 4);
}

void drawVignette() {

  noFill();
  strokeWeight(150);
  stroke(0, 150);
  rect(0, 0, width, height);
}

void drawScanlines() {

  stroke(255, 15);
  strokeWeight(1);
  for (int i = 0; i < height; i += 4) {
    line(0, i, width, i);
  }
}

void drawNeonText(String txt, float x, float y, float size, color c) {

  textFont(fontHeader);
  textSize(size);

  fill(c, 50);
  for (int i = 0; i < 3; i++) {
    text(txt, x + random(-1, 1), y + random(-1, 1));
  }

  fill(255);
  text(txt, x, y);
}

// ======================
// GAME STATES
// ======================

void drawWaiting() {

  pulseVal = 150 + sin(globalTime*3) * 100;

  noFill();
  stroke(neonCyan, pulseVal);
  strokeWeight(5);
  ellipse(width/2, height/2, 200, 200);

  textSize(40);
  fill(neonCyan);
  text("SYSTEM READY", width/2, height/2 - 150);

  textSize(60);
  fill(255);
  text("PLACE HAND", width/2, height/2);
}

void drawGo() {

  background(neonLime);

  fill(0);
  rect(random(width), random(height), random(100), 10);

  fill(0);
  textSize(150);
  text("GO!", width/2 + random(-5, 5), height/2 + random(-5, 5));
}

void drawResult() {

  color rankColor = getRankColor();

  drawNeonText(reactionTime + " ms",
               width/2,
               height/2 - 80,
               120,
               rankColor);

  textSize(50);
  fill(rankColor);
  text("- " + getRank() + " -", width/2, height/2 + 60);

  drawFuturisticBar();
}

void drawFail() {

  background(neonAlert);

  fill(0);
  textSize(140);
  text("FAIL", width/2 + random(-10, 10), height/2);

  textSize(40);
  text("TOO EARLY", width/2, height/2 + 100);

  if (millis() - failStartTime > 2000) {
    gameState = "WAIT";
  }
}

void drawLevelDisplay() {

  fill(0, 200);
  noStroke();
  rect(width-220, 20, 200, 80, 10);

  fill(neonCyan);
  textSize(30);
  textAlign(RIGHT, CENTER);
  text("LEVEL " + level, width-40, 60);

  stroke(neonCyan);
  line(width-210, 80, width-30, 80);

  textAlign(CENTER, CENTER);
}

void drawFuturisticBar() {

  float barWidth = 600;
  float barHeight = 30;
  float x = width/2 - barWidth/2;
  float y = height - 150;

  noFill();
  stroke(100);
  strokeWeight(2);
  rect(x, y, barWidth, barHeight);

  float percent = map(reactionTime, 200, 800, 1, 0);
  percent = constrain(percent, 0, 1);

  noStroke();
  fill(getRankColor());
  rect(x+4, y+4, (barWidth-8) * percent, barHeight-8);
}

// ======================
// PARTICLES
// ======================

void createParticles() {
  for (int i = 0; i < 50; i++) {
    particles.add(new Particle(width/2, height/2, getRankColor()));
  }
}

void updateParticles() {

  blendMode(ADD);

  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.dead) particles.remove(i);
  }

  blendMode(BLEND);
}

class Particle {

  float x, y, vx, vy, life = 255;
  float size;
  color c;
  boolean dead = false;

  Particle(float _x, float _y, color _c) {

    x = _x;
    y = _y;
    c = _c;

    float angle = random(TWO_PI);
    float speed = random(2, 15);

    vx = cos(angle) * speed;
    vy = sin(angle) * speed;

    size = random(5, 15);
  }

  void update() {

    x += vx;
    y += vy;

    vy += 0.2;

    vx *= 0.95;
    vy *= 0.95;

    life -= 5;

    if (life <= 0) dead = true;
  }

  void display() {

    if (!dead) {
      noStroke();
      fill(c, life);
      ellipse(x, y, size, size);
    }
  }
}

// ======================
// RANK SYSTEM
// ======================

color getRankColor() {

  if (reactionTime < 300) return neonLime;
  if (reactionTime < 500) return neonCyan;
  if (reactionTime < 700) return color(255, 150, 0);
  return neonAlert;
}

String getRank() {

  if (reactionTime < 300) return "LEGENDARY";
  if (reactionTime < 500) return "GOOD";
  if (reactionTime < 700) return "AVERAGE";
  return "TOO SLOW";
}

// ======================
// SERIAL COMMUNICATION
// ======================

void serialEvent(Serial p) {

  String data = trim(p.readStringUntil('\n'));
  if (data == null) return;

  println(data);

  if (data.equals("GO")) {
    gameState = "GO";
  }

  if (data.equals("FAIL")) {
    gameState = "FAIL";
    failStartTime = millis();
  }

  if (data.startsWith("RESULT:")) {
    reactionTime = int(split(data, ":")[1]);
    gameState = "RESULT";
    createParticles();
  }
}
