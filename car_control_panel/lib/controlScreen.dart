import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  ControlScreen({required this.device});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  BluetoothCharacteristic? writableCharacteristic;

  @override
  void initState() {
    super.initState();
    discoverServices();
  }

  void discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          setState(() {
            writableCharacteristic = characteristic;
          });
          return; // Stop looking once a writable characteristic is found
        }
      }
    }

    if (writableCharacteristic == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("No writable characteristic found."),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  void sendData(String data) async {
    if (writableCharacteristic == null) {
      print("No writable characteristic set.");
      return;
    }

    try {
      await writableCharacteristic!.write(data.codeUnits);
      print("Data sent successfully.");
    } catch (e) {
      print("Error sending data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Control Device')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => sendData("0"),
              child: Text('Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}
