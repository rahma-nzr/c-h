import 'package:flutter/material.dart';
import '../../core/constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, String>> newestNotifications = [
    {'text': 'Farouk has accepted your request.', 'time': '9h'}
  ];

  List<Map<String, String>> lastDaysNotifications = [
    {'text': 'Your request has been rejected by Hassan Wael.', 'time': '1 day'},
    {'text': 'Farouk has accepted your request.', 'time': '2 days'},
    {'text': 'Farouk has accepted your request.', 'time': '10 days'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(color: Color.fromARGB(255, 4, 26, 134))),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Newest', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...newestNotifications.map((notif) => dismissibleItem(notif, newestNotifications)),
            const SizedBox(height: 20),
            const Text('Last days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...lastDaysNotifications.map((notif) => dismissibleItem(notif, lastDaysNotifications)),
          ],
        ),
      ),
      
    );
  }

  Widget dismissibleItem(Map<String, String> notif, List<Map<String, String>> sourceList) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart, // فقط السحب لليسار
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          sourceList.remove(notif);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification deleted')),
        );
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 4, 26, 134),
          child: Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(notif['text']!),
        subtitle: Text(notif['time']!),
      ),
    );
  }
}
