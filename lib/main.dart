import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        home: CupertinoNativeApp(),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NativeApp(),
      );
    }
  }
}

// iOS용 네이티브 통신 위젯
class CupertinoNativeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CupertinoNative();
}

class _CupertinoNative extends State<CupertinoNativeApp> {
  String _deviceInfo = 'Unknown info';
  static const platform = MethodChannel('com.flutter.dev/info');
  static const platform3 = MethodChannel('com.flutter.dev/dialog');

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('iOS Native Example'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _deviceInfo,
              style: TextStyle(fontSize: 30),
            ),
            CupertinoButton(
              onPressed: _showDialog,
              child: Text('Open Native Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    try {
      await platform3.invokeMethod('showDialog');
    } on PlatformException catch (e) {
      print('Failed to show dialog: ${e.message}');
    }
  }

  Future<void> _getDeviceInfo() async {
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      if (result != null && result.isNotEmpty) {
        setState(() {
          _deviceInfo = 'Device info: $result';
        });
      } else {
        setState(() {
          _deviceInfo = 'No device info received';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _deviceInfo = "Failed to get device info: '${e.message}'.";
      });
    }
  }
}

// Android용 네이티브 통신 위젯
class NativeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NativeApp();
}

class _NativeApp extends State<NativeApp> {
  String _deviceInfo = 'Unknown info';
  static const platform = MethodChannel('com.flutter.dev/info');

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Native 통신 예제'),
      ),
      body: Container(
        child: Center(
          child: Text(
            _deviceInfo,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getDeviceInfo,
        child: Icon(Icons.get_app),
      ),
    );
  }

  Future<void> _getDeviceInfo() async {
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      if (result != null && result.isNotEmpty) {
        setState(() {
          _deviceInfo = 'Device info: $result';
        });
      } else {
        setState(() {
          _deviceInfo = 'No device info received';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _deviceInfo = "Failed to get device info: '${e.message}'.";
      });
    }
  }
}