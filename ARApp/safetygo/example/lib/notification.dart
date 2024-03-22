import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:safetygo/main.dart';

class NotificationManager {
  static void sendNotification(
      String title, String body, BuildContext context) {
    // Send notification
    _showNotification(title, body);

    final updateManager = Provider.of<UpdateManager>(context, listen: false);
    updateManager.addUpdate(Update(title: title, description: body));
  }

  static Future<void> _showNotification(String title, String body) async {
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
}

class Update {
  final String title;
  final String description;

  Update({required this.title, required this.description});
}

class UpdatesList extends StatelessWidget {
  final List<Update> updates;

  UpdatesList({required this.updates});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: updates.length,
      itemBuilder: (context, index) {
        final update = updates[index];
        return ListTile(
          title: Text(
            update.title,
            style: TextStyle(
              color: Colors.red, // Change the title color here
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(update.description),
        );
      },
    );
  }
}

class UpdateManager extends ChangeNotifier {
  List<Update> _updates = [
    Update(
      title: 'Attention: Fire Alert in Room 5!',
      description:
          'A Fire Alert has been activated in Room 5! Immediate action is required. Please evacuate the area calmly and swiftly. Contact emergency services if necessary. Safety is our top priority."',
    ),
    Update(
      title: 'Attention: Fire Alerts in Room 2!',
      description:
          'Fire detected in Room 2! Evacuate immediately and calmly. Contact emergency services if needed. Safety comes first.',
    ),
    // Add more updates as needed
  ];

  List<Update> get updates => _updates;

  void addUpdate(Update update) {
    _updates.insert(0, update);
    notifyListeners(); // Notify listeners that updates have changed
  }
}
