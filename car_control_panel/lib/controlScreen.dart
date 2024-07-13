import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class ControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ControlScreen({required this.device, super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToDevice();
  }

  void _connectToDevice() async {
    // Attempt to connect to the device
    await widget.device.connect().catchError((e) {
      print('Failed to connect: $e');
    });

    // Listen to connection state updates
    widget.device.state.listen((state) {
      setState(() {
        _isConnected = (state == BluetoothDeviceState.connected);
      });
    });

    // Discover services after connection
    if (_isConnected) {
      _discoverServices();
    }
  }

  void _discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          setState(() {
            _characteristic = characteristic;
          });
        }
      }
    }
  }

  void _sendCommand(int command) {
    if (_characteristic != null && _isConnected) {
      var commandBytes = Uint8List(1);
      commandBytes[0] = command;
      _characteristic!.write(commandBytes).then((_) {
        print("Command sent successfully");
      }).catchError((error) {
        print("Failed to send command: $error");
      });
    } else {
      print("Characteristic not found or device is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Bluetooth Car Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  _sendCommand(0);
                },
                child: Text("Pick me ")),
            SizedBox(
              height: 20,
            ),
            Joystick(
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
                _sendCommand(command);
              },
            ),
            SizedBox(height: 20),
            Text(_connectedDevice != null
                ? 'Connected to ${_connectedDevice!.name}'
                : 'Scanning for devices...'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  int _calculateCommand(StickDragDetails details) {
    double angle = (atan2(details.y, details.x) * 180 / pi + 360) % 360;

    if (angle < 22.5 || angle >= 337.5) {
      return 0; // Saat 12 yönü
    } else if (angle >= 22.5 && angle < 67.5) {
      return 2; // Saat 12 - 15 yönü arası
    } else if (angle >= 67.5 && angle < 112.5) {
      return 7; // Saat 15 yönü
    } else if (angle >= 112.5 && angle < 157.5) {
      return 5; // Saat 15 - 18 yönü arası
    } else if (angle >= 157.5 && angle < 202.5) {
      return 3; // Saat 18 yönü
    } else if (angle >= 202.5 && angle < 247.5) {
      return 4; // Saat 18 - 21 yönü arası
    } else if (angle >= 247.5 && angle < 292.5) {
      return 6; // Saat 21 yönü
    } else {
      return 0; // Geri kalan durumlar için varsayılan
    }
  }
}
