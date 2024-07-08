const int motorA1 = 11;  // Input IN3 of L298N
const int motorA2 = 13;  // Input IN1 of L298N
const int motorB1 = 12;  // Input IN2 of L298N
const int motorB2 = 10;  // Input IN4 of L298N
int state;                // Variable for signal from Bluetooth device
int vSpeed = 255;         // Standard Speed, can take a value between 0-255

void setup() {
  pinMode(motorA1, OUTPUT);
  pinMode(motorA2, OUTPUT);
  pinMode(motorB1, OUTPUT);
  pinMode(motorB2, OUTPUT);    
  Serial.begin(9600);
}

void loop() {
  // Check for Bluetooth data
  if (Serial.available() > 0) {
    state = Serial.read();
    executeCommand(state);
  }
}

// Functions are designed for each command with a movement duration limited to 1 second
void executeCommand(char command) {
  if (command == 'F') {
    goForward();
  } else if (command == 'G') {
    goForwardLeft();
  } else if (command == 'I') {
    goForwardRight();
  } else if (command == 'B') {
    goBackward();
  } else if (command == 'H') {
    goBackwardLeft();
  } else if (command == 'J') {
    goBackwardRight();
  } else if (command == 'L') {
    goLeft();
  } else if (command == 'R') {
    goRight();
  } else if (command == 'S') {
    stopCar();
  }
}

void goForward() {
  analogWrite(motorA1, vSpeed);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, vSpeed);
  analogWrite(motorB2, 0);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void goForwardLeft() {
  analogWrite(motorA1, vSpeed);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, 100);
  analogWrite(motorB2, 0);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void goForwardRight() {
  analogWrite(motorA1, 100);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, vSpeed);
  analogWrite(motorB2, 0);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void goBackward() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, vSpeed);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, vSpeed);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void goBackwardLeft() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, 100);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, vSpeed);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void goBackwardRight() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, vSpeed);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, 100);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void goLeft() {
  analogWrite(motorA1, vSpeed);
  analogWrite(motorA2, 150);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, 0);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void goRight() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, vSpeed);
  analogWrite(motorB2, 150);
  delay(1000);  // Movement duration of 1 second
  stopCar();
}

void stopCar() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, 0);
}
