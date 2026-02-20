// =============================
// TRICK REACTION GAME
// Must react only when GREEN + SOUND together
// =============================

const int trigPin = 2;
const int echoPin = 3;

const int redPin = 9;
const int greenPin = 10;
const int bluePin = 11;

const int buzzerPin = 6;

const int triggerDistance = 10;

unsigned long startTime;
unsigned long reactionTime;

bool realSignal = false;

void setup() {
  Serial.begin(9600);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  pinMode(buzzerPin, OUTPUT);

  randomSeed(analogRead(A0));
}
void loop() {

  // ======================
  // WAIT FOR HAND (BLUE)
  // ======================

  setColor(0, 0, 255);   // BLUE waiting

  while (readDistance() > triggerDistance || readDistance() == 0) {}

  delay(500);

  int fakeCount = 0;
  int maxFakes = random(2, 6);   // 🔥 between 2 and 5 tricks
  realSignal = false;

  while (!realSignal) {

    delay(random(1500, 3000));

    // ======================
    // IF WE REACHED MAX FAKES → FORCE REAL
    // ======================
    if (fakeCount >= maxFakes) {

      realSignal = true;

      Serial.println("GO");

      setColor(0, 255, 0);   // GREEN
      digitalWrite(buzzerPin, HIGH);

      startTime = millis();

      while (true) {
        if (handRemoved()) {
          reactionTime = millis() - startTime;
          break;
        }
      }

      digitalWrite(buzzerPin, LOW);

      Serial.print("RESULT:");
      Serial.println(reactionTime);

      delay(3000);
      return;
    }

    // ======================
    // RANDOM FAKE TYPE
    // ======================
    int signalType = random(1, 3);  // 1 or 2

    // FAKE 1 → SOUND ONLY
    if (signalType == 1) {

      digitalWrite(buzzerPin, HIGH);
      delay(200);
      digitalWrite(buzzerPin, LOW);

      delay(500);

      if (handRemoved()) {
        falseStart();
        return;
      }

      fakeCount++;
    }

    // FAKE 2 → GREEN ONLY
    else {

      setColor(0, 255, 0);
      delay(300);
      setColor(0, 0, 255);   // back to BLUE

      delay(500);

      if (handRemoved()) {
        falseStart();
        return;
      }

      fakeCount++;
    }
  }
}


// ======================
// FUNCTIONS
// ======================

bool handRemoved() {
  int distance = readDistance();
  return (distance > triggerDistance || distance == 0);
}

int readDistance() {

  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000);
  if (duration == 0) return 0;

  return duration * 0.034 / 2;
}

void setColor(int r, int g, int b) {
  analogWrite(redPin, r);
  analogWrite(greenPin, g);
  analogWrite(bluePin, b);
}

void falseStart() {

  Serial.println("FAIL");

  setColor(255, 0, 0);

  for (int i = 0; i < 3; i++) {
    digitalWrite(buzzerPin, HIGH);
    delay(150);
    digitalWrite(buzzerPin, LOW);
    delay(150);
  }

  delay(2000);
}
