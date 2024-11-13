# Arduino Bluetooth Car Control

This project is a Bluetooth-controlled car system powered by an Arduino and controlled via a Flutter application. It includes code for both the Arduino and the Flutter app, enabling Bluetooth communication to send commands that control the car's movement. The car uses an ultrasonic sensor for obstacle detection, and an L298N motor driver to drive the motors.


---

## Demo

### Photos

![Car Setup](https://github.com/user-attachments/assets/3e568944-eaff-4ad4-b125-6d83ea64bdf9)

*Figure 1: Complete Car Setup with Arduino and L298N Motor Driver*



---

## Circuit Diagram
Below is the circuit schema of the car control system, including the Arduino, L298N motor driver, and HC-SR04 ultrasonic sensor.
> **Note**: The pin numbers in the diagram may differ from the code. The diagram is intended to illustrate the logical connections, not the exact pin configuration.

![Circuit Schema](https://github.com/user-attachments/assets/5867d210-6d6b-4c37-af08-bb4a094c8752)

*Figure 3: Circuit Diagram*

---



## Project Components

1. **Arduino** - Controls the car's movements based on received Bluetooth commands.
2. **L298N Motor Driver** - Powers and controls the car's motors.
3. **Ultrasonic Sensor (HC-SR04)** - Measures distance to obstacles and prevents collisions.
4. **Flutter Application** - Provides a graphical interface for controlling the car via Bluetooth.

## Hardware Connections

### L298N Motor Driver
- **MotorA1 (IN3)** - Arduino Pin 5
- **MotorA2 (IN1)** - Arduino Pin 6
- **MotorB1 (IN2)** - Arduino Pin 10
- **MotorB2 (IN4)** - Arduino Pin 9

### Ultrasonic Sensor
- **Trig Pin** - Arduino Pin 3
- **Echo Pin** - Arduino Pin 4

## Arduino Code

The Arduino code performs the following tasks:
- Reads distance from the ultrasonic sensor to detect nearby obstacles.
- Listens for Bluetooth commands to control motor movements.
- Executes movement functions based on commands (e.g., forward, reverse, turn left/right).

### Key Arduino Functions
- **`setSpeed(int state)`**: Sets the motor speed based on the received Bluetooth command.
- **`setHcSR04()`**: Measures distance using the ultrasonic sensor.
- **`executeCommand(int state)`**: Executes a movement command (e.g., forward, reverse).
- **Movement Functions**: Includes functions like `goForward()`, `goReverse()`, `turnLeft()`, and `stopMotors()` to control motor directions.

## Flutter Application

The Flutter app scans for Bluetooth devices, connects to the car, and provides an interface to control movement using a joystick. 

### Key Flutter Components
- **BluetoothDeviceScreen**: Lists available Bluetooth devices and initiates a connection.
- **ControlScreen**: Provides a joystick control interface to send movement commands to the car.

### Main Flutter Functions
- **`startScan()`**: Scans for nearby Bluetooth devices.
- **`connectToDevice(BluetoothDevice device)`**: Connects to the selected Bluetooth device.
- **`sendDataToDevice(int data)`**: Sends movement data to the connected Arduino via Bluetooth.

### Dependencies
- **flutter_blue_plus**: Manages Bluetooth device scanning and connection.
- **flutter_joystick**: Provides a joystick widget for control.

## Getting Started

### Hardware Setup
1. Connect the Arduino, L298N motor driver, and HC-SR04 ultrasonic sensor as per the pin configuration above.
2. Upload the Arduino code to your Arduino board.

### Flutter App Setup
1. Clone this repository and open it in your Flutter development environment.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
## Usage
1. Open the Flutter app and start a Bluetooth scan.
2. Select your Arduino Bluetooth device from the list to connect.
3. Use the joystick control on the ControlScreen to send movement commands to the car.
4. The car will move according to joystick commands, and the ultrasonic sensor will detect and avoid obstacles.
### Troubleshooting
- Bluetooth Connection: Ensure that your phone's Bluetooth is enabled and that the Arduino is powered on.
- Distance Sensing: Verify the ultrasonic sensor is connected correctly and that there are no obstacles within 15cm.
