import 'dart:async';

import 'package:safetygo/examples/debugoptionsexample.dart';
import 'package:safetygo/examples/direction_arrow.dart';
import 'package:safetygo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ExampleCard extends StatefulWidget {
  ExampleCard({Key? key, required this.example}) : super(key: key);
  final Example example;

  @override
  _ExampleCardState createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard> {
  String buttonText = '';
  late Timer _timer;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    buttonText = widget.example.name;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
          buttonText = 'Message Sent ($_countdown)';
        });
      } else {
        _timer.cancel();
        setState(() {
          buttonText = 'I am in emergency!';
          _countdown = 10;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: buttonText == 'I am in emergency!'
          ? Colors.red
          : buttonText.startsWith('Message Sent')
              ? Colors.green
              : null,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (buttonText == 'I am in emergency!') {
            setState(() {
              buttonText = 'Message Sent ($_countdown)';
            });
            startCountdown();
            // Code to send the alert message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Message sent'),
              ),
            );
          } else {
            widget.example.onTap();
          }
        },
        child: ListTile(
          title: Text(buttonText),
          subtitle: Text(widget.example.description),
        ),
      ),
    );
  }
}

class ExampleList extends StatelessWidget {
  ExampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examples = [
      Example(
        'Direction Arrow',
        'Direction guide',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DirectionArrowWidget()),
        ),
      ),
      // Example(
      //   'Debug Options',
      //   'Visualize feature points, planes and world coordinate system',
      //   () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => DebugOptionsWidget()),
      //   ),
      // ),
      Example(
        'Send Notification',
        'Simulate receiving notification',
        () => _showNotification("Its an emergency!", "Evacuate the Building."),
      ),
      Example(
        'I am in emergency!',
        'Sends an alert',
        () {
          // Code to send alerts
        },
      ),
    ];
    return ListView(
      children:
          examples.map((example) => ExampleCard(example: example)).toList(),
    );
  }
}

class Example {
  const Example(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}

Future<void> _showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'channel_id', // Replace with your channel ID
          'alert_notifications', // Replace with your channel name
          channelDescription: 'Alert notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          showWhen: true,
          sound: RawResourceAndroidNotificationSound('alert'));
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}
