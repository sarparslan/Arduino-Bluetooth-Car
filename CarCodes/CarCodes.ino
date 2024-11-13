
// L298N Connection
const int motorA1 = 5;   // IN3 input of L298N
const int motorA2 = 6;   // IN1 input of L298N
const int motorB1 = 10;  // IN2 input of L298N
const int motorB2 = 9;   // IN4 input of L298N

const int trigPin = 3;
const int echoPin = 4;
long duration, distance;


int state = -1;               // Variable for signal from Bluetooth device
int vSpeed = 255;        // Default speed, can be between 0-255

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

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
  state = Serial.read();
  Serial.print("Received state: ");
  Serial.println(state);
}

  // setSpeed(state);
  setHcSR04();

  if(distance < 15){
    Serial.print("distance : ");
    Serial.println(distance);
    goReverse();
    delay(1000);
    stopMotors();
  }

  else{
      executeCommand(state);
  }
 }
void setHcSR04(){
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);  
  duration = pulseIn(echoPin, HIGH);
  distance = duration/58.2;
}


void executeCommand(int state) {
  switch (state) {
    case 0: goForward(); break;
    case 1: goForwardLeft(); break;
    case 2: goForwardRight(); break;
    case 3: goReverse(); break;
    case 4: goReverseLeft(); break;
    case 5: goReverseRight(); break;
    case 6: turnLeft(); break;
    case 7: turnRight(); break;
    case 8: stopMotors(); break;
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
