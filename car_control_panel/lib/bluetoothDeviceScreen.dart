import 'package:car_control_panel/controlScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceScreen extends StatefulWidget {
  @override
  _BluetoothDeviceScreenState createState() => _BluetoothDeviceScreenState();
}

class _BluetoothDeviceScreenState extends State<BluetoothDeviceScreen> {
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    setState(() {
      devicesList.clear();
    });
    print("Starting scan for devices...");
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        print("Found device: ${r.device.name} (${r.device.id})");
        if (!devicesList.contains(r.device)) {
          setState(() {
            devicesList.add(r.device);
          });
        }
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      print("Trying to connect to device: ${device.name}");
      await device.connect();
      print("Connected to device: ${device.name}");
      print("isConected -> " + device.isConnected.toString());
      print("isDisconected -> " + device.isDisconnected.toString());
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ControlScreen(device: device),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      print("Error connecting to device: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Bluetooth Devices'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              startScan();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: Colors.blue[50],
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              title: Text(
                devicesList[index].name.isNotEmpty
                    ? devicesList[index].name
                    : 'Unknown Device',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue[900]),
              ),
              subtitle: Text(
                devicesList[index].id.toString(),
                style: TextStyle(color: Colors.blue[700]),
              ),
              trailing: ElevatedButton(
                onPressed: () => connectToDevice(devicesList[index]),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
