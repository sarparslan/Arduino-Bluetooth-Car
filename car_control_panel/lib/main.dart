import 'package:car_control_panel/bluetoothDeviceScreen.dart';
import 'package:car_control_panel/controlScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BluetoothDeviceScreen(),
    );
  }
}
