import 'package:car_control_panel/controlScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothDeviceScreen extends StatefulWidget {
  const BluetoothDeviceScreen({super.key});

  @override
  State<BluetoothDeviceScreen> createState() => _BluetoothDeviceScreenState();
}

class _BluetoothDeviceScreenState extends State<BluetoothDeviceScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    setState(() {
      isScanning = true;
      scanResults.clear();
    });

    flutterBlue.startScan(timeout: Duration(seconds: 4)).then((_) {
      setState(() {
        isScanning = false;
      });
    });

    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
        print("Scan results updated: ${results.length} devices found");
      });
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ControlScreen(device: device),
        ),
      );
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Connection Error"),
            content: Text("Failed to connect to the device: $e"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog'u kapat
                },
              ),
            ],
          );
        },
      );
      print("Connection failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bluetooth Device'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _startScan,
          ),
        ],
      ),
      body: isScanning
          ? Center(child: CircularProgressIndicator())
          : scanResults.isEmpty
              ? Center(child: Text('No devices found.'))
              : ListView.builder(
                  itemCount: scanResults.length,
                  itemBuilder: (context, index) {
                    ScanResult result = scanResults[index];
                    return Card(
                      color: Colors.blue.shade50,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.bluetooth, color: Colors.blue),
                        title: Text(
                          result.device.name.isNotEmpty
                              ? result.device.name
                              : result.device.id.toString(),
                          style: TextStyle(color: Colors.blue.shade800),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // Button color
                            onPrimary: Colors.white, // Text color
                          ),
                          onPressed: () => _connectToDevice(result.device),
                          child: Text('Connect'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
