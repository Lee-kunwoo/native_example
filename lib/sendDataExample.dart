import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendDataExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SendDataExample();
}

class _SendDataExample extends State<SendDataExample> {
  static const platform = const MethodChannel('com.flutter.dev/encryto');

  TextEditingController controller = TextEditingController(text: '안녕하세요  flutter');
  String _changeText = 'Nothing';
  String _reChangedText = 'Nothing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Data Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                _changeText,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _decodeText();
                },
                child: Text('디코딩 하기'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                _reChangedText,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sendData(controller.text);
        },
        child: Text('변환'),
      ),
    );
  }

  Future<void> _sendData(String text) async {
    try {
      final String result = await platform.invokeMethod('getEncryto', text);
      if (result != null && result.isNotEmpty) {
        setState(() {
          _changeText = result;
        });
      } else {
        setState(() {
          _changeText = 'Encoding failed';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _changeText = "Failed to encode: '${e.message}'";
      });
    }
  }

  Future<void> _decodeText() async {
    try {
      final String result = await platform.invokeMethod("getDecode", _changeText);
      if (result != null && result.isNotEmpty) {
       setState(() {
         _reChangedText = result;
        });
     } else {
       setState(() {
        _reChangedText = 'Decoding failed';
      });
    }
  } on PlatformException catch (e) {
     setState(() {
      _reChangedText = "Failed to decode: '${e.message}'";
     });
    }
  }
}
