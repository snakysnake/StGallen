import 'dart:async';

import 'package:safetygo/examples/debugoptionsexample.dart';
import 'package:safetygo/examples/direction_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safetygo/notification.dart';

class ExampleCard extends StatefulWidget {
  ExampleCard({Key? key, required this.example}) : super(key: key);
  final Example example;

  @override
  _ExampleCardState createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard> {
  String buttonText = '';
  String descriptionText = '';
  late Timer _timer;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    buttonText = widget.example.name;
    descriptionText = widget.example.description;
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
          buttonText = 'Message Sent! Wait ($_countdown) Seconds.';
          descriptionText = 'Rescue team is on the way.';
        });
      } else {
        _timer.cancel();
        setState(() {
          buttonText = 'I am in emergency!';
          descriptionText = 'Request a rescue.';
          _countdown = 10;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: buttonText == 'I am in emergency!'
          ? Colors.orange
          : buttonText.startsWith('Message Sent')
              ? Colors.green
              : null,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (buttonText == 'I am in emergency!') {
            setState(() {
              buttonText = 'Message Sent! Wait ($_countdown) Seconds.';
              descriptionText = 'Rescue team is on the way.';
            });
            startCountdown();
            // Code to send the alert message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Message sent!'),
              ),
            );
          } else {
            widget.example.onTap();
          }
        },
        child: ListTile(
          title: Text(buttonText),
          subtitle: Text(descriptionText),
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
        () => NotificationManager.sendNotification(
            "Its an emergency!", "Evacuate the Building.", context),
      ),
      Example(
        'I am in emergency!',
        'Request a rescue.',
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
