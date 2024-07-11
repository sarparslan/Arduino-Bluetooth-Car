// L298N Connection
const int motorA1 = 5;   // IN3 input of L298N
const int motorA2 = 6;   // IN1 input of L298N
const int motorB1 = 10;  // IN2 input of L298N
const int motorB2 = 9;   // IN4 input of L298N

int state;               // Variable for signal from Bluetooth device
int vSpeed = 235;        // Default speed, can be between 0-255

void setup() {
  // Define pins as outputs
  pinMode(motorA1, OUTPUT);
  pinMode(motorA2, OUTPUT);
  pinMode(motorB1, OUTPUT);
  pinMode(motorB2, OUTPUT);

  // Start serial communication at 9600 baud
  Serial.begin(9600);
}

void loop() {
  // Check if there is data available from Bluetooth
  if (Serial.available() > 0) {
    state = Serial.read();   // Read incoming data
  }

  // Set speed levels based on received data
  /*
  switch (state) {
    case '0':
      vSpeed = 0;
      break;
    case '1':
      vSpeed = 100;
      break;
    case '2':
      vSpeed = 180;
      break;
    case '3':
      vSpeed = 200;
      break;
    case '4':
      vSpeed = 255;
      break;
  }
  */

  // Movement controls based on received command
  switch (state) {
    case 8:
      goForward();
      break;
    case 1:
      goForwardLeft();
      break;
    case 2:
      goForwardRight();
      break;
    case 3:
      goReverse();
      break;
    case 4:
      goReverseLeft();
      break;
    case 5:
      goReverseRight();
      break;
    case 6:
      turnLeft();
      break;
    case 7:
      turnRight();
      break;
    case 0:
      stopMotors();
      break;
  }
}

// Function definitions for each movement direction

void goForward() {
  analogWrite(motorA1, vSpeed);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, vSpeed);
  analogWrite(motorB2, 0);
}

void goForwardLeft() {
  analogWrite(motorA1, vSpeed);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, 100);
  analogWrite(motorB2, 0);
}

void goForwardRight() {
  analogWrite(motorA1, 100);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, vSpeed);
  analogWrite(motorB2, 0);
}

void goReverse() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, vSpeed);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, vSpeed);
}

void goReverseLeft() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, 100);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, vSpeed);
}

void goReverseRight() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, vSpeed);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, 100);
}

void turnLeft() {
  analogWrite(motorA1, vSpeed);
  analogWrite(motorA2, 150);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, 0);
}

void turnRight() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, vSpeed);
  analogWrite(motorB2, 150);
}

void stopMotors() {
  analogWrite(motorA1, 0);
  analogWrite(motorA2, 0);
  analogWrite(motorB1, 0);
  analogWrite(motorB2, 0);
}
