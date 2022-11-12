import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_watch_blue_lamb/slider_controller.dart';
import 'package:flutter_watch_blue_lamb/switch_list_tile_controller.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        debugPrint("setstate1");

        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          debugPrint("setstate2");
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
      print("1111111111");
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var high = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    SwitchController switchController = Get.put(SwitchController());
    SliderController sliderController = Get.put(SliderController());

    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: (isConnecting
            ? Text('Connecting chat to ' + widget.server.name + '...')
            : isConnected
                ? Text('Live chat with ' + widget.server.name)
                : Text('Chat log with ' + widget.server.name)),
        actions: [connectedIcon()],
      ),
      body: ListView(
        children: [
          Obx(() {
            return SwitchListTile(
                //lamp 1 controller
                secondary: switchController.switchIsOpen1
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.nightlight_round),
                title:
                    switchController.switchIsOpen1 ? Text("ON") : Text("OFF"),
                value: switchController.switchIsOpen1,
                onChanged: (onChanged) {
                  switchController.switchIsOpen1 = onChanged;
                  if (onChanged) {
                    print("a");
                    _sendMessage("g");
                  } else {
                    _sendMessage("h");
                    print("b");
                  }
                });
          }),
          Obx(() {
            return SwitchListTile(
                //lamp 2 controller
                secondary: switchController.switchIsOpen2
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.nightlight_round),
                title:
                    switchController.switchIsOpen2 ? Text("ON") : Text("OFF"),
                value: switchController.switchIsOpen2,
                onChanged: (onChanged) {
                  switchController.switchIsOpen2 = onChanged;
                  if (onChanged) {
                    _sendMessage("a");
                  } else {
                    _sendMessage("b");
                  }
                });
          }),
          Obx(() {
            return SwitchListTile(
                //lamp 3 controller
                secondary: switchController.switchIsOpen3
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.nightlight_round),
                title:
                    switchController.switchIsOpen3 ? Text("ON") : Text("OFF"),
                value: switchController.switchIsOpen3,
                onChanged: (onChanged) {
                  switchController.switchIsOpen3 = onChanged;
                  if (onChanged) {
                    _sendMessage("c");
                  } else {
                    _sendMessage("d");
                  }
                });
          }),
          Obx(() {
            return SwitchListTile(
                // lamp 4 controller
                secondary: switchController.switchIsOpen4
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.nightlight_round),
                title:
                    switchController.switchIsOpen4 ? Text("ON") : Text("OFF"),
                value: switchController.switchIsOpen4,
                onChanged: (onChanged) {
                  switchController.switchIsOpen4 = onChanged;
                  if (onChanged) {
                    _sendMessage("e");
                  } else {
                    _sendMessage("f");
                  }
                });
          }),
          Obx(() {
            return SwitchListTile(

                //all lamp controller
                secondary: switchController.switchIsOpen5
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.nightlight_round),
                title:
                    switchController.switchIsOpen5 ? Text("ON") : Text("OFF"),
                value: switchController.switchIsOpen5,
                onChanged: (onChanged) {
                  switchController.switchIsOpen5 = onChanged;
                  if (onChanged) {
                    String message = "8";
                    _sendMessage(message);
                    print(message);
                  } else {
                    String message = "9";

                    _sendMessage(message);
                    print(message);
                  }
                });
          }),
          Obx(() {
            return slider();
          })
        ],
      ),
    );
  }

  Widget slider() {
    SliderController controller = Get.find();
    return Slider(
      value: controller.value,
      min: 0,
      max: 100,
      divisions: 5,
      label: controller.value.round().toString(),
      onChanged: (double value) {
        controller.value = value;
        sendMessageSlider(value);
      },
    );
  }

  void sendMessageSlider(double value) {
    if (value == 0) {
      _sendMessage("2");
    } else if (value == 20) {
      _sendMessage("3");
    } else if (value == 40) {
      _sendMessage("4");
    } else if (value == 60) {
      _sendMessage("5");
    } else if (value == 80) {
      _sendMessage("6");
    } else if (value == 100) {
      _sendMessage("7");
    }
  }

  Widget connectedIcon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
      child: CircleAvatar(
        child: isConnected == false
            ? const Text("!")
            : const Icon(
                Icons.check,
                color: Colors.white,
              ),
        backgroundColor: isConnected == false ? Colors.red : Colors.green,
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      messages.add(
        _Message(
          1,
          backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString.substring(0, index),
        ),
      );
      _messageBuffer = dataString.substring(index);
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        debugPrint("hata***************************************");
      }
    }
  }
}
