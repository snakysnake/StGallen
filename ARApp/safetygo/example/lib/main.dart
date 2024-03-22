import 'package:safetygo/app_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safetygo/notification.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UpdateManager(),
      child: MyApp(),
    ),
  );
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  static const String _title = 'SafetyApp';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ArFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final updateManager = Provider.of<UpdateManager>(context);
    final _updates = updateManager.updates;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
              _title,
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontWeight: FontWeight.bold, // Make text bold
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF7D48EA)),
        body: Column(children: [
          // Text('Running on: $_platformVersion\n'),
          Expanded(
            child: ExampleList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Important Updates:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: UpdatesList(
              updates: _updates,
            ),
          ),
        ]),
      ),
    );
  }
}
