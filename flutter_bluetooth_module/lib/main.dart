import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Data Visualization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<BluetoothDevice> _devices = [];
  late BluetoothConnection _connection;
  String _receivedData = '';

  @override
  void initState() {
    super.initState();
    _getPairedDevices();
  }

  Future<void> _getPairedDevices() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      _devices = devices;
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      setState(() {
        _connection = connection;
      });
      _startListening();
    } catch (error) {
      print('Error connecting to device: $error');
    }
  }

  void _startListening() {
    _connection.input!.listen((Uint8List data) {
      setState(() {
        _receivedData = String.fromCharCodes(data);
        print("receivedData $_receivedData");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Data Visualization'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Paired Devices'),
            onTap: _getPairedDevices,
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              BluetoothDevice device = _devices[index];
              return ListTile(
                title: Text(device.name ?? ""),
                subtitle: Text(device.address),
                onTap: () => _connectToDevice(device),
              );
            }, ,
          ),
          const Divider(),
          ListTile(
            title: const Text('Received Data:'),
            subtitle: Text(_receivedData),
          ),
        ],
      ),
    );
  }
}
