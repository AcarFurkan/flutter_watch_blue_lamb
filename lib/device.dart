import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;

  BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.devices),
              Text(device.name ?? "Unknown device"),
            ],
          ),
          Text(device.address.toString()),
          OutlinedButton(
            child: Text('Connect'),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
