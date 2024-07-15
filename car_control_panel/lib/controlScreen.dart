import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    // Ekranı yatay moda kilitle
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    _discoverServices();
  }

  @override
  void dispose() {
    // Ekranı varsayılan duruma döndür
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

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
            return; // İlk uygun karakteristiği bulduktan sonra dur
          }
        }
      }
      print("No writable characteristic found");
    } catch (e) {
      print("Error discovering services: $e");
    }
  }

  void sendDataToDevice(int data) async {
    if (_characteristic != null) {
      try {
        // Karakteristik özelliklerini yazdırma
        print('Characteristic properties: ${_characteristic!.properties}');
        // Veriyi byte array olarak gönderme
        List<int> value = [data];
        await _characteristic!
            .write(value, withoutResponse: false); // withoutResponse: false
        print("Data sent: $data");
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
              padding: EdgeInsets.only(left: 600, top: 120),
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
                  print('Joystick moved: $details, Command: $command');
                  sendDataToDevice(command);
                },
              ),
            ),
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
