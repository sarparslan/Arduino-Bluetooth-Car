import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class ControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  ControlScreen({required this.device});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  BluetoothCharacteristic? _characteristic;
  int lastCommand = -1; // Last sent command

  @override
  void initState() {
    super.initState();
    _discoverServices();
  }

  // Discover Bluetooth services and find a writable characteristic
  void _discoverServices() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      for (BluetoothService service in services) {
        print('Discovered service: ${service.uuid}');
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          print('Discovered characteristic: ${characteristic.uuid}');
          if (characteristic.properties.write) {
            setState(() {
              _characteristic = characteristic;
            });
            print('Writable characteristic found: ${characteristic.uuid}');
            return; // Stop after finding the first writable characteristic
          }
        }
      }
      print("No writable characteristic found");
    } catch (e) {
      print("Error discovering services: $e");
    }
  }

  // Send data to the connected Bluetooth device
  void sendDataToDevice(int data) async {
    if (_characteristic != null) {
      try {
        List<int> startByte = [252]; // Start byte
        List<int> dataByte = [data & 0xFF]; // Data byte
        List<int> endByte = [250]; // End byte

        // Send start byte
        await _characteristic!.write(startByte, withoutResponse: false);
        await Future.delayed(Duration(milliseconds: 50));
        // Send data byte
        await _characteristic!.write(dataByte, withoutResponse: false);
        await Future.delayed(Duration(milliseconds: 50));

        // Send end byte
        await _characteristic!.write(endByte, withoutResponse: false);
        await Future.delayed(Duration(milliseconds: 50));

        print("Data sent: Start: $startByte, Data: $dataByte, End: $endByte");
      } catch (e) {
        print("Error sending data: $e");
      }
    } else {
      print("Characteristic is null or does not support write.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Device: ${widget.device.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                top: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Joystick(
                base: JoystickBase(
                  decoration: JoystickBaseDecoration(
                    middleCircleColor: Colors.red.shade400,
                    drawOuterCircle: false,
                    drawInnerCircle: false,
                    boxShadowColor: Colors.red.shade100,
                  ),
                ),
                stick: JoystickStick(
                  decoration: JoystickStickDecoration(
                    color: Colors.red,
                  ),
                ),
                listener: (details) {
                  int command = _calculateCommand(details);
                  if (command != lastCommand) {
                    _discoverServices();
                    sendDataToDevice(command);
                    lastCommand = command;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Calculate the command based on the joystick's angle
  int _calculateCommand(StickDragDetails details) {
    double angle = (atan2(details.y, details.x) * 180 / pi + 360) % 360;

    if (angle < 22.5 || angle >= 337.5) {
      return 0; // Forward (12 o'clock direction)
    } else if (angle >= 22.5 && angle < 67.5) {
      return 5; // Reverse Right (between 12 - 3 o'clock)
    } else if (angle >= 67.5 && angle < 112.5) {
      return 3; // Reverse (3 o'clock direction)
    } else if (angle >= 112.5 && angle < 157.5) {
      return 4; // Reverse Left (between 3 - 6 o'clock)
    } else if (angle >= 157.5 && angle < 202.5) {
      return 6; // Turn Left (6 o'clock direction)
    } else if (angle >= 202.5 && angle < 247.5) {
      return 1; // Forward Left (between 6 - 9 o'clock)
    } else if (angle >= 247.5 && angle < 292.5) {
      return 0; // Forward (9 o'clock direction)
    } else {
      return -1; // Default case for remaining angles
    }
  }
}
